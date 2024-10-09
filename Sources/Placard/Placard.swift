//
//  Placard
//
//  Created by Christopher Charles Cavnor on 9/6/24.
//


import OSLog
import UIKit
import SwiftUI


public typealias TapAction = () -> Void

/**
 Placard is a small and easy to use package for presenting an animated message bar in Swift.

 Message views can be displayed at the top, bottom, or center of the screen and can be offset from both the screen edges and the vertical placements using UIEdgeInsets.

 There are interactive show, tap, and dismiss gestures - an array of animated themes to choose from (or no animation if you want).

 Placard allows you to choose default message themes for things such as priority-based messages, but also offers customization via either parameters, a configuration object, or you can use your own SwiftUI view and let Placard control its animations and appearance. The Placard can be configured to display for any period of time (by default, it displays forever - or until a user taps on it). Further, all Placard messages can given an action to perform on user tap (but not if Placard dismisses itself via a timeout).
 */
public final class Placard: UIView {

    let logger = Logger(subsystem: Logger.subsystem, category: "Placard")

    /// time to wait after user interaction (tap) before hiding view
    public static let DEFAULT_DELAY: TimeInterval = .zero
    /// amount of time to show the Placard view before auto-hiding
    public static let DEFAULT_SHOW_DURATION: TimeInterval = .infinity
    /// amount of time for the show and hide animations to execute (note that if no animation is used, the view appears and disappears immediately)
    public static let DEFAULT_ANIMATION_DURATION: TimeInterval = 1.25

    // get the top window to ensure that other views don't obscure actions
    var activeWindow: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.last
    }

    var statusBarFrameHeight: CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let height = (windowScene?.statusBarManager?.statusBarFrame.height) ?? 0
        return height
    }

    var preferredContentSize: CGSize?
    var minimumHeight: CGFloat = 0.0

    var verticalConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    private let screenDims = UIScreen.main.bounds

    var height: CGFloat {
        var _height: CGFloat? = 0.0

        let intrinsic = content?.intrinsicContentSize.height ?? minimumHeight
        let preferred = preferredContentSize?.height ?? minimumHeight

        switch getDeviceOrientation() {
        case .portrait: _height = max(intrinsic, preferred)  //1
        case .portraitUpsideDown: _height = min(intrinsic, preferred) //2
        case .landscapeLeft: _height = minimumHeight //3
        case .landscapeRight: _height = minimumHeight //4
        default: _height = min(intrinsic, preferred)
        }

        return _height ?? minimumHeight
    }

    var duration: TimeInterval = DEFAULT_SHOW_DURATION
    var hideTimer: Timer?
    var startTop: CGFloat?
    var action: TapAction?

    var content: UIView?
    var config: PlacardConfigP?

    private var title: String?
    private var statusMessage: String?

    convenience init<T: PlacardConfigP>(
        content: UIView,
        config: T,
        title: String = "",
        statusMessage: String = "",
        duration: Double,
        action: TapAction?) {
            self.init(frame: CGRect.zero)
            self.content = content
            self.config = config
            self.title = title
            self.statusMessage = statusMessage

            self.addSubview(content)

            // set minimumHeight before layout as default size
            self.minimumHeight = content.intrinsicContentSize.height

            calculateConstraints(config: config, viewDuration: duration, action: action)

            self.preferredContentSize = content.intrinsicContentSize
            updateHeightConstraint()
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        haltTimer()
        NotificationCenter.default.removeObserver(self)
    }

    @objc func applicationDidEnterBackground(_ notification: Notification) {
        haltTimer()
        removeFromSuperview()
    }

    @objc func deviceOrientationDidChange(_ notification: Notification) {
        updateHeightConstraint()
    }
    
    /// Hide the Placard view immediately (called automatically if the Placard duration expires)
    func hide() {
        scheduleHideTimer(0.0)
    }

    /// Hide the Placard view when timer expires.
    @objc private func timeForAction(_ timer: Timer) {
        // this uses the interval passed from scheduleHideTimer to control the length of the hide animation.
        if let interval = timer.userInfo as? Double {
            Placard.hide(self, interval: interval, transition: config?.hideAnimation, fadeOut: config?.fadeAnimation ?? false)
        }
    }

    /// Called at view show to schedule hide after show duration expires, as well as by
    /// hide() to schedule immediate running of close animations after user interaction.
    /// - Parameter after: how long to wait before executing the hide timer.
    func scheduleHideTimer(_ after: Double) {
        scheduleHideTimer(after, interval: Placard.DEFAULT_ANIMATION_DURATION)
    }

    /// Invalidates the hide timer and calls timeForAction to hide the Placard view.
    /// - Parameters:
    ///   - after: The number of seconds between firings of the timer.
    ///   - interval: The number of seconds for the hide animation to take.
    private func scheduleHideTimer(_ after: Double, interval: Double) {
        haltTimer()
        hideTimer = Timer.scheduledTimer(timeInterval: after,
                                         target: self,
                                         selector: #selector(self.timeForAction(_:)),
                                         userInfo: interval,
                                         repeats: false)
    }

    private func haltTimer() {
        hideTimer?.invalidate()
        hideTimer = nil
    }

    /// Recalculate the height constraint for the presenting view
    func updateHeightConstraint() {
        invalidateIntrinsicContentSize()
        heightConstraint?.constant = height

        self.layoutIfNeeded()
    }
}


extension Placard {

    /// Fires the action that might be associated with a Placard.
    /// - Parameter sender: UITapGestureRecognizer
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapAnimation = config?.tapAnimation
            let coords = sender.location(in: self)

            // empirically derived (corrects for padding)
            let tappable = CGRect(x: self.subviews[0].frame.minX,
                                  y: self.subviews[0].frame.minY + 20,
                                  width: self.content!.frame.width,
                                  height: self.content!.frame.height - 30)

            // hit test for the view (to prevent insets from creating tappable margins)
            if tappable.contains(coords) {
                UIView.animate(
                    withDuration: TimeInterval(1.2),
                    delay: TimeInterval(0.0),
                    options: [.beginFromCurrentState],
                    animations: { [weak self] in
                        switch tapAnimation {
                        case .pulseIn: self?.content?.pulseIn()
                        case .pulseOut: self?.content?.pulseOut()
                        case .zoomInWithEasing: self?.content?.zoomInWithEasing()
                        case .zoomOutWithEasing: self?.content?.zoomOutWithEasing()
                        default: break
                        }

                        self?.superview?.layoutIfNeeded()
                    },
                    completion: { _ in
                        self.action?()
                        self.hide()
                    }
                )
            }
        }
    }
}





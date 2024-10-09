//
//  Placard+Constraints.swift
//  Placard
//
//  Created by Christopher Charles Cavnor on 9/18/24.
//

import SwiftUI

extension Placard {
    /// Performs the constraint calculations for auto-layout.
    /// - Parameters:
    ///   - config: the Placard configuration file (user provided else defaults are used)
    ///   - viewDuration: how long the Placard view should show
    ///   - action: any action (of type TapAction) that the user (optionally) provides
    func calculateConstraints(
        config: PlacardConfigP,
        viewDuration: Double,
        action: TapAction?) {
            self.translatesAutoresizingMaskIntoConstraints = false
            let edgeInsets = config.insets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let placement = config.placement ?? .top

            guard let window = activeWindow else { return }
            window.addSubview(self)

            // Placard base view aligns with window
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 0),
                self.rightAnchor.constraint(equalTo: window.rightAnchor, constant: 0),
                self.topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
                self.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0),
            ])

            scheduleHideTimer(viewDuration)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.applicationDidEnterBackground(_:)),
                                                   name: UIApplication.didEnterBackgroundNotification,
                                                   object: nil)


            let placard = self.subviews[0]

            let heightConstraint = NSLayoutConstraint(item: placard,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .height,
                                                      multiplier: 1.0,
                                                      constant: height)

            placard.addConstraint(heightConstraint)
            self.heightConstraint = heightConstraint

            // offset from vertical margin
            var verticalConstraint: NSLayoutConstraint

            switch placement {
            case .top:
                verticalConstraint = NSLayoutConstraint(item: self,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: window,
                                                        attribute: .top,
                                                        multiplier: 1.0,
                                                        constant: edgeInsets.top)
            case .bottom:
                verticalConstraint = NSLayoutConstraint(item: self,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: window,
                                                        attribute: .bottom,
                                                        multiplier: 1.0,
                                                        constant: -edgeInsets.bottom)
            case .center:
                verticalConstraint = NSLayoutConstraint(item: self,
                                                        attribute: .centerYWithinMargins,
                                                        relatedBy: .equal,
                                                        toItem: window,
                                                        attribute: .centerYWithinMargins,
                                                        multiplier: 1.0,
                                                        constant: 0)
            }

            self.verticalConstraint = verticalConstraint

            self.layout(placement: placement, edgeInsets: edgeInsets)

            self.preferredContentSize = content?.intrinsicContentSize
            self.updateHeightConstraint()

            self.action = action

            // update height after setup and animate change
            guard let superview = self.superview else { return }
            superview.layoutIfNeeded()
            verticalConstraint.constant = 0.0

            // don't confuse animationDuration (fixed) with Placard duration (time before it disappears)
            let animationDuration = Placard.DEFAULT_ANIMATION_DURATION
            // this is not configurable by user - mainly used for testing
            let animationDelay = TimeInterval(0.0)

            UIView.animate(
                withDuration: animationDuration,
                delay: TimeInterval(0.0),
                options: [.beginFromCurrentState],
                animations: {
                    guard let content = self.content else { return }
                    let fade = config.fadeAnimation ?? false

                    switch config.showAnimation {
                    case .fade: content.fadeIn(delay: animationDelay, duration: animationDuration)
                    case .rollUp: content.rollUpIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .rollDown: content.rollDownIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .floatUp: content.floatUpIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .floatDown: content.floatDownIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .floatLeft: content.floatLeftIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .floatRight: content.floatRightIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .toX: content.expandFromX(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .toY: content.expandFromY(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .toPoint: content.expandFromPoint(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .spin: content.spinIn(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .spinOnX: content.spinInOnX(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    case .spinOnY: content.spinInOnY(delay: animationDelay, duration: animationDuration, fadeIn: fade)
                    default: return
                    }
                    superview.layoutIfNeeded()
                },
                completion: nil
            )
        }


    /// Animates the closing of the Placard view.
    /// - Parameters:
    ///   - placard: the Placard instance
    ///   - interval: TimeInterval to perform the animation
    ///   - transition: the TransitionAnimation type of the animation
    ///   - fadeOut: whether to fade the animation
    class func hide(_ placard: Placard, interval: TimeInterval, transition: TransitionAnimation?, fadeOut: Bool = false) {

        UIView.animate(withDuration: interval,
                       delay: TimeInterval(0.0),
                       options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut],
                       animations: { [weak placard] in

            if fadeOut { placard?.layer.opacity = 0.02 }

            switch transition {
            case .fade: placard?.content?.fadeOut()
            case .rollUp: placard?.content?.rollUpOut()
            case .rollDown: placard?.content?.rollDownOut()
            case .floatUp: placard?.content?.floatUpOut()
            case .floatDown: placard?.content?.floatDownOut()
            case .floatLeft: placard?.content?.floatLeftOut()
            case .floatRight: placard?.content?.floatRightOut()
            case .toX: placard?.content?.collapseToX()
            case .toY: placard?.content?.collapseToY()
            case .toPoint: placard?.content?.collapseToPoint()
            case .spin: placard?.content?.spinOut()
            case .spinOnX: placard?.content?.spinOutOnX()
            case .spinOnY: placard?.content?.spinOutOnY()
            default: return
            }

            placard?.superview?.layoutIfNeeded()
        }) {
            [weak placard] _ in
            if let placard = placard, let _ = placard.superview { placard.removeFromSuperview() }
        }
    }


    // close all the active views of this class
    public func hideAll() {
        guard let window = activeWindow else { return }

        for view in window.subviews {
            if let placard = view as? Placard {
                placard.hide()
            }
        }
    }
}





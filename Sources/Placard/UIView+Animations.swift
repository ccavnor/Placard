//
//  UIView+Animations.swift
//  Placard
//
//  Created by Christopher Charles Cavnor on 10/8/24.
//

import UIKit

extension UIView {
    enum TextAlignment {
        case left, right, center
    }

    // ======= show ===========
    func spinIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: -0.01, y: -0.01)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.165) { [weak self] in
                self?.transform = .identity
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func fadeIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.165) { [weak self] in
                self?.alpha = 1.0
            }
        }
    }

    func rollUpIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        let b = self.bounds
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.maxY, width: b.width, height: 0)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.165) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.maxY, width: b.width, height: -b.height)
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func rollDownIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        let b = self.bounds

        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: 0)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.165) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: b.height)
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func floatUpIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        let b = self.bounds
        let screenHeight = UIScreen.main.bounds.height

        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: screenHeight/2, width: b.width, height: screenHeight)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: b.height)
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func floatDownIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        let b = self.bounds
        let screenHeight = UIScreen.main.bounds.height

        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: -screenHeight/2, width: b.width, height: screenHeight)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: b.height)
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func floatLeftIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        let b = self.bounds
        let screenWidth = UIScreen.main.bounds.width
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.layer.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: b.height)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: b.height)
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func floatRightIn(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        let b = self.bounds
        let screenWidth = UIScreen.main.bounds.width

        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.layer.frame = CGRect(x: 0, y: 0, width: -screenWidth, height: b.height)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: b.height)
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func expandFromX(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.transform = .identity
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func expandFromY(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.transform = .identity
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func expandFromPoint(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                if fadeIn { self?.layer.opacity = 0.0 }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                self?.transform = .identity
                if fadeIn { self?.layer.opacity = 1.0 }
            }
        }
    }

    func spinInOnX(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                if fadeIn { self?.layer.opacity = 0.0 }
                self?.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                if fadeIn { self?.layer.opacity = 1.0 }
                self?.transform = .identity
            }
        }
    }

    func spinInOnY(delay: TimeInterval = 0.0, duration: TimeInterval = 0.2, fadeIn: Bool = false) {
        UIView.animateKeyframes(withDuration: duration,
                                delay: delay,
                                options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) { [weak self] in
                if fadeIn { self?.layer.opacity = 0.0 }
                self?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.165, relativeDuration: 1.5) { [weak self] in
                if fadeIn { self?.layer.opacity = 1.0 }
                self?.transform = .identity
            }
        }
    }

    // ======= hide ===========

    func fadeOut() {
        self.layer.opacity = 0.02
        self.transform = .identity
    }

    func rollUpOut() {
        let b = self.bounds
        self.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: 0)
    }

    func rollDownOut() {
        let b = self.bounds
        self.layer.frame = CGRect(x: b.minX, y: b.maxY, width: b.width, height: 0)
    }

    func floatUpOut() {
        let b = self.bounds
        let screenHeight = UIScreen.main.bounds.height
        self.layer.frame = CGRect(x: b.minX, y: b.minY, width: b.width, height: -screenHeight)
    }

    func floatDownOut(duration: TimeInterval = 0.2) {
        let b = self.bounds
        let screenHeight = UIScreen.main.bounds.height
        self.layer.frame = CGRect(x: b.minX, y: b.maxY, width: b.width, height: screenHeight)
    }

    func floatLeftOut() {
        let b = self.bounds
        let screenWidth = UIScreen.main.bounds.width
        self.layer.frame = CGRect(x: 0, y: 0, width: -screenWidth, height: b.height)
    }

    func floatRightOut() {
        let b = self.bounds
        let screenWidth = UIScreen.main.bounds.width
        self.layer.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: b.height)
    }

    func collapseToX() {
        self.transform = CGAffineTransform(scaleX: 0.01, y: 1)
    }

    func collapseToY() {
        self.transform = CGAffineTransform(scaleX: 1, y: 0.01)
    }

    func collapseToPoint() {
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }

    func spinOut() {
        self.transform = CGAffineTransform(scaleX: -0.01, y: -0.01)
    }

    func spinOutOnX() {
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.transform = .identity
    }

    func spinOutOnY() {
        self.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.transform = .identity
    }


    /*
     Tap animations
     */
    /**
     Zoom in momentarily up to offset. Uses spring animation.

     - parameter duration: animation duration
     - parameter offset: the amount to zoom in by
     */
    func pulseIn(duration: TimeInterval = 0.2, offset: CGFloat = 0.2) {
        let offsetScale = 1.0 - offset
        self.transform = CGAffineTransform(scaleX: offsetScale, y: offsetScale)
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(4.0),
                       options: [.allowUserInteraction],
                       animations: { () -> Void in
            self.transform = .identity
        })
    }

    func pulseOut(duration: TimeInterval = 0.2, offset: CGFloat = 0.2) {
        let offsetScale = 1.0 + offset
        self.transform = CGAffineTransform(scaleX: offsetScale, y: offsetScale)
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(4.0),
                       options: [.allowUserInteraction],
                       animations: { () -> Void in
            self.transform = .identity
        })
    }

    /**
     Zoom in any view with specified offset magnification.

     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 - easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        UIView.animate(withDuration: scalingDuration,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: { () -> Void in },
                       completion: { (animationCompleted: Bool) -> Void in
            UIView.animate(withDuration: easingDuration,
                           delay: 0.0,
                           options: .curveEaseIn,
                           animations: { () -> Void in self.transform = .identity })
        })
    }

    /**
     Zoom out any view with specified offset magnification.

     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        UIView.animate(withDuration: easingDuration,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: { () -> Void in },
                       completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: { () -> Void in self.transform = .identity })
        })
    }
}



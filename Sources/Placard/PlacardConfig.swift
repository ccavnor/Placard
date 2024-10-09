//
//  PlacardConfig.swift
//  Placard
//
//  Created by Christopher Charles Cavnor on 9/23/24.
//

import UIKit

/// These are the types of the animated transitions that occur on show and hide of placard.
/// Show and hide implement each with their own set of functions; for example - .fade is implemented
/// as fadeIn() for show functionality and fadeOut() for hide functionality.
public enum TransitionAnimation {
    case none, fade, rollUp, rollDown, floatUp, floatDown, floatLeft, floatRight, toX, toY, toPoint, spin, spinOnX, spinOnY
}

/// These are the animations that occur when a user taps on placard (follow by action completion and hide)
public enum TapAnimation {
    case none, pulseIn, pulseOut, zoomInWithEasing, zoomOutWithEasing
}

/// Placement in the UIScreen for the Placard view. These can be offset by using the insets
/// property (a UIEdgeInsets instance). Keep in mind the following constraints for insets:
///
/// Note that for:
/// .top - UIEdgeInsets.bottom is ignored
/// .bottom - UIEdgeInsets.top is ignored
/// .center - UIEdgeInsets.top and  UIEdgeInsets.bottom are ignored
public enum PlacardPlacement {
    case top, bottom, center
}

// The priority to be passed to a PlacardPriorityView view
public enum PlacardPriority {
    case `default`, info, success, warning, error
}


/// The protocol for Placard Configuration objects to confrom to.
public protocol PlacardConfigP {
    var backgroundColor: UIColor? { get }
    var primaryFont: UIFont? { get }
    var secondaryFont: UIFont? { get }
    var accentColor: UIColor? { get }
    var titleTextColor: UIColor? { get }
    var placement: PlacardPlacement? { get }
    var insets: UIEdgeInsets? { get }
    var showAnimation: TransitionAnimation? { get }
    var hideAnimation: TransitionAnimation? { get }
    var tapAnimation: TapAnimation? { get }
    var fadeAnimation: Bool? { get }
}


/// The configuration object for a Placard. A user can override some or all of these values.
public struct PlacardConfig: PlacardConfigP {
    private var _backgroundColor: UIColor?
    private var _accentColor: UIColor?
    private var _primaryFont: UIFont?
    private var _secondaryFont: UIFont?
    private var _textColor: UIColor?
    private var _placement: PlacardPlacement?
    private var _insets: UIEdgeInsets?
    public var _showAnimation: TransitionAnimation?
    public var _hideAnimation: TransitionAnimation?
    public var _tapAnimation: TapAnimation?
    public var _fadeAnimation: Bool?

    /// Background color (as a UIColor) for the Placard view
    public var backgroundColor: UIColor? {
        get { return _backgroundColor }
        set { _backgroundColor = newValue ?? PlacardConfigCase.default.backgroundColor }
    }

    /// Accent color (as a UIColor) for the Placard view (used for the status message foreground)
    public var accentColor: UIColor? {
        get { return _accentColor}
        set { _accentColor = newValue ?? PlacardConfigCase.default.accentColor }
    }

    /// The font for the title
    public var primaryFont: UIFont? {
        get { return _primaryFont }
        set { _primaryFont = newValue ?? PlacardConfigCase.default.primaryFont }
    }

    /// The font for the status message
    public var secondaryFont: UIFont? {
        get { return _secondaryFont }
        set { _secondaryFont = newValue ?? PlacardConfigCase.default.secondaryFont }
    }

    /// Color (as a UIColor) used for the Placard view title and systemImage foreground colors
    public var titleTextColor: UIColor? {
        get { return _textColor }
        set { _textColor = newValue ?? PlacardConfigCase.default.titleTextColor }
    }

    /// Where to position the Placard view on the device screen
    public var placement: PlacardPlacement? {
        get { return _placement }
        set { _placement = newValue ?? PlacardConfigCase.default.placement }
    }

    /// UIEdgeInsets used to offset a Placard view from its PlacardPlacement. Keep in mind that
    /// UIEdgeInsets.left and UIEdgeInsets.right act to "push" the Placard view away from the edges
    /// of the device screen (allowing the user to create a Placard that does not span the screen). Also,
    /// all values should be positive offsets - a value for UIEdgeInsets.top of 50 will push a Placard view
    /// 50 points from the top of the device (regardless of its orientation).  A value for UIEdgeInsets.bottom
    /// of 50 will push a Placard view 50 points from the bottom of the device (toward the center).
    ///
    /// Note that for:
    /// PlacardPlacement.top - UIEdgeInsets.bottom is ignored
    /// PlacardPlacement.bottom - UIEdgeInsets.top is ignored
    public var insets: UIEdgeInsets? {
        get { return _insets }
        set { _insets = newValue ?? PlacardConfigCase.default.insets }
    }

    /// The animation to be used when the Placard view appears
    public var showAnimation: TransitionAnimation? {
        get { return _showAnimation }
        set { _showAnimation = newValue ?? PlacardConfigCase.default.showAnimation }
    }

    /// The animation to be used when the Placard view disappears
    public var hideAnimation: TransitionAnimation? {
        get { return _hideAnimation }
        set { _hideAnimation = newValue ?? PlacardConfigCase.default.hideAnimation }
    }

    /// The animation to be used when the Placard view is tapped by the user
    public var tapAnimation: TapAnimation? {
        get { return _tapAnimation }
        set { _tapAnimation = newValue ?? PlacardConfigCase.default.tapAnimation }
    }

    /// When true, the show and hide animations will fade in or out, respectively
    public var fadeAnimation: Bool? {
        get { return _fadeAnimation }
        set { _fadeAnimation = newValue ?? PlacardConfigCase.default.fadeAnimation }
    }

    init(backgroundColor: UIColor? = nil,
         primaryFont: UIFont? = nil,
         secondaryFont: UIFont? = nil,
         accentColor: UIColor? = nil,
         titleTextColor: UIColor? = nil,
         placement: PlacardPlacement? = nil,
         insets: UIEdgeInsets? = nil,
         showAnimation: TransitionAnimation? = nil,
         hideAnimation: TransitionAnimation? = nil,
         tapAnimation: TapAnimation? = nil,
         fadeAnimation: Bool = false) {
        self.backgroundColor = backgroundColor
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.accentColor = accentColor
        self.titleTextColor = titleTextColor
        self.placement = placement
        self.insets = insets
        self.showAnimation = showAnimation
        self.hideAnimation = hideAnimation
        self.tapAnimation = tapAnimation
        self.fadeAnimation = fadeAnimation
    }
}

/// Internal state for built in Placard views (the default configuration)
enum PlacardConfigCase: PlacardConfigP {

    case `default`, info, success, warning, error, color(UIColor)

    public var backgroundColor: UIColor? {
        switch self {
        case .info: return UIColor(red: 0.13, green: 0.48, blue: 0.90, alpha: 1.0)
        case .success: return UIColor(red: 0.07, green: 0.66, blue: 0.07, alpha: 1.0)
        case .warning: return UIColor(red: 0.78, green: 0.75, blue: 0.00, alpha: 1.0)
        case .error: return UIColor(red: 0.89, green: 0.21, blue: 0.21, alpha: 1.0)
        case .color(let color): return color
        default: return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }

    // used for system image and secondary font foregrounds
    public var accentColor: UIColor? {
        switch self {
        case .info, .success, .warning, .error: return UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1.00)
        default: return UIColor(red: 0.61, green: 0.78, blue: 0.87, alpha: 1.00)
        }
    }

    public var primaryFont: UIFont? {
        switch self { default: return UIFont.systemFont(ofSize: 20.0, weight: .semibold) }
    }

    public var secondaryFont: UIFont? {
        switch self { default: return UIFont.systemFont(ofSize: 16.0, weight: .medium) }
    }

    public var titleTextColor: UIColor? {
        switch self { default: return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00) }
    }

    public var placement: PlacardPlacement? {
        switch self { default: return .top }
    }

    public var insets: UIEdgeInsets? {
        switch self { default: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
    }

    public var showAnimation: TransitionAnimation? {
        switch self { default: return nil }
    }

    public var hideAnimation: TransitionAnimation? {
        switch self { default: return nil }
    }

    public var tapAnimation: TapAnimation? {
        switch self { default: return nil }
    }

    public var fadeAnimation: Bool? {
        switch self { default: return false }
    }
}



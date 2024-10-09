//
//  PlacardView.swift
//  Placard
//
//  Created by Christopher Charles Cavnor on 9/18/24.
//

import SwiftUI

// =================== View templates ========================

@ViewBuilder private func cardViewBuilder(imageName: String,
                                          accentColor: Color,
                                          title: String,
                                          primaryFont: Font,
                                          primaryTextColor: Color,
                                          statusMessage: String,
                                          secondaryFont: Font,
                                          minHeight: CGFloat) -> some View {
    HStack(alignment: .center) {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .foregroundColor(primaryTextColor)
            .padding(.all, 20)

        VStack(alignment: .leading) {
            Text(title)
                .font(primaryFont)
                .foregroundColor(primaryTextColor)
            Text(statusMessage)
                .font(secondaryFont)
                .foregroundColor(accentColor)
        }
        .padding(.trailing, 20)
        //Spacer() // this forces contents to left margin
    }
    .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .center)
    .padding(.bottom, 15)
}

private struct PriorityCardModifier: ViewModifier {
    var priority: PlacardPriority

    func body(content: Content) -> some View {
        var backgroundColor: UIColor? {
            switch priority {
            case .info: return PlacardConfigCase.info.backgroundColor
            case .success: return PlacardConfigCase.success.backgroundColor
            case .warning: return PlacardConfigCase.warning.backgroundColor
            case .error: return PlacardConfigCase.error.backgroundColor
            default: return PlacardConfigCase.default.backgroundColor
            }
        }
        content
            .background(Color(backgroundColor!)) // default black
            .opacity(0.90)
    }
}

// This handles the views for all messages that do not pass their own view and have a set PlacardPriority.
fileprivate struct PriorityPlacardViewTemplate: View {
    private var title: String
    private var statusMessage: String
    private var systemImageName: String
    private var priority: PlacardPriority?
    private var config: PlacardConfigP
    private var minHeight: CGFloat

    init(title: String,
         statusMessage: String,
         systemImageName: String = "",
         priority: PlacardPriority?,
         config: PlacardConfigP,
         minHeight: CGFloat = 0) {
        self.title = title
        self.statusMessage = statusMessage
        self.systemImageName = systemImageName
        self.priority = priority
        self.config = config
        self.minHeight = minHeight
    }

    var image: String {
        if !systemImageName.isEmpty { return systemImageName }
        switch priority {
        case .success: return "checkmark.circle"
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.octagon"
        default: return "paperplane"
        }
    }

    var primaryTextColor: Color {
        return Color(PlacardConfigCase.default.titleTextColor ?? .white)
    }

    var accentColor: Color {
        switch priority {
        case .success: return Color(PlacardConfigCase.success.accentColor ?? .white)
        case .info: return Color(PlacardConfigCase.info.accentColor ?? .white)
        case .warning: return Color(PlacardConfigCase.warning.accentColor ?? .white)
        case .error: return Color(PlacardConfigCase.error.accentColor ?? .white)
        default: return Color(PlacardConfigCase.default.accentColor ?? .white)
        }
    }

    var primaryFont: Font {
        if let font = PlacardConfigCase.default.primaryFont {
            return Font(font)
        }
        return .system(size: 26, weight: .bold, design: .default)
    }

    var secondaryFont: Font {
        if let font = PlacardConfigCase.default.secondaryFont {
            return Font(font)
        }
        return .system(size: 16, weight: .bold, design: .default)
    }

    var body: some View {
        cardViewBuilder(imageName: image,
                        accentColor: accentColor,
                        title: title,
                        primaryFont: primaryFont,
                        primaryTextColor: primaryTextColor,
                        statusMessage: statusMessage,
                        secondaryFont: secondaryFont,
                        minHeight: minHeight
        )
        .modifier(PriorityCardModifier(priority: priority ?? .default))
    }
}

// This handles the views for all messages that do not pass their own view and DO NOT have a set PlacardPriority.
fileprivate struct CustomPlacardViewTemplate: View {
    private var title: String
    private var statusMessage: String
    private var systemImageName: String
    private var config: PlacardConfigP

    init(title: String, statusMessage: String, systemImageName: String, config: PlacardConfigP) {
        self.title = title
        self.statusMessage = statusMessage
        self.systemImageName = systemImageName
        self.config = config
    }

    var image: String {
        systemImageName
    }

    var backgroundColor: Color {
        Color((config.backgroundColor ?? PlacardConfigCase.default.backgroundColor)!)
    }

    var primaryTextColor: Color {
        Color((config.titleTextColor ?? PlacardConfigCase.default.titleTextColor)!)
    }

    var accentColor: Color {
        Color((config.accentColor ?? PlacardConfigCase.default.accentColor)!)
    }

    var primaryFont: Font {
        if let font = config.primaryFont {
            return Font(font)
        }
        return .system(size: 26, weight: .bold, design: .default)
    }

    var secondaryFont: Font {
        if let font = config.secondaryFont {
            return Font(font)
        }
        return .system(size: 16, weight: .bold, design: .default)
    }

    var body: some View {
        cardViewBuilder(imageName: image,
                        accentColor: accentColor,
                        title: title,
                        primaryFont: primaryFont,
                        primaryTextColor: primaryTextColor,
                        statusMessage: statusMessage,
                        secondaryFont: secondaryFont,
                        minHeight: 0
        )
        .background(backgroundColor)
    }
}

// =================== UIViewRepresentable ========================

/// Default View handler - same as calling PlacardPriorityView with priority of .default
struct PlacardView: View {
    private let title: String
    private let message: String
    private let systemImageName: String?
    private var config: PlacardConfigP?
    private var duration: Double
    private var action: TapAction?

    init(title: String,
         statusMessage: String,
         systemImageName: String? = "",
         config: PlacardConfigP? = nil,
         duration: Double = Placard.DEFAULT_SHOW_DURATION,
         action: TapAction? = nil
    ) {
        self.title = title
        self.message = statusMessage
        self.systemImageName = systemImageName
        self.config = config
        self.duration = duration
        self.action = action
    }

    var body: some View {
        PlacardPriorityView(title: title,
                            statusMessage: message,
                            systemImageName: systemImageName!,
                            config: config ?? PlacardConfig(),
                            duration: duration,
                            action: action)
    }
}


/*
 The minimum height (minHeight) fed to the view renderer is always based off of portrait mode,
 since the text height calculations are performed on screen/view width. The view, rendered as
 a UIView, uses the swiftui view to calculate intrinsicContentSize using minHeight.

 For placards with very long message text (title and message status), the swiftui view might get
 truncated. If so, the best thing to do is to adjust the insets and/or the padding in the view
 template.

 This is ONLY an issue if the user renders the placard in landscape mode and then rotates the
 screen to portrait mode (since placard calculates intrinsicContentSize on the first rendered view).
 Starting in portrait mode is guaranteed to work since intrinsicContentSize for portrait will render
 a view height larger than landscape orientation requires.
 */
/// View handler for provided placard views (handles the processing of both  PlacardPriorityView and PlacardView)
struct PlacardPriorityView: UIViewRepresentable {
    private let title: String
    private let statusMessage: String
    private let systemImageName: String?
    private var config: PlacardConfigP
    private var duration: Double
    private var action: TapAction?
    private var priority: PlacardPriority?

    private let content: UIView

    init(title: String,
         statusMessage: String,
         systemImageName: String = "",
         config: PlacardConfigP = PlacardConfig(),
         duration: Double = Placard.DEFAULT_SHOW_DURATION,
         action: TapAction? = nil,
         priority: PlacardPriority? = nil) {
        self.title = title
        self.statusMessage = statusMessage
        self.systemImageName = systemImageName
        self.config = config
        self.duration = duration
        self.action = action
        self.priority = priority

        let screenDims = UIScreen.main.bounds
        var placardWidth = screenDims.width

        // calculations are based on portrait orientation
        if screenDims.width > screenDims.height {
            placardWidth = screenDims.height
        }

        if let insets = config.insets {
            placardWidth -= (insets.left + insets.right)
        }

        // use UILabel calculations to estimate text size renderings (we keep only the size)
        let titleHeight = UILabel(frame: .zero)
        titleHeight.numberOfLines = 0 // multiline
        titleHeight.font = config.primaryFont // user font
        titleHeight.preferredMaxLayoutWidth = placardWidth // max width
        titleHeight.text = title // the text to display

        // use UILabel calculations to estimate text size renderings (we keep only the size)
        let messageHeight = UILabel(frame: .zero)
        messageHeight.numberOfLines = 0 // multiline
        messageHeight.font = config.secondaryFont // user font
        messageHeight.preferredMaxLayoutWidth = placardWidth // max width
        messageHeight.text = statusMessage // the text to display

        var minHeight: CGFloat {
            titleHeight.intrinsicContentSize.height + messageHeight.intrinsicContentSize.height
        }

        if let priority = self.priority {
            let cardView = PriorityPlacardViewTemplate(title: title,
                                                       statusMessage: statusMessage,
                                                       systemImageName: systemImageName,
                                                       priority: priority,
                                                       config: config,
                                                       minHeight: minHeight)
            self.content = UIHostingController(rootView: cardView).view
        } else {
            // any view without a priority is a custom view
            let cardView = CustomPlacardViewTemplate(title: title,
                                                     statusMessage: statusMessage,
                                                     systemImageName: systemImageName,
                                                     config: config)

            self.content = UIHostingController(rootView: cardView).view
        }
        self.content.backgroundColor = .clear
    }

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        content.translatesAutoresizingMaskIntoConstraints = false
        _=Placard(content: content, config: config, title: title, statusMessage: statusMessage, duration: duration, action: action)
    }
}

/// View handler for custom (user-provided) views
struct PlacardCustomView<Content>: UIViewRepresentable where Content: View {
    private let title: String
    private let statusMessage: String
    private let content: UIView
    private var config: PlacardConfigP?
    private var delay: Double
    private var duration: Double
    private var action: TapAction?

    init(title: String,
         statusMessage: String,
         config: PlacardConfigP?,
         delay: Double = Placard.DEFAULT_DELAY,
         duration: Double = Placard.DEFAULT_SHOW_DURATION,
         action: TapAction? = nil,
         @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.statusMessage = statusMessage

        self.content = UIHostingController(rootView: content()).view
        self.content.backgroundColor = .clear

        self.config = config
        self.delay = delay
        self.duration = duration
        self.action = action
    }

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        content.translatesAutoresizingMaskIntoConstraints = false
        let _config = self.config ?? PlacardConfigCase.default
        _=Placard(content: content, config: _config, duration: duration, action: action)
    }
}


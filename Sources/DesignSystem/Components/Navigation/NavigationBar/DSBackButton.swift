import SwiftUI

// MARK: - Back Button Style

/// Defines the visual style of the back button
public enum DSBackButtonStyle: Equatable {
    /// Standard iOS chevron style
    case chevron
    /// Arrow style
    case arrow
    /// Close (X) style
    case close
    /// Custom icon
    case custom(String)

    var iconName: String {
        switch self {
        case .chevron:
            return "chevron.left"
        case .arrow:
            return "arrow.left"
        case .close:
            return "xmark"
        case .custom(let name):
            return name
        }
    }
}

// MARK: - DSBackButton

/// A customizable back button component for navigation
///
/// DSBackButton provides a consistent back button implementation with support for:
/// - Multiple visual styles (chevron, arrow, close, custom)
/// - Optional text label
/// - Haptic feedback
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSBackButton {
///     dismiss()
/// }
///
/// DSBackButton(title: "Back", style: .chevron) {
///     navigationPath.removeLast()
/// }
/// ```
public struct DSBackButton: View {
    // MARK: - Properties

    private let title: String?
    private let style: DSBackButtonStyle
    private let tintColor: Color
    private let showTitle: Bool
    private let hapticFeedback: Bool
    private let action: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a new DSBackButton
    /// - Parameters:
    ///   - title: Optional text to display next to the icon
    ///   - style: Visual style of the back button (default: .chevron)
    ///   - tintColor: Color of the button (default: .accentColor)
    ///   - showTitle: Whether to show the title text (default: true if title provided)
    ///   - hapticFeedback: Whether to trigger haptic feedback on tap (default: true)
    ///   - action: Closure executed when button is tapped
    public init(
        title: String? = nil,
        style: DSBackButtonStyle = .chevron,
        tintColor: Color = .accentColor,
        showTitle: Bool = true,
        hapticFeedback: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.tintColor = tintColor
        self.showTitle = showTitle
        self.hapticFeedback = hapticFeedback
        self.action = action
    }

    /// Creates a DSBackButton that automatically dismisses the view
    /// - Parameters:
    ///   - title: Optional text to display next to the icon
    ///   - style: Visual style of the back button (default: .chevron)
    ///   - tintColor: Color of the button (default: .accentColor)
    public init(
        title: String? = nil,
        style: DSBackButtonStyle = .chevron,
        tintColor: Color = .accentColor
    ) {
        self.title = title
        self.style = style
        self.tintColor = tintColor
        self.showTitle = title != nil
        self.hapticFeedback = true
        self.action = {}
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to go back")
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    // MARK: - Subviews

    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: 4) {
            Image(systemName: style.iconName)
                .font(.system(size: iconSize, weight: .semibold))
                .imageScale(.large)

            if let title = title, showTitle {
                Text(title)
                    .font(.body)
            }
        }
        .foregroundColor(isPressed ? tintColor.opacity(0.6) : tintColor)
        .padding(.vertical, 8)
        .padding(.trailing, title != nil ? 8 : 0)
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    // MARK: - Computed Properties

    private var iconSize: CGFloat {
        switch style {
        case .chevron:
            return 18
        case .arrow:
            return 17
        case .close:
            return 16
        case .custom:
            return 17
        }
    }

    private var accessibilityLabel: String {
        if let title = title {
            return title
        }

        switch style {
        case .close:
            return "Close"
        default:
            return "Back"
        }
    }

    // MARK: - Actions

    private func handleTap() {
        if hapticFeedback {
            triggerHapticFeedback()
        }

        action()
        dismiss()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Convenience Initializers

extension DSBackButton {
    /// Creates a close button
    public static func close(
        tintColor: Color = .accentColor,
        action: @escaping () -> Void = {}
    ) -> DSBackButton {
        DSBackButton(style: .close, tintColor: tintColor, action: action)
    }

    /// Creates a back button with chevron and text
    public static func withTitle(
        _ title: String,
        tintColor: Color = .accentColor,
        action: @escaping () -> Void = {}
    ) -> DSBackButton {
        DSBackButton(title: title, style: .chevron, tintColor: tintColor, action: action)
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSBackButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            // Styles
            Text("Back Button Styles")
                .font(.headline)

            HStack(spacing: 24) {
                DSBackButton(style: .chevron) { }
                DSBackButton(style: .arrow) { }
                DSBackButton.close { }
                DSBackButton(style: .custom("chevron.backward.circle")) { }
            }

            Divider()

            // With titles
            Text("With Titles")
                .font(.headline)

            VStack(alignment: .leading, spacing: 16) {
                DSBackButton(title: "Back", style: .chevron) { }
                DSBackButton(title: "Settings", style: .chevron) { }
                DSBackButton.withTitle("Home") { }
            }

            Divider()

            // Colors
            Text("Color Variants")
                .font(.headline)

            HStack(spacing: 24) {
                DSBackButton(tintColor: .blue) { }
                DSBackButton(tintColor: .red) { }
                DSBackButton(tintColor: .green) { }
                DSBackButton(tintColor: .orange) { }
            }
        }
        .padding()
        .previewDisplayName("Light Mode")

        VStack(spacing: 24) {
            DSBackButton(title: "Back") { }
            DSBackButton.close { }
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif

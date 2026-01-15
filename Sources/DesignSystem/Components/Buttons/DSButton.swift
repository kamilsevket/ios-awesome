import SwiftUI

// MARK: - Button Style

/// Defines the visual style of the button
public enum DSButtonStyle {
    case primary
    case secondary
    case tertiary

    var backgroundColor: Color {
        switch self {
        case .primary:
            return Color.accentColor
        case .secondary:
            return Color(.systemGray5)
        case .tertiary:
            return Color.clear
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return Color.white
        case .secondary:
            return Color.primary
        case .tertiary:
            return Color.accentColor
        }
    }

    var pressedBackgroundColor: Color {
        switch self {
        case .primary:
            return Color.accentColor.opacity(0.8)
        case .secondary:
            return Color(.systemGray4)
        case .tertiary:
            return Color(.systemGray6)
        }
    }
}

// MARK: - Button Size

/// Defines the size variant of the button
public enum DSButtonSize {
    case small
    case medium
    case large

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        }
    }

    var font: Font {
        switch self {
        case .small: return .subheadline.weight(.medium)
        case .medium: return .body.weight(.semibold)
        case .large: return .headline.weight(.semibold)
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }

    var minHeight: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 44
        case .large: return 52
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 10
        case .large: return 12
        }
    }
}

// MARK: - Icon Position

/// Defines where the icon appears relative to the text
public enum DSButtonIconPosition {
    case leading
    case trailing
}

// MARK: - DSButton

/// A customizable button component for the design system
///
/// DSButton provides a consistent button implementation with support for:
/// - Multiple visual styles (primary, secondary, tertiary)
/// - Size variants (small, medium, large)
/// - Loading state with spinner
/// - Icon support with configurable positioning
/// - Full-width option
/// - Haptic feedback
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSButton("Save", style: .primary, isLoading: isLoading) {
///     save()
/// }
///
/// DSButton("Cancel", style: .secondary, icon: Image(systemName: "xmark")) {
///     cancel()
/// }
/// ```
public struct DSButton: View {
    // MARK: - Properties

    private let title: String
    private let style: DSButtonStyle
    private let size: DSButtonSize
    private let icon: Image?
    private let iconPosition: DSButtonIconPosition
    private let isFullWidth: Bool
    private let isLoading: Bool
    private let isEnabled: Bool
    private let hapticFeedback: Bool
    private let action: () -> Void

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a new DSButton
    /// - Parameters:
    ///   - title: The button's title text
    ///   - style: Visual style of the button (default: .primary)
    ///   - size: Size variant (default: .medium)
    ///   - icon: Optional icon image
    ///   - iconPosition: Position of the icon relative to text (default: .leading)
    ///   - isFullWidth: Whether button should expand to full width (default: false)
    ///   - isLoading: Shows loading spinner when true (default: false)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback on tap (default: true)
    ///   - action: Closure executed when button is tapped
    public init(
        _ title: String,
        style: DSButtonStyle = .primary,
        size: DSButtonSize = .medium,
        icon: Image? = nil,
        iconPosition: DSButtonIconPosition = .leading,
        isFullWidth: Bool = false,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.icon = icon
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.hapticFeedback = hapticFeedback
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(isLoading ? "Loading" : "")
        .accessibilityAddTraits(.isButton)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    // MARK: - Subviews

    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: 8) {
            if isLoading {
                loadingSpinner
            } else {
                if let icon = icon, iconPosition == .leading {
                    iconView(icon)
                }

                Text(title)
                    .font(size.font)

                if let icon = icon, iconPosition == .trailing {
                    iconView(icon)
                }
            }
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .frame(minHeight: max(size.minHeight, 44)) // Ensure minimum 44pt touch target
        .background(backgroundView)
        .foregroundColor(style.foregroundColor)
        .cornerRadius(size.cornerRadius)
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: size.cornerRadius)
            .fill(isPressed ? style.pressedBackgroundColor : style.backgroundColor)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    private func iconView(_ icon: Image) -> some View {
        icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.iconSize, height: size.iconSize)
    }

    private var loadingSpinner: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
            .scaleEffect(size == .small ? 0.8 : 1.0)
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        if isLoading {
            return "\(title), loading"
        }
        return title
    }

    // MARK: - Actions

    private func handleTap() {
        guard isEnabled && !isLoading else { return }

        if hapticFeedback {
            triggerHapticFeedback()
        }

        action()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Style variants
                sectionHeader("Button Styles")
                DSButton("Primary Button", style: .primary) { }
                DSButton("Secondary Button", style: .secondary) { }
                DSButton("Tertiary Button", style: .tertiary) { }

                Divider()

                // Size variants
                sectionHeader("Size Variants")
                DSButton("Small", style: .primary, size: .small) { }
                DSButton("Medium", style: .primary, size: .medium) { }
                DSButton("Large", style: .primary, size: .large) { }

                Divider()

                // With icons
                sectionHeader("With Icons")
                DSButton("Add Item", style: .primary, icon: Image(systemName: "plus")) { }
                DSButton("Next", style: .secondary, icon: Image(systemName: "arrow.right"), iconPosition: .trailing) { }

                Divider()

                // States
                sectionHeader("States")
                DSButton("Loading", style: .primary, isLoading: true) { }
                DSButton("Disabled", style: .primary, isEnabled: false) { }

                Divider()

                // Full width
                sectionHeader("Full Width")
                DSButton("Full Width Button", style: .primary, isFullWidth: true) { }
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 24) {
                DSButton("Primary Button", style: .primary) { }
                DSButton("Secondary Button", style: .secondary) { }
                DSButton("Tertiary Button", style: .tertiary) { }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }

    static func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#endif

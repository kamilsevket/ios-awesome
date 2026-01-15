import SwiftUI

// MARK: - Icon Button Style

/// Visual style variants for icon buttons
public enum DSIconButtonStyle {
    case filled
    case tinted
    case plain

    func backgroundColor(for color: Color) -> Color {
        switch self {
        case .filled:
            return color
        case .tinted:
            return color.opacity(0.15)
        case .plain:
            return Color.clear
        }
    }

    func foregroundColor(for color: Color) -> Color {
        switch self {
        case .filled:
            return Color.white
        case .tinted, .plain:
            return color
        }
    }

    func pressedBackgroundColor(for color: Color) -> Color {
        switch self {
        case .filled:
            return color.opacity(0.8)
        case .tinted:
            return color.opacity(0.25)
        case .plain:
            return Color(.systemGray5)
        }
    }
}

// MARK: - Icon Button Size

/// Size variants for icon buttons
public enum DSIconButtonSize {
    case small
    case medium
    case large

    var buttonSize: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 44
        case .large: return 52
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
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

// MARK: - DSIconButton

/// A button component that displays only an icon
///
/// DSIconButton is designed for actions that can be represented by a single icon,
/// such as close buttons, action shortcuts, or toolbar items.
///
/// Features:
/// - Multiple visual styles (filled, tinted, plain)
/// - Configurable size variants
/// - Circular or rounded rectangle shape
/// - Loading state support
/// - Haptic feedback
/// - Full accessibility support
///
/// Example usage:
/// ```swift
/// DSIconButton(.plus) { add() }
///
/// DSIconButton(.xmark, style: .plain, size: .small) { dismiss() }
///
/// DSIconButton(systemName: "heart.fill", style: .tinted, color: .red) {
///     toggleFavorite()
/// }
/// ```
public struct DSIconButton: View {
    // MARK: - Properties

    private let icon: Image
    private let style: DSIconButtonStyle
    private let size: DSIconButtonSize
    private let color: Color
    private let isCircular: Bool
    private let isLoading: Bool
    private let isEnabled: Bool
    private let hapticFeedback: Bool
    private let accessibilityLabel: String
    private let action: () -> Void

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a new DSIconButton with a system icon name
    /// - Parameters:
    ///   - systemName: SF Symbol name
    ///   - style: Visual style (default: .filled)
    ///   - size: Size variant (default: .medium)
    ///   - color: Tint color (default: .accentColor)
    ///   - isCircular: Whether to use circular shape (default: false)
    ///   - isLoading: Shows loading spinner when true (default: false)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback (default: true)
    ///   - accessibilityLabel: VoiceOver label for the button
    ///   - action: Closure executed when button is tapped
    public init(
        systemName: String,
        style: DSIconButtonStyle = .filled,
        size: DSIconButtonSize = .medium,
        color: Color = .accentColor,
        isCircular: Bool = false,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = Image(systemName: systemName)
        self.style = style
        self.size = size
        self.color = color
        self.isCircular = isCircular
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.hapticFeedback = hapticFeedback
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    /// Creates a new DSIconButton with a custom Image
    /// - Parameters:
    ///   - icon: The icon image to display
    ///   - style: Visual style (default: .filled)
    ///   - size: Size variant (default: .medium)
    ///   - color: Tint color (default: .accentColor)
    ///   - isCircular: Whether to use circular shape (default: false)
    ///   - isLoading: Shows loading spinner when true (default: false)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback (default: true)
    ///   - accessibilityLabel: VoiceOver label for the button
    ///   - action: Closure executed when button is tapped
    public init(
        icon: Image,
        style: DSIconButtonStyle = .filled,
        size: DSIconButtonSize = .medium,
        color: Color = .accentColor,
        isCircular: Bool = false,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.color = color
        self.isCircular = isCircular
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.hapticFeedback = hapticFeedback
        self.accessibilityLabel = accessibilityLabel
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
        .accessibilityLabel(accessibilityLabelText)
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
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor(for: color)))
                    .scaleEffect(size == .small ? 0.7 : 0.85)
            } else {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.iconSize, height: size.iconSize)
            }
        }
        .frame(width: size.buttonSize, height: size.buttonSize)
        .background(backgroundView)
        .foregroundColor(style.foregroundColor(for: color))
        .clipShape(buttonShape)
    }

    @ViewBuilder
    private var backgroundView: some View {
        let backgroundColor = isPressed
            ? style.pressedBackgroundColor(for: color)
            : style.backgroundColor(for: color)

        if isCircular {
            Circle()
                .fill(backgroundColor)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        } else {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(backgroundColor)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
    }

    @ViewBuilder
    private var buttonShape: some Shape {
        if isCircular {
            AnyShape(Circle())
        } else {
            AnyShape(RoundedRectangle(cornerRadius: size.cornerRadius))
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabelText: String {
        if isLoading {
            return "\(accessibilityLabel), loading"
        }
        return accessibilityLabel
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
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Convenience Initializers

extension DSIconButton {
    /// Creates an icon button with common system icons
    public static func close(
        style: DSIconButtonStyle = .plain,
        size: DSIconButtonSize = .medium,
        action: @escaping () -> Void
    ) -> DSIconButton {
        DSIconButton(
            systemName: "xmark",
            style: style,
            size: size,
            accessibilityLabel: "Close",
            action: action
        )
    }

    /// Creates an add/plus icon button
    public static func add(
        style: DSIconButtonStyle = .filled,
        size: DSIconButtonSize = .medium,
        color: Color = .accentColor,
        action: @escaping () -> Void
    ) -> DSIconButton {
        DSIconButton(
            systemName: "plus",
            style: style,
            size: size,
            color: color,
            accessibilityLabel: "Add",
            action: action
        )
    }

    /// Creates a settings/gear icon button
    public static func settings(
        style: DSIconButtonStyle = .plain,
        size: DSIconButtonSize = .medium,
        action: @escaping () -> Void
    ) -> DSIconButton {
        DSIconButton(
            systemName: "gearshape",
            style: style,
            size: size,
            accessibilityLabel: "Settings",
            action: action
        )
    }

    /// Creates a share icon button
    public static func share(
        style: DSIconButtonStyle = .plain,
        size: DSIconButtonSize = .medium,
        action: @escaping () -> Void
    ) -> DSIconButton {
        DSIconButton(
            systemName: "square.and.arrow.up",
            style: style,
            size: size,
            accessibilityLabel: "Share",
            action: action
        )
    }

    /// Creates an edit/pencil icon button
    public static func edit(
        style: DSIconButtonStyle = .plain,
        size: DSIconButtonSize = .medium,
        action: @escaping () -> Void
    ) -> DSIconButton {
        DSIconButton(
            systemName: "pencil",
            style: style,
            size: size,
            accessibilityLabel: "Edit",
            action: action
        )
    }

    /// Creates a delete/trash icon button
    public static func delete(
        style: DSIconButtonStyle = .plain,
        size: DSIconButtonSize = .medium,
        color: Color = .red,
        action: @escaping () -> Void
    ) -> DSIconButton {
        DSIconButton(
            systemName: "trash",
            style: style,
            size: size,
            color: color,
            accessibilityLabel: "Delete",
            action: action
        )
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSIconButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Style variants
                sectionHeader("Style Variants")
                HStack(spacing: 16) {
                    DSIconButton(systemName: "plus", style: .filled, accessibilityLabel: "Add") { }
                    DSIconButton(systemName: "plus", style: .tinted, accessibilityLabel: "Add") { }
                    DSIconButton(systemName: "plus", style: .plain, accessibilityLabel: "Add") { }
                }

                // Size variants
                sectionHeader("Size Variants")
                HStack(spacing: 16) {
                    DSIconButton(systemName: "star.fill", size: .small, accessibilityLabel: "Favorite") { }
                    DSIconButton(systemName: "star.fill", size: .medium, accessibilityLabel: "Favorite") { }
                    DSIconButton(systemName: "star.fill", size: .large, accessibilityLabel: "Favorite") { }
                }

                // Circular variants
                sectionHeader("Circular Shape")
                HStack(spacing: 16) {
                    DSIconButton(systemName: "heart.fill", style: .filled, isCircular: true, accessibilityLabel: "Like") { }
                    DSIconButton(systemName: "heart.fill", style: .tinted, color: .red, isCircular: true, accessibilityLabel: "Like") { }
                    DSIconButton(systemName: "heart.fill", style: .plain, color: .red, isCircular: true, accessibilityLabel: "Like") { }
                }

                // Common actions
                sectionHeader("Common Actions")
                HStack(spacing: 16) {
                    DSIconButton.close { }
                    DSIconButton.add { }
                    DSIconButton.settings { }
                    DSIconButton.share { }
                    DSIconButton.edit { }
                    DSIconButton.delete { }
                }

                // States
                sectionHeader("States")
                HStack(spacing: 16) {
                    DSIconButton(systemName: "checkmark", isLoading: true, accessibilityLabel: "Confirm") { }
                    DSIconButton(systemName: "checkmark", isEnabled: false, accessibilityLabel: "Confirm") { }
                }

                // Custom colors
                sectionHeader("Custom Colors")
                HStack(spacing: 16) {
                    DSIconButton(systemName: "bell.fill", style: .tinted, color: .orange, accessibilityLabel: "Notifications") { }
                    DSIconButton(systemName: "bookmark.fill", style: .tinted, color: .purple, accessibilityLabel: "Bookmark") { }
                    DSIconButton(systemName: "flag.fill", style: .tinted, color: .green, accessibilityLabel: "Flag") { }
                }
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 32) {
                HStack(spacing: 16) {
                    DSIconButton(systemName: "plus", style: .filled, accessibilityLabel: "Add") { }
                    DSIconButton(systemName: "plus", style: .tinted, accessibilityLabel: "Add") { }
                    DSIconButton(systemName: "plus", style: .plain, accessibilityLabel: "Add") { }
                }

                HStack(spacing: 16) {
                    DSIconButton.close { }
                    DSIconButton.add { }
                    DSIconButton.settings { }
                }
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

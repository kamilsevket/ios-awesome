import SwiftUI

// MARK: - List Card Accessory

/// Defines the accessory view shown on the trailing edge of a list card
public enum ListCardAccessory: Sendable {
    case none
    case chevron
    case checkmark
    case disclosure
    case custom(AnyView)

    @ViewBuilder
    var view: some View {
        switch self {
        case .none:
            EmptyView()
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.tertiaryLabel))
        case .checkmark:
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.accentColor)
        case .disclosure:
            Image(systemName: "info.circle")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.accentColor)
        case .custom(let view):
            view
        }
    }

    public static func custom<V: View>(_ view: V) -> ListCardAccessory {
        .custom(AnyView(view))
    }
}

// MARK: - DSListCard

/// A list item style card component for use in lists and menus.
///
/// DSListCard provides:
/// - Leading icon/avatar support
/// - Title and subtitle
/// - Trailing accessory views
/// - Swipe actions support
/// - Navigation-ready with chevron accessory
///
/// Example usage:
/// ```swift
/// DSListCard(
///     title: "Settings",
///     subtitle: "Configure your preferences",
///     icon: Image(systemName: "gear")
/// )
/// .accessory(.chevron)
/// .onTap { navigate() }
/// ```
public struct DSListCard: View {
    // MARK: - Properties

    private let title: String
    private let subtitle: String?
    private let icon: Image?
    private var style: CardStyle = .flat
    private var cardPadding: CardPadding = .standard
    private var cornerRadius: CardCornerRadius = .medium
    private var accessory: ListCardAccessory = .none
    private var showDivider: Bool = false
    private var iconBackgroundColor: Color?
    private var iconForegroundColor: Color = .accentColor
    private var onTap: (() -> Void)?
    private var hapticFeedback: Bool = true

    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a new DSListCard.
    /// - Parameters:
    ///   - title: The primary text.
    ///   - subtitle: Optional secondary text.
    ///   - icon: Optional leading icon.
    public init(
        title: String,
        subtitle: String? = nil,
        icon: Image? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if onTap != nil {
                Button(action: handleTap) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(pressGesture)
            } else {
                cardContent
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(onTap != nil ? .isButton : [])
    }

    // MARK: - Subviews

    private var cardContent: some View {
        VStack(spacing: 0) {
            HStack(spacing: Spacing.md) {
                if let icon = icon {
                    iconView(icon)
                }

                textContent

                Spacer(minLength: Spacing.sm)

                accessory.view
            }
            .padding(.horizontal, cardPadding.value)
            .padding(.vertical, cardPadding == .none ? 0 : Spacing.md)
            .frame(minHeight: 44) // Minimum touch target
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius.value))
            .contentShape(Rectangle())

            if showDivider {
                dividerView
            }
        }
    }

    private func iconView(_ image: Image) -> some View {
        ZStack {
            if let backgroundColor = iconBackgroundColor {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(width: 36, height: 36)
            }

            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(iconForegroundColor)
        }
        .frame(width: 36, height: 36)
    }

    private var textContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(1)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: cornerRadius.value)
            .fill(resolveBackgroundColor())
    }

    private var dividerView: some View {
        Rectangle()
            .fill(Color(.separator))
            .frame(height: 0.5)
            .padding(.leading, icon != nil ? (36 + Spacing.md + cardPadding.value) : cardPadding.value)
    }

    // MARK: - Helpers

    private func resolveBackgroundColor() -> Color {
        if isPressed {
            return Color(.systemGray5)
        }
        return style.resolvedBackgroundColor(for: colorScheme)
    }

    private var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
            }
            .onEnded { _ in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
    }

    private func handleTap() {
        if hapticFeedback {
            #if os(iOS)
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            #endif
        }
        onTap?()
    }

    private var accessibilityLabel: String {
        var label = title
        if let subtitle = subtitle {
            label += ", \(subtitle)"
        }
        return label
    }

    // MARK: - Modifiers

    /// Sets the visual style of the card.
    public func style(_ style: CardStyle) -> DSListCard {
        var card = self
        card.style = style
        return card
    }

    /// Sets the internal padding of the card.
    public func cardPadding(_ padding: CardPadding) -> DSListCard {
        var card = self
        card.cardPadding = padding
        return card
    }

    /// Sets the corner radius of the card.
    public func cornerRadius(_ radius: CardCornerRadius) -> DSListCard {
        var card = self
        card.cornerRadius = radius
        return card
    }

    /// Sets the trailing accessory view.
    public func accessory(_ accessory: ListCardAccessory) -> DSListCard {
        var card = self
        card.accessory = accessory
        return card
    }

    /// Shows a divider at the bottom of the card.
    public func showDivider(_ show: Bool = true) -> DSListCard {
        var card = self
        card.showDivider = show
        return card
    }

    /// Sets the icon background color.
    public func iconBackground(_ color: Color) -> DSListCard {
        var card = self
        card.iconBackgroundColor = color
        return card
    }

    /// Sets the icon foreground color.
    public func iconColor(_ color: Color) -> DSListCard {
        var card = self
        card.iconForegroundColor = color
        return card
    }

    /// Sets a tap action to make the card interactive.
    public func onTap(_ action: @escaping () -> Void) -> DSListCard {
        var card = self
        card.onTap = action
        return card
    }

    /// Enables or disables haptic feedback.
    public func hapticFeedback(_ enabled: Bool) -> DSListCard {
        var card = self
        card.hapticFeedback = enabled
        return card
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSListCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                sectionHeader("Basic List Cards")

                DSListCard(
                    title: "Simple List Item",
                    subtitle: nil,
                    icon: nil
                )
                .showDivider()

                DSListCard(
                    title: "With Subtitle",
                    subtitle: "Additional description text",
                    icon: nil
                )
                .showDivider()

                DSListCard(
                    title: "With Icon",
                    subtitle: "Shows a leading icon",
                    icon: Image(systemName: "star.fill")
                )
                .showDivider()

                Spacer().frame(height: Spacing.lg)

                sectionHeader("Accessories")

                DSListCard(
                    title: "Navigation Item",
                    subtitle: "Tap to navigate",
                    icon: Image(systemName: "gear")
                )
                .accessory(.chevron)
                .showDivider()
                .onTap {}

                DSListCard(
                    title: "Selected Item",
                    subtitle: "Shows checkmark",
                    icon: Image(systemName: "checkmark.circle.fill")
                )
                .accessory(.checkmark)
                .showDivider()

                DSListCard(
                    title: "Info Item",
                    subtitle: "Shows disclosure",
                    icon: Image(systemName: "info.circle")
                )
                .accessory(.disclosure)
                .showDivider()

                Spacer().frame(height: Spacing.lg)

                sectionHeader("Icon Styles")

                DSListCard(
                    title: "Colored Background",
                    subtitle: "Icon with background",
                    icon: Image(systemName: "bell.fill")
                )
                .iconBackground(Color.red.opacity(0.2))
                .iconColor(.red)
                .accessory(.chevron)
                .showDivider()
                .onTap {}

                DSListCard(
                    title: "Blue Theme",
                    subtitle: "Different icon color",
                    icon: Image(systemName: "envelope.fill")
                )
                .iconBackground(Color.blue.opacity(0.2))
                .iconColor(.blue)
                .accessory(.chevron)
                .showDivider()
                .onTap {}

                Spacer().frame(height: Spacing.lg)

                sectionHeader("Card Style Variants")

                DSListCard(
                    title: "Elevated Style",
                    subtitle: "With shadow",
                    icon: Image(systemName: "square.stack.fill")
                )
                .style(.elevated)
                .accessory(.chevron)
                .onTap {}

                Spacer().frame(height: Spacing.sm)

                DSListCard(
                    title: "Outlined Style",
                    subtitle: "With border",
                    icon: Image(systemName: "rectangle")
                )
                .style(.outlined)
                .accessory(.chevron)
                .onTap {}
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 0) {
                DSListCard(
                    title: "Dark Mode Item",
                    subtitle: "Automatic adaptation",
                    icon: Image(systemName: "moon.fill")
                )
                .iconBackground(Color.purple.opacity(0.3))
                .iconColor(.purple)
                .accessory(.chevron)
                .showDivider()
                .onTap {}

                DSListCard(
                    title: "Another Item",
                    subtitle: "Dark mode styling",
                    icon: Image(systemName: "star.fill")
                )
                .iconBackground(Color.yellow.opacity(0.3))
                .iconColor(.yellow)
                .accessory(.chevron)
                .showDivider()
                .onTap {}
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
            .padding(.vertical, Spacing.sm)
    }
}
#endif

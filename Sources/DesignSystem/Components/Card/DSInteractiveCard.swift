import SwiftUI

// MARK: - DSInteractiveCard

/// A tappable card component with touch feedback animation.
///
/// DSInteractiveCard provides:
/// - Press state with scale animation
/// - Haptic feedback on tap
/// - Selection state support
/// - Swipe action support (optional)
/// - Full accessibility support
///
/// Example usage:
/// ```swift
/// DSInteractiveCard {
///     Text("Tap me!")
/// } onTap: {
///     handleTap()
/// }
/// .selectable(isSelected: $isSelected)
/// ```
public struct DSInteractiveCard<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private let onTap: (() -> Void)?
    private var style: CardStyle = .elevated
    private var cardPadding: CardPadding = .standard
    private var cornerRadius: CardCornerRadius = .medium
    private var shadowLevel: CardShadowLevel = .small
    private var isSelectable: Bool = false
    private var isSelected: Bool = false
    private var hapticFeedback: Bool = true
    private var scaleEffect: CGFloat = 0.98
    private var animationDuration: Double = 0.15

    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a new DSInteractiveCard with the provided content and tap action.
    /// - Parameters:
    ///   - content: A view builder closure that provides the card's content.
    ///   - onTap: An optional closure executed when the card is tapped.
    public init(
        @ViewBuilder content: () -> Content,
        onTap: (() -> Void)? = nil
    ) {
        self.content = content()
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            cardContent
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        isPressed = false
                    }
                }
        )
        .scaleEffect(isPressed ? scaleEffect : 1.0)
        .animation(.easeInOut(duration: animationDuration), value: isPressed)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isSelectable ? (isSelected ? "Selected" : "Not selected") : "")
    }

    // MARK: - Subviews

    private var cardContent: some View {
        content
            .padding(cardPadding.value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius.value))
            .overlay(borderOverlay)
            .overlay(selectionOverlay)
            .shadow(resolveShadowToken(), colorScheme: colorScheme)
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: cornerRadius.value)
            .fill(resolveBackgroundColor())
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            RoundedRectangle(cornerRadius: cornerRadius.value)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        }
    }

    @ViewBuilder
    private var selectionOverlay: some View {
        if isSelectable && isSelected {
            RoundedRectangle(cornerRadius: cornerRadius.value)
                .stroke(Color.accentColor, lineWidth: 2)
        }
    }

    // MARK: - Helpers

    private func resolveBackgroundColor() -> Color {
        if isPressed {
            return pressedBackgroundColor()
        }
        return style.resolvedBackgroundColor(for: colorScheme)
    }

    private func pressedBackgroundColor() -> Color {
        switch style {
        case .flat:
            return Color(.systemGray6)
        case .outlined, .elevated, .filled:
            return style.resolvedBackgroundColor(for: colorScheme).opacity(0.8)
        }
    }

    private func resolveShadowToken() -> ShadowToken {
        guard style == .elevated else { return .none }
        // Reduce shadow when pressed for depth effect
        return isPressed ? .none : shadowLevel.shadowToken
    }

    // MARK: - Actions

    private func handleTap() {
        if hapticFeedback {
            triggerHapticFeedback()
        }
        onTap?()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }

    // MARK: - Modifiers

    /// Sets the visual style of the card.
    public func style(_ style: CardStyle) -> DSInteractiveCard {
        var card = self
        card.style = style
        return card
    }

    /// Sets the internal padding of the card.
    public func cardPadding(_ padding: CardPadding) -> DSInteractiveCard {
        var card = self
        card.cardPadding = padding
        return card
    }

    /// Sets the corner radius of the card.
    public func cornerRadius(_ radius: CardCornerRadius) -> DSInteractiveCard {
        var card = self
        card.cornerRadius = radius
        return card
    }

    /// Sets the shadow level for elevated cards.
    public func shadowLevel(_ level: CardShadowLevel) -> DSInteractiveCard {
        var card = self
        card.shadowLevel = level
        return card
    }

    /// Enables selection state with visual feedback.
    /// - Parameter isSelected: Whether the card is currently selected.
    public func selectable(_ isSelected: Bool) -> DSInteractiveCard {
        var card = self
        card.isSelectable = true
        card.isSelected = isSelected
        return card
    }

    /// Enables or disables haptic feedback on tap.
    public func hapticFeedback(_ enabled: Bool) -> DSInteractiveCard {
        var card = self
        card.hapticFeedback = enabled
        return card
    }

    /// Sets the scale effect when pressed.
    /// - Parameter scale: The scale factor when pressed (default: 0.98).
    public func pressScale(_ scale: CGFloat) -> DSInteractiveCard {
        var card = self
        card.scaleEffect = scale
        return card
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSInteractiveCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                sectionHeader("Interactive Cards")

                DSInteractiveCard {
                    cardContent("Tappable Card", subtitle: "Tap to see animation")
                } onTap: {
                    print("Card tapped!")
                }
                .style(.elevated)

                DSInteractiveCard {
                    cardContent("Outlined Interactive", subtitle: "With border style")
                } onTap: {
                    print("Outlined card tapped!")
                }
                .style(.outlined)

                Divider()

                sectionHeader("Selection State")

                DSInteractiveCard {
                    cardContent("Selected Card", subtitle: "Shows selection border")
                } onTap: {}
                .style(.elevated)
                .selectable(true)

                DSInteractiveCard {
                    cardContent("Unselected Card", subtitle: "No selection border")
                } onTap: {}
                .style(.elevated)
                .selectable(false)

                Divider()

                sectionHeader("Custom Press Effect")

                DSInteractiveCard {
                    cardContent("Large Press Scale", subtitle: "More dramatic animation")
                } onTap: {}
                .style(.elevated)
                .pressScale(0.95)
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: Spacing.lg) {
                DSInteractiveCard {
                    cardContent("Interactive Card", subtitle: "Dark mode appearance")
                } onTap: {}
                .style(.elevated)

                DSInteractiveCard {
                    cardContent("Selected Card", subtitle: "Dark mode with selection")
                } onTap: {}
                .style(.elevated)
                .selectable(true)
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

    static func cardContent(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
#endif

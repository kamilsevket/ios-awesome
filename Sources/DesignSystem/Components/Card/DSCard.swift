import SwiftUI

// MARK: - DSCard

/// A customizable card container component for the design system.
///
/// DSCard provides a consistent card implementation with support for:
/// - Multiple visual styles (flat, outlined, elevated, filled)
/// - Configurable padding, corner radius, and shadow
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSCard {
///     VStack {
///         Text("Card Title")
///         Text("Card content goes here")
///     }
/// }
/// .style(.elevated)
/// .padding(.standard)
/// .cornerRadius(.large)
/// ```
public struct DSCard<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private var style: CardStyle = .elevated
    private var cardPadding: CardPadding = .standard
    private var cornerRadius: CardCornerRadius = .medium
    private var shadowLevel: CardShadowLevel = .small

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a new DSCard with the provided content.
    /// - Parameter content: A view builder closure that provides the card's content.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        content
            .padding(cardPadding.value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius.value))
            .overlay(borderOverlay)
            .shadow(resolveShadowToken(), colorScheme: colorScheme)
            .accessibilityElement(children: .contain)
    }

    // MARK: - Subviews

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: cornerRadius.value)
            .fill(style.resolvedBackgroundColor(for: colorScheme))
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            RoundedRectangle(cornerRadius: cornerRadius.value)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        }
    }

    // MARK: - Helpers

    private func resolveShadowToken() -> ShadowToken {
        guard style == .elevated else { return .none }
        return shadowLevel.shadowToken
    }

    // MARK: - Modifiers

    /// Sets the visual style of the card.
    /// - Parameter style: The card style to apply.
    /// - Returns: A card with the specified style.
    public func style(_ style: CardStyle) -> DSCard {
        var card = self
        card.style = style
        return card
    }

    /// Sets the internal padding of the card.
    /// - Parameter padding: The padding to apply.
    /// - Returns: A card with the specified padding.
    public func cardPadding(_ padding: CardPadding) -> DSCard {
        var card = self
        card.cardPadding = padding
        return card
    }

    /// Sets the corner radius of the card.
    /// - Parameter radius: The corner radius to apply.
    /// - Returns: A card with the specified corner radius.
    public func cornerRadius(_ radius: CardCornerRadius) -> DSCard {
        var card = self
        card.cornerRadius = radius
        return card
    }

    /// Sets the shadow level for elevated cards.
    /// - Parameter level: The shadow level to apply.
    /// - Returns: A card with the specified shadow level.
    public func shadowLevel(_ level: CardShadowLevel) -> DSCard {
        var card = self
        card.shadowLevel = level
        return card
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Style variants
                sectionHeader("Card Styles")

                DSCard {
                    cardContent("Flat Card", subtitle: "No background or shadow")
                }
                .style(.flat)

                DSCard {
                    cardContent("Outlined Card", subtitle: "Border outline style")
                }
                .style(.outlined)

                DSCard {
                    cardContent("Elevated Card", subtitle: "With shadow elevation")
                }
                .style(.elevated)

                DSCard {
                    cardContent("Filled Card", subtitle: "Secondary background color")
                }
                .style(.filled)

                Divider()

                // Padding variants
                sectionHeader("Padding Variants")

                DSCard {
                    cardContent("No Padding", subtitle: "Edge to edge content")
                }
                .style(.outlined)
                .cardPadding(.none)

                DSCard {
                    cardContent("Compact Padding", subtitle: "8pt padding")
                }
                .style(.outlined)
                .cardPadding(.compact)

                DSCard {
                    cardContent("Standard Padding", subtitle: "16pt padding (default)")
                }
                .style(.outlined)
                .cardPadding(.standard)

                DSCard {
                    cardContent("Spacious Padding", subtitle: "24pt padding")
                }
                .style(.outlined)
                .cardPadding(.spacious)

                Divider()

                // Corner radius variants
                sectionHeader("Corner Radius")

                DSCard {
                    cardContent("Small Radius", subtitle: "4pt corners")
                }
                .style(.elevated)
                .cornerRadius(.small)

                DSCard {
                    cardContent("Medium Radius", subtitle: "8pt corners (default)")
                }
                .style(.elevated)
                .cornerRadius(.medium)

                DSCard {
                    cardContent("Large Radius", subtitle: "12pt corners")
                }
                .style(.elevated)
                .cornerRadius(.large)

                DSCard {
                    cardContent("Extra Large Radius", subtitle: "16pt corners")
                }
                .style(.elevated)
                .cornerRadius(.extraLarge)

                Divider()

                // Shadow level variants
                sectionHeader("Shadow Levels")

                DSCard {
                    cardContent("Small Shadow", subtitle: "Subtle elevation")
                }
                .style(.elevated)
                .shadowLevel(.small)

                DSCard {
                    cardContent("Medium Shadow", subtitle: "Standard elevation")
                }
                .style(.elevated)
                .shadowLevel(.medium)

                DSCard {
                    cardContent("Large Shadow", subtitle: "Prominent elevation")
                }
                .style(.elevated)
                .shadowLevel(.large)
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: Spacing.lg) {
                DSCard {
                    cardContent("Elevated Card", subtitle: "Dark mode appearance")
                }
                .style(.elevated)

                DSCard {
                    cardContent("Outlined Card", subtitle: "Dark mode appearance")
                }
                .style(.outlined)

                DSCard {
                    cardContent("Filled Card", subtitle: "Dark mode appearance")
                }
                .style(.filled)
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

import SwiftUI

// MARK: - DSExpandableCard

/// An expandable/collapsible card component with smooth animation.
///
/// DSExpandableCard provides:
/// - Tap-to-expand/collapse functionality
/// - Smooth disclosure animation
/// - Customizable header and content
/// - Rotation animation for disclosure indicator
/// - Full accessibility support
///
/// Example usage:
/// ```swift
/// DSExpandableCard(
///     title: "More Details",
///     isExpanded: $isExpanded
/// ) {
///     Text("Hidden content that appears when expanded")
/// }
/// .style(.elevated)
/// ```
public struct DSExpandableCard<Header: View, Content: View>: View {
    // MARK: - Properties

    private let header: Header
    private let content: Content
    @Binding private var isExpanded: Bool
    private var style: CardStyle = .elevated
    private var cardPadding: CardPadding = .standard
    private var cornerRadius: CardCornerRadius = .medium
    private var shadowLevel: CardShadowLevel = .small
    private var animationDuration: Double = 0.3
    private var hapticFeedback: Bool = true

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a new DSExpandableCard with a custom header view.
    /// - Parameters:
    ///   - isExpanded: Binding to control expanded state.
    ///   - header: A view builder for the header content.
    ///   - content: A view builder for the expandable content.
    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = isExpanded
        self.header = header()
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            headerSection
            expandableContent
        }
        .background(style.resolvedBackgroundColor(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius.value))
        .overlay(borderOverlay)
        .shadow(resolveShadowToken(), colorScheme: colorScheme)
        .accessibilityElement(children: .contain)
    }

    // MARK: - Subviews

    private var headerSection: some View {
        Button(action: toggleExpanded) {
            HStack(spacing: Spacing.md) {
                header
                    .frame(maxWidth: .infinity, alignment: .leading)

                disclosureIndicator
            }
            .padding(cardPadding.value)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Expandable section")
        .accessibilityHint(isExpanded ? "Tap to collapse" : "Tap to expand")
        .accessibilityAddTraits(.isButton)
    }

    private var disclosureIndicator: some View {
        Image(systemName: "chevron.down")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color(.tertiaryLabel))
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
            .animation(.easeInOut(duration: animationDuration), value: isExpanded)
    }

    @ViewBuilder
    private var expandableContent: some View {
        if isExpanded {
            VStack(spacing: 0) {
                Divider()
                    .padding(.horizontal, cardPadding.value)

                content
                    .padding(cardPadding.value)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
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

    private func toggleExpanded() {
        if hapticFeedback {
            #if os(iOS)
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            #endif
        }

        withAnimation(.easeInOut(duration: animationDuration)) {
            isExpanded.toggle()
        }
    }

    // MARK: - Modifiers

    /// Sets the visual style of the card.
    public func style(_ style: CardStyle) -> DSExpandableCard {
        var card = self
        card.style = style
        return card
    }

    /// Sets the internal padding of the card.
    public func cardPadding(_ padding: CardPadding) -> DSExpandableCard {
        var card = self
        card.cardPadding = padding
        return card
    }

    /// Sets the corner radius of the card.
    public func cornerRadius(_ radius: CardCornerRadius) -> DSExpandableCard {
        var card = self
        card.cornerRadius = radius
        return card
    }

    /// Sets the shadow level for elevated cards.
    public func shadowLevel(_ level: CardShadowLevel) -> DSExpandableCard {
        var card = self
        card.shadowLevel = level
        return card
    }

    /// Sets the animation duration for expand/collapse.
    public func animationDuration(_ duration: Double) -> DSExpandableCard {
        var card = self
        card.animationDuration = duration
        return card
    }

    /// Enables or disables haptic feedback.
    public func hapticFeedback(_ enabled: Bool) -> DSExpandableCard {
        var card = self
        card.hapticFeedback = enabled
        return card
    }
}

// MARK: - Convenience Initializer with Title

public extension DSExpandableCard where Header == DSExpandableCardTitleHeader {
    /// Creates a new DSExpandableCard with a simple title header.
    /// - Parameters:
    ///   - title: The header title text.
    ///   - subtitle: Optional subtitle text.
    ///   - isExpanded: Binding to control expanded state.
    ///   - content: A view builder for the expandable content.
    init(
        title: String,
        subtitle: String? = nil,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = isExpanded
        self.header = DSExpandableCardTitleHeader(title: title, subtitle: subtitle)
        self.content = content()
    }
}

// MARK: - Title Header View

/// Default header view for expandable cards with title and subtitle
public struct DSExpandableCardTitleHeader: View {
    let title: String
    let subtitle: String?

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSExpandableCard_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var isExpanded1 = false
        @State private var isExpanded2 = true
        @State private var isExpanded3 = false
        @State private var isExpanded4 = false

        var body: some View {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    sectionHeader("Expandable Cards")

                    DSExpandableCard(
                        title: "Collapsed Card",
                        subtitle: "Tap to expand",
                        isExpanded: $isExpanded1
                    ) {
                        Text("This is the expandable content. It can contain any SwiftUI views like text, images, lists, or custom components.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .style(.elevated)

                    DSExpandableCard(
                        title: "Expanded Card",
                        subtitle: "Tap to collapse",
                        isExpanded: $isExpanded2
                    ) {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("Expanded Content")
                                .font(.headline)
                            Text("This card starts in the expanded state.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Item completed")
                            }
                        }
                    }
                    .style(.elevated)

                    Divider()

                    sectionHeader("Style Variants")

                    DSExpandableCard(
                        title: "Outlined Style",
                        isExpanded: $isExpanded3
                    ) {
                        Text("Content with outlined card style")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .style(.outlined)

                    DSExpandableCard(
                        title: "Filled Style",
                        isExpanded: $isExpanded4
                    ) {
                        Text("Content with filled background")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .style(.filled)

                    Divider()

                    sectionHeader("Custom Header")

                    CustomHeaderExample()
                }
                .padding()
            }
        }

        func sectionHeader(_ title: String) -> some View {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    struct CustomHeaderExample: View {
        @State private var isExpanded = false

        var body: some View {
            DSExpandableCard(isExpanded: $isExpanded) {
                HStack(spacing: Spacing.md) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title2)

                    VStack(alignment: .leading) {
                        Text("Custom Header")
                            .font(.headline)
                        Text("With icon and custom layout")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } content: {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(1...3, id: \.self) { index in
                        HStack {
                            Image(systemName: "\(index).circle.fill")
                            Text("Item \(index)")
                        }
                    }
                }
            }
            .style(.elevated)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("Light Mode")

        PreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
#endif

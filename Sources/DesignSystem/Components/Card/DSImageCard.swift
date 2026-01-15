import SwiftUI

// MARK: - Image Card Aspect Ratio

/// Defines the aspect ratio for the image in DSImageCard
public enum ImageCardAspectRatio: String, CaseIterable, Sendable {
    case square        // 1:1
    case landscape     // 16:9
    case portrait      // 3:4
    case wide          // 2:1
    case custom

    /// Returns the aspect ratio value
    public var value: CGFloat {
        switch self {
        case .square: return 1.0
        case .landscape: return 16.0 / 9.0
        case .portrait: return 3.0 / 4.0
        case .wide: return 2.0 / 1.0
        case .custom: return 1.0
        }
    }
}

// MARK: - Image Card Layout

/// Defines where the image is positioned in the card
public enum ImageCardLayout: String, CaseIterable, Sendable {
    case top       // Image at top, content below
    case bottom    // Content at top, image below
    case leading   // Image on left side (horizontal)
    case trailing  // Image on right side (horizontal)
}

// MARK: - DSImageCard

/// A card component with an image header and text content.
///
/// DSImageCard provides:
/// - Image at top with configurable aspect ratio
/// - Title and subtitle text
/// - Optional footer content
/// - Image loading placeholder
/// - Maintains aspect ratio automatically
///
/// Example usage:
/// ```swift
/// DSImageCard(
///     image: Image("product"),
///     title: "Product Name",
///     subtitle: "Product description"
/// )
/// .aspectRatio(.landscape)
/// .style(.elevated)
/// ```
public struct DSImageCard: View {
    // MARK: - Properties

    private let image: Image?
    private let imageURL: URL?
    private let title: String
    private let subtitle: String?
    private var style: CardStyle = .elevated
    private var cornerRadius: CardCornerRadius = .medium
    private var shadowLevel: CardShadowLevel = .small
    private var aspectRatio: ImageCardAspectRatio = .landscape
    private var customAspectRatio: CGFloat?
    private var layout: ImageCardLayout = .top
    private var imageContentMode: ContentMode = .fill
    private var onTap: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a new DSImageCard with an Image.
    /// - Parameters:
    ///   - image: The image to display.
    ///   - title: The card title.
    ///   - subtitle: An optional subtitle.
    public init(
        image: Image,
        title: String,
        subtitle: String? = nil
    ) {
        self.image = image
        self.imageURL = nil
        self.title = title
        self.subtitle = subtitle
    }

    /// Creates a new DSImageCard with an image URL for async loading.
    /// - Parameters:
    ///   - imageURL: The URL of the image to load.
    ///   - title: The card title.
    ///   - subtitle: An optional subtitle.
    public init(
        imageURL: URL,
        title: String,
        subtitle: String? = nil
    ) {
        self.image = nil
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
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
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPressed)
            } else {
                cardContent
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(onTap != nil ? .isButton : [])
    }

    // MARK: - Subviews

    @ViewBuilder
    private var cardContent: some View {
        switch layout {
        case .top, .bottom:
            verticalLayout
        case .leading, .trailing:
            horizontalLayout
        }
    }

    private var verticalLayout: some View {
        VStack(alignment: .leading, spacing: 0) {
            if layout == .top {
                imageSection
                textSection
            } else {
                textSection
                imageSection
            }
        }
        .background(style.resolvedBackgroundColor(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius.value))
        .overlay(borderOverlay)
        .shadow(resolveShadowToken(), colorScheme: colorScheme)
    }

    private var horizontalLayout: some View {
        HStack(alignment: .top, spacing: 0) {
            if layout == .leading {
                horizontalImageSection
                textSection
            } else {
                textSection
                horizontalImageSection
            }
        }
        .background(style.resolvedBackgroundColor(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius.value))
        .overlay(borderOverlay)
        .shadow(resolveShadowToken(), colorScheme: colorScheme)
    }

    private var imageSection: some View {
        imageView
            .aspectRatio(resolvedAspectRatio, contentMode: .fit)
            .clipped()
    }

    private var horizontalImageSection: some View {
        imageView
            .frame(width: 120)
            .aspectRatio(1, contentMode: .fit)
            .clipped()
    }

    @ViewBuilder
    private var imageView: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: imageContentMode)
        } else if let imageURL = imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    imagePlaceholder
                case .success(let loadedImage):
                    loadedImage
                        .resizable()
                        .aspectRatio(contentMode: imageContentMode)
                case .failure:
                    imageErrorPlaceholder
                @unknown default:
                    imagePlaceholder
                }
            }
        } else {
            imagePlaceholder
        }
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .overlay(
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            )
    }

    private var imageErrorPlaceholder: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .overlay(
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundColor(.secondary)
            )
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            RoundedRectangle(cornerRadius: cornerRadius.value)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        }
    }

    // MARK: - Helpers

    private var resolvedAspectRatio: CGFloat {
        customAspectRatio ?? aspectRatio.value
    }

    private func resolveShadowToken() -> ShadowToken {
        guard style == .elevated else { return .none }
        return isPressed ? .none : shadowLevel.shadowToken
    }

    private var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = true
                }
            }
            .onEnded { _ in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
            }
    }

    private func handleTap() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
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
    public func style(_ style: CardStyle) -> DSImageCard {
        var card = self
        card.style = style
        return card
    }

    /// Sets the corner radius of the card.
    public func cornerRadius(_ radius: CardCornerRadius) -> DSImageCard {
        var card = self
        card.cornerRadius = radius
        return card
    }

    /// Sets the shadow level for elevated cards.
    public func shadowLevel(_ level: CardShadowLevel) -> DSImageCard {
        var card = self
        card.shadowLevel = level
        return card
    }

    /// Sets the aspect ratio of the image.
    public func aspectRatio(_ ratio: ImageCardAspectRatio) -> DSImageCard {
        var card = self
        card.aspectRatio = ratio
        return card
    }

    /// Sets a custom aspect ratio for the image.
    public func customAspectRatio(_ ratio: CGFloat) -> DSImageCard {
        var card = self
        card.customAspectRatio = ratio
        return card
    }

    /// Sets the layout direction of the card.
    public func layout(_ layout: ImageCardLayout) -> DSImageCard {
        var card = self
        card.layout = layout
        return card
    }

    /// Sets how the image fills its container.
    public func imageContentMode(_ mode: ContentMode) -> DSImageCard {
        var card = self
        card.imageContentMode = mode
        return card
    }

    /// Sets a tap action to make the card interactive.
    public func onTap(_ action: @escaping () -> Void) -> DSImageCard {
        var card = self
        card.onTap = action
        return card
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSImageCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                sectionHeader("Image Card Variants")

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Landscape Image Card",
                    subtitle: "16:9 aspect ratio with title and subtitle"
                )
                .aspectRatio(.landscape)
                .style(.elevated)

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Square Image Card",
                    subtitle: "1:1 aspect ratio"
                )
                .aspectRatio(.square)
                .style(.elevated)

                Divider()

                sectionHeader("Aspect Ratios")

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Wide Ratio",
                    subtitle: "2:1 aspect ratio"
                )
                .aspectRatio(.wide)
                .style(.outlined)

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Portrait Ratio",
                    subtitle: "3:4 aspect ratio"
                )
                .aspectRatio(.portrait)
                .style(.outlined)

                Divider()

                sectionHeader("Horizontal Layout")

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Leading Image",
                    subtitle: "Image on the left side"
                )
                .layout(.leading)
                .style(.elevated)

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Trailing Image",
                    subtitle: "Image on the right side"
                )
                .layout(.trailing)
                .style(.elevated)

                Divider()

                sectionHeader("Interactive")

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Tappable Card",
                    subtitle: "Tap to interact"
                )
                .style(.elevated)
                .onTap {
                    print("Card tapped!")
                }
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: Spacing.lg) {
                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Dark Mode Card",
                    subtitle: "Automatic dark mode support"
                )
                .style(.elevated)

                DSImageCard(
                    image: Image(systemName: "photo.fill"),
                    title: "Outlined Dark",
                    subtitle: "Border style in dark mode"
                )
                .style(.outlined)
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

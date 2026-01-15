import SwiftUI

// MARK: - Segment Configuration

/// Configuration model for a segment item
public struct DSSegment<Tag: Hashable>: Identifiable {

    // MARK: - Properties

    /// Unique identifier for the segment
    public let id: Tag

    /// Display title for the segment
    public let title: String

    /// Optional SF Symbol icon name
    public let icon: String?

    /// Whether this segment is disabled
    public let isDisabled: Bool

    // MARK: - Private Properties

    private let accessibilityLabelOverride: String?

    // MARK: - Initialization

    /// Creates a segment with title only
    /// - Parameters:
    ///   - tag: Unique identifier for the segment
    ///   - title: Display title for the segment
    ///   - isDisabled: Whether the segment is disabled
    public init(
        _ tag: Tag,
        _ title: String,
        isDisabled: Bool = false
    ) {
        self.id = tag
        self.title = title
        self.icon = nil
        self.isDisabled = isDisabled
        self.accessibilityLabelOverride = nil
    }

    /// Creates a segment with title and icon
    /// - Parameters:
    ///   - tag: Unique identifier for the segment
    ///   - title: Display title for the segment
    ///   - icon: SF Symbol name for the icon
    ///   - isDisabled: Whether the segment is disabled
    public init(
        _ tag: Tag,
        _ title: String,
        icon: String,
        isDisabled: Bool = false
    ) {
        self.id = tag
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.accessibilityLabelOverride = nil
    }

    /// Private initializer for internal use
    private init(
        id: Tag,
        title: String,
        icon: String?,
        isDisabled: Bool,
        accessibilityLabel: String?
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.accessibilityLabelOverride = accessibilityLabel
    }

    /// Creates a segment with icon only (no title)
    /// - Parameters:
    ///   - tag: Unique identifier for the segment
    ///   - icon: SF Symbol name for the icon
    ///   - accessibilityLabel: Accessibility label for VoiceOver
    ///   - isDisabled: Whether the segment is disabled
    public static func iconOnly(
        _ tag: Tag,
        icon: String,
        accessibilityLabel: String,
        isDisabled: Bool = false
    ) -> DSSegment {
        DSSegment(
            id: tag,
            title: "",
            icon: icon,
            isDisabled: isDisabled,
            accessibilityLabel: accessibilityLabel
        )
    }

    // MARK: - Computed Properties

    /// Whether this segment has a title
    public var hasTitle: Bool {
        !title.isEmpty
    }

    /// Whether this segment has an icon
    public var hasIcon: Bool {
        icon != nil
    }

    /// Whether this segment is icon-only
    public var isIconOnly: Bool {
        hasIcon && !hasTitle
    }

    /// Accessibility label for this segment
    public var accessibilityLabel: String {
        accessibilityLabelOverride ?? title
    }
}

// MARK: - Segment View

/// Internal view for rendering a single segment
struct DSSegmentView<Tag: Hashable>: View {

    // MARK: - Properties

    let segment: DSSegment<Tag>
    let isSelected: Bool
    let style: DSSegmentedControlStyle
    let size: DSSegmentedControlSize
    let selectedColor: Color
    let unselectedColor: Color
    let widthMode: DSSegmentWidthMode
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Body

    var body: some View {
        Button(action: {
            if !segment.isDisabled {
                action()
            }
        }) {
            segmentContent
        }
        .buttonStyle(SegmentButtonStyle(isDisabled: segment.isDisabled))
        .disabled(segment.isDisabled)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(segment.accessibilityLabel)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(segment.isDisabled ? "Disabled" : "")
    }

    // MARK: - Segment Content

    @ViewBuilder
    private var segmentContent: some View {
        HStack(spacing: size.iconTextSpacing) {
            if let icon = segment.icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: isSelected ? .semibold : .medium))
            }

            if segment.hasTitle {
                Text(segment.title)
                    .font(size.font)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .lineLimit(1)
            }
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, size.horizontalPadding)
        .frame(height: size.height - DSSegmentedControlConstants.containerPadding * 2)
        .frame(maxWidth: frameWidth)
        .contentShape(Rectangle())
    }

    // MARK: - Computed Properties

    private var foregroundColor: Color {
        if segment.isDisabled {
            return unselectedColor.opacity(0.4)
        }
        return isSelected ? selectedColor : unselectedColor
    }

    private var frameWidth: CGFloat? {
        switch widthMode {
        case .equal:
            return .infinity
        case .dynamic:
            return nil
        case .fixed(let width):
            return width
        }
    }
}

// MARK: - Segment Button Style

private struct SegmentButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed && !isDisabled ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

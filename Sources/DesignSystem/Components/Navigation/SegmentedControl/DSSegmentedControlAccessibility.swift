import SwiftUI

// MARK: - Accessibility Extensions

extension DSSegmentedControl {
    /// Adds accessibility container traits for the segmented control
    public func accessibilityContainer() -> some View {
        self
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Segmented control")
            .accessibilityHint("Swipe left or right to navigate between segments")
    }
}

// MARK: - Accessibility Announcements

/// Utility for accessibility announcements
public enum DSSegmentedControlAccessibility {

    /// Posts an accessibility announcement for segment selection
    /// - Parameter segmentTitle: The title of the selected segment
    public static func announceSelection(_ segmentTitle: String) {
        #if os(iOS)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(
                notification: .announcement,
                argument: "\(segmentTitle) selected"
            )
        }
        #endif
    }

    /// Returns the accessibility value for segment position
    /// - Parameters:
    ///   - index: Current segment index (0-based)
    ///   - total: Total number of segments
    /// - Returns: Formatted position string (e.g., "2 of 3")
    public static func positionValue(index: Int, total: Int) -> String {
        "\(index + 1) of \(total)"
    }
}

// MARK: - Accessible Segment View Modifier

/// View modifier to enhance segment accessibility
struct SegmentAccessibilityModifier: ViewModifier {
    let title: String
    let isSelected: Bool
    let isDisabled: Bool
    let index: Int
    let total: Int

    func body(content: Content) -> some View {
        content
            .accessibilityLabel(title)
            .accessibilityValue(DSSegmentedControlAccessibility.positionValue(index: index, total: total))
            .accessibilityAddTraits(accessibilityTraits)
            .accessibilityRemoveTraits(isDisabled ? .isButton : [])
            .accessibilityHint(accessibilityHint)
    }

    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = .isButton
        if isSelected {
            traits.insert(.isSelected)
        }
        return traits
    }

    private var accessibilityHint: String {
        if isDisabled {
            return "Disabled"
        }
        return isSelected ? "Currently selected" : "Double tap to select"
    }
}

extension View {
    /// Applies accessibility enhancements for a segment
    func segmentAccessibility(
        title: String,
        isSelected: Bool,
        isDisabled: Bool,
        index: Int,
        total: Int
    ) -> some View {
        self.modifier(SegmentAccessibilityModifier(
            title: title,
            isSelected: isSelected,
            isDisabled: isDisabled,
            index: index,
            total: total
        ))
    }
}

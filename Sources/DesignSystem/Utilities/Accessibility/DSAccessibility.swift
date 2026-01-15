import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - DSAccessibility Modifier

/// A comprehensive accessibility modifier for the Design System
/// Provides an easy-to-use API for common accessibility configurations
public struct DSAccessibilityModifier: ViewModifier {
    let label: String?
    let hint: String?
    let value: String?
    let traits: AccessibilityTraits
    let identifier: String?
    let isHidden: Bool
    let sortPriority: Double?

    public init(
        label: String? = nil,
        hint: String? = nil,
        value: String? = nil,
        traits: AccessibilityTraits = [],
        identifier: String? = nil,
        isHidden: Bool = false,
        sortPriority: Double? = nil
    ) {
        self.label = label
        self.hint = hint
        self.value = value
        self.traits = traits
        self.identifier = identifier
        self.isHidden = isHidden
        self.sortPriority = sortPriority
    }

    public func body(content: Content) -> some View {
        content
            .accessibilityHidden(isHidden)
            .modifier(AccessibilityLabelModifier(label: label))
            .modifier(AccessibilityHintModifier(hint: hint))
            .modifier(AccessibilityValueModifier(value: value))
            .accessibilityAddTraits(traits)
            .modifier(AccessibilityIdentifierModifier(identifier: identifier))
            .modifier(AccessibilitySortPriorityModifier(priority: sortPriority))
    }
}

// MARK: - Helper Modifiers

private struct AccessibilityLabelModifier: ViewModifier {
    let label: String?

    func body(content: Content) -> some View {
        if let label = label {
            content.accessibilityLabel(label)
        } else {
            content
        }
    }
}

private struct AccessibilityHintModifier: ViewModifier {
    let hint: String?

    func body(content: Content) -> some View {
        if let hint = hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}

private struct AccessibilityValueModifier: ViewModifier {
    let value: String?

    func body(content: Content) -> some View {
        if let value = value {
            content.accessibilityValue(value)
        } else {
            content
        }
    }
}

private struct AccessibilityIdentifierModifier: ViewModifier {
    let identifier: String?

    func body(content: Content) -> some View {
        if let identifier = identifier {
            content.accessibilityIdentifier(identifier)
        } else {
            content
        }
    }
}

private struct AccessibilitySortPriorityModifier: ViewModifier {
    let priority: Double?

    func body(content: Content) -> some View {
        if let priority = priority {
            content.accessibilitySortPriority(priority)
        } else {
            content
        }
    }
}

// MARK: - View Extension

extension View {
    /// Applies comprehensive accessibility attributes to a view
    /// - Parameters:
    ///   - label: The accessibility label describing the element
    ///   - hint: Additional context about what happens when activating
    ///   - value: The current value of the element
    ///   - traits: Accessibility traits that describe the element's behavior
    ///   - identifier: A unique identifier for UI testing
    ///   - isHidden: Whether to hide from accessibility
    ///   - sortPriority: VoiceOver navigation order priority
    /// - Returns: A view with accessibility attributes applied
    public func dsAccessibility(
        label: String? = nil,
        hint: String? = nil,
        value: String? = nil,
        traits: AccessibilityTraits = [],
        identifier: String? = nil,
        isHidden: Bool = false,
        sortPriority: Double? = nil
    ) -> some View {
        modifier(DSAccessibilityModifier(
            label: label,
            hint: hint,
            value: value,
            traits: traits,
            identifier: identifier,
            isHidden: isHidden,
            sortPriority: sortPriority
        ))
    }

    /// Convenience method for button accessibility
    /// - Parameters:
    ///   - label: The button's accessibility label
    ///   - hint: Description of what the button does
    public func dsButtonAccessibility(
        label: String,
        hint: String? = nil
    ) -> some View {
        dsAccessibility(
            label: label,
            hint: hint,
            traits: .isButton
        )
    }

    /// Convenience method for header accessibility
    /// - Parameter label: The header's accessibility label
    public func dsHeaderAccessibility(label: String) -> some View {
        dsAccessibility(
            label: label,
            traits: .isHeader
        )
    }

    /// Convenience method for link accessibility
    /// - Parameters:
    ///   - label: The link's accessibility label
    ///   - hint: Description of where the link navigates
    public func dsLinkAccessibility(
        label: String,
        hint: String? = nil
    ) -> some View {
        dsAccessibility(
            label: label,
            hint: hint,
            traits: .isLink
        )
    }

    /// Convenience method for image accessibility
    /// - Parameter label: Description of the image content
    public func dsImageAccessibility(label: String) -> some View {
        dsAccessibility(
            label: label,
            traits: .isImage
        )
    }

    /// Marks the view as a container for accessibility grouping
    public func dsAccessibilityContainer() -> some View {
        accessibilityElement(children: .contain)
    }

    /// Groups child elements and uses combined labels
    public func dsAccessibilityGroup() -> some View {
        accessibilityElement(children: .combine)
    }

    /// Hides the view from accessibility
    public func dsAccessibilityHidden() -> some View {
        accessibilityHidden(true)
    }
}

// MARK: - Accessibility Rotor Support

extension View {
    /// Adds custom rotor support for quick navigation
    /// - Parameters:
    ///   - label: The rotor's label
    ///   - entries: The rotor entries to navigate between
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func dsAccessibilityRotor<ID: Hashable>(
        _ label: String,
        entries: [AccessibilityRotorEntry<ID>]
    ) -> some View {
        accessibilityRotor(label) {
            ForEach(entries, id: \.id) { entry in
                entry
            }
        }
    }
}

// MARK: - Accessibility Actions

extension View {
    /// Adds a custom accessibility action
    /// - Parameters:
    ///   - name: The action's name
    ///   - action: The action to perform
    public func dsAccessibilityAction(
        named name: String,
        action: @escaping () -> Void
    ) -> some View {
        accessibilityAction(named: name, action)
    }

    /// Adds increment and decrement actions for adjustable elements
    /// - Parameters:
    ///   - onIncrement: Action when user increments
    ///   - onDecrement: Action when user decrements
    public func dsAccessibilityAdjustable(
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void
    ) -> some View {
        self
            .accessibilityAddTraits(.allowsDirectInteraction)
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    onIncrement()
                case .decrement:
                    onDecrement()
                @unknown default:
                    break
                }
            }
    }
}

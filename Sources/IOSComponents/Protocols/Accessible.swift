import SwiftUI

/// Protocol for components that support accessibility
public protocol Accessible {
    /// The accessibility label for the component
    var accessibilityLabel: String { get }

    /// The accessibility hint for the component
    var accessibilityHint: String? { get }

    /// The accessibility traits for the component
    var accessibilityTraits: AccessibilityTraits { get }

    /// Whether the component is accessible
    var isAccessibilityElement: Bool { get }
}

/// Default implementations for Accessible protocol
public extension Accessible {
    var accessibilityHint: String? { nil }
    var accessibilityTraits: AccessibilityTraits { .none }
    var isAccessibilityElement: Bool { true }
}

/// Accessibility configuration for components
public struct AccessibilityConfiguration {
    public let label: String
    public let hint: String?
    public let traits: AccessibilityTraits
    public let value: String?
    public let isElement: Bool

    public init(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = .none,
        value: String? = nil,
        isElement: Bool = true
    ) {
        self.label = label
        self.hint = hint
        self.traits = traits
        self.value = value
        self.isElement = isElement
    }
}

/// View modifier for applying accessibility configuration
public struct AccessibilityModifier: ViewModifier {
    let configuration: AccessibilityConfiguration

    public func body(content: Content) -> some View {
        content
            .accessibilityLabel(configuration.label)
            .accessibilityHint(configuration.hint ?? "")
            .accessibilityAddTraits(configuration.traits)
            .accessibilityValue(configuration.value ?? "")
            .accessibilityElement(children: configuration.isElement ? .combine : .ignore)
    }
}

public extension View {
    /// Apply accessibility configuration to a view
    func accessible(_ configuration: AccessibilityConfiguration) -> some View {
        modifier(AccessibilityModifier(configuration: configuration))
    }
}

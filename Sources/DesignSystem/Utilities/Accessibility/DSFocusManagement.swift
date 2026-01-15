import SwiftUI

// MARK: - Focus Management

/// A namespace for focus-related accessibility utilities
public enum DSFocusManagement {}

// MARK: - Focus State Wrapper

/// A property wrapper for managing accessibility focus state
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@propertyWrapper
public struct DSAccessibilityFocused<Value: Hashable>: DynamicProperty {
    @AccessibilityFocusState private var focusedValue: Value?

    public var wrappedValue: Value? {
        get { focusedValue }
        nonmutating set { focusedValue = newValue }
    }

    public var projectedValue: AccessibilityFocusState<Value?>.Binding {
        $focusedValue
    }

    public init() {}
}

// MARK: - Focus Request Modifier

/// A modifier that handles focus requests with VoiceOver
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DSFocusRequestModifier<Value: Hashable>: ViewModifier {
    @AccessibilityFocusState var isFocused: Bool

    let shouldFocus: Bool
    let onFocusChange: ((Bool) -> Void)?

    public func body(content: Content) -> some View {
        content
            .accessibilityFocused($isFocused)
            .onChange(of: shouldFocus) { newValue in
                isFocused = newValue
            }
            .onChange(of: isFocused) { newValue in
                onFocusChange?(newValue)
            }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Makes the view focusable for accessibility and controls focus programmatically
    /// - Parameters:
    ///   - shouldFocus: Whether the view should be focused
    ///   - onFocusChange: Callback when focus state changes
    public func dsAccessibilityFocusRequest(
        _ shouldFocus: Bool,
        onFocusChange: ((Bool) -> Void)? = nil
    ) -> some View {
        modifier(DSFocusRequestModifier<Int>(
            shouldFocus: shouldFocus,
            onFocusChange: onFocusChange
        ))
    }
}

// MARK: - Focus Order Modifier

/// A modifier that sets the accessibility focus order
public struct DSFocusOrderModifier: ViewModifier {
    let priority: Double

    public func body(content: Content) -> some View {
        content
            .accessibilitySortPriority(priority)
    }
}

extension View {
    /// Sets the accessibility focus order priority
    /// Higher values are focused first
    /// - Parameter priority: The focus priority
    public func dsFocusOrder(_ priority: Double) -> some View {
        modifier(DSFocusOrderModifier(priority: priority))
    }

    /// Sets the accessibility focus order using predefined levels
    /// - Parameter level: The focus level
    public func dsFocusOrder(_ level: DSFocusLevel) -> some View {
        dsFocusOrder(level.priority)
    }
}

// MARK: - Focus Level

/// Predefined focus priority levels
public enum DSFocusLevel {
    /// Critical elements that should be focused first
    case critical
    /// High priority elements
    case high
    /// Normal priority (default)
    case normal
    /// Low priority elements
    case low
    /// Elements that should be focused last
    case last

    var priority: Double {
        switch self {
        case .critical: return 1000
        case .high: return 100
        case .normal: return 0
        case .low: return -100
        case .last: return -1000
        }
    }
}

// MARK: - Focus Container

/// A container that manages focus within a group of elements
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DSFocusContainer<Content: View, ID: Hashable>: View {
    @AccessibilityFocusState private var focusedID: ID?

    @Binding var currentFocus: ID?
    let content: (Binding<ID?>) -> Content

    public init(
        focus: Binding<ID?>,
        @ViewBuilder content: @escaping (Binding<ID?>) -> Content
    ) {
        self._currentFocus = focus
        self.content = content
    }

    public var body: some View {
        content($focusedID)
            .onChange(of: focusedID) { newValue in
                currentFocus = newValue
            }
            .onChange(of: currentFocus) { newValue in
                focusedID = newValue
            }
    }
}

// MARK: - Focus Trap

/// A modifier that traps focus within a container (useful for modals)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DSFocusTrapModifier: ViewModifier {
    let isActive: Bool

    public func body(content: Content) -> some View {
        content
            .accessibilityElement(children: isActive ? .contain : .combine)
            .accessibilityAddTraits(isActive ? .isModal : [])
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Traps accessibility focus within this view when active
    /// - Parameter isActive: Whether the focus trap is active
    public func dsFocusTrap(_ isActive: Bool) -> some View {
        modifier(DSFocusTrapModifier(isActive: isActive))
    }
}

// MARK: - Skip Link

/// A hidden link that allows VoiceOver users to skip content
public struct DSSkipLink: View {
    let label: String
    let action: () -> Void

    public init(label: String = "Skip to main content", action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
        }
        .accessibilityAddTraits(.isLink)
        .accessibilitySortPriority(Double.greatestFiniteMagnitude)
        .frame(width: 1, height: 1)
        .opacity(0.01)
    }
}

// MARK: - Focus Ring Modifier

/// A modifier that adds a visible focus ring for accessibility
public struct DSFocusRingModifier: ViewModifier {
    let isFocused: Bool
    let color: Color
    let width: CGFloat

    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: isFocused ? width : 0)
                    .animation(.easeInOut(duration: 0.1), value: isFocused)
            )
    }
}

extension View {
    /// Adds a visible focus ring when the element is focused
    /// - Parameters:
    ///   - isFocused: Whether the element is focused
    ///   - color: The focus ring color
    ///   - width: The focus ring width
    public func dsFocusRing(
        _ isFocused: Bool,
        color: Color = .accentColor,
        width: CGFloat = 2
    ) -> some View {
        modifier(DSFocusRingModifier(
            isFocused: isFocused,
            color: color,
            width: width
        ))
    }
}

// MARK: - First Responder Request

/// Utility for programmatically requesting first responder status
public enum DSFirstResponder {
    #if os(iOS)
    /// Requests first responder status for a view
    /// - Parameter view: The UIView to become first responder
    public static func request(_ view: UIView) {
        DispatchQueue.main.async {
            view.becomeFirstResponder()
        }
    }

    /// Resigns first responder from the current view
    public static func resign() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
    #endif
}

// MARK: - Focus After Delay

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Requests focus after a delay (useful for appearing views)
    /// - Parameters:
    ///   - binding: The focus state binding
    ///   - value: The value to set
    ///   - delay: The delay before focusing
    public func dsFocusAfterDelay<Value: Hashable>(
        _ binding: AccessibilityFocusState<Value?>.Binding,
        value: Value,
        delay: TimeInterval = 0.5
    ) -> some View {
        onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                binding.wrappedValue = value
            }
        }
    }
}

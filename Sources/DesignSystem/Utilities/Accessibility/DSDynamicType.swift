import SwiftUI

// MARK: - Dynamic Type Support

/// A property wrapper that provides scaled metrics based on Dynamic Type settings
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper
public struct DSDynamicMetric: DynamicProperty {
    @ScaledMetric private var scaledValue: CGFloat

    public var wrappedValue: CGFloat {
        scaledValue
    }

    /// Creates a dynamic metric with a base value
    /// - Parameters:
    ///   - wrappedValue: The base value at default text size
    ///   - relativeTo: The text style to scale relative to
    public init(wrappedValue: CGFloat, relativeTo textStyle: Font.TextStyle = .body) {
        _scaledValue = ScaledMetric(wrappedValue: wrappedValue, relativeTo: textStyle)
    }
}

// MARK: - Dynamic Type Size Range Modifier

/// A modifier that constrains dynamic type size within a range
public struct DSDynamicTypeSizeModifier: ViewModifier {
    let minSize: DynamicTypeSize
    let maxSize: DynamicTypeSize

    public func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            content
                .dynamicTypeSize(minSize ... maxSize)
        } else {
            content
        }
    }
}

extension View {
    /// Constrains the dynamic type size to a specific range
    /// - Parameters:
    ///   - min: Minimum dynamic type size
    ///   - max: Maximum dynamic type size
    /// - Returns: A view with constrained dynamic type size
    public func dsDynamicTypeSize(
        _ min: DynamicTypeSize = .xSmall,
        _ max: DynamicTypeSize = .accessibility5
    ) -> some View {
        modifier(DSDynamicTypeSizeModifier(minSize: min, maxSize: max))
    }

    /// Applies standard dynamic type range for body text
    /// Limits maximum size to prevent extreme scaling issues
    public func dsDynamicTypeStandard() -> some View {
        dsDynamicTypeSize(.xSmall, .accessibility3)
    }

    /// Applies a compact dynamic type range
    /// Useful for fixed-height UI elements
    public func dsDynamicTypeCompact() -> some View {
        dsDynamicTypeSize(.xSmall, .xxxLarge)
    }
}

// MARK: - Dynamic Type Observer

/// An observable object that tracks the current dynamic type size
public final class DSDynamicTypeObserver: ObservableObject {
    @Published public private(set) var currentSize: ContentSizeCategory = .medium
    @Published public private(set) var isAccessibilitySize: Bool = false

    public static let shared = DSDynamicTypeObserver()

    private init() {
        updateSize()

        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
        #endif
    }

    deinit {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self)
        #endif
    }

    #if os(iOS)
    @objc private func contentSizeCategoryDidChange() {
        updateSize()
    }
    #endif

    private func updateSize() {
        #if os(iOS)
        let category = UIApplication.shared.preferredContentSizeCategory
        DispatchQueue.main.async {
            self.currentSize = ContentSizeCategory(category)
            self.isAccessibilitySize = category.isAccessibilityCategory
        }
        #endif
    }
}

// MARK: - ContentSizeCategory Extensions

extension ContentSizeCategory {
    /// Returns the scale factor for this size category
    public var scaleFactor: CGFloat {
        switch self {
        case .extraSmall:
            return 0.82
        case .small:
            return 0.88
        case .medium:
            return 0.94
        case .large:
            return 1.0
        case .extraLarge:
            return 1.12
        case .extraExtraLarge:
            return 1.24
        case .extraExtraExtraLarge:
            return 1.35
        case .accessibilityMedium:
            return 1.64
        case .accessibilityLarge:
            return 1.95
        case .accessibilityExtraLarge:
            return 2.35
        case .accessibilityExtraExtraLarge:
            return 2.76
        case .accessibilityExtraExtraExtraLarge:
            return 3.12
        @unknown default:
            return 1.0
        }
    }

    /// Whether this is an accessibility size category
    public var isAccessibilityCategory: Bool {
        switch self {
        case .accessibilityMedium,
             .accessibilityLarge,
             .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraExtraExtraLarge:
            return true
        default:
            return false
        }
    }

    #if os(iOS)
    /// Initializes from UIContentSizeCategory
    public init(_ uiCategory: UIContentSizeCategory) {
        switch uiCategory {
        case .extraSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .extraLarge:
            self = .extraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        default:
            self = .large
        }
    }
    #endif
}

// MARK: - Scaled Value Helper

/// A view modifier that scales a value based on dynamic type
public struct DSScaledValueModifier<V: BinaryFloatingPoint>: ViewModifier {
    @Environment(\.sizeCategory) private var sizeCategory

    let baseValue: V
    let minimumValue: V?
    let maximumValue: V?
    let apply: (V) -> Void

    public func body(content: Content) -> some View {
        content
            .onAppear {
                apply(scaledValue)
            }
            .onChange(of: sizeCategory) { _ in
                apply(scaledValue)
            }
    }

    private var scaledValue: V {
        let scaled = baseValue * V(sizeCategory.scaleFactor)

        if let min = minimumValue, scaled < min {
            return min
        }

        if let max = maximumValue, scaled > max {
            return max
        }

        return scaled
    }
}

extension View {
    /// Applies a scaled value based on dynamic type settings
    /// - Parameters:
    ///   - baseValue: The base value at default size
    ///   - min: Optional minimum value
    ///   - max: Optional maximum value
    ///   - apply: Closure to apply the scaled value
    public func dsScaledValue<V: BinaryFloatingPoint>(
        _ baseValue: V,
        min: V? = nil,
        max: V? = nil,
        apply: @escaping (V) -> Void
    ) -> some View {
        modifier(DSScaledValueModifier(
            baseValue: baseValue,
            minimumValue: min,
            maximumValue: max,
            apply: apply
        ))
    }
}

// MARK: - Dynamic Type Aware Container

/// A container view that adapts its layout based on dynamic type size
public struct DSDynamicTypeContainer<Content: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let content: (Bool) -> Content

    /// Creates a dynamic type aware container
    /// - Parameter content: A view builder that receives whether accessibility sizes are active
    public init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }

    public var body: some View {
        content(sizeCategory.isAccessibilityCategory)
    }
}

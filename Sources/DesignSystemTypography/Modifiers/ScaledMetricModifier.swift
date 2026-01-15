import SwiftUI

// MARK: - Scaled Metric for Typography

/// Property wrapper for Dynamic Type-aware values
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper
public struct DSScaledMetric<Value: BinaryFloatingPoint>: DynamicProperty {
    @ScaledMetric private var scaledValue: Value

    public var wrappedValue: Value {
        scaledValue
    }

    public init(wrappedValue: Value, relativeTo textStyle: Font.TextStyle = .body) {
        _scaledValue = ScaledMetric(wrappedValue: wrappedValue, relativeTo: textStyle)
    }

    public init(wrappedValue: Value, relativeTo scale: FontScale) {
        _scaledValue = ScaledMetric(wrappedValue: wrappedValue, relativeTo: scale.textStyle)
    }
}

// MARK: - Dynamic Type Environment Reader

/// Environment key for reading scaled typography values
public struct ScaledTypographyKey: EnvironmentKey {
    public static let defaultValue: ScaledTypography = ScaledTypography()
}

extension EnvironmentValues {
    public var scaledTypography: ScaledTypography {
        get { self[ScaledTypographyKey.self] }
        set { self[ScaledTypographyKey.self] = newValue }
    }
}

/// Container for scaled typography values
public struct ScaledTypography: Sendable {
    public let baseMultiplier: CGFloat

    public init(baseMultiplier: CGFloat = 1.0) {
        self.baseMultiplier = baseMultiplier
    }

    /// Scale a size value based on the current multiplier
    public func scaled(_ value: CGFloat) -> CGFloat {
        value * baseMultiplier
    }

    /// Get scaled font size for a scale
    public func fontSize(for scale: FontScale) -> CGFloat {
        scaled(scale.defaultSize)
    }

    /// Get scaled line height for a scale
    public func lineHeight(for scale: FontScale) -> CGFloat {
        scaled(scale.defaultSize * scale.lineHeightMultiplier)
    }
}

// MARK: - Maximum Lines Modifier

/// Modifier to limit text to a maximum number of lines with truncation
public struct MaxLinesModifier: ViewModifier {
    public let maxLines: Int
    public let truncationMode: Text.TruncationMode
    public let reservesSpace: Bool

    public init(
        maxLines: Int,
        truncationMode: Text.TruncationMode = .tail,
        reservesSpace: Bool = false
    ) {
        self.maxLines = maxLines
        self.truncationMode = truncationMode
        self.reservesSpace = reservesSpace
    }

    public func body(content: Content) -> some View {
        content
            .lineLimit(maxLines)
            .truncationMode(truncationMode)
            .frame(maxHeight: reservesSpace ? .infinity : nil, alignment: .top)
    }
}

extension View {
    /// Limit text to a maximum number of lines
    public func maxLines(
        _ count: Int,
        truncation: Text.TruncationMode = .tail,
        reservesSpace: Bool = false
    ) -> some View {
        modifier(MaxLinesModifier(
            maxLines: count,
            truncationMode: truncation,
            reservesSpace: reservesSpace
        ))
    }
}

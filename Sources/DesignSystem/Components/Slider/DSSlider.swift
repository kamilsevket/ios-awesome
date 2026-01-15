import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Size Enum

/// Size variants for DSSlider
public enum DSSliderSize: CaseIterable {
    case small
    case medium
    case large

    var trackHeight: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }

    var thumbSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        }
    }

    var tickSize: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
}

// MARK: - Style Enum

/// Style variants for DSSlider
public enum DSSliderStyle {
    case standard
    case filled
    case gradient

    func trackColor(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return DSColors.loadingTrackDark
        default:
            return DSColors.loadingTrack
        }
    }
}

// MARK: - Thumb Style

/// Thumb style configuration for DSSlider
public struct DSSliderThumbStyle {
    public let size: CGFloat
    public let color: Color
    public let borderColor: Color?
    public let borderWidth: CGFloat
    public let shadowRadius: CGFloat
    public let shape: ThumbShape

    public enum ThumbShape {
        case circle
        case roundedSquare
        case custom(AnyShape)
    }

    public init(
        size: CGFloat = 24,
        color: Color = .white,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        shadowRadius: CGFloat = 2,
        shape: ThumbShape = .circle
    ) {
        self.size = size
        self.color = color
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shape = shape
    }

    public static let `default` = DSSliderThumbStyle()

    public static let bordered = DSSliderThumbStyle(
        borderColor: DSColors.primary,
        borderWidth: 2
    )

    public static let minimal = DSSliderThumbStyle(
        size: 16,
        shadowRadius: 0
    )
}

// MARK: - AnyShape Helper

public struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path

    public init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    public func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

// MARK: - DSSlider Component

/// A customizable slider component for single value selection.
///
/// Example usage:
/// ```swift
/// DSSlider(value: $volume, range: 0...100)
///     .step(10)
///     .showValueLabel()
///     .tintColor(.blue)
///
/// DSSlider(value: $brightness)
///     .size(.large)
///     .showTicks()
///     .hapticFeedback(true)
/// ```
public struct DSSlider: View {
    // MARK: - Properties

    @Binding private var value: Double
    private let range: ClosedRange<Double>

    private var size: DSSliderSize = .medium
    private var style: DSSliderStyle = .standard
    private var tintColor: Color = DSColors.primary
    private var step: Double?
    private var showValueLabel: Bool = false
    private var valueLabelFormat: (Double) -> String = { String(format: "%.0f", $0) }
    private var showTicks: Bool = false
    private var showMinMaxLabels: Bool = false
    private var minLabel: String?
    private var maxLabel: String?
    private var isDisabled: Bool = false
    private var hapticFeedbackEnabled: Bool = true
    private var thumbStyle: DSSliderThumbStyle = .default
    private var onValueChanged: ((Double) -> Void)?
    private var gradientColors: [Color]?

    // MARK: - State

    @State private var isDragging: Bool = false
    @State private var lastStepValue: Double = 0
    @GestureState private var dragOffset: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a slider with the specified value binding and range.
    /// - Parameters:
    ///   - value: Binding to the current value.
    ///   - range: The range of valid values (default 0...1).
    public init(value: Binding<Double>, range: ClosedRange<Double> = 0...1) {
        self._value = value
        self.range = range
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: DSSpacing.xs) {
            // Value label
            if showValueLabel {
                valueLabel
            }

            // Slider
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track background
                    trackBackground

                    // Filled track
                    filledTrack(width: geometry.size.width)

                    // Tick marks
                    if showTicks, let step = step {
                        tickMarks(width: geometry.size.width, step: step)
                    }

                    // Thumb
                    thumb(width: geometry.size.width)
                }
                .frame(height: max(size.thumbSize, size.trackHeight))
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            handleDragChange(gesture: gesture, width: geometry.size.width)
                        }
                        .onEnded { _ in
                            handleDragEnd()
                        }
                )
            }
            .frame(height: max(size.thumbSize, DSSpacing.minTouchTarget))

            // Min/Max labels
            if showMinMaxLabels {
                minMaxLabels
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .allowsHitTesting(!isDisabled)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityAdjustableAction { direction in
            handleAccessibilityAdjustment(direction: direction)
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var valueLabel: some View {
        Text(valueLabelFormat(value))
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(isDragging ? tintColor : .primary)
            .animation(.easeInOut(duration: 0.15), value: isDragging)
    }

    @ViewBuilder
    private var trackBackground: some View {
        Capsule()
            .fill(style.trackColor(colorScheme: colorScheme))
            .frame(height: size.trackHeight)
    }

    @ViewBuilder
    private func filledTrack(width: CGFloat) -> some View {
        let fillWidth = calculateThumbPosition(width: width)

        Group {
            switch style {
            case .gradient:
                if let colors = gradientColors, colors.count >= 2 {
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [tintColor.opacity(0.7), tintColor]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
            default:
                tintColor
            }
        }
        .frame(width: fillWidth, height: size.trackHeight)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private func tickMarks(width: CGFloat, step: Double) -> some View {
        let steps = Int((range.upperBound - range.lowerBound) / step)

        HStack(spacing: 0) {
            ForEach(0...steps, id: \.self) { index in
                let tickValue = range.lowerBound + Double(index) * step
                let position = CGFloat((tickValue - range.lowerBound) / (range.upperBound - range.lowerBound))

                Circle()
                    .fill(tickValue <= value ? tintColor : style.trackColor(colorScheme: colorScheme))
                    .frame(width: size.tickSize, height: size.tickSize)
                    .position(x: position * width, y: size.thumbSize / 2)
            }
        }
        .frame(height: size.thumbSize)
    }

    @ViewBuilder
    private func thumb(width: CGFloat) -> some View {
        let thumbPosition = calculateThumbPosition(width: width)
        let effectiveThumbSize = thumbStyle.size > 0 ? thumbStyle.size : size.thumbSize

        ZStack {
            thumbShape
                .fill(thumbStyle.color)
                .frame(width: effectiveThumbSize, height: effectiveThumbSize)

            if let borderColor = thumbStyle.borderColor {
                thumbShape
                    .stroke(borderColor, lineWidth: thumbStyle.borderWidth)
                    .frame(width: effectiveThumbSize, height: effectiveThumbSize)
            }
        }
        .shadow(color: .black.opacity(0.15), radius: thumbStyle.shadowRadius, x: 0, y: 1)
        .scaleEffect(isDragging ? 1.15 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
        .position(
            x: max(effectiveThumbSize / 2, min(thumbPosition, width - effectiveThumbSize / 2)),
            y: max(size.thumbSize, DSSpacing.minTouchTarget) / 2
        )
    }

    @ViewBuilder
    private var thumbShape: some Shape {
        switch thumbStyle.shape {
        case .circle:
            Circle()
        case .roundedSquare:
            RoundedRectangle(cornerRadius: 4)
        case .custom(let shape):
            shape
        }
    }

    @ViewBuilder
    private var minMaxLabels: some View {
        HStack {
            Text(minLabel ?? valueLabelFormat(range.lowerBound))
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Text(maxLabel ?? valueLabelFormat(range.upperBound))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Calculations

    private func calculateThumbPosition(width: CGFloat) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(percentage) * width
    }

    private func calculateValue(from position: CGFloat, width: CGFloat) -> Double {
        let percentage = max(0, min(1, Double(position / width)))
        var newValue = range.lowerBound + percentage * (range.upperBound - range.lowerBound)

        if let step = step {
            newValue = round(newValue / step) * step
        }

        return max(range.lowerBound, min(range.upperBound, newValue))
    }

    // MARK: - Gesture Handling

    private func handleDragChange(gesture: DragGesture.Value, width: CGFloat) {
        if !isDragging {
            isDragging = true
            lastStepValue = value
        }

        let newValue = calculateValue(from: gesture.location.x, width: width)

        if newValue != value {
            // Haptic feedback on step changes
            if hapticFeedbackEnabled, let step = step {
                let currentStep = round(value / step)
                let newStep = round(newValue / step)
                if currentStep != newStep {
                    triggerHapticFeedback()
                }
            } else if hapticFeedbackEnabled && abs(newValue - lastStepValue) > (range.upperBound - range.lowerBound) * 0.1 {
                triggerHapticFeedback()
                lastStepValue = newValue
            }

            value = newValue
            onValueChanged?(newValue)
        }
    }

    private func handleDragEnd() {
        isDragging = false
    }

    private func handleAccessibilityAdjustment(direction: AccessibilityAdjustmentDirection) {
        let adjustmentStep = step ?? (range.upperBound - range.lowerBound) / 10

        switch direction {
        case .increment:
            value = min(range.upperBound, value + adjustmentStep)
        case .decrement:
            value = max(range.lowerBound, value - adjustmentStep)
        @unknown default:
            break
        }

        if hapticFeedbackEnabled {
            triggerHapticFeedback()
        }
        onValueChanged?(value)
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        "Slider"
    }

    private var accessibilityValue: String {
        "\(valueLabelFormat(value)), range \(valueLabelFormat(range.lowerBound)) to \(valueLabelFormat(range.upperBound))"
    }
}

// MARK: - Modifiers

public extension DSSlider {
    /// Sets the slider size.
    func size(_ size: DSSliderSize) -> DSSlider {
        var copy = self
        copy.size = size
        return copy
    }

    /// Sets the slider style.
    func style(_ style: DSSliderStyle) -> DSSlider {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the tint color for the filled track.
    func tintColor(_ color: Color) -> DSSlider {
        var copy = self
        copy.tintColor = color
        return copy
    }

    /// Sets the step increment for the slider.
    func step(_ step: Double) -> DSSlider {
        var copy = self
        copy.step = step
        return copy
    }

    /// Shows or hides the value label above the slider.
    func showValueLabel(_ show: Bool = true) -> DSSlider {
        var copy = self
        copy.showValueLabel = show
        return copy
    }

    /// Sets a custom format for the value label.
    func valueLabelFormat(_ format: @escaping (Double) -> String) -> DSSlider {
        var copy = self
        copy.valueLabelFormat = format
        return copy
    }

    /// Shows or hides tick marks at step intervals.
    func showTicks(_ show: Bool = true) -> DSSlider {
        var copy = self
        copy.showTicks = show
        return copy
    }

    /// Shows or hides min/max labels below the slider.
    func showMinMaxLabels(_ show: Bool = true) -> DSSlider {
        var copy = self
        copy.showMinMaxLabels = show
        return copy
    }

    /// Sets custom min label text.
    func minLabel(_ label: String) -> DSSlider {
        var copy = self
        copy.minLabel = label
        return copy
    }

    /// Sets custom max label text.
    func maxLabel(_ label: String) -> DSSlider {
        var copy = self
        copy.maxLabel = label
        return copy
    }

    /// Disables the slider.
    func disabled(_ disabled: Bool) -> DSSlider {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Enables or disables haptic feedback.
    func hapticFeedback(_ enabled: Bool) -> DSSlider {
        var copy = self
        copy.hapticFeedbackEnabled = enabled
        return copy
    }

    /// Sets the thumb style.
    func thumbStyle(_ style: DSSliderThumbStyle) -> DSSlider {
        var copy = self
        copy.thumbStyle = style
        return copy
    }

    /// Sets a callback for value changes.
    func onValueChanged(_ action: @escaping (Double) -> Void) -> DSSlider {
        var copy = self
        copy.onValueChanged = action
        return copy
    }

    /// Sets gradient colors for gradient style.
    func gradientColors(_ colors: [Color]) -> DSSlider {
        var copy = self
        copy.gradientColors = colors
        copy.style = .gradient
        return copy
    }
}

// MARK: - Convenience Initializers

public extension DSSlider {
    /// Creates a slider with an integer value binding.
    init(value: Binding<Int>, range: ClosedRange<Int> = 0...100) {
        self._value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = Int($0) }
        )
        self.range = Double(range.lowerBound)...Double(range.upperBound)
    }

    /// Creates a slider with a float value binding.
    init(value: Binding<Float>, range: ClosedRange<Float> = 0...1) {
        self._value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = Float($0) }
        )
        self.range = Double(range.lowerBound)...Double(range.upperBound)
    }
}

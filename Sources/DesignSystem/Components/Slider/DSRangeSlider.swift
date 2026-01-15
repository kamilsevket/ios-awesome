import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - DSRangeSlider Component

/// A range slider component for selecting a min-max range.
///
/// Example usage:
/// ```swift
/// DSRangeSlider(range: $priceRange, bounds: 0...1000)
///     .step(50)
///     .showValueLabels()
///     .tintColor(.green)
///
/// DSRangeSlider(range: $ageRange, bounds: 18...100)
///     .size(.large)
///     .minDistance(5)
/// ```
public struct DSRangeSlider: View {
    // MARK: - Properties

    @Binding private var range: ClosedRange<Double>
    private let bounds: ClosedRange<Double>

    private var size: DSSliderSize = .medium
    private var style: DSSliderStyle = .standard
    private var tintColor: Color = DSColors.primary
    private var step: Double?
    private var showValueLabels: Bool = false
    private var valueLabelFormat: (Double) -> String = { String(format: "%.0f", $0) }
    private var showTicks: Bool = false
    private var showBoundsLabels: Bool = false
    private var minLabel: String?
    private var maxLabel: String?
    private var isDisabled: Bool = false
    private var hapticFeedbackEnabled: Bool = true
    private var thumbStyle: DSSliderThumbStyle = .default
    private var minDistance: Double = 0
    private var onRangeChanged: ((ClosedRange<Double>) -> Void)?
    private var gradientColors: [Color]?

    // MARK: - State

    @State private var isDraggingLower: Bool = false
    @State private var isDraggingUpper: Bool = false
    @State private var lastLowerStepValue: Double = 0
    @State private var lastUpperStepValue: Double = 0
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a range slider with the specified range binding and bounds.
    /// - Parameters:
    ///   - range: Binding to the current range (lowerBound...upperBound).
    ///   - bounds: The valid bounds for the slider.
    public init(range: Binding<ClosedRange<Double>>, bounds: ClosedRange<Double>) {
        self._range = range
        self.bounds = bounds
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: DSSpacing.xs) {
            // Value labels
            if showValueLabels {
                valueLabels
            }

            // Slider
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track background
                    trackBackground

                    // Filled track (between thumbs)
                    filledTrack(width: geometry.size.width)

                    // Tick marks
                    if showTicks, let step = step {
                        tickMarks(width: geometry.size.width, step: step)
                    }

                    // Lower thumb
                    thumb(
                        position: calculatePosition(for: range.lowerBound, width: geometry.size.width),
                        width: geometry.size.width,
                        isDragging: isDraggingLower,
                        isLower: true
                    )

                    // Upper thumb
                    thumb(
                        position: calculatePosition(for: range.upperBound, width: geometry.size.width),
                        width: geometry.size.width,
                        isDragging: isDraggingUpper,
                        isLower: false
                    )
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

            // Bounds labels
            if showBoundsLabels {
                boundsLabels
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .allowsHitTesting(!isDisabled)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var valueLabels: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Min")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(valueLabelFormat(range.lowerBound))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isDraggingLower ? tintColor : .primary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Max")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(valueLabelFormat(range.upperBound))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isDraggingUpper ? tintColor : .primary)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isDraggingLower)
        .animation(.easeInOut(duration: 0.15), value: isDraggingUpper)
    }

    @ViewBuilder
    private var trackBackground: some View {
        Capsule()
            .fill(style.trackColor(colorScheme: colorScheme))
            .frame(height: size.trackHeight)
    }

    @ViewBuilder
    private func filledTrack(width: CGFloat) -> some View {
        let lowerPosition = calculatePosition(for: range.lowerBound, width: width)
        let upperPosition = calculatePosition(for: range.upperBound, width: width)
        let fillWidth = upperPosition - lowerPosition

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
        .frame(width: max(0, fillWidth), height: size.trackHeight)
        .clipShape(Capsule())
        .offset(x: lowerPosition)
    }

    @ViewBuilder
    private func tickMarks(width: CGFloat, step: Double) -> some View {
        let steps = Int((bounds.upperBound - bounds.lowerBound) / step)

        ZStack {
            ForEach(0...steps, id: \.self) { index in
                let tickValue = bounds.lowerBound + Double(index) * step
                let position = CGFloat((tickValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound))
                let isInRange = tickValue >= range.lowerBound && tickValue <= range.upperBound

                Circle()
                    .fill(isInRange ? tintColor : style.trackColor(colorScheme: colorScheme))
                    .frame(width: size.tickSize, height: size.tickSize)
                    .position(x: position * width, y: size.thumbSize / 2)
            }
        }
        .frame(height: size.thumbSize)
    }

    @ViewBuilder
    private func thumb(position: CGFloat, width: CGFloat, isDragging: Bool, isLower: Bool) -> some View {
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
            x: max(effectiveThumbSize / 2, min(position, width - effectiveThumbSize / 2)),
            y: max(size.thumbSize, DSSpacing.minTouchTarget) / 2
        )
        .zIndex(isDragging ? 1 : 0)
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
    private var boundsLabels: some View {
        HStack {
            Text(minLabel ?? valueLabelFormat(bounds.lowerBound))
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Text(maxLabel ?? valueLabelFormat(bounds.upperBound))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Calculations

    private func calculatePosition(for value: Double, width: CGFloat) -> CGFloat {
        let percentage = (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return CGFloat(percentage) * width
    }

    private func calculateValue(from position: CGFloat, width: CGFloat) -> Double {
        let percentage = max(0, min(1, Double(position / width)))
        var newValue = bounds.lowerBound + percentage * (bounds.upperBound - bounds.lowerBound)

        if let step = step {
            newValue = round(newValue / step) * step
        }

        return max(bounds.lowerBound, min(bounds.upperBound, newValue))
    }

    // MARK: - Gesture Handling

    private func handleDragChange(gesture: DragGesture.Value, width: CGFloat) {
        let touchX = gesture.location.x
        let newValue = calculateValue(from: touchX, width: width)

        let lowerPosition = calculatePosition(for: range.lowerBound, width: width)
        let upperPosition = calculatePosition(for: range.upperBound, width: width)

        // Determine which thumb to move
        let distanceToLower = abs(touchX - lowerPosition)
        let distanceToUpper = abs(touchX - upperPosition)

        // If neither thumb is being dragged, start dragging the closer one
        if !isDraggingLower && !isDraggingUpper {
            if distanceToLower < distanceToUpper {
                isDraggingLower = true
                lastLowerStepValue = range.lowerBound
            } else {
                isDraggingUpper = true
                lastUpperStepValue = range.upperBound
            }
        }

        if isDraggingLower {
            let maxLowerValue = range.upperBound - minDistance
            let clampedValue = min(newValue, maxLowerValue)

            if clampedValue != range.lowerBound {
                // Haptic feedback
                if hapticFeedbackEnabled {
                    checkHapticFeedback(oldValue: range.lowerBound, newValue: clampedValue, lastStepValue: &lastLowerStepValue)
                }

                range = clampedValue...range.upperBound
                onRangeChanged?(range)
            }
        } else if isDraggingUpper {
            let minUpperValue = range.lowerBound + minDistance
            let clampedValue = max(newValue, minUpperValue)

            if clampedValue != range.upperBound {
                // Haptic feedback
                if hapticFeedbackEnabled {
                    checkHapticFeedback(oldValue: range.upperBound, newValue: clampedValue, lastStepValue: &lastUpperStepValue)
                }

                range = range.lowerBound...clampedValue
                onRangeChanged?(range)
            }
        }
    }

    private func handleDragEnd() {
        isDraggingLower = false
        isDraggingUpper = false
    }

    private func checkHapticFeedback(oldValue: Double, newValue: Double, lastStepValue: inout Double) {
        if let step = step {
            let oldStep = round(oldValue / step)
            let newStep = round(newValue / step)
            if oldStep != newStep {
                triggerHapticFeedback()
            }
        } else if abs(newValue - lastStepValue) > (bounds.upperBound - bounds.lowerBound) * 0.1 {
            triggerHapticFeedback()
            lastStepValue = newValue
        }
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        "Range slider"
    }

    private var accessibilityValue: String {
        "From \(valueLabelFormat(range.lowerBound)) to \(valueLabelFormat(range.upperBound)), bounds \(valueLabelFormat(bounds.lowerBound)) to \(valueLabelFormat(bounds.upperBound))"
    }
}

// MARK: - Modifiers

public extension DSRangeSlider {
    /// Sets the slider size.
    func size(_ size: DSSliderSize) -> DSRangeSlider {
        var copy = self
        copy.size = size
        return copy
    }

    /// Sets the slider style.
    func style(_ style: DSSliderStyle) -> DSRangeSlider {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the tint color for the filled track.
    func tintColor(_ color: Color) -> DSRangeSlider {
        var copy = self
        copy.tintColor = color
        return copy
    }

    /// Sets the step increment for the slider.
    func step(_ step: Double) -> DSRangeSlider {
        var copy = self
        copy.step = step
        return copy
    }

    /// Shows or hides the value labels above the slider.
    func showValueLabels(_ show: Bool = true) -> DSRangeSlider {
        var copy = self
        copy.showValueLabels = show
        return copy
    }

    /// Sets a custom format for the value labels.
    func valueLabelFormat(_ format: @escaping (Double) -> String) -> DSRangeSlider {
        var copy = self
        copy.valueLabelFormat = format
        return copy
    }

    /// Shows or hides tick marks at step intervals.
    func showTicks(_ show: Bool = true) -> DSRangeSlider {
        var copy = self
        copy.showTicks = show
        return copy
    }

    /// Shows or hides bounds labels below the slider.
    func showBoundsLabels(_ show: Bool = true) -> DSRangeSlider {
        var copy = self
        copy.showBoundsLabels = show
        return copy
    }

    /// Sets custom min label text.
    func minLabel(_ label: String) -> DSRangeSlider {
        var copy = self
        copy.minLabel = label
        return copy
    }

    /// Sets custom max label text.
    func maxLabel(_ label: String) -> DSRangeSlider {
        var copy = self
        copy.maxLabel = label
        return copy
    }

    /// Disables the slider.
    func disabled(_ disabled: Bool) -> DSRangeSlider {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Enables or disables haptic feedback.
    func hapticFeedback(_ enabled: Bool) -> DSRangeSlider {
        var copy = self
        copy.hapticFeedbackEnabled = enabled
        return copy
    }

    /// Sets the thumb style.
    func thumbStyle(_ style: DSSliderThumbStyle) -> DSRangeSlider {
        var copy = self
        copy.thumbStyle = style
        return copy
    }

    /// Sets the minimum distance between the two thumbs.
    func minDistance(_ distance: Double) -> DSRangeSlider {
        var copy = self
        copy.minDistance = distance
        return copy
    }

    /// Sets a callback for range changes.
    func onRangeChanged(_ action: @escaping (ClosedRange<Double>) -> Void) -> DSRangeSlider {
        var copy = self
        copy.onRangeChanged = action
        return copy
    }

    /// Sets gradient colors for gradient style.
    func gradientColors(_ colors: [Color]) -> DSRangeSlider {
        var copy = self
        copy.gradientColors = colors
        copy.style = .gradient
        return copy
    }
}

// MARK: - Convenience Initializers

public extension DSRangeSlider {
    /// Creates a range slider with integer range and bounds.
    init(range: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>) {
        self._range = Binding(
            get: { Double(range.wrappedValue.lowerBound)...Double(range.wrappedValue.upperBound) },
            set: { range.wrappedValue = Int($0.lowerBound)...Int($0.upperBound) }
        )
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
    }
}

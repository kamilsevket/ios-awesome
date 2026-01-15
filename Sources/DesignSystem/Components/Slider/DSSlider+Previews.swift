import SwiftUI

#if DEBUG
// MARK: - DSSlider Previews

struct DSSlider_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Basic sliders
                basicSliders

                // Size variants
                sizeVariants

                // Style variants
                styleVariants

                // With features
                withFeatures

                // Thumb styles
                thumbStyles

                // Custom colors
                customColors

                // Disabled state
                disabledState
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 32) {
                basicSliders
                styleVariants
                customColors
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }

    @ViewBuilder
    static var basicSliders: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Sliders")
                .font(.headline)

            SliderPreviewWrapper(initialValue: 0.5) { value in
                DSSlider(value: value)
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
            }

            SliderPreviewWrapper(initialValue: 25) { value in
                DSSlider(value: value, range: 0...100)
                    .showValueLabel()
            }
        }
    }

    @ViewBuilder
    static var sizeVariants: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Size Variants")
                .font(.headline)

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .size(.small)
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .size(.medium)
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .size(.large)
            }
        }
    }

    @ViewBuilder
    static var styleVariants: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Variants")
                .font(.headline)

            SliderPreviewWrapper(initialValue: 60) { value in
                DSSlider(value: value, range: 0...100)
                    .style(.standard)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 60) { value in
                DSSlider(value: value, range: 0...100)
                    .style(.filled)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 60) { value in
                DSSlider(value: value, range: 0...100)
                    .style(.gradient)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 60) { value in
                DSSlider(value: value, range: 0...100)
                    .gradientColors([.purple, .pink, .orange])
                    .showValueLabel()
            }
        }
    }

    @ViewBuilder
    static var withFeatures: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("With Features")
                .font(.headline)

            // Step slider
            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .step(10)
                    .showTicks()
                    .showValueLabel()
            }

            // With min/max labels
            SliderPreviewWrapper(initialValue: 30) { value in
                DSSlider(value: value, range: 0...100)
                    .showValueLabel()
                    .showMinMaxLabels()
            }

            // Custom labels
            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .showValueLabel()
                    .valueLabelFormat { "\(Int($0))%" }
                    .showMinMaxLabels()
                    .minLabel("Silent")
                    .maxLabel("Loud")
            }

            // Step with custom format
            SliderPreviewWrapper(initialValue: 25) { value in
                DSSlider(value: value, range: 0...100)
                    .step(25)
                    .showTicks()
                    .showValueLabel()
                    .valueLabelFormat { value in
                        switch Int(value) {
                        case 0: return "Off"
                        case 25: return "Low"
                        case 50: return "Medium"
                        case 75: return "High"
                        case 100: return "Max"
                        default: return "\(Int(value))"
                        }
                    }
            }
        }
    }

    @ViewBuilder
    static var thumbStyles: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thumb Styles")
                .font(.headline)

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .thumbStyle(.default)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .thumbStyle(.bordered)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .thumbStyle(.minimal)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .thumbStyle(DSSliderThumbStyle(
                        size: 28,
                        color: DSColors.primary,
                        borderColor: .white,
                        borderWidth: 3,
                        shadowRadius: 4,
                        shape: .circle
                    ))
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .thumbStyle(DSSliderThumbStyle(
                        size: 24,
                        color: .white,
                        borderColor: DSColors.success,
                        borderWidth: 2,
                        shape: .roundedSquare
                    ))
                    .tintColor(DSColors.success)
                    .showValueLabel()
            }
        }
    }

    @ViewBuilder
    static var customColors: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Colors")
                .font(.headline)

            SliderPreviewWrapper(initialValue: 70) { value in
                DSSlider(value: value, range: 0...100)
                    .tintColor(DSColors.success)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 40) { value in
                DSSlider(value: value, range: 0...100)
                    .tintColor(DSColors.warning)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 80) { value in
                DSSlider(value: value, range: 0...100)
                    .tintColor(DSColors.error)
                    .showValueLabel()
            }

            SliderPreviewWrapper(initialValue: 50) { value in
                DSSlider(value: value, range: 0...100)
                    .tintColor(.purple)
                    .showValueLabel()
            }
        }
    }

    @ViewBuilder
    static var disabledState: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Disabled State")
                .font(.headline)

            SliderPreviewWrapper(initialValue: 60) { value in
                DSSlider(value: value, range: 0...100)
                    .disabled(true)
                    .showValueLabel()
            }
        }
    }
}

// MARK: - DSRangeSlider Previews

struct DSRangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Basic range sliders
                basicRangeSliders

                // Size variants
                sizeVariants

                // Style variants
                styleVariants

                // With features
                withFeatures

                // Custom colors
                customColors

                // Disabled state
                disabledState
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 32) {
                basicRangeSliders
                styleVariants
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }

    @ViewBuilder
    static var basicRangeSliders: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Range Sliders")
                .font(.headline)

            RangeSliderPreviewWrapper(initialRange: 25...75, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
            }

            RangeSliderPreviewWrapper(initialRange: 200...800, bounds: 0...1000) { range in
                DSRangeSlider(range: range, bounds: 0...1000)
                    .showValueLabels()
            }
        }
    }

    @ViewBuilder
    static var sizeVariants: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Size Variants")
                .font(.headline)

            RangeSliderPreviewWrapper(initialRange: 30...70, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .size(.small)
            }

            RangeSliderPreviewWrapper(initialRange: 30...70, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .size(.medium)
            }

            RangeSliderPreviewWrapper(initialRange: 30...70, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .size(.large)
            }
        }
    }

    @ViewBuilder
    static var styleVariants: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Variants")
                .font(.headline)

            RangeSliderPreviewWrapper(initialRange: 25...75, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .style(.standard)
                    .showValueLabels()
            }

            RangeSliderPreviewWrapper(initialRange: 25...75, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .style(.gradient)
                    .showValueLabels()
            }

            RangeSliderPreviewWrapper(initialRange: 25...75, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .gradientColors([.blue, .purple])
                    .showValueLabels()
            }
        }
    }

    @ViewBuilder
    static var withFeatures: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("With Features")
                .font(.headline)

            // Step slider
            RangeSliderPreviewWrapper(initialRange: 20...80, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .step(10)
                    .showTicks()
                    .showValueLabels()
            }

            // With bounds labels
            RangeSliderPreviewWrapper(initialRange: 100...500, bounds: 0...1000) { range in
                DSRangeSlider(range: range, bounds: 0...1000)
                    .showValueLabels()
                    .showBoundsLabels()
                    .valueLabelFormat { "$\(Int($0))" }
            }

            // With min distance
            RangeSliderPreviewWrapper(initialRange: 30...70, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .minDistance(20)
                    .showValueLabels()
            }

            // Price range example
            RangeSliderPreviewWrapper(initialRange: 50...200, bounds: 0...500) { range in
                DSRangeSlider(range: range, bounds: 0...500)
                    .step(10)
                    .showValueLabels()
                    .showBoundsLabels()
                    .valueLabelFormat { "$\(Int($0))" }
                    .minLabel("$0")
                    .maxLabel("$500+")
            }
        }
    }

    @ViewBuilder
    static var customColors: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Colors")
                .font(.headline)

            RangeSliderPreviewWrapper(initialRange: 25...75, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .tintColor(DSColors.success)
                    .showValueLabels()
            }

            RangeSliderPreviewWrapper(initialRange: 30...60, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .tintColor(.orange)
                    .showValueLabels()
            }

            RangeSliderPreviewWrapper(initialRange: 20...80, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .tintColor(.purple)
                    .thumbStyle(.bordered)
                    .showValueLabels()
            }
        }
    }

    @ViewBuilder
    static var disabledState: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Disabled State")
                .font(.headline)

            RangeSliderPreviewWrapper(initialRange: 30...70, bounds: 0...100) { range in
                DSRangeSlider(range: range, bounds: 0...100)
                    .disabled(true)
                    .showValueLabels()
            }
        }
    }
}

// MARK: - Preview Helpers

private struct SliderPreviewWrapper<Content: View>: View {
    @State private var value: Double
    let content: (Binding<Double>) -> Content

    init(initialValue: Double, @ViewBuilder content: @escaping (Binding<Double>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

private struct RangeSliderPreviewWrapper<Content: View>: View {
    @State private var range: ClosedRange<Double>
    let content: (Binding<ClosedRange<Double>>) -> Content

    init(initialRange: ClosedRange<Double>, bounds: ClosedRange<Double>, @ViewBuilder content: @escaping (Binding<ClosedRange<Double>>) -> Content) {
        self._range = State(initialValue: initialRange)
        self.content = content
    }

    var body: some View {
        content($range)
    }
}
#endif

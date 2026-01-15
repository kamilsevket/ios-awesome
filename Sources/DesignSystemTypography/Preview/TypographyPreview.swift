import SwiftUI

// MARK: - Typography Preview Provider

/// Preview component showing all typography styles
public struct TypographyPreviewView: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                displayStylesSection
                contentStylesSection
                supportingStylesSection
                customWeightsSection
            }
            .padding()
        }
    }

    private var displayStylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Display Styles")

            Text("Large Title")
                .font(.ds.largeTitle)

            Text("Title 1")
                .font(.ds.title1)

            Text("Title 2")
                .font(.ds.title2)

            Text("Title 3")
                .font(.ds.title3)
        }
    }

    private var contentStylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Content Styles")

            Text("Headline")
                .font(.ds.headline)

            Text("Body")
                .font(.ds.body)

            Text("Callout")
                .font(.ds.callout)

            Text("Subheadline")
                .font(.ds.subheadline)
        }
    }

    private var supportingStylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Supporting Styles")

            Text("Footnote")
                .font(.ds.footnote)

            Text("Caption 1")
                .font(.ds.caption1)

            Text("Caption 2")
                .font(.ds.caption2)
        }
    }

    private var customWeightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Weight Variants")

            ForEach(DSFontWeight.allCases, id: \.rawValue) { weight in
                Text("\(weight.rawValue.capitalized) (\(weight.numericValue))")
                    .textStyle(.body, weight: weight)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .textStyle(.caption1, weight: .semibold)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
    }
}

// MARK: - Typography Scale Preview

/// Preview showing typography scale with measurements
public struct TypographyScalePreview: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(FontScale.allCases, id: \.rawValue) { scale in
                    scaleRow(scale)
                    Divider()
                }
            }
            .padding()
        }
    }

    private func scaleRow(_ scale: FontScale) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(scale.rawValue)
                    .font(.ds.caption1)
                    .foregroundColor(.secondary)

                Spacer()

                Text("\(Int(scale.defaultSize))pt")
                    .font(.ds.caption2)
                    .foregroundColor(.secondary)
            }

            Text("The quick brown fox jumps over the lazy dog")
                .font(Font.ds.font(for: scale))

            HStack(spacing: 16) {
                metricBadge("Line Height", value: String(format: "%.1fx", scale.lineHeightMultiplier))
                metricBadge("Tracking", value: String(format: "%.2f", scale.letterSpacing))
                metricBadge("Weight", value: scale.defaultWeight.rawValue)
            }
        }
    }

    private func metricBadge(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.ds.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.ds.caption1)
        }
    }
}

// MARK: - Dynamic Type Preview

/// Preview showing Dynamic Type scaling behavior
public struct DynamicTypePreview: View {
    @State private var sizeCategory: ContentSizeCategory = .large

    private let sizeCategories: [ContentSizeCategory] = [
        .extraSmall,
        .small,
        .medium,
        .large,
        .extraLarge,
        .extraExtraLarge,
        .extraExtraExtraLarge,
        .accessibilityMedium,
        .accessibilityLarge,
        .accessibilityExtraLarge
    ]

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            Picker("Size Category", selection: $sizeCategory) {
                ForEach(sizeCategories, id: \.self) { category in
                    Text(categoryName(category))
                        .tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(FontScale.allCases, id: \.rawValue) { scale in
                        HStack {
                            Text(scale.rawValue)
                                .textStyle(scale)

                            Spacer()

                            Text("\(scaledSize(for: scale))pt")
                                .font(.ds.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .environment(\.sizeCategory, sizeCategory)
        }
    }

    private func categoryName(_ category: ContentSizeCategory) -> String {
        switch category {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .extraLarge: return "XL"
        case .extraExtraLarge: return "XXL"
        case .extraExtraExtraLarge: return "XXXL"
        case .accessibilityMedium: return "AX-M"
        case .accessibilityLarge: return "AX-L"
        case .accessibilityExtraLarge: return "AX-XL"
        default: return "?"
        }
    }

    private func scaledSize(for scale: FontScale) -> Int {
        Int(scale.defaultSize * sizeCategory.scaleFactor)
    }
}

// MARK: - Typography Comparison Preview

/// Preview comparing system fonts with custom fonts
public struct TypographyComparisonPreview: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                comparisonSection("System Font", fontFamily: .system)

                // Add more font families as needed
            }
            .padding()
        }
    }

    private func comparisonSection(_ title: String, fontFamily: FontFamily) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .textStyle(.headline)

            ForEach([FontScale.title1, .headline, .body, .caption1], id: \.rawValue) { scale in
                let token = TypographyToken(scale: scale, fontFamily: fontFamily)
                Text("The quick brown fox")
                    .typography(token)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        #if os(iOS)
        .background(Color(.systemGray6))
        #else
        .background(Color.gray.opacity(0.1))
        #endif
        .cornerRadius(12)
    }
}

// MARK: - Previews

#if DEBUG
struct TypographyPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        TypographyPreviewView()
            .previewDisplayName("Typography Styles")
    }
}

struct TypographyScalePreview_Previews: PreviewProvider {
    static var previews: some View {
        TypographyScalePreview()
            .previewDisplayName("Typography Scale")
    }
}

struct DynamicTypePreview_Previews: PreviewProvider {
    static var previews: some View {
        DynamicTypePreview()
            .previewDisplayName("Dynamic Type")
    }
}

struct TypographyComparisonPreview_Previews: PreviewProvider {
    static var previews: some View {
        TypographyComparisonPreview()
            .previewDisplayName("Font Comparison")
    }
}

// Multi-size preview for accessibility testing
struct TypographyAccessibility_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TypographyPreviewView()
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Extra Small")

            TypographyPreviewView()
                .environment(\.sizeCategory, .large)
                .previewDisplayName("Large (Default)")

            TypographyPreviewView()
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                .previewDisplayName("Accessibility XXXL")
        }
    }
}
#endif

import SwiftUI

// MARK: - Spacing Token Preview

/// Preview for all spacing tokens
struct SpacingTokenPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Spacing Tokens")
                    .font(.title.bold())
                    .padding(.bottom, Spacing.sm)

                ForEach(SpacingToken.allCases, id: \.rawValue) { token in
                    SpacingTokenRow(token: token)
                }
            }
            .padding(Spacing.md)
        }
    }
}

/// Individual spacing token row
struct SpacingTokenRow: View {
    let token: SpacingToken

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Token name and value
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(tokenName)
                    .font(.headline)
                Text("\(Int(token.value))pt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 80, alignment: .leading)

            // Visual representation
            Rectangle()
                .fill(Color.accentColor)
                .frame(width: token.value, height: 24)

            Spacer()
        }
        .padding(.vertical, Spacing.xs)
    }

    private var tokenName: String {
        switch token {
        case .none: return "none"
        case .xxs: return "xxs"
        case .xs: return "xs"
        case .sm: return "sm"
        case .md: return "md"
        case .lg: return "lg"
        case .xl: return "xl"
        case .xxl: return "xxl"
        }
    }
}

// MARK: - Spacing Scale Preview

/// Visual preview of the complete spacing scale
struct SpacingScalePreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("4pt Grid System")
                    .font(.title.bold())

                Text("All spacing values are multiples of 4pt for visual consistency.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // Grid visualization
                VStack(spacing: 0) {
                    ForEach(0..<12) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<12) { col in
                                Rectangle()
                                    .fill((row + col) % 2 == 0 ? Color.gray.opacity(0.1) : Color.gray.opacity(0.2))
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                }
                .border(Color.gray.opacity(0.5))

                Divider()

                // Spacing demonstrations
                SpacingDemoSection(title: "Padding Examples") {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SpacingDemoBox(label: ".padding(.xs)", padding: .xs)
                        SpacingDemoBox(label: ".padding(.sm)", padding: .sm)
                        SpacingDemoBox(label: ".padding(.md)", padding: .md)
                        SpacingDemoBox(label: ".padding(.lg)", padding: .lg)
                    }
                }
            }
            .padding(Spacing.md)
        }
    }
}

struct SpacingDemoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .font(.headline)
            content()
        }
    }
}

struct SpacingDemoBox: View {
    let label: String
    let padding: SpacingToken

    var body: some View {
        HStack {
            Text(label)
                .font(.caption.monospaced())
                .frame(width: 120, alignment: .leading)

            Text("Content")
                .padding(padding)
                .background(Color.accentColor.opacity(0.2))
                .border(Color.accentColor)
        }
    }
}

// MARK: - Responsive Layout Preview

/// Preview for responsive breakpoints
struct ResponsivePreview: View {
    var body: some View {
        ResponsiveContainer { sizeClass in
            VStack(spacing: Spacing.md) {
                Text("Responsive Layout")
                    .font(.title.bold())

                Text("Current: \(sizeClass.rawValue.capitalized)")
                    .font(.headline)
                    .padding(.sm)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(LayoutConstants.cornerRadiusSmall)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    InfoRow(label: "Min Width", value: "\(Int(sizeClass.minWidth))pt")
                    InfoRow(label: "Content Width", value: "\(Int(sizeClass.contentWidth))pt")
                    InfoRow(label: "Grid Columns", value: "\(sizeClass.gridColumns)")
                }
                .padding(.md)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(LayoutConstants.cardCornerRadius)
            }
            .padding(ResponsiveSpacing.pageMargin.value(for: sizeClass))
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Layout Constants Preview

/// Preview for layout constants
struct LayoutConstantsPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("Layout Constants")
                    .font(.title.bold())

                // Touch Targets
                ConstantSection(title: "Touch Targets") {
                    ConstantRow(name: "minTouchTarget", value: LayoutConstants.minTouchTarget)
                    ConstantRow(name: "touchTarget", value: LayoutConstants.touchTarget)
                    ConstantRow(name: "largeTouchTarget", value: LayoutConstants.largeTouchTarget)
                }

                // Button Heights
                ConstantSection(title: "Button Heights") {
                    ConstantRow(name: "buttonHeightSmall", value: LayoutConstants.buttonHeightSmall)
                    ConstantRow(name: "buttonHeight", value: LayoutConstants.buttonHeight)
                    ConstantRow(name: "buttonHeightLarge", value: LayoutConstants.buttonHeightLarge)
                }

                // Corner Radii
                ConstantSection(title: "Corner Radii") {
                    CornerRadiusRow(name: "small", value: LayoutConstants.cornerRadiusSmall)
                    CornerRadiusRow(name: "medium", value: LayoutConstants.cornerRadiusMedium)
                    CornerRadiusRow(name: "large", value: LayoutConstants.cornerRadiusLarge)
                    CornerRadiusRow(name: "xLarge", value: LayoutConstants.cornerRadiusXLarge)
                }

                // Icon Sizes
                ConstantSection(title: "Icon Sizes") {
                    IconSizeRow(name: "small", value: LayoutConstants.iconSizeSmall)
                    IconSizeRow(name: "default", value: LayoutConstants.iconSize)
                    IconSizeRow(name: "large", value: LayoutConstants.iconSizeLarge)
                    IconSizeRow(name: "xLarge", value: LayoutConstants.iconSizeXLarge)
                }
            }
            .padding(Spacing.md)
        }
    }
}

struct ConstantSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(.bottom, Spacing.sm)
    }
}

struct ConstantRow: View {
    let name: String
    let value: CGFloat

    var body: some View {
        HStack {
            Text(name)
                .font(.caption.monospaced())
            Spacer()
            Text("\(Int(value))pt")
                .font(.caption)
                .foregroundStyle(.secondary)
            Rectangle()
                .fill(Color.accentColor)
                .frame(width: min(value, 100), height: 20)
        }
    }
}

struct CornerRadiusRow: View {
    let name: String
    let value: CGFloat

    var body: some View {
        HStack {
            Text(name)
                .font(.caption.monospaced())
                .frame(width: 60, alignment: .leading)
            Text("\(Int(value))pt")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 40)
            RoundedRectangle(cornerRadius: value)
                .fill(Color.accentColor.opacity(0.3))
                .frame(width: 60, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: value)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
            Spacer()
        }
    }
}

struct IconSizeRow: View {
    let name: String
    let value: CGFloat

    var body: some View {
        HStack {
            Text(name)
                .font(.caption.monospaced())
                .frame(width: 60, alignment: .leading)
            Text("\(Int(value))pt")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 40)
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: value, height: value)
                .foregroundColor(.accentColor)
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Spacing Tokens") {
    SpacingTokenPreview()
}

#Preview("Spacing Scale") {
    SpacingScalePreview()
}

#Preview("Responsive Layout") {
    ResponsivePreview()
}

#Preview("Layout Constants") {
    LayoutConstantsPreview()
}

#Preview("Spacing Modifiers") {
    VStack(spacing: Spacing.lg) {
        Text("Card Spacing")
            .cardSpacing(inset: .md)

        Text("Section Spacing")
            .sectionSpacing()
            .background(Color(.secondarySystemBackground))

        Text("Touch Target")
            .touchTarget()
            .background(Color.accentColor.opacity(0.2))
    }
    .padding()
}

#Preview("Safe Area Demo") {
    SafeAreaReader { insets in
        VStack {
            Text("Top: \(Int(insets.top))pt")
            Spacer()
            Text("Bottom: \(Int(insets.bottom))pt")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
    }
}

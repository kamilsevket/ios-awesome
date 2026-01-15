import SwiftUI

#if DEBUG

// MARK: - Preview Helpers

enum PreviewFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

enum PreviewTab: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

enum PreviewViewMode: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
    case map = "Map"
}

// MARK: - Preview Provider

struct DSSegmentedControl_Previews: PreviewProvider {

    // MARK: - Standard Style Preview

    struct StandardStylePreview: View {
        @State private var selection: PreviewFilter = .all

        var body: some View {
            VStack(spacing: 24) {
                Text("Standard Style")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.all, "All")
                    DSSegment(.active, "Active")
                    DSSegment(.completed, "Completed")
                }

                Text("Selected: \(selection.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    // MARK: - Pill Style Preview

    struct PillStylePreview: View {
        @State private var selection: PreviewTab = .week

        var body: some View {
            VStack(spacing: 24) {
                Text("Pill Style")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.day, "Day")
                    DSSegment(.week, "Week")
                    DSSegment(.month, "Month")
                    DSSegment(.year, "Year")
                }
                .style(.pill)

                Text("Selected: \(selection.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    // MARK: - Underline Style Preview

    struct UnderlineStylePreview: View {
        @State private var selection: PreviewViewMode = .list

        var body: some View {
            VStack(spacing: 24) {
                Text("Underline Style")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.list, "List")
                    DSSegment(.grid, "Grid")
                    DSSegment(.map, "Map")
                }
                .style(.underline)

                Text("Selected: \(selection.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    // MARK: - Icon + Text Preview

    struct IconTextPreview: View {
        @State private var selection: PreviewViewMode = .list

        var body: some View {
            VStack(spacing: 24) {
                Text("Icon + Text")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.list, "List", icon: "list.bullet")
                    DSSegment(.grid, "Grid", icon: "square.grid.2x2")
                    DSSegment(.map, "Map", icon: "map")
                }

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.list, "List", icon: "list.bullet")
                    DSSegment(.grid, "Grid", icon: "square.grid.2x2")
                    DSSegment(.map, "Map", icon: "map")
                }
                .style(.pill)

                Text("Selected: \(selection.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    // MARK: - Size Variants Preview

    struct SizeVariantsPreview: View {
        @State private var selection: PreviewFilter = .all

        var body: some View {
            VStack(spacing: 24) {
                Text("Size Variants")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Compact").font(.caption)
                    DSSegmentedControl(selection: $selection) {
                        DSSegment(.all, "All")
                        DSSegment(.active, "Active")
                        DSSegment(.completed, "Done")
                    }
                    .controlSize(.compact)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Standard").font(.caption)
                    DSSegmentedControl(selection: $selection) {
                        DSSegment(.all, "All")
                        DSSegment(.active, "Active")
                        DSSegment(.completed, "Done")
                    }
                    .controlSize(.standard)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Large").font(.caption)
                    DSSegmentedControl(selection: $selection) {
                        DSSegment(.all, "All")
                        DSSegment(.active, "Active")
                        DSSegment(.completed, "Done")
                    }
                    .controlSize(.large)
                }
            }
            .padding()
        }
    }

    // MARK: - Disabled Segments Preview

    struct DisabledSegmentsPreview: View {
        @State private var selection: PreviewFilter = .all

        var body: some View {
            VStack(spacing: 24) {
                Text("Disabled Segments")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.all, "All")
                    DSSegment(.active, "Active", isDisabled: true)
                    DSSegment(.completed, "Completed")
                }

                Text("'Active' segment is disabled")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    // MARK: - Custom Colors Preview

    struct CustomColorsPreview: View {
        @State private var selection: PreviewFilter = .active

        var body: some View {
            VStack(spacing: 24) {
                Text("Custom Colors")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.all, "All")
                    DSSegment(.active, "Active")
                    DSSegment(.completed, "Done")
                }
                .style(.underline)
                .tintColor(.purple)

                DSSegmentedControl(selection: $selection) {
                    DSSegment(.all, "All")
                    DSSegment(.active, "Active")
                    DSSegment(.completed, "Done")
                }
                .backgroundColor(Color.blue.opacity(0.1))
                .selectedTextColor(.blue)
            }
            .padding()
        }
    }

    // MARK: - Icon Only Preview

    struct IconOnlyPreview: View {
        @State private var selection: PreviewViewMode = .list

        var body: some View {
            VStack(spacing: 24) {
                Text("Icon Only")
                    .font(.headline)

                DSSegmentedControl(selection: $selection) {
                    DSSegment.iconOnly(.list, icon: "list.bullet", accessibilityLabel: "List view")
                    DSSegment.iconOnly(.grid, icon: "square.grid.2x2", accessibilityLabel: "Grid view")
                    DSSegment.iconOnly(.map, icon: "map", accessibilityLabel: "Map view")
                }
                .controlSize(.compact)

                DSSegmentedControl(selection: $selection) {
                    DSSegment.iconOnly(.list, icon: "list.bullet", accessibilityLabel: "List view")
                    DSSegment.iconOnly(.grid, icon: "square.grid.2x2", accessibilityLabel: "Grid view")
                    DSSegment.iconOnly(.map, icon: "map", accessibilityLabel: "Map view")
                }
                .style(.pill)
            }
            .padding()
        }
    }

    // MARK: - All Previews

    static var previews: some View {
        Group {
            StandardStylePreview()
                .previewDisplayName("Standard Style")

            PillStylePreview()
                .previewDisplayName("Pill Style")

            UnderlineStylePreview()
                .previewDisplayName("Underline Style")

            IconTextPreview()
                .previewDisplayName("Icon + Text")

            SizeVariantsPreview()
                .previewDisplayName("Size Variants")

            DisabledSegmentsPreview()
                .previewDisplayName("Disabled Segments")

            CustomColorsPreview()
                .previewDisplayName("Custom Colors")

            IconOnlyPreview()
                .previewDisplayName("Icon Only")

            // Dark mode previews
            StandardStylePreview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode - Standard")

            PillStylePreview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode - Pill")

            UnderlineStylePreview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode - Underline")
        }
    }
}

// MARK: - Interactive Demo View

/// A comprehensive demo view showcasing all segmented control features
public struct DSSegmentedControlDemoView: View {
    @State private var filterSelection: PreviewFilter = .all
    @State private var tabSelection: PreviewTab = .week
    @State private var viewModeSelection: PreviewViewMode = .list
    @State private var style: DSSegmentedControlStyle = .standard

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Style selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Style")
                        .font(.headline)

                    Picker("Style", selection: $style) {
                        Text("Standard").tag(DSSegmentedControlStyle.standard)
                        Text("Pill").tag(DSSegmentedControlStyle.pill)
                        Text("Underline").tag(DSSegmentedControlStyle.underline)
                    }
                    .pickerStyle(.segmented)
                }

                Divider()

                // Filter example
                VStack(alignment: .leading, spacing: 8) {
                    Text("Filter Example")
                        .font(.headline)

                    DSSegmentedControl(selection: $filterSelection) {
                        DSSegment(.all, "All")
                        DSSegment(.active, "Active")
                        DSSegment(.completed, "Completed")
                    }
                    .style(style)

                    Text("Showing: \(filterSelection.rawValue) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                // Time range example
                VStack(alignment: .leading, spacing: 8) {
                    Text("Time Range Example")
                        .font(.headline)

                    DSSegmentedControl(selection: $tabSelection) {
                        DSSegment(.day, "D")
                        DSSegment(.week, "W")
                        DSSegment(.month, "M")
                        DSSegment(.year, "Y")
                    }
                    .style(style)
                    .controlSize(.compact)

                    Text("Selected: \(tabSelection.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                // View mode with icons
                VStack(alignment: .leading, spacing: 8) {
                    Text("View Mode with Icons")
                        .font(.headline)

                    DSSegmentedControl(selection: $viewModeSelection) {
                        DSSegment(.list, "List", icon: "list.bullet")
                        DSSegment(.grid, "Grid", icon: "square.grid.2x2")
                        DSSegment(.map, "Map", icon: "map")
                    }
                    .style(style)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Segmented Control")
    }
}

#endif

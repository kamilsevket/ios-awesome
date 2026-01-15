import SwiftUI
import DesignSystem

/// Demo view showcasing all form components: Selection controls, Sliders, Pickers, and Dropdowns.
public struct FormsDemoView: View {
    public init() {}

    public var body: some View {
        List {
            NavigationLink("Selection Controls", destination: SelectionControlsDemoView())
            NavigationLink("Sliders", destination: SlidersDemoView())
            NavigationLink("Pickers", destination: PickersDemoView())
            NavigationLink("Dropdowns & Selects", destination: DropdownsDemoView())
        }
        .navigationTitle("Forms")
    }
}

// MARK: - Selection Controls Demo

struct SelectionControlsDemoView: View {
    @State private var checkboxStates: [Bool] = [false, true, false]
    @State private var selectedRadio = 0
    @State private var toggleStates: [Bool] = [false, true, false]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Checkboxes
                sectionHeader("Checkboxes")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSCheckbox(isChecked: $checkboxStates[0], label: "Option 1")
                    DSCheckbox(isChecked: $checkboxStates[1], label: "Option 2 (pre-selected)")
                    DSCheckbox(isChecked: $checkboxStates[2], label: "Option 3")
                }

                Divider()

                // Checkbox Sizes
                sectionHeader("Checkbox Sizes")
                HStack(spacing: DSSpacing.xl) {
                    DSCheckbox(isChecked: .constant(true), label: "Small", size: .sm)
                    DSCheckbox(isChecked: .constant(true), label: "Medium", size: .md)
                    DSCheckbox(isChecked: .constant(true), label: "Large", size: .lg)
                }

                Divider()

                // Indeterminate Checkbox
                sectionHeader("Indeterminate State")
                DSCheckbox(
                    isChecked: .constant(false),
                    label: "Select All",
                    state: .indeterminate
                )

                Divider()

                // Radio Buttons
                sectionHeader("Radio Buttons")
                DSRadioGroup(selection: $selectedRadio) {
                    DSRadioButton(value: 0, label: "Option A")
                    DSRadioButton(value: 1, label: "Option B")
                    DSRadioButton(value: 2, label: "Option C")
                }

                Text("Selected: Option \(["A", "B", "C"][selectedRadio])")
                    .font(.body)
                    .foregroundColor(DSColors.textSecondary)

                Divider()

                // Toggles
                sectionHeader("Toggles")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSToggle(isOn: $toggleStates[0], label: "Notifications")
                    DSToggle(isOn: $toggleStates[1], label: "Dark Mode")
                    DSToggle(isOn: $toggleStates[2], label: "Auto-save")
                }

                Divider()

                // Disabled States
                sectionHeader("Disabled States")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSCheckbox(isChecked: .constant(true), label: "Disabled Checkbox", isDisabled: true)
                    DSToggle(isOn: .constant(true), label: "Disabled Toggle", isDisabled: true)
                }
            }
            .padding()
        }
        .navigationTitle("Selection Controls")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Sliders Demo

struct SlidersDemoView: View {
    @State private var basicValue: Double = 50
    @State private var rangeValues: ClosedRange<Double> = 25...75
    @State private var steppedValue: Double = 5

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Slider
                sectionHeader("Basic Slider")
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSSlider(value: $basicValue, range: 0...100)
                    Text("Value: \(Int(basicValue))")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)
                }

                Divider()

                // Slider with Labels
                sectionHeader("With Labels")
                DSSlider(
                    value: $basicValue,
                    range: 0...100,
                    label: "Volume",
                    showValue: true
                )

                Divider()

                // Stepped Slider
                sectionHeader("Stepped Slider")
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSSlider(
                        value: $steppedValue,
                        range: 0...10,
                        step: 1,
                        label: "Rating",
                        showValue: true
                    )
                }

                Divider()

                // Range Slider
                sectionHeader("Range Slider")
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSRangeSlider(
                        values: $rangeValues,
                        range: 0...100,
                        label: "Price Range"
                    )
                    Text("Range: $\(Int(rangeValues.lowerBound)) - $\(Int(rangeValues.upperBound))")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)
                }

                Divider()

                // Slider with Custom Track Colors
                sectionHeader("Custom Colors")
                DSSlider(
                    value: $basicValue,
                    range: 0...100,
                    trackColor: DSColors.success,
                    thumbColor: DSColors.success
                )
            }
            .padding()
        }
        .navigationTitle("Sliders")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Pickers Demo

struct PickersDemoView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var selectedDateTime = Date()
    @State private var selectedOption = 0

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Date Picker
                sectionHeader("Date Picker")
                DSDatePicker(
                    selection: $selectedDate,
                    label: "Select Date"
                )

                Divider()

                // Time Picker
                sectionHeader("Time Picker")
                DSTimePicker(
                    selection: $selectedTime,
                    label: "Select Time"
                )

                Divider()

                // Date Time Picker
                sectionHeader("Date & Time Picker")
                DSDateTimePicker(
                    selection: $selectedDateTime,
                    label: "Select Date & Time"
                )

                Divider()

                // Wheel Picker
                sectionHeader("Wheel Picker")
                DSWheelPicker(
                    selection: $selectedOption,
                    options: ["Small", "Medium", "Large", "Extra Large"],
                    label: "Size"
                )

                Divider()

                // Custom Picker
                sectionHeader("Custom Picker")
                DSCustomPicker(
                    selection: $selectedOption,
                    label: "Priority"
                ) {
                    ForEach(0..<4) { index in
                        Text(["Low", "Medium", "High", "Critical"][index]).tag(index)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Pickers")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Dropdowns Demo

struct DropdownsDemoView: View {
    @State private var selectedOption: String?
    @State private var selectedOptions: Set<String> = []
    @State private var searchText = ""

    let options = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Select
                sectionHeader("Basic Select")
                DSSelect(
                    selection: $selectedOption,
                    options: options,
                    placeholder: "Choose a fruit"
                )

                if let selected = selectedOption {
                    Text("Selected: \(selected)")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)
                }

                Divider()

                // Searchable Dropdown
                sectionHeader("Searchable Dropdown")
                DSSearchableDropdown(
                    selection: $selectedOption,
                    options: options,
                    placeholder: "Search fruits...",
                    searchText: $searchText
                )

                Divider()

                // Multi-Select
                sectionHeader("Multi-Select")
                DSMultiSelect(
                    selection: $selectedOptions,
                    options: options,
                    placeholder: "Select fruits"
                )

                if !selectedOptions.isEmpty {
                    Text("Selected: \(selectedOptions.sorted().joined(separator: ", "))")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)
                }

                Divider()

                // Dropdown Menu
                sectionHeader("Dropdown Menu")
                DSDropdownMenu(
                    title: "Actions",
                    icon: Image(systemName: "ellipsis.circle")
                ) {
                    Button("Edit") { print("Edit") }
                    Button("Duplicate") { print("Duplicate") }
                    Button("Share") { print("Share") }
                    Divider()
                    Button("Delete", role: .destructive) { print("Delete") }
                }
            }
            .padding()
        }
        .navigationTitle("Dropdowns")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct FormsDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormsDemoView()
        }
    }
}
#endif

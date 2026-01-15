import SwiftUI

// MARK: - DSDatePicker

/// A styled date picker component for the design system
///
/// DSDatePicker provides a consistent date picker implementation with support for:
/// - Multiple display modes (compact, inline, wheel, graphical)
/// - Date range limits
/// - Custom formatting
/// - Localization support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSDatePicker(selection: $selectedDate)
///     .displayMode(.inline)
///     .minimumDate(.now)
///
/// DSDatePicker("Birth Date", selection: $birthDate)
///     .displayMode(.compact)
///     .maximumDate(.now)
/// ```
public struct DSDatePicker: View {
    // MARK: - Properties

    @Binding private var selection: Date
    private let label: String?
    private var displayMode: DSPickerDisplayMode
    private var minimumDate: Date?
    private var maximumDate: Date?
    private var size: DSPickerSize
    private var variant: DSPickerVariant
    private var displayedComponents: DatePickerComponents
    private var locale: Locale
    private var calendar: Calendar

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a new DSDatePicker
    /// - Parameters:
    ///   - label: Optional label text displayed above the picker
    ///   - selection: Binding to the selected date
    public init(
        _ label: String? = nil,
        selection: Binding<Date>
    ) {
        self.label = label
        self._selection = selection
        self.displayMode = .compact
        self.minimumDate = nil
        self.maximumDate = nil
        self.size = .medium
        self.variant = .default
        self.displayedComponents = .date
        self.locale = .current
        self.calendar = .current
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let label = label {
                labelView(label)
            }

            pickerContent
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var pickerContent: some View {
        Group {
            switch displayMode {
            case .compact:
                compactPicker
            case .inline, .graphical:
                graphicalPicker
            case .wheel:
                wheelPicker
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }

    private var compactPicker: some View {
        HStack {
            DatePicker(
                "",
                selection: $selection,
                in: dateRange,
                displayedComponents: datePickerComponents
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .environment(\.locale, locale)
            .environment(\.calendar, calendar)
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Date picker")
    }

    private var graphicalPicker: some View {
        DatePicker(
            "",
            selection: $selection,
            in: dateRange,
            displayedComponents: datePickerComponents
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
        .environment(\.locale, locale)
        .environment(\.calendar, calendar)
        .padding(size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Date picker")
    }

    private var wheelPicker: some View {
        DatePicker(
            "",
            selection: $selection,
            in: dateRange,
            displayedComponents: datePickerComponents
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .environment(\.locale, locale)
        .environment(\.calendar, calendar)
        .padding(size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Date picker")
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.labelFont)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }

    // MARK: - Helpers

    private var dateRange: ClosedRange<Date> {
        let min = minimumDate ?? Date.distantPast
        let max = maximumDate ?? Date.distantFuture
        return min...max
    }

    private var datePickerComponents: DatePickerComponents {
        displayedComponents
    }
}

// MARK: - Modifiers

public extension DSDatePicker {
    /// Sets the display mode for the picker
    func displayMode(_ mode: DSPickerDisplayMode) -> DSDatePicker {
        var picker = self
        picker.displayMode = mode
        return picker
    }

    /// Sets the minimum allowed date
    func minimumDate(_ date: Date?) -> DSDatePicker {
        var picker = self
        picker.minimumDate = date
        return picker
    }

    /// Sets the maximum allowed date
    func maximumDate(_ date: Date?) -> DSDatePicker {
        var picker = self
        picker.maximumDate = date
        return picker
    }

    /// Sets the date range
    func dateRange(_ range: ClosedRange<Date>) -> DSDatePicker {
        var picker = self
        picker.minimumDate = range.lowerBound
        picker.maximumDate = range.upperBound
        return picker
    }

    /// Sets the size of the picker
    func pickerSize(_ size: DSPickerSize) -> DSDatePicker {
        var picker = self
        picker.size = size
        return picker
    }

    /// Sets the visual variant of the picker
    func pickerVariant(_ variant: DSPickerVariant) -> DSDatePicker {
        var picker = self
        picker.variant = variant
        return picker
    }

    /// Sets which date components to display
    func displayedComponents(_ components: DatePickerComponents) -> DSDatePicker {
        var picker = self
        picker.displayedComponents = components
        return picker
    }

    /// Sets the locale for the picker
    func locale(_ locale: Locale) -> DSDatePicker {
        var picker = self
        picker.locale = locale
        return picker
    }

    /// Sets the calendar for the picker
    func calendar(_ calendar: Calendar) -> DSDatePicker {
        var picker = self
        picker.calendar = calendar
        return picker
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Compact mode
                PreviewSection(title: "Compact Mode") {
                    DSDatePicker("Select Date", selection: .constant(Date()))
                        .displayMode(.compact)
                }

                // Graphical mode
                PreviewSection(title: "Graphical Mode") {
                    DSDatePicker("Select Date", selection: .constant(Date()))
                        .displayMode(.graphical)
                }

                // Wheel mode
                PreviewSection(title: "Wheel Mode") {
                    DSDatePicker("Select Date", selection: .constant(Date()))
                        .displayMode(.wheel)
                }

                // Variants
                PreviewSection(title: "Variants") {
                    VStack(spacing: 16) {
                        DSDatePicker("Default", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.default)

                        DSDatePicker("Outlined", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.outlined)

                        DSDatePicker("Filled", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.filled)
                    }
                }

                // With date range
                PreviewSection(title: "With Date Range") {
                    DSDatePicker("Future Dates Only", selection: .constant(Date()))
                        .displayMode(.compact)
                        .minimumDate(.now)
                        .pickerVariant(.outlined)
                }

                // Disabled state
                PreviewSection(title: "Disabled") {
                    DSDatePicker("Disabled", selection: .constant(Date()))
                        .displayMode(.compact)
                        .pickerVariant(.outlined)
                        .disabled(true)
                }
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 32) {
                PreviewSection(title: "Dark Mode") {
                    VStack(spacing: 16) {
                        DSDatePicker("Compact", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.outlined)

                        DSDatePicker("Graphical", selection: .constant(Date()))
                            .displayMode(.graphical)
                            .pickerVariant(.filled)
                    }
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}

private struct PreviewSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#endif

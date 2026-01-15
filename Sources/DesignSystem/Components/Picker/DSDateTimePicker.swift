import SwiftUI

// MARK: - DSDateTimePicker

/// A combined date and time picker component for the design system
///
/// DSDateTimePicker provides a unified interface for selecting both date and time with support for:
/// - Separate or combined date/time selection
/// - Multiple display modes
/// - Date range limits
/// - Localization support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSDateTimePicker(selection: $dateTime)
///     .displayMode(.compact)
///     .minimumDate(.now)
///
/// DSDateTimePicker("Schedule", selection: $scheduleTime)
///     .displayMode(.stacked)
/// ```
public struct DSDateTimePicker: View {
    // MARK: - Properties

    @Binding private var selection: Date
    private let label: String?
    private var displayMode: DateTimePickerDisplayMode
    private var minimumDate: Date?
    private var maximumDate: Date?
    private var size: DSPickerSize
    private var variant: DSPickerVariant
    private var locale: Locale
    private var calendar: Calendar

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a new DSDateTimePicker
    /// - Parameters:
    ///   - label: Optional label text displayed above the picker
    ///   - selection: Binding to the selected date and time
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
            case .inline:
                inlinePicker
            case .stacked:
                stackedPicker
            case .sideBySide:
                sideBySidePicker
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }

    private var compactPicker: some View {
        HStack(spacing: DSSpacing.sm) {
            DatePicker(
                "",
                selection: $selection,
                in: dateRange,
                displayedComponents: [.date, .hourAndMinute]
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
        .accessibilityLabel(label ?? "Date and time picker")
    }

    private var inlinePicker: some View {
        DatePicker(
            "",
            selection: $selection,
            in: dateRange,
            displayedComponents: [.date, .hourAndMinute]
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
        .accessibilityLabel(label ?? "Date and time picker")
    }

    private var stackedPicker: some View {
        VStack(spacing: DSSpacing.md) {
            // Date picker section
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text("Date")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))

                DatePicker(
                    "",
                    selection: $selection,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .environment(\.locale, locale)
                .environment(\.calendar, calendar)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider()

            // Time picker section
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text("Time")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))

                DatePicker(
                    "",
                    selection: $selection,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .environment(\.locale, locale)
                .environment(\.calendar, calendar)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Date and time picker")
    }

    private var sideBySidePicker: some View {
        HStack(spacing: DSSpacing.md) {
            // Date picker
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text("Date")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))

                DatePicker(
                    "",
                    selection: $selection,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .environment(\.locale, locale)
                .environment(\.calendar, calendar)
            }

            Divider()

            // Time picker
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text("Time")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))

                DatePicker(
                    "",
                    selection: $selection,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .environment(\.locale, locale)
                .environment(\.calendar, calendar)
            }
        }
        .padding(size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Date and time picker")
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
}

// MARK: - DateTime Display Mode

/// Display modes for date-time picker
public enum DateTimePickerDisplayMode {
    /// Compact inline display
    case compact
    /// Inline graphical display
    case inline
    /// Stacked date and time (vertical)
    case stacked
    /// Side by side date and time (horizontal)
    case sideBySide
}

// MARK: - Modifiers

public extension DSDateTimePicker {
    /// Sets the display mode for the picker
    func displayMode(_ mode: DateTimePickerDisplayMode) -> DSDateTimePicker {
        var picker = self
        picker.displayMode = mode
        return picker
    }

    /// Sets the minimum allowed date
    func minimumDate(_ date: Date?) -> DSDateTimePicker {
        var picker = self
        picker.minimumDate = date
        return picker
    }

    /// Sets the maximum allowed date
    func maximumDate(_ date: Date?) -> DSDateTimePicker {
        var picker = self
        picker.maximumDate = date
        return picker
    }

    /// Sets the date range
    func dateRange(_ range: ClosedRange<Date>) -> DSDateTimePicker {
        var picker = self
        picker.minimumDate = range.lowerBound
        picker.maximumDate = range.upperBound
        return picker
    }

    /// Sets the size of the picker
    func pickerSize(_ size: DSPickerSize) -> DSDateTimePicker {
        var picker = self
        picker.size = size
        return picker
    }

    /// Sets the visual variant of the picker
    func pickerVariant(_ variant: DSPickerVariant) -> DSDateTimePicker {
        var picker = self
        picker.variant = variant
        return picker
    }

    /// Sets the locale for the picker
    func locale(_ locale: Locale) -> DSDateTimePicker {
        var picker = self
        picker.locale = locale
        return picker
    }

    /// Sets the calendar for the picker
    func calendar(_ calendar: Calendar) -> DSDateTimePicker {
        var picker = self
        picker.calendar = calendar
        return picker
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSDateTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Compact mode
                DateTimePickerPreviewSection(title: "Compact Mode") {
                    DSDateTimePicker("Schedule", selection: .constant(Date()))
                        .displayMode(.compact)
                        .pickerVariant(.outlined)
                }

                // Inline mode
                DateTimePickerPreviewSection(title: "Inline Mode") {
                    DSDateTimePicker("Select Date & Time", selection: .constant(Date()))
                        .displayMode(.inline)
                        .pickerVariant(.outlined)
                }

                // Stacked mode
                DateTimePickerPreviewSection(title: "Stacked Mode") {
                    DSDateTimePicker("Appointment", selection: .constant(Date()))
                        .displayMode(.stacked)
                        .pickerVariant(.outlined)
                }

                // Side by side mode
                DateTimePickerPreviewSection(title: "Side by Side Mode") {
                    DSDateTimePicker("Meeting", selection: .constant(Date()))
                        .displayMode(.sideBySide)
                        .pickerVariant(.outlined)
                }

                // With date range
                DateTimePickerPreviewSection(title: "Future Dates Only") {
                    DSDateTimePicker("Future Event", selection: .constant(Date()))
                        .displayMode(.compact)
                        .minimumDate(.now)
                        .pickerVariant(.filled)
                }

                // Disabled
                DateTimePickerPreviewSection(title: "Disabled") {
                    DSDateTimePicker("Disabled", selection: .constant(Date()))
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
                DateTimePickerPreviewSection(title: "Dark Mode") {
                    VStack(spacing: 16) {
                        DSDateTimePicker("Compact", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.outlined)

                        DSDateTimePicker("Stacked", selection: .constant(Date()))
                            .displayMode(.stacked)
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

private struct DateTimePickerPreviewSection<Content: View>: View {
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

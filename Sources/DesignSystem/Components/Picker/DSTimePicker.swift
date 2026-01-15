import SwiftUI

// MARK: - DSTimePicker

/// A styled time picker component for the design system
///
/// DSTimePicker provides a consistent time picker implementation with support for:
/// - Multiple display modes (compact, wheel)
/// - Time interval configuration
/// - 12/24 hour format support
/// - Localization support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSTimePicker(selection: $selectedTime)
///     .displayMode(.wheel)
///
/// DSTimePicker("Meeting Time", selection: $meetingTime)
///     .displayMode(.compact)
///     .minuteInterval(15)
/// ```
public struct DSTimePicker: View {
    // MARK: - Properties

    @Binding private var selection: Date
    private let label: String?
    private var displayMode: DSPickerDisplayMode
    private var size: DSPickerSize
    private var variant: DSPickerVariant
    private var minuteInterval: Int
    private var hourInterval: Int
    private var locale: Locale
    private var calendar: Calendar

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a new DSTimePicker
    /// - Parameters:
    ///   - label: Optional label text displayed above the picker
    ///   - selection: Binding to the selected time
    public init(
        _ label: String? = nil,
        selection: Binding<Date>
    ) {
        self.label = label
        self._selection = selection
        self.displayMode = .compact
        self.size = .medium
        self.variant = .default
        self.minuteInterval = 1
        self.hourInterval = 1
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
            case .wheel, .inline, .graphical:
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
                displayedComponents: .hourAndMinute
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
        .accessibilityLabel(label ?? "Time picker")
    }

    private var wheelPicker: some View {
        DatePicker(
            "",
            selection: $selection,
            displayedComponents: .hourAndMinute
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
        .accessibilityLabel(label ?? "Time picker")
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.labelFont)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }
}

// MARK: - Modifiers

public extension DSTimePicker {
    /// Sets the display mode for the picker
    func displayMode(_ mode: DSPickerDisplayMode) -> DSTimePicker {
        var picker = self
        picker.displayMode = mode
        return picker
    }

    /// Sets the size of the picker
    func pickerSize(_ size: DSPickerSize) -> DSTimePicker {
        var picker = self
        picker.size = size
        return picker
    }

    /// Sets the visual variant of the picker
    func pickerVariant(_ variant: DSPickerVariant) -> DSTimePicker {
        var picker = self
        picker.variant = variant
        return picker
    }

    /// Sets the minute interval for selection
    func minuteInterval(_ interval: Int) -> DSTimePicker {
        var picker = self
        picker.minuteInterval = max(1, min(30, interval))
        return picker
    }

    /// Sets the hour interval for selection
    func hourInterval(_ interval: Int) -> DSTimePicker {
        var picker = self
        picker.hourInterval = max(1, min(12, interval))
        return picker
    }

    /// Sets the locale for the picker
    func locale(_ locale: Locale) -> DSTimePicker {
        var picker = self
        picker.locale = locale
        return picker
    }

    /// Sets the calendar for the picker
    func calendar(_ calendar: Calendar) -> DSTimePicker {
        var picker = self
        picker.calendar = calendar
        return picker
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Compact mode
                TimePickerPreviewSection(title: "Compact Mode") {
                    DSTimePicker("Select Time", selection: .constant(Date()))
                        .displayMode(.compact)
                }

                // Wheel mode
                TimePickerPreviewSection(title: "Wheel Mode") {
                    DSTimePicker("Select Time", selection: .constant(Date()))
                        .displayMode(.wheel)
                }

                // Variants
                TimePickerPreviewSection(title: "Variants") {
                    VStack(spacing: 16) {
                        DSTimePicker("Default", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.default)

                        DSTimePicker("Outlined", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.outlined)

                        DSTimePicker("Filled", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.filled)
                    }
                }

                // Sizes
                TimePickerPreviewSection(title: "Sizes") {
                    VStack(spacing: 16) {
                        DSTimePicker("Small", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerSize(.small)
                            .pickerVariant(.outlined)

                        DSTimePicker("Medium", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerSize(.medium)
                            .pickerVariant(.outlined)

                        DSTimePicker("Large", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerSize(.large)
                            .pickerVariant(.outlined)
                    }
                }

                // Disabled state
                TimePickerPreviewSection(title: "Disabled") {
                    DSTimePicker("Disabled", selection: .constant(Date()))
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
                TimePickerPreviewSection(title: "Dark Mode") {
                    VStack(spacing: 16) {
                        DSTimePicker("Compact", selection: .constant(Date()))
                            .displayMode(.compact)
                            .pickerVariant(.outlined)

                        DSTimePicker("Wheel", selection: .constant(Date()))
                            .displayMode(.wheel)
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

private struct TimePickerPreviewSection<Content: View>: View {
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

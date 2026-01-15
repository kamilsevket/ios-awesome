import SwiftUI

/// A selectable option for DSSelect component
public protocol DSSelectOption: Identifiable, Equatable {
    var id: String { get }
    var displayText: String { get }
}

/// Default implementation for String-based options
public struct DSSelectStringOption: DSSelectOption {
    public let id: String
    public let displayText: String

    public init(_ text: String) {
        self.id = text
        self.displayText = text
    }

    public init(id: String, displayText: String) {
        self.id = id
        self.displayText = displayText
    }
}

/// Style variants for the select component
public enum DSSelectStyle {
    case standard
    case outlined
    case filled
}

/// A form select input component
///
/// Example usage:
/// ```swift
/// @State private var selectedCountry: String?
///
/// DSSelect(
///     selection: $selectedCountry,
///     options: ["USA", "Canada", "Mexico"]
/// )
/// .placeholder("Select country")
/// ```
public struct DSSelect<Option: DSSelectOption>: View {
    // MARK: - Properties

    @Binding private var selection: Option?
    private let options: [Option]
    private var placeholder: String = "Select an option"
    private var label: String?
    private var helperText: String?
    private var errorMessage: String?
    private var style: DSSelectStyle = .outlined
    private var isDisabled: Bool = false
    private var showClearButton: Bool = true
    private var leadingIcon: Image?

    @State private var isExpanded = false
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a select component with options
    /// - Parameters:
    ///   - selection: Binding to the selected option
    ///   - options: Array of options to choose from
    public init(
        selection: Binding<Option?>,
        options: [Option]
    ) {
        self._selection = selection
        self.options = options
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Label
            if let label = label {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(labelColor)
            }

            // Select field
            Menu {
                ForEach(options) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = option
                        }
                    } label: {
                        HStack {
                            Text(option.displayText)
                            if selection?.id == option.id {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(DSColors.primary)
                            }
                        }
                    }
                }
            } label: {
                selectFieldContent
            }
            .disabled(isDisabled)

            // Helper/Error text
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(DSColors.error)
            } else if let helper = helperText {
                Text(helper)
                    .font(.caption)
                    .foregroundColor(DSColors.textSecondary)
            }
        }
        .opacity(isDisabled ? 0.6 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(selection?.displayText ?? "No selection")
        .accessibilityHint("Double tap to show options")
    }

    // MARK: - Subviews

    private var selectFieldContent: some View {
        HStack(spacing: Spacing.sm) {
            if let icon = leadingIcon {
                icon
                    .foregroundColor(DSColors.textSecondary)
                    .frame(width: 24, height: 24)
            }

            if let selected = selection {
                Text(selected.displayText)
                    .foregroundColor(DSColors.textPrimary)
            } else {
                Text(placeholder)
                    .foregroundColor(DSColors.textTertiary)
            }

            Spacer()

            if showClearButton && selection != nil {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = nil
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DSColors.textTertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear selection")
            }

            Image(systemName: "chevron.down")
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .frame(minHeight: DSSpacing.minTouchTarget)
        .background(backgroundView)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .standard:
            VStack {
                Spacer()
                Rectangle()
                    .fill(borderColor)
                    .frame(height: 1)
            }
        case .outlined:
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(borderColor, lineWidth: 1)
        case .filled:
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? DSColors.backgroundSecondary : Color(UIColor.systemGray6))
        }
    }

    // MARK: - Computed Properties

    private var labelColor: Color {
        if errorMessage != nil {
            return DSColors.error
        }
        return DSColors.textSecondary
    }

    private var borderColor: Color {
        if errorMessage != nil {
            return DSColors.error
        }
        return DSColors.border
    }

    private var accessibilityLabel: String {
        var result = label ?? "Select"
        if let error = errorMessage {
            result += ", error: \(error)"
        }
        return result
    }
}

// MARK: - Modifiers

public extension DSSelect {
    /// Sets the placeholder text
    func placeholder(_ text: String) -> DSSelect {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Sets the label text
    func label(_ text: String) -> DSSelect {
        var copy = self
        copy.label = text
        return copy
    }

    /// Sets the helper text
    func helperText(_ text: String) -> DSSelect {
        var copy = self
        copy.helperText = text
        return copy
    }

    /// Sets the error message
    func errorMessage(_ message: String?) -> DSSelect {
        var copy = self
        copy.errorMessage = message
        return copy
    }

    /// Sets the style variant
    func style(_ style: DSSelectStyle) -> DSSelect {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets whether the component is disabled
    func disabled(_ disabled: Bool) -> DSSelect {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Sets whether to show the clear button
    func showClearButton(_ show: Bool) -> DSSelect {
        var copy = self
        copy.showClearButton = show
        return copy
    }

    /// Sets the leading icon
    func leadingIcon(_ icon: Image) -> DSSelect {
        var copy = self
        copy.leadingIcon = icon
        return copy
    }
}

// MARK: - String Array Convenience

public extension DSSelect where Option == DSSelectStringOption {
    /// Creates a select component with string options
    init(
        selection: Binding<String?>,
        options: [String]
    ) {
        let stringOptions = options.map { DSSelectStringOption($0) }
        let optionBinding = Binding<DSSelectStringOption?>(
            get: {
                if let value = selection.wrappedValue {
                    return DSSelectStringOption(value)
                }
                return nil
            },
            set: { newValue in
                selection.wrappedValue = newValue?.displayText
            }
        )
        self.init(selection: optionBinding, options: stringOptions)
    }
}

// MARK: - Preview

#if DEBUG
struct DSSelect_Previews: PreviewProvider {
    struct Country: DSSelectOption {
        let id: String
        let displayText: String
        let code: String

        init(name: String, code: String) {
            self.id = code
            self.displayText = name
            self.code = code
        }
    }

    struct PreviewWrapper: View {
        @State private var selectedCountry: Country?
        @State private var selectedString: String?
        @State private var selectedWithError: String?

        let countries = [
            Country(name: "United States", code: "US"),
            Country(name: "Canada", code: "CA"),
            Country(name: "Mexico", code: "MX"),
            Country(name: "United Kingdom", code: "UK"),
            Country(name: "Germany", code: "DE"),
            Country(name: "France", code: "FR")
        ]

        let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]

        var body: some View {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Group {
                        Text("Basic Select")
                            .font(.headline)

                        DSSelect(selection: $selectedString, options: fruits)
                            .placeholder("Choose a fruit")
                            .label("Favorite Fruit")
                    }

                    Divider()

                    Group {
                        Text("Custom Options")
                            .font(.headline)

                        DSSelect(selection: $selectedCountry, options: countries)
                            .placeholder("Select your country")
                            .label("Country")
                            .helperText("Select your country of residence")
                            .leadingIcon(Image(systemName: "globe"))
                    }

                    Divider()

                    Group {
                        Text("Style Variants")
                            .font(.headline)

                        DSSelect(selection: $selectedString, options: fruits)
                            .placeholder("Standard style")
                            .style(.standard)

                        DSSelect(selection: $selectedString, options: fruits)
                            .placeholder("Outlined style")
                            .style(.outlined)

                        DSSelect(selection: $selectedString, options: fruits)
                            .placeholder("Filled style")
                            .style(.filled)
                    }

                    Divider()

                    Group {
                        Text("Error State")
                            .font(.headline)

                        DSSelect(selection: $selectedWithError, options: fruits)
                            .placeholder("Select required")
                            .label("Required Field")
                            .errorMessage("This field is required")
                    }

                    Divider()

                    Group {
                        Text("Disabled State")
                            .font(.headline)

                        DSSelect(selection: .constant(nil as String?), options: fruits)
                            .placeholder("Disabled select")
                            .disabled(true)
                    }
                }
                .padding()
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("DSSelect")
    }
}
#endif

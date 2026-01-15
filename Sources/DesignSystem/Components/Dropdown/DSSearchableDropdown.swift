import SwiftUI

/// A searchable dropdown component with custom item rendering
///
/// Example usage:
/// ```swift
/// @State private var selectedUser: User?
///
/// DSSearchableDropdown(
///     selection: $selectedUser,
///     options: users
/// ) { user in
///     HStack {
///         AsyncImage(url: user.avatarURL)
///         VStack(alignment: .leading) {
///             Text(user.name)
///             Text(user.email).font(.caption)
///         }
///     }
/// }
/// ```
public struct DSSearchableDropdown<Option: DSSelectOption, ItemContent: View>: View {
    // MARK: - Properties

    @Binding private var selection: Option?
    private let options: [Option]
    private let itemContent: (Option) -> ItemContent
    private var placeholder: String = "Search..."
    private var label: String?
    private var helperText: String?
    private var errorMessage: String?
    private var isDisabled: Bool = false
    private var emptyStateMessage: String = "No results found"

    @State private var searchText = ""
    @State private var isExpanded = false
    @FocusState private var isSearchFocused: Bool
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a searchable dropdown with custom item rendering
    /// - Parameters:
    ///   - selection: Binding to the selected option
    ///   - options: Array of available options
    ///   - itemContent: View builder for custom item display
    public init(
        selection: Binding<Option?>,
        options: [Option],
        @ViewBuilder itemContent: @escaping (Option) -> ItemContent
    ) {
        self._selection = selection
        self.options = options
        self.itemContent = itemContent
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

            // Dropdown
            VStack(spacing: 0) {
                searchField

                if isExpanded {
                    dropdownContent
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

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
        .onChange(of: isSearchFocused) { focused in
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded = focused
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Subviews

    private var searchField: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DSColors.textTertiary)

            if let selected = selection, !isExpanded {
                // Show selected item
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded = true
                        isSearchFocused = true
                    }
                } label: {
                    Text(selected.displayText)
                        .foregroundColor(DSColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
            } else {
                // Show search field
                TextField(placeholder, text: $searchText)
                    .textFieldStyle(.plain)
                    .focused($isSearchFocused)
                    .onSubmit {
                        selectFirstMatch()
                    }
            }

            if selection != nil || !searchText.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = nil
                        searchText = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DSColors.textTertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear")
            }

            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                        if isExpanded {
                            isSearchFocused = true
                        }
                    }
                }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .frame(minHeight: DSSpacing.minTouchTarget)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(borderColor, lineWidth: isExpanded ? 2 : 1)
        )
        .disabled(isDisabled)
    }

    private var dropdownContent: some View {
        VStack(spacing: 0) {
            if filteredOptions.isEmpty {
                // Empty state
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(DSColors.textTertiary)
                    Text(emptyStateMessage)
                        .font(.subheadline)
                        .foregroundColor(DSColors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xl)
            } else {
                // Options list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredOptions) { option in
                            optionRow(for: option)

                            if option.id != filteredOptions.last?.id {
                                Divider()
                                    .padding(.horizontal, Spacing.sm)
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? DSColors.backgroundSecondary : DSColors.backgroundPrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(DSColors.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    private func optionRow(for option: Option) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = option
                searchText = ""
                isExpanded = false
                isSearchFocused = false
            }
        } label: {
            HStack {
                itemContent(option)

                Spacer()

                if selection?.id == option.id {
                    Image(systemName: "checkmark")
                        .foregroundColor(DSColors.primary)
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .contentShape(Rectangle())
            .background(
                selection?.id == option.id ?
                    DSColors.primary.opacity(0.05) :
                    Color.clear
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection?.id == option.id ? [.isSelected] : [])
    }

    // MARK: - Computed Properties

    private var filteredOptions: [Option] {
        if searchText.isEmpty {
            return options
        }
        return options.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }
    }

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
        if isExpanded {
            return DSColors.primary
        }
        return DSColors.border
    }

    private var accessibilityLabel: String {
        var result = label ?? "Searchable dropdown"
        if let selected = selection {
            result += ", selected: \(selected.displayText)"
        }
        if let error = errorMessage {
            result += ", error: \(error)"
        }
        return result
    }

    // MARK: - Actions

    private func selectFirstMatch() {
        if let first = filteredOptions.first {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = first
                searchText = ""
                isExpanded = false
                isSearchFocused = false
            }
        }
    }
}

// MARK: - Modifiers

public extension DSSearchableDropdown {
    /// Sets the placeholder text
    func placeholder(_ text: String) -> DSSearchableDropdown {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Sets the label text
    func label(_ text: String) -> DSSearchableDropdown {
        var copy = self
        copy.label = text
        return copy
    }

    /// Sets the helper text
    func helperText(_ text: String) -> DSSearchableDropdown {
        var copy = self
        copy.helperText = text
        return copy
    }

    /// Sets the error message
    func errorMessage(_ message: String?) -> DSSearchableDropdown {
        var copy = self
        copy.errorMessage = message
        return copy
    }

    /// Sets whether the component is disabled
    func disabled(_ disabled: Bool) -> DSSearchableDropdown {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Sets the empty state message
    func emptyStateMessage(_ message: String) -> DSSearchableDropdown {
        var copy = self
        copy.emptyStateMessage = message
        return copy
    }
}

// MARK: - Default Item Content

public extension DSSearchableDropdown where ItemContent == Text {
    /// Creates a searchable dropdown with default text rendering
    init(
        selection: Binding<Option?>,
        options: [Option]
    ) {
        self.init(selection: selection, options: options) { option in
            Text(option.displayText)
                .foregroundColor(DSColors.textPrimary)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSSearchableDropdown_Previews: PreviewProvider {
    struct User: DSSelectOption, Hashable {
        let id: String
        let displayText: String
        let email: String
        let avatarSystemName: String

        init(name: String, email: String, avatar: String) {
            self.id = email
            self.displayText = name
            self.email = email
            self.avatarSystemName = avatar
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    struct PreviewWrapper: View {
        @State private var selectedUser: User?
        @State private var selectedCountry: DSSelectStringOption?

        let users = [
            User(name: "John Doe", email: "john@example.com", avatar: "person.circle.fill"),
            User(name: "Jane Smith", email: "jane@example.com", avatar: "person.circle.fill"),
            User(name: "Bob Wilson", email: "bob@example.com", avatar: "person.circle.fill"),
            User(name: "Alice Brown", email: "alice@example.com", avatar: "person.circle.fill"),
            User(name: "Charlie Davis", email: "charlie@example.com", avatar: "person.circle.fill")
        ]

        let countries = [
            DSSelectStringOption("United States"),
            DSSelectStringOption("Canada"),
            DSSelectStringOption("United Kingdom"),
            DSSelectStringOption("Germany"),
            DSSelectStringOption("France"),
            DSSelectStringOption("Japan"),
            DSSelectStringOption("Australia")
        ]

        var body: some View {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Group {
                        Text("Custom Item Rendering")
                            .font(.headline)

                        DSSearchableDropdown(
                            selection: $selectedUser,
                            options: users
                        ) { user in
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: user.avatarSystemName)
                                    .font(.title2)
                                    .foregroundColor(DSColors.primary)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(DSColors.primary.opacity(0.1))
                                    )

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(user.displayText)
                                        .font(.body)
                                        .foregroundColor(DSColors.textPrimary)
                                    Text(user.email)
                                        .font(.caption)
                                        .foregroundColor(DSColors.textSecondary)
                                }
                            }
                        }
                        .placeholder("Search users...")
                        .label("Assign To")
                        .helperText("Search by name or email")
                    }

                    Divider()

                    Group {
                        Text("Simple Text Items")
                            .font(.headline)

                        DSSearchableDropdown(
                            selection: $selectedCountry,
                            options: countries
                        )
                        .placeholder("Search countries...")
                        .label("Country")
                    }

                    Divider()

                    Group {
                        Text("With Error State")
                            .font(.headline)

                        DSSearchableDropdown(
                            selection: .constant(nil as User?),
                            options: users
                        ) { user in
                            Text(user.displayText)
                        }
                        .placeholder("Search...")
                        .label("Required User")
                        .errorMessage("Please select a user")
                    }

                    Divider()

                    Group {
                        Text("Disabled State")
                            .font(.headline)

                        DSSearchableDropdown(
                            selection: $selectedUser,
                            options: users
                        ) { user in
                            Text(user.displayText)
                        }
                        .placeholder("Search...")
                        .disabled(true)
                    }
                }
                .padding()
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("DSSearchableDropdown")
    }
}
#endif

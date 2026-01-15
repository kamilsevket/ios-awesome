import SwiftUI

/// A search-optimized text field component.
///
/// Example usage:
/// ```swift
/// DSSearchTextField(text: $searchQuery)
///     .placeholder("Search...")
///     .onSubmit { performSearch() }
/// ```
public struct DSSearchTextField: View {
    @Binding private var text: String

    private var placeholder: String = "Search"
    private var showsCancelButton: Bool = true
    private var onSubmit: (() -> Void)?
    private var onCancel: (() -> Void)?

    @State private var isFocused: Bool = false
    @FocusState private var fieldIsFocused: Bool

    // MARK: - Initialization

    public init(text: Binding<String>) {
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            // Search field
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField(placeholder, text: $text)
                    .focused($fieldIsFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        onSubmit?()
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                // Clear button
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )

            // Cancel button
            if showsCancelButton && isFocused {
                Button("Cancel") {
                    text = ""
                    fieldIsFocused = false
                    onCancel?()
                }
                .foregroundColor(.accentColor)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .onChange(of: fieldIsFocused) { newValue in
            withAnimation(.easeInOut(duration: 0.2)) {
                isFocused = newValue
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search field")
        .accessibilityValue(text.isEmpty ? "Empty" : text)
    }
}

// MARK: - Modifiers

public extension DSSearchTextField {
    /// Sets the placeholder text.
    func placeholder(_ text: String) -> DSSearchTextField {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Shows or hides the cancel button.
    func showsCancelButton(_ show: Bool) -> DSSearchTextField {
        var copy = self
        copy.showsCancelButton = show
        return copy
    }

    /// Called when the search is submitted.
    func onSubmit(_ action: @escaping () -> Void) -> DSSearchTextField {
        var copy = self
        copy.onSubmit = action
        return copy
    }

    /// Called when the search is cancelled.
    func onCancel(_ action: @escaping () -> Void) -> DSSearchTextField {
        var copy = self
        copy.onCancel = action
        return copy
    }
}

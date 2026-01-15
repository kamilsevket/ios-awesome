import SwiftUI

// MARK: - Search Field Style

/// Defines the visual style of the search field
public enum DSSearchFieldStyle: Equatable {
    /// Standard rounded rectangle style
    case rounded
    /// Pill-shaped style
    case pill
    /// Minimal underline style
    case minimal

    var cornerRadius: CGFloat {
        switch self {
        case .rounded:
            return 10
        case .pill:
            return 20
        case .minimal:
            return 0
        }
    }

    var height: CGFloat {
        switch self {
        case .rounded, .pill:
            return 36
        case .minimal:
            return 32
        }
    }
}

// MARK: - DSNavigationBarSearchField

/// A search field component designed for navigation bar integration
///
/// Features:
/// - Animated expand/collapse
/// - Cancel button support
/// - Clear button
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSNavigationBarSearchField(
///     text: $searchText,
///     isActive: $isSearching,
///     placeholder: "Search..."
/// )
/// ```
public struct DSNavigationBarSearchField: View {
    // MARK: - Properties

    @Binding private var text: String
    @Binding private var isActive: Bool
    private let placeholder: String
    private let style: DSSearchFieldStyle
    private let showCancelButton: Bool
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?

    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a new DSNavigationBarSearchField
    /// - Parameters:
    ///   - text: Binding to the search text
    ///   - isActive: Binding to the active state
    ///   - placeholder: Placeholder text (default: "Search")
    ///   - style: Visual style of the search field (default: .rounded)
    ///   - showCancelButton: Whether to show cancel button when active (default: true)
    ///   - onSubmit: Closure called when search is submitted
    ///   - onCancel: Closure called when search is cancelled
    public init(
        text: Binding<String>,
        isActive: Binding<Bool>,
        placeholder: String = "Search",
        style: DSSearchFieldStyle = .rounded,
        showCancelButton: Bool = true,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self._isActive = isActive
        self.placeholder = placeholder
        self.style = style
        self.showCancelButton = showCancelButton
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            searchFieldContent
                .onChange(of: isFocused) { _, focused in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isActive = focused
                    }
                }

            if showCancelButton && isActive {
                cancelButton
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isActive)
    }

    // MARK: - Subviews

    private var searchFieldContent: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 15, weight: .medium))

            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit {
                    onSubmit?()
                }
                .accessibilityLabel("Search field")
                .accessibilityHint(placeholder)

            if !text.isEmpty {
                clearButton
            }
        }
        .padding(.horizontal, 12)
        .frame(height: style.height)
        .background(searchFieldBackground)
    }

    @ViewBuilder
    private var searchFieldBackground: some View {
        switch style {
        case .rounded, .pill:
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(Color(.systemGray6))
        case .minimal:
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 1)
            }
        }
    }

    private var clearButton: some View {
        Button {
            text = ""
            triggerHapticFeedback()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
        }
        .buttonStyle(PlainButtonStyle())
        .transition(.scale.combined(with: .opacity))
        .accessibilityLabel("Clear search")
    }

    private var cancelButton: some View {
        Button("Cancel") {
            withAnimation(.easeInOut(duration: 0.25)) {
                text = ""
                isFocused = false
                isActive = false
            }
            onCancel?()
            triggerHapticFeedback()
        }
        .font(.body)
        .foregroundColor(.accentColor)
        .accessibilityLabel("Cancel search")
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Navigation Bar Search Modifier

/// A view modifier that adds a searchable search field to a navigation bar
public struct NavigationBarSearchableModifier: ViewModifier {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    let placeholder: String
    let style: DSSearchFieldStyle

    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top) {
                if isSearching {
                    DSNavigationBarSearchField(
                        text: $searchText,
                        isActive: $isSearching,
                        placeholder: placeholder,
                        style: style
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
    }
}

// MARK: - View Extension

extension View {
    /// Adds a searchable search field to the navigation bar
    public func navigationBarSearchable(
        text: Binding<String>,
        isSearching: Binding<Bool>,
        placeholder: String = "Search",
        style: DSSearchFieldStyle = .rounded
    ) -> some View {
        modifier(NavigationBarSearchableModifier(
            searchText: text,
            isSearching: isSearching,
            placeholder: placeholder,
            style: style
        ))
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSNavigationBarSearchField_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var searchText = ""
        @State private var isActive = false

        let style: DSSearchFieldStyle

        var body: some View {
            VStack {
                DSNavigationBarSearchField(
                    text: $searchText,
                    isActive: $isActive,
                    placeholder: "Search products...",
                    style: style
                )
                .padding()

                Text("Search text: \(searchText)")
                    .foregroundColor(.secondary)

                Text("Active: \(isActive ? "Yes" : "No")")
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
    }

    static var previews: some View {
        Group {
            PreviewWrapper(style: .rounded)
                .previewDisplayName("Rounded Style")

            PreviewWrapper(style: .pill)
                .previewDisplayName("Pill Style")

            PreviewWrapper(style: .minimal)
                .previewDisplayName("Minimal Style")

            PreviewWrapper(style: .rounded)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
#endif

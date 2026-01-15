import SwiftUI

#if DEBUG

// MARK: - Navigation Bar Previews

struct DSNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Basic inline style
            InlineStylePreview()
                .previewDisplayName("Inline Style")

            // Large title style
            LargeTitleStylePreview()
                .previewDisplayName("Large Title Style")

            // With search
            SearchIntegrationPreview()
                .previewDisplayName("With Search")

            // Transparent style
            TransparentStylePreview()
                .previewDisplayName("Transparent Style")

            // Full example
            FullExamplePreview()
                .previewDisplayName("Full Example")

            // Dark mode
            FullExamplePreview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }

    // MARK: - Inline Style Preview

    struct InlineStylePreview: View {
        var body: some View {
            VStack(spacing: 0) {
                DSNavigationBar(title: "Settings", subtitle: "Account preferences") {
                    DSBackButton { }
                } trailing: {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20))
                    }
                }
                .style(.inline)
                .background(.defaultBlur)

                Spacer()

                Text("Content Area")
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
    }

    // MARK: - Large Title Style Preview

    struct LargeTitleStylePreview: View {
        @State private var scrollOffset: CGFloat = 0

        var body: some View {
            VStack(spacing: 0) {
                DSNavigationBar(title: "Messages", subtitle: "12 unread") {
                    EmptyView()
                } trailing: {
                    Button {
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                    }
                }
                .style(.largeTitle)
                .scrollOffset(scrollOffset)

                DSObservableScrollView(offset: $scrollOffset) {
                    LazyVStack(spacing: 12) {
                        ForEach(0..<20) { index in
                            MessageRow(index: index)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    // MARK: - Search Integration Preview

    struct SearchIntegrationPreview: View {
        @State private var searchText = ""
        @State private var isSearchActive = false
        @State private var scrollOffset: CGFloat = 0

        var body: some View {
            VStack(spacing: 0) {
                DSNavigationBar(title: "Contacts") {
                    EmptyView()
                } trailing: {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                    }
                }
                .style(.largeTitle)
                .searchable($searchText, isActive: $isSearchActive, placeholder: "Search contacts...")
                .scrollOffset(scrollOffset)

                DSObservableScrollView(offset: $scrollOffset) {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredContacts, id: \.self) { contact in
                            ContactRow(name: contact)
                        }
                    }
                }
            }
        }

        private var contacts: [String] {
            ["Alice", "Bob", "Charlie", "David", "Emma", "Frank", "Grace", "Henry", "Ivy", "Jack"]
        }

        private var filteredContacts: [String] {
            if searchText.isEmpty {
                return contacts
            }
            return contacts.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // MARK: - Transparent Style Preview

    struct TransparentStylePreview: View {
        var body: some View {
            ZStack {
                // Background image placeholder
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    DSNavigationBar(title: "Profile") {
                        DSBackButton(tintColor: .white) { }
                    } trailing: {
                        Button {
                        } label: {
                            Image(systemName: "gear")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .style(.transparent)
                    .titleColor(.white)
                    .shadow(.none)

                    Spacer()

                    Text("Profile Content")
                        .foregroundColor(.white)

                    Spacer()
                }
            }
        }
    }

    // MARK: - Full Example Preview

    struct FullExamplePreview: View {
        @State private var scrollOffset: CGFloat = 0
        @State private var searchText = ""
        @State private var isSearchActive = false

        var body: some View {
            VStack(spacing: 0) {
                DSNavigationBar(title: "Photos", subtitle: "All Photos") {
                    DSBackButton(title: "Albums") { }
                } trailing: {
                    HStack(spacing: 16) {
                        Button {
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                        }

                        Button {
                        } label: {
                            Text("Select")
                                .font(.body)
                        }
                    }
                }
                .style(.largeTitle)
                .background(.blur(.systemThinMaterial))
                .searchable($searchText, isActive: $isSearchActive, placeholder: "Search photos...")
                .scrollOffset(scrollOffset)

                DSObservableScrollView(offset: $scrollOffset) {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 2
                    ) {
                        ForEach(0..<50) { index in
                            PhotoThumbnail(index: index)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helper Views

    struct MessageRow: View {
        let index: Int

        var body: some View {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Contact \(index + 1)")
                        .font(.headline)

                    Text("Last message preview...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Text("12:30")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    struct ContactRow: View {
        let name: String

        var body: some View {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(name.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.gray)
                    )

                Text(name)
                    .font(.body)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Divider()
                .padding(.leading, 64)
        }
    }

    struct PhotoThumbnail: View {
        let index: Int

        var body: some View {
            Rectangle()
                .fill(Color(hue: Double(index) / 50.0, saturation: 0.6, brightness: 0.8))
                .aspectRatio(1, contentMode: .fill)
        }
    }
}

// MARK: - Component Previews

struct DSBackButton_ComponentPreview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            // Styles section
            VStack(alignment: .leading, spacing: 16) {
                Text("Styles")
                    .font(.headline)

                HStack(spacing: 24) {
                    VStack {
                        DSBackButton(style: .chevron) { }
                        Text("Chevron").font(.caption)
                    }

                    VStack {
                        DSBackButton(style: .arrow) { }
                        Text("Arrow").font(.caption)
                    }

                    VStack {
                        DSBackButton.close { }
                        Text("Close").font(.caption)
                    }
                }
            }

            Divider()

            // With titles
            VStack(alignment: .leading, spacing: 16) {
                Text("With Titles")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 12) {
                    DSBackButton(title: "Back") { }
                    DSBackButton(title: "Settings") { }
                    DSBackButton.withTitle("Home") { }
                }
            }

            Divider()

            // Colors
            VStack(alignment: .leading, spacing: 16) {
                Text("Colors")
                    .font(.headline)

                HStack(spacing: 24) {
                    DSBackButton(tintColor: .blue) { }
                    DSBackButton(tintColor: .red) { }
                    DSBackButton(tintColor: .green) { }
                    DSBackButton(tintColor: .purple) { }
                }
            }
        }
        .padding()
        .previewDisplayName("DSBackButton")
    }
}

struct DSNavigationBarSearchField_ComponentPreview: PreviewProvider {
    struct Wrapper: View {
        @State private var text = ""
        @State private var isActive = false
        let style: DSSearchFieldStyle

        var body: some View {
            VStack {
                DSNavigationBarSearchField(
                    text: $text,
                    isActive: $isActive,
                    placeholder: "Search...",
                    style: style
                )

                Text("Text: \(text.isEmpty ? "(empty)" : text)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    static var previews: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Rounded").font(.headline)
                Wrapper(style: .rounded)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Pill").font(.headline)
                Wrapper(style: .pill)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Minimal").font(.headline)
                Wrapper(style: .minimal)
            }
        }
        .padding()
        .previewDisplayName("Search Field Styles")
    }
}

#endif

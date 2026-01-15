import SwiftUI
import DesignSystem

/// Demo view showcasing all basic components: Buttons, TextFields, Cards, Avatars, and Badges.
public struct ComponentsDemoView: View {
    public init() {}

    public var body: some View {
        List {
            Section("Basic Components") {
                NavigationLink("Buttons", destination: ButtonsDemoView())
                NavigationLink("Text Fields", destination: TextFieldsDemoView())
                NavigationLink("Cards", destination: CardsDemoView())
                NavigationLink("Avatars", destination: AvatarsDemoView())
                NavigationLink("Badges & Tags", destination: BadgesDemoView())
            }

            Section("Navigation") {
                NavigationLink("Tab Bar", destination: TabBarDemoView())
                NavigationLink("Navigation Bar", destination: NavigationBarDemoView())
                NavigationLink("Segmented Control", destination: SegmentedControlDemoView())
            }

            Section("Data Display") {
                NavigationLink("Lists", destination: ListsDemoView())
                NavigationLink("Grids", destination: GridsDemoView())
                NavigationLink("Carousel", destination: CarouselDemoView())
            }
        }
        .navigationTitle("Components")
    }
}

// MARK: - Buttons Demo

struct ButtonsDemoView: View {
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Button Styles
                sectionHeader("Button Styles")
                DSButton("Primary Button", style: .primary) { }
                DSButton("Secondary Button", style: .secondary) { }
                DSButton("Tertiary Button", style: .tertiary) { }

                Divider()

                // Button Sizes
                sectionHeader("Button Sizes")
                DSButton("Small", style: .primary, size: .small) { }
                DSButton("Medium", style: .primary, size: .medium) { }
                DSButton("Large", style: .primary, size: .large) { }

                Divider()

                // Buttons with Icons
                sectionHeader("Buttons with Icons")
                DSButton("Add Item", style: .primary, icon: Image(systemName: "plus")) { }
                DSButton("Next", style: .secondary, icon: Image(systemName: "arrow.right"), iconPosition: .trailing) { }
                DSButton("Download", style: .tertiary, icon: Image(systemName: "arrow.down.circle")) { }

                Divider()

                // Button States
                sectionHeader("Button States")
                DSButton("Loading State", style: .primary, isLoading: isLoading) {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                DSButton("Disabled State", style: .primary, isEnabled: false) { }

                Divider()

                // Full Width Button
                sectionHeader("Full Width")
                DSButton("Full Width Button", style: .primary, isFullWidth: true) { }

                Divider()

                // Icon Buttons
                sectionHeader("Icon Buttons")
                HStack(spacing: DSSpacing.lg) {
                    DSIconButton(systemName: "heart", style: .filled, size: .small, accessibilityLabel: "Like") { }
                    DSIconButton(systemName: "star", style: .tinted, size: .medium, accessibilityLabel: "Favorite") { }
                    DSIconButton(systemName: "bookmark", style: .plain, size: .large, accessibilityLabel: "Bookmark") { }
                }

                Divider()

                // Floating Action Button
                sectionHeader("Floating Action Button")
                HStack(spacing: DSSpacing.lg) {
                    DSFloatingActionButton(systemName: "plus", size: .small, accessibilityLabel: "Add") { }
                    DSFloatingActionButton(systemName: "pencil", size: .regular, accessibilityLabel: "Edit") { }
                    DSFloatingActionButton.extended(systemName: "camera", title: "Camera") { }
                }
            }
            .padding()
        }
        .navigationTitle("Buttons")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - TextFields Demo

struct TextFieldsDemoView: View {
    @State private var basicText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var searchText = ""
    @State private var multilineText = ""

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic TextField
                sectionHeader("Basic Text Field")
                DSTextField("Username", text: $basicText)
                    .helperText("Enter your username")

                Divider()

                // Outlined Style
                sectionHeader("Outlined Style")
                DSTextField("Email", text: $emailText)
                    .style(.outlined)
                    .validation(.email)
                    .errorMessage("Please enter a valid email")
                    .leadingIcon(Image(systemName: "envelope"))

                Divider()

                // Secure Field
                sectionHeader("Secure Text Field")
                DSTextField("Password", text: $passwordText)
                    .style(.outlined)
                    .secure(true)
                    .validation(.password)
                    .helperText("Minimum 8 characters")

                Divider()

                // Search Style
                sectionHeader("Search Style")
                DSTextField("Search", text: $searchText)
                    .style(.search)
                    .leadingIcon(Image(systemName: "magnifyingglass"))
                    .showsClearButton(true)

                Divider()

                // With Character Counter
                sectionHeader("With Character Counter")
                DSTextField("Bio", text: $basicText)
                    .style(.outlined)
                    .maxCharacters(100)

                Divider()

                // Multiline TextField
                sectionHeader("Multiline Text Field")
                DSMultilineTextField("Description", text: $multilineText, minLines: 3)
                    .helperText("Enter a detailed description")

                Divider()

                // Disabled State
                sectionHeader("Disabled State")
                DSTextField("Disabled", text: .constant("Cannot edit"))
                    .style(.outlined)
                    .disabled(true)
            }
            .padding()
        }
        .navigationTitle("Text Fields")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Cards Demo

struct CardsDemoView: View {
    @State private var isExpanded = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Card
                sectionHeader("Basic Card")
                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Basic Card")
                            .font(.headline)
                        Text("This is a simple card with basic content. Cards are containers for related content and actions.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                    }
                }

                Divider()

                // Image Card
                sectionHeader("Image Card")
                DSImageCard(
                    imageURL: nil,
                    title: "Featured Image",
                    subtitle: "Beautiful landscape photography"
                ) {
                    // Placeholder for image
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [DSColors.primary, DSColors.info],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 180)
                }

                Divider()

                // Interactive Card
                sectionHeader("Interactive Card")
                DSInteractiveCard(isSelected: false) {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Tap to Select")
                            .font(.headline)
                        Text("Interactive cards respond to user taps and can show selection state.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                    }
                } onTap: {
                    print("Card tapped")
                }

                Divider()

                // Expandable Card
                sectionHeader("Expandable Card")
                DSExpandableCard(
                    title: "Expandable Content",
                    isExpanded: $isExpanded
                ) {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("This content is revealed when expanded.")
                            .font(.body)
                        Text("You can put any content here, including other components, images, or complex layouts.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                    }
                }

                Divider()

                // List Card
                sectionHeader("List Card")
                DSListCard(
                    title: "List Item",
                    subtitle: "Supporting text goes here",
                    leadingIcon: Image(systemName: "folder"),
                    trailingIcon: Image(systemName: "chevron.right")
                )

                DSListCard(
                    title: "Another Item",
                    subtitle: "With different icon",
                    leadingIcon: Image(systemName: "doc.text")
                )
            }
            .padding()
        }
        .navigationTitle("Cards")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Simple User for Demo

struct DemoUser: AvatarUser {
    var avatarURL: URL?
    var displayName: String?

    init(name: String) {
        self.displayName = name
        self.avatarURL = nil
    }
}

// MARK: - Avatars Demo

struct AvatarsDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Avatar Sizes
                sectionHeader("Avatar Sizes")
                HStack(spacing: DSSpacing.lg) {
                    DSAvatar(initials: "XS", size: .xs)
                    DSAvatar(initials: "SM", size: .sm)
                    DSAvatar(initials: "MD", size: .md)
                    DSAvatar(initials: "LG", size: .lg)
                    DSAvatar(initials: "XL", size: .xl)
                }

                Divider()

                // Avatar with Status
                sectionHeader("Avatar with Status")
                HStack(spacing: DSSpacing.lg) {
                    DSAvatar(initials: "ON", size: .lg)
                        .statusIndicator(.online)
                    DSAvatar(initials: "OF", size: .lg)
                        .statusIndicator(.offline)
                    DSAvatar(initials: "BS", size: .lg)
                        .statusIndicator(.busy)
                    DSAvatar(initials: "AW", size: .lg)
                        .statusIndicator(.away)
                }

                Divider()

                // Avatar with Ring
                sectionHeader("Avatar with Ring Border")
                HStack(spacing: DSSpacing.lg) {
                    DSAvatar(initials: "AB", size: .lg, showRing: true)
                    DSAvatar(initials: "CD", size: .lg, showRing: true)
                        .statusIndicator(.online)
                }

                Divider()

                // Icon Avatar (fallback)
                sectionHeader("Icon Avatar (Fallback)")
                HStack(spacing: DSSpacing.lg) {
                    DSAvatar(size: .sm)
                    DSAvatar(size: .md)
                    DSAvatar(size: .lg)
                }

                Divider()

                // Avatar Group
                sectionHeader("Avatar Group")
                let users: [DemoUser] = [
                    DemoUser(name: "Alice"),
                    DemoUser(name: "Bob"),
                    DemoUser(name: "Charlie"),
                    DemoUser(name: "Diana"),
                    DemoUser(name: "Eve")
                ]
                DSAvatarGroup(users: users, maxVisible: 3, size: .md)

                DSAvatarGroup(users: users, maxVisible: 4, size: .lg)
            }
            .padding()
        }
        .navigationTitle("Avatars")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Badges Demo

struct BadgesDemoView: View {
    @State private var filterAll = true
    @State private var filterActive = false
    @State private var filterCompleted = false
    @State private var selectDesign = false
    @State private var selectDevelopment = true
    @State private var selectTesting = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Count Badges
                sectionHeader("Count Badges")
                HStack(spacing: DSSpacing.xl) {
                    badgeDemo("1", size: .sm)
                    badgeDemo("9", size: .sm)
                    badgeDemo("99+", size: .md)
                }

                Divider()

                // Status Badges
                sectionHeader("Status Badges")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSStatusBadge(.online, text: "Online")
                    DSStatusBadge(.offline, text: "Offline")
                    DSStatusBadge(.busy, text: "Do Not Disturb")
                    DSStatusBadge(.away, text: "Away")
                }

                Divider()

                // Tags
                sectionHeader("Tags")
                FlowLayout(spacing: DSSpacing.sm) {
                    DSTag("Success", variant: .success)
                    DSTag("Warning", variant: .warning)
                    DSTag("Error", variant: .error)
                    DSTag("Info", variant: .info)
                }

                Divider()

                // Tags with Icons
                sectionHeader("Tags with Icons")
                FlowLayout(spacing: DSSpacing.sm) {
                    DSTag("New", variant: .success, icon: Image(systemName: "star"))
                    DSTag("Sale", variant: .error, icon: Image(systemName: "tag"))
                    DSTag("Popular", variant: .warning, icon: Image(systemName: "flame"))
                }

                Divider()

                // Dismissible Tags
                sectionHeader("Dismissible Tags")
                FlowLayout(spacing: DSSpacing.sm) {
                    DSTag("Swift", variant: .info, onDismiss: {
                        print("Dismissed Swift")
                    })
                    DSTag("iOS", variant: .info, onDismiss: {
                        print("Dismissed iOS")
                    })
                }

                Divider()

                // Filter Chips
                sectionHeader("Filter Chips (Single Select)")
                FlowLayout(spacing: DSSpacing.sm) {
                    DSFilterChip("All", isSelected: $filterAll)
                    DSFilterChip("Active", isSelected: $filterActive)
                    DSFilterChip("Completed", isSelected: $filterCompleted)
                }

                Divider()

                // Selectable Chips
                sectionHeader("Selectable Chips (Multi Select)")
                FlowLayout(spacing: DSSpacing.sm) {
                    DSSelectableChip("Design", isSelected: $selectDesign)
                    DSSelectableChip("Development", isSelected: $selectDevelopment)
                    DSSelectableChip("Testing", isSelected: $selectTesting)
                }
            }
            .padding()
        }
        .navigationTitle("Badges & Tags")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func badgeDemo(_ count: String, size: DSBadgeSize) -> some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 8)
                .fill(DSColors.backgroundSecondary)
                .frame(width: 50, height: 50)

            DSBadge(count: Int(count.replacingOccurrences(of: "+", with: "")) ?? 0, size: size)
                .offset(x: 8, y: -8)
        }
    }
}

// MARK: - Flow Layout Helper

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: ProposedViewSize(result.sizes[index]))
        }
    }

    struct FlowResult {
        var positions: [CGPoint] = []
        var sizes: [CGSize] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                sizes.append(size)
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }
            self.size.height = y + rowHeight
        }
    }
}

#if DEBUG
struct ComponentsDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComponentsDemoView()
        }
    }
}
#endif

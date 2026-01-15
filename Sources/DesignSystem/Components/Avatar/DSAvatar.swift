import SwiftUI

/// A customizable avatar component with support for images, initials, and icons
///
/// The avatar follows a fallback chain: image → initials → icon
///
/// Usage:
/// ```swift
/// // With image URL
/// DSAvatar(imageURL: url, size: .lg)
///
/// // With initials
/// DSAvatar(initials: "JD", backgroundColor: .blue)
///
/// // With user object
/// DSAvatar(user: user, size: .md)
///
/// // With status indicator
/// DSAvatar(initials: "JD", size: .lg)
///     .statusIndicator(.online)
/// ```
public struct DSAvatar: View {
    // MARK: - Properties

    private let size: AvatarSize
    private let imageURL: URL?
    private let initials: String?
    private let backgroundColor: Color
    private let showRing: Bool
    private let ringColor: Color
    private var status: AvatarStatus?
    private var statusPosition: StatusIndicatorPosition

    // MARK: - Initialization

    /// Creates an avatar with an image URL
    /// - Parameters:
    ///   - imageURL: URL of the avatar image
    ///   - size: Size variant of the avatar
    ///   - initials: Fallback initials if image fails to load
    ///   - backgroundColor: Background color for initials/icon fallback
    ///   - showRing: Whether to show a ring border around the avatar
    ///   - ringColor: Color of the ring border
    public init(
        imageURL: URL? = nil,
        size: AvatarSize = .md,
        initials: String? = nil,
        backgroundColor: Color = .gray,
        showRing: Bool = false,
        ringColor: Color = .white
    ) {
        self.imageURL = imageURL
        self.size = size
        self.initials = initials
        self.backgroundColor = backgroundColor
        self.showRing = showRing
        self.ringColor = ringColor
        self.status = nil
        self.statusPosition = .bottomRight
    }

    /// Creates an avatar with initials only
    /// - Parameters:
    ///   - initials: The initials to display (e.g., "JD" for John Doe)
    ///   - size: Size variant of the avatar
    ///   - backgroundColor: Background color for the avatar
    ///   - showRing: Whether to show a ring border around the avatar
    ///   - ringColor: Color of the ring border
    public init(
        initials: String,
        size: AvatarSize = .md,
        backgroundColor: Color = .blue,
        showRing: Bool = false,
        ringColor: Color = .white
    ) {
        self.imageURL = nil
        self.size = size
        self.initials = initials
        self.backgroundColor = backgroundColor
        self.showRing = showRing
        self.ringColor = ringColor
        self.status = nil
        self.statusPosition = .bottomRight
    }

    /// Creates an avatar from an AvatarUser object
    /// - Parameters:
    ///   - user: User object conforming to AvatarUser protocol
    ///   - size: Size variant of the avatar
    ///   - showRing: Whether to show a ring border around the avatar
    ///   - ringColor: Color of the ring border
    public init(
        user: some AvatarUser,
        size: AvatarSize = .md,
        showRing: Bool = false,
        ringColor: Color = .white
    ) {
        self.imageURL = user.avatarURL
        self.size = size
        self.initials = Self.generateInitials(from: user.displayName)
        self.backgroundColor = Self.colorForName(user.displayName)
        self.showRing = showRing
        self.ringColor = ringColor
        self.status = nil
        self.statusPosition = .bottomRight
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: statusPosition.alignment) {
            avatarContent
                .frame(width: size.diameter, height: size.diameter)
                .clipShape(Circle())
                .overlay {
                    if showRing {
                        Circle()
                            .strokeBorder(ringColor, lineWidth: size.ringWidth)
                    }
                }

            if let status = status {
                StatusIndicator(status: status, size: size)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Avatar Content

    @ViewBuilder
    private var avatarContent: some View {
        if let imageURL = imageURL {
            ImageAvatar(url: imageURL, size: size) {
                fallbackContent
            }
        } else {
            fallbackContent
        }
    }

    @ViewBuilder
    private var fallbackContent: some View {
        if let initials = initials, !initials.isEmpty {
            InitialsAvatar(
                initials: String(initials.prefix(2)).uppercased(),
                size: size,
                backgroundColor: backgroundColor
            )
        } else {
            IconAvatar(size: size, backgroundColor: backgroundColor)
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var label = "Avatar"
        if let initials = initials {
            label = "Avatar for \(initials)"
        }
        if let status = status {
            label += ", \(status.accessibilityLabel)"
        }
        return label
    }

    // MARK: - Modifiers

    /// Adds a status indicator to the avatar
    /// - Parameters:
    ///   - status: The online status to display
    ///   - position: Position of the indicator (default: bottomRight)
    /// - Returns: Avatar with status indicator
    public func statusIndicator(
        _ status: AvatarStatus,
        position: StatusIndicatorPosition = .bottomRight
    ) -> DSAvatar {
        var avatar = self
        avatar.status = status
        avatar.statusPosition = position
        return avatar
    }

    // MARK: - Helper Methods

    /// Generates initials from a display name
    static func generateInitials(from name: String?) -> String? {
        guard let name = name, !name.isEmpty else { return nil }

        let components = name.split(separator: " ")
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let last = components[components.count - 1].prefix(1)
            return "\(first)\(last)".uppercased()
        } else if let firstChar = name.first {
            return String(firstChar).uppercased()
        }
        return nil
    }

    /// Generates a consistent color based on a name string
    static func colorForName(_ name: String?) -> Color {
        guard let name = name, !name.isEmpty else { return .gray }

        let colors: [Color] = [
            .blue, .green, .orange, .purple, .pink, .red, .teal, .indigo
        ]

        let hash = name.utf8.reduce(0) { $0 &+ Int($1) }
        return colors[abs(hash) % colors.count]
    }
}

// MARK: - AvatarStatus Accessibility Extension

extension AvatarStatus {
    var accessibilityLabel: String {
        switch self {
        case .online: return "online"
        case .offline: return "offline"
        case .busy: return "busy"
        case .away: return "away"
        }
    }
}

// MARK: - Preview

#Preview("Avatar Sizes") {
    HStack(spacing: 16) {
        DSAvatar(initials: "XS", size: .xs, backgroundColor: .blue)
        DSAvatar(initials: "SM", size: .sm, backgroundColor: .green)
        DSAvatar(initials: "MD", size: .md, backgroundColor: .orange)
        DSAvatar(initials: "LG", size: .lg, backgroundColor: .purple)
        DSAvatar(initials: "XL", size: .xl, backgroundColor: .pink)
    }
    .padding()
}

#Preview("Avatar with Status") {
    HStack(spacing: 16) {
        DSAvatar(initials: "JD", size: .lg, backgroundColor: .blue)
            .statusIndicator(.online)
        DSAvatar(initials: "AB", size: .lg, backgroundColor: .green)
            .statusIndicator(.busy)
        DSAvatar(initials: "CD", size: .lg, backgroundColor: .orange)
            .statusIndicator(.away)
        DSAvatar(initials: "EF", size: .lg, backgroundColor: .purple)
            .statusIndicator(.offline)
    }
    .padding()
}

#Preview("Avatar with Ring") {
    ZStack {
        Color.gray.opacity(0.3)
        HStack(spacing: 16) {
            DSAvatar(initials: "JD", size: .lg, backgroundColor: .blue, showRing: true)
            DSAvatar(initials: "AB", size: .lg, backgroundColor: .green, showRing: true, ringColor: .blue)
        }
    }
    .frame(height: 100)
}

#Preview("Icon Fallback") {
    HStack(spacing: 16) {
        DSAvatar(size: .sm)
        DSAvatar(size: .md)
        DSAvatar(size: .lg)
        DSAvatar(size: .xl)
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            DSAvatar(initials: "JD", size: .lg, backgroundColor: .blue)
                .statusIndicator(.online)
            DSAvatar(initials: "AB", size: .lg, backgroundColor: .green, showRing: true)
            DSAvatar(size: .lg)
        }
    }
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}

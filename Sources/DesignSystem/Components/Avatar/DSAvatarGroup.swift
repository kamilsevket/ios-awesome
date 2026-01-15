import SwiftUI

/// A group of overlapping avatars with an optional overflow indicator
///
/// Usage:
/// ```swift
/// // With user objects
/// DSAvatarGroup(users: users, max: 3, size: .md)
///
/// // With initials
/// DSAvatarGroup(
///     initials: ["JD", "AB", "CD", "EF", "GH"],
///     max: 3,
///     size: .lg
/// )
/// ```
public struct DSAvatarGroup<User: AvatarUser>: View {
    // MARK: - Properties

    private let users: [User]
    private let maxVisible: Int
    private let size: AvatarSize
    private let overlapRatio: CGFloat
    private let showRing: Bool
    private let ringColor: Color

    // MARK: - Computed Properties

    private var visibleUsers: [User] {
        Array(users.prefix(maxVisible))
    }

    private var overflowCount: Int {
        max(0, users.count - maxVisible)
    }

    private var spacing: CGFloat {
        -size.diameter * overlapRatio
    }

    // MARK: - Initialization

    /// Creates an avatar group from an array of users
    /// - Parameters:
    ///   - users: Array of user objects conforming to AvatarUser
    ///   - max: Maximum number of avatars to display before showing overflow
    ///   - size: Size variant for all avatars in the group
    ///   - overlapRatio: How much avatars overlap (0.0 - 1.0, default 0.25)
    ///   - showRing: Whether to show ring borders around avatars
    ///   - ringColor: Color of the ring borders
    public init(
        users: [User],
        max: Int = 3,
        size: AvatarSize = .md,
        overlapRatio: CGFloat = 0.25,
        showRing: Bool = true,
        ringColor: Color = .white
    ) {
        self.users = users
        self.maxVisible = max
        self.size = size
        self.overlapRatio = min(max(overlapRatio, 0), 1)
        self.showRing = showRing
        self.ringColor = ringColor
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(Array(visibleUsers.enumerated()), id: \.offset) { index, user in
                DSAvatar(
                    user: user,
                    size: size,
                    showRing: showRing,
                    ringColor: ringColor
                )
                .zIndex(Double(visibleUsers.count - index))
            }

            if overflowCount > 0 {
                overflowIndicator
                    .zIndex(0)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Overflow Indicator

    private var overflowIndicator: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.8))
                .frame(width: size.diameter, height: size.diameter)

            Text("+\(overflowCount)")
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .overlay {
            if showRing {
                Circle()
                    .strokeBorder(ringColor, lineWidth: size.ringWidth)
            }
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        if users.isEmpty {
            return "No avatars"
        } else if users.count == 1 {
            return "1 avatar"
        } else {
            return "\(users.count) avatars"
        }
    }
}

// MARK: - Convenience Initializer for Initials

extension DSAvatarGroup where User == SimpleAvatarUser {
    /// Creates an avatar group from an array of initials strings
    /// - Parameters:
    ///   - initials: Array of initials strings
    ///   - max: Maximum number of avatars to display before showing overflow
    ///   - size: Size variant for all avatars in the group
    ///   - overlapRatio: How much avatars overlap (0.0 - 1.0, default 0.25)
    ///   - showRing: Whether to show ring borders around avatars
    ///   - ringColor: Color of the ring borders
    public init(
        initials: [String],
        max: Int = 3,
        size: AvatarSize = .md,
        overlapRatio: CGFloat = 0.25,
        showRing: Bool = true,
        ringColor: Color = .white
    ) {
        let users = initials.map { SimpleAvatarUser(displayName: $0) }
        self.init(
            users: users,
            max: max,
            size: size,
            overlapRatio: overlapRatio,
            showRing: showRing,
            ringColor: ringColor
        )
    }
}

// MARK: - Simple Avatar User

/// A simple implementation of AvatarUser for basic use cases
public struct SimpleAvatarUser: AvatarUser {
    public let avatarURL: URL?
    public let displayName: String?

    public init(
        avatarURL: URL? = nil,
        displayName: String? = nil
    ) {
        self.avatarURL = avatarURL
        self.displayName = displayName
    }
}

// MARK: - Preview

#Preview("Avatar Group - Basic") {
    let users = [
        SimpleAvatarUser(displayName: "John Doe"),
        SimpleAvatarUser(displayName: "Alice Brown"),
        SimpleAvatarUser(displayName: "Charlie Davis"),
        SimpleAvatarUser(displayName: "Eve Foster"),
        SimpleAvatarUser(displayName: "Grace Hill")
    ]

    return VStack(spacing: 24) {
        DSAvatarGroup(users: users, max: 3, size: .md)
        DSAvatarGroup(users: users, max: 4, size: .md)
        DSAvatarGroup(users: users, max: 5, size: .md)
    }
    .padding()
}

#Preview("Avatar Group - Sizes") {
    let users = [
        SimpleAvatarUser(displayName: "JD"),
        SimpleAvatarUser(displayName: "AB"),
        SimpleAvatarUser(displayName: "CD"),
        SimpleAvatarUser(displayName: "EF")
    ]

    return VStack(spacing: 24) {
        DSAvatarGroup(users: users, max: 3, size: .xs)
        DSAvatarGroup(users: users, max: 3, size: .sm)
        DSAvatarGroup(users: users, max: 3, size: .md)
        DSAvatarGroup(users: users, max: 3, size: .lg)
        DSAvatarGroup(users: users, max: 3, size: .xl)
    }
    .padding()
}

#Preview("Avatar Group - With Initials") {
    VStack(spacing: 24) {
        DSAvatarGroup(
            initials: ["JD", "AB", "CD", "EF", "GH"],
            max: 3,
            size: .lg
        )

        DSAvatarGroup(
            initials: ["A", "B", "C"],
            max: 5,
            size: .lg
        )
    }
    .padding()
}

#Preview("Avatar Group - Overlap Ratios") {
    let initials = ["JD", "AB", "CD", "EF"]

    return VStack(spacing: 24) {
        VStack {
            DSAvatarGroup(initials: initials, max: 4, size: .lg, overlapRatio: 0.1)
            Text("10% overlap").font(.caption)
        }
        VStack {
            DSAvatarGroup(initials: initials, max: 4, size: .lg, overlapRatio: 0.25)
            Text("25% overlap (default)").font(.caption)
        }
        VStack {
            DSAvatarGroup(initials: initials, max: 4, size: .lg, overlapRatio: 0.5)
            Text("50% overlap").font(.caption)
        }
    }
    .padding()
}

#Preview("Avatar Group - Dark Mode") {
    let users = [
        SimpleAvatarUser(displayName: "John Doe"),
        SimpleAvatarUser(displayName: "Alice Brown"),
        SimpleAvatarUser(displayName: "Charlie Davis"),
        SimpleAvatarUser(displayName: "Eve Foster")
    ]

    return VStack(spacing: 24) {
        DSAvatarGroup(
            users: users,
            max: 3,
            size: .lg,
            ringColor: Color(.systemBackground)
        )
    }
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}

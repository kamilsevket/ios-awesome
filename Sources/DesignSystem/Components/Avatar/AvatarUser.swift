import Foundation

/// Protocol for objects that can be represented as an avatar
public protocol AvatarUser {
    /// URL for the user's avatar image
    var avatarURL: URL? { get }

    /// Display name used for generating initials
    var displayName: String? { get }
}

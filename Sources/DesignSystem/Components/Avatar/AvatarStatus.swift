import SwiftUI

/// Online status for avatar indicator
public enum AvatarStatus {
    case online
    case offline
    case busy
    case away

    /// Color for the status indicator
    public var color: Color {
        switch self {
        case .online: return .green
        case .offline: return .gray
        case .busy: return .red
        case .away: return .orange
        }
    }
}

/// Position of the status indicator on the avatar
public enum StatusIndicatorPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    /// Alignment for positioning the indicator
    public var alignment: Alignment {
        switch self {
        case .topLeft: return .topLeading
        case .topRight: return .topTrailing
        case .bottomLeft: return .bottomLeading
        case .bottomRight: return .bottomTrailing
        }
    }
}

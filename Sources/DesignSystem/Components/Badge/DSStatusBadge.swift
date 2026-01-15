import SwiftUI

/// A status indicator badge with dot and optional text
///
/// Use `DSStatusBadge` to show user or system status.
///
/// ```swift
/// DSStatusBadge(.online)
/// DSStatusBadge(.online, text: "Active")
/// DSStatusBadge(.busy, text: "Do Not Disturb")
/// ```
public struct DSStatusBadge: View {
    // MARK: - Properties

    private let status: DSStatus
    private let text: String?
    private let size: DSStatusBadgeSize
    private let showPulse: Bool

    @State private var isPulsing = false

    // MARK: - Initialization

    /// Creates a status badge
    /// - Parameters:
    ///   - status: The status to display
    ///   - text: Optional text label to show next to the dot
    ///   - size: The size variant (default: .md)
    ///   - showPulse: Whether to show pulse animation for online status (default: true)
    public init(
        _ status: DSStatus,
        text: String? = nil,
        size: DSStatusBadgeSize = .md,
        showPulse: Bool = true
    ) {
        self.status = status
        self.text = text
        self.size = size
        self.showPulse = showPulse
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            statusDot
            if let text = text {
                Text(text)
                    .font(size.font)
                    .foregroundColor(textColor)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    // MARK: - Private Views

    @ViewBuilder
    private var statusDot: some View {
        ZStack {
            if showPulse && status == .online {
                Circle()
                    .fill(status.color.opacity(0.4))
                    .frame(width: size.dotSize * 1.8, height: size.dotSize * 1.8)
                    .scaleEffect(isPulsing ? 1.2 : 0.8)
                    .opacity(isPulsing ? 0 : 0.6)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: false),
                        value: isPulsing
                    )
                    .onAppear { isPulsing = true }
            }

            Circle()
                .fill(status.color)
                .frame(width: size.dotSize, height: size.dotSize)
        }
    }

    // MARK: - Computed Properties

    private var textColor: Color {
        Color.primary
    }

    private var accessibilityText: String {
        if let text = text {
            return "\(status.accessibilityLabel): \(text)"
        }
        return status.accessibilityLabel
    }
}

// MARK: - Status Types

/// Available status types for DSStatusBadge
public enum DSStatus: CaseIterable {
    case online
    case offline
    case busy
    case away

    var color: Color {
        switch self {
        case .online: return DSColors.statusOnline
        case .offline: return DSColors.statusOffline
        case .busy: return DSColors.statusBusy
        case .away: return DSColors.statusAway
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .online: return "Online"
        case .offline: return "Offline"
        case .busy: return "Busy"
        case .away: return "Away"
        }
    }
}

// MARK: - Size Configuration

/// Size variants for DSStatusBadge
public enum DSStatusBadgeSize {
    case sm
    case md

    var dotSize: CGFloat {
        switch self {
        case .sm: return 8
        case .md: return 10
        }
    }

    var font: Font {
        switch self {
        case .sm: return .caption2
        case .md: return .caption
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSStatusBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Group {
                Text("Status Dots Only")
                    .font(.headline)
                HStack(spacing: 16) {
                    ForEach(DSStatus.allCases, id: \.self) { status in
                        DSStatusBadge(status)
                    }
                }
            }

            Group {
                Text("With Labels (Small)")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    DSStatusBadge(.online, text: "Online", size: .sm)
                    DSStatusBadge(.away, text: "Away", size: .sm)
                    DSStatusBadge(.busy, text: "Do Not Disturb", size: .sm)
                    DSStatusBadge(.offline, text: "Offline", size: .sm)
                }
            }

            Group {
                Text("With Labels (Medium)")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    DSStatusBadge(.online, text: "Active")
                    DSStatusBadge(.away, text: "Away")
                    DSStatusBadge(.busy, text: "Busy")
                    DSStatusBadge(.offline, text: "Offline")
                }
            }

            Group {
                Text("User Status Example")
                    .font(.headline)
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("JD")
                                .font(.caption)
                                .fontWeight(.medium)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text("John Doe")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        DSStatusBadge(.online, text: "Active now", size: .sm)
                    }
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("DSStatusBadge")
    }
}
#endif

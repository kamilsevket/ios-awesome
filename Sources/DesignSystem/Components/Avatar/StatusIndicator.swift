import SwiftUI

/// Status indicator dot overlay for avatars
struct StatusIndicator: View {
    let status: AvatarStatus
    let size: AvatarSize

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Circle()
            .fill(status.color)
            .frame(width: size.statusIndicatorSize, height: size.statusIndicatorSize)
            .overlay {
                Circle()
                    .strokeBorder(borderColor, lineWidth: size.statusBorderWidth)
            }
    }

    private var borderColor: Color {
        colorScheme == .dark ? Color(.systemBackground) : .white
    }
}

// MARK: - Preview

#Preview("Status Indicator") {
    VStack(spacing: 24) {
        HStack(spacing: 32) {
            VStack {
                StatusIndicator(status: .online, size: .lg)
                Text("Online").font(.caption)
            }
            VStack {
                StatusIndicator(status: .offline, size: .lg)
                Text("Offline").font(.caption)
            }
            VStack {
                StatusIndicator(status: .busy, size: .lg)
                Text("Busy").font(.caption)
            }
            VStack {
                StatusIndicator(status: .away, size: .lg)
                Text("Away").font(.caption)
            }
        }

        HStack(spacing: 16) {
            StatusIndicator(status: .online, size: .xs)
            StatusIndicator(status: .online, size: .sm)
            StatusIndicator(status: .online, size: .md)
            StatusIndicator(status: .online, size: .lg)
            StatusIndicator(status: .online, size: .xl)
        }
    }
    .padding()
}

#Preview("Status Indicator - Dark Mode") {
    VStack(spacing: 24) {
        HStack(spacing: 32) {
            StatusIndicator(status: .online, size: .lg)
            StatusIndicator(status: .offline, size: .lg)
            StatusIndicator(status: .busy, size: .lg)
            StatusIndicator(status: .away, size: .lg)
        }
    }
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}

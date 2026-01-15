import SwiftUI

// MARK: - Badge Overlay Modifier

extension View {
    /// Adds a notification badge overlay to a view
    ///
    /// ```swift
    /// Image(systemName: "bell.fill")
    ///     .badgeOverlay(count: 5)
    ///
    /// Button("Messages") { }
    ///     .badgeOverlay(count: unreadCount, alignment: .topTrailing)
    /// ```
    ///
    /// - Parameters:
    ///   - count: The number to display in the badge
    ///   - maxCount: Maximum count before showing "+" suffix (default: 99)
    ///   - showZero: Whether to show the badge when count is 0 (default: false)
    ///   - size: The size variant of the badge (default: .sm)
    ///   - alignment: Where to position the badge (default: .topTrailing)
    ///   - offset: Custom offset for the badge position
    /// - Returns: A view with the badge overlay
    public func badgeOverlay(
        count: Int,
        maxCount: Int = 99,
        showZero: Bool = false,
        size: DSBadgeSize = .sm,
        alignment: Alignment = .topTrailing,
        offset: CGPoint = CGPoint(x: 8, y: -8)
    ) -> some View {
        overlay(alignment: alignment) {
            DSBadge(count: count, maxCount: maxCount, showZero: showZero, size: size)
                .offset(x: offset.x, y: offset.y)
        }
    }

    /// Adds a status badge overlay to a view
    ///
    /// ```swift
    /// Image("avatar")
    ///     .statusBadgeOverlay(.online)
    /// ```
    ///
    /// - Parameters:
    ///   - status: The status to display
    ///   - alignment: Where to position the badge (default: .bottomTrailing)
    ///   - offset: Custom offset for the badge position
    /// - Returns: A view with the status badge overlay
    public func statusBadgeOverlay(
        _ status: DSStatus,
        alignment: Alignment = .bottomTrailing,
        offset: CGPoint = CGPoint(x: 2, y: 2)
    ) -> some View {
        overlay(alignment: alignment) {
            DSStatusBadge(status, showPulse: true)
                .offset(x: offset.x, y: offset.y)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ViewBadgeModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            Group {
                Text("Badge Overlay on Icons")
                    .font(.headline)
                HStack(spacing: 32) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 24))
                        .badgeOverlay(count: 3)

                    Image(systemName: "envelope.fill")
                        .font(.system(size: 24))
                        .badgeOverlay(count: 99)

                    Image(systemName: "cart.fill")
                        .font(.system(size: 24))
                        .badgeOverlay(count: 150)
                }
            }

            Group {
                Text("Status Badge on Avatar")
                    .font(.headline)
                HStack(spacing: 24) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 48, height: 48)
                        .overlay(Text("A").fontWeight(.medium))
                        .statusBadgeOverlay(.online)

                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 48, height: 48)
                        .overlay(Text("B").fontWeight(.medium))
                        .statusBadgeOverlay(.away)

                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 48, height: 48)
                        .overlay(Text("C").fontWeight(.medium))
                        .statusBadgeOverlay(.busy)

                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 48, height: 48)
                        .overlay(Text("D").fontWeight(.medium))
                        .statusBadgeOverlay(.offline)
                }
            }

            Group {
                Text("Badge on Button")
                    .font(.headline)
                Button {
                } label: {
                    Label("Notifications", systemImage: "bell")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .badgeOverlay(count: 5, offset: CGPoint(x: 12, y: -12))
            }

            Group {
                Text("Custom Alignment")
                    .font(.headline)
                HStack(spacing: 32) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .badgeOverlay(count: 1, alignment: .topLeading, offset: CGPoint(x: -8, y: -8))

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .badgeOverlay(count: 2, alignment: .topTrailing, offset: CGPoint(x: 8, y: -8))

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .badgeOverlay(count: 3, alignment: .bottomTrailing, offset: CGPoint(x: 8, y: 8))
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Badge Overlay Modifiers")
    }
}
#endif

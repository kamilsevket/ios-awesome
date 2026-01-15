import SwiftUI

/// A notification badge that displays a count
///
/// Use `DSBadge` to show notification counts, typically overlaid on icons or buttons.
/// Counts above 99 are displayed as "99+".
///
/// ```swift
/// DSBadge(count: 5)
/// DSBadge(count: 150) // Shows "99+"
/// DSBadge(count: 0, showZero: true)
/// ```
public struct DSBadge: View {
    // MARK: - Properties

    private let count: Int
    private let maxCount: Int
    private let showZero: Bool
    private let size: DSBadgeSize

    @State private var animatedCount: Int
    @State private var scale: CGFloat = 1.0

    // MARK: - Initialization

    /// Creates a notification badge with a count
    /// - Parameters:
    ///   - count: The number to display
    ///   - maxCount: Maximum count before showing "+" suffix (default: 99)
    ///   - showZero: Whether to show the badge when count is 0 (default: false)
    ///   - size: The size variant of the badge (default: .md)
    public init(
        count: Int,
        maxCount: Int = 99,
        showZero: Bool = false,
        size: DSBadgeSize = .md
    ) {
        self.count = max(0, count)
        self.maxCount = maxCount
        self.showZero = showZero
        self.size = size
        self._animatedCount = State(initialValue: max(0, count))
    }

    // MARK: - Body

    public var body: some View {
        if shouldShow {
            badgeContent
                .scaleEffect(scale)
                .onChange(of: count) { newValue in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        scale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                            scale = 1.0
                            animatedCount = max(0, newValue)
                        }
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(accessibilityText)
        }
    }

    // MARK: - Private Views

    @ViewBuilder
    private var badgeContent: some View {
        Text(displayText)
            .font(size.font)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(minWidth: size.minWidth, minHeight: size.minHeight)
            .background(
                Capsule()
                    .fill(DSColors.badgeRed)
            )
    }

    // MARK: - Computed Properties

    private var shouldShow: Bool {
        count > 0 || showZero
    }

    private var displayText: String {
        if animatedCount > maxCount {
            return "\(maxCount)+"
        }
        return "\(animatedCount)"
    }

    private var accessibilityText: String {
        if count == 0 {
            return "No notifications"
        } else if count == 1 {
            return "1 notification"
        } else if count > maxCount {
            return "More than \(maxCount) notifications"
        } else {
            return "\(count) notifications"
        }
    }
}

// MARK: - Size Configuration

/// Size variants for DSBadge
public enum DSBadgeSize {
    case sm
    case md

    var font: Font {
        switch self {
        case .sm: return .system(size: 10)
        case .md: return .system(size: 12)
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .sm: return DSSpacing.xs
        case .md: return DSSpacing.sm
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .sm: return DSSpacing.xxs
        case .md: return DSSpacing.xs
        }
    }

    var minWidth: CGFloat {
        switch self {
        case .sm: return 16
        case .md: return 20
        }
    }

    var minHeight: CGFloat {
        switch self {
        case .sm: return 16
        case .md: return 20
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Group {
                Text("Small Badges")
                    .font(.headline)
                HStack(spacing: 16) {
                    DSBadge(count: 1, size: .sm)
                    DSBadge(count: 9, size: .sm)
                    DSBadge(count: 99, size: .sm)
                    DSBadge(count: 150, size: .sm)
                }
            }

            Group {
                Text("Medium Badges")
                    .font(.headline)
                HStack(spacing: 16) {
                    DSBadge(count: 1)
                    DSBadge(count: 9)
                    DSBadge(count: 99)
                    DSBadge(count: 150)
                }
            }

            Group {
                Text("Badge on Icon")
                    .font(.headline)
                HStack(spacing: 32) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 24))
                        DSBadge(count: 3, size: .sm)
                            .offset(x: 8, y: -8)
                    }

                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 24))
                        DSBadge(count: 128)
                            .offset(x: 12, y: -8)
                    }
                }
            }

            Group {
                Text("Zero Badge")
                    .font(.headline)
                HStack(spacing: 16) {
                    DSBadge(count: 0, showZero: false)
                    DSBadge(count: 0, showZero: true)
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("DSBadge")
    }
}
#endif

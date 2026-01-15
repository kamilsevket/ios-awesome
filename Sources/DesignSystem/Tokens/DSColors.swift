import SwiftUI

/// Design System color tokens
public enum DSColors {
    // MARK: - Badge Colors
    public static let badgeRed = Color(red: 0.94, green: 0.27, blue: 0.27)
    public static let badgeRedDark = Color(red: 0.90, green: 0.22, blue: 0.22)

    // MARK: - Status Colors
    public static let statusOnline = Color(red: 0.20, green: 0.78, blue: 0.35)
    public static let statusOffline = Color(red: 0.60, green: 0.60, blue: 0.60)
    public static let statusBusy = Color(red: 0.94, green: 0.27, blue: 0.27)
    public static let statusAway = Color(red: 1.0, green: 0.76, blue: 0.03)

    // MARK: - Chip Colors
    public static let chipBackground = Color(red: 0.95, green: 0.95, blue: 0.97)
    public static let chipBackgroundDark = Color(red: 0.17, green: 0.17, blue: 0.18)
    public static let chipSelectedBackground = Color(red: 0.0, green: 0.48, blue: 1.0)
    public static let chipText = Color(red: 0.23, green: 0.23, blue: 0.26)
    public static let chipTextDark = Color(red: 0.92, green: 0.92, blue: 0.96)

    // MARK: - Semantic Colors
    public static let primary = Color(red: 0.0, green: 0.48, blue: 1.0)
    public static let success = Color(red: 0.20, green: 0.78, blue: 0.35)
    public static let warning = Color(red: 1.0, green: 0.76, blue: 0.03)
    public static let error = Color(red: 0.94, green: 0.27, blue: 0.27)
    public static let info = Color(red: 0.35, green: 0.68, blue: 0.98)

    // MARK: - Destructive Colors
    public static let destructive = Color(red: 0.94, green: 0.27, blue: 0.27)
    public static let destructiveDark = Color(red: 0.90, green: 0.22, blue: 0.22)

    // MARK: - Background Colors
    public static let backdrop = Color.black.opacity(0.4)
    public static let alertBackground = Color(UIColor.systemBackground)
    public static let alertBackgroundSecondary = Color(UIColor.secondarySystemBackground)

    // MARK: - Loading Colors
    public static let loadingTrack = Color(UIColor.systemGray5)
    public static let loadingTrackDark = Color(UIColor.systemGray4)
    public static let shimmerBase = Color(UIColor.systemGray5)
    public static let shimmerHighlight = Color(UIColor.systemGray6)
}

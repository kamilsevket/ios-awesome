import SwiftUI

/// Design System color tokens providing semantic colors for the entire design system.
/// All colors automatically support light and dark mode.
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
    public static let primarySelected = Color(red: 0.0, green: 0.35, blue: 0.8)
    public static let success = Color(red: 0.20, green: 0.78, blue: 0.35)
    public static let warning = Color(red: 1.0, green: 0.76, blue: 0.03)
    public static let error = Color(red: 0.94, green: 0.27, blue: 0.27)
    public static let info = Color(red: 0.35, green: 0.68, blue: 0.98)

    // MARK: - Text Colors
    public static let textPrimary = Color(red: 0.11, green: 0.11, blue: 0.12)
    public static let textSecondary = Color(red: 0.45, green: 0.45, blue: 0.50)
    public static let textTertiary = Color(red: 0.60, green: 0.60, blue: 0.65)
    public static let textDisabled = Color(red: 0.60, green: 0.60, blue: 0.65)
    public static let textInverse = Color(red: 1.0, green: 1.0, blue: 1.0)

    // MARK: - Destructive Colors
    public static let destructive = Color(red: 0.94, green: 0.27, blue: 0.27)
    public static let destructiveDark = Color(red: 0.90, green: 0.22, blue: 0.22)

    // MARK: - Background Colors
    public static let backdrop = Color.black.opacity(0.4)
    public static let alertBackground = Color(UIColor.systemBackground)
    public static let alertBackgroundSecondary = Color(UIColor.secondarySystemBackground)
    public static let backgroundPrimary = Color(UIColor.systemBackground)
    public static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
    public static let backgroundTertiary = Color(UIColor.tertiarySystemBackground)

    // MARK: - Border Colors
    public static let border = Color(UIColor.separator)
    public static let borderFocused = primary
    public static let borderDisabled = Color(UIColor.quaternarySystemFill)

    // MARK: - Loading Colors
    public static let loadingTrack = Color(UIColor.systemGray5)
    public static let loadingTrackDark = Color(UIColor.systemGray4)
    public static let shimmerBase = Color(UIColor.systemGray5)
    public static let shimmerHighlight = Color(UIColor.systemGray6)

    // MARK: - Selection Control Colors
    public static let selectionUnchecked = Color(UIColor.systemBackground)
    public static let selectionBorder = Color(UIColor.systemGray3)
    public static let selectionChecked = primary
    public static let toggleTrackOff = Color(UIColor.systemGray5)
    public static let toggleTrackOn = success
    public static let toggleThumb = Color.white
}

import SwiftUI

/// Design System color tokens providing semantic colors for the entire design system.
/// All colors automatically support light and dark mode.
public enum DSColors {
    // MARK: - Primary Colors

    /// Primary brand color - used for main interactive elements
    public static let primary = Color(light: .init(hex: "#007AFF"), dark: .init(hex: "#0A84FF"))

    /// Primary color for selected/active states
    public static let primarySelected = Color(light: .init(hex: "#0056B3"), dark: .init(hex: "#409CFF"))

    // MARK: - Semantic Colors

    /// Success color - used for positive states and confirmations
    public static let success = Color(light: .init(hex: "#34C759"), dark: .init(hex: "#30D158"))

    /// Warning color - used for cautionary states
    public static let warning = Color(light: .init(hex: "#FF9500"), dark: .init(hex: "#FF9F0A"))

    /// Error/Destructive color - used for errors and destructive actions
    public static let error = Color(light: .init(hex: "#FF3B30"), dark: .init(hex: "#FF453A"))

    /// Info color - used for informational states
    public static let info = Color(light: .init(hex: "#5856D6"), dark: .init(hex: "#5E5CE6"))

    // MARK: - Background Colors

    /// Primary background color
    public static let backgroundPrimary = Color(light: .white, dark: .init(hex: "#000000"))

    /// Secondary background color
    public static let backgroundSecondary = Color(light: .init(hex: "#F2F2F7"), dark: .init(hex: "#1C1C1E"))

    /// Tertiary background color
    public static let backgroundTertiary = Color(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#2C2C2E"))

    // MARK: - Text Colors

    /// Primary text color
    public static let textPrimary = Color(light: .init(hex: "#000000"), dark: .init(hex: "#FFFFFF"))

    /// Secondary text color
    public static let textSecondary = Color(light: .init(hex: "#3C3C43", opacity: 0.6), dark: .init(hex: "#EBEBF5", opacity: 0.6))

    /// Tertiary text color
    public static let textTertiary = Color(light: .init(hex: "#3C3C43", opacity: 0.3), dark: .init(hex: "#EBEBF5", opacity: 0.3))

    /// Disabled text color
    public static let textDisabled = Color(light: .init(hex: "#3C3C43", opacity: 0.3), dark: .init(hex: "#EBEBF5", opacity: 0.3))

    // MARK: - Border Colors

    /// Default border color
    public static let border = Color(light: .init(hex: "#C6C6C8"), dark: .init(hex: "#38383A"))

    /// Border color for focused/active states
    public static let borderFocused = primary

    /// Border color for disabled states
    public static let borderDisabled = Color(light: .init(hex: "#E5E5EA"), dark: .init(hex: "#2C2C2E"))

    // MARK: - Selection Control Colors

    /// Checkbox/Radio unchecked background
    public static let selectionUnchecked = Color(light: .white, dark: .init(hex: "#1C1C1E"))

    /// Checkbox/Radio unchecked border
    public static let selectionBorder = Color(light: .init(hex: "#C7C7CC"), dark: .init(hex: "#48484A"))

    /// Checkbox/Radio checked background
    public static let selectionChecked = primary

    /// Toggle track off color
    public static let toggleTrackOff = Color(light: .init(hex: "#E9E9EB"), dark: .init(hex: "#39393D"))

    /// Toggle track on color
    public static let toggleTrackOn = success

    /// Toggle thumb color
    public static let toggleThumb = Color.white
}

// MARK: - Color Extensions

extension Color {
    /// Creates a color that adapts to light and dark mode
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }

    /// Creates a color from a hex string
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: opacity * Double(a) / 255
        )
    }
}

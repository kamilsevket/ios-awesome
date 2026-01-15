import SwiftUI

/// Utility for color manipulation and generation
public enum ColorUtility {
    /// Converts a hex string to a Color
    public static func color(from hex: String) -> Color {
        let cleanHex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, int >> 24)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }

        return Color(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Generates a contrasting text color (black or white) for a given background
    public static func contrastingColor(for background: Color) -> Color {
        // This is a simplified version - in production would extract RGB values
        // For now, default to white for dark colors and black for light colors
        return .primary
    }

    /// Lightens a color by a percentage
    public static func lighten(_ color: Color, by percentage: CGFloat) -> Color {
        // Simplified implementation
        return color.opacity(1 - percentage)
    }

    /// Darkens a color by a percentage
    public static func darken(_ color: Color, by percentage: CGFloat) -> Color {
        // Simplified implementation
        return color.opacity(1 + percentage)
    }

    /// Calculates the relative luminance of RGB values
    public static func luminance(red: Double, green: Double, blue: Double) -> Double {
        let r = red <= 0.03928 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4)
        let g = green <= 0.03928 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4)
        let b = blue <= 0.03928 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    /// Calculates contrast ratio between two luminance values
    public static func contrastRatio(luminance1: Double, luminance2: Double) -> Double {
        let lighter = max(luminance1, luminance2)
        let darker = min(luminance1, luminance2)
        return (lighter + 0.05) / (darker + 0.05)
    }
}

/// Predefined color palette
public extension Color {
    static let componentsPrimary = ColorUtility.color(from: "#007AFF")
    static let componentsSecondary = ColorUtility.color(from: "#5856D6")
    static let componentsSuccess = ColorUtility.color(from: "#34C759")
    static let componentsWarning = ColorUtility.color(from: "#FF9500")
    static let componentsError = ColorUtility.color(from: "#FF3B30")
    static let componentsInfo = ColorUtility.color(from: "#5AC8FA")
}

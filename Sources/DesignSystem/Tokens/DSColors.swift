import SwiftUI

/// Design System color tokens
public enum DSColors {
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
}

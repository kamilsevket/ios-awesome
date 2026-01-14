import SwiftUI

/// Color tokens representing the design system's color palette.
/// All colors support automatic dark/light mode switching via Asset Catalog.
public enum ColorTokens {

    // MARK: - Primary Colors (Blue)

    public enum Primary {
        public static let shade50 = Color("Primary/Primary50", bundle: .module)
        public static let shade100 = Color("Primary/Primary100", bundle: .module)
        public static let shade200 = Color("Primary/Primary200", bundle: .module)
        public static let shade300 = Color("Primary/Primary300", bundle: .module)
        public static let shade400 = Color("Primary/Primary400", bundle: .module)
        public static let shade500 = Color("Primary/Primary500", bundle: .module)
        public static let shade600 = Color("Primary/Primary600", bundle: .module)
        public static let shade700 = Color("Primary/Primary700", bundle: .module)
        public static let shade800 = Color("Primary/Primary800", bundle: .module)
        public static let shade900 = Color("Primary/Primary900", bundle: .module)
    }

    // MARK: - Secondary Colors (Green)

    public enum Secondary {
        public static let shade50 = Color("Secondary/Secondary50", bundle: .module)
        public static let shade100 = Color("Secondary/Secondary100", bundle: .module)
        public static let shade200 = Color("Secondary/Secondary200", bundle: .module)
        public static let shade300 = Color("Secondary/Secondary300", bundle: .module)
        public static let shade400 = Color("Secondary/Secondary400", bundle: .module)
        public static let shade500 = Color("Secondary/Secondary500", bundle: .module)
        public static let shade600 = Color("Secondary/Secondary600", bundle: .module)
        public static let shade700 = Color("Secondary/Secondary700", bundle: .module)
        public static let shade800 = Color("Secondary/Secondary800", bundle: .module)
        public static let shade900 = Color("Secondary/Secondary900", bundle: .module)
    }

    // MARK: - Tertiary Colors (Purple)

    public enum Tertiary {
        public static let shade50 = Color("Tertiary/Tertiary50", bundle: .module)
        public static let shade100 = Color("Tertiary/Tertiary100", bundle: .module)
        public static let shade200 = Color("Tertiary/Tertiary200", bundle: .module)
        public static let shade300 = Color("Tertiary/Tertiary300", bundle: .module)
        public static let shade400 = Color("Tertiary/Tertiary400", bundle: .module)
        public static let shade500 = Color("Tertiary/Tertiary500", bundle: .module)
        public static let shade600 = Color("Tertiary/Tertiary600", bundle: .module)
        public static let shade700 = Color("Tertiary/Tertiary700", bundle: .module)
        public static let shade800 = Color("Tertiary/Tertiary800", bundle: .module)
        public static let shade900 = Color("Tertiary/Tertiary900", bundle: .module)
    }

    // MARK: - Semantic Colors

    public enum Semantic {
        public static let success = Color("Semantic/Success", bundle: .module)
        public static let successLight = Color("Semantic/SuccessLight", bundle: .module)
        public static let warning = Color("Semantic/Warning", bundle: .module)
        public static let warningLight = Color("Semantic/WarningLight", bundle: .module)
        public static let error = Color("Semantic/Error", bundle: .module)
        public static let errorLight = Color("Semantic/ErrorLight", bundle: .module)
        public static let info = Color("Semantic/Info", bundle: .module)
        public static let infoLight = Color("Semantic/InfoLight", bundle: .module)
    }

    // MARK: - UI Colors

    public enum UI {
        public static let background = Color("UI/Background", bundle: .module)
        public static let backgroundSecondary = Color("UI/BackgroundSecondary", bundle: .module)
        public static let surface = Color("UI/Surface", bundle: .module)
        public static let surfaceElevated = Color("UI/SurfaceElevated", bundle: .module)
        public static let textPrimary = Color("UI/TextPrimary", bundle: .module)
        public static let textSecondary = Color("UI/TextSecondary", bundle: .module)
        public static let textTertiary = Color("UI/TextTertiary", bundle: .module)
        public static let textInverse = Color("UI/TextInverse", bundle: .module)
        public static let border = Color("UI/Border", bundle: .module)
        public static let divider = Color("UI/Divider", bundle: .module)
    }
}

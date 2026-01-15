import SwiftUI

// MARK: - Picker Display Mode

/// Defines how the picker is displayed
public enum DSPickerDisplayMode {
    /// Compact inline display (single row)
    case compact
    /// Inline display showing full picker
    case inline
    /// Wheel style picker
    case wheel
    /// Graphical style (calendar for dates)
    case graphical

    @available(iOS 15.0, *)
    var datePickerStyle: any DatePickerStyle {
        switch self {
        case .compact:
            return .compact
        case .inline, .graphical:
            return .graphical
        case .wheel:
            return .wheel
        }
    }
}

// MARK: - Picker Size

/// Size variants for pickers
public enum DSPickerSize {
    case small
    case medium
    case large

    var font: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .body
        case .large: return .title3
        }
    }

    var labelFont: Font {
        switch self {
        case .small: return .caption
        case .medium: return .subheadline
        case .large: return .body
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 16
        case .large: return 20
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 10
        case .large: return 12
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 48
        }
    }
}

// MARK: - Picker Variant

/// Visual style variants for pickers
public enum DSPickerVariant {
    /// Default picker appearance
    case `default`
    /// Outlined picker with border
    case outlined
    /// Filled picker with background
    case filled

    func backgroundColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .default:
            return .clear
        case .outlined:
            return .clear
        case .filled:
            return colorScheme == .dark
                ? Color(UIColor.secondarySystemBackground)
                : Color(UIColor.systemGray6)
        }
    }

    func borderColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .default:
            return .clear
        case .outlined:
            return colorScheme == .dark
                ? Color(UIColor.systemGray4)
                : Color(UIColor.systemGray3)
        case .filled:
            return .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .default: return 0
        case .outlined: return 1
        case .filled: return 0
        }
    }
}

import SwiftUI

/// A tag/label component for categorization
///
/// Use `DSTag` for displaying labels, categories, or keywords.
///
/// ```swift
/// DSTag("Swift")
/// DSTag("iOS", icon: Image(systemName: "apple.logo"))
/// DSTag("Removable", onDismiss: { print("dismissed") })
/// ```
public struct DSTag: View {
    // MARK: - Properties

    private let text: String
    private let icon: Image?
    private let variant: DSTagVariant
    private let size: DSTagSize
    private let onDismiss: (() -> Void)?

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a tag
    /// - Parameters:
    ///   - text: The text to display
    ///   - icon: Optional leading icon
    ///   - variant: The color variant (default: .default)
    ///   - size: The size variant (default: .md)
    ///   - onDismiss: Optional closure called when dismiss button is tapped
    public init(
        _ text: String,
        icon: Image? = nil,
        variant: DSTagVariant = .default,
        size: DSTagSize = .md,
        onDismiss: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.variant = variant
        self.size = size
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            if let icon = icon {
                icon
                    .font(size.iconFont)
                    .foregroundColor(foregroundColor)
            }

            Text(text)
                .font(size.font)
                .fontWeight(.medium)
                .foregroundColor(foregroundColor)
                .lineLimit(1)

            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(size.dismissFont)
                        .foregroundColor(foregroundColor.opacity(0.7))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Remove \(text)")
            }
        }
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .frame(minHeight: size.minHeight)
        .background(
            Capsule()
                .fill(backgroundColor)
        )
        .overlay(
            Capsule()
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
        .accessibilityAddTraits(onDismiss != nil ? .isButton : [])
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        variant.backgroundColor
    }

    private var foregroundColor: Color {
        variant.foregroundColor
    }

    private var borderColor: Color {
        variant.borderColor
    }
}

// MARK: - Tag Variants

/// Color variants for DSTag
public enum DSTagVariant {
    case `default`
    case primary
    case success
    case warning
    case error
    case info

    var backgroundColor: Color {
        switch self {
        case .default: return DSColors.chipBackground
        case .primary: return DSColors.primary.opacity(0.12)
        case .success: return DSColors.success.opacity(0.12)
        case .warning: return DSColors.warning.opacity(0.12)
        case .error: return DSColors.error.opacity(0.12)
        case .info: return DSColors.info.opacity(0.12)
        }
    }

    var foregroundColor: Color {
        switch self {
        case .default: return DSColors.chipText
        case .primary: return DSColors.primary
        case .success: return DSColors.success
        case .warning: return Color(red: 0.7, green: 0.5, blue: 0.0)
        case .error: return DSColors.error
        case .info: return Color(red: 0.2, green: 0.5, blue: 0.9)
        }
    }

    var borderColor: Color {
        switch self {
        case .default: return Color.clear
        case .primary: return DSColors.primary.opacity(0.3)
        case .success: return DSColors.success.opacity(0.3)
        case .warning: return DSColors.warning.opacity(0.3)
        case .error: return DSColors.error.opacity(0.3)
        case .info: return DSColors.info.opacity(0.3)
        }
    }
}

// MARK: - Size Configuration

/// Size variants for DSTag
public enum DSTagSize {
    case sm
    case md

    var font: Font {
        switch self {
        case .sm: return .caption2
        case .md: return .caption
        }
    }

    var iconFont: Font {
        switch self {
        case .sm: return .system(size: 10)
        case .md: return .system(size: 12)
        }
    }

    var dismissFont: Font {
        switch self {
        case .sm: return .system(size: 8, weight: .bold)
        case .md: return .system(size: 10, weight: .bold)
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .sm: return DSSpacing.sm
        case .md: return DSSpacing.md
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .sm: return DSSpacing.xs
        case .md: return DSSpacing.sm
        }
    }

    var minHeight: CGFloat {
        switch self {
        case .sm: return 24
        case .md: return 28
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Group {
                Text("Default Tags")
                    .font(.headline)
                HStack(spacing: 8) {
                    DSTag("Swift")
                    DSTag("iOS")
                    DSTag("SwiftUI")
                }
            }

            Group {
                Text("Size Variants")
                    .font(.headline)
                HStack(spacing: 8) {
                    DSTag("Small", size: .sm)
                    DSTag("Medium", size: .md)
                }
            }

            Group {
                Text("Color Variants")
                    .font(.headline)
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        DSTag("Default", variant: .default)
                        DSTag("Primary", variant: .primary)
                        DSTag("Success", variant: .success)
                    }
                    HStack(spacing: 8) {
                        DSTag("Warning", variant: .warning)
                        DSTag("Error", variant: .error)
                        DSTag("Info", variant: .info)
                    }
                }
            }

            Group {
                Text("With Icons")
                    .font(.headline)
                HStack(spacing: 8) {
                    DSTag("Apple", icon: Image(systemName: "apple.logo"))
                    DSTag("Star", icon: Image(systemName: "star.fill"), variant: .warning)
                    DSTag("Check", icon: Image(systemName: "checkmark"), variant: .success)
                }
            }

            Group {
                Text("Dismissible")
                    .font(.headline)
                HStack(spacing: 8) {
                    DSTag("Remove me") { }
                    DSTag("Filter", variant: .primary) { }
                }
            }

            Group {
                Text("Disabled State")
                    .font(.headline)
                HStack(spacing: 8) {
                    DSTag("Disabled")
                        .disabled(true)
                    DSTag("Enabled")
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("DSTag")
    }
}
#endif

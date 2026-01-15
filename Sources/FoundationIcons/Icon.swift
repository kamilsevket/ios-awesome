import SwiftUI

// MARK: - IconSize

/// Predefined icon sizes for consistent sizing across the app.
public enum IconSize: CGFloat, CaseIterable, Sendable {
    /// Extra small icon (12pt)
    case xs = 12

    /// Small icon (16pt)
    case sm = 16

    /// Medium icon (20pt) - Default
    case md = 20

    /// Large icon (24pt)
    case lg = 24

    /// Extra large icon (32pt)
    case xl = 32

    /// Extra extra large icon (48pt)
    case xxl = 48

    /// The point size value
    public var pointSize: CGFloat {
        rawValue
    }
}

// MARK: - IconWeight

/// Wrapper for SF Symbol weights
public enum IconWeight: Sendable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    var fontWeight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
}

// MARK: - Icon

/// A unified icon view component that supports both SF Symbols and custom icons.
///
/// ## Usage
/// ```swift
/// // SF Symbol
/// Icon.system(.heart)
///
/// // Custom icon
/// Icon.custom(.logo)
///
/// // With size
/// Icon.system(.star, size: .lg)
///
/// // With weight (SF Symbols only)
/// Icon.system(.chevronRight, weight: .bold)
///
/// // Full customization
/// Icon.system(.bell, size: .xl)
///     .foregroundStyle(.blue)
/// ```
public struct Icon: View {
    private let content: IconContent
    private let size: IconSize
    private let weight: IconWeight?

    private enum IconContent {
        case system(SFSymbol)
        case custom(CustomIcon)
    }

    // MARK: - Initializers

    private init(content: IconContent, size: IconSize, weight: IconWeight?) {
        self.content = content
        self.size = size
        self.weight = weight
    }

    /// Creates an icon from an SF Symbol
    /// - Parameters:
    ///   - symbol: The SF Symbol to display
    ///   - size: The size of the icon (default: .md)
    ///   - weight: The weight/thickness of the symbol (default: nil, uses system default)
    /// - Returns: An Icon view
    public static func system(
        _ symbol: SFSymbol,
        size: IconSize = .md,
        weight: IconWeight? = nil
    ) -> Icon {
        Icon(content: .system(symbol), size: size, weight: weight)
    }

    /// Creates an icon from a custom asset
    /// - Parameters:
    ///   - icon: The custom icon to display
    ///   - size: The size of the icon (default: .md)
    /// - Returns: An Icon view
    public static func custom(
        _ icon: CustomIcon,
        size: IconSize = .md
    ) -> Icon {
        Icon(content: .custom(icon), size: size, weight: nil)
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch content {
            case .system(let symbol):
                Image(sfSymbol: symbol)
                    .font(.system(size: size.pointSize, weight: weight?.fontWeight ?? .regular))
                    .imageScale(.large)
            case .custom(let icon):
                Image(customIcon: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.pointSize, height: size.pointSize)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Icon Modifiers

public extension Icon {
    /// Returns a new icon with the specified size
    /// - Parameter size: The new size
    /// - Returns: A new Icon with the updated size
    func size(_ size: IconSize) -> Icon {
        switch content {
        case .system(let symbol):
            return .system(symbol, size: size, weight: weight)
        case .custom(let icon):
            return .custom(icon, size: size)
        }
    }

    /// Returns a new icon with the specified weight (SF Symbols only)
    /// - Parameter weight: The new weight
    /// - Returns: A new Icon with the updated weight
    func weight(_ weight: IconWeight) -> Icon {
        switch content {
        case .system(let symbol):
            return .system(symbol, size: size, weight: weight)
        case .custom(let icon):
            return .custom(icon, size: size)
        }
    }
}

// MARK: - IconButton

/// A button with an icon.
///
/// ## Usage
/// ```swift
/// IconButton(.system(.heart)) {
///     // Action
/// }
///
/// IconButton(.custom(.settings), size: .lg) {
///     // Action
/// }
/// ```
public struct IconButton: View {
    private let icon: Icon
    private let action: () -> Void

    /// Creates an icon button with an SF Symbol
    /// - Parameters:
    ///   - symbol: The SF Symbol to display
    ///   - size: The size of the icon
    ///   - action: The action to perform when tapped
    public init(
        _ symbol: SFSymbol,
        size: IconSize = .md,
        action: @escaping () -> Void
    ) {
        self.icon = .system(symbol, size: size)
        self.action = action
    }

    /// Creates an icon button with a custom icon
    /// - Parameters:
    ///   - customIcon: The custom icon to display
    ///   - size: The size of the icon
    ///   - action: The action to perform when tapped
    public init(
        _ customIcon: CustomIcon,
        size: IconSize = .md,
        action: @escaping () -> Void
    ) {
        self.icon = .custom(customIcon, size: size)
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            icon
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Convenience Extensions

public extension View {
    /// Adds an icon overlay to the view
    /// - Parameters:
    ///   - symbol: The SF Symbol to overlay
    ///   - alignment: The alignment of the overlay
    /// - Returns: The view with an icon overlay
    func iconOverlay(
        _ symbol: SFSymbol,
        alignment: Alignment = .topTrailing
    ) -> some View {
        overlay(alignment: alignment) {
            Icon.system(symbol, size: .sm)
        }
    }

    /// Adds a custom icon overlay to the view
    /// - Parameters:
    ///   - icon: The custom icon to overlay
    ///   - alignment: The alignment of the overlay
    /// - Returns: The view with an icon overlay
    func iconOverlay(
        _ icon: CustomIcon,
        alignment: Alignment = .topTrailing
    ) -> some View {
        overlay(alignment: alignment) {
            Icon.custom(icon, size: .sm)
        }
    }
}

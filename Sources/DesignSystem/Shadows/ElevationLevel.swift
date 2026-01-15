import SwiftUI

// MARK: - Elevation Level

/// Design system elevation levels representing visual hierarchy depth.
///
/// Elevation levels map to shadow tokens and provide semantic meaning
/// for component layering in the UI hierarchy.
///
/// Usage:
/// ```swift
/// .elevation(.level2)
/// .elevation(.modal)
/// ```
public enum ElevationLevel: Int, CaseIterable, Sendable {
    /// Level 0: No elevation (flat surface)
    case level0 = 0
    /// Level 1: Slight elevation (cards, tiles)
    case level1 = 1
    /// Level 2: Medium elevation (raised buttons, floating action buttons)
    case level2 = 2
    /// Level 3: High elevation (navigation bars, app bars)
    case level3 = 3
    /// Level 4: Higher elevation (dialogs, pickers)
    case level4 = 4
    /// Level 5: Highest elevation (modals, overlays)
    case level5 = 5

    // MARK: - Semantic Aliases

    /// Flat surface with no elevation.
    public static let flat = ElevationLevel.level0

    /// Standard card elevation.
    public static let card = ElevationLevel.level1

    /// Raised interactive element elevation.
    public static let raised = ElevationLevel.level2

    /// Floating element elevation.
    public static let floating = ElevationLevel.level3

    /// Dialog/picker elevation.
    public static let dialog = ElevationLevel.level4

    /// Modal overlay elevation.
    public static let modal = ElevationLevel.level5

    // MARK: - Shadow Token Mapping

    /// The shadow token corresponding to this elevation level.
    public var shadowToken: ShadowToken {
        switch self {
        case .level0: return .none
        case .level1: return .sm
        case .level2: return .md
        case .level3: return .md
        case .level4: return .lg
        case .level5: return .xl
        }
    }

    /// The z-index value for this elevation level.
    public var zIndex: Double {
        Double(rawValue)
    }
}

// MARK: - Elevation Modifier

/// A view modifier that applies elevation with shadow and z-index.
public struct ElevationModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let level: ElevationLevel
    private let includeZIndex: Bool

    public init(level: ElevationLevel, includeZIndex: Bool = true) {
        self.level = level
        self.includeZIndex = includeZIndex
    }

    public func body(content: Content) -> some View {
        content
            .shadow(level.shadowToken, colorScheme: colorScheme)
            .zIndex(includeZIndex ? level.zIndex : 0)
    }
}

// MARK: - View Extension

public extension View {
    /// Applies an elevation level to the view with appropriate shadow and z-index.
    ///
    /// - Parameters:
    ///   - level: The elevation level to apply.
    ///   - includeZIndex: Whether to set the z-index based on elevation. Default is true.
    /// - Returns: A view with the elevation applied.
    func elevation(_ level: ElevationLevel, includeZIndex: Bool = true) -> some View {
        modifier(ElevationModifier(level: level, includeZIndex: includeZIndex))
    }
}

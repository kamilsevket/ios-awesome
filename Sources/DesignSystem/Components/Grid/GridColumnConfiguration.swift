import SwiftUI

// MARK: - Grid Column Configuration

/// Configuration for grid column layout
public enum DSGridColumns: Equatable, Sendable {
    /// Fixed number of columns
    case fixed(Int)

    /// Adaptive columns with minimum item width
    case adaptive(minimum: CGFloat, maximum: CGFloat? = nil)

    /// Flexible columns that expand to fill available space
    case flexible(count: Int, minimumSize: CGFloat = 0)

    /// Returns the GridItem array for SwiftUI LazyVGrid
    @MainActor
    public func gridItems(spacing: CGFloat? = nil) -> [GridItem] {
        switch self {
        case .fixed(let count):
            return Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(1, count))

        case .adaptive(let minimum, let maximum):
            if let max = maximum {
                return [GridItem(.adaptive(minimum: minimum, maximum: max), spacing: spacing)]
            }
            return [GridItem(.adaptive(minimum: minimum), spacing: spacing)]

        case .flexible(let count, let minimumSize):
            return Array(
                repeating: GridItem(.flexible(minimum: minimumSize), spacing: spacing),
                count: max(1, count)
            )
        }
    }
}

// MARK: - Grid Spacing Configuration

/// Spacing configuration for grid layouts
public struct DSGridSpacing: Equatable, Sendable {
    /// Horizontal spacing between columns
    public let horizontal: CGFloat

    /// Vertical spacing between rows
    public let vertical: CGFloat

    public init(horizontal: CGFloat = Spacing.sm, vertical: CGFloat = Spacing.sm) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public init(uniform: CGFloat) {
        self.horizontal = uniform
        self.vertical = uniform
    }

    // MARK: - Preset Spacings

    /// No spacing between items
    public static let none = DSGridSpacing(uniform: 0)

    /// Extra small spacing (4pt)
    public static let xs = DSGridSpacing(uniform: Spacing.xs)

    /// Small spacing (8pt)
    public static let sm = DSGridSpacing(uniform: Spacing.sm)

    /// Medium spacing (16pt)
    public static let md = DSGridSpacing(uniform: Spacing.md)

    /// Large spacing (24pt)
    public static let lg = DSGridSpacing(uniform: Spacing.lg)
}

// MARK: - Section Configuration

/// Configuration for grid sections
public struct DSGridSection<Header: View, Footer: View>: Identifiable {
    public let id: String
    public let header: Header?
    public let footer: Footer?
    public let itemCount: Int

    public init(
        id: String = UUID().uuidString,
        itemCount: Int,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.id = id
        self.itemCount = itemCount
        self.header = header()
        self.footer = footer()
    }
}

extension DSGridSection where Header == EmptyView {
    public init(
        id: String = UUID().uuidString,
        itemCount: Int,
        @ViewBuilder footer: () -> Footer
    ) {
        self.id = id
        self.itemCount = itemCount
        self.header = nil
        self.footer = footer()
    }
}

extension DSGridSection where Footer == EmptyView {
    public init(
        id: String = UUID().uuidString,
        itemCount: Int,
        @ViewBuilder header: () -> Header
    ) {
        self.id = id
        self.itemCount = itemCount
        self.header = header()
        self.footer = nil
    }
}

extension DSGridSection where Header == EmptyView, Footer == EmptyView {
    public init(
        id: String = UUID().uuidString,
        itemCount: Int
    ) {
        self.id = id
        self.itemCount = itemCount
        self.header = nil
        self.footer = nil
    }
}

// MARK: - Selection Mode

/// Selection mode for grid items
public enum DSGridSelectionMode: Equatable, Sendable {
    /// No selection allowed
    case none

    /// Single item selection
    case single

    /// Multiple item selection
    case multiple

    /// Multiple selection with maximum count
    case multiple(max: Int)

    public static func == (lhs: DSGridSelectionMode, rhs: DSGridSelectionMode) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.single, .single):
            return true
        case (.multiple(let lhsMax), .multiple(let rhsMax)):
            return lhsMax == rhsMax
        case (.multiple, .multiple) where lhsMax(lhs) == nil && rhsMax(rhs) == nil:
            return true
        default:
            return false
        }
    }

    private static func lhsMax(_ mode: DSGridSelectionMode) -> Int? {
        if case .multiple(let max) = mode { return max }
        return nil
    }

    private static func rhsMax(_ mode: DSGridSelectionMode) -> Int? {
        if case .multiple(let max) = mode { return max }
        return nil
    }
}

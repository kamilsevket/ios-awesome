import SwiftUI

// MARK: - DSDetent

/// Sheet detent options for controlling sheet height
///
/// DSDetent provides predefined and custom height options for bottom sheets:
/// - `.small`: Approximately 25% of screen height
/// - `.medium`: Approximately 50% of screen height
/// - `.large`: Approximately 90% of screen height
/// - `.custom(CGFloat)`: Custom fraction of screen height (0.0 to 1.0)
///
/// Example usage:
/// ```swift
/// .dsSheet(isPresented: $show, detents: [.medium, .large]) {
///     SheetContent()
/// }
/// ```
public enum DSDetent: Hashable, Sendable {
    /// Small detent - approximately 25% of screen height
    case small

    /// Medium detent - approximately 50% of screen height
    case medium

    /// Large detent - approximately 90% of screen height
    case large

    /// Custom detent with specified fraction (0.0 to 1.0)
    case custom(CGFloat)

    // MARK: - Height Calculation

    /// Returns the height fraction for this detent (0.0 to 1.0)
    public var fraction: CGFloat {
        switch self {
        case .small:
            return 0.25
        case .medium:
            return 0.5
        case .large:
            return 0.9
        case .custom(let value):
            return min(max(value, 0.1), 1.0)
        }
    }

    /// Calculates the actual height for a given container height
    /// - Parameter containerHeight: The total available height
    /// - Returns: The calculated height for this detent
    public func height(in containerHeight: CGFloat) -> CGFloat {
        containerHeight * fraction
    }

    // MARK: - Sorting

    /// Returns detents sorted by height (smallest to largest)
    public static func sorted(_ detents: [DSDetent]) -> [DSDetent] {
        detents.sorted { $0.fraction < $1.fraction }
    }

    /// Finds the closest detent to a given fraction
    public static func closest(to fraction: CGFloat, in detents: [DSDetent]) -> DSDetent {
        guard !detents.isEmpty else { return .medium }

        return detents.min { abs($0.fraction - fraction) < abs($1.fraction - fraction) } ?? .medium
    }

    /// Finds the next larger detent from the current one
    public static func nextLarger(from current: DSDetent, in detents: [DSDetent]) -> DSDetent? {
        let sorted = self.sorted(detents)
        guard let currentIndex = sorted.firstIndex(of: current),
              currentIndex < sorted.count - 1 else {
            return nil
        }
        return sorted[currentIndex + 1]
    }

    /// Finds the next smaller detent from the current one
    public static func nextSmaller(from current: DSDetent, in detents: [DSDetent]) -> DSDetent? {
        let sorted = self.sorted(detents)
        guard let currentIndex = sorted.firstIndex(of: current),
              currentIndex > 0 else {
            return nil
        }
        return sorted[currentIndex - 1]
    }
}

// MARK: - Hashable Conformance

extension DSDetent {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .small:
            hasher.combine("small")
        case .medium:
            hasher.combine("medium")
        case .large:
            hasher.combine("large")
        case .custom(let value):
            hasher.combine("custom")
            hasher.combine(value)
        }
    }
}

// MARK: - Default Detent Sets

public extension DSDetent {
    /// Standard detent set for most use cases
    static let standard: [DSDetent] = [.medium, .large]

    /// Full range detent set
    static let fullRange: [DSDetent] = [.small, .medium, .large]

    /// Single medium detent
    static let mediumOnly: [DSDetent] = [.medium]

    /// Single large detent
    static let largeOnly: [DSDetent] = [.large]
}

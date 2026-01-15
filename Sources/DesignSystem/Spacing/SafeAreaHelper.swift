import SwiftUI

// MARK: - Safe Area Insets Key

/// Environment key for accessing safe area insets
private struct SafeAreaInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets = EdgeInsets()
}

extension EnvironmentValues {
    /// The safe area insets of the current view
    public var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

// MARK: - Safe Area Helper

/// Helper for working with safe area insets
public enum SafeAreaHelper {

    /// Standard safe area values for common device types (fallback values)
    public enum DeviceDefaults {

        // MARK: - iPhone

        /// iPhone with notch/Dynamic Island top safe area
        public static let iPhoneNotchTop: CGFloat = 59

        /// iPhone with notch bottom safe area (home indicator)
        public static let iPhoneNotchBottom: CGFloat = 34

        /// iPhone without notch (SE, 8) top safe area
        public static let iPhoneClassicTop: CGFloat = 20

        /// iPhone without notch bottom safe area
        public static let iPhoneClassicBottom: CGFloat = 0

        // MARK: - iPad

        /// iPad top safe area
        public static let iPadTop: CGFloat = 24

        /// iPad bottom safe area
        public static let iPadBottom: CGFloat = 20

        // MARK: - Home Indicator

        /// Height of the home indicator area
        public static let homeIndicatorHeight: CGFloat = 34

        /// Height of the status bar
        public static let statusBarHeight: CGFloat = 20

        /// Height of the status bar on notched devices
        public static let statusBarHeightNotched: CGFloat = 54
    }
}

// MARK: - Safe Area Reader

/// A view that reads and provides safe area insets to its content
public struct SafeAreaReader<Content: View>: View {
    private let content: (EdgeInsets) -> Content

    public init(@ViewBuilder content: @escaping (EdgeInsets) -> Content) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            content(geometry.safeAreaInsets)
        }
    }
}

// MARK: - Safe Area View Modifier

/// View modifier that provides safe area insets to the environment
private struct SafeAreaInsetsModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .environment(\.safeAreaInsets, geometry.safeAreaInsets)
        }
    }
}

extension View {
    /// Provides safe area insets to child views via environment
    public func provideSafeAreaInsets() -> some View {
        modifier(SafeAreaInsetsModifier())
    }
}

// MARK: - Safe Area Padding Extensions

extension View {
    /// Adds padding that respects safe areas plus additional spacing
    /// - Parameters:
    ///   - edges: The edges to apply padding to
    ///   - additionalSpacing: Additional spacing to add beyond safe area
    /// - Returns: View with safe-area-aware padding
    @ViewBuilder
    public func safeAreaPadding(
        _ edges: Edge.Set = .all,
        additional additionalSpacing: CGFloat = 0
    ) -> some View {
        GeometryReader { geometry in
            let insets = calculateInsets(from: geometry.safeAreaInsets, edges: edges, additional: additionalSpacing)
            self.padding(insets)
        }
    }

    /// Adds padding that respects safe areas plus spacing token
    /// - Parameters:
    ///   - edges: The edges to apply padding to
    ///   - token: Spacing token for additional padding
    /// - Returns: View with safe-area-aware padding
    @ViewBuilder
    public func safeAreaPadding(
        _ edges: Edge.Set = .all,
        additional token: SpacingToken
    ) -> some View {
        safeAreaPadding(edges, additional: token.value)
    }

    private func calculateInsets(
        from safeArea: EdgeInsets,
        edges: Edge.Set,
        additional: CGFloat
    ) -> EdgeInsets {
        EdgeInsets(
            top: edges.contains(.top) ? safeArea.top + additional : 0,
            leading: edges.contains(.leading) ? safeArea.leading + additional : 0,
            bottom: edges.contains(.bottom) ? safeArea.bottom + additional : 0,
            trailing: edges.contains(.trailing) ? safeArea.trailing + additional : 0
        )
    }
}

// MARK: - Safe Area Offset Extensions

extension View {
    /// Offsets the view to account for safe areas
    /// - Parameter edges: Which safe area edges to offset for
    /// - Returns: View offset to account for safe areas
    @ViewBuilder
    public func safeAreaOffset(_ edges: Edge.Set = .all) -> some View {
        GeometryReader { geometry in
            let xOffset = calculateHorizontalOffset(from: geometry.safeAreaInsets, edges: edges)
            let yOffset = calculateVerticalOffset(from: geometry.safeAreaInsets, edges: edges)
            self.offset(x: xOffset, y: yOffset)
        }
    }

    private func calculateHorizontalOffset(from safeArea: EdgeInsets, edges: Edge.Set) -> CGFloat {
        var offset: CGFloat = 0
        if edges.contains(.leading) {
            offset += safeArea.leading
        }
        if edges.contains(.trailing) {
            offset -= safeArea.trailing
        }
        return offset / 2
    }

    private func calculateVerticalOffset(from safeArea: EdgeInsets, edges: Edge.Set) -> CGFloat {
        var offset: CGFloat = 0
        if edges.contains(.top) {
            offset += safeArea.top
        }
        if edges.contains(.bottom) {
            offset -= safeArea.bottom
        }
        return offset / 2
    }
}

// MARK: - Safe Area Ignoring with Spacing

extension View {
    /// Ignores safe area but adds custom padding
    /// - Parameters:
    ///   - edges: Edges to ignore safe area on
    ///   - padding: Padding to add after ignoring safe area
    /// - Returns: View with ignored safe area and custom padding
    @ViewBuilder
    public func ignoresSafeAreaWithPadding(
        _ edges: Edge.Set = .all,
        padding: CGFloat
    ) -> some View {
        self.ignoresSafeArea(.all, edges: edges)
            .padding(edges, padding)
    }

    /// Ignores safe area but adds spacing token padding
    /// - Parameters:
    ///   - edges: Edges to ignore safe area on
    ///   - token: Spacing token for padding
    /// - Returns: View with ignored safe area and token-based padding
    @ViewBuilder
    public func ignoresSafeAreaWithPadding(
        _ edges: Edge.Set = .all,
        padding token: SpacingToken
    ) -> some View {
        ignoresSafeAreaWithPadding(edges, padding: token.value)
    }
}

// MARK: - Bottom Safe Area for Buttons

extension View {
    /// Adds bottom padding that ensures content clears the home indicator
    /// with additional spacing
    /// - Parameter additionalPadding: Extra padding beyond safe area
    /// - Returns: View with bottom-safe padding
    @ViewBuilder
    public func bottomSafePadding(_ additionalPadding: CGFloat = Spacing.md) -> some View {
        GeometryReader { geometry in
            self.padding(
                .bottom,
                max(geometry.safeAreaInsets.bottom, Spacing.md) + additionalPadding
            )
        }
    }

    /// Adds bottom padding with a spacing token
    /// - Parameter token: Spacing token for additional padding
    /// - Returns: View with bottom-safe padding
    @ViewBuilder
    public func bottomSafePadding(_ token: SpacingToken) -> some View {
        bottomSafePadding(token.value)
    }
}

// MARK: - Keyboard Avoiding with Safe Area

extension View {
    /// Applies keyboard avoiding behavior that respects safe areas
    @ViewBuilder
    public func keyboardAwareBottomPadding() -> some View {
        GeometryReader { geometry in
            self.padding(.bottom, geometry.safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

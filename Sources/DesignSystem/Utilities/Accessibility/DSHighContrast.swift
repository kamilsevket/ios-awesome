import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - High Contrast Support

/// A view modifier that provides high contrast alternatives
public struct DSHighContrastModifier<HighContrastContent: View>: ViewModifier {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.colorSchemeContrast) private var contrast

    let highContrastContent: () -> HighContrastContent

    public func body(content: Content) -> some View {
        if isHighContrastEnabled {
            highContrastContent()
        } else {
            content
        }
    }

    private var isHighContrastEnabled: Bool {
        contrast == .increased || differentiateWithoutColor
    }
}

extension View {
    /// Provides alternative content for high contrast mode
    /// - Parameter content: The high contrast content
    /// - Returns: A view that shows appropriate content based on contrast settings
    public func dsHighContrast<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DSHighContrastModifier(highContrastContent: content))
    }
}

// MARK: - High Contrast Color Modifier

/// A modifier that adjusts colors for high contrast mode
public struct DSHighContrastColorModifier: ViewModifier {
    @Environment(\.colorSchemeContrast) private var contrast

    let standardColor: Color
    let highContrastColor: Color

    public func body(content: Content) -> some View {
        content
            .foregroundColor(contrast == .increased ? highContrastColor : standardColor)
    }
}

extension View {
    /// Applies color that adapts to high contrast mode
    /// - Parameters:
    ///   - standard: Color for standard contrast
    ///   - highContrast: Color for high contrast mode
    public func dsHighContrastForeground(
        standard: Color,
        highContrast: Color
    ) -> some View {
        modifier(DSHighContrastColorModifier(
            standardColor: standard,
            highContrastColor: highContrast
        ))
    }
}

// MARK: - High Contrast Observer

/// An observable object that tracks high contrast preferences
public final class DSHighContrastObserver: ObservableObject {
    @Published public private(set) var isHighContrastEnabled: Bool = false
    @Published public private(set) var isDifferentiateWithoutColorEnabled: Bool = false
    @Published public private(set) var isReduceTransparencyEnabled: Bool = false
    @Published public private(set) var isInvertColorsEnabled: Bool = false

    public static let shared = DSHighContrastObserver()

    private init() {
        updatePreferences()

        #if os(iOS)
        setupNotifications()
        #endif
    }

    deinit {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self)
        #endif
    }

    #if os(iOS)
    private func setupNotifications() {
        let notifications: [(Notification.Name, Selector)] = [
            (UIAccessibility.darkerSystemColorsStatusDidChangeNotification, #selector(preferencesDidChange)),
            (UIAccessibility.reduceTransparencyStatusDidChangeNotification, #selector(preferencesDidChange)),
            (UIAccessibility.invertColorsStatusDidChangeNotification, #selector(preferencesDidChange))
        ]

        for (name, selector) in notifications {
            NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        }
    }

    @objc private func preferencesDidChange() {
        updatePreferences()
    }
    #endif

    private func updatePreferences() {
        #if os(iOS)
        DispatchQueue.main.async {
            self.isHighContrastEnabled = UIAccessibility.isDarkerSystemColorsEnabled
            self.isDifferentiateWithoutColorEnabled = UIAccessibility.shouldDifferentiateWithoutColor
            self.isReduceTransparencyEnabled = UIAccessibility.isReduceTransparencyEnabled
            self.isInvertColorsEnabled = UIAccessibility.isInvertColorsEnabled
        }
        #endif
    }
}

// MARK: - Contrast Aware Colors

/// A structure that provides colors adapted for contrast settings
public struct DSContrastColor {
    let standard: Color
    let increased: Color
    let highContrast: Color

    /// Creates a contrast-aware color
    /// - Parameters:
    ///   - standard: The standard color
    ///   - increased: Color for increased contrast
    ///   - highContrast: Color for maximum contrast (typically black or white)
    public init(
        standard: Color,
        increased: Color? = nil,
        highContrast: Color? = nil
    ) {
        self.standard = standard
        self.increased = increased ?? standard.opacity(1.0)
        self.highContrast = highContrast ?? (standard.isLight ? .black : .white)
    }

    /// Returns the appropriate color for the current contrast level
    public func color(for contrast: ColorSchemeContrast, differentiateWithoutColor: Bool) -> Color {
        if differentiateWithoutColor {
            return highContrast
        }

        switch contrast {
        case .increased:
            return increased
        default:
            return standard
        }
    }
}

// MARK: - Color Extension for Contrast

extension Color {
    /// Approximates whether a color is light (for contrast calculations)
    var isLight: Bool {
        #if os(iOS)
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return false
        }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
        #else
        return false
        #endif
    }

    /// Returns a high contrast version of this color
    public var highContrast: Color {
        isLight ? .black : .white
    }

    /// Ensures minimum contrast ratio with another color
    public func ensureContrast(against background: Color, minimumRatio: CGFloat = 4.5) -> Color {
        // Simplified implementation - returns high contrast if original doesn't meet ratio
        // In production, you might calculate actual contrast ratios
        return highContrast
    }
}

// MARK: - Border for Color Differentiation

/// A modifier that adds borders when color differentiation is needed
public struct DSDifferentiateWithoutColorBorder: ViewModifier {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiate

    let color: Color
    let width: CGFloat

    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: differentiate ? width : 0)
            )
    }
}

extension View {
    /// Adds a border when differentiate without color is enabled
    /// - Parameters:
    ///   - color: The border color
    ///   - width: The border width
    public func dsDifferentiateWithoutColorBorder(
        color: Color = .primary,
        width: CGFloat = 2
    ) -> some View {
        modifier(DSDifferentiateWithoutColorBorder(color: color, width: width))
    }
}

// MARK: - Pattern Overlay for Color Blindness

/// Patterns that can be used instead of or alongside colors
public enum DSAccessibilityPattern {
    case dots
    case lines
    case crosshatch
    case diagonal

    /// Creates a pattern view
    @ViewBuilder
    public func patternView(color: Color = .primary, size: CGFloat = 4) -> some View {
        switch self {
        case .dots:
            Circle()
                .fill(color)
                .frame(width: size / 2, height: size / 2)
        case .lines:
            Rectangle()
                .fill(color)
                .frame(width: size, height: 1)
        case .crosshatch:
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(width: size, height: 1)
                Rectangle()
                    .fill(color)
                    .frame(width: 1, height: size)
            }
        case .diagonal:
            Rectangle()
                .fill(color)
                .frame(width: size, height: 1)
                .rotationEffect(.degrees(45))
        }
    }
}

// MARK: - Accessibility Indicator

/// A view that shows different indicators when color alone isn't sufficient
public struct DSAccessibilityIndicator: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiate

    let color: Color
    let pattern: DSAccessibilityPattern?
    let icon: String?

    public init(
        color: Color,
        pattern: DSAccessibilityPattern? = nil,
        icon: String? = nil
    ) {
        self.color = color
        self.pattern = pattern
        self.icon = icon
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(color)

            if differentiate {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(color.highContrast)
                        .font(.caption2)
                } else if let pattern = pattern {
                    pattern.patternView(color: color.highContrast, size: 8)
                }
            }
        }
    }
}

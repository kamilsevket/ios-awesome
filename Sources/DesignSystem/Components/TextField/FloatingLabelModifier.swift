import SwiftUI

/// A view modifier that adds a floating label effect to any view.
public struct FloatingLabelModifier: ViewModifier {
    let label: String
    let isFloating: Bool
    let color: Color

    public init(label: String, isFloating: Bool, color: Color = .secondary) {
        self.label = label
        self.isFloating = isFloating
        self.color = color
    }

    public func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(isFloating ? .caption : .body)
                .foregroundColor(color)
                .offset(y: isFloating ? 0 : 20)
                .scaleEffect(isFloating ? 0.85 : 1.0, anchor: .leading)
                .animation(.easeInOut(duration: 0.2), value: isFloating)

            content
        }
    }
}

public extension View {
    /// Adds a floating label to the view.
    /// - Parameters:
    ///   - label: The text to display as the label.
    ///   - isFloating: Whether the label should be in floating (raised) position.
    ///   - color: The color of the label text.
    func floatingLabel(_ label: String, isFloating: Bool, color: Color = .secondary) -> some View {
        modifier(FloatingLabelModifier(label: label, isFloating: isFloating, color: color))
    }
}

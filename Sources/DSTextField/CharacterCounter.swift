import SwiftUI

/// A character counter component that displays current and maximum character counts.
public struct CharacterCounter: View {
    let currentCount: Int
    let maxCount: Int
    let warningThreshold: Double

    /// Creates a character counter.
    /// - Parameters:
    ///   - currentCount: The current number of characters.
    ///   - maxCount: The maximum allowed characters.
    ///   - warningThreshold: The percentage (0-1) at which to show warning color. Default is 0.8 (80%).
    public init(currentCount: Int, maxCount: Int, warningThreshold: Double = 0.8) {
        self.currentCount = currentCount
        self.maxCount = maxCount
        self.warningThreshold = warningThreshold
    }

    public var body: some View {
        Text("\(currentCount)/\(maxCount)")
            .font(.caption)
            .foregroundColor(textColor)
            .monospacedDigit()
            .accessibilityLabel("\(currentCount) of \(maxCount) characters")
    }

    private var textColor: Color {
        if currentCount > maxCount {
            return .red
        } else if Double(currentCount) / Double(maxCount) >= warningThreshold {
            return .orange
        }
        return .secondary
    }
}

/// A view modifier that adds a character counter to the bottom of a view.
public struct CharacterCounterModifier: ViewModifier {
    let text: String
    let maxCharacters: Int
    let warningThreshold: Double

    public init(text: String, maxCharacters: Int, warningThreshold: Double = 0.8) {
        self.text = text
        self.maxCharacters = maxCharacters
        self.warningThreshold = warningThreshold
    }

    public func body(content: Content) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            content

            CharacterCounter(
                currentCount: text.count,
                maxCount: maxCharacters,
                warningThreshold: warningThreshold
            )
        }
    }
}

public extension View {
    /// Adds a character counter below the view.
    /// - Parameters:
    ///   - text: The text to count characters from.
    ///   - maxCharacters: The maximum number of characters allowed.
    ///   - warningThreshold: The percentage (0-1) at which to show warning color.
    func characterCounter(text: String, maxCharacters: Int, warningThreshold: Double = 0.8) -> some View {
        modifier(CharacterCounterModifier(text: text, maxCharacters: maxCharacters, warningThreshold: warningThreshold))
    }
}

// MARK: - Preview

#if DEBUG
struct CharacterCounter_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CharacterCounter(currentCount: 10, maxCount: 100)
            CharacterCounter(currentCount: 85, maxCount: 100)
            CharacterCounter(currentCount: 100, maxCount: 100)
            CharacterCounter(currentCount: 110, maxCount: 100)
        }
        .padding()
    }
}
#endif

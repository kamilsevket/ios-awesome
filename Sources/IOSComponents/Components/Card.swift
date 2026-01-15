import SwiftUI

/// A customizable card component for displaying content
public struct Card<Content: View>: View {
    private let content: Content
    private let style: CardStyle
    private let onTap: (() -> Void)?

    /// Card style variants
    public enum CardStyle {
        case elevated
        case outlined
        case filled

        var backgroundColor: Color {
            switch self {
            case .elevated, .outlined: return Color(.systemBackground)
            case .filled: return Color(.systemGray6)
            }
        }

        var shadowRadius: CGFloat {
            switch self {
            case .elevated: return 4
            case .outlined, .filled: return 0
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .outlined: return 1
            case .elevated, .filled: return 0
            }
        }
    }

    public init(
        style: CardStyle = .elevated,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.onTap = onTap
        self.content = content()
    }

    public var body: some View {
        Group {
            if let onTap = onTap {
                Button(action: onTap) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityAddTraits(.isButton)
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        content
            .padding(16)
            .background(style.backgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: style.shadowRadius, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: style.borderWidth)
            )
    }
}

#if DEBUG
struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Card(style: .elevated) {
                VStack(alignment: .leading) {
                    Text("Elevated Card")
                        .font(.headline)
                    Text("This is a card with elevation shadow")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Card(style: .outlined) {
                VStack(alignment: .leading) {
                    Text("Outlined Card")
                        .font(.headline)
                    Text("This is a card with border")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Card(style: .filled) {
                VStack(alignment: .leading) {
                    Text("Filled Card")
                        .font(.headline)
                    Text("This is a card with background fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}
#endif

import SwiftUI

/// A customizable primary button component
public struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    private let isEnabled: Bool
    private let isLoading: Bool
    private let style: ButtonStyle

    /// Button style variants
    public enum ButtonStyle {
        case filled
        case outlined
        case text

        var backgroundColor: Color {
            switch self {
            case .filled: return .blue
            case .outlined: return .clear
            case .text: return .clear
            }
        }

        var foregroundColor: Color {
            switch self {
            case .filled: return .white
            case .outlined: return .blue
            case .text: return .blue
            }
        }

        var borderColor: Color {
            switch self {
            case .filled: return .clear
            case .outlined: return .blue
            case .text: return .clear
            }
        }
    }

    public init(
        title: String,
        style: ButtonStyle = .filled,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: {
            guard !isLoading && isEnabled else { return }
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style.borderColor, lineWidth: 2)
            )
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityLabel(title)
        .accessibilityHint(isLoading ? "Loading" : "")
        .accessibilityAddTraits(.isButton)
    }
}

#if DEBUG
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            PrimaryButton(title: "Filled Button", style: .filled) {}
            PrimaryButton(title: "Outlined Button", style: .outlined) {}
            PrimaryButton(title: "Text Button", style: .text) {}
            PrimaryButton(title: "Disabled Button", isEnabled: false) {}
            PrimaryButton(title: "Loading Button", isLoading: true) {}
        }
        .padding()
    }
}
#endif

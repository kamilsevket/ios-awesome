import SwiftUI

// MARK: - DSSnackbar

/// A non-blocking feedback component with optional action button
///
/// DSSnackbar provides transient feedback with an optional action button.
/// Useful for operations that can be undone or require user interaction.
///
/// Example usage:
/// ```swift
/// DSSnackbar(
///     message: "Item deleted",
///     actionTitle: "Undo"
/// ) {
///     restoreItem()
/// }
///
/// DSSnackbar(
///     message: "Message sent",
///     type: .success,
///     actionTitle: "View"
/// ) {
///     openMessages()
/// }
/// ```
public struct DSSnackbar: View {

    // MARK: - Properties

    private let message: String
    private let type: DSToastType
    private let icon: String?
    private let actionTitle: String?
    private let action: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let iconSize: CGFloat = 20
        static let maxWidth: CGFloat = 400
        static let actionPadding: CGFloat = 8
    }

    // MARK: - Initialization

    /// Creates a snackbar with a message, optional type, and optional action
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The snackbar type determining style (default: .info)
    ///   - icon: Optional custom icon name (overrides type's default icon)
    ///   - actionTitle: Optional title for the action button
    ///   - action: Optional action to perform when button is tapped
    public init(
        message: String,
        type: DSToastType = .info,
        icon: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.type = type
        self.icon = icon
        self.actionTitle = actionTitle
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            iconView
            messageText
            Spacer(minLength: DSSpacing.sm)
            actionButton
        }
        .padding(.leading, DSSpacing.lg)
        .padding(.trailing, actionTitle != nil ? DSSpacing.sm : DSSpacing.lg)
        .padding(.vertical, DSSpacing.sm)
        .frame(maxWidth: Constants.maxWidth)
        .frame(minHeight: DSSpacing.minTouchTarget)
        .background(backgroundView)
        .shadow(.lg)
        .accessibilityElement(children: .contain)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var iconView: some View {
        let iconName = icon ?? type.iconName
        if let iconName = iconName {
            Image(systemName: iconName)
                .font(.system(size: Constants.iconSize, weight: .semibold))
                .foregroundColor(type.foregroundColor)
                .accessibilityHidden(true)
        }
    }

    private var messageText: some View {
        Text(message)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(type.foregroundColor)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .accessibilityLabel("\(type.accessibilityPrefix): \(message)")
    }

    @ViewBuilder
    private var actionButton: some View {
        if let actionTitle = actionTitle, let action = action {
            Button(action: {
                triggerHapticFeedback()
                action()
            }) {
                Text(actionTitle)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(actionButtonColor)
                    .padding(.horizontal, Constants.actionPadding)
                    .padding(.vertical, DSSpacing.sm)
            }
            .buttonStyle(SnackbarButtonStyle(type: type))
            .accessibilityLabel("\(actionTitle) action")
            .accessibilityHint("Double tap to \(actionTitle.lowercased())")
        }
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(type.backgroundColor)
    }

    // MARK: - Computed Properties

    private var actionButtonColor: Color {
        switch type {
        case .warning:
            return DSColors.primary
        default:
            return type.foregroundColor.opacity(0.9)
        }
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - SnackbarButtonStyle

private struct SnackbarButtonStyle: ButtonStyle {
    let type: DSToastType

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isPressed ? pressedBackgroundColor : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }

    private var pressedBackgroundColor: Color {
        switch type {
        case .warning:
            return Color.black.opacity(0.1)
        default:
            return Color.white.opacity(0.2)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSSnackbar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DSSpacing.lg) {
            DSSnackbar(
                message: "Item deleted",
                actionTitle: "Undo"
            ) {
                print("Undo tapped")
            }

            DSSnackbar(
                message: "Message sent successfully",
                type: .success,
                actionTitle: "View"
            ) {
                print("View tapped")
            }

            DSSnackbar(
                message: "Failed to save changes",
                type: .error,
                actionTitle: "Retry"
            ) {
                print("Retry tapped")
            }

            DSSnackbar(
                message: "Low battery warning",
                type: .warning,
                actionTitle: "Settings"
            ) {
                print("Settings tapped")
            }

            DSSnackbar(
                message: "Simple message without action",
                type: .info
            )
        }
        .padding()
        .previewDisplayName("All Variants")

        VStack(spacing: DSSpacing.lg) {
            DSSnackbar(
                message: "Item deleted",
                actionTitle: "Undo"
            ) {
                print("Undo tapped")
            }

            DSSnackbar(
                message: "Message sent successfully",
                type: .success,
                actionTitle: "View"
            ) {
                print("View tapped")
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif

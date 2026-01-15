import SwiftUI

// MARK: - DSToast

/// A non-blocking feedback toast component for displaying simple messages
///
/// DSToast provides transient feedback messages that automatically dismiss.
/// Supports different types (success, error, warning, info) with appropriate styling.
///
/// Example usage:
/// ```swift
/// DSToast(
///     message: "Saved successfully",
///     type: .success
/// )
///
/// DSToast(
///     message: "Network error",
///     type: .error,
///     icon: "wifi.slash"
/// )
/// ```
public struct DSToast: View {

    // MARK: - Properties

    private let message: String
    private let type: DSToastType
    private let icon: String?

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let iconSize: CGFloat = 20
        static let maxWidth: CGFloat = 400
    }

    // MARK: - Initialization

    /// Creates a toast with a message and type
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The toast type determining style (default: .info)
    ///   - icon: Optional custom icon name (overrides type's default icon)
    public init(
        message: String,
        type: DSToastType = .info,
        icon: String? = nil
    ) {
        self.message = message
        self.type = type
        self.icon = icon
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            iconView
            messageText
            Spacer(minLength: 0)
        }
        .padding(.horizontal, DSSpacing.lg)
        .padding(.vertical, DSSpacing.md)
        .frame(maxWidth: Constants.maxWidth)
        .background(backgroundView)
        .shadow(.lg)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(type.accessibilityPrefix): \(message)")
        .accessibilityAddTraits(.isStaticText)
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
    }

    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(type.backgroundColor)
    }
}

// MARK: - Preview

#if DEBUG
struct DSToast_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DSSpacing.lg) {
            DSToast(message: "Saved successfully", type: .success)
            DSToast(message: "Failed to load data", type: .error)
            DSToast(message: "Check your connection", type: .warning)
            DSToast(message: "New update available", type: .info)
            DSToast(message: "Custom icon toast", type: .info, icon: "star.fill")
        }
        .padding()
        .previewDisplayName("All Types")

        VStack(spacing: DSSpacing.lg) {
            DSToast(message: "Saved successfully", type: .success)
            DSToast(message: "Failed to load data", type: .error)
            DSToast(message: "Check your connection", type: .warning)
            DSToast(message: "New update available", type: .info)
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif

import SwiftUI

// MARK: - DSAlert

/// A customizable alert component for the design system
///
/// DSAlert provides a consistent alert implementation with support for:
/// - Title, message, and optional icon
/// - Primary, secondary, and cancel actions
/// - Destructive action styling (red)
/// - Scale and fade animations
/// - Backdrop dimming with tap to dismiss option
/// - Keyboard dismiss support
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSAlert.show(
///     title: "Delete?",
///     message: "This cannot be undone",
///     primaryAction: .destructive("Delete") { delete() },
///     secondaryAction: .cancel()
/// )
/// ```
public struct DSAlert: View {
    // MARK: - Properties

    private let title: String
    private let message: String?
    private let icon: DSAlertIcon?
    private let primaryAction: DSAlertAction
    private let secondaryAction: DSAlertAction?
    private let dismissOnBackdropTap: Bool

    @Binding private var isPresented: Bool
    @State private var animationScale: CGFloat = 0.8
    @State private var animationOpacity: Double = 0

    // MARK: - Initialization

    /// Creates a new DSAlert
    /// - Parameters:
    ///   - isPresented: Binding to control alert visibility
    ///   - title: The alert title
    ///   - message: Optional message text
    ///   - icon: Optional icon to display
    ///   - primaryAction: The primary action button
    ///   - secondaryAction: Optional secondary action button
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses the alert (default: true)
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: DSAlertIcon? = nil,
        primaryAction: DSAlertAction,
        secondaryAction: DSAlertAction? = nil,
        dismissOnBackdropTap: Bool = true
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.icon = icon
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.dismissOnBackdropTap = dismissOnBackdropTap
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Backdrop
            backdrop

            // Alert content
            alertContent
                .scaleEffect(animationScale)
                .opacity(animationOpacity)
        }
        .ignoresSafeArea()
        .onAppear {
            dismissKeyboard()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                animationScale = 1.0
                animationOpacity = 1.0
            }
        }
    }

    // MARK: - Subviews

    private var backdrop: some View {
        DSColors.backdrop
            .opacity(animationOpacity)
            .onTapGesture {
                if dismissOnBackdropTap {
                    dismiss()
                }
            }
            .accessibilityHidden(true)
    }

    private var alertContent: some View {
        VStack(spacing: 0) {
            // Header with icon and title
            VStack(spacing: 12) {
                if let icon = icon {
                    iconView(icon)
                }

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.label))

                if let message = message {
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)

            Divider()

            // Action buttons
            actionButtons
        }
        .background(DSColors.alertBackground)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .frame(maxWidth: 270)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("\(title) alert")
    }

    private func iconView(_ icon: DSAlertIcon) -> some View {
        icon.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 44, height: 44)
            .foregroundColor(icon.color)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var actionButtons: some View {
        if let secondaryAction = secondaryAction {
            // Two buttons - horizontal layout
            HStack(spacing: 0) {
                actionButton(secondaryAction)

                Divider()
                    .frame(height: 44)

                actionButton(primaryAction)
            }
        } else {
            // Single button
            actionButton(primaryAction)
        }
    }

    private func actionButton(_ action: DSAlertAction) -> some View {
        Button {
            dismiss {
                action.action()
            }
        } label: {
            Text(action.title)
                .font(.body)
                .fontWeight(action.style.fontWeight)
                .foregroundColor(action.style.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(AlertButtonStyle())
        .accessibilityLabel(action.title)
        .accessibilityHint(action.style == .destructive ? "Destructive action" : "")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Actions

    private func dismiss(completion: @escaping () -> Void = {}) {
        withAnimation(.easeOut(duration: 0.2)) {
            animationScale = 0.8
            animationOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
            completion()
        }
    }

    private func dismissKeyboard() {
        #if os(iOS)
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
        #endif
    }
}

// MARK: - Alert Button Style

private struct AlertButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                    ? Color(.systemGray4)
                    : Color.clear
            )
    }
}

// MARK: - View Extension

public extension View {
    /// Presents a design system alert
    /// - Parameters:
    ///   - isPresented: Binding to control alert visibility
    ///   - title: The alert title
    ///   - message: Optional message text
    ///   - icon: Optional icon to display
    ///   - primaryAction: The primary action button
    ///   - secondaryAction: Optional secondary action button
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses the alert
    /// - Returns: Modified view with alert capability
    func dsAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: DSAlertIcon? = nil,
        primaryAction: DSAlertAction,
        secondaryAction: DSAlertAction? = nil,
        dismissOnBackdropTap: Bool = true
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSAlert(
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    icon: icon,
                    primaryAction: primaryAction,
                    secondaryAction: secondaryAction,
                    dismissOnBackdropTap: dismissOnBackdropTap
                )
            }
        }
    }
}

// MARK: - Static Show Method

public extension DSAlert {
    /// Configuration for showing an alert
    struct Configuration {
        public let title: String
        public let message: String?
        public let icon: DSAlertIcon?
        public let primaryAction: DSAlertAction
        public let secondaryAction: DSAlertAction?
        public let dismissOnBackdropTap: Bool

        public init(
            title: String,
            message: String? = nil,
            icon: DSAlertIcon? = nil,
            primaryAction: DSAlertAction,
            secondaryAction: DSAlertAction? = nil,
            dismissOnBackdropTap: Bool = true
        ) {
            self.title = title
            self.message = message
            self.icon = icon
            self.primaryAction = primaryAction
            self.secondaryAction = secondaryAction
            self.dismissOnBackdropTap = dismissOnBackdropTap
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSAlert_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Simple alert
            AlertPreviewWrapper(
                title: "Alert Title",
                message: "This is a simple alert message.",
                primaryAction: .default("OK") { }
            )
            .previewDisplayName("Simple Alert")

            // Alert with two actions
            AlertPreviewWrapper(
                title: "Delete Item?",
                message: "This action cannot be undone.",
                primaryAction: .destructive("Delete") { },
                secondaryAction: .cancel()
            )
            .previewDisplayName("Destructive Alert")

            // Alert with icon
            AlertPreviewWrapper(
                title: "Success!",
                message: "Your changes have been saved.",
                icon: .success,
                primaryAction: .default("Done") { }
            )
            .previewDisplayName("Success Alert")

            // Alert with warning icon
            AlertPreviewWrapper(
                title: "Warning",
                message: "You have unsaved changes. Do you want to continue?",
                icon: .warning,
                primaryAction: .default("Continue") { },
                secondaryAction: .cancel()
            )
            .previewDisplayName("Warning Alert")

            // Dark mode
            AlertPreviewWrapper(
                title: "Delete Item?",
                message: "This action cannot be undone.",
                icon: .error,
                primaryAction: .destructive("Delete") { },
                secondaryAction: .cancel()
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}

private struct AlertPreviewWrapper: View {
    let title: String
    let message: String?
    let icon: DSAlertIcon?
    let primaryAction: DSAlertAction
    let secondaryAction: DSAlertAction?

    @State private var isPresented = true

    init(
        title: String,
        message: String? = nil,
        icon: DSAlertIcon? = nil,
        primaryAction: DSAlertAction,
        secondaryAction: DSAlertAction? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("Background Content")
                    .foregroundColor(.secondary)

                Button("Show Alert") {
                    isPresented = true
                }
            }

            if isPresented {
                DSAlert(
                    isPresented: $isPresented,
                    title: title,
                    message: message,
                    icon: icon,
                    primaryAction: primaryAction,
                    secondaryAction: secondaryAction
                )
            }
        }
    }
}
#endif

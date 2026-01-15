import SwiftUI

// MARK: - DSConfirmationDialog

/// A confirmation dialog component with multiple action options
///
/// DSConfirmationDialog provides a bottom sheet style confirmation dialog with support for:
/// - Title and optional message
/// - Multiple action buttons with different styles
/// - Destructive action styling (red)
/// - Cancel button (always at bottom)
/// - Scale and slide animations
/// - Backdrop dimming with tap to dismiss
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// .dsConfirmationDialog(
///     isPresented: $showDialog,
///     title: "Share Photo",
///     actions: [
///         .default("Save to Photos") { savePhoto() },
///         .default("Copy Link") { copyLink() },
///         .destructive("Delete") { delete() }
///     ]
/// )
/// ```
public struct DSConfirmationDialog: View {
    // MARK: - Properties

    private let title: String?
    private let message: String?
    private let actions: [DSAlertAction]
    private let cancelAction: DSAlertAction
    private let dismissOnBackdropTap: Bool

    @Binding private var isPresented: Bool
    @State private var animationOffset: CGFloat = 300
    @State private var animationOpacity: Double = 0

    // MARK: - Initialization

    /// Creates a new DSConfirmationDialog
    /// - Parameters:
    ///   - isPresented: Binding to control dialog visibility
    ///   - title: Optional title text
    ///   - message: Optional message text
    ///   - actions: Array of action buttons to display
    ///   - cancelAction: The cancel action (default: standard cancel)
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses the dialog (default: true)
    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [DSAlertAction],
        cancelAction: DSAlertAction = .cancel(),
        dismissOnBackdropTap: Bool = true
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelAction = cancelAction
        self.dismissOnBackdropTap = dismissOnBackdropTap
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop
            backdrop

            // Dialog content
            dialogContent
                .offset(y: animationOffset)
        }
        .ignoresSafeArea()
        .onAppear {
            dismissKeyboard()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                animationOffset = 0
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

    private var dialogContent: some View {
        VStack(spacing: 8) {
            // Actions group
            VStack(spacing: 0) {
                // Header
                if title != nil || message != nil {
                    headerView
                    Divider()
                }

                // Action buttons
                ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                    actionButton(action)

                    if index < actions.count - 1 {
                        Divider()
                    }
                }
            }
            .background(DSColors.alertBackground)
            .cornerRadius(14)

            // Cancel button (separate)
            cancelButton
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }

    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.secondaryLabel))
            }

            if let message = message {
                Text(message)
                    .font(.caption)
                    .foregroundColor(Color(.tertiaryLabel))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }

    private func actionButton(_ action: DSAlertAction) -> some View {
        Button {
            dismiss {
                action.action()
            }
        } label: {
            Text(action.title)
                .font(.title3)
                .foregroundColor(action.style.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .contentShape(Rectangle())
        }
        .buttonStyle(DialogButtonStyle())
        .accessibilityLabel(action.title)
        .accessibilityHint(action.style == .destructive ? "Destructive action" : "")
        .accessibilityAddTraits(.isButton)
    }

    private var cancelButton: some View {
        Button {
            dismiss {
                cancelAction.action()
            }
        } label: {
            Text(cancelAction.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(DSColors.alertBackground)
                .cornerRadius(14)
        }
        .buttonStyle(DialogButtonStyle())
        .accessibilityLabel(cancelAction.title)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Actions

    private func dismiss(completion: @escaping () -> Void = {}) {
        withAnimation(.easeOut(duration: 0.2)) {
            animationOffset = 300
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

// MARK: - Dialog Button Style

private struct DialogButtonStyle: ButtonStyle {
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
    /// Presents a design system confirmation dialog
    /// - Parameters:
    ///   - isPresented: Binding to control dialog visibility
    ///   - title: Optional title text
    ///   - message: Optional message text
    ///   - actions: Array of action buttons to display
    ///   - cancelAction: The cancel action
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses the dialog
    /// - Returns: Modified view with dialog capability
    func dsConfirmationDialog(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [DSAlertAction],
        cancelAction: DSAlertAction = .cancel(),
        dismissOnBackdropTap: Bool = true
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSConfirmationDialog(
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    actions: actions,
                    cancelAction: cancelAction,
                    dismissOnBackdropTap: dismissOnBackdropTap
                )
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Simple dialog
            ConfirmationDialogPreviewWrapper(
                title: "Share Photo",
                actions: [
                    .default("Save to Photos") { },
                    .default("Copy Link") { },
                    .default("Share via Messages") { }
                ]
            )
            .previewDisplayName("Simple Dialog")

            // With destructive action
            ConfirmationDialogPreviewWrapper(
                title: "Photo Options",
                message: "Choose an action for this photo",
                actions: [
                    .default("Edit") { },
                    .default("Duplicate") { },
                    .destructive("Delete Photo") { }
                ]
            )
            .previewDisplayName("With Destructive")

            // Dark mode
            ConfirmationDialogPreviewWrapper(
                title: "Actions",
                actions: [
                    .default("Option 1") { },
                    .default("Option 2") { },
                    .destructive("Delete") { }
                ]
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}

private struct ConfirmationDialogPreviewWrapper: View {
    let title: String?
    let message: String?
    let actions: [DSAlertAction]

    @State private var isPresented = true

    init(
        title: String? = nil,
        message: String? = nil,
        actions: [DSAlertAction]
    ) {
        self.title = title
        self.message = message
        self.actions = actions
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("Background Content")
                    .foregroundColor(.secondary)

                Button("Show Dialog") {
                    isPresented = true
                }
            }

            if isPresented {
                DSConfirmationDialog(
                    isPresented: $isPresented,
                    title: title,
                    message: message,
                    actions: actions
                )
            }
        }
    }
}
#endif

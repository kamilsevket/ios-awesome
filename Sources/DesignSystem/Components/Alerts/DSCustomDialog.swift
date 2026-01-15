import SwiftUI

// MARK: - DSCustomDialog

/// A customizable dialog container for displaying custom content
///
/// DSCustomDialog provides a modal dialog with support for:
/// - Custom content via ViewBuilder
/// - Optional title
/// - Optional action buttons
/// - Scale and fade animations
/// - Backdrop dimming with tap to dismiss option
/// - Keyboard dismiss support
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// .dsCustomDialog(isPresented: $showDialog, title: "Settings") {
///     VStack {
///         Toggle("Notifications", isOn: $notifications)
///         Toggle("Dark Mode", isOn: $darkMode)
///     }
/// } actions: {
///     DSAlertAction("Save") { save() }
/// }
/// ```
public struct DSCustomDialog<Content: View>: View {
    // MARK: - Properties

    private let title: String?
    private let content: Content
    private let actions: [DSAlertAction]
    private let dismissOnBackdropTap: Bool
    private let maxWidth: CGFloat

    @Binding private var isPresented: Bool
    @State private var animationScale: CGFloat = 0.8
    @State private var animationOpacity: Double = 0

    // MARK: - Initialization

    /// Creates a new DSCustomDialog
    /// - Parameters:
    ///   - isPresented: Binding to control dialog visibility
    ///   - title: Optional title text
    ///   - maxWidth: Maximum width of the dialog (default: 300)
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses the dialog (default: true)
    ///   - content: The custom content to display
    ///   - actions: Array of action buttons to display
    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        maxWidth: CGFloat = 300,
        dismissOnBackdropTap: Bool = true,
        @ViewBuilder content: () -> Content,
        actions: [DSAlertAction] = []
    ) {
        self._isPresented = isPresented
        self.title = title
        self.maxWidth = maxWidth
        self.dismissOnBackdropTap = dismissOnBackdropTap
        self.content = content()
        self.actions = actions
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Backdrop
            backdrop

            // Dialog content
            dialogContent
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

    private var dialogContent: some View {
        VStack(spacing: 0) {
            // Title
            if let title = title {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.label))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 12)
            }

            // Custom content
            content
                .padding(.horizontal, 20)
                .padding(.vertical, title == nil ? 20 : 8)

            // Actions
            if !actions.isEmpty {
                Divider()
                    .padding(.top, 12)
                actionButtons
            }
        }
        .background(DSColors.alertBackground)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .frame(maxWidth: maxWidth)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel(title ?? "Dialog")
    }

    @ViewBuilder
    private var actionButtons: some View {
        if actions.count == 2 {
            // Two buttons - horizontal layout
            HStack(spacing: 0) {
                actionButton(actions[0])

                Divider()
                    .frame(height: 44)

                actionButton(actions[1])
            }
        } else {
            // Multiple buttons - vertical layout
            VStack(spacing: 0) {
                ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                    actionButton(action)

                    if index < actions.count - 1 {
                        Divider()
                    }
                }
            }
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
        .buttonStyle(CustomDialogButtonStyle())
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

// MARK: - Custom Dialog Button Style

private struct CustomDialogButtonStyle: ButtonStyle {
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
    /// Presents a design system custom dialog
    /// - Parameters:
    ///   - isPresented: Binding to control dialog visibility
    ///   - title: Optional title text
    ///   - maxWidth: Maximum width of the dialog
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses the dialog
    ///   - content: The custom content to display
    ///   - actions: Array of action buttons
    /// - Returns: Modified view with dialog capability
    func dsCustomDialog<Content: View>(
        isPresented: Binding<Bool>,
        title: String? = nil,
        maxWidth: CGFloat = 300,
        dismissOnBackdropTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        actions: [DSAlertAction] = []
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSCustomDialog(
                    isPresented: isPresented,
                    title: title,
                    maxWidth: maxWidth,
                    dismissOnBackdropTap: dismissOnBackdropTap,
                    content: content,
                    actions: actions
                )
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSCustomDialog_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Simple custom content
            CustomDialogPreviewWrapper(
                title: "Profile Settings"
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentColor)

                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("john@example.com")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Divider()

                    Text("Member since January 2024")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .previewDisplayName("Profile Dialog")

            // Form dialog
            FormDialogPreviewWrapper()
                .previewDisplayName("Form Dialog")

            // Dark mode
            CustomDialogPreviewWrapper(
                title: "Settings"
            ) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Notifications")
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }

                    Divider()

                    HStack {
                        Text("Dark Mode")
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}

private struct CustomDialogPreviewWrapper<Content: View>: View {
    let title: String?
    let content: Content

    @State private var isPresented = true

    init(
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
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
                DSCustomDialog(
                    isPresented: $isPresented,
                    title: title,
                    content: { content },
                    actions: [
                        .cancel(),
                        .default("Done") { }
                    ]
                )
            }
        }
    }
}

private struct FormDialogPreviewWrapper: View {
    @State private var isPresented = true
    @State private var name = ""
    @State private var email = ""

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
                DSCustomDialog(
                    isPresented: $isPresented,
                    title: "Edit Profile",
                    content: {
                        VStack(spacing: 16) {
                            TextField("Name", text: $name)
                                .textFieldStyle(.roundedBorder)

                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                        }
                    },
                    actions: [
                        .cancel(),
                        .default("Save") { }
                    ]
                )
            }
        }
    }
}
#endif

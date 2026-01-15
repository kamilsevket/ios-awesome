import SwiftUI

// MARK: - Action Sheet Action

/// An action for use in DSActionSheet
public struct DSActionSheetAction: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let systemImage: String?
    public let role: DSMenuItemRole
    public let action: @Sendable () -> Void

    /// Creates a default action
    /// - Parameters:
    ///   - title: The action title
    ///   - systemImage: Optional SF Symbol name
    ///   - action: The action to perform
    /// - Returns: A configured action
    public static func `default`(
        _ title: String,
        systemImage: String? = nil,
        action: @escaping @Sendable () -> Void
    ) -> DSActionSheetAction {
        DSActionSheetAction(
            title: title,
            systemImage: systemImage,
            role: .default,
            action: action
        )
    }

    /// Creates a destructive action
    /// - Parameters:
    ///   - title: The action title
    ///   - systemImage: Optional SF Symbol name
    ///   - action: The action to perform
    /// - Returns: A configured destructive action
    public static func destructive(
        _ title: String,
        systemImage: String? = nil,
        action: @escaping @Sendable () -> Void
    ) -> DSActionSheetAction {
        DSActionSheetAction(
            title: title,
            systemImage: systemImage,
            role: .destructive,
            action: action
        )
    }

    /// Creates a cancel action
    /// - Parameters:
    ///   - title: The cancel button title (default: "Cancel")
    ///   - action: Optional action to perform on cancel
    /// - Returns: A configured cancel action
    public static func cancel(
        _ title: String = "Cancel",
        action: @escaping @Sendable () -> Void = {}
    ) -> DSActionSheetAction {
        DSActionSheetAction(
            title: title,
            systemImage: nil,
            role: .default,
            action: action
        )
    }

    private init(
        title: String,
        systemImage: String?,
        role: DSMenuItemRole,
        action: @escaping @Sendable () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
}

// MARK: - Action Sheet Style

/// Style configuration for DSActionSheet
public struct DSActionSheetStyle: Sendable {
    public let showsDragIndicator: Bool
    public let cornerRadius: CGFloat
    public let buttonHeight: CGFloat
    public let separatorInset: CGFloat

    public static let `default` = DSActionSheetStyle(
        showsDragIndicator: true,
        cornerRadius: 14,
        buttonHeight: 56,
        separatorInset: 0
    )

    public static let compact = DSActionSheetStyle(
        showsDragIndicator: false,
        cornerRadius: 14,
        buttonHeight: 48,
        separatorInset: 16
    )

    public init(
        showsDragIndicator: Bool = true,
        cornerRadius: CGFloat = 14,
        buttonHeight: CGFloat = 56,
        separatorInset: CGFloat = 0
    ) {
        self.showsDragIndicator = showsDragIndicator
        self.cornerRadius = cornerRadius
        self.buttonHeight = buttonHeight
        self.separatorInset = separatorInset
    }
}

// MARK: - DSActionSheet

/// A custom action sheet component with rich styling options
///
/// DSActionSheet provides a bottom sheet style action sheet with:
/// - Title and optional message
/// - Multiple action buttons with icons
/// - Destructive action styling
/// - Drag indicator
/// - Smooth animations
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// .dsActionSheet(
///     isPresented: $showSheet,
///     title: "Photo Options",
///     message: "Choose what to do with this photo",
///     actions: [
///         .default("Save to Photos", systemImage: "square.and.arrow.down") { },
///         .default("Share", systemImage: "square.and.arrow.up") { },
///         .destructive("Delete", systemImage: "trash") { }
///     ]
/// )
/// ```
public struct DSActionSheet: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    private let title: String?
    private let message: String?
    private let actions: [DSActionSheetAction]
    private let cancelAction: DSActionSheetAction
    private let style: DSActionSheetStyle
    private let dismissOnBackdropTap: Bool

    @State private var animationOffset: CGFloat = 400
    @State private var animationOpacity: Double = 0
    @State private var dragOffset: CGFloat = 0

    // MARK: - Initialization

    /// Creates a DSActionSheet
    /// - Parameters:
    ///   - isPresented: Binding to control sheet visibility
    ///   - title: Optional title text
    ///   - message: Optional message text
    ///   - actions: Array of actions to display
    ///   - cancelAction: The cancel action (default: standard cancel)
    ///   - style: Visual style configuration
    ///   - dismissOnBackdropTap: Whether tapping backdrop dismisses the sheet
    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [DSActionSheetAction],
        cancelAction: DSActionSheetAction = .cancel(),
        style: DSActionSheetStyle = .default,
        dismissOnBackdropTap: Bool = true
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelAction = cancelAction
        self.style = style
        self.dismissOnBackdropTap = dismissOnBackdropTap
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop
            DSColors.backdrop
                .opacity(animationOpacity)
                .onTapGesture {
                    if dismissOnBackdropTap {
                        dismiss()
                    }
                }
                .accessibilityHidden(true)

            // Sheet content
            sheetContent
                .offset(y: animationOffset + dragOffset)
                .gesture(dragGesture)
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

    private var sheetContent: some View {
        VStack(spacing: 8) {
            // Main actions group
            VStack(spacing: 0) {
                // Drag indicator
                if style.showsDragIndicator {
                    dragIndicator
                }

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
                            .padding(.leading, style.separatorInset)
                    }
                }
            }
            .background(DSColors.alertBackground)
            .cornerRadius(style.cornerRadius)

            // Cancel button
            cancelButton
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Action sheet")
    }

    private var dragIndicator: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color(.systemGray3))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 4)
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

    private func actionButton(_ action: DSActionSheetAction) -> some View {
        Button {
            dismiss {
                action.action()
            }
        } label: {
            HStack(spacing: 12) {
                if let systemImage = action.systemImage {
                    Image(systemName: systemImage)
                        .font(.body)
                        .frame(width: 24)
                }

                Text(action.title)
                    .font(.title3)

                Spacer()
            }
            .foregroundColor(action.role.foregroundColor)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: style.buttonHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(ActionSheetButtonStyle())
        .accessibilityLabel(action.title)
        .accessibilityHint(action.role == .destructive ? "Destructive action" : "")
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
                .frame(height: style.buttonHeight)
                .background(DSColors.alertBackground)
                .cornerRadius(style.cornerRadius)
        }
        .buttonStyle(ActionSheetButtonStyle())
        .accessibilityLabel(cancelAction.title)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Gestures

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 0 {
                    dragOffset = value.translation.height
                }
            }
            .onEnded { value in
                if value.translation.height > 100 || value.predictedEndTranslation.height > 200 {
                    dismiss()
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = 0
                    }
                }
            }
    }

    // MARK: - Actions

    private func dismiss(completion: @escaping () -> Void = {}) {
        withAnimation(.easeOut(duration: 0.2)) {
            animationOffset = 400
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

// MARK: - Button Style

private struct ActionSheetButtonStyle: ButtonStyle {
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
    /// Presents a design system action sheet
    /// - Parameters:
    ///   - isPresented: Binding to control sheet visibility
    ///   - title: Optional title text
    ///   - message: Optional message text
    ///   - actions: Array of actions to display
    ///   - cancelAction: The cancel action
    ///   - style: Visual style configuration
    ///   - dismissOnBackdropTap: Whether tapping backdrop dismisses
    /// - Returns: Modified view with action sheet capability
    func dsActionSheet(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [DSActionSheetAction],
        cancelAction: DSActionSheetAction = .cancel(),
        style: DSActionSheetStyle = .default,
        dismissOnBackdropTap: Bool = true
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSActionSheet(
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    actions: actions,
                    cancelAction: cancelAction,
                    style: style,
                    dismissOnBackdropTap: dismissOnBackdropTap
                )
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActionSheetPreviewWrapper(
                title: "Photo Options",
                message: "Choose what to do with this photo",
                actions: [
                    .default("Save to Photos", systemImage: "square.and.arrow.down") { },
                    .default("Copy", systemImage: "doc.on.doc") { },
                    .default("Share", systemImage: "square.and.arrow.up") { },
                    .destructive("Delete Photo", systemImage: "trash") { }
                ]
            )
            .previewDisplayName("With Icons")

            ActionSheetPreviewWrapper(
                title: "Share",
                actions: [
                    .default("Messages") { },
                    .default("Mail") { },
                    .default("AirDrop") { },
                    .default("Copy Link") { }
                ]
            )
            .previewDisplayName("Without Icons")

            ActionSheetPreviewWrapper(
                title: nil,
                message: nil,
                actions: [
                    .default("Edit", systemImage: "pencil") { },
                    .default("Duplicate", systemImage: "plus.square.on.square") { },
                    .destructive("Delete", systemImage: "trash") { }
                ]
            )
            .previewDisplayName("No Header")

            ActionSheetPreviewWrapper(
                title: "Delete Item?",
                message: "This action cannot be undone.",
                actions: [
                    .destructive("Delete", systemImage: "trash") { }
                ]
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}

private struct ActionSheetPreviewWrapper: View {
    let title: String?
    let message: String?
    let actions: [DSActionSheetAction]

    @State private var isPresented = true

    init(
        title: String? = nil,
        message: String? = nil,
        actions: [DSActionSheetAction]
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

                Button("Show Action Sheet") {
                    isPresented = true
                }
            }

            if isPresented {
                DSActionSheet(
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

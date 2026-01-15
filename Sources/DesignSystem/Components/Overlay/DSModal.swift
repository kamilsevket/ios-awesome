import SwiftUI

// MARK: - DSModal

/// A centered modal dialog with customizable appearance
///
/// DSModal provides a modal view that appears in the center of the screen with:
/// - Scale and fade animations
/// - Backdrop dimming with tap to dismiss option
/// - Keyboard dismiss support
/// - Custom sizing
/// - Safe area handling
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// .dsModal(isPresented: $showModal) {
///     ModalContent()
/// }
/// ```
public struct DSModal<Content: View>: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    private let dismissOnBackdropTap: Bool
    private let maxWidth: CGFloat
    private let maxHeight: CGFloat?
    private let cornerRadius: CGFloat
    private let showCloseButton: Bool
    private let content: Content

    @State private var animationScale: CGFloat = 0.8
    @State private var animationOpacity: Double = 0

    // MARK: - Initialization

    /// Creates a new DSModal
    /// - Parameters:
    ///   - isPresented: Binding to control modal visibility
    ///   - dismissOnBackdropTap: Whether tapping the backdrop dismisses (default: true)
    ///   - maxWidth: Maximum width of the modal (default: 340)
    ///   - maxHeight: Maximum height of the modal (default: nil - auto)
    ///   - cornerRadius: Corner radius of the modal (default: 16)
    ///   - showCloseButton: Whether to show a close button (default: false)
    ///   - content: The modal content
    public init(
        isPresented: Binding<Bool>,
        dismissOnBackdropTap: Bool = true,
        maxWidth: CGFloat = 340,
        maxHeight: CGFloat? = nil,
        cornerRadius: CGFloat = 16,
        showCloseButton: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.dismissOnBackdropTap = dismissOnBackdropTap
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.cornerRadius = cornerRadius
        self.showCloseButton = showCloseButton
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Backdrop
            backdrop

            // Modal content
            modalContent
                .scaleEffect(animationScale)
                .opacity(animationOpacity)
        }
        .ignoresSafeArea()
        .onAppear {
            dismissKeyboard()
            presentModal()
        }
    }

    // MARK: - Subviews

    private var backdrop: some View {
        DSColors.backdrop
            .opacity(animationOpacity)
            .onTapGesture {
                if dismissOnBackdropTap {
                    dismissModal()
                }
            }
            .accessibilityHidden(true)
    }

    private var modalContent: some View {
        ZStack(alignment: .topTrailing) {
            // Content
            content
                .frame(maxWidth: maxWidth)
                .frame(maxHeight: maxHeight)
                .background(DSColors.backgroundPrimary)
                .cornerRadius(cornerRadius)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)

            // Close button
            if showCloseButton {
                closeButton
            }
        }
        .padding(.horizontal, DSSpacing.lg)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Modal dialog")
    }

    private var closeButton: some View {
        Button {
            dismissModal()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(UIColor.systemGray3))
        }
        .padding(DSSpacing.sm)
        .accessibilityLabel("Close")
        .accessibilityHint("Double tap to close this modal")
    }

    // MARK: - Actions

    private func presentModal() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            animationScale = 1.0
            animationOpacity = 1.0
        }
    }

    private func dismissModal() {
        withAnimation(.easeOut(duration: 0.2)) {
            animationScale = 0.8
            animationOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
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

// MARK: - View Extension

public extension View {
    /// Presents a design system modal
    /// - Parameters:
    ///   - isPresented: Binding to control modal visibility
    ///   - dismissOnBackdropTap: Whether tapping backdrop dismisses
    ///   - maxWidth: Maximum width of the modal
    ///   - maxHeight: Maximum height of the modal
    ///   - cornerRadius: Corner radius of the modal
    ///   - showCloseButton: Whether to show a close button
    ///   - content: The modal content
    /// - Returns: Modified view with modal capability
    func dsModal<Content: View>(
        isPresented: Binding<Bool>,
        dismissOnBackdropTap: Bool = true,
        maxWidth: CGFloat = 340,
        maxHeight: CGFloat? = nil,
        cornerRadius: CGFloat = 16,
        showCloseButton: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSModal(
                    isPresented: isPresented,
                    dismissOnBackdropTap: dismissOnBackdropTap,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    cornerRadius: cornerRadius,
                    showCloseButton: showCloseButton,
                    content: content
                )
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSModal_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Basic modal
            ModalPreviewWrapper(showCloseButton: false) {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)

                    Text("Success!")
                        .font(.headline)

                    Text("Your action was completed successfully.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Continue") { }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                }
                .padding(24)
            }
            .previewDisplayName("Success Modal")

            // Modal with close button
            ModalPreviewWrapper(showCloseButton: true) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Settings")
                        .font(.headline)

                    Toggle("Notifications", isOn: .constant(true))
                    Toggle("Dark Mode", isOn: .constant(false))
                    Toggle("Sounds", isOn: .constant(true))
                }
                .padding(20)
            }
            .previewDisplayName("Settings Modal")

            // Dark mode
            ModalPreviewWrapper(showCloseButton: false) {
                VStack(spacing: 16) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.yellow)

                    Text("Dark Mode")
                        .font(.headline)

                    Text("Dark mode is enabled for better night viewing.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}

private struct ModalPreviewWrapper<Content: View>: View {
    let showCloseButton: Bool
    let content: Content
    @State private var isPresented = true

    init(showCloseButton: Bool, @ViewBuilder content: () -> Content) {
        self.showCloseButton = showCloseButton
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("Background Content")
                    .foregroundColor(.secondary)

                Button("Show Modal") {
                    isPresented = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .dsModal(
            isPresented: $isPresented,
            showCloseButton: showCloseButton
        ) {
            content
        }
    }
}
#endif

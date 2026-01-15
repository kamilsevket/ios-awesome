import SwiftUI

// MARK: - DSToastContainerView

/// Container view for displaying toasts with swipe-to-dismiss functionality
///
/// This view should be used to wrap your main content and will display
/// toasts from DSToastManager at the configured position.
///
/// Example usage:
/// ```swift
/// DSToastContainerView {
///     ContentView()
/// }
///
/// // Or using the view modifier
/// ContentView()
///     .toastContainer()
/// ```
public struct DSToastContainerView<Content: View>: View {

    // MARK: - Properties

    private let content: Content
    @StateObject private var toastManager = DSToastManager.shared

    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false

    // MARK: - Constants

    private enum Constants {
        static let dismissThreshold: CGFloat = 50
        static let horizontalPadding: CGFloat = 16
        static let safeAreaPadding: CGFloat = 8
        static let maxDragOpacity: CGFloat = 1.0
        static let minDragOpacity: CGFloat = 0.3
    }

    // MARK: - Initialization

    /// Creates a toast container with content
    /// - Parameter content: The main content to display
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            content

            if let toast = toastManager.currentToast {
                toastOverlay(for: toast)
            }
        }
    }

    // MARK: - Toast Overlay

    @ViewBuilder
    private func toastOverlay(for toast: DSToastItem) -> some View {
        GeometryReader { geometry in
            VStack {
                if toastManager.position == .bottom {
                    Spacer()
                }

                toastView(for: toast)
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(
                        toastManager.position == .top ? .top : .bottom,
                        Constants.safeAreaPadding + safeAreaInset(for: geometry)
                    )
                    .offset(y: calculateOffset())
                    .opacity(calculateOpacity())
                    .gesture(swipeToDismissGesture)
                    .transition(toastTransition)

                if toastManager.position == .top {
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func toastView(for toast: DSToastItem) -> some View {
        Group {
            if toast.actionTitle != nil {
                DSSnackbar(
                    message: toast.message,
                    type: toast.type,
                    icon: toast.icon,
                    actionTitle: toast.actionTitle,
                    action: {
                        toast.action?()
                        toastManager.dismiss()
                    }
                )
            } else {
                DSToast(
                    message: toast.message,
                    type: toast.type,
                    icon: toast.icon
                )
            }
        }
        .accessibilityAddTraits(.updatesFrequently)
        .accessibilityHint("Swipe to dismiss")
        .onAppear {
            announceToastForVoiceOver(toast)
        }
    }

    // MARK: - Accessibility

    private func announceToastForVoiceOver(_ toast: DSToastItem) {
        #if os(iOS)
        let announcement = "\(toast.type.accessibilityPrefix): \(toast.message)"
        UIAccessibility.post(notification: .announcement, argument: announcement)
        #endif
    }

    // MARK: - Swipe Gesture

    private var swipeToDismissGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                let translation = toastManager.position == .top
                    ? min(0, value.translation.height)
                    : max(0, value.translation.height)
                dragOffset = translation
            }
            .onEnded { value in
                isDragging = false
                let velocity = abs(value.predictedEndTranslation.height)
                let shouldDismiss = abs(dragOffset) > Constants.dismissThreshold || velocity > 200

                if shouldDismiss {
                    withAnimation(.easeOut(duration: 0.2)) {
                        dragOffset = toastManager.position == .top ? -200 : 200
                    }
                    toastManager.dismiss()
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dragOffset = 0
                    }
                }
            }
    }

    // MARK: - Helper Methods

    private func calculateOffset() -> CGFloat {
        dragOffset
    }

    private func calculateOpacity() -> Double {
        let progress = abs(dragOffset) / 100
        return max(Constants.minDragOpacity, Constants.maxDragOpacity - progress * 0.5)
    }

    private func safeAreaInset(for geometry: GeometryProxy) -> CGFloat {
        toastManager.position == .top
            ? geometry.safeAreaInsets.top
            : geometry.safeAreaInsets.bottom
    }

    private var toastTransition: AnyTransition {
        let edge: Edge = toastManager.position == .top ? .top : .bottom
        return .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: edge).combined(with: .opacity)
        )
    }
}

// MARK: - View Modifier

/// View modifier for adding toast container functionality
public struct ToastContainerModifier: ViewModifier {
    public func body(content: Content) -> some View {
        DSToastContainerView {
            content
        }
    }
}

public extension View {
    /// Adds toast container functionality to the view
    /// Toasts will be displayed from DSToastManager
    /// - Returns: A view wrapped in a toast container
    func toastContainer() -> some View {
        modifier(ToastContainerModifier())
    }
}

// MARK: - Preview

#if DEBUG
struct DSToastContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
            .previewDisplayName("Toast Container")
    }
}

private struct PreviewContainer: View {
    var body: some View {
        DSToastContainerView {
            VStack(spacing: 20) {
                Text("Toast Demo")
                    .font(.title)

                Button("Show Success Toast") {
                    DSToastManager.success("Saved successfully")
                }

                Button("Show Error Toast") {
                    DSToastManager.error("Failed to save")
                }

                Button("Show Warning Toast") {
                    DSToastManager.warning("Low storage space")
                }

                Button("Show Info Toast") {
                    DSToastManager.info("New update available")
                }

                Button("Show Snackbar with Action") {
                    DSToastManager.shared.showSnackbar(
                        "Item deleted",
                        actionTitle: "Undo"
                    ) {
                        print("Undo tapped")
                    }
                }

                Button("Show Multiple Toasts") {
                    DSToastManager.success("First toast")
                    DSToastManager.info("Second toast")
                    DSToastManager.warning("Third toast")
                }
            }
            .padding()
        }
    }
}
#endif

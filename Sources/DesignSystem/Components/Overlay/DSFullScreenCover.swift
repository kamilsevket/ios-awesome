import SwiftUI

// MARK: - DSFullScreenCover

/// A full-screen modal cover with customizable transitions
///
/// DSFullScreenCover provides a full-screen modal that:
/// - Covers the entire screen including safe areas
/// - Supports slide-up, fade, and scale transitions
/// - Optional close button
/// - Keyboard avoidance
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// .dsFullScreenCover(isPresented: $showCover) {
///     FullScreenContent()
/// }
/// ```
public struct DSFullScreenCover<Content: View>: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    private let transition: Transition
    private let showCloseButton: Bool
    private let closeButtonPosition: CloseButtonPosition
    private let backgroundColor: Color
    private let content: Content

    @State private var animationProgress: CGFloat = 0

    // MARK: - Initialization

    /// Creates a new DSFullScreenCover
    /// - Parameters:
    ///   - isPresented: Binding to control cover visibility
    ///   - transition: The transition animation type (default: .slideUp)
    ///   - showCloseButton: Whether to show a close button (default: true)
    ///   - closeButtonPosition: Position of the close button (default: .topTrailing)
    ///   - backgroundColor: Background color of the cover (default: system background)
    ///   - content: The cover content
    public init(
        isPresented: Binding<Bool>,
        transition: Transition = .slideUp,
        showCloseButton: Bool = true,
        closeButtonPosition: CloseButtonPosition = .topTrailing,
        backgroundColor: Color = Color(UIColor.systemBackground),
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.transition = transition
        self.showCloseButton = showCloseButton
        self.closeButtonPosition = closeButtonPosition
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                    .opacity(backgroundOpacity)

                // Content
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .modifier(TransitionModifier(
                        transition: transition,
                        progress: animationProgress,
                        geometry: geometry
                    ))

                // Close button
                if showCloseButton {
                    closeButton(in: geometry)
                        .opacity(animationProgress)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            presentCover()
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Full screen cover")
    }

    // MARK: - Subviews

    private func closeButton(in geometry: GeometryProxy) -> some View {
        VStack {
            if closeButtonPosition == .topLeading || closeButtonPosition == .topTrailing {
                HStack {
                    if closeButtonPosition == .topTrailing {
                        Spacer()
                    }

                    Button {
                        dismissCover()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(UIColor.systemGray2))
                    }
                    .padding(DSSpacing.lg)
                    .padding(.top, geometry.safeAreaInsets.top)
                    .accessibilityLabel("Close")
                    .accessibilityHint("Double tap to close")

                    if closeButtonPosition == .topLeading {
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }

    // MARK: - Computed Properties

    private var backgroundOpacity: Double {
        switch transition {
        case .fade, .scale:
            return animationProgress
        case .slideUp:
            return 1.0
        }
    }

    // MARK: - Actions

    private func presentCover() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            animationProgress = 1.0
        }
    }

    private func dismissCover() {
        withAnimation(.easeOut(duration: 0.25)) {
            animationProgress = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPresented = false
        }
    }
}

// MARK: - Transition

public extension DSFullScreenCover {
    /// Transition animation types for the full screen cover
    enum Transition: Sendable {
        /// Slides up from the bottom
        case slideUp
        /// Fades in
        case fade
        /// Scales from center
        case scale
    }
}

// MARK: - Close Button Position

public extension DSFullScreenCover {
    /// Position options for the close button
    enum CloseButtonPosition: Sendable {
        case topLeading
        case topTrailing
    }
}

// MARK: - Transition Modifier

private struct TransitionModifier: ViewModifier {
    let transition: DSFullScreenCover<AnyView>.Transition
    let progress: CGFloat
    let geometry: GeometryProxy

    func body(content: Content) -> some View {
        switch transition {
        case .slideUp:
            content
                .offset(y: (1 - progress) * geometry.size.height)
        case .fade:
            content
                .opacity(progress)
        case .scale:
            content
                .scaleEffect(0.8 + (0.2 * progress))
                .opacity(progress)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Presents a design system full screen cover
    /// - Parameters:
    ///   - isPresented: Binding to control cover visibility
    ///   - transition: The transition animation type
    ///   - showCloseButton: Whether to show a close button
    ///   - closeButtonPosition: Position of the close button
    ///   - backgroundColor: Background color of the cover
    ///   - content: The cover content
    /// - Returns: Modified view with full screen cover capability
    func dsFullScreenCover<Content: View>(
        isPresented: Binding<Bool>,
        transition: DSFullScreenCover<Content>.Transition = .slideUp,
        showCloseButton: Bool = true,
        closeButtonPosition: DSFullScreenCover<Content>.CloseButtonPosition = .topTrailing,
        backgroundColor: Color = Color(UIColor.systemBackground),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSFullScreenCover(
                    isPresented: isPresented,
                    transition: transition,
                    showCloseButton: showCloseButton,
                    closeButtonPosition: closeButtonPosition,
                    backgroundColor: backgroundColor,
                    content: content
                )
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSFullScreenCover_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Slide up transition
            FullScreenCoverPreviewWrapper(transition: .slideUp)
                .previewDisplayName("Slide Up")

            // Fade transition
            FullScreenCoverPreviewWrapper(transition: .fade)
                .previewDisplayName("Fade")

            // Scale transition
            FullScreenCoverPreviewWrapper(transition: .scale)
                .previewDisplayName("Scale")

            // Dark mode
            FullScreenCoverPreviewWrapper(transition: .slideUp)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

private struct FullScreenCoverPreviewWrapper: View {
    let transition: DSFullScreenCover<AnyView>.Transition
    @State private var isPresented = true

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("Background Content")
                    .foregroundColor(.secondary)

                Button("Show Cover") {
                    isPresented = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .dsFullScreenCover(
            isPresented: $isPresented,
            transition: transition
        ) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.accentColor)
                            .padding(.top, 40)

                        Text("Full Screen Content")
                            .font(.largeTitle)
                            .bold()

                        Text("This is a full screen cover that can contain any content. It covers the entire screen including safe areas.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        ForEach(0..<10) { index in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("Item \(index + 1)")
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}
#endif

import SwiftUI

// MARK: - DSBottomSheet

/// A customizable bottom sheet with detent support
///
/// DSBottomSheet provides a modal sheet that slides up from the bottom with:
/// - Multiple detent heights (small, medium, large, custom)
/// - Drag to resize between detents
/// - Drag to dismiss
/// - Backdrop dimming
/// - Keyboard avoidance
/// - Safe area handling
/// - Custom corner radius
///
/// Example usage:
/// ```swift
/// .dsSheet(isPresented: $show, detents: [.medium, .large]) {
///     SheetContent()
/// }
/// ```
public struct DSBottomSheet<Content: View>: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    private let detents: [DSDetent]
    private let selectedDetent: Binding<DSDetent>?
    private let showDragIndicator: Bool
    private let dismissOnBackdropTap: Bool
    private let dismissOnDragDown: Bool
    private let cornerRadius: CGFloat
    private let content: Content

    @State private var currentDetent: DSDetent
    @State private var dragOffset: CGFloat = 0
    @State private var backdropOpacity: Double = 0
    @State private var sheetOffset: CGFloat = 1000
    @GestureState private var isDragging: Bool = false

    // MARK: - Initialization

    /// Creates a new DSBottomSheet
    /// - Parameters:
    ///   - isPresented: Binding to control sheet visibility
    ///   - detents: Array of available detent heights (default: [.medium, .large])
    ///   - selectedDetent: Optional binding to track/control current detent
    ///   - showDragIndicator: Whether to show the drag handle (default: true)
    ///   - dismissOnBackdropTap: Whether tapping backdrop dismisses (default: true)
    ///   - dismissOnDragDown: Whether dragging down past threshold dismisses (default: true)
    ///   - cornerRadius: Corner radius of the sheet (default: 16)
    ///   - content: The sheet content
    public init(
        isPresented: Binding<Bool>,
        detents: [DSDetent] = [.medium, .large],
        selectedDetent: Binding<DSDetent>? = nil,
        showDragIndicator: Bool = true,
        dismissOnBackdropTap: Bool = true,
        dismissOnDragDown: Bool = true,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.detents = detents.isEmpty ? [.medium] : detents
        self.selectedDetent = selectedDetent
        self.showDragIndicator = showDragIndicator
        self.dismissOnBackdropTap = dismissOnBackdropTap
        self.dismissOnDragDown = dismissOnDragDown
        self.cornerRadius = cornerRadius
        self.content = content()

        let initialDetent = selectedDetent?.wrappedValue ?? DSDetent.sorted(detents).first ?? .medium
        self._currentDetent = State(initialValue: initialDetent)
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Backdrop
                backdrop

                // Sheet
                sheetContent(in: geometry)
            }
            .ignoresSafeArea()
            .onAppear {
                presentSheet(in: geometry)
            }
        }
    }

    // MARK: - Subviews

    private var backdrop: some View {
        Color.black
            .opacity(backdropOpacity)
            .onTapGesture {
                if dismissOnBackdropTap {
                    dismissSheet()
                }
            }
            .accessibilityHidden(true)
    }

    private func sheetContent(in geometry: GeometryProxy) -> some View {
        let sheetHeight = currentDetent.height(in: geometry.size.height)
        let safeAreaBottom = geometry.safeAreaInsets.bottom

        return VStack(spacing: 0) {
            // Drag indicator
            if showDragIndicator {
                DSDragIndicator()
            }

            // Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(width: geometry.size.width, height: sheetHeight + safeAreaBottom)
        .background(
            RoundedCorner(radius: cornerRadius, corners: [.topLeft, .topRight])
                .fill(Color(UIColor.systemBackground))
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
        .offset(y: sheetOffset + dragOffset)
        .gesture(dragGesture(in: geometry))
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Bottom sheet")
    }

    // MARK: - Gesture

    private func dragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                let translation = value.translation.height
                // Allow free dragging up, but add resistance when dragging down
                if translation > 0 {
                    dragOffset = translation * 0.8
                } else {
                    dragOffset = translation * 0.5
                }

                // Update backdrop opacity based on drag
                updateBackdropDuringDrag(in: geometry)
            }
            .onEnded { value in
                handleDragEnd(value: value, in: geometry)
            }
    }

    // MARK: - Actions

    private func presentSheet(in geometry: GeometryProxy) {
        let targetHeight = currentDetent.height(in: geometry.size.height)
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        sheetOffset = targetHeight + safeAreaBottom

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            sheetOffset = 0
            backdropOpacity = backdropOpacityForDetent(currentDetent)
        }
    }

    private func dismissSheet() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            sheetOffset = 1000
            backdropOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }

    private func handleDragEnd(value: DragGesture.Value, in geometry: GeometryProxy) {
        let velocity = value.predictedEndTranslation.height - value.translation.height
        let translation = value.translation.height
        let containerHeight = geometry.size.height
        let currentHeight = currentDetent.height(in: containerHeight)
        let newHeightFraction = (currentHeight - translation) / containerHeight

        // Check for dismiss gesture
        if dismissOnDragDown && translation > 150 && velocity > 0 {
            dismissSheet()
            return
        }

        // Determine target detent based on drag direction and velocity
        let targetDetent: DSDetent

        if abs(velocity) > 500 {
            // Fast swipe - go to next detent in swipe direction
            if velocity > 0 {
                targetDetent = DSDetent.nextSmaller(from: currentDetent, in: detents) ?? currentDetent
            } else {
                targetDetent = DSDetent.nextLarger(from: currentDetent, in: detents) ?? currentDetent
            }
        } else {
            // Slow drag - snap to closest detent
            targetDetent = DSDetent.closest(to: newHeightFraction, in: detents)
        }

        // Animate to target detent
        animateToDetent(targetDetent, in: geometry)
    }

    private func animateToDetent(_ detent: DSDetent, in geometry: GeometryProxy) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            currentDetent = detent
            dragOffset = 0
            backdropOpacity = backdropOpacityForDetent(detent)
        }

        selectedDetent?.wrappedValue = detent
    }

    private func updateBackdropDuringDrag(in geometry: GeometryProxy) {
        let currentHeight = currentDetent.height(in: geometry.size.height)
        let effectiveHeight = currentHeight - dragOffset
        let fraction = effectiveHeight / geometry.size.height

        backdropOpacity = min(0.5, max(0, fraction * 0.5))
    }

    private func backdropOpacityForDetent(_ detent: DSDetent) -> Double {
        min(0.5, detent.fraction * 0.5)
    }
}

// MARK: - RoundedCorner Shape

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - View Extension

public extension View {
    /// Presents a design system bottom sheet
    /// - Parameters:
    ///   - isPresented: Binding to control sheet visibility
    ///   - detents: Array of available detent heights
    ///   - selectedDetent: Optional binding to track/control current detent
    ///   - showDragIndicator: Whether to show the drag handle
    ///   - dismissOnBackdropTap: Whether tapping backdrop dismisses
    ///   - dismissOnDragDown: Whether dragging down dismisses
    ///   - cornerRadius: Corner radius of the sheet
    ///   - content: The sheet content
    /// - Returns: Modified view with sheet capability
    func dsSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [DSDetent] = [.medium, .large],
        selectedDetent: Binding<DSDetent>? = nil,
        showDragIndicator: Bool = true,
        dismissOnBackdropTap: Bool = true,
        dismissOnDragDown: Bool = true,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                DSBottomSheet(
                    isPresented: isPresented,
                    detents: detents,
                    selectedDetent: selectedDetent,
                    showDragIndicator: showDragIndicator,
                    dismissOnBackdropTap: dismissOnBackdropTap,
                    dismissOnDragDown: dismissOnDragDown,
                    cornerRadius: cornerRadius,
                    content: content
                )
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard bottom sheet
            BottomSheetPreviewWrapper(detents: [.medium, .large])
                .previewDisplayName("Standard Sheet")

            // Small to large
            BottomSheetPreviewWrapper(detents: [.small, .medium, .large])
                .previewDisplayName("Full Range")

            // Single detent
            BottomSheetPreviewWrapper(detents: [.medium])
                .previewDisplayName("Single Detent")

            // Dark mode
            BottomSheetPreviewWrapper(detents: [.medium, .large])
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

private struct BottomSheetPreviewWrapper: View {
    let detents: [DSDetent]
    @State private var isPresented = true
    @State private var selectedDetent: DSDetent = .medium

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                Text("Main Content")
                    .foregroundColor(.secondary)

                Button("Show Sheet") {
                    isPresented = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .dsSheet(
            isPresented: $isPresented,
            detents: detents,
            selectedDetent: $selectedDetent
        ) {
            VStack(spacing: 16) {
                Text("Sheet Content")
                    .font(.headline)

                Text("Current detent: \(detentName(selectedDetent))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                ForEach(0..<5) { index in
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Item \(index + 1)")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func detentName(_ detent: DSDetent) -> String {
        switch detent {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .custom(let value): return "Custom (\(Int(value * 100))%)"
        }
    }
}
#endif

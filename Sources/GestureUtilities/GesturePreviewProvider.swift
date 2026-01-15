import SwiftUI

// MARK: - Swipe Gesture Preview

struct SwipeGesturePreview: View {
    @State private var swipeDirection: String = "No swipe"
    @State private var backgroundColor: Color = .blue

    var body: some View {
        VStack(spacing: 20) {
            Text("Swipe Gesture Demo")
                .font(.headline)

            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .frame(height: 200)
                .overlay(
                    Text(swipeDirection)
                        .foregroundColor(.white)
                        .font(.title2)
                )
                .onSwipe(configuration: .default, handlers: [
                    .left: {
                        swipeDirection = "← Left"
                        backgroundColor = .red
                    },
                    .right: {
                        swipeDirection = "Right →"
                        backgroundColor = .green
                    },
                    .up: {
                        swipeDirection = "↑ Up"
                        backgroundColor = .purple
                    },
                    .down: {
                        swipeDirection = "↓ Down"
                        backgroundColor = .orange
                    }
                ])

            Text("Swipe in any direction")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Long Press Gesture Preview

struct LongPressGesturePreview: View {
    @State private var pressState: LongPressState = .inactive
    @State private var pressCount: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Long Press Gesture Demo")
                .font(.headline)

            Circle()
                .fill(stateColor)
                .frame(width: 150, height: 150)
                .overlay(
                    VStack {
                        Text(stateText)
                            .foregroundColor(.white)
                            .font(.headline)
                        Text("Count: \(pressCount)")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)
                    }
                )
                .scaleEffect(pressState == .pressing ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: pressState)
                .onLongPress(
                    state: $pressState,
                    configuration: .default
                ) {
                    pressCount += 1
                }

            Text("Press and hold for 0.5 seconds")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private var stateColor: Color {
        switch pressState {
        case .inactive: return .blue
        case .pressing: return .orange
        case .completed: return .green
        }
    }

    private var stateText: String {
        switch pressState {
        case .inactive: return "Press me"
        case .pressing: return "Pressing..."
        case .completed: return "Done!"
        }
    }
}

// MARK: - Pinch to Zoom Preview

struct PinchToZoomPreview: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack(spacing: 20) {
            Text("Pinch to Zoom Demo")
                .font(.headline)

            ZStack {
                Color.gray.opacity(0.2)
                    .cornerRadius(16)

                ZoomableContainer(
                    scale: $scale,
                    offset: $offset,
                    configuration: .photoViewer
                ) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                }
            }
            .frame(height: 250)
            .clipped()

            HStack {
                Text("Scale: \(String(format: "%.2f", scale))")
                Spacer()
                Button("Reset") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scale = 1.0
                        offset = .zero
                    }
                }
                .buttonStyle(.bordered)
            }
            .font(.caption)
            .foregroundColor(.secondary)

            Text("Pinch to zoom, drag to pan")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Double Tap Gesture Preview

struct DoubleTapGesturePreview: View {
    @State private var isFavorite: Bool = false
    @State private var tapLocation: CGPoint = .zero
    @State private var showHeart: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Double Tap Gesture Demo")
                .font(.headline)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.3))
                    .frame(height: 200)

                VStack {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 50))
                        .foregroundColor(isFavorite ? .red : .gray)
                        .scaleEffect(showHeart ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: showHeart)

                    Text(isFavorite ? "Favorited!" : "Double tap to favorite")
                        .foregroundColor(.secondary)
                }
            }
            .doubleTapToggle($isFavorite)
            .onChange(of: isFavorite) { _ in
                showHeart = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showHeart = false
                }
            }

            Text("Double tap the area above")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Combined Gestures Preview

struct CombinedGesturesPreview: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastMessage: String = "Try different gestures"

    var body: some View {
        VStack(spacing: 20) {
            Text("Combined Gestures Demo")
                .font(.headline)

            Text(lastMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(height: 20)

            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
                .scaleEffect(scale)
                .onSwipe(.left) {
                    lastMessage = "Swiped left!"
                }
                .onSwipe(.right) {
                    lastMessage = "Swiped right!"
                }
                .onLongPress(minimumDuration: 0.5) {
                    lastMessage = "Long pressed!"
                }
                .onDoubleTap {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        scale = scale == 1.0 ? 1.2 : 1.0
                    }
                    lastMessage = "Double tapped! Scale: \(String(format: "%.1f", scale))"
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("Available gestures:")
                    .font(.caption.bold())
                Text("• Swipe left/right")
                Text("• Long press")
                Text("• Double tap to toggle scale")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Main Preview Container

struct GestureUtilitiesPreview: View {
    var body: some View {
        TabView {
            SwipeGesturePreview()
                .tabItem {
                    Label("Swipe", systemImage: "hand.draw")
                }

            LongPressGesturePreview()
                .tabItem {
                    Label("Long Press", systemImage: "hand.tap")
                }

            PinchToZoomPreview()
                .tabItem {
                    Label("Pinch", systemImage: "arrow.up.left.and.arrow.down.right")
                }

            DoubleTapGesturePreview()
                .tabItem {
                    Label("Double Tap", systemImage: "hand.tap.fill")
                }

            CombinedGesturesPreview()
                .tabItem {
                    Label("Combined", systemImage: "hand.raised")
                }
        }
    }
}

// MARK: - Preview Provider

#Preview("Gesture Utilities") {
    GestureUtilitiesPreview()
}

#Preview("Swipe Gesture") {
    SwipeGesturePreview()
}

#Preview("Long Press Gesture") {
    LongPressGesturePreview()
}

#Preview("Pinch to Zoom") {
    PinchToZoomPreview()
}

#Preview("Double Tap Gesture") {
    DoubleTapGesturePreview()
}

#Preview("Combined Gestures") {
    CombinedGesturesPreview()
}

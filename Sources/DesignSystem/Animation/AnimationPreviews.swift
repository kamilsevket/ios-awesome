import SwiftUI

// MARK: - Animation Preview Components

#if DEBUG

// MARK: - Transition Previews

struct TransitionPreviewsView: View {
    @State private var showFade = false
    @State private var showSlideUp = false
    @State private var showSlideDown = false
    @State private var showSlideLeft = false
    @State private var showSlideRight = false
    @State private var showScale = false
    @State private var showBounce = false
    @State private var showModal = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Transition Previews")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Fade
                PreviewRow(title: "Fade", isShowing: $showFade) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .frame(width: 100, height: 60)
                        .transition(.opacity)
                }

                // Slide Up
                PreviewRow(title: "Slide Up", isShowing: $showSlideUp) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green)
                        .frame(width: 100, height: 60)
                        .transition(AnyTransition.ds.slideUp)
                }

                // Slide Down
                PreviewRow(title: "Slide Down", isShowing: $showSlideDown) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange)
                        .frame(width: 100, height: 60)
                        .transition(AnyTransition.ds.slideDown)
                }

                // Scale
                PreviewRow(title: "Scale", isShowing: $showScale) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple)
                        .frame(width: 100, height: 60)
                        .transition(AnyTransition.ds.scale)
                }

                // Bounce
                PreviewRow(title: "Bounce", isShowing: $showBounce) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.pink)
                        .frame(width: 100, height: 60)
                        .transition(AnyTransition.ds.bounce)
                }

                // Pop In
                PreviewRow(title: "Pop In", isShowing: $showModal) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                        .frame(width: 100, height: 60)
                        .transition(AnyTransition.ds.popIn)
                }
            }
            .padding()
        }
    }
}

// MARK: - Spring Animation Previews

struct SpringAnimationPreviewsView: View {
    @State private var gentleScale: CGFloat = 1
    @State private var snappyScale: CGFloat = 1
    @State private var bouncyScale: CGFloat = 1
    @State private var stiffScale: CGFloat = 1
    @State private var interactiveScale: CGFloat = 1

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Spring Animations")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SpringPreviewRow(
                    title: "Gentle",
                    description: "response: 0.5, damping: 0.8",
                    scale: $gentleScale,
                    animation: Animation.ds.spring.gentle
                )

                SpringPreviewRow(
                    title: "Snappy",
                    description: "response: 0.3, damping: 0.7",
                    scale: $snappyScale,
                    animation: Animation.ds.spring.snappy
                )

                SpringPreviewRow(
                    title: "Bouncy",
                    description: "response: 0.4, damping: 0.5",
                    scale: $bouncyScale,
                    animation: Animation.ds.spring.bouncy
                )

                SpringPreviewRow(
                    title: "Stiff",
                    description: "response: 0.2, damping: 0.9",
                    scale: $stiffScale,
                    animation: Animation.ds.spring.stiff
                )

                SpringPreviewRow(
                    title: "Interactive",
                    description: "response: 0.15, damping: 0.86",
                    scale: $interactiveScale,
                    animation: Animation.ds.spring.interactive
                )
            }
            .padding()
        }
    }
}

// MARK: - Keyframe Animation Previews

struct KeyframeAnimationPreviewsView: View {
    @State private var isShaking = false
    @State private var isBouncing = false
    @State private var isPulsing = false
    @State private var isWiggling = false
    @State private var isHeartbeating = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Keyframe Animations")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Shake
                KeyframePreviewRow(title: "Shake", isActive: $isShaking) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 60, height: 60)
                        .dsShake(isActive: isShaking)
                }

                // Bounce
                KeyframePreviewRow(title: "Bounce", isActive: $isBouncing) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 60, height: 60)
                        .dsBounce(isActive: isBouncing)
                }

                // Pulse
                KeyframePreviewRow(title: "Pulse", isActive: $isPulsing) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 60, height: 60)
                        .dsPulse(isActive: isPulsing)
                }

                // Wiggle
                KeyframePreviewRow(title: "Wiggle", isActive: $isWiggling) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green)
                        .frame(width: 60, height: 60)
                        .dsWiggle(isActive: isWiggling)
                }

                // Heartbeat
                KeyframePreviewRow(title: "Heartbeat", isActive: $isHeartbeating) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.pink)
                        .dsHeartbeat(isActive: isHeartbeating, continuous: true)
                }
            }
            .padding()
        }
    }
}

// MARK: - Lottie Preview

struct LottiePreviewsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Lottie Animations")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Placeholder Views")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 24) {
                VStack {
                    DSLottieView.preview(loopMode: .loop, color: .blue)
                        .frame(width: 80, height: 80)
                    Text("Loading")
                        .font(.caption)
                }

                VStack {
                    DSLottieView.preview(loopMode: .playOnce, color: .green)
                        .frame(width: 80, height: 80)
                    Text("Success")
                        .font(.caption)
                }

                VStack {
                    DSLottieView.preview(loopMode: .playOnce, color: .red)
                        .frame(width: 80, height: 80)
                    Text("Error")
                        .font(.caption)
                }
            }

            Text("Connect Lottie library for actual animations")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .padding()
    }
}

// MARK: - Preset Previews

struct PresetPreviewsView: View {
    @State private var selectedPreset: DSAnimationPreset = .fadeIn
    @State private var isShowing = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Animation Presets")
                .font(.largeTitle)
                .fontWeight(.bold)

            Picker("Preset", selection: $selectedPreset) {
                ForEach(DSAnimationPreset.allCases, id: \.self) { preset in
                    Text(preset.rawValue).tag(preset)
                }
            }
            .pickerStyle(.menu)

            Button("Toggle") {
                withAnimation(selectedPreset.animation) {
                    isShowing.toggle()
                }
            }
            .buttonStyle(.borderedProminent)

            ZStack {
                if isShowing {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.gradient)
                        .frame(width: 150, height: 100)
                        .transition(selectedPreset.transition)
                }
            }
            .frame(height: 150)

            VStack(alignment: .leading, spacing: 8) {
                Text("Preset Info")
                    .font(.headline)
                Text("Duration: \(selectedPreset.defaultDuration, specifier: "%.2f")s")
                Text("Reduce Motion: \(selectedPreset.shouldReduceMotion ? "Yes" : "No")")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Helper Views

private struct PreviewRow<Content: View>: View {
    let title: String
    @Binding var isShowing: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button(isShowing ? "Hide" : "Show") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isShowing.toggle()
                    }
                }
                .buttonStyle(.bordered)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 80)

                if isShowing {
                    content()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

private struct SpringPreviewRow: View {
    let title: String
    let description: String
    @Binding var scale: CGFloat
    let animation: Animation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Circle()
                    .fill(Color.blue.gradient)
                    .frame(width: 60, height: 60)
                    .scaleEffect(scale)

                Spacer()

                Button("Animate") {
                    withAnimation(animation) {
                        scale = scale == 1 ? 1.3 : 1
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

private struct KeyframePreviewRow<Content: View>: View {
    let title: String
    @Binding var isActive: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button(isActive ? "Stop" : "Start") {
                    isActive.toggle()
                }
                .buttonStyle(.bordered)
            }

            HStack {
                Spacer()
                content()
                Spacer()
            }
            .frame(height: 80)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

// MARK: - Combined Preview

struct AnimationUtilitiesPreview: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TransitionPreviewsView()
                .tabItem {
                    Label("Transitions", systemImage: "arrow.left.arrow.right")
                }
                .tag(0)

            SpringAnimationPreviewsView()
                .tabItem {
                    Label("Springs", systemImage: "waveform")
                }
                .tag(1)

            KeyframeAnimationPreviewsView()
                .tabItem {
                    Label("Keyframes", systemImage: "chart.xyaxis.line")
                }
                .tag(2)

            LottiePreviewsView()
                .tabItem {
                    Label("Lottie", systemImage: "play.circle")
                }
                .tag(3)

            PresetPreviewsView()
                .tabItem {
                    Label("Presets", systemImage: "slider.horizontal.3")
                }
                .tag(4)
        }
    }
}

// MARK: - Preview Provider

struct AnimationPreviews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnimationUtilitiesPreview()
                .previewDisplayName("All Animations")

            TransitionPreviewsView()
                .previewDisplayName("Transitions")

            SpringAnimationPreviewsView()
                .previewDisplayName("Springs")

            KeyframeAnimationPreviewsView()
                .previewDisplayName("Keyframes")

            LottiePreviewsView()
                .previewDisplayName("Lottie")

            PresetPreviewsView()
                .previewDisplayName("Presets")
        }
    }
}

#endif

import SwiftUI
import DesignSystem
import GestureUtilities

/// Demo view showcasing all utilities: Animation, Gestures, Accessibility, and Theme.
public struct UtilitiesDemoView: View {
    public init() {}

    public var body: some View {
        List {
            NavigationLink("Animations", destination: AnimationsDemoView())
            NavigationLink("Gestures", destination: GesturesDemoView())
            NavigationLink("Accessibility", destination: AccessibilityDemoView())
            NavigationLink("Theme Manager", destination: ThemeDemoView())
            NavigationLink("Popovers & Tooltips", destination: PopoverTooltipDemoView())
        }
        .navigationTitle("Utilities")
    }
}

// MARK: - Animations Demo

struct AnimationsDemoView: View {
    @State private var isAnimating = false
    @State private var shakeCount = 0
    @State private var bounceCount = 0

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Spring Animations
                sectionHeader("Spring Animations")
                HStack(spacing: DSSpacing.lg) {
                    animationBox("Gentle", animation: .dsGentle)
                    animationBox("Snappy", animation: .dsSnappy)
                    animationBox("Bouncy", animation: .dsBouncy)
                }

                Divider()

                // Transition Presets
                sectionHeader("Transition Presets")
                VStack(spacing: DSSpacing.md) {
                    DSButton("Toggle Visibility", style: .primary, isFullWidth: true) {
                        withAnimation(.dsSnappy) {
                            isAnimating.toggle()
                        }
                    }

                    if isAnimating {
                        HStack(spacing: DSSpacing.md) {
                            transitionDemo("Fade", transition: .dsFadeIn)
                            transitionDemo("Scale", transition: .dsScale)
                            transitionDemo("Slide", transition: .dsSlideUp)
                        }
                        .transition(.dsPopIn)
                    }
                }

                Divider()

                // Keyframe Animations
                sectionHeader("Keyframe Animations")
                VStack(spacing: DSSpacing.md) {
                    HStack(spacing: DSSpacing.lg) {
                        VStack {
                            Circle()
                                .fill(DSColors.primary)
                                .frame(width: 60, height: 60)
                                .modifier(ShakeEffect(shakes: shakeCount))

                            DSButton("Shake", style: .secondary, size: .small) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    shakeCount += 1
                                }
                            }
                        }

                        VStack {
                            Circle()
                                .fill(DSColors.success)
                                .frame(width: 60, height: 60)
                                .modifier(BounceEffect(bounces: bounceCount))

                            DSButton("Bounce", style: .secondary, size: .small) {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    bounceCount += 1
                                }
                            }
                        }
                    }
                }

                Divider()

                // Animation Helpers
                sectionHeader("Animation Helpers")
                VStack(spacing: DSSpacing.md) {
                    Text("Use withDSAnimation() for consistent animations")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)

                    DSButton("Animate with Haptic", style: .primary) {
                        withDSAnimation(.bouncy) {
                            isAnimating.toggle()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Animations")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func animationBox(_ name: String, animation: Animation) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(DSColors.primary)
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(animation, value: isAnimating)

            Text(name)
                .font(.caption)
        }
    }

    private func transitionDemo(_ name: String, transition: AnyTransition) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(DSColors.info)
                .frame(width: 60, height: 60)

            Text(name)
                .font(.caption)
        }
    }
}

// Shake effect modifier
struct ShakeEffect: GeometryEffect {
    var shakes: Int

    var animatableData: CGFloat {
        get { CGFloat(shakes) }
        set { shakes = Int(newValue) }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(animatableData * .pi * 4) * 10
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// Bounce effect modifier
struct BounceEffect: GeometryEffect {
    var bounces: Int

    var animatableData: CGFloat {
        get { CGFloat(bounces) }
        set { bounces = Int(newValue) }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = -abs(sin(animatableData * .pi * 2)) * 20
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: translation))
    }
}

// Animation helper
func withDSAnimation<Result>(_ animation: Animation = .dsSnappy, _ body: () throws -> Result) rethrows -> Result {
    try withAnimation(animation, body)
}

// MARK: - Gestures Demo

struct GesturesDemoView: View {
    @State private var tapCount = 0
    @State private var longPressActive = false
    @State private var swipeDirection: String = "None"
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Tap Gestures
                sectionHeader("Tap Gestures")
                HStack(spacing: DSSpacing.lg) {
                    // Single Tap
                    VStack {
                        Circle()
                            .fill(DSColors.primary)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("\(tapCount)")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                tapCount += 1
                                HapticManager.shared.impact(.light)
                            }

                        Text("Single Tap")
                            .font(.caption)
                    }

                    // Double Tap
                    VStack {
                        Circle()
                            .fill(DSColors.success)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "heart.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            )
                            .onTapGesture(count: 2) {
                                HapticManager.shared.notification(.success)
                            }

                        Text("Double Tap")
                            .font(.caption)
                    }
                }

                Divider()

                // Long Press
                sectionHeader("Long Press")
                RoundedRectangle(cornerRadius: 12)
                    .fill(longPressActive ? DSColors.success : DSColors.primary)
                    .frame(height: 80)
                    .overlay(
                        Text(longPressActive ? "Release!" : "Press and Hold")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                    .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                        withAnimation(.dsSnappy) {
                            longPressActive = isPressing
                        }
                        if isPressing {
                            HapticManager.shared.impact(.medium)
                        }
                    }, perform: {
                        HapticManager.shared.notification(.success)
                    })

                Divider()

                // Swipe Gestures
                sectionHeader("Swipe Gestures")
                RoundedRectangle(cornerRadius: 12)
                    .fill(DSColors.info)
                    .frame(height: 100)
                    .overlay(
                        VStack {
                            Image(systemName: swipeIcon)
                                .font(.title)
                            Text("Swipe: \(swipeDirection)")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                let horizontal = value.translation.width
                                let vertical = value.translation.height

                                if abs(horizontal) > abs(vertical) {
                                    swipeDirection = horizontal > 0 ? "Right" : "Left"
                                } else {
                                    swipeDirection = vertical > 0 ? "Down" : "Up"
                                }
                                HapticManager.shared.impact(.light)
                            }
                    )

                Divider()

                // Pinch to Zoom
                sectionHeader("Pinch to Zoom")
                RoundedRectangle(cornerRadius: 12)
                    .fill(DSColors.warning)
                    .frame(width: 150 * scale, height: 150 * scale)
                    .overlay(
                        Image(systemName: "hand.pinch")
                            .font(.system(size: 40 * scale))
                            .foregroundColor(.white)
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = min(max(value, 0.5), 2.0)
                            }
                            .onEnded { _ in
                                withAnimation(.dsSnappy) {
                                    scale = 1.0
                                }
                            }
                    )

                Divider()

                // Drag Gesture
                sectionHeader("Drag Gesture")
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DSColors.border, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(height: 150)

                    Circle()
                        .fill(DSColors.error)
                        .frame(width: 60, height: 60)
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                                .onEnded { _ in
                                    withAnimation(.dsBouncy) {
                                        offset = .zero
                                    }
                                    HapticManager.shared.impact(.light)
                                }
                        )
                }
            }
            .padding()
        }
        .navigationTitle("Gestures")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var swipeIcon: String {
        switch swipeDirection {
        case "Left": return "arrow.left"
        case "Right": return "arrow.right"
        case "Up": return "arrow.up"
        case "Down": return "arrow.down"
        default: return "arrow.left.and.right"
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Accessibility Demo

struct AccessibilityDemoView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.colorSchemeContrast) var contrast

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Dynamic Type
                sectionHeader("Dynamic Type Support")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    Text("Current size: \(dynamicTypeSize.description)")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)

                    Text("Large Title")
                        .font(.largeTitle)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility3)

                    Text("Body Text")
                        .font(.body)

                    Text("Caption")
                        .font(.caption)
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)

                Divider()

                // Reduce Motion
                sectionHeader("Reduce Motion")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    Text("Reduce Motion: \(reduceMotion ? "Enabled" : "Disabled")")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)

                    DSButton("Animated Button", style: .primary) { }
                        .animation(reduceMotion ? nil : .dsBouncy, value: reduceMotion)
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)

                Divider()

                // High Contrast
                sectionHeader("High Contrast")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    Text("High Contrast: \(contrast == .increased ? "Enabled" : "Disabled")")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)

                    HStack(spacing: DSSpacing.md) {
                        Circle()
                            .fill(DSColors.primary)
                            .frame(width: 40, height: 40)
                        Circle()
                            .fill(DSColors.success)
                            .frame(width: 40, height: 40)
                        Circle()
                            .fill(DSColors.warning)
                            .frame(width: 40, height: 40)
                        Circle()
                            .fill(DSColors.error)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)

                Divider()

                // Accessibility Labels
                sectionHeader("Accessibility Labels")
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    Text("All components include proper accessibility support:")
                        .font(.body)
                        .foregroundColor(DSColors.textSecondary)

                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        accessibilityFeature("VoiceOver labels")
                        accessibilityFeature("Accessibility hints")
                        accessibilityFeature("Focus management")
                        accessibilityFeature("Dynamic Type scaling")
                        accessibilityFeature("Reduce motion support")
                        accessibilityFeature("High contrast mode")
                    }
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)

                Divider()

                // VoiceOver Announcements
                sectionHeader("VoiceOver Announcements")
                DSButton("Announce Message", style: .primary, isFullWidth: true) {
                    DSAnnounce.announce("This is a VoiceOver announcement")
                }
            }
            .padding()
        }
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func accessibilityFeature(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(DSColors.success)
            Text(text)
                .font(.body)
        }
    }
}

extension DynamicTypeSize {
    var description: String {
        switch self {
        case .xSmall: return "Extra Small"
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large (Default)"
        case .xLarge: return "Extra Large"
        case .xxLarge: return "XX Large"
        case .xxxLarge: return "XXX Large"
        case .accessibility1: return "Accessibility 1"
        case .accessibility2: return "Accessibility 2"
        case .accessibility3: return "Accessibility 3"
        case .accessibility4: return "Accessibility 4"
        case .accessibility5: return "Accessibility 5"
        @unknown default: return "Unknown"
        }
    }
}

// MARK: - Theme Demo

struct ThemeDemoView: View {
    @StateObject private var themeManager = DSThemeManager.shared
    @State private var selectedTheme = 0

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Theme Selection
                sectionHeader("Theme Selection")
                DSSegmentedControl(
                    selection: $selectedTheme,
                    segments: [
                        DSSegment(title: "Light"),
                        DSSegment(title: "Dark"),
                        DSSegment(title: "System")
                    ]
                )
                .onChange(of: selectedTheme) { newValue in
                    switch newValue {
                    case 0:
                        themeManager.setTheme(.light)
                    case 1:
                        themeManager.setTheme(.dark)
                    default:
                        themeManager.setTheme(.system)
                    }
                }

                Divider()

                // Theme Preview
                sectionHeader("Theme Preview")
                VStack(spacing: DSSpacing.md) {
                    // Colors preview
                    HStack(spacing: DSSpacing.md) {
                        colorPreview("Primary", DSColors.primary)
                        colorPreview("Success", DSColors.success)
                        colorPreview("Warning", DSColors.warning)
                        colorPreview("Error", DSColors.error)
                    }

                    // Components preview
                    VStack(spacing: DSSpacing.md) {
                        DSButton("Primary Button", style: .primary) { }
                        DSButton("Secondary Button", style: .secondary) { }

                        DSCard {
                            HStack {
                                DSAvatar(initials: "AB", size: .md)
                                VStack(alignment: .leading) {
                                    Text("Card Title")
                                        .font(.headline)
                                    Text("Card subtitle text")
                                        .font(.body)
                                        .foregroundColor(DSColors.textSecondary)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)

                Divider()

                // Current Theme Info
                sectionHeader("Current Theme")
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    themeInfo("Mode", themeManager.currentTheme.rawValue.capitalized)
                    themeInfo("Color Scheme", themeManager.colorScheme?.description ?? "System")
                }
                .padding()
                .background(DSColors.backgroundSecondary)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Theme Manager")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func colorPreview(_ name: String, _ color: Color) -> some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
            Text(name)
                .font(.caption2)
        }
    }

    private func themeInfo(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(DSColors.textSecondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

extension ColorScheme {
    var description: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        @unknown default: return "Unknown"
        }
    }
}

// MARK: - Popover & Tooltip Demo

struct PopoverTooltipDemoView: View {
    @State private var showPopover = false
    @State private var showTooltip = false
    @State private var showContextMenu = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Popover
                sectionHeader("Popover")
                DSButton("Show Popover", style: .primary) {
                    showPopover = true
                }
                .dsPopover(isPresented: $showPopover, edge: .bottom) {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("Popover Content")
                            .font(.headline)
                        Text("This is a popover that appears attached to the button.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                        DSButton("Close", style: .secondary, size: .small) {
                            showPopover = false
                        }
                    }
                    .padding()
                    .frame(width: 250)
                }

                Divider()

                // Tooltip
                sectionHeader("Tooltip")
                HStack(spacing: DSSpacing.xl) {
                    VStack {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .foregroundColor(DSColors.info)
                            .dsTooltip("Information tooltip", style: .info)

                        Text("Info")
                            .font(.caption)
                    }

                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.title)
                            .foregroundColor(DSColors.warning)
                            .dsTooltip("Warning tooltip", style: .warning)

                        Text("Warning")
                            .font(.caption)
                    }

                    VStack {
                        Image(systemName: "xmark.octagon")
                            .font(.title)
                            .foregroundColor(DSColors.error)
                            .dsTooltip("Error tooltip", style: .error)

                        Text("Error")
                            .font(.caption)
                    }
                }

                Text("Hover or long-press icons to see tooltips")
                    .font(.caption)
                    .foregroundColor(DSColors.textTertiary)

                Divider()

                // Context Menu
                sectionHeader("Context Menu")
                DSCard {
                    HStack {
                        Image(systemName: "doc.text")
                            .font(.title2)
                            .foregroundColor(DSColors.primary)

                        VStack(alignment: .leading) {
                            Text("Document.pdf")
                                .font(.headline)
                            Text("Long press for options")
                                .font(.caption)
                                .foregroundColor(DSColors.textSecondary)
                        }

                        Spacer()
                    }
                    .padding()
                }
                .dsContextMenu {
                    DSContextMenu.MenuItem(title: "Open", icon: Image(systemName: "doc")) {
                        print("Open")
                    }
                    DSContextMenu.MenuItem(title: "Share", icon: Image(systemName: "square.and.arrow.up")) {
                        print("Share")
                    }
                    DSContextMenu.MenuItem(title: "Copy", icon: Image(systemName: "doc.on.doc")) {
                        print("Copy")
                    }
                    DSContextMenu.MenuDivider()
                    DSContextMenu.MenuItem(title: "Delete", icon: Image(systemName: "trash"), role: .destructive) {
                        print("Delete")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Popovers & Tooltips")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct UtilitiesDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UtilitiesDemoView()
        }
    }
}
#endif

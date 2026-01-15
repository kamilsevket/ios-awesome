import SwiftUI

// MARK: - FAB Size

/// Size variants for Floating Action Button
public enum DSFABSize {
    case small
    case regular
    case extended

    var diameter: CGFloat {
        switch self {
        case .small: return 40
        case .regular: return 56
        case .extended: return 56
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 20
        case .regular: return 24
        case .extended: return 24
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .small: return 4
        case .regular: return 8
        case .extended: return 8
        }
    }
}

// MARK: - DSFloatingActionButton

/// A Material Design-inspired Floating Action Button
///
/// DSFloatingActionButton (FAB) represents the primary action of a screen.
/// It floats above the UI and is typically positioned in the bottom-right corner.
///
/// Features:
/// - Regular circular FAB with icon
/// - Extended FAB with icon and text
/// - Customizable colors
/// - Shadow and elevation effects
/// - Scale animation on press
/// - Haptic feedback
/// - Full accessibility support
///
/// Example usage:
/// ```swift
/// // Regular FAB
/// DSFloatingActionButton(systemName: "plus") {
///     createNewItem()
/// }
///
/// // Extended FAB
/// DSFloatingActionButton.extended(
///     systemName: "plus",
///     title: "Create"
/// ) {
///     createNewItem()
/// }
/// ```
public struct DSFloatingActionButton: View {
    // MARK: - Properties

    private let icon: Image
    private let title: String?
    private let size: DSFABSize
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let isEnabled: Bool
    private let hapticFeedback: Bool
    private let accessibilityLabel: String
    private let action: () -> Void

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a standard circular FAB with a system icon
    /// - Parameters:
    ///   - systemName: SF Symbol name for the icon
    ///   - size: FAB size variant (default: .regular)
    ///   - backgroundColor: Background color (default: .accentColor)
    ///   - foregroundColor: Icon color (default: .white)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback (default: true)
    ///   - accessibilityLabel: VoiceOver label
    ///   - action: Closure executed when FAB is tapped
    public init(
        systemName: String,
        size: DSFABSize = .regular,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = Image(systemName: systemName)
        self.title = nil
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.isEnabled = isEnabled
        self.hapticFeedback = hapticFeedback
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    /// Creates a FAB with a custom image
    /// - Parameters:
    ///   - icon: Custom image for the icon
    ///   - size: FAB size variant (default: .regular)
    ///   - backgroundColor: Background color (default: .accentColor)
    ///   - foregroundColor: Icon color (default: .white)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback (default: true)
    ///   - accessibilityLabel: VoiceOver label
    ///   - action: Closure executed when FAB is tapped
    public init(
        icon: Image,
        size: DSFABSize = .regular,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = nil
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.isEnabled = isEnabled
        self.hapticFeedback = hapticFeedback
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    /// Internal initializer for extended FAB
    private init(
        icon: Image,
        title: String?,
        size: DSFABSize,
        backgroundColor: Color,
        foregroundColor: Color,
        isEnabled: Bool,
        hapticFeedback: Bool,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.isEnabled = isEnabled
        self.hapticFeedback = hapticFeedback
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .shadow(
            color: backgroundColor.opacity(0.3),
            radius: isPressed ? size.shadowRadius / 2 : size.shadowRadius,
            x: 0,
            y: isPressed ? 2 : 4
        )
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    // MARK: - Subviews

    @ViewBuilder
    private var buttonContent: some View {
        if let title = title {
            // Extended FAB
            HStack(spacing: 12) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.iconSize, height: size.iconSize)

                Text(title)
                    .font(.body.weight(.semibold))
            }
            .padding(.horizontal, 20)
            .frame(height: size.diameter)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
        } else {
            // Regular circular FAB
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.iconSize, height: size.iconSize)
                .frame(width: size.diameter, height: size.diameter)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(Circle())
        }
    }

    // MARK: - Actions

    private func handleTap() {
        guard isEnabled else { return }

        if hapticFeedback {
            triggerHapticFeedback()
        }

        action()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Extended FAB Factory

extension DSFloatingActionButton {
    /// Creates an extended FAB with icon and text
    /// - Parameters:
    ///   - systemName: SF Symbol name for the icon
    ///   - title: Text label displayed next to the icon
    ///   - backgroundColor: Background color (default: .accentColor)
    ///   - foregroundColor: Text and icon color (default: .white)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback (default: true)
    ///   - action: Closure executed when FAB is tapped
    public static func extended(
        systemName: String,
        title: String,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        action: @escaping () -> Void
    ) -> DSFloatingActionButton {
        DSFloatingActionButton(
            icon: Image(systemName: systemName),
            title: title,
            size: .extended,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            isEnabled: isEnabled,
            hapticFeedback: hapticFeedback,
            accessibilityLabel: title,
            action: action
        )
    }

    /// Creates an extended FAB with a custom icon and text
    /// - Parameters:
    ///   - icon: Custom image for the icon
    ///   - title: Text label displayed next to the icon
    ///   - backgroundColor: Background color (default: .accentColor)
    ///   - foregroundColor: Text and icon color (default: .white)
    ///   - isEnabled: Whether the button is interactive (default: true)
    ///   - hapticFeedback: Whether to trigger haptic feedback (default: true)
    ///   - action: Closure executed when FAB is tapped
    public static func extended(
        icon: Image,
        title: String,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        isEnabled: Bool = true,
        hapticFeedback: Bool = true,
        action: @escaping () -> Void
    ) -> DSFloatingActionButton {
        DSFloatingActionButton(
            icon: icon,
            title: title,
            size: .extended,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            isEnabled: isEnabled,
            hapticFeedback: hapticFeedback,
            accessibilityLabel: title,
            action: action
        )
    }
}

// MARK: - FAB Position Modifier

extension View {
    /// Positions a FAB in the standard bottom-right corner location
    /// - Parameters:
    ///   - fab: The FAB view to position
    ///   - padding: Edge padding (default: 16)
    public func floatingActionButton<FAB: View>(
        _ fab: FAB,
        padding: CGFloat = 16
    ) -> some View {
        ZStack(alignment: .bottomTrailing) {
            self
            fab
                .padding(.trailing, padding)
                .padding(.bottom, padding)
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSFloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    // Size variants
                    sectionHeader("Size Variants")
                    HStack(spacing: 24) {
                        VStack {
                            DSFloatingActionButton(
                                systemName: "plus",
                                size: .small,
                                accessibilityLabel: "Add"
                            ) { }
                            Text("Small").font(.caption)
                        }

                        VStack {
                            DSFloatingActionButton(
                                systemName: "plus",
                                size: .regular,
                                accessibilityLabel: "Add"
                            ) { }
                            Text("Regular").font(.caption)
                        }
                    }

                    Divider()

                    // Extended FAB
                    sectionHeader("Extended FAB")
                    VStack(spacing: 16) {
                        DSFloatingActionButton.extended(
                            systemName: "plus",
                            title: "Create"
                        ) { }

                        DSFloatingActionButton.extended(
                            systemName: "square.and.pencil",
                            title: "Compose"
                        ) { }
                    }

                    Divider()

                    // Custom colors
                    sectionHeader("Custom Colors")
                    HStack(spacing: 24) {
                        DSFloatingActionButton(
                            systemName: "heart.fill",
                            backgroundColor: .red,
                            accessibilityLabel: "Like"
                        ) { }

                        DSFloatingActionButton(
                            systemName: "bookmark.fill",
                            backgroundColor: .purple,
                            accessibilityLabel: "Bookmark"
                        ) { }

                        DSFloatingActionButton(
                            systemName: "checkmark",
                            backgroundColor: .green,
                            accessibilityLabel: "Done"
                        ) { }
                    }

                    Divider()

                    // Disabled state
                    sectionHeader("States")
                    HStack(spacing: 24) {
                        VStack {
                            DSFloatingActionButton(
                                systemName: "plus",
                                accessibilityLabel: "Add"
                            ) { }
                            Text("Normal").font(.caption)
                        }

                        VStack {
                            DSFloatingActionButton(
                                systemName: "plus",
                                isEnabled: false,
                                accessibilityLabel: "Add"
                            ) { }
                            Text("Disabled").font(.caption)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("FAB Examples")
        }
        .previewDisplayName("Light Mode")

        // Example of FAB in context
        NavigationView {
            List {
                ForEach(1...10, id: \.self) { index in
                    Text("Item \(index)")
                }
            }
            .navigationTitle("Items")
            .floatingActionButton(
                DSFloatingActionButton(
                    systemName: "plus",
                    accessibilityLabel: "Add item"
                ) { }
            )
        }
        .previewDisplayName("FAB in Context")

        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    DSFloatingActionButton(systemName: "plus", accessibilityLabel: "Add") { }
                    DSFloatingActionButton.extended(systemName: "plus", title: "Create") { }
                }
            }
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }

    static func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#endif

import SwiftUI

/// Size variants for the toggle component.
public enum DSToggleSize: CaseIterable, Sendable {
    case small
    case medium
    case large

    var trackWidth: CGFloat {
        switch self {
        case .small: return 42
        case .medium: return 51
        case .large: return 60
        }
    }

    var trackHeight: CGFloat {
        switch self {
        case .small: return 26
        case .medium: return 31
        case .large: return 36
        }
    }

    var thumbSize: CGFloat {
        switch self {
        case .small: return 22
        case .medium: return 27
        case .large: return 32
        }
    }

    var thumbPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 2
        case .large: return 2
        }
    }

    var font: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .body
        case .large: return .headline
        }
    }
}

/// Position of the label relative to the toggle.
public enum DSToggleLabelPosition: Sendable {
    case leading
    case trailing
}

/// A customizable toggle/switch component for on/off states.
///
/// Example usage:
/// ```swift
/// @State private var isEnabled = false
///
/// DSToggle(isOn: $isEnabled, label: "Push notifications")
///
/// // With custom colors
/// DSToggle(
///     isOn: $isEnabled,
///     label: "Dark mode",
///     onColor: .purple
/// )
/// ```
public struct DSToggle: View {
    // MARK: - Properties

    @Binding private var isOn: Bool
    private let label: String?
    private let size: DSToggleSize
    private let labelPosition: DSToggleLabelPosition
    private let isDisabled: Bool
    private let onColor: Color
    private let offColor: Color
    private let thumbColor: Color
    private let action: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initializers

    /// Creates a toggle with a boolean binding.
    /// - Parameters:
    ///   - isOn: Binding to the on/off state
    ///   - label: Optional text label
    ///   - size: Size variant of the toggle
    ///   - labelPosition: Position of the label relative to the toggle
    ///   - isDisabled: Whether the toggle is disabled
    ///   - onColor: Track color when on
    ///   - offColor: Track color when off
    ///   - thumbColor: Thumb color
    ///   - action: Optional action to perform on state change
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        size: DSToggleSize = .medium,
        labelPosition: DSToggleLabelPosition = .leading,
        isDisabled: Bool = false,
        onColor: Color = DSColors.toggleTrackOn,
        offColor: Color = DSColors.toggleTrackOff,
        thumbColor: Color = DSColors.toggleThumb,
        action: (() -> Void)? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.size = size
        self.labelPosition = labelPosition
        self.isDisabled = isDisabled
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColor = thumbColor
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: toggle) {
            HStack(spacing: DSSpacing.sm) {
                if labelPosition == .leading, let label {
                    labelView(label)
                    Spacer(minLength: DSSpacing.sm)
                }

                toggleView

                if labelPosition == .trailing, let label {
                    Spacer(minLength: DSSpacing.sm)
                    labelView(label)
                }
            }
            .frame(minHeight: DSTouchTarget.minimum)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(isOn ? "on" : "off")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isDisabled ? "Disabled" : "Double tap to toggle")
    }

    // MARK: - Subviews

    private var toggleView: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            // Track
            Capsule()
                .fill(isOn ? onColor : offColor)
                .frame(width: size.trackWidth, height: size.trackHeight)

            // Thumb
            Circle()
                .fill(thumbColor)
                .frame(width: size.thumbSize, height: size.thumbSize)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                .padding(size.thumbPadding)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.font)
            .foregroundColor(isDisabled ? DSColors.textDisabled : DSColors.textPrimary)
            .multilineTextAlignment(labelPosition == .leading ? .leading : .trailing)
    }

    // MARK: - Computed Properties

    private var accessibilityLabel: String {
        if let label {
            return label
        }
        return "Toggle"
    }

    // MARK: - Actions

    private func toggle() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isOn.toggle()
        }
        action?()
    }
}

// MARK: - Preview

#if DEBUG
struct DSToggle_Previews: PreviewProvider {
    static var previews: some View {
        TogglePreviewContainer()
            .previewDisplayName("Toggle States")
    }
}

private struct TogglePreviewContainer: View {
    @State private var toggle1 = false
    @State private var toggle2 = true
    @State private var toggle3 = false
    @State private var toggle4 = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                Group {
                    Text("Basic Toggle")
                        .font(.headline)

                    DSToggle(isOn: $toggle1, label: "Push notifications")
                    DSToggle(isOn: $toggle2, label: "Email notifications")
                }

                Divider()

                Group {
                    Text("Sizes")
                        .font(.headline)

                    DSToggle(isOn: .constant(true), label: "Small", size: .small)
                    DSToggle(isOn: .constant(true), label: "Medium", size: .medium)
                    DSToggle(isOn: .constant(true), label: "Large", size: .large)
                }

                Divider()

                Group {
                    Text("Label Position")
                        .font(.headline)

                    DSToggle(isOn: $toggle3, label: "Leading label", labelPosition: .leading)
                    DSToggle(isOn: $toggle4, label: "Trailing label", labelPosition: .trailing)
                }

                Divider()

                Group {
                    Text("Disabled State")
                        .font(.headline)

                    DSToggle(isOn: .constant(false), label: "Disabled off", isDisabled: true)
                    DSToggle(isOn: .constant(true), label: "Disabled on", isDisabled: true)
                }

                Divider()

                Group {
                    Text("Custom Colors")
                        .font(.headline)

                    DSToggle(
                        isOn: .constant(true),
                        label: "Primary color",
                        onColor: DSColors.primary
                    )
                    DSToggle(
                        isOn: .constant(true),
                        label: "Warning color",
                        onColor: DSColors.warning
                    )
                    DSToggle(
                        isOn: .constant(true),
                        label: "Error color",
                        onColor: DSColors.error
                    )
                    DSToggle(
                        isOn: .constant(true),
                        label: "Info color",
                        onColor: DSColors.info
                    )
                }

                Divider()

                Group {
                    Text("Without Label")
                        .font(.headline)

                    HStack(spacing: DSSpacing.lg) {
                        DSToggle(isOn: .constant(false), size: .small)
                        DSToggle(isOn: .constant(true), size: .small)
                        DSToggle(isOn: .constant(false), size: .medium)
                        DSToggle(isOn: .constant(true), size: .medium)
                    }
                }
            }
            .padding()
        }
    }
}
#endif

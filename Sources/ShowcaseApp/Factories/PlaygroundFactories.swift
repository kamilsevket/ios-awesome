import SwiftUI

// MARK: - Playground Preview Factory

/// Factory for creating playground component previews
public enum PlaygroundPreviewFactory {

    @ViewBuilder
    public static func preview(for component: PlaygroundComponent, state: PlaygroundState) -> some View {
        switch component {
        case .button:
            ButtonPlaygroundPreview(state: state)
        case .card:
            CardPlaygroundPreview(state: state)
        case .avatar:
            AvatarPlaygroundPreview(state: state)
        case .badge:
            BadgePlaygroundPreview(state: state)
        case .textField:
            TextFieldPlaygroundPreview(state: state)
        case .toggle:
            TogglePlaygroundPreview(state: state)
        case .slider:
            SliderPlaygroundPreview(state: state)
        case .alert:
            AlertPlaygroundPreview(state: state)
        }
    }
}

// MARK: - Playground Controls Factory

/// Factory for creating playground controls
public enum PlaygroundControlsFactory {

    @ViewBuilder
    public static func controls(for component: PlaygroundComponent, state: Binding<PlaygroundState>) -> some View {
        switch component {
        case .button:
            ButtonPlaygroundControls(state: state)
        case .card:
            CardPlaygroundControls(state: state)
        case .avatar:
            AvatarPlaygroundControls(state: state)
        case .badge:
            BadgePlaygroundControls(state: state)
        case .textField:
            TextFieldPlaygroundControls(state: state)
        case .toggle:
            TogglePlaygroundControls(state: state)
        case .slider:
            SliderPlaygroundControls(state: state)
        case .alert:
            AlertPlaygroundControls(state: state)
        }
    }
}

// MARK: - Button Playground

struct ButtonPlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        Button {} label: {
            HStack {
                if state.buttonIsLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(state.buttonStyle == "primary" ? .white : .accentColor)
                }
                Text(state.buttonText)
            }
            .frame(maxWidth: state.buttonIsFullWidth ? .infinity : nil)
        }
        .buttonStyle(buttonStyle)
        .controlSize(controlSize)
        .disabled(!state.buttonIsEnabled || state.buttonIsLoading)
    }

    private var buttonStyle: some PrimitiveButtonStyle {
        switch state.buttonStyle {
        case "secondary": return AnyPrimitiveButtonStyle(.bordered)
        case "tertiary": return AnyPrimitiveButtonStyle(.borderless)
        default: return AnyPrimitiveButtonStyle(.borderedProminent)
        }
    }

    private var controlSize: ControlSize {
        switch state.buttonSize {
        case "small": return .small
        case "large": return .large
        default: return .regular
        }
    }
}

struct AnyPrimitiveButtonStyle: PrimitiveButtonStyle {
    private let _makeBody: (Configuration) -> AnyView

    init<S: PrimitiveButtonStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

struct ButtonPlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Text") {
                TextField("Button text", text: $state.buttonText)
                    .textFieldStyle(.roundedBorder)
            }

            ControlSection(title: "Style") {
                Picker("Style", selection: $state.buttonStyle) {
                    Text("Primary").tag("primary")
                    Text("Secondary").tag("secondary")
                    Text("Tertiary").tag("tertiary")
                }
                .pickerStyle(.segmented)
            }

            ControlSection(title: "Size") {
                Picker("Size", selection: $state.buttonSize) {
                    Text("Small").tag("small")
                    Text("Medium").tag("medium")
                    Text("Large").tag("large")
                }
                .pickerStyle(.segmented)
            }

            ControlSection(title: "Options") {
                Toggle("Loading", isOn: $state.buttonIsLoading)
                Toggle("Enabled", isOn: $state.buttonIsEnabled)
                Toggle("Full Width", isOn: $state.buttonIsFullWidth)
            }
        }
    }
}

// MARK: - Card Playground

struct CardPlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if state.cardHasImage {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 60)
            }

            Text("Card Title")
                .font(.headline)

            Text("Card description text")
                .font(.caption)
                .foregroundColor(.secondary)

            if state.cardIsInteractive {
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(12)
        .overlay(cardOverlay)
        .shadow(color: state.cardStyle == "elevated" ? .black.opacity(0.1) : .clear, radius: 4, y: 2)
        .frame(width: 200)
    }

    private var cardBackground: Color {
        switch state.cardStyle {
        case "filled": return Color(.systemGray5)
        default: return Color(.systemBackground)
        }
    }

    @ViewBuilder
    private var cardOverlay: some View {
        if state.cardStyle == "outlined" {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        }
    }
}

struct CardPlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Style") {
                Picker("Style", selection: $state.cardStyle) {
                    Text("Flat").tag("flat")
                    Text("Outlined").tag("outlined")
                    Text("Elevated").tag("elevated")
                    Text("Filled").tag("filled")
                }
                .pickerStyle(.segmented)
            }

            ControlSection(title: "Options") {
                Toggle("Has Image", isOn: $state.cardHasImage)
                Toggle("Interactive", isOn: $state.cardIsInteractive)
            }
        }
    }
}

// MARK: - Avatar Playground

struct AvatarPlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.accentColor)
                .frame(width: avatarSize, height: avatarSize)
                .overlay(
                    Text("JD")
                        .font(.system(size: avatarSize * 0.35).weight(.medium))
                        .foregroundColor(.white)
                )

            if state.avatarShowStatus {
                Circle()
                    .fill(statusColor)
                    .frame(width: avatarSize * 0.3, height: avatarSize * 0.3)
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
            }
        }
    }

    private var avatarSize: CGFloat {
        switch state.avatarSize {
        case "small": return 32
        case "large": return 64
        default: return 48
        }
    }

    private var statusColor: Color {
        switch state.avatarStatus {
        case "offline": return .gray
        case "busy": return .red
        case "away": return .orange
        default: return .green
        }
    }
}

struct AvatarPlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Size") {
                Picker("Size", selection: $state.avatarSize) {
                    Text("Small").tag("small")
                    Text("Medium").tag("medium")
                    Text("Large").tag("large")
                }
                .pickerStyle(.segmented)
            }

            ControlSection(title: "Status") {
                Toggle("Show Status", isOn: $state.avatarShowStatus)

                if state.avatarShowStatus {
                    Picker("Status", selection: $state.avatarStatus) {
                        Text("Online").tag("online")
                        Text("Offline").tag("offline")
                        Text("Busy").tag("busy")
                        Text("Away").tag("away")
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}

// MARK: - Badge Playground

struct BadgePlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        Text(state.badgeText)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(badgeColor)
            .foregroundColor(.white)
            .cornerRadius(state.badgeStyle.contains("pill") ? 12 : 4)
    }

    private var badgeColor: Color {
        if state.badgeStyle.contains("success") { return .green }
        if state.badgeStyle.contains("warning") { return .orange }
        if state.badgeStyle.contains("error") { return .red }
        return .accentColor
    }
}

struct BadgePlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Text") {
                TextField("Badge text", text: $state.badgeText)
                    .textFieldStyle(.roundedBorder)
            }

            ControlSection(title: "Style") {
                Picker("Style", selection: $state.badgeStyle) {
                    Text("Primary").tag("primary")
                    Text("Success").tag("success")
                    Text("Warning").tag("warning")
                    Text("Error").tag("error")
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

// MARK: - TextField Playground

struct TextFieldPlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if state.textFieldIsSecure {
                SecureField(state.textFieldPlaceholder, text: $state.textFieldText)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextField(state.textFieldPlaceholder, text: $state.textFieldText)
                    .textFieldStyle(.roundedBorder)
            }

            if state.textFieldHasError {
                Text("This field has an error")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .frame(width: 250)
    }
}

struct TextFieldPlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Placeholder") {
                TextField("Placeholder text", text: $state.textFieldPlaceholder)
                    .textFieldStyle(.roundedBorder)
            }

            ControlSection(title: "Options") {
                Toggle("Secure Entry", isOn: $state.textFieldIsSecure)
                Toggle("Show Error", isOn: $state.textFieldHasError)
            }
        }
    }
}

// MARK: - Toggle Playground

struct TogglePlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        Toggle(state.toggleLabel, isOn: $state.toggleIsOn)
            .frame(width: 200)
    }
}

struct TogglePlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Label") {
                TextField("Toggle label", text: $state.toggleLabel)
                    .textFieldStyle(.roundedBorder)
            }

            ControlSection(title: "State") {
                Toggle("Is On", isOn: $state.toggleIsOn)
            }
        }
    }
}

// MARK: - Slider Playground

struct SliderPlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        VStack {
            Slider(value: $state.sliderValue, in: state.sliderMin...state.sliderMax)
                .frame(width: 200)

            Text("\(Int(state.sliderValue))")
                .font(.headline)
                .foregroundColor(.accentColor)
        }
    }
}

struct SliderPlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Value") {
                HStack {
                    Text("\(Int(state.sliderValue))")
                        .font(.headline)
                        .frame(width: 40)

                    Slider(value: $state.sliderValue, in: state.sliderMin...state.sliderMax)
                }
            }

            ControlSection(title: "Range") {
                HStack {
                    Text("Min")
                    Slider(value: $state.sliderMin, in: 0...50)
                    Text("\(Int(state.sliderMin))")
                        .frame(width: 30)
                }

                HStack {
                    Text("Max")
                    Slider(value: $state.sliderMax, in: 50...200)
                    Text("\(Int(state.sliderMax))")
                        .frame(width: 30)
                }
            }
        }
    }
}

// MARK: - Alert Playground

struct AlertPlaygroundPreview: View {
    @ObservedObject var state: PlaygroundState

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: alertIcon)
                .foregroundColor(alertColor)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(state.alertTitle)
                    .font(.subheadline.weight(.semibold))
                Text(state.alertMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(alertColor.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: 280)
    }

    private var alertIcon: String {
        switch state.alertStyle {
        case "success": return "checkmark.circle.fill"
        case "warning": return "exclamationmark.triangle.fill"
        case "error": return "xmark.circle.fill"
        default: return "info.circle.fill"
        }
    }

    private var alertColor: Color {
        switch state.alertStyle {
        case "success": return .green
        case "warning": return .orange
        case "error": return .red
        default: return .blue
        }
    }
}

struct AlertPlaygroundControls: View {
    @Binding var state: PlaygroundState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ControlSection(title: "Title") {
                TextField("Alert title", text: $state.alertTitle)
                    .textFieldStyle(.roundedBorder)
            }

            ControlSection(title: "Message") {
                TextField("Alert message", text: $state.alertMessage)
                    .textFieldStyle(.roundedBorder)
            }

            ControlSection(title: "Style") {
                Picker("Style", selection: $state.alertStyle) {
                    Text("Info").tag("info")
                    Text("Success").tag("success")
                    Text("Warning").tag("warning")
                    Text("Error").tag("error")
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

// MARK: - Control Section

struct ControlSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)

            content()
        }
    }
}

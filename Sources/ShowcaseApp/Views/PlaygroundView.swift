import SwiftUI

/// Interactive playground for experimenting with components
public struct PlaygroundView: View {
    @State private var selectedComponent: PlaygroundComponent = .button
    @State private var playgroundState = PlaygroundState()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Component selector
                componentPicker

                Divider()

                // Preview area
                previewArea

                Divider()

                // Controls area
                controlsArea
            }
            .navigationTitle("Playground")
        }
    }

    private var componentPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(PlaygroundComponent.allCases, id: \.self) { component in
                    PlaygroundChip(
                        title: component.rawValue,
                        isSelected: selectedComponent == component
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedComponent = component
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }

    private var previewArea: some View {
        VStack {
            Spacer()

            PlaygroundPreviewFactory.preview(
                for: selectedComponent,
                state: playgroundState
            )

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color(.secondarySystemBackground))
    }

    private var controlsArea: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PlaygroundControlsFactory.controls(
                    for: selectedComponent,
                    state: $playgroundState
                )
            }
            .padding()
        }
    }
}

/// Chip button for selecting playground component
struct PlaygroundChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

/// Components available in the playground
enum PlaygroundComponent: String, CaseIterable {
    case button = "Button"
    case card = "Card"
    case avatar = "Avatar"
    case badge = "Badge"
    case textField = "TextField"
    case toggle = "Toggle"
    case slider = "Slider"
    case alert = "Alert"
}

/// State for playground controls
class PlaygroundState: ObservableObject {
    // Button properties
    @Published var buttonStyle: String = "primary"
    @Published var buttonSize: String = "medium"
    @Published var buttonText: String = "Button"
    @Published var buttonIsLoading: Bool = false
    @Published var buttonIsEnabled: Bool = true
    @Published var buttonIsFullWidth: Bool = false

    // Card properties
    @Published var cardStyle: String = "elevated"
    @Published var cardHasImage: Bool = true
    @Published var cardIsInteractive: Bool = false

    // Avatar properties
    @Published var avatarSize: String = "medium"
    @Published var avatarShowStatus: Bool = false
    @Published var avatarStatus: String = "online"

    // Badge properties
    @Published var badgeText: String = "New"
    @Published var badgeStyle: String = "primary"

    // TextField properties
    @Published var textFieldText: String = ""
    @Published var textFieldPlaceholder: String = "Enter text..."
    @Published var textFieldIsSecure: Bool = false
    @Published var textFieldHasError: Bool = false

    // Toggle properties
    @Published var toggleIsOn: Bool = false
    @Published var toggleLabel: String = "Enable feature"

    // Slider properties
    @Published var sliderValue: Double = 50
    @Published var sliderMin: Double = 0
    @Published var sliderMax: Double = 100

    // Alert properties
    @Published var alertTitle: String = "Alert Title"
    @Published var alertMessage: String = "This is an alert message."
    @Published var alertStyle: String = "info"
}

#if DEBUG
struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}
#endif

import SwiftUI

/// Factory for creating component variant displays
public enum ComponentVariantsFactory {

    @ViewBuilder
    public static func variants(for component: ComponentInfo) -> some View {
        switch component.name {
        case "Button":
            ButtonVariants()
        case "Card":
            CardVariants()
        case "Avatar":
            AvatarVariants()
        case "Badge":
            BadgeVariants()
        case "TextField":
            TextFieldVariants()
        case "Alert":
            AlertVariants()
        case "Toggle":
            ToggleVariants()
        case "Slider":
            SliderVariants()
        case "Progress":
            ProgressVariants()
        default:
            DefaultVariants(componentName: component.name)
        }
    }
}

// MARK: - Default Variants

struct DefaultVariants: View {
    let componentName: String

    var body: some View {
        VStack(spacing: 12) {
            VariantCard(title: "Default", description: "Standard appearance") {
                Text("Default variant")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Variant Card

struct VariantCard<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            content()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
        }
    }
}

// MARK: - Button Variants

struct ButtonVariants: View {
    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Styles", description: "Primary, Secondary, and Tertiary styles") {
                HStack(spacing: 12) {
                    Button("Primary") {}
                        .buttonStyle(.borderedProminent)

                    Button("Secondary") {}
                        .buttonStyle(.bordered)

                    Button("Tertiary") {}
                }
            }

            VariantCard(title: "Sizes", description: "Small, Medium, and Large sizes") {
                VStack(spacing: 8) {
                    Button("Small") {}
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)

                    Button("Medium") {}
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)

                    Button("Large") {}
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                }
            }

            VariantCard(title: "With Icons", description: "Leading and trailing icon positions") {
                HStack(spacing: 12) {
                    Button {} label: {
                        Label("Add", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)

                    Button {} label: {
                        HStack {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }

            VariantCard(title: "States", description: "Loading and Disabled states") {
                HStack(spacing: 12) {
                    Button {} label: {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Loading")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(true)

                    Button("Disabled") {}
                        .buttonStyle(.borderedProminent)
                        .disabled(true)
                }
            }
        }
    }
}

// MARK: - Card Variants

struct CardVariants: View {
    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Flat", description: "No shadow, minimal styling") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Flat Card")
                        .font(.headline)
                    Text("Simple content without elevation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(12)
            }

            VariantCard(title: "Elevated", description: "With shadow for depth") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Elevated Card")
                        .font(.headline)
                    Text("Raised appearance with shadow")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }

            VariantCard(title: "Outlined", description: "With border") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Outlined Card")
                        .font(.headline)
                    Text("Border defines the boundary")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 1)
                )
            }

            VariantCard(title: "Interactive", description: "Tappable with hover state") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Interactive Card")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    Text("Tap to navigate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }
        }
    }
}

// MARK: - Avatar Variants

struct AvatarVariants: View {
    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Sizes", description: "Extra small to extra large") {
                HStack(spacing: 16) {
                    ForEach([24, 32, 44, 56, 72], id: \.self) { size in
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(size), height: CGFloat(size))
                            .overlay(
                                Text(size == 24 ? "XS" : size == 32 ? "S" : size == 44 ? "M" : size == 56 ? "L" : "XL")
                                    .font(.system(size: CGFloat(size) * 0.35))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }

            VariantCard(title: "Content Types", description: "Image, Initials, and Icon") {
                HStack(spacing: 16) {
                    // Image avatar
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .overlay(Image(systemName: "photo").foregroundColor(.gray))

                    // Initials avatar
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 44, height: 44)
                        .overlay(Text("JD").foregroundColor(.white).font(.subheadline.weight(.medium)))

                    // Icon avatar
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 44, height: 44)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                }
            }

            VariantCard(title: "With Status", description: "Online, Offline, Busy, Away") {
                HStack(spacing: 16) {
                    ForEach([("Online", Color.green), ("Offline", Color.gray), ("Busy", Color.red), ("Away", Color.orange)], id: \.0) { status, color in
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 44, height: 44)

                            Circle()
                                .fill(color)
                                .frame(width: 14, height: 14)
                                .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                        }
                    }
                }
            }

            VariantCard(title: "Avatar Group", description: "Stacked avatars") {
                HStack(spacing: -12) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill([Color.blue, Color.green, Color.orange, Color.purple][index])
                            .frame(width: 36, height: 36)
                            .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                    }

                    Circle()
                        .fill(Color(.systemGray4))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("+3")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.primary)
                        )
                        .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                }
            }
        }
    }
}

// MARK: - Badge Variants

struct BadgeVariants: View {
    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Semantic Colors", description: "Primary, Success, Warning, Error") {
                HStack(spacing: 12) {
                    ForEach([("Primary", Color.accentColor), ("Success", Color.green), ("Warning", Color.orange), ("Error", Color.red)], id: \.0) { label, color in
                        Text(label)
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
            }

            VariantCard(title: "Shapes", description: "Rounded and Pill shapes") {
                HStack(spacing: 12) {
                    Text("Rounded")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(4)

                    Text("Pill")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            VariantCard(title: "Notification Badges", description: "Count badges") {
                HStack(spacing: 20) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.title2)
                        Text("3")
                            .font(.caption2.weight(.bold))
                            .frame(width: 18, height: 18)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .offset(x: 6, y: -6)
                    }

                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "envelope.fill")
                            .font(.title2)
                        Text("99+")
                            .font(.system(size: 10).weight(.bold))
                            .padding(.horizontal, 4)
                            .frame(height: 16)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .offset(x: 8, y: -6)
                    }
                }
            }
        }
    }
}

// MARK: - TextField Variants

struct TextFieldVariants: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var text4 = "Some text"

    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Standard", description: "Basic text field") {
                TextField("Enter text...", text: $text1)
                    .textFieldStyle(.roundedBorder)
            }

            VariantCard(title: "With Label", description: "Floating label style") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("email@example.com", text: $text2)
                        .textFieldStyle(.roundedBorder)
                }
            }

            VariantCard(title: "Secure", description: "Password input") {
                SecureField("Password", text: $text3)
                    .textFieldStyle(.roundedBorder)
            }

            VariantCard(title: "With Validation", description: "Error state") {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Username", text: $text4)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    Text("Username already taken")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Alert Variants

struct AlertVariants: View {
    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Info", description: "Informational message") {
                AlertRow(icon: "info.circle.fill", title: "Information", message: "This is an info message.", color: .blue)
            }

            VariantCard(title: "Success", description: "Success message") {
                AlertRow(icon: "checkmark.circle.fill", title: "Success", message: "Operation completed successfully.", color: .green)
            }

            VariantCard(title: "Warning", description: "Warning message") {
                AlertRow(icon: "exclamationmark.triangle.fill", title: "Warning", message: "Please review before continuing.", color: .orange)
            }

            VariantCard(title: "Error", description: "Error message") {
                AlertRow(icon: "xmark.circle.fill", title: "Error", message: "Something went wrong.", color: .red)
            }
        }
    }
}

struct AlertRow: View {
    let icon: String
    let title: String
    let message: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Toggle Variants

struct ToggleVariants: View {
    @State private var toggle1 = true
    @State private var toggle2 = false
    @State private var toggle3 = true

    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Standard", description: "Basic toggle switch") {
                Toggle("Enable notifications", isOn: $toggle1)
            }

            VariantCard(title: "With Description", description: "Toggle with helper text") {
                VStack(alignment: .leading, spacing: 4) {
                    Toggle("Dark Mode", isOn: $toggle2)
                    Text("Use dark theme throughout the app")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            VariantCard(title: "Custom Tint", description: "Colored toggle") {
                Toggle("Premium Feature", isOn: $toggle3)
                    .tint(.purple)
            }
        }
    }
}

// MARK: - Slider Variants

struct SliderVariants: View {
    @State private var value1: Double = 50
    @State private var value2: Double = 75
    @State private var value3: Double = 30

    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Standard", description: "Basic slider") {
                VStack {
                    Slider(value: $value1, in: 0...100)
                    Text("\(Int(value1))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            VariantCard(title: "With Labels", description: "Min/Max labels") {
                VStack {
                    Slider(value: $value2, in: 0...100) {
                        Text("Volume")
                    } minimumValueLabel: {
                        Image(systemName: "speaker.fill")
                    } maximumValueLabel: {
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }
            }

            VariantCard(title: "Stepped", description: "Discrete values") {
                VStack {
                    Slider(value: $value3, in: 0...100, step: 10)
                    Text("Step: \(Int(value3))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Progress Variants

struct ProgressVariants: View {
    var body: some View {
        VStack(spacing: 16) {
            VariantCard(title: "Linear", description: "Horizontal progress bar") {
                VStack(spacing: 8) {
                    ProgressView(value: 0.7)
                    ProgressView(value: 0.4)
                        .tint(.green)
                    ProgressView(value: 0.9)
                        .tint(.orange)
                }
            }

            VariantCard(title: "Circular", description: "Spinning indicator") {
                HStack(spacing: 24) {
                    ProgressView()
                    ProgressView()
                        .scaleEffect(1.5)
                    ProgressView()
                        .tint(.purple)
                }
            }

            VariantCard(title: "With Label", description: "Progress with percentage") {
                VStack(spacing: 8) {
                    ProgressView(value: 0.65) {
                        Text("Downloading...")
                    } currentValueLabel: {
                        Text("65%")
                    }
                }
            }
        }
    }
}

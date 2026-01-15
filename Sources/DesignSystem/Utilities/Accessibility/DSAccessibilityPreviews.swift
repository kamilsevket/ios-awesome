import SwiftUI

// MARK: - Accessibility Previews

#if DEBUG

// MARK: - DSAccessibility Modifier Previews

struct DSAccessibilityModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Basic accessibility modifier
            Text("Save Document")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .dsAccessibility(
                    label: "Save button",
                    hint: "Saves your current document",
                    traits: .isButton
                )

            // Button accessibility shorthand
            Image(systemName: "heart.fill")
                .font(.title)
                .foregroundColor(.red)
                .dsButtonAccessibility(
                    label: "Like",
                    hint: "Adds this item to your favorites"
                )

            // Header accessibility
            Text("Settings")
                .font(.title)
                .dsHeaderAccessibility(label: "Settings section")

            // Accessibility group
            HStack {
                Image(systemName: "person.circle")
                VStack(alignment: .leading) {
                    Text("John Doe")
                    Text("john@example.com")
                        .foregroundColor(.secondary)
                }
            }
            .dsAccessibilityGroup()

            // Hidden from accessibility
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .dsAccessibilityHidden()
        }
        .padding()
        .previewDisplayName("DSAccessibility Modifier")
    }
}

// MARK: - Announce Previews

struct DSAnnounce_Previews: PreviewProvider {
    static var previews: some View {
        AnnounceDemoView()
            .previewDisplayName("DSAnnounce")
    }

    struct AnnounceDemoView: View {
        @State private var itemCount = 0
        @State private var isLoading = false

        var body: some View {
            VStack(spacing: 20) {
                Text("Announce Demo")
                    .font(.headline)

                Button("Add Item") {
                    itemCount += 1
                    dsAnnounce("Item added. Total: \(itemCount)")
                }
                .buttonStyle(.borderedProminent)

                Button("Toggle Loading") {
                    isLoading.toggle()
                    DSAnnouncer.shared.announceLoading(isLoading)
                }
                .buttonStyle(.bordered)

                Text("Items: \(itemCount)")
                    .dsAnnounce(
                        { count in "You have \(count) items" },
                        when: itemCount
                    )
            }
            .padding()
        }
    }
}

// MARK: - Dynamic Type Previews

struct DSDynamicType_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard size
            DynamicTypeDemoView()
                .previewDisplayName("Standard")

            // Large size
            DynamicTypeDemoView()
                .environment(\.sizeCategory, .accessibilityLarge)
                .previewDisplayName("Accessibility Large")

            // Extra Extra Large
            DynamicTypeDemoView()
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                .previewDisplayName("Accessibility XXXL")
        }
    }

    struct DynamicTypeDemoView: View {
        @Environment(\.sizeCategory) var sizeCategory

        var body: some View {
            VStack(spacing: 16) {
                Text("Dynamic Type Support")
                    .font(.headline)

                Text("Current size: \(String(describing: sizeCategory))")
                    .font(.caption)

                Text("This text scales with Dynamic Type")
                    .dsDynamicTypeStandard()

                Text("This text has limited scaling")
                    .dsDynamicTypeCompact()

                DSDynamicTypeContainer { isAccessibilitySize in
                    if isAccessibilitySize {
                        VStack(alignment: .leading) {
                            Text("Layout adapted for accessibility")
                            Text("Items stack vertically")
                        }
                    } else {
                        HStack {
                            Text("Standard layout")
                            Spacer()
                            Text("Side by side")
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

// MARK: - Reduce Motion Previews

struct DSReduceMotion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard animations
            ReduceMotionDemoView()
                .previewDisplayName("Standard Motion")

            // Reduce motion enabled
            ReduceMotionDemoView()
                .environment(\.accessibilityReduceMotion, true)
                .previewDisplayName("Reduce Motion Enabled")
        }
    }

    struct ReduceMotionDemoView: View {
        @State private var isExpanded = false
        @Environment(\.accessibilityReduceMotion) var reduceMotion

        var body: some View {
            VStack(spacing: 20) {
                Text("Reduce Motion: \(reduceMotion ? "ON" : "OFF")")
                    .font(.headline)

                Button("Toggle Animation") {
                    isExpanded.toggle()
                }
                .buttonStyle(.borderedProminent)

                Rectangle()
                    .fill(Color.blue)
                    .frame(width: isExpanded ? 200 : 100, height: 50)
                    .dsReduceMotionAnimation(
                        .spring(response: 0.5, dampingFraction: 0.6),
                        value: isExpanded
                    )

                DSMotionSafeView {
                    Text("Animated Content")
                        .scaleEffect(isExpanded ? 1.2 : 1.0)
                        .animation(.spring(), value: isExpanded)
                } reducedContent: {
                    Text("Static Content")
                }
            }
            .padding()
        }
    }
}

// MARK: - High Contrast Previews

struct DSHighContrast_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard contrast
            HighContrastDemoView()
                .previewDisplayName("Standard Contrast")

            // Increased contrast
            HighContrastDemoView()
                .environment(\.colorSchemeContrast, .increased)
                .previewDisplayName("Increased Contrast")

            // Differentiate without color
            HighContrastDemoView()
                .environment(\.accessibilityDifferentiateWithoutColor, true)
                .previewDisplayName("Differentiate Without Color")
        }
    }

    struct HighContrastDemoView: View {
        @Environment(\.colorSchemeContrast) var contrast
        @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

        var body: some View {
            VStack(spacing: 20) {
                Text("High Contrast Demo")
                    .font(.headline)

                Text("Contrast: \(contrast == .increased ? "Increased" : "Standard")")
                Text("Differentiate: \(differentiateWithoutColor ? "ON" : "OFF")")

                HStack(spacing: 12) {
                    DSAccessibilityIndicator(
                        color: .red,
                        pattern: .crosshatch,
                        icon: "xmark"
                    )
                    .frame(width: 24, height: 24)

                    DSAccessibilityIndicator(
                        color: .green,
                        pattern: .dots,
                        icon: "checkmark"
                    )
                    .frame(width: 24, height: 24)

                    DSAccessibilityIndicator(
                        color: .blue,
                        pattern: .lines,
                        icon: "info"
                    )
                    .frame(width: 24, height: 24)
                }

                Text("Status indicator")
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .dsDifferentiateWithoutColorBorder()
            }
            .padding()
        }
    }
}

// MARK: - Focus Management Previews

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct DSFocusManagement_Previews: PreviewProvider {
    static var previews: some View {
        FocusManagementDemoView()
            .previewDisplayName("Focus Management")
    }

    struct FocusManagementDemoView: View {
        enum FocusedField: Hashable {
            case firstName
            case lastName
            case email
        }

        @AccessibilityFocusState private var focusedField: FocusedField?
        @State private var firstName = ""
        @State private var lastName = ""
        @State private var email = ""

        var body: some View {
            VStack(spacing: 20) {
                Text("Focus Management Demo")
                    .font(.headline)
                    .dsFocusOrder(.critical)

                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityFocused($focusedField, equals: .firstName)
                    .dsFocusRing(focusedField == .firstName)
                    .dsFocusOrder(.high)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityFocused($focusedField, equals: .lastName)
                    .dsFocusRing(focusedField == .lastName)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityFocused($focusedField, equals: .email)
                    .dsFocusRing(focusedField == .email)
                    .dsFocusOrder(.low)

                HStack {
                    Button("Focus First") {
                        focusedField = .firstName
                    }

                    Button("Focus Email") {
                        focusedField = .email
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

// MARK: - Combined Demo Preview

struct DSAccessibility_AllPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section("Accessibility Modifier") {
                    Text("See DSAccessibilityModifier_Previews")
                }

                Section("Announcements") {
                    Text("See DSAnnounce_Previews")
                }

                Section("Dynamic Type") {
                    Text("See DSDynamicType_Previews")
                }

                Section("Reduce Motion") {
                    Text("See DSReduceMotion_Previews")
                }

                Section("High Contrast") {
                    Text("See DSHighContrast_Previews")
                }

                Section("Focus Management") {
                    Text("See DSFocusManagement_Previews")
                }
            }
            .navigationTitle("Accessibility Utilities")
        }
        .previewDisplayName("All Accessibility Features")
    }
}

#endif

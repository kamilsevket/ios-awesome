import SwiftUI

#if DEBUG

// MARK: - DSTextField Previews

struct DSTextField_Previews: PreviewProvider {
    static var previews: some View {
        DSTextFieldPreviewContainer()
            .previewDisplayName("DSTextField")
    }
}

private struct DSTextFieldPreviewContainer: View {
    @State private var standardText = ""
    @State private var outlinedText = ""
    @State private var emailText = ""
    @State private var errorText = "invalid"
    @State private var disabledText = "Disabled"
    @State private var iconText = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GroupBox("Standard Style") {
                    DSTextField("Username", text: $standardText)
                        .style(.standard)
                        .helperText("Enter your username")
                }

                GroupBox("Outlined Style") {
                    DSTextField("Email", text: $outlinedText)
                        .style(.outlined)
                        .validation(.email)
                        .helperText("We'll never share your email")
                        .showsClearButton(true)
                }

                GroupBox("With Icons") {
                    DSTextField("Email Address", text: $iconText)
                        .style(.outlined)
                        .leadingIcon(Image(systemName: "envelope"))
                        .validation(.email)
                }

                GroupBox("With Character Counter") {
                    DSTextField("Bio", text: $emailText)
                        .style(.outlined)
                        .maxCharacters(50)
                        .helperText("Tell us about yourself")
                }

                GroupBox("Disabled State") {
                    DSTextField("Username", text: $disabledText)
                        .style(.outlined)
                        .disabled(true)
                }
            }
            .padding()
        }
    }
}

// MARK: - DSSecureTextField Previews

struct DSSecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        DSSecureTextFieldPreviewContainer()
            .previewDisplayName("DSSecureTextField")
    }
}

private struct DSSecureTextFieldPreviewContainer: View {
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GroupBox("Password Field") {
                    DSSecureTextField("Password", text: $password)
                        .style(.outlined)
                        .validation(.password)
                        .helperText("Min 8 characters with uppercase, lowercase, and number")
                        .showStrengthIndicator(true)
                }

                GroupBox("Confirm Password") {
                    DSSecureTextField("Confirm Password", text: $confirmPassword)
                        .style(.outlined)
                        .helperText("Re-enter your password")
                }
            }
            .padding()
        }
    }
}

// MARK: - DSSearchTextField Previews

struct DSSearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        DSSearchTextFieldPreviewContainer()
            .previewDisplayName("DSSearchTextField")
    }
}

private struct DSSearchTextFieldPreviewContainer: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 24) {
            GroupBox("Search Field") {
                DSSearchTextField(text: $searchText)
                    .placeholder("Search products...")
            }
        }
        .padding()
    }
}

// MARK: - DSMultilineTextField Previews

struct DSMultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        DSMultilineTextFieldPreviewContainer()
            .previewDisplayName("DSMultilineTextField")
    }
}

private struct DSMultilineTextFieldPreviewContainer: View {
    @State private var description = ""
    @State private var notes = "Some existing notes..."

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GroupBox("Description") {
                    DSMultilineTextField("Description", text: $description)
                        .style(.outlined)
                        .placeholder("Enter a detailed description...")
                        .maxCharacters(500)
                        .minHeight(100)
                }

                GroupBox("Notes") {
                    DSMultilineTextField("Notes", text: $notes)
                        .style(.outlined)
                        .helperText("Optional notes")
                        .minHeight(80)
                        .maxHeight(150)
                }
            }
            .padding()
        }
    }
}

// MARK: - All Styles Preview

struct DSTextField_AllStyles_Previews: PreviewProvider {
    static var previews: some View {
        AllStylesPreviewContainer()
            .previewDisplayName("All Styles")
    }
}

private struct AllStylesPreviewContainer: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""

    var body: some View {
        VStack(spacing: 32) {
            DSTextField("Standard", text: $text1)
                .style(.standard)

            DSTextField("Outlined", text: $text2)
                .style(.outlined)

            DSSearchTextField(text: $text3)
                .placeholder("Search...")
        }
        .padding()
    }
}

// MARK: - Dark Mode Previews

struct DSTextField_DarkMode_Previews: PreviewProvider {
    static var previews: some View {
        DarkModePreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DarkModePreviewContainer: View {
    @State private var email = ""
    @State private var password = ""
    @State private var search = ""

    var body: some View {
        VStack(spacing: 24) {
            DSTextField("Email", text: $email)
                .style(.outlined)
                .validation(.email)

            DSSecureTextField("Password", text: $password)
                .style(.outlined)
                .showStrengthIndicator(true)

            DSSearchTextField(text: $search)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Validation States Preview

struct DSTextField_ValidationStates_Previews: PreviewProvider {
    static var previews: some View {
        ValidationStatesPreviewContainer()
            .previewDisplayName("Validation States")
    }
}

private struct ValidationStatesPreviewContainer: View {
    @State private var defaultText = ""
    @State private var successText = "valid@email.com"
    @State private var errorText = "invalid"

    var body: some View {
        VStack(spacing: 24) {
            GroupBox("Default") {
                DSTextField("Email", text: $defaultText)
                    .style(.outlined)
                    .validation(.email)
            }

            GroupBox("Success (blur to validate)") {
                DSTextField("Email", text: $successText)
                    .style(.outlined)
                    .validation(.email)
            }

            GroupBox("Error (blur to validate)") {
                DSTextField("Email", text: $errorText)
                    .style(.outlined)
                    .validation(.email)
                    .errorMessage("Please enter a valid email address")
            }
        }
        .padding()
    }
}

#endif

# TextField Components

DesignSystem provides a comprehensive text input component with built-in validation, states, and accessibility.

## DSTextField

A customizable text field with support for various input types, validation, and styling.

### Basic Usage

```swift
import DesignSystem

@State private var text = ""

// Simple text field
DSTextField("Username", text: $text)

// With placeholder
DSTextField(
    "Email",
    text: $email,
    placeholder: "Enter your email"
)
```

### Input Types

DSTextField supports various input types that automatically configure the keyboard and validation:

```swift
// Plain text (default)
DSTextField("Name", text: $name, type: .text)

// Email with email keyboard
DSTextField("Email", text: $email, type: .email)

// Password with secure entry
DSTextField("Password", text: $password, type: .password)

// Phone with phone keyboard
DSTextField("Phone", text: $phone, type: .phone)

// Number with numeric keyboard
DSTextField("Amount", text: $amount, type: .number)

// URL with URL keyboard
DSTextField("Website", text: $website, type: .url)

// Search with search keyboard
DSTextField("Search", text: $query, type: .search)
```

### Validation

```swift
// Required field
DSTextField(
    "Name",
    text: $name,
    isRequired: true
)

// With validation rules
DSTextField(
    "Email",
    text: $email,
    type: .email,
    validation: .email
)

// Custom validation
DSTextField(
    "Username",
    text: $username,
    validation: .custom { value in
        if value.count < 3 {
            return .invalid("Username must be at least 3 characters")
        }
        if value.contains(" ") {
            return .invalid("Username cannot contain spaces")
        }
        return .valid
    }
)

// Multiple validations
DSTextField(
    "Password",
    text: $password,
    type: .password,
    validations: [
        .minLength(8),
        .containsUppercase,
        .containsNumber
    ]
)
```

### Error States

```swift
// Show error message
DSTextField(
    "Email",
    text: $email,
    error: emailError
)

// Conditional error
DSTextField(
    "Email",
    text: $email,
    error: isEmailTaken ? "This email is already registered" : nil
)
```

### Helper Text

```swift
// Helper text below field
DSTextField(
    "Password",
    text: $password,
    type: .password,
    helperText: "Must be at least 8 characters"
)

// Character count
DSTextField(
    "Bio",
    text: $bio,
    helperText: "\(bio.count)/500",
    maxLength: 500
)
```

### Icons

```swift
// Leading icon
DSTextField(
    "Email",
    text: $email,
    leadingIcon: Image(systemName: "envelope")
)

// Trailing icon
DSTextField(
    "Search",
    text: $query,
    trailingIcon: Image(systemName: "magnifyingglass")
)

// Both icons
DSTextField(
    "Password",
    text: $password,
    type: .password,
    leadingIcon: Image(systemName: "lock"),
    trailingIcon: Image(systemName: "eye")
)
```

### Clearable

```swift
// Show clear button
DSTextField(
    "Search",
    text: $query,
    isClearable: true
)
```

### States

```swift
// Disabled
DSTextField(
    "Email",
    text: $email,
    isDisabled: true
)

// Read-only
DSTextField(
    "User ID",
    text: .constant(userId),
    isReadOnly: true
)

// Focused
@FocusState private var isEmailFocused: Bool

DSTextField(
    "Email",
    text: $email
)
.focused($isEmailFocused)
```

### Multiline Text

```swift
// Multiline with fixed height
DSTextField(
    "Description",
    text: $description,
    axis: .vertical,
    lineLimit: 5
)

// Expandable
DSTextField(
    "Notes",
    text: $notes,
    axis: .vertical,
    lineLimit: 3...10
)
```

### Complete Example

```swift
struct RegistrationForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var emailError: String?
    @State private var passwordError: String?

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSTextField(
                "Email",
                text: $email,
                type: .email,
                placeholder: "you@example.com",
                leadingIcon: Image(systemName: "envelope"),
                error: emailError,
                isRequired: true
            )
            .onChange(of: email) { _ in
                validateEmail()
            }

            DSTextField(
                "Password",
                text: $password,
                type: .password,
                placeholder: "Create a password",
                leadingIcon: Image(systemName: "lock"),
                helperText: "At least 8 characters",
                isRequired: true
            )

            DSTextField(
                "Confirm Password",
                text: $confirmPassword,
                type: .password,
                placeholder: "Confirm your password",
                leadingIcon: Image(systemName: "lock.fill"),
                error: passwordError,
                isRequired: true
            )
            .onChange(of: confirmPassword) { _ in
                validatePasswordMatch()
            }

            DSButton(
                "Create Account",
                style: .primary,
                isFullWidth: true,
                isEnabled: isFormValid
            ) {
                createAccount()
            }
        }
        .padding()
    }

    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        emailError == nil &&
        passwordError == nil
    }

    private func validateEmail() {
        emailError = email.contains("@") ? nil : "Invalid email format"
    }

    private func validatePasswordMatch() {
        passwordError = password == confirmPassword ? nil : "Passwords don't match"
    }
}
```

### Keyboard Handling

```swift
struct SearchView: View {
    @State private var query = ""
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack {
            DSTextField(
                "Search",
                text: $query,
                type: .search,
                isClearable: true
            )
            .focused($isSearchFocused)
            .submitLabel(.search)
            .onSubmit {
                performSearch()
            }

            // Dismiss keyboard button
            if isSearchFocused {
                Button("Cancel") {
                    isSearchFocused = false
                }
            }
        }
    }
}
```

### Accessibility

```swift
// Custom accessibility
DSTextField(
    "Email",
    text: $email,
    type: .email
)
.accessibilityLabel("Email address")
.accessibilityHint("Enter your email to sign in")

// Error announcement
DSTextField(
    "Password",
    text: $password,
    error: passwordError
)
// VoiceOver automatically announces: "Password, text field, error: [error message]"
```

## Best Practices

### Form Layout

```swift
Form {
    Section("Account Details") {
        DSTextField("Email", text: $email, type: .email)
        DSTextField("Password", text: $password, type: .password)
    }

    Section("Personal Information") {
        DSTextField("First Name", text: $firstName)
        DSTextField("Last Name", text: $lastName)
        DSTextField("Phone", text: $phone, type: .phone)
    }
}
```

### Real-time Validation

```swift
DSTextField(
    "Username",
    text: $username,
    validation: .custom { value in
        // Validate as user types
        guard value.count >= 3 else {
            return .invalid("Too short")
        }
        return .valid
    },
    validateOnChange: true  // Validate while typing
)
```

### Password Requirements

```swift
VStack(alignment: .leading) {
    DSTextField(
        "Password",
        text: $password,
        type: .password
    )

    // Show requirements
    PasswordRequirementRow(
        "At least 8 characters",
        isMet: password.count >= 8
    )
    PasswordRequirementRow(
        "Contains uppercase",
        isMet: password.contains(where: \.isUppercase)
    )
    PasswordRequirementRow(
        "Contains number",
        isMet: password.contains(where: \.isNumber)
    )
}
```

## API Reference

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | `String` | required | Field label |
| `text` | `Binding<String>` | required | Text binding |
| `type` | `DSTextFieldType` | `.text` | Input type |
| `placeholder` | `String?` | `nil` | Placeholder text |
| `helperText` | `String?` | `nil` | Helper text below |
| `error` | `String?` | `nil` | Error message |
| `leadingIcon` | `Image?` | `nil` | Icon before text |
| `trailingIcon` | `Image?` | `nil` | Icon after text |
| `isClearable` | `Bool` | `false` | Show clear button |
| `isRequired` | `Bool` | `false` | Required indicator |
| `isDisabled` | `Bool` | `false` | Disabled state |
| `isReadOnly` | `Bool` | `false` | Read-only state |
| `maxLength` | `Int?` | `nil` | Max character limit |
| `validation` | `DSValidation?` | `nil` | Validation rule |

### DSTextFieldType

| Type | Keyboard | Secure | Autocapitalization |
|------|----------|--------|-------------------|
| `.text` | Default | No | Sentences |
| `.email` | Email | No | None |
| `.password` | Default | Yes | None |
| `.phone` | Phone | No | None |
| `.number` | Number | No | None |
| `.url` | URL | No | None |
| `.search` | Default | No | None |

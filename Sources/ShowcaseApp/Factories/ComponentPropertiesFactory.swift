import SwiftUI

/// Factory for creating component property documentation
public enum ComponentPropertiesFactory {

    @ViewBuilder
    public static func properties(for component: ComponentInfo) -> some View {
        switch component.name {
        case "Button":
            ButtonProperties()
        case "Card":
            CardProperties()
        case "Avatar":
            AvatarProperties()
        case "Badge":
            BadgeProperties()
        case "TextField":
            TextFieldProperties()
        case "Alert":
            AlertProperties()
        case "Toggle":
            ToggleProperties()
        case "Slider":
            SliderProperties()
        default:
            DefaultProperties(componentName: component.name)
        }
    }
}

// MARK: - Property Row

struct PropertyRow: View {
    let name: String
    let type: String
    let description: String
    let defaultValue: String?
    let isRequired: Bool

    init(name: String, type: String, description: String, defaultValue: String? = nil, isRequired: Bool = false) {
        self.name = name
        self.type = type
        self.description = description
        self.defaultValue = defaultValue
        self.isRequired = isRequired
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(name)
                    .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                    .foregroundColor(.accentColor)

                Text(type)
                    .font(.system(.caption, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray5))
                    .cornerRadius(4)

                if isRequired {
                    Text("Required")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.red)
                }
            }

            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)

            if let defaultValue = defaultValue {
                HStack(spacing: 4) {
                    Text("Default:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(defaultValue)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Default Properties

struct DefaultProperties: View {
    let componentName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Properties documentation coming soon.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Button Properties

struct ButtonProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "title",
                type: "String",
                description: "The button's title text",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "style",
                type: "DSButtonStyle",
                description: "Visual style of the button (primary, secondary, tertiary)",
                defaultValue: ".primary"
            )
            Divider()

            PropertyRow(
                name: "size",
                type: "DSButtonSize",
                description: "Size variant (small, medium, large)",
                defaultValue: ".medium"
            )
            Divider()

            PropertyRow(
                name: "icon",
                type: "Image?",
                description: "Optional icon image to display alongside the title"
            )
            Divider()

            PropertyRow(
                name: "iconPosition",
                type: "DSButtonIconPosition",
                description: "Position of the icon relative to text (leading, trailing)",
                defaultValue: ".leading"
            )
            Divider()

            PropertyRow(
                name: "isFullWidth",
                type: "Bool",
                description: "Whether button should expand to full width",
                defaultValue: "false"
            )
            Divider()

            PropertyRow(
                name: "isLoading",
                type: "Bool",
                description: "Shows loading spinner when true",
                defaultValue: "false"
            )
            Divider()

            PropertyRow(
                name: "isEnabled",
                type: "Bool",
                description: "Whether the button is interactive",
                defaultValue: "true"
            )
            Divider()

            PropertyRow(
                name: "hapticFeedback",
                type: "Bool",
                description: "Whether to trigger haptic feedback on tap",
                defaultValue: "true"
            )
            Divider()

            PropertyRow(
                name: "action",
                type: "() -> Void",
                description: "Closure executed when button is tapped",
                isRequired: true
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Card Properties

struct CardProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "style",
                type: "CardStyle",
                description: "Visual style (flat, outlined, elevated, filled)",
                defaultValue: ".elevated"
            )
            Divider()

            PropertyRow(
                name: "padding",
                type: "CGFloat",
                description: "Internal padding of the card",
                defaultValue: "16"
            )
            Divider()

            PropertyRow(
                name: "cornerRadius",
                type: "CGFloat",
                description: "Corner radius of the card",
                defaultValue: "12"
            )
            Divider()

            PropertyRow(
                name: "shadowRadius",
                type: "CGFloat",
                description: "Shadow blur radius (elevated style only)",
                defaultValue: "4"
            )
            Divider()

            PropertyRow(
                name: "content",
                type: "Content",
                description: "The card's content view",
                isRequired: true
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Avatar Properties

struct AvatarProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "size",
                type: "AvatarSize",
                description: "Size of the avatar (xs, sm, md, lg, xl)",
                defaultValue: ".md"
            )
            Divider()

            PropertyRow(
                name: "imageURL",
                type: "URL?",
                description: "URL for the avatar image"
            )
            Divider()

            PropertyRow(
                name: "initials",
                type: "String?",
                description: "Initials to display when no image is available"
            )
            Divider()

            PropertyRow(
                name: "icon",
                type: "Image?",
                description: "Fallback icon when no image or initials"
            )
            Divider()

            PropertyRow(
                name: "status",
                type: "AvatarStatus?",
                description: "Status indicator (online, offline, busy, away)"
            )
            Divider()

            PropertyRow(
                name: "backgroundColor",
                type: "Color",
                description: "Background color for initials/icon avatar",
                defaultValue: ".accentColor"
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Badge Properties

struct BadgeProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "text",
                type: "String",
                description: "Text content of the badge",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "style",
                type: "BadgeStyle",
                description: "Visual style (primary, success, warning, error, info)",
                defaultValue: ".primary"
            )
            Divider()

            PropertyRow(
                name: "size",
                type: "BadgeSize",
                description: "Size of the badge (small, medium)",
                defaultValue: ".small"
            )
            Divider()

            PropertyRow(
                name: "shape",
                type: "BadgeShape",
                description: "Shape of the badge (rounded, pill)",
                defaultValue: ".rounded"
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - TextField Properties

struct TextFieldProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "text",
                type: "Binding<String>",
                description: "Binding to the text field's content",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "placeholder",
                type: "String",
                description: "Placeholder text when field is empty",
                defaultValue: "\"\""
            )
            Divider()

            PropertyRow(
                name: "label",
                type: "String?",
                description: "Label text above the field"
            )
            Divider()

            PropertyRow(
                name: "helperText",
                type: "String?",
                description: "Helper text below the field"
            )
            Divider()

            PropertyRow(
                name: "errorMessage",
                type: "String?",
                description: "Error message when validation fails"
            )
            Divider()

            PropertyRow(
                name: "isSecure",
                type: "Bool",
                description: "Whether to mask input (password mode)",
                defaultValue: "false"
            )
            Divider()

            PropertyRow(
                name: "isDisabled",
                type: "Bool",
                description: "Whether the field is disabled",
                defaultValue: "false"
            )
            Divider()

            PropertyRow(
                name: "maxLength",
                type: "Int?",
                description: "Maximum character count"
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Alert Properties

struct AlertProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "title",
                type: "String",
                description: "Title of the alert",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "message",
                type: "String?",
                description: "Optional message body"
            )
            Divider()

            PropertyRow(
                name: "type",
                type: "AlertType",
                description: "Type of alert (info, success, warning, error)",
                defaultValue: ".info"
            )
            Divider()

            PropertyRow(
                name: "icon",
                type: "Image?",
                description: "Custom icon (uses default based on type if nil)"
            )
            Divider()

            PropertyRow(
                name: "primaryAction",
                type: "DSAlertAction?",
                description: "Primary action button"
            )
            Divider()

            PropertyRow(
                name: "secondaryAction",
                type: "DSAlertAction?",
                description: "Secondary action button"
            )
            Divider()

            PropertyRow(
                name: "isDismissable",
                type: "Bool",
                description: "Whether the alert can be dismissed",
                defaultValue: "true"
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Toggle Properties

struct ToggleProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "isOn",
                type: "Binding<Bool>",
                description: "Binding to the toggle's on/off state",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "label",
                type: "String",
                description: "Label text for the toggle",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "tint",
                type: "Color",
                description: "Color when toggle is on",
                defaultValue: ".accentColor"
            )
            Divider()

            PropertyRow(
                name: "isDisabled",
                type: "Bool",
                description: "Whether the toggle is disabled",
                defaultValue: "false"
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Slider Properties

struct SliderProperties: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PropertyRow(
                name: "value",
                type: "Binding<Double>",
                description: "Binding to the slider's current value",
                isRequired: true
            )
            Divider()

            PropertyRow(
                name: "range",
                type: "ClosedRange<Double>",
                description: "The range of valid values",
                defaultValue: "0...1"
            )
            Divider()

            PropertyRow(
                name: "step",
                type: "Double?",
                description: "Step increment for discrete values"
            )
            Divider()

            PropertyRow(
                name: "label",
                type: "String?",
                description: "Accessibility label for the slider"
            )
            Divider()

            PropertyRow(
                name: "minimumValueLabel",
                type: "View?",
                description: "Label shown at minimum value"
            )
            Divider()

            PropertyRow(
                name: "maximumValueLabel",
                type: "View?",
                description: "Label shown at maximum value"
            )
            Divider()

            PropertyRow(
                name: "tint",
                type: "Color",
                description: "Color of the filled track",
                defaultValue: ".accentColor"
            )
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

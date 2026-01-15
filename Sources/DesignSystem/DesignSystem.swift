// DesignSystem
// A comprehensive iOS design system library

/// Design System main entry point
///
/// This module provides a collection of reusable UI components for building
/// consistent and accessible iOS applications.
///
/// ## Selection Controls
///
/// The selection control components include:
/// - ``DSCheckbox``: A checkbox with support for checked, unchecked, and indeterminate states
/// - ``DSRadioButton``: A radio button for single selection
/// - ``DSRadioGroup``: A container for grouping radio buttons
/// - ``DSToggle``: A toggle/switch for on/off states
///
/// ## Usage Example
///
/// ```swift
/// import DesignSystem
///
/// struct SettingsView: View {
///     @State private var agreeTerms = false
///     @State private var notifications = true
///     @State private var selectedTheme: Theme = .system
///
///     var body: some View {
///         VStack {
///             DSCheckbox(isChecked: $agreeTerms, label: "I agree to the terms")
///
///             DSToggle(isOn: $notifications, label: "Push notifications")
///
///             DSRadioGroup(selection: $selectedTheme) {
///                 DSRadio(.light, "Light")
///                 DSRadio(.dark, "Dark")
///                 DSRadio(.system, "System")
///             }
///         }
///     }
/// }
/// ```

// Re-export all public types
@_exported import struct SwiftUI.Color

// Selection Controls
public typealias Checkbox = DSCheckbox
public typealias CheckboxState = DSCheckboxState
public typealias CheckboxSize = DSCheckboxSize

public typealias RadioButton = DSRadioButton
public typealias RadioButtonSize = DSRadioButtonSize
public typealias RadioGroup = DSRadioGroup
public typealias Radio = DSRadio

public typealias Toggle = DSToggle
public typealias ToggleSize = DSToggleSize

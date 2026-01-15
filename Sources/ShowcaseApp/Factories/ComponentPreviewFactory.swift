import SwiftUI

/// Factory for creating component previews
public enum ComponentPreviewFactory {

    @ViewBuilder
    public static func preview(for component: ComponentInfo) -> some View {
        switch component.name {
        // MARK: - Foundation
        case "Colors":
            ColorsPreview()
        case "Typography":
            TypographyPreview()
        case "Spacing":
            SpacingPreview()
        case "Icons":
            IconsPreview()
        case "Shadows":
            ShadowsPreview()

        // MARK: - Basic
        case "Button":
            ButtonPreview()
        case "IconButton":
            IconButtonPreview()
        case "FloatingActionButton":
            FABPreview()
        case "Card":
            CardPreview()
        case "Avatar":
            AvatarPreview()
        case "Badge":
            BadgePreview()
        case "Tag":
            TagPreview()
        case "TextField":
            TextFieldPreview()

        // MARK: - Navigation
        case "TabBar":
            TabBarPreview()
        case "NavigationBar":
            NavigationBarPreview()
        case "SegmentedControl":
            SegmentedControlPreview()

        // MARK: - Feedback
        case "Alert":
            AlertPreview()
        case "Toast":
            ToastPreview()
        case "Snackbar":
            SnackbarPreview()
        case "EmptyState":
            EmptyStatePreview()
        case "LoadingIndicator":
            LoadingIndicatorPreview()
        case "Skeleton":
            SkeletonPreview()
        case "Progress":
            ProgressPreview()

        // MARK: - Form
        case "Checkbox":
            CheckboxPreview()
        case "RadioButton":
            RadioButtonPreview()
        case "Toggle":
            TogglePreview()
        case "Slider":
            SliderPreview()
        case "RangeSlider":
            RangeSliderPreview()
        case "DatePicker":
            DatePickerPreview()
        case "TimePicker":
            TimePickerPreview()
        case "Dropdown":
            DropdownPreview()
        case "MultiSelect":
            MultiSelectPreview()

        // MARK: - Overlay
        case "Modal":
            ModalPreview()
        case "BottomSheet":
            BottomSheetPreview()
        case "ActionSheet":
            ActionSheetPreview()
        case "Popover":
            PopoverPreview()
        case "Tooltip":
            TooltipPreview()
        case "ContextMenu":
            ContextMenuPreview()

        // MARK: - Data Display
        case "List":
            ListPreview()
        case "Grid":
            GridPreview()
        case "Carousel":
            CarouselPreview()
        case "Pagination":
            PaginationPreview()

        // MARK: - Utilities
        case "Animation":
            AnimationPreview()
        case "Gesture":
            GesturePreview()
        case "Accessibility":
            AccessibilityPreview()

        default:
            DefaultPreview(name: component.name)
        }
    }
}

// MARK: - Default Preview

struct DefaultPreview: View {
    let name: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.dashed")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(name)
                .font(.headline)

            Text("Preview coming soon")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

// MARK: - Foundation Previews

struct ColorsPreview: View {
    let colors: [(String, Color)] = [
        ("Primary", .accentColor),
        ("Success", .green),
        ("Warning", .orange),
        ("Error", .red),
        ("Info", .blue)
    ]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(colors, id: \.0) { name, color in
                VStack(spacing: 4) {
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                    Text(name)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct TypographyPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Large Title").font(.largeTitle)
            Text("Title").font(.title)
            Text("Headline").font(.headline)
            Text("Body").font(.body)
            Text("Caption").font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SpacingPreview: View {
    let spacings: [(String, CGFloat)] = [
        ("xs", 4), ("sm", 8), ("md", 16), ("lg", 24), ("xl", 32)
    ]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(spacings, id: \.0) { name, size in
                VStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: size, height: size)
                    Text(name)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct IconsPreview: View {
    let icons = ["heart.fill", "star.fill", "bell.fill", "gear", "person.fill"]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(icons, id: \.self) { icon in
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct ShadowsPreview: View {
    var body: some View {
        HStack(spacing: 24) {
            ForEach(["sm", "md", "lg"], id: \.self) { size in
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .frame(width: 60, height: 60)
                        .shadow(
                            color: .black.opacity(0.15),
                            radius: size == "sm" ? 2 : size == "md" ? 4 : 8,
                            y: size == "sm" ? 1 : size == "md" ? 2 : 4
                        )
                    Text(size)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Basic Component Previews

struct ButtonPreview: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("Primary") {}
                    .buttonStyle(.borderedProminent)

                Button("Secondary") {}
                    .buttonStyle(.bordered)

                Button("Tertiary") {}
            }
        }
    }
}

struct IconButtonPreview: View {
    var body: some View {
        HStack(spacing: 16) {
            Button {} label: {
                Image(systemName: "heart.fill")
            }
            .buttonStyle(.borderedProminent)

            Button {} label: {
                Image(systemName: "share")
            }
            .buttonStyle(.bordered)

            Button {} label: {
                Image(systemName: "bookmark")
            }
        }
        .font(.title3)
    }
}

struct FABPreview: View {
    var body: some View {
        Button {} label: {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
        }
    }
}

struct CardPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 80)

            Text("Card Title")
                .font(.headline)

            Text("Card description goes here")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        .frame(width: 200)
    }
}

struct AvatarPreview: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 32, height: 32)
                .overlay(Text("S").foregroundColor(.white).font(.caption))

            Circle()
                .fill(Color.green)
                .frame(width: 44, height: 44)
                .overlay(Text("M").foregroundColor(.white))

            Circle()
                .fill(Color.orange)
                .frame(width: 56, height: 56)
                .overlay(Text("L").foregroundColor(.white).font(.title3))
        }
    }
}

struct BadgePreview: View {
    var body: some View {
        HStack(spacing: 12) {
            Text("New")
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(4)

            Text("3")
                .font(.caption2.weight(.bold))
                .frame(width: 20, height: 20)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())

            Text("Beta")
                .font(.caption2.weight(.medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.2))
                .foregroundColor(.orange)
                .cornerRadius(4)
        }
    }
}

struct TagPreview: View {
    var body: some View {
        HStack(spacing: 8) {
            ForEach(["Swift", "iOS", "SwiftUI"], id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
            }
        }
    }
}

struct TextFieldPreview: View {
    @State private var text = ""

    var body: some View {
        VStack(spacing: 12) {
            TextField("Enter text...", text: $text)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $text)
                .textFieldStyle(.roundedBorder)
        }
        .frame(width: 250)
    }
}

// MARK: - Navigation Previews

struct TabBarPreview: View {
    @State private var selection = 0

    var body: some View {
        HStack(spacing: 32) {
            ForEach(0..<4) { index in
                VStack(spacing: 4) {
                    Image(systemName: ["house", "magnifyingglass", "bell", "person"][index])
                        .font(.system(size: 20))
                    Text(["Home", "Search", "Alerts", "Profile"][index])
                        .font(.caption2)
                }
                .foregroundColor(selection == index ? .accentColor : .secondary)
                .onTapGesture { selection = index }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct NavigationBarPreview: View {
    var body: some View {
        HStack {
            Button {} label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text("Title")
                .font(.headline)
            Spacer()
            Button {} label: {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct SegmentedControlPreview: View {
    @State private var selection = 0

    var body: some View {
        Picker("Options", selection: $selection) {
            Text("First").tag(0)
            Text("Second").tag(1)
            Text("Third").tag(2)
        }
        .pickerStyle(.segmented)
        .frame(width: 250)
    }
}

// MARK: - Feedback Previews

struct AlertPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Warning")
                    .font(.headline)
            }
            Text("This is an alert message.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ToastPreview: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Action completed successfully")
                .font(.subheadline)
            Spacer()
            Image(systemName: "xmark")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

struct SnackbarPreview: View {
    var body: some View {
        HStack {
            Text("Item deleted")
                .font(.subheadline)
            Spacer()
            Button("Undo") {}
                .font(.subheadline.weight(.semibold))
        }
        .padding()
        .background(Color(.systemGray2))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct EmptyStatePreview: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No items found")
                .font(.headline)
            Text("Add your first item to get started")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct LoadingIndicatorPreview: View {
    var body: some View {
        HStack(spacing: 24) {
            ProgressView()
            ProgressView()
                .scaleEffect(1.5)
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.accentColor)
        }
    }
}

struct SkeletonPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray5))
                .frame(height: 16)
                .frame(width: 200)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray5))
                .frame(height: 12)
                .frame(width: 150)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray5))
                .frame(height: 12)
                .frame(width: 180)
        }
    }
}

struct ProgressPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView(value: 0.7)
                .frame(width: 200)

            ProgressView(value: 0.4)
                .tint(.green)
                .frame(width: 200)
        }
    }
}

// MARK: - Form Previews

struct CheckboxPreview: View {
    @State private var isChecked1 = true
    @State private var isChecked2 = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $isChecked1) {
                Text("Option 1")
            }
            .toggleStyle(.checkbox)

            Toggle(isOn: $isChecked2) {
                Text("Option 2")
            }
            .toggleStyle(.checkbox)
        }
    }
}

struct RadioButtonPreview: View {
    @State private var selection = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<3) { index in
                HStack {
                    Image(systemName: selection == index ? "circle.inset.filled" : "circle")
                        .foregroundColor(selection == index ? .accentColor : .secondary)
                    Text("Option \(index + 1)")
                }
                .onTapGesture { selection = index }
            }
        }
    }
}

struct TogglePreview: View {
    @State private var isOn = true

    var body: some View {
        Toggle("Enable feature", isOn: $isOn)
            .frame(width: 200)
    }
}

struct SliderPreview: View {
    @State private var value: Double = 50

    var body: some View {
        VStack {
            Slider(value: $value, in: 0...100)
                .frame(width: 200)
            Text("\(Int(value))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct RangeSliderPreview: View {
    var body: some View {
        VStack {
            HStack {
                Text("$0")
                Spacer()
                Text("$100")
            }
            .font(.caption)
            .foregroundColor(.secondary)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray5))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentColor)
                        .frame(width: geometry.size.width * 0.5, height: 4)
                        .offset(x: geometry.size.width * 0.2)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .shadow(radius: 2)
                        .offset(x: geometry.size.width * 0.2 - 10)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .shadow(radius: 2)
                        .offset(x: geometry.size.width * 0.7 - 10)
                }
            }
            .frame(height: 20)
        }
        .frame(width: 200)
    }
}

struct DatePickerPreview: View {
    @State private var date = Date()

    var body: some View {
        DatePicker("Select date", selection: $date, displayedComponents: .date)
            .datePickerStyle(.compact)
            .frame(width: 200)
    }
}

struct TimePickerPreview: View {
    @State private var time = Date()

    var body: some View {
        DatePicker("Select time", selection: $time, displayedComponents: .hourAndMinute)
            .datePickerStyle(.compact)
            .frame(width: 200)
    }
}

struct DropdownPreview: View {
    @State private var selection = "Option 1"

    var body: some View {
        Menu {
            ForEach(["Option 1", "Option 2", "Option 3"], id: \.self) { option in
                Button(option) { selection = option }
            }
        } label: {
            HStack {
                Text(selection)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
        .frame(width: 200)
    }
}

struct MultiSelectPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "checkmark.square.fill")
                    .foregroundColor(.accentColor)
                Text("Selected 1")
            }
            HStack {
                Image(systemName: "checkmark.square.fill")
                    .foregroundColor(.accentColor)
                Text("Selected 2")
            }
            HStack {
                Image(systemName: "square")
                    .foregroundColor(.secondary)
                Text("Not selected")
            }
        }
    }
}

// MARK: - Overlay Previews

struct ModalPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Modal Title")
                .font(.headline)
            Text("Modal content goes here")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack(spacing: 12) {
                Button("Cancel") {}
                    .buttonStyle(.bordered)
                Button("Confirm") {}
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}

struct BottomSheetPreview: View {
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 4)

            Text("Bottom Sheet")
                .font(.headline)

            Text("Sheet content appears here")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
}

struct ActionSheetPreview: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(["Edit", "Share", "Delete"], id: \.self) { action in
                Button {} label: {
                    Text(action)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                if action != "Delete" {
                    Divider()
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .frame(width: 200)
    }
}

struct PopoverPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Popover Title")
                .font(.subheadline.weight(.semibold))
            Text("Additional information displayed in a popover")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct TooltipPreview: View {
    var body: some View {
        VStack {
            Text("Helpful tooltip text")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.label))
                .foregroundColor(Color(.systemBackground))
                .cornerRadius(6)

            Triangle()
                .fill(Color(.label))
                .frame(width: 12, height: 6)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct ContextMenuPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach([("doc.on.doc", "Copy"), ("square.and.arrow.up", "Share"), ("trash", "Delete")], id: \.1) { icon, title in
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: icon)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .foregroundColor(title == "Delete" ? .red : .primary)

                if title != "Delete" {
                    Divider()
                }
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .frame(width: 160)
    }
}

// MARK: - Data Display Previews

struct ListPreview: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(1..<4) { index in
                HStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading) {
                        Text("Item \(index)")
                            .font(.subheadline)
                        Text("Description")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)

                if index < 3 {
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct GridPreview: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<6) { _ in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        .frame(width: 200)
    }
}

struct CarouselPreview: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(index == 1 ? Color.accentColor : Color(.systemGray5))
                        .frame(width: index == 1 ? 100 : 60, height: 80)
                }
            }

            HStack(spacing: 6) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == 1 ? Color.accentColor : Color(.systemGray4))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

struct PaginationPreview: View {
    var body: some View {
        HStack(spacing: 8) {
            Button {} label: {
                Image(systemName: "chevron.left")
            }
            .disabled(true)

            ForEach(1..<5) { page in
                Button {} label: {
                    Text("\(page)")
                        .frame(width: 32, height: 32)
                        .background(page == 1 ? Color.accentColor : Color(.systemGray5))
                        .foregroundColor(page == 1 ? .white : .primary)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }

            Button {} label: {
                Image(systemName: "chevron.right")
            }
        }
    }
}

// MARK: - Utility Previews

struct AnimationPreview: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 24) {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 40, height: 40)
                .scaleEffect(isAnimating ? 1.2 : 1.0)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green)
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))

            Capsule()
                .fill(Color.orange)
                .frame(width: 60, height: 30)
                .offset(y: isAnimating ? -10 : 0)
        }
        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear { isAnimating = true }
    }
}

struct GesturePreview: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                VStack {
                    Image(systemName: "hand.tap")
                        .font(.title)
                    Text("Tap")
                        .font(.caption)
                }

                VStack {
                    Image(systemName: "hand.draw")
                        .font(.title)
                    Text("Swipe")
                        .font(.caption)
                }

                VStack {
                    Image(systemName: "hand.pinch")
                        .font(.title)
                    Text("Pinch")
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary)
        }
    }
}

struct AccessibilityPreview: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "accessibility")
                    .foregroundColor(.accentColor)
                Text("VoiceOver Ready")
            }

            HStack {
                Image(systemName: "textformat.size")
                    .foregroundColor(.accentColor)
                Text("Dynamic Type")
            }

            HStack {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(.accentColor)
                Text("Reduced Motion")
            }
        }
        .font(.subheadline)
    }
}

// MARK: - Helper Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Checkbox Toggle Style

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}

extension ToggleStyle where Self == CheckboxToggleStyle {
    static var checkbox: CheckboxToggleStyle { CheckboxToggleStyle() }
}

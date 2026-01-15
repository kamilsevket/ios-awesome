import SwiftUI

/// A filter chip component for single-selection filtering
///
/// Use `DSFilterChip` when users need to select one filter option.
///
/// ```swift
/// DSFilterChip("All", isSelected: $isAllSelected)
/// DSFilterChip("Recent", icon: Image(systemName: "clock"), isSelected: $isRecentSelected)
/// ```
public struct DSFilterChip: View {
    // MARK: - Properties

    private let text: String
    private let icon: Image?
    private let size: DSChipSize

    @Binding private var isSelected: Bool
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a filter chip
    /// - Parameters:
    ///   - text: The text to display
    ///   - icon: Optional leading icon
    ///   - size: The size variant (default: .md)
    ///   - isSelected: Binding to the selection state
    public init(
        _ text: String,
        icon: Image? = nil,
        size: DSChipSize = .md,
        isSelected: Binding<Bool>
    ) {
        self.text = text
        self.icon = icon
        self.size = size
        self._isSelected = isSelected
    }

    // MARK: - Body

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isSelected.toggle()
            }
        } label: {
            HStack(spacing: DSSpacing.xs) {
                if let icon = icon {
                    icon
                        .font(size.iconFont)
                        .foregroundColor(foregroundColor)
                }

                Text(text)
                    .font(size.font)
                    .fontWeight(.medium)
                    .foregroundColor(foregroundColor)
                    .lineLimit(1)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(size.checkmarkFont)
                        .foregroundColor(foregroundColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(minHeight: DSSpacing.minTouchTarget)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
            .overlay(
                Capsule()
                    .strokeBorder(borderColor, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityLabel("\(text), \(isSelected ? "selected" : "not selected")")
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        if isSelected {
            return DSColors.chipSelectedBackground
        }
        return Color.clear
    }

    private var foregroundColor: Color {
        if isSelected {
            return .white
        }
        return Color.primary
    }

    private var borderColor: Color {
        Color.primary.opacity(0.2)
    }
}

// MARK: - Size Configuration

/// Size variants for chips
public enum DSChipSize {
    case sm
    case md

    var font: Font {
        switch self {
        case .sm: return .caption
        case .md: return .subheadline
        }
    }

    var iconFont: Font {
        switch self {
        case .sm: return .system(size: 12)
        case .md: return .system(size: 14)
        }
    }

    var checkmarkFont: Font {
        switch self {
        case .sm: return .system(size: 10, weight: .bold)
        case .md: return .system(size: 12, weight: .bold)
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .sm: return DSSpacing.md
        case .md: return DSSpacing.lg
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .sm: return DSSpacing.sm
        case .md: return DSSpacing.md
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSFilterChip_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var filters: [String: Bool] = [
            "All": true,
            "Recent": false,
            "Favorites": false,
            "Archived": false
        ]

        var body: some View {
            VStack(spacing: 24) {
                Group {
                    Text("Single Selection")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSFilterChip("All", isSelected: binding(for: "All"))
                        DSFilterChip("Recent", icon: Image(systemName: "clock"), isSelected: binding(for: "Recent"))
                        DSFilterChip("Favorites", icon: Image(systemName: "star"), isSelected: binding(for: "Favorites"))
                    }
                }

                Group {
                    Text("Size Variants")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSFilterChip("Small", size: .sm, isSelected: .constant(false))
                        DSFilterChip("Small Selected", size: .sm, isSelected: .constant(true))
                    }
                    HStack(spacing: 8) {
                        DSFilterChip("Medium", size: .md, isSelected: .constant(false))
                        DSFilterChip("Medium Selected", size: .md, isSelected: .constant(true))
                    }
                }

                Group {
                    Text("Disabled State")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSFilterChip("Disabled", isSelected: .constant(false))
                            .disabled(true)
                        DSFilterChip("Disabled Selected", isSelected: .constant(true))
                            .disabled(true)
                    }
                }
            }
            .padding()
        }

        private func binding(for key: String) -> Binding<Bool> {
            Binding(
                get: { filters[key] ?? false },
                set: { filters[key] = $0 }
            )
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("DSFilterChip")
    }
}
#endif

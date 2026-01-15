import SwiftUI

// MARK: - Large Title Display Mode

/// Controls how the large title is displayed
public enum DSLargeTitleDisplayMode {
    /// Always show large title
    case always
    /// Show large title only when scrolled to top
    case automatic
    /// Never show large title (inline only)
    case never

    var prefersLargeTitles: Bool {
        switch self {
        case .always, .automatic:
            return true
        case .never:
            return false
        }
    }
}

// MARK: - Large Title View Modifier

/// A view modifier that adds iOS-style large title behavior to any view
///
/// Usage:
/// ```swift
/// ScrollView {
///     content
/// }
/// .dsLargeTitle("Settings", displayMode: .automatic)
/// ```
public struct DSLargeTitleModifier: ViewModifier {
    let title: String
    let subtitle: String?
    let displayMode: DSLargeTitleDisplayMode
    let tintColor: Color
    let backgroundColor: Color?

    @State private var scrollOffset: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme

    private let collapseCalculator = DSScrollCollapseCalculator(
        collapseStartOffset: 0,
        collapseEndOffset: 60
    )

    public init(
        title: String,
        subtitle: String? = nil,
        displayMode: DSLargeTitleDisplayMode = .automatic,
        tintColor: Color = .accentColor,
        backgroundColor: Color? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.displayMode = displayMode
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }

    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Navigation bar
                navigationBar
                    .zIndex(1)

                // Content with scroll tracking
                ScrollView {
                    DSScrollObserver(coordinateSpace: "largeTitleScroll")

                    content
                        .padding(.top, largeTitlePadding)
                }
                .coordinateSpace(name: "largeTitleScroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    scrollOffset = offset
                }
            }
        }
    }

    @ViewBuilder
    private var navigationBar: some View {
        VStack(spacing: 0) {
            // Inline header
            HStack {
                Spacer()

                if shouldShowInlineTitle {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .opacity(inlineTitleOpacity)
                }

                Spacer()
            }
            .frame(height: 44)

            // Large title
            if displayMode.prefersLargeTitles {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 34, weight: .bold))

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .opacity(largeTitleOpacity)
                .scaleEffect(largeTitleScale, anchor: .topLeading)
            }

            Divider()
                .opacity(dividerOpacity)
        }
        .background(navBarBackground)
    }

    @ViewBuilder
    private var navBarBackground: some View {
        if let backgroundColor = backgroundColor {
            backgroundColor
        } else {
            Color(.systemBackground)
        }
    }

    // MARK: - Computed Properties

    private var collapseProgress: CGFloat {
        guard displayMode == .automatic else {
            return displayMode == .never ? 1 : 0
        }
        return collapseCalculator.progress(for: scrollOffset)
    }

    private var shouldShowInlineTitle: Bool {
        displayMode == .never || collapseProgress > 0.3
    }

    private var inlineTitleOpacity: CGFloat {
        displayMode == .never ? 1 : min(1, (collapseProgress - 0.3) / 0.7)
    }

    private var largeTitleOpacity: CGFloat {
        collapseCalculator.largeTitleOpacity(for: collapseProgress)
    }

    private var largeTitleScale: CGFloat {
        collapseCalculator.largeTitleScale(for: collapseProgress)
    }

    private var dividerOpacity: CGFloat {
        min(1, collapseProgress * 2)
    }

    private var largeTitlePadding: CGFloat {
        displayMode.prefersLargeTitles ? 0 : 0
    }
}

// MARK: - View Extension

extension View {
    /// Adds iOS-style large title behavior
    public func dsLargeTitle(
        _ title: String,
        subtitle: String? = nil,
        displayMode: DSLargeTitleDisplayMode = .automatic,
        tintColor: Color = .accentColor,
        backgroundColor: Color? = nil
    ) -> some View {
        modifier(DSLargeTitleModifier(
            title: title,
            subtitle: subtitle,
            displayMode: displayMode,
            tintColor: tintColor,
            backgroundColor: backgroundColor
        ))
    }
}

// MARK: - Navigation Title Style Modifier

/// Applies styling to navigation titles
public struct DSNavigationTitleStyleModifier: ViewModifier {
    let style: DSNavigationBarStyle
    let tintColor: Color

    public init(style: DSNavigationBarStyle = .largeTitle, tintColor: Color = .accentColor) {
        self.style = style
        self.tintColor = tintColor
    }

    public func body(content: Content) -> some View {
        content
            #if os(iOS)
            .navigationBarTitleDisplayMode(navigationTitleDisplayMode)
            #endif
            .tint(tintColor)
    }

    #if os(iOS)
    private var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode {
        switch style {
        case .largeTitle:
            return .large
        case .inline, .transparent:
            return .inline
        case .custom(let config):
            return config.supportsCollapse ? .large : .inline
        }
    }
    #endif
}

// MARK: - View Extension for Navigation Title Style

extension View {
    /// Applies design system navigation title styling
    public func dsNavigationTitleStyle(
        _ style: DSNavigationBarStyle = .largeTitle,
        tintColor: Color = .accentColor
    ) -> some View {
        modifier(DSNavigationTitleStyleModifier(style: style, tintColor: tintColor))
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSLargeTitleModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Automatic mode
            VStack {
                ForEach(0..<30) { index in
                    Text("Item \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .padding()
            .dsLargeTitle("Settings", subtitle: "Customize your experience")
            .previewDisplayName("Automatic Mode")

            // Always mode
            VStack {
                ForEach(0..<30) { index in
                    Text("Item \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .padding()
            .dsLargeTitle("Profile", displayMode: .always)
            .previewDisplayName("Always Mode")

            // Never mode
            VStack {
                ForEach(0..<30) { index in
                    Text("Item \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .padding()
            .dsLargeTitle("Messages", displayMode: .never)
            .previewDisplayName("Never Mode")
        }
    }
}
#endif

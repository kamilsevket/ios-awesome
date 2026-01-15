import SwiftUI

/// Detail view showing a component with its variants, states, and code snippets
public struct ComponentDetailView: View {
    let component: ComponentInfo
    @State private var selectedVariant: Int = 0
    @State private var showCodeSnippet = false

    public init(component: ComponentInfo) {
        self.component = component
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Component header
                componentHeader

                Divider()

                // Live preview section
                livePreviewSection

                Divider()

                // Variants section
                variantsSection

                Divider()

                // Code snippet section
                codeSnippetSection

                Divider()

                // Properties section
                propertiesSection
            }
            .padding()
        }
        .navigationTitle(component.name)
        .navigationBarTitleDisplayMode(.large)
    }

    private var componentHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: component.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.accentColor)

                VStack(alignment: .leading) {
                    Text(component.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(component.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Text(componentDescription)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }

    private var livePreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Live Preview", icon: "eye.fill")

            ComponentPreviewFactory.preview(for: component)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
        }
    }

    private var variantsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Variants", icon: "square.on.square")

            ComponentVariantsFactory.variants(for: component)
        }
    }

    private var codeSnippetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Code Snippet", icon: "doc.text.fill")

            CodeSnippetView(code: codeSnippet)
        }
    }

    private var propertiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Properties", icon: "list.bullet")

            ComponentPropertiesFactory.properties(for: component)
        }
    }

    private var componentDescription: String {
        ComponentDescriptions.description(for: component.name)
    }

    private var codeSnippet: String {
        CodeSnippets.snippet(for: component.name)
    }
}

/// Section header with icon and title
struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.accentColor)

            Text(title)
                .font(.headline)
        }
    }
}

#if DEBUG
struct ComponentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ComponentDetailView(
                component: ComponentInfo(name: "Button", icon: "rectangle.fill", category: .basic)
            )
        }
    }
}
#endif

import SwiftUI

/// Main view displaying all component categories and their components
public struct ComponentsListView: View {
    @Binding var searchText: String
    @State private var expandedCategories: Set<ComponentCategory> = Set(ComponentCategory.allCases)

    public init(searchText: Binding<String>) {
        self._searchText = searchText
    }

    private var filteredCategories: [(ComponentCategory, [ComponentInfo])] {
        if searchText.isEmpty {
            return ComponentCategory.allCases.map { ($0, $0.components) }
        }

        return ComponentCategory.allCases.compactMap { category in
            let filteredComponents = category.components.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            if filteredComponents.isEmpty && !category.rawValue.localizedCaseInsensitiveContains(searchText) {
                return nil
            }
            return (category, filteredComponents.isEmpty ? category.components : filteredComponents)
        }
    }

    public var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCategories, id: \.0) { category, components in
                    Section {
                        DisclosureGroup(
                            isExpanded: Binding(
                                get: { expandedCategories.contains(category) },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedCategories.insert(category)
                                    } else {
                                        expandedCategories.remove(category)
                                    }
                                }
                            )
                        ) {
                            ForEach(components) { component in
                                NavigationLink(value: component) {
                                    ComponentRow(component: component)
                                }
                            }
                        } label: {
                            CategoryHeader(category: category)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Components")
            .searchable(text: $searchText, prompt: "Search components")
            .navigationDestination(for: ComponentInfo.self) { component in
                ComponentDetailView(component: component)
            }
        }
    }
}

/// Row displaying a single component in the list
struct ComponentRow: View {
    let component: ComponentInfo

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: component.icon)
                .font(.system(size: 18))
                .foregroundColor(.accentColor)
                .frame(width: 28, height: 28)

            Text(component.name)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

/// Header for a component category section
struct CategoryHeader: View {
    let category: ComponentCategory

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.accentColor)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(category.components.count) components")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
struct ComponentsListView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsListView(searchText: .constant(""))
    }
}
#endif

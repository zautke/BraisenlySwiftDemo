import SwiftUI
import BraisenlySwiftUI

struct CatalogSidebar: View {
    @Binding var themeID: BraisenlyThemeDefinition.ID
    @Binding var selection: CatalogEntry.ID?
    @Binding var compactColumn: NavigationSplitViewColumn
    @State private var query = ""

    var body: some View {
        let sections = CatalogRegistry.sections(matching: query)
        BraisenlyScroll {
            BraisenlyVStack(alignment: .leading, spacing: .s) {
                BraisenlyThemeSwitcher(selection: $themeID, style: .row)
                    .accessibilityIdentifier("catalog.themeSwitcher")
                BraisenlySidebarSearchHeader(searchText: $query)
                    .accessibilityIdentifier("catalog.search")
                if sections.isEmpty {
                    BraisenlyEmptyState(title: "No components", message: "Nothing matches “\(query.trimmingCharacters(in: .whitespacesAndNewlines))”.", systemImage: "magnifyingglass")
                }
                ForEach(sections, id: \.group) { section in
                    BraisenlySectionHeader(section.group.title, systemImage: section.group.symbolName, trailing: "\(section.entries.count)")
                    ForEach(section.entries) { entry in
                        BraisenlyNavRow(title: entry.title, isSelected: entry.id == selection) {
                            selection = entry.id
                            compactColumn = .detail
                        }
                        .accessibilityIdentifier("catalog.row.\(entry.id)")
                        .accessibilityLabel(entry.title)
                    }
                }
            }
            .braisenlyPadding(.all, .m)
        }
    }
}

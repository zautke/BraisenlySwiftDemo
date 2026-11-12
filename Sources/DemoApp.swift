import SwiftUI
import BraisenlySwiftUI

@main
struct DemoApp: App {
    @State private var themeID: BraisenlyThemeDefinition.ID
    @State private var selection: CatalogEntry.ID?
    @State private var compactColumn: NavigationSplitViewColumn

    init() {
        let options = LaunchOptions(defaults: .standard)
        let entry = Self.initialSelection(for: options)
        _themeID = State(initialValue: Self.initialThemeID(for: options))
        _selection = State(initialValue: entry)
        _compactColumn = State(initialValue: entry == nil ? .sidebar : .detail)
    }

    nonisolated static func initialSelection(for options: LaunchOptions) -> CatalogEntry.ID? {
        options.entryID.flatMap { CatalogRegistry.entry(id: $0)?.id }
    }

    nonisolated static func initialThemeID(for options: LaunchOptions) -> BraisenlyThemeDefinition.ID {
        BraisenlyThemes.theme(withID: options.themeID ?? "").id
    }

    var body: some Scene {
        WindowGroup {
            BraisenlySplitView(preferredCompactColumn: $compactColumn) {
                CatalogSidebar(themeID: $themeID, selection: $selection, compactColumn: $compactColumn)
            } detail: {
                if let id = selection, let entry = CatalogRegistry.entry(id: id) {
                    CatalogDetail(entry: entry).id(entry.id)
                } else {
                    BraisenlyEmptyState(title: "Pick a component", message: "Choose an entry in the sidebar.", systemImage: "sidebar.leading")
                }
            }
            .braisenlyTheme(BraisenlyThemes.theme(withID: themeID))
        }
        .defaultSize(width: 1200, height: 800)
    }
}

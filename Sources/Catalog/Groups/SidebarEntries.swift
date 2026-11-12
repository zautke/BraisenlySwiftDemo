import SwiftUI
import BraisenlySwiftUI

nonisolated private struct ContextPopoverState { var mode: BraisenlySidebarMode = .files; var isPresented = true }
nonisolated private struct DrawerState { var searchText = ""; var mode: BraisenlySidebarMode = .files; var showPopover = false }

nonisolated enum SidebarEntries {
    private static let modeOptions = BraisenlySidebarMode.allCases.map(\.rawValue)

    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "sidebar.searchHeader", group: .sidebar, typeName: "BraisenlySidebarSearchHeader",
            title: "Sidebar Search Header", summary: "Search field with clear and filter affordances.",
            snippet: "@State private var searchText = \"\"\nBraisenlySidebarSearchHeader(searchText: $searchText, platform: .{{platform}})",
            knobs: [.platform()]
        ) { values in
            var v = values
            let platform = v.platform()
            return AnyView(StateHost("") { BraisenlySidebarSearchHeader(searchText: $0, platform: platform) })
        },
        CatalogEntry(
            id: "sidebar.footer", group: .sidebar, typeName: "BraisenlySidebarFooter",
            title: "Sidebar Footer", summary: "Bottom bar showing the selected sidebar mode.",
            snippet: "BraisenlySidebarFooter(selectedMode: .{{selectedMode}}, platform: .{{platform}}) { }",
            knobs: [.pick(key: "selectedMode", label: "Mode", options: modeOptions, default: "Files"), .platform()]
        ) { values in
            var v = values
            let mode = BraisenlySidebarMode(rawValue: v.string("selectedMode")) ?? .files, platform = v.platform()
            return AnyView(BraisenlySidebarFooter(selectedMode: mode, platform: platform, onModePickerTap: v.action("onModePickerTap")))
        },
        CatalogEntry(
            id: "sidebar.contextPopover", group: .sidebar, typeName: "BraisenlySidebarContextPopover",
            title: "Sidebar Context Popover", summary: "Mode picker popover shown from the sidebar footer.",
            snippet: "@State private var mode: BraisenlySidebarMode = .files\n@State private var isPresented = true\nBraisenlySidebarContextPopover(selectedMode: $mode, isPresented: $isPresented, platform: .{{platform}})",
            knobs: [.platform()], presentation: .canvas(height: 360)
        ) { values in
            var v = values
            let platform = v.platform()
            return AnyView(StateHost(ContextPopoverState()) { BraisenlySidebarContextPopover(selectedMode: $0.mode, isPresented: $0.isPresented, platform: platform) })
        },
        CatalogEntry(
            id: "sidebar.drawer", group: .sidebar, typeName: "BraisenlySidebarDrawer",
            title: "Sidebar Drawer", summary: "Full sidebar: search header, conversation list, footer and popover.",
            snippet: "@State private var searchText = \"\"\n@State private var mode: BraisenlySidebarMode = .files\n@State private var showPopover = false\nBraisenlySidebarDrawer(searchText: $searchText, selectedMode: $mode, isShowingContextPopover: $showPopover, platform: .{{platform}})",
            knobs: [.platform()], presentation: .canvas(height: 560)
        ) { values in
            var v = values
            let platform = v.platform()
            return AnyView(StateHost(DrawerState()) { BraisenlySidebarDrawer(searchText: $0.searchText, selectedMode: $0.mode, isShowingContextPopover: $0.showPopover, platform: platform) })
        },
        CatalogEntry(
            id: "sidebar.modes", group: .sidebar, typeName: nil,
            title: "Sidebar Modes", summary: "The five BraisenlySidebarMode cases and their symbols.",
            snippet: "BraisenlySidebarMode.allCases.map { ($0.rawValue, $0.icon) }  // showIcons: {{showIcons}}",
            knobs: [.bool(key: "showIcons", label: "Show icons", default: true)]
        ) { values in
            var v = values
            let showIcons = v.bool("showIcons")
            return AnyView(BraisenlyVStack(alignment: .leading, spacing: .m) {
                if showIcons {
                    BraisenlyHStack(spacing: .l) {
                        ForEach(BraisenlySidebarMode.allCases) { BraisenlyIcon(systemName: $0.icon, size: .large, tone: .accent) }
                    }
                }
                BraisenlyPropertyTable(rows: BraisenlySidebarMode.allCases.map { .init(key: $0.rawValue, value: $0.icon) })
            })
        },
    ]
}

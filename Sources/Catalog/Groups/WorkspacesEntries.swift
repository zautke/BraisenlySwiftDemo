import SwiftUI
import BraisenlySwiftUI

nonisolated private struct CompactWorkspaceState {
    var isSidebarOpen = false, isActionSheetPresented = false, isContextPopoverOpen = false
    var searchText = ""; var selectedMode: BraisenlySidebarMode = .files
    var themeID = BraisenlyThemes.liquidGlass.id
}

nonisolated private struct RegularWorkspaceState {
    var isActionSheetPresented = false, isContextPopoverOpen = false
    var searchText = ""; var selectedMode: BraisenlySidebarMode = .files
    var themeID = BraisenlyThemes.liquidGlass.id
}

nonisolated enum WorkspacesEntries {
    private static let themeIDs = BraisenlyThemes.all.map(\.id)

    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "workspaces.compact", group: .workspaces, typeName: "BraisenlyCompactWorkspace",
            title: "Compact Workspace", summary: "Phone-width workspace: document with slide-over sidebar and sheets.",
            snippet: "BraisenlyCompactWorkspace(documentTitle: {{documentTitle}}, documentText: {{documentText}}, isSidebarOpen: $isSidebarOpen, isActionSheetPresented: $isActionSheetPresented, isContextPopoverOpen: $isContextPopoverOpen, searchText: $searchText, selectedMode: $selectedMode, theme: $themeID)",
            knobs: [
                .text(key: "documentTitle", label: "Document title", default: "Home"),
                .text(key: "documentText", label: "Document text", default: Fixtures.documentText),
            ], presentation: .canvas(height: 640)
        ) { values in
            var v = values
            let title = v.string("documentTitle"), text = v.string("documentText")
            return AnyView(StateHost(CompactWorkspaceState()) { s in
                BraisenlyCompactWorkspace(documentTitle: title, documentText: text, isSidebarOpen: s.isSidebarOpen, isActionSheetPresented: s.isActionSheetPresented, isContextPopoverOpen: s.isContextPopoverOpen, searchText: s.searchText, selectedMode: s.selectedMode, theme: s.themeID).frame(width: 390)
            })
        },
        CatalogEntry(
            id: "workspaces.regular", group: .workspaces, typeName: "BraisenlyRegularWorkspace",
            title: "Regular Workspace", summary: "Side-by-side sidebar and document for iPad and Mac widths.",
            snippet: "BraisenlyRegularWorkspace(documentTitle: {{documentTitle}}, documentText: {{documentText}}, platform: .{{platform}}, isActionSheetPresented: $isActionSheetPresented, isContextPopoverOpen: $isContextPopoverOpen, searchText: $searchText, selectedMode: $selectedMode, theme: $themeID)",
            knobs: [
                .text(key: "documentTitle", label: "Document title", default: "Home"),
                .text(key: "documentText", label: "Document text", default: Fixtures.documentText),
                .platform(default: "iPad"),
            ], presentation: .canvas(height: 640)
        ) { values in
            var v = values
            let title = v.string("documentTitle"), text = v.string("documentText"), platform = v.platform()
            return AnyView(StateHost(RegularWorkspaceState()) { s in
                BraisenlyRegularWorkspace(documentTitle: title, documentText: text, platform: platform, isActionSheetPresented: s.isActionSheetPresented, isContextPopoverOpen: s.isContextPopoverOpen, searchText: s.searchText, selectedMode: s.selectedMode, theme: s.themeID)
            })
        },
        CatalogEntry(
            id: "workspaces.mobile", group: .workspaces, typeName: "BraisenlyMobileWorkspaceView",
            title: "Mobile Workspace View", summary: "Self-contained workspace that owns its state and theme.",
            snippet: "BraisenlyMobileWorkspaceView(documentTitle: {{documentTitle}}, documentText: {{documentText}}, initialTheme: \"{{initialTheme}}\", platform: .{{platform}})",
            knobs: [
                .text(key: "documentTitle", label: "Document title", default: "Home"),
                .text(key: "documentText", label: "Document text", default: Fixtures.documentText),
                .pick(key: "initialTheme", label: "Initial theme", options: themeIDs, default: "liquidGlass"),
                .platform(),
            ], presentation: .canvas(height: 640)
        ) { values in
            var v = values
            let title = v.string("documentTitle"), text = v.string("documentText"), theme = v.string("initialTheme"), platform = v.platform()
            return AnyView(BraisenlyMobileWorkspaceView(documentTitle: title, documentText: text, initialTheme: theme, platform: platform).id(theme))
        },
    ]
}

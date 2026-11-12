import SwiftUI
import BraisenlySwiftUI

nonisolated enum DocumentEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "document.chrome", group: .document, typeName: "BraisenlyDocumentChrome",
            title: "Document Chrome", summary: "Top chrome of a document: sidebar toggle, title area, theme and actions.",
            snippet: "@State private var themeID = BraisenlyThemes.liquidGlass.id\nBraisenlyDocumentChrome(theme: $themeID, platform: .{{platform}}, onToggleSidebar: { }, onEdit: { }, onOpenActionSheet: { })",
            knobs: [.platform()], presentation: .canvas(height: 160)
        ) { values in
            var v = values
            let platform = v.platform()
            let toggle = v.action("onToggleSidebar"), edit = v.action("onEdit"), sheet = v.action("onOpenActionSheet")
            return AnyView(StateHost(BraisenlyThemes.liquidGlass.id) { BraisenlyDocumentChrome(theme: $0, platform: platform, onToggleSidebar: toggle, onEdit: edit, onOpenActionSheet: sheet) })
        },
        CatalogEntry(
            id: "document.canvas", group: .document, typeName: "BraisenlyDocumentCanvas",
            title: "Document Canvas", summary: "Reading surface with chrome, title and body text.",
            snippet: "@State private var themeID = BraisenlyThemes.liquidGlass.id\nBraisenlyDocumentCanvas(title: {{title}}, bodyText: {{bodyText}}, theme: $themeID, platform: .{{platform}}, onToggleSidebar: { }, onEdit: { }, onOpenActionSheet: { })",
            knobs: [
                .text(key: "title", label: "Title", default: "Home"),
                .text(key: "bodyText", label: "Body", default: Fixtures.documentText),
                .platform(),
            ], presentation: .canvas(height: 560)
        ) { values in
            var v = values
            let title = v.string("title"), body = v.string("bodyText"), platform = v.platform()
            let toggle = v.action("onToggleSidebar"), edit = v.action("onEdit"), sheet = v.action("onOpenActionSheet")
            return AnyView(StateHost(BraisenlyThemes.liquidGlass.id) { BraisenlyDocumentCanvas(title: title, bodyText: body, theme: $0, platform: platform, onToggleSidebar: toggle, onEdit: edit, onOpenActionSheet: sheet) })
        },
        CatalogEntry(
            id: "document.actionSheet", group: .document, typeName: "BraisenlyDocumentActionSheet",
            title: "Document Action Sheet", summary: "Action sheet content for a document, rendered inline.",
            snippet: "BraisenlyDocumentActionSheet(platform: .{{platform}})",
            knobs: [.platform()], presentation: .canvas(height: 520)
        ) { values in
            var v = values
            let platform = v.platform()
            return AnyView(BraisenlyDocumentActionSheet(platform: platform))
        },
        CatalogEntry(
            id: "document.bottomToolbar", group: .document, typeName: "BraisenlyBottomToolbar",
            title: "Bottom Toolbar", summary: "Browser-style bottom toolbar with tab counter.",
            snippet: "BraisenlyBottomToolbar(tabCount: {{tabCount}}, platform: .{{platform}}, onBack: { }, onForward: { }, onSearch: { }, onAdd: { }, onTabs: { }, onMenu: { })",
            knobs: [.int(key: "tabCount", label: "Tabs", range: 0...150, default: 23), .platform()], presentation: .canvas(height: 120)
        ) { values in
            var v = values
            let tabs = v.int("tabCount"), platform = v.platform()
            return AnyView(BraisenlyBottomToolbar(tabCount: tabs, platform: platform, onBack: v.action("onBack"), onForward: v.action("onForward"), onSearch: v.action("onSearch"), onAdd: v.action("onAdd"), onTabs: v.action("onTabs"), onMenu: v.action("onMenu")))
        },
    ]
}

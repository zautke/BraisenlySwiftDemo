import SwiftUI
import BraisenlySwiftUI

nonisolated enum RowsGroupsEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "rowsGroups.actionRow", group: .rowsGroups, typeName: "BraisenlyActionRow",
            title: "Action Row", summary: "One row of an action sheet, driven by a BraisenlyActionItem.",
            snippet: "BraisenlyActionRow(item: BraisenlyActionItem(id: \"row\", icon: {{icon}}, title: {{title}}, isChecked: {{isChecked}}), platform: .{{platform}})",
            knobs: [
                .text(key: "icon", label: "Icon", default: "pin"),
                .text(key: "title", label: "Title", default: "Pin"),
                .bool(key: "isChecked", label: "Checked", default: false),
                .platform(),
            ]
        ) { values in
            var v = values
            let icon = v.string("icon"), title = v.string("title"), checked = v.bool("isChecked"), platform = v.platform()
            let item = BraisenlyActionItem(id: "row", icon: icon, title: LocalizedStringResource(stringLiteral: title), isChecked: checked)
            return AnyView(BraisenlyActionRow(item: item, platform: platform))
        },
        CatalogEntry(
            id: "rowsGroups.actionGroup", group: .rowsGroups, typeName: "BraisenlyActionGroup",
            title: "Action Group", summary: "Grouped action rows on one card surface.",
            snippet: "BraisenlyActionGroup(items: items.prefix({{itemCount}}), platform: .{{platform}}) { item in }",
            knobs: [.int(key: "itemCount", label: "Items", range: 1...6, default: 4), .platform()]
        ) { values in
            var v = values
            let items = Array(Fixtures.actionItems.prefix(v.int("itemCount"))), platform = v.platform()
            let log = v.action
            return AnyView(BraisenlyActionGroup(items: items, platform: platform) { item in log("action(\(item.id))")() })
        },
        CatalogEntry(
            id: "rowsGroups.conversationRow", group: .rowsGroups, typeName: "BraisenlyConversationRow",
            title: "Conversation Row", summary: "Sidebar conversation row with subtitle, timestamp, pin and selection.",
            snippet: "BraisenlyConversationRow(title: {{title}}, subtitle: {{subtitle}}, timestampText: {{timestampText}}, isSelected: {{isSelected}}, isPinned: {{isPinned}}, platform: .{{platform}}) { }",
            knobs: [
                .text(key: "title", label: "Title", default: "Design review notes"),
                .text(key: "subtitle", label: "Subtitle", default: "Glass belongs on controls…"),
                .text(key: "timestampText", label: "Timestamp", default: "2m"),
                .bool(key: "isSelected", label: "Selected", default: false),
                .bool(key: "isPinned", label: "Pinned", default: false),
                .platform(),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), subtitle = v.optionalString("subtitle"), stamp = v.optionalString("timestampText")
            let selected = v.bool("isSelected"), pinned = v.bool("isPinned"), platform = v.platform()
            return AnyView(BraisenlyConversationRow(title: title, subtitle: subtitle, timestampText: stamp, isSelected: selected, isPinned: pinned, platform: platform, action: v.action("conversationRow.action")))
        },
        CatalogEntry(
            id: "rowsGroups.searchMetadataRow", group: .rowsGroups, typeName: "BraisenlySearchMetadataRow",
            title: "Search Metadata Row", summary: "Fixed metadata strip shown above search results.",
            snippet: "BraisenlySearchMetadataRow()\n    .frame(maxWidth: {{stageWidth}})",
            knobs: [.pick(key: "stageWidth", label: "Stage width", options: ["fill", "375", "760"], default: "fill")],
            snippetValues: ["stageWidth": ["fill": ".infinity"]]
        ) { values in
            var v = values
            let width: CGFloat = switch v.string("stageWidth") { case "375": 375; case "760": 760; default: .infinity }
            return AnyView(BraisenlySearchMetadataRow().frame(maxWidth: width))
        },
        CatalogEntry(
            id: "rowsGroups.expandableSearchResult", group: .rowsGroups, typeName: "BraisenlyExpandableSearchResult",
            title: "Expandable Search Result", summary: "Collapsible search result for a query.",
            snippet: "@State private var isExpanded = false\nBraisenlyExpandableSearchResult(query: {{query}}, platform: .{{platform}}, isExpanded: $isExpanded)",
            knobs: [.text(key: "query", label: "Query", default: "glass"), .platform()]
        ) { values in
            var v = values
            let query = v.string("query"), platform = v.platform()
            return AnyView(StateHost(false) { BraisenlyExpandableSearchResult(query: query, platform: platform, isExpanded: $0) })
        },
    ]
}

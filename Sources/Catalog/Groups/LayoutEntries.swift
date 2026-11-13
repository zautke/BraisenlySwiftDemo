import SwiftUI
import BraisenlySwiftUI

nonisolated enum LayoutEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "layout.vStack", group: .layout, typeName: "BraisenlyVStack", title: "VStack",
            summary: "Vertical stack whose spacing is a theme step.",
            snippet: """
            BraisenlyVStack(alignment: .{{alignment}}, spacing: .{{spacing}}) {
                BraisenlyText("Item 1").braisenlyPadding(.horizontal, .m).braisenlyPadding(.vertical, .xs).braisenlyCapsule()
            }
            """,
            knobs: [.step(), .pick(key: "alignment", label: "Alignment", options: ["leading", "center", "trailing"], default: "center"),
                    .int(key: "itemCount", label: "Items", range: 1...6, default: 3)],
            make: { values in
                var v = values
                let spacing = v.step(), alignment = hAlignment(v.string("alignment")), count = v.int("itemCount")
                return AnyView(BraisenlyVStack(alignment: alignment, spacing: spacing) { items(count) }.frame(maxWidth: .infinity))
            }),
        CatalogEntry(
            id: "layout.hStack", group: .layout, typeName: "BraisenlyHStack", title: "HStack",
            summary: "Horizontal stack whose spacing is a theme step.",
            snippet: """
            BraisenlyHStack(alignment: .{{alignment}}, spacing: .{{spacing}}) {
                BraisenlyText("Item 1").braisenlyPadding(.horizontal, .m).braisenlyPadding(.vertical, .xs).braisenlyCapsule()
            }
            """,
            knobs: [.step(), .pick(key: "alignment", label: "Alignment", options: ["top", "center", "bottom"], default: "center"),
                    .int(key: "itemCount", label: "Items", range: 1...6, default: 3)],
            make: { values in
                var v = values
                let spacing = v.step(), alignment = vAlignment(v.string("alignment")), count = v.int("itemCount")
                return AnyView(BraisenlyHStack(alignment: alignment, spacing: spacing) { items(count) })
            }),
        CatalogEntry(
            id: "layout.zStack", group: .layout, typeName: "BraisenlyZStack", title: "ZStack",
            summary: "Layered stack aligned within its bounds.",
            snippet: """
            BraisenlyZStack(alignment: .{{alignment}}) {
                BraisenlyText("Layer 1").braisenlyPadding(.all, .xl).braisenlyCapsule()
            }
            """,
            knobs: [.pick(key: "alignment", label: "Alignment", options: ["topLeading", "center", "bottomTrailing"], default: "center"),
                    .int(key: "layerCount", label: "Layers", range: 1...4, default: 3)],
            make: { values in
                var v = values
                let alignment = zAlignment(v.string("alignment")), count = v.int("layerCount")
                let pads: [BraisenlyStep] = [.xl, .l, .m, .s]
                return AnyView(BraisenlyZStack(alignment: alignment) {
                    ForEach(0..<count, id: \.self) { i in
                        BraisenlyText("Layer \(i + 1)").braisenlyPadding(.all, pads[i]).braisenlyCapsule()
                    }
                }.frame(width: 240, height: 160))
            }),
        CatalogEntry(
            id: "layout.scroll", group: .layout, typeName: "BraisenlyScroll", title: "Scroll",
            summary: "Scroll container over one or both axes.",
            snippet: """
            BraisenlyScroll(.{{axis}}, showsIndicators: {{showsIndicators}}) {
                BraisenlyVStack { BraisenlyText("Item 1").braisenlyPadding(.horizontal, .m).braisenlyPadding(.vertical, .xs).braisenlyCapsule() }
            }
            """,
            knobs: [.pick(key: "axis", label: "Axis", options: ["vertical", "horizontal"], default: "vertical"),
                    .int(key: "itemCount", label: "Items", range: 5...50, default: 20),
                    .bool(key: "showsIndicators", label: "Shows indicators", default: true)],
            make: { values in
                var v = values
                let horizontal = v.string("axis") == "horizontal", count = v.int("itemCount"), shows = v.bool("showsIndicators")
                return AnyView(Group {
                    if horizontal {
                        BraisenlyScroll(.horizontal, showsIndicators: shows) { BraisenlyHStack { items(count) } }
                    } else {
                        BraisenlyScroll(.vertical, showsIndicators: shows) { BraisenlyVStack { items(count) } }
                    }
                }.braisenlyPadding(.all, .m).frame(maxWidth: .infinity).frame(height: 240))
            }),
        CatalogEntry(
            id: "layout.spacer", group: .layout, typeName: "BraisenlySpacer", title: "Spacer",
            summary: "Flexible space with an optional theme-step minimum length.",
            snippet: """
            BraisenlyHStack {
                BraisenlyText("Leading")
                BraisenlySpacer(minLength: .{{minLength}})
                BraisenlyText("Trailing")
            }
            """,
            knobs: [.pick(key: "minLength", label: "Min length", options: ["none", "zero", "xs", "s", "m", "l", "xl"], default: "none")],
            make: { values in
                var v = values
                let min = BraisenlyStep(rawValue: v.string("minLength"))
                return AnyView(BraisenlyHStack {
                    BraisenlyText("Leading")
                    BraisenlySpacer(minLength: min)
                    BraisenlyText("Trailing")
                })
            }),
        CatalogEntry(
            id: "layout.divider", group: .layout, typeName: "BraisenlyDivider", title: "Divider",
            summary: "Hairline separator in the theme divider color.",
            snippet: """
            // {{context}}
            BraisenlyDivider()
            """,
            knobs: [.pick(key: "context", label: "Context", options: ["vertical stack", "horizontal stack"], default: "vertical stack")],
            make: { values in
                var v = values
                let horizontal = v.string("context") == "horizontal stack"
                return AnyView(Group {
                    if horizontal {
                        BraisenlyHStack { BraisenlyText("Left"); BraisenlyDivider(); BraisenlyText("Right") }.frame(height: 48)
                    } else {
                        BraisenlyVStack { BraisenlyText("Above"); BraisenlyDivider(); BraisenlyText("Below") }
                    }
                })
            }),
        CatalogEntry(
            id: "layout.text", group: .layout, typeName: "BraisenlyText", title: "Text",
            summary: "Themed text with a named style and tone.",
            snippet: "BraisenlyText({{text}}, style: .{{style}}, tone: .{{tone}})",
            knobs: [.text(key: "text", label: "Text", default: "Braisenly"), .textStyle(), .tone()],
            make: { values in
                var v = values
                let text = v.string("text"), style = v.textStyle(), tone = v.tone()
                return AnyView(BraisenlyText(text, style: style, tone: tone))
            }),
        CatalogEntry(
            id: "layout.icon", group: .layout, typeName: "BraisenlyIcon", title: "Icon",
            summary: "Themed SF Symbol with a size and tone.",
            snippet: "BraisenlyIcon(systemName: {{systemName}}, size: .{{size}}, tone: .{{tone}})",
            knobs: [.text(key: "systemName", label: "Symbol", default: "sparkles"),
                    .pick(key: "size", label: "Size", options: ["small", "medium", "large"], default: "large"), .tone()],
            make: { values in
                var v = values
                let name = v.string("systemName"), size = BraisenlyIconSize(rawValue: v.string("size")) ?? .medium, tone = v.tone()
                return AnyView(BraisenlyIcon(systemName: name, size: size, tone: tone))
            }),
        CatalogEntry(
            id: "layout.grid", group: .layout, typeName: "BraisenlyGrid", title: "Grid",
            summary: "Adaptive grid that fits as many columns as the minimum width allows.",
            snippet: """
            BraisenlyGrid(minimumColumnWidth: {{minimumColumnWidth}}, spacing: .{{spacing}}) {
                BraisenlyText("1").braisenlyPadding(.horizontal, .m).braisenlyPadding(.vertical, .xs).braisenlyCapsule()
            }
            """,
            knobs: [.double(key: "minimumColumnWidth", label: "Min column width", range: 40...320, step: 10, default: 120),
                    .int(key: "itemCount", label: "Items", range: 1...24, default: 9), .step()],
            make: { values in
                var v = values
                let width = v.double("minimumColumnWidth"), count = v.int("itemCount"), spacing = v.step()
                return AnyView(BraisenlyGrid(minimumColumnWidth: width, spacing: spacing) {
                    ForEach(1...count, id: \.self) { BraisenlyText("\($0)").braisenlyPadding(.horizontal, .m).braisenlyPadding(.vertical, .xs).braisenlyCapsule() }
                })
            }),
        CatalogEntry(
            id: "layout.splitView", group: .layout, typeName: "BraisenlySplitView", title: "Split View",
            summary: "Themed two-column navigation split with a preferred compact column.",
            snippet: """
            @State private var column: NavigationSplitViewColumn = .{{compactColumn}}

            BraisenlySplitView(preferredCompactColumn: $column, extendsDetailBackground: {{extendsDetailBackground}}) {
                BraisenlyNavRow(title: "Item", isSelected: false) { }
            } detail: {
                BraisenlyEmptyState(title: "Detail")
            }
            """,
            knobs: [.pick(key: "compactColumn", label: "Compact column", options: ["sidebar", "detail"], default: "sidebar"),
                    .bool(key: "extendsDetailBackground", label: "Extends detail background", default: false)],
            presentation: .canvas(height: 420),
            make: { values in
                var v = values
                let column: NavigationSplitViewColumn = v.string("compactColumn") == "detail" ? .detail : .sidebar
                let extends = v.bool("extendsDetailBackground")
                let nav1 = v.action("sidebar.row1"), nav2 = v.action("sidebar.row2"), nav3 = v.action("sidebar.row3")
                return AnyView(BraisenlySplitView(
                    preferredCompactColumn: Binding(get: { column }, set: { _ in }),
                    extendsDetailBackground: extends
                ) {
                    BraisenlyVStack(alignment: .leading, spacing: .xs) {
                        BraisenlyNavRow(title: "Inbox", systemImage: "tray", isSelected: true, action: nav1)
                        BraisenlyNavRow(title: "Drafts", systemImage: "doc", isSelected: false, action: nav2)
                        BraisenlyNavRow(title: "Archive", systemImage: "archivebox", isSelected: false, action: nav3)
                    }
                } detail: {
                    BraisenlyEmptyState(title: "Nothing selected", message: "Pick an item in the sidebar.", systemImage: "sidebar.leading")
                })
            }),
    ]

    @MainActor @ViewBuilder private static func items(_ count: Int) -> some View {
        ForEach(1...count, id: \.self) { BraisenlyText("Item \($0)").braisenlyPadding(.horizontal, .m).braisenlyPadding(.vertical, .xs).braisenlyCapsule() }
    }

    private static func hAlignment(_ raw: String) -> HorizontalAlignment {
        switch raw { case "leading": .leading; case "trailing": .trailing; default: .center }
    }
    private static func vAlignment(_ raw: String) -> VerticalAlignment {
        switch raw { case "top": .top; case "bottom": .bottom; default: .center }
    }
    private static func zAlignment(_ raw: String) -> Alignment {
        switch raw { case "topLeading": .topLeading; case "bottomTrailing": .bottomTrailing; default: .center }
    }
}

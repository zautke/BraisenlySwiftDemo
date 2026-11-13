import SwiftUI
import BraisenlySwiftUI

nonisolated enum IndicatorsEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "indicators.pulseIndicator", group: .indicators, typeName: "BraisenlyPulseIndicator",
            title: "Pulse Indicator", summary: "Animated activity dot with a label, used while a model responds.",
            snippet: "BraisenlyPulseIndicator(label: {{label}})",
            knobs: [.text(key: "label", label: "Label", default: "Thinking…")]
        ) { values in
            var v = values
            let label = v.string("label")
            return AnyView(BraisenlyPulseIndicator(label: label))
        },
        CatalogEntry(
            id: "indicators.tabCounterBadge", group: .indicators, typeName: "BraisenlyTabCounterBadge",
            title: "Tab Counter Badge", summary: "Rounded badge showing an open-tab count.",
            snippet: "BraisenlyTabCounterBadge(count: {{count}})",
            knobs: [.int(key: "count", label: "Count", range: 0...150, default: 23)]
        ) { values in
            var v = values
            let count = v.int("count")
            return AnyView(BraisenlyTabCounterBadge(count: count))
        },
        CatalogEntry(
            id: "indicators.avatarBadge", group: .indicators, typeName: "BraisenlyAvatarBadge",
            title: "Avatar Badge", summary: "Circular symbol avatar with themed or explicit colours.",
            snippet: "BraisenlyAvatarBadge(systemName: {{systemName}}, foregroundColor: {{foregroundColor}}, backgroundColor: {{backgroundColor}}, borderColor: {{borderColor}}, size: {{size}}, iconSize: {{iconSize}})",
            knobs: [
                .text(key: "systemName", label: "System name", default: "sparkles"),
                .color(key: "foregroundColor", label: "Foreground", options: ColorToken.allCases, default: .accentTeal),
                .color(key: "backgroundColor", label: "Background", options: ColorToken.allCases, default: .surfaceElevated),
                .color(key: "borderColor", label: "Border", options: ColorToken.allCases, default: .borderSubtle),
                .double(key: "size", label: "Size", range: 16...96, step: 2, default: 56),
                .double(key: "iconSize", label: "Icon size", range: 8...48, step: 1, default: 24),
            ]
        ) { values in
            var v = values
            let name = v.string("systemName")
            let fg = v.color("foregroundColor"), bg = v.color("backgroundColor"), border = v.color("borderColor")
            let size = v.double("size"), icon = v.double("iconSize")
            return AnyView(BraisenlyAvatarBadge(systemName: name, foregroundColor: fg, backgroundColor: bg, borderColor: border, size: size, iconSize: icon))
        },
        CatalogEntry(
            id: "indicators.highlightedText", group: .indicators, typeName: "BraisenlyHighlightedText",
            title: "Highlighted Text", summary: "Text with every occurrence of a query highlighted.",
            snippet: "BraisenlyHighlightedText({{text}}, highlight: {{highlight}}, font: BraisenlyTextStyle.{{font}}.font(in: theme.typography), baseColor: {{baseColor}})",
            knobs: [
                .text(key: "text", label: "Text", default: "Liquid Glass belongs on controls"),
                .text(key: "highlight", label: "Highlight", default: "glass"),
                Knob.textStyle(key: "font", label: "Font"),
                .color(key: "baseColor", label: "Base colour", options: ColorToken.themeTokens, default: .textPrimary),
            ]
        ) { values in
            var v = values
            let text = v.string("text"), highlight = v.string("highlight")
            let font = v.textStyle("font").font(in: v.theme.typography), base = v.color("baseColor")
            return AnyView(BraisenlyHighlightedText(text, highlight: highlight, font: font, baseColor: base))
        },
        CatalogEntry(
            id: "indicators.colorSwatch", group: .indicators, typeName: "BraisenlyColorSwatch",
            title: "Color Swatch", summary: "Selectable colour chip with a name and optional detail.",
            snippet: "BraisenlyColorSwatch(color: {{color}}, name: {{name}}, detail: {{detail}}, isSelected: {{isSelected}}) { }",
            knobs: [
                .color(key: "color", label: "Colour", options: ColorToken.allCases, default: .accentTeal),
                .text(key: "name", label: "Name", default: "accentTeal"),
                .text(key: "detail", label: "Detail", default: "#2AA198"),
                .bool(key: "isSelected", label: "Selected", default: false),
            ]
        ) { values in
            var v = values
            let color = v.color("color"), name = v.string("name"), detail = v.optionalString("detail")
            let selected = v.bool("isSelected")
            return AnyView(BraisenlyColorSwatch(color: color, name: name, detail: detail, isSelected: selected, action: v.action("colorSwatch.action")))
        },
    ]
}

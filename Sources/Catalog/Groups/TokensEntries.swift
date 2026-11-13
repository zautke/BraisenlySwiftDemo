import SwiftUI
import BraisenlySwiftUI

nonisolated enum TokensEntries {
    static let entries: [CatalogEntry] = [solarizedPalette, colors, typography, metrics, platformDensity, themeDefinitions]

    private static let themeIDs = BraisenlyThemes.all.map(\.id)

    private static let paletteSnippet = """
        BraisenlyGrid(minimumColumnWidth: {{minColumnWidth}}, spacing: .m) {
            BraisenlyColorSwatch(color: BraisenlyDS.Solarized.base03, name: {{showNames}} ? "base03" : "")
            BraisenlyColorSwatch(color: BraisenlyDS.Solarized.red, name: {{showNames}} ? "red" : "")
            BraisenlyColorSwatch(color: BraisenlyDS.Solarized.blue, name: {{showNames}} ? "blue" : "")
        }
        """

    private static let solarizedPalette = CatalogEntry(
        id: "tokens.solarizedPalette", group: .tokens, typeName: nil,
        title: "Solarized Palette", summary: "The 16 Solarized constants shipped by the package.",
        snippet: paletteSnippet,
        knobs: [
            .double(key: "minColumnWidth", label: "Min column width", range: 48...240, step: 8, default: 96),
            .bool(key: "showNames", label: "Show names", default: true),
        ],
        make: { values in
            var v = values
            let minWidth = v.double("minColumnWidth")
            let showNames = v.bool("showNames")
            let theme = v.theme
            return AnyView(BraisenlyGrid(minimumColumnWidth: minWidth, spacing: .m) {
                ForEach(ColorToken.solarized, id: \.self) { token in
                    BraisenlyColorSwatch(color: token.color(in: theme), name: showNames ? token.rawValue : "")
                }
            })
        })

    private static let colors = CatalogEntry(
        id: "tokens.colors", group: .tokens, typeName: nil,
        title: "Color Tokens", summary: "The 20 semantic color tokens of a theme.",
        snippet: """
        BraisenlyGrid(minimumColumnWidth: {{minColumnWidth}}, spacing: .m) {
            BraisenlyColorSwatch(color: theme.colors.accentTeal, name: {{showNames}} ? "accentTeal" : "")
            BraisenlyColorSwatch(color: theme.colors.danger, name: {{showNames}} ? "danger" : "")
        }
        .braisenlyTheme(BraisenlyThemes.theme(withID: "{{theme}}"))
        """,
        knobs: [
            .double(key: "minColumnWidth", label: "Min column width", range: 48...240, step: 8, default: 96),
            .bool(key: "showNames", label: "Show names", default: true),
            .pick(key: "theme", label: "Theme", options: ["app"] + themeIDs, default: "app"),
        ],
        snippetValues: ["theme": ["app": "{{appThemeID}}"]],
        make: { values in
            var v = values
            let minWidth = v.double("minColumnWidth")
            let showNames = v.bool("showNames")
            let themeID = v.string("theme")
            let theme = themeID == "app" ? v.theme : BraisenlyThemes.theme(withID: themeID)
            let stage = BraisenlyGrid(minimumColumnWidth: minWidth, spacing: .m) {
                ForEach(ColorToken.themeTokens, id: \.self) { token in
                    BraisenlyColorSwatch(color: token.color(in: theme), name: showNames ? token.rawValue : "")
                }
            }
            return themeID == "app" ? AnyView(stage) : AnyView(stage.braisenlyTheme(theme))
        })

    private static let typography = CatalogEntry(
        id: "tokens.typography", group: .tokens, typeName: nil,
        title: "Typography", summary: "Every BraisenlyTextStyle rendered with the sample text.",
        snippet: "BraisenlyText({{sample}}, style: .documentTitle)",
        knobs: [.text(key: "sample", label: "Sample", default: "The quick brown fox jumps over the lazy dog")],
        make: { values in
            var v = values
            let sample = v.string("sample")
            return AnyView(BraisenlyVStack(alignment: .leading, spacing: .m) {
                ForEach(BraisenlyTextStyle.allCases, id: \.self) { style in
                    BraisenlyVStack(alignment: .leading, spacing: .xs) {
                        BraisenlyText(style.rawValue, style: .metadata, tone: .secondary)
                        BraisenlyText(sample, style: style)
                    }
                }
            })
        })

    private static let metrics = CatalogEntry(
        id: "tokens.metrics", group: .tokens, typeName: nil,
        title: "Metrics & Scales", summary: "Scalar layout metrics plus the spacing and radius scales.",
        snippet: """
        BraisenlyHStack(spacing: .{{step}}) {
            BraisenlyText("A").braisenlyCapsule()
            BraisenlyText("B").braisenlyCapsule()
        }
        BraisenlyText("Card").braisenlyPadding(.all, .{{step}}).braisenlyCard(cornerRadius: theme.metrics.radius[.{{step}}])
        """,
        knobs: [.step(key: "step", label: "Step")],
        make: { values in
            var v = values
            let step = v.step("step")
            let m = v.theme.metrics
            let rows = [
                BraisenlyPropertyTable.Row(key: "circleButtonSize", value: "\(m.circleButtonSize)"),
                BraisenlyPropertyTable.Row(key: "toolbarHeight", value: "\(m.toolbarHeight)"),
                BraisenlyPropertyTable.Row(key: "rowHeight", value: "\(m.rowHeight)"),
                BraisenlyPropertyTable.Row(key: "sidebarWidthRatio", value: "\(m.sidebarWidthRatio)"),
                BraisenlyPropertyTable.Row(key: "hairline", value: "\(m.hairline)"),
                BraisenlyPropertyTable.Row(key: "sheetCornerRadius", value: "\(m.sheetCornerRadius)"),
                BraisenlyPropertyTable.Row(key: "grabberSize", value: "\(m.grabberSize.width) x \(m.grabberSize.height)"),
                BraisenlyPropertyTable.Row(key: "spacing[\(step.rawValue)]", value: "\(m.spacing[step])"),
                BraisenlyPropertyTable.Row(key: "radius[\(step.rawValue)]", value: "\(m.radius[step])"),
            ]
            return AnyView(BraisenlyVStack(alignment: .leading, spacing: .l) {
                BraisenlyPropertyTable(rows: rows)
                BraisenlyHStack(spacing: step) {
                    BraisenlyText("A").braisenlyCapsule()
                    BraisenlyText("B").braisenlyCapsule()
                }
                BraisenlyText("Card")
                    .braisenlyPadding(.all, step)
                    .braisenlyCard(cornerRadius: m.radius[step])
            })
        })

    private static let platformDensity = CatalogEntry(
        id: "tokens.platformDensity", group: .tokens, typeName: nil,
        title: "Platform Density", summary: "Control size, row height and content width per platform.",
        snippet: "let density: BraisenlyPlatform = .{{platform}}",
        knobs: [.platform(default: "iPad")],
        make: { values in
            var v = values
            let platform = v.platform()
            let maxWidth = platform.contentMaxWidth
            return AnyView(BraisenlyPropertyTable(rows: [
                .init(key: "controlSize", value: "\(platform.controlSize)"),
                .init(key: "rowHeight", value: "\(platform.rowHeight)"),
                .init(key: "contentMaxWidth", value: maxWidth.isInfinite ? "infinity" : "\(maxWidth)"),
            ]))
        })

    private static let themeDefinitions = CatalogEntry(
        id: "tokens.themeDefinitions", group: .tokens, typeName: nil,
        title: "Theme Definitions", summary: "Identity, color scheme and surface style of a built-in theme.",
        snippet: "let definition = BraisenlyThemes.theme(withID: \"{{theme}}\")",
        knobs: [.pick(key: "theme", label: "Theme", options: themeIDs, default: "liquidGlass")],
        make: { values in
            var v = values
            let t = BraisenlyThemes.theme(withID: v.string("theme"))
            let scheme: String = switch t.colorScheme {
            case .light?: "light"
            case .dark?: "dark"
            default: "system"
            }
            let surface: String = if case .glass = t.surface { "glass" } else { "solid" }
            return AnyView(BraisenlyPropertyTable(rows: [
                .init(key: "id", value: t.id),
                .init(key: "name", value: t.name),
                .init(key: "symbolName", value: t.symbolName),
                .init(key: "colorScheme", value: scheme),
                .init(key: "surface", value: surface),
            ]))
        })
}

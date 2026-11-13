import SwiftUI
import BraisenlySwiftUI

nonisolated enum ModifiersEntries {
    private static let roles = ["content", "control", "chrome"]

    nonisolated private static func role(_ name: String) -> BraisenlySurfaceRole {
        switch name {
        case "control": .control
        case "chrome": .chrome
        default: .content
        }
    }

    nonisolated private static func edges(_ name: String) -> Edge.Set {
        switch name {
        case "horizontal": .horizontal
        case "vertical": .vertical
        case "top": .top
        case "bottom": .bottom
        case "leading": .leading
        case "trailing": .trailing
        default: .all
        }
    }

    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "modifiers.braisenlyCard", group: .modifiers, typeName: "BraisenlyCardModifier",
            title: "braisenlyCard", summary: "Rounded surface: solid fill and hairline, or glass for control and chrome roles.",
            snippet: """
            BraisenlyText({{content}}, style: .bodyReading)
                .braisenlyPadding(.all, .l)
                .braisenlyCard(cornerRadius: {{cornerRadius}}, fill: {{fill}}, role: .{{role}})
            """,
            knobs: [
                .text(key: "content", label: "Content", default: "Card content"),
                .double(key: "cornerRadius", label: "Corner radius", range: 0...48, step: 1, default: 20),
                .color(key: "fill", label: "Fill", options: ColorToken.themeTokens, default: .surfaceElevated),
                .pick(key: "role", label: "Role", options: roles, default: "content"),
            ],
            make: { values in
                var v = values
                let content = v.string("content")
                let radius = v.double("cornerRadius")
                let fill = v.color("fill")
                let role = role(v.string("role"))
                return AnyView(
                    BraisenlyText(content, style: .bodyReading)
                        .braisenlyPadding(.all, .l)
                        .braisenlyCard(cornerRadius: radius, fill: fill, role: role)
                )
            }
        ),
        CatalogEntry(
            id: "modifiers.braisenlyCapsule", group: .modifiers, typeName: "BraisenlyCapsuleModifier",
            title: "braisenlyCapsule", summary: "Capsule surface: solid fill, stroke and shadow, or glass for control and chrome roles.",
            snippet: """
            BraisenlyText({{content}})
                .braisenlyPadding(.all, .m)
                .braisenlyCapsule(fill: {{fill}}, role: .{{role}})
            """,
            knobs: [
                .text(key: "content", label: "Content", default: "Capsule"),
                .color(key: "fill", label: "Fill", options: ColorToken.themeTokens, default: .surfaceElevated),
                .pick(key: "role", label: "Role", options: roles, default: "control"),
            ],
            make: { values in
                var v = values
                let content = v.string("content")
                let fill = v.color("fill")
                let role = role(v.string("role"))
                return AnyView(
                    BraisenlyText(content)
                        .braisenlyPadding(.all, .m)
                        .braisenlyCapsule(fill: fill, role: role)
                )
            }
        ),
        CatalogEntry(
            id: "modifiers.braisenlyPadding", group: .modifiers, typeName: nil,
            title: "braisenlyPadding", summary: "Padding resolved from the theme spacing scale.",
            snippet: """
            BraisenlyText("Padded")
                .braisenlyPadding(.{{edges}}, .{{step}})
                .braisenlyCapsule()
            """,
            knobs: [
                .pick(key: "edges", label: "Edges", options: ["all", "horizontal", "vertical", "top", "bottom", "leading", "trailing"], default: "all"),
                Knob.step(key: "step", label: "Step"),
            ],
            make: { values in
                var v = values
                let edges = edges(v.string("edges"))
                let step = v.step("step")
                return AnyView(
                    BraisenlyText("Padded")
                        .braisenlyPadding(edges, step)
                        .braisenlyCapsule()
                )
            }
        ),
        CatalogEntry(
            id: "modifiers.braisenlyTheme", group: .modifiers, typeName: nil,
            title: "braisenlyTheme", summary: "Sets the environment theme for one subtree only; the rest of the app keeps its theme.",
            snippet: """
            BraisenlyVStack(spacing: .m) {
                BraisenlyStatusCard(title: "Model ready", subtitle: "Scoped theme", systemImage: "checkmark.seal")
                BraisenlyCircleIconButton(systemName: "plus", accessibilityLabel: "Add") {}
            }
            .braisenlyTheme(BraisenlyThemes.theme(withID: "{{theme}}"))
            """,
            knobs: [
                .pick(key: "theme", label: "Theme", options: ["liquidGlass", "solarizedLight", "solarizedDark"], default: "solarizedDark"),
            ],
            make: { values in
                var v = values
                let theme = BraisenlyThemes.theme(withID: v.string("theme"))
                let add = v.action("add")
                return AnyView(
                    BraisenlyVStack(spacing: .m) {
                        BraisenlyStatusCard(title: "Model ready", subtitle: "Scoped theme", systemImage: "checkmark.seal")
                        BraisenlyCircleIconButton(systemName: "plus", accessibilityLabel: "Add", action: add)
                    }
                    .braisenlyPadding(.all, .l)
                    .background(theme.colors.backgroundPrimary)
                    .braisenlyTheme(theme)
                )
            }
        ),
        CatalogEntry(
            id: "modifiers.glassSurfaces", group: .modifiers, typeName: nil,
            title: "Glass surfaces", summary: "A card and a capsule under a theme copy whose surface is overridden; glass(for:) decides per role.",
            snippet: """
            var themed = theme
            themed.surface = {{surface}}
            BraisenlyVStack(spacing: .l) {
                BraisenlyText("Card").braisenlyPadding(.all, .l).braisenlyCard(role: .{{role}})
                BraisenlyText("Capsule").braisenlyPadding(.all, .m).braisenlyCapsule(role: .{{role}})
            }
            .braisenlyTheme(themed)
            """,
            knobs: [
                .pick(key: "surface", label: "Surface", options: ["glass", "solid"], default: "glass"),
                .pick(key: "glass", label: "Glass", options: ["regular", "clear", "identity"], default: "regular"),
                .pick(key: "role", label: "Role", options: roles, default: "control"),
            ],
            snippetValues: ["surface": ["glass": ".glass(.{{glass}})", "solid": ".solid"]],
            make: { values in
                var v = values
                let surface = v.string("surface")
                let glass = v.string("glass")
                let role = role(v.string("role"))
                var themed = v.theme
                themed.surface = switch (surface, glass) {
                case ("solid", _): .solid
                case (_, "clear"): .glass(.clear)
                case (_, "identity"): .glass(.identity)
                default: .glass(.regular)
                }
                let stageTheme = themed
                return AnyView(
                    BraisenlyVStack(spacing: .l) {
                        BraisenlyText("Card").braisenlyPadding(.all, .l).braisenlyCard(role: role)
                        BraisenlyText("Capsule").braisenlyPadding(.all, .m).braisenlyCapsule(role: role)
                    }
                    .braisenlyPadding(.all, .xl)
                    .braisenlyTheme(stageTheme)
                )
            }
        ),
        CatalogEntry(
            id: "modifiers.braisenlySheetBackground", group: .modifiers, typeName: nil,
            title: "braisenlySheetBackground", summary: "Sheet styling: theme corner radius, solid sheet fill on solid themes, system glass otherwise.",
            snippet: """
            BraisenlyButton("Present sheet") { isPresented.toggle() }
                .sheet(isPresented: $isPresented) {
                    BraisenlyVStack(spacing: .m) {
                        BraisenlyText({{title}})
                        BraisenlyButton("Close") { isPresented = false }
                    }
                    .braisenlyPadding(.all, .xl)
                    .braisenlySheetBackground()
                }
            """,
            knobs: [
                .text(key: "title", label: "Title", default: "Sheet"),
            ],
            make: { values in
                var v = values
                let title = v.string("title")
                return AnyView(
                    StateHost(false) { isPresented in
                        BraisenlyButton("Present sheet") { isPresented.wrappedValue.toggle() }
                            .sheet(isPresented: isPresented) {
                                BraisenlyVStack(spacing: .m) {
                                    BraisenlyText(title)
                                    BraisenlyButton("Close") { isPresented.wrappedValue = false }
                                }
                                .braisenlyPadding(.all, .xl)
                                .braisenlySheetBackground()
                            }
                    }
                )
            }
        ),
    ]
}

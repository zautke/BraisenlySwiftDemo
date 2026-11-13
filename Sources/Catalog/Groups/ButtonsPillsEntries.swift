import SwiftUI
import BraisenlySwiftUI

nonisolated enum ButtonsPillsEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "buttonsPills.button", group: .buttonsPills, typeName: "BraisenlyButton",
            title: "Button", summary: "Standard or prominent themed button with optional leading symbol.",
            snippet: "BraisenlyButton({{title}}, systemImage: {{systemImage}}, prominence: .{{prominence}}) { }",
            knobs: [
                .text(key: "title", label: "Title", default: "Continue"),
                .text(key: "systemImage", label: "System image", default: "arrow.right"),
                .pick(key: "prominence", label: "Prominence", options: ["standard", "prominent"], default: "standard"),
            ]
        ) { values in
            var v = values
            let title = v.string("title")
            let image = v.optionalString("systemImage")
            let prominence: BraisenlyButtonProminence = v.string("prominence") == "prominent" ? .prominent : .standard
            return AnyView(BraisenlyButton(title, systemImage: image, prominence: prominence, action: v.action("button.action")))
        },
        CatalogEntry(
            id: "buttonsPills.circleIconButton", group: .buttonsPills, typeName: "BraisenlyCircleIconButton",
            title: "Circle Icon Button", summary: "Round icon-only button.",
            snippet: "BraisenlyCircleIconButton(systemName: {{systemName}}, accessibilityLabel: {{accessibilityLabel}}, iconSize: {{iconSize}}, platform: .{{platform}}) { }",
            knobs: [
                .text(key: "systemName", label: "System name", default: "plus"),
                .text(key: "accessibilityLabel", label: "Accessibility label", default: "Add"),
                .double(key: "iconSize", label: "Icon size", range: 10...32, step: 1, default: 18),
                .platform(),
            ]
        ) { values in
            var v = values
            let name = v.string("systemName")
            let label = v.string("accessibilityLabel")
            let size = v.double("iconSize")
            let platform = v.platform()
            return AnyView(BraisenlyCircleIconButton(systemName: name, accessibilityLabel: LocalizedStringResource(stringLiteral: label), iconSize: size, platform: platform, action: v.action("circleIconButton.action")))
        },
        CatalogEntry(
            id: "buttonsPills.toolbarIconButton", group: .buttonsPills, typeName: "BraisenlyToolbarIconButton",
            title: "Toolbar Icon Button", summary: "Icon button for toolbars, with enabled state.",
            snippet: "BraisenlyToolbarIconButton(systemName: {{systemName}}, label: {{label}}, isEnabled: {{isEnabled}}) { }",
            knobs: [
                .text(key: "systemName", label: "System name", default: "square.and.arrow.up"),
                .text(key: "label", label: "Label", default: "Share"),
                .bool(key: "isEnabled", label: "Enabled", default: true),
            ]
        ) { values in
            var v = values
            let name = v.string("systemName")
            let label = v.string("label")
            let enabled = v.bool("isEnabled")
            return AnyView(BraisenlyToolbarIconButton(systemName: name, label: LocalizedStringResource(stringLiteral: label), isEnabled: enabled, action: v.action("toolbarIconButton.action")))
        },
        CatalogEntry(
            id: "buttonsPills.sendStopButton", group: .buttonsPills, typeName: "BraisenlySendStopButton",
            title: "Send / Stop Button", summary: "Composer button that switches between send and stop.",
            snippet: "BraisenlySendStopButton(isResponding: {{isResponding}}, canSend: {{canSend}}, size: {{size}}, onSend: { }, onCancel: { })",
            knobs: [
                .bool(key: "isResponding", label: "Responding", default: false),
                .bool(key: "canSend", label: "Can send", default: true),
                .double(key: "size", label: "Size", range: 24...72, step: 2, default: 44),
            ]
        ) { values in
            var v = values
            let responding = v.bool("isResponding")
            let canSend = v.bool("canSend")
            let size = v.double("size")
            return AnyView(BraisenlySendStopButton(isResponding: responding, canSend: canSend, size: size, onSend: v.action("sendStopButton.onSend"), onCancel: v.action("sendStopButton.onCancel")))
        },
        CatalogEntry(
            id: "buttonsPills.dualActionPill", group: .buttonsPills, typeName: "BraisenlyDualActionPill",
            title: "Dual Action Pill", summary: "Capsule with edit and more actions.",
            snippet: "BraisenlyDualActionPill(platform: .{{platform}}, onEdit: { }, onMore: { })",
            knobs: [.platform()]
        ) { values in
            var v = values
            let platform = v.platform()
            return AnyView(BraisenlyDualActionPill(platform: platform, onEdit: v.action("dualActionPill.onEdit"), onMore: v.action("dualActionPill.onMore")))
        },
        CatalogEntry(
            id: "buttonsPills.messageActionPill", group: .buttonsPills, typeName: "BraisenlyMessageActionPill",
            title: "Message Action Pill", summary: "Copy and regenerate actions under a chat message.",
            snippet: "BraisenlyMessageActionPill(isCopied: {{isCopied}}, canRegenerate: {{canRegenerate}}, onCopy: { }, onRegenerate: { })",
            knobs: [
                .bool(key: "isCopied", label: "Copied", default: false),
                .bool(key: "canRegenerate", label: "Can regenerate", default: true),
            ]
        ) { values in
            var v = values
            let copied = v.bool("isCopied")
            let canRegenerate = v.bool("canRegenerate")
            return AnyView(BraisenlyMessageActionPill(isCopied: copied, canRegenerate: canRegenerate, onCopy: v.action("messageActionPill.onCopy"), onRegenerate: v.action("messageActionPill.onRegenerate")))
        },
        CatalogEntry(
            id: "buttonsPills.modelPill", group: .buttonsPills, typeName: "BraisenlyModelPill",
            title: "Model Pill", summary: "Capsule naming the active model; tappable or static.",
            snippet: "BraisenlyModelPill(title: {{title}}, systemImage: {{systemImage}}) { }",
            knobs: [
                .text(key: "title", label: "Title", default: "LFM3 1.7B"),
                .text(key: "systemImage", label: "System image", default: "cpu"),
                .bool(key: "tappable", label: "Tappable", default: true),
            ]
        ) { values in
            var v = values
            let title = v.string("title")
            let image = v.string("systemImage")
            let tappable = v.bool("tappable")
            return AnyView(BraisenlyModelPill(title: title, systemImage: image, action: tappable ? v.action("modelPill.action") : nil))
        },
        CatalogEntry(
            id: "buttonsPills.citationPill", group: .buttonsPills, typeName: "BraisenlyCitationPill",
            title: "Citation Pill", summary: "Source citation capsule, optionally linking out.",
            snippet: "BraisenlyCitationPill(title: {{title}}, source: {{source}}, url: URL(string: \"https://www.swift.org\"), systemImage: {{systemImage}})",
            knobs: [
                .text(key: "title", label: "Title", default: "Swift Evolution"),
                .text(key: "source", label: "Source", default: "swift.org"),
                .bool(key: "hasURL", label: "Has URL", default: true),
                .text(key: "systemImage", label: "System image", default: "link"),
            ]
        ) { values in
            var v = values
            let title = v.string("title")
            let source = v.optionalString("source")
            let url = v.bool("hasURL") ? URL(string: "https://www.swift.org") : nil
            let image = v.string("systemImage")
            return AnyView(BraisenlyCitationPill(title: title, source: source, url: url, systemImage: image))
        },
        CatalogEntry(
            id: "buttonsPills.themeSwitcher", group: .buttonsPills, typeName: "BraisenlyThemeSwitcher",
            title: "Theme Switcher", summary: "Row or cycle control that selects a theme by id (stage-local here).",
            snippet: "@State private var themeID = \"solarizedLight\"\n\nBraisenlyThemeSwitcher(selection: $themeID, themes: BraisenlyThemes.all, style: .{{style}}, platform: .{{platform}})",
            knobs: [
                .pick(key: "style", label: "Style", options: ["row", "cycle"], default: "row"),
                .bool(key: "includeLiquidGlass", label: "Include Liquid Glass", default: true),
                .platform(),
            ]
        ) { values in
            var v = values
            let style: BraisenlyThemeSwitcherStyle = v.string("style") == "cycle" ? .cycle : .row
            let themes = v.bool("includeLiquidGlass") ? BraisenlyThemes.all : [BraisenlyThemes.solarizedLight, BraisenlyThemes.solarizedDark]
            let platform = v.platform()
            return AnyView(StateHost("solarizedLight") { selection in
                BraisenlyThemeSwitcher(selection: selection, themes: themes, style: style, platform: platform)
            })
        },
    ]
}

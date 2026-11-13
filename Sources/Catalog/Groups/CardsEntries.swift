import SwiftUI
import BraisenlySwiftUI

nonisolated enum CardsEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "cards.bannerCard", group: .cards, typeName: "BraisenlyBannerCard",
            title: "Banner Card", summary: "Inline alert banner with symbol and optional dismiss.",
            snippet: "BraisenlyBannerCard(message: {{message}}, systemImage: {{systemImage}}, iconColor: {{iconColor}}, onDismiss: {{dismissible}} ? { } : nil)",
            knobs: [
                .text(key: "message", label: "Message", default: "Model download failed. Check your connection."),
                .text(key: "systemImage", label: "System image", default: "exclamationmark.triangle.fill"),
                .color(key: "iconColor", label: "Icon colour", options: ColorToken.allCases, default: .danger),
                .bool(key: "dismissible", label: "Dismissible", default: true),
            ]
        ) { values in
            var v = values
            let message = v.string("message"), image = v.string("systemImage"), color = v.color("iconColor")
            let onDismiss: (() -> Void)? = v.bool("dismissible") ? v.action("onDismiss") : nil
            return AnyView(BraisenlyBannerCard(message: message, systemImage: image, iconColor: color, onDismiss: onDismiss))
        },
        CatalogEntry(
            id: "cards.statusCard", group: .cards, typeName: "BraisenlyStatusCard",
            title: "Status Card", summary: "Title, subtitle and a tinted status symbol.",
            snippet: "BraisenlyStatusCard(title: {{title}}, subtitle: {{subtitle}}, systemImage: {{systemImage}}, iconColor: {{iconColor}})",
            knobs: [
                .text(key: "title", label: "Title", default: "Model ready"),
                .text(key: "subtitle", label: "Subtitle", default: "LFM3 1.7B · 4-bit"),
                .text(key: "systemImage", label: "System image", default: "checkmark.seal.fill"),
                .color(key: "iconColor", label: "Icon colour", options: ColorToken.allCases, default: .accentTeal),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), subtitle = v.string("subtitle"), image = v.string("systemImage"), color = v.color("iconColor")
            return AnyView(BraisenlyStatusCard(title: title, subtitle: subtitle, systemImage: image, iconColor: color))
        },
        CatalogEntry(
            id: "cards.suggestionCard", group: .cards, typeName: "BraisenlySuggestionCard",
            title: "Suggestion Card", summary: "Tappable prompt suggestion.",
            snippet: "BraisenlySuggestionCard(title: {{title}}, systemImage: {{systemImage}}) { }",
            knobs: [
                .text(key: "title", label: "Title", default: "Summarize my research"),
                .text(key: "systemImage", label: "System image", default: "arrow.up.right"),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), image = v.optionalString("systemImage")
            return AnyView(BraisenlySuggestionCard(title: title, systemImage: image, action: v.action("suggestionCard.action")))
        },
        CatalogEntry(
            id: "cards.codeBlockCard", group: .cards, typeName: "BraisenlyCodeBlockCard",
            title: "Code Block Card", summary: "Monospaced code surface with language tag and copy action.",
            snippet: "BraisenlyCodeBlockCard(language: {{language}}, code: {{code}}, onCopy: {{copyable}} ? { } : nil)",
            knobs: [
                .text(key: "language", label: "Language", default: "swift"),
                .text(key: "code", label: "Code", default: Fixtures.codeSample),
                .bool(key: "copyable", label: "Copyable", default: true),
            ]
        ) { values in
            var v = values
            let language = v.optionalString("language"), code = v.string("code")
            let onCopy: (() -> Void)? = v.bool("copyable") ? v.action("onCopy") : nil
            return AnyView(BraisenlyCodeBlockCard(language: language, code: code, onCopy: onCopy))
        },
        CatalogEntry(
            id: "cards.searchSnippetCard", group: .cards, typeName: "BraisenlySearchSnippetCard",
            title: "Search Snippet Card", summary: "Search result excerpt with the query highlighted.",
            snippet: "BraisenlySearchSnippetCard(text: {{text}}, query: {{query}}, platform: .{{platform}})",
            knobs: [
                .text(key: "text", label: "Text", default: Fixtures.searchParagraph),
                .text(key: "query", label: "Query", default: "glass"),
                .platform(),
            ]
        ) { values in
            var v = values
            let text = v.string("text"), query = v.string("query"), platform = v.platform()
            return AnyView(BraisenlySearchSnippetCard(text: text, query: query, platform: platform))
        },
        CatalogEntry(
            id: "cards.chatBubbleSurface", group: .cards, typeName: "BraisenlyChatBubbleSurface",
            title: "Chat Bubble Surface", summary: "Rounded message bubble with themed fill and foreground.",
            snippet: "BraisenlyChatBubbleSurface(text: {{text}}, fill: {{fill}}, foregroundColor: {{foregroundColor}}, cornerRadius: {{cornerRadius}})",
            knobs: [
                .text(key: "text", label: "Text", default: "Can you summarize the design review?"),
                .color(key: "fill", label: "Fill", options: ColorToken.themeTokens, default: .surfaceElevated),
                .color(key: "foregroundColor", label: "Foreground", options: ColorToken.themeTokens, default: .textPrimary),
                .double(key: "cornerRadius", label: "Corner radius", range: 0...36, step: 1, default: 18),
            ]
        ) { values in
            var v = values
            let text = v.string("text"), fill = v.color("fill"), fg = v.color("foregroundColor"), radius = v.double("cornerRadius")
            return AnyView(BraisenlyChatBubbleSurface(text: text, fill: fill, foregroundColor: fg, cornerRadius: radius))
        },
    ]
}

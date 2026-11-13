import SwiftUI

nonisolated enum EntryPresentation: Equatable { case inline, canvas(height: CGFloat) }

// Registry data is nonisolated and Sendable so Swift Testing can enumerate it as test arguments off the main actor;
// `make` itself runs on the main actor.
nonisolated struct CatalogEntry: Identifiable, Sendable {
    let id: String
    let group: CatalogGroup
    let typeName: String?
    let title: String
    let summary: String
    let snippet: String
    let knobs: [Knob]
    /// Pick options whose display value is not a Swift expression: knob key → option → snippet text.
    var snippetValues: [String: [String: String]] = [:]
    var presentation: EntryPresentation = .inline
    let make: @MainActor @Sendable (KnobValues) -> AnyView

    init(id: String, group: CatalogGroup, typeName: String?, title: String, summary: String, snippet: String,
         knobs: [Knob], snippetValues: [String: [String: String]] = [:], presentation: EntryPresentation = .inline, make: @escaping @MainActor @Sendable (KnobValues) -> AnyView) {
        self.id = id; self.group = group; self.typeName = typeName; self.title = title; self.summary = summary
        self.snippet = snippet; self.knobs = knobs; self.snippetValues = snippetValues; self.presentation = presentation; self.make = make
    }

    func renderSnippet(_ values: KnobValues) -> String {
        let picks = Set(knobs.compactMap { if case .pick = $0 { $0.key } else { nil } })
        func expand(_ text: String) -> String {
            text.replacing(/\{\{([A-Za-z0-9_]+)\}\}/) { match in
                let key = String(match.output.1)
                if key == "appThemeID" { return values.theme.id }
                guard let value = values[key] else { return String(match.output.0) }
                // pick knobs are written raw so templates can spell `.{{platform}}`
                if picks.contains(key), case .string(let raw) = value { return snippetValues[key]?[raw] ?? raw }
                return value.swiftLiteral
            }
        }
        return expand(expand(snippet))  // second pass: a mapped option may itself name another knob
    }
}

nonisolated extension KnobValue {
    var swiftLiteral: String {
        switch self {
        case .bool(let b): String(b)
        case .int(let i): String(i)
        case .double(let d): String(describing: d)
        case .string(let s): Self.escaped(s)
        case .color(let c): c.snippetExpression
        }
    }

    private static func escaped(_ s: String) -> String {
        var out = "\""
        for ch in s {
            switch ch {
            case "\\": out += "\\\\"
            case "\"": out += "\\\""
            case "\n": out += "\\n"
            case "\t": out += "\\t"
            default: out.append(ch)
            }
        }
        return out + "\""
    }
}

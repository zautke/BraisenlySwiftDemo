import Testing
import SwiftUI
import BraisenlySwiftUI
@testable import BraisenlySwiftDemo

@Suite struct KnobTests {
    private func values(_ knobs: [Knob], log: ActionLog = ActionLog()) -> KnobValues {
        KnobValues(knobs: knobs, theme: BraisenlyThemes.liquidGlass, log: log)
    }

    @Test func defaultsSeedEveryKnob() {
        var v = values([
            .bool(key: "a", label: "A", default: true),
            .int(key: "b", label: "B", range: 0...5, default: 2),
            .text(key: "c", label: "C", default: "x"),
        ])
        #expect(v.bool("a") == true)
        #expect(v.int("b") == 2)
        #expect(v.string("c") == "x")
        #expect(v.missingKeys.isEmpty)
        v["a"] = .bool(false)
        #expect(v.bool("a") == false)
    }

    @Test func missingKeyIsRecordedNotTrapped() {
        var v = values([])
        #expect(v.int("zzz") == 0)
        #expect(v.missingKeys == ["zzz"])
    }

    @Test func optionalStringMapsEmptyToNil() {
        var v = values([.text(key: "t", label: "T", default: "")])
        #expect(v.optionalString("t") == nil)
        v["t"] = .string("hi")
        #expect(v.optionalString("t") == "hi")
    }

    @Test func actionRecordsName() {
        let log = ActionLog()
        var v = values([], log: log)
        v.action("onSend")()
        #expect(log.last == "onSend")
        #expect(log.count == 1)
        #expect(v.missingKeys.isEmpty)
    }

    @Test func colorTokenSplits() {
        #expect(ColorToken.themeTokens.count == 20)
        #expect(ColorToken.solarized.count == 16)
        #expect(ColorToken.allCases.count == 36)
        #expect(ColorToken.danger.snippetExpression == "theme.colors.danger")
        #expect(ColorToken.solarizedRed.snippetExpression == "BraisenlyDS.Solarized.red")
    }

    @Test func enumPicksParseWithFallback() {
        var v = values([Knob.step(default: "l"), Knob.tone(default: "bogus"), Knob.platform(default: "mac"), Knob.textStyle(default: "code")])
        #expect(v.step("spacing") == .l)
        #expect(v.tone("tone") == .primary)
        #expect(v.platform("platform") == .mac)
        #expect(v.textStyle("style") == .code)
        v["spacing"] = .string("bogus")
        #expect(v.step("spacing") == .zero)
    }

    private let kinds: [Knob] = [
        .text(key: "t", label: "T", default: "hi"),
        .bool(key: "b", label: "B", default: true),
        .int(key: "i", label: "I", range: 0...9, default: 3),
        .double(key: "d", label: "D", range: 0...1, step: 0.1, default: 0.5),
        .pick(key: "p", label: "P", options: ["iPhone", "iPad"], default: "iPad"),
        .color(key: "c", label: "C", options: ColorToken.allCases, default: .accentTeal),
    ]

    private func entry(_ snippet: String) -> CatalogEntry {
        CatalogEntry(id: "tokens.x", group: .tokens, typeName: nil, title: "X", summary: "", snippet: snippet, knobs: kinds) { _ in AnyView(BraisenlySpacer()) }
    }

    @Test func snippetRendersEachKind() {
        var v = values(kinds)
        #expect(entry("X({{t}}, {{b}}, {{i}}, {{d}}, .{{p}}, {{c}})").renderSnippet(v) == "X(\"hi\", true, 3, 0.5, .iPad, theme.colors.accentTeal)")
        v["c"] = .color(.solarizedRed)
        #expect(entry("{{c}}").renderSnippet(v) == "BraisenlyDS.Solarized.red")
    }

    @Test func snippetEscapesStringLiterals() {
        var v = values(kinds)
        v["t"] = .string("He said \"hi\"\\\nx")
        #expect(entry("{{t}}").renderSnippet(v) == "\"He said \\\"hi\\\"\\\\\\nx\"")
    }

    @Test func snippetLeavesUnknownPlaceholder() {
        #expect(entry("{{nope}}").renderSnippet(values(kinds)) == "{{nope}}")
    }
}

import Testing
@testable import BraisenlySwiftDemo

@Suite struct ButtonsPillsEntriesTests {
    private let entries = ButtonsPillsEntries.entries

    @Test func idsAndTypeNamesMatchSpec() {
        #expect(entries.map(\.id) == ["buttonsPills.button", "buttonsPills.circleIconButton", "buttonsPills.toolbarIconButton", "buttonsPills.sendStopButton", "buttonsPills.dualActionPill", "buttonsPills.messageActionPill", "buttonsPills.modelPill", "buttonsPills.citationPill", "buttonsPills.themeSwitcher"])
        #expect(entries.map(\.typeName) == ["BraisenlyButton", "BraisenlyCircleIconButton", "BraisenlyToolbarIconButton", "BraisenlySendStopButton", "BraisenlyDualActionPill", "BraisenlyMessageActionPill", "BraisenlyModelPill", "BraisenlyCitationPill", "BraisenlyThemeSwitcher"])
    }

    @Test func knobKeysMatchSpec() {
        let expected: [[String]] = [
            ["title", "systemImage", "prominence"],
            ["systemName", "accessibilityLabel", "iconSize", "platform"],
            ["systemName", "label", "isEnabled"],
            ["isResponding", "canSend", "size"],
            ["platform"],
            ["isCopied", "canRegenerate"],
            ["title", "systemImage", "tappable"],
            ["title", "source", "hasURL", "systemImage"],
            ["style", "includeLiquidGlass", "platform"],
        ]
        #expect(entries.map { $0.knobs.map(\.key) } == expected)
    }
}

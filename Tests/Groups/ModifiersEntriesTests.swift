import Testing
@testable import BraisenlySwiftDemo

@Suite struct ModifiersEntriesTests {
    private let entries = ModifiersEntries.entries

    @Test func idsAndTypeNamesMatchSpec() {
        #expect(entries.map(\.id) == ["modifiers.braisenlyCard", "modifiers.braisenlyCapsule", "modifiers.braisenlyPadding",
                                      "modifiers.braisenlyTheme", "modifiers.glassSurfaces", "modifiers.braisenlySheetBackground"])
        #expect(entries.map(\.typeName) == ["BraisenlyCardModifier", "BraisenlyCapsuleModifier", nil, nil, nil, nil])
    }

    @Test func knobKeysMatchSpec() {
        #expect(entries.map { $0.knobs.map(\.key) } == [
            ["content", "cornerRadius", "fill", "role"],
            ["content", "fill", "role"],
            ["edges", "step"],
            ["theme"],
            ["surface", "glass", "role"],
            ["title"],
        ])
    }
}

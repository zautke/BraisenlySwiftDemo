import Testing
@testable import BraisenlySwiftDemo

@Suite struct TokensEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        let ids = ["tokens.solarizedPalette", "tokens.colors", "tokens.typography", "tokens.metrics", "tokens.platformDensity", "tokens.themeDefinitions"]
        let typeNames: [String?] = [nil, nil, nil, nil, nil, nil]
        #expect(TokensEntries.entries.map(\.id) == ids)
        #expect(TokensEntries.entries.map(\.typeName) == typeNames)
    }

    @Test func knobKeysMatchSpec() {
        let knobKeys: [String: [String]] = [
            "tokens.solarizedPalette": ["minColumnWidth", "showNames"],
            "tokens.colors": ["minColumnWidth", "showNames", "theme"],
            "tokens.typography": ["sample"],
            "tokens.metrics": ["step"],
            "tokens.platformDensity": ["platform"],
            "tokens.themeDefinitions": ["theme"],
        ]
        #expect(Dictionary(uniqueKeysWithValues: TokensEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == knobKeys)
    }
}

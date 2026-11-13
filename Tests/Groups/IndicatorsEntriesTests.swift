import Testing
@testable import BraisenlySwiftDemo

@Suite struct IndicatorsEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(IndicatorsEntries.entries.map(\.id) == ["indicators.pulseIndicator","indicators.tabCounterBadge","indicators.avatarBadge","indicators.highlightedText","indicators.colorSwatch"])
        #expect(IndicatorsEntries.entries.map(\.typeName) == ["BraisenlyPulseIndicator","BraisenlyTabCounterBadge","BraisenlyAvatarBadge","BraisenlyHighlightedText","BraisenlyColorSwatch"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: IndicatorsEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["indicators.pulseIndicator": ["label"], "indicators.tabCounterBadge": ["count"], "indicators.avatarBadge": ["systemName","foregroundColor","backgroundColor","borderColor","size","iconSize"], "indicators.highlightedText": ["text","highlight","font","baseColor"], "indicators.colorSwatch": ["color","name","detail","isSelected"]])
    }
}

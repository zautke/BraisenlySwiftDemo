import Testing
@testable import BraisenlySwiftDemo

@Suite struct CardsEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(CardsEntries.entries.map(\.id) == ["cards.bannerCard","cards.statusCard","cards.suggestionCard","cards.codeBlockCard","cards.searchSnippetCard","cards.chatBubbleSurface"])
        #expect(CardsEntries.entries.map(\.typeName) == ["BraisenlyBannerCard","BraisenlyStatusCard","BraisenlySuggestionCard","BraisenlyCodeBlockCard","BraisenlySearchSnippetCard","BraisenlyChatBubbleSurface"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: CardsEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["cards.bannerCard": ["message","systemImage","iconColor","dismissible"], "cards.statusCard": ["title","subtitle","systemImage","iconColor"], "cards.suggestionCard": ["title","systemImage"], "cards.codeBlockCard": ["language","code","copyable"], "cards.searchSnippetCard": ["text","query","platform"], "cards.chatBubbleSurface": ["text","fill","foregroundColor","cornerRadius"]])
    }
}

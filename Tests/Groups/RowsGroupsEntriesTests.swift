import Testing
@testable import BraisenlySwiftDemo

@Suite struct RowsGroupsEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(RowsGroupsEntries.entries.map(\.id) == ["rowsGroups.actionRow","rowsGroups.actionGroup","rowsGroups.conversationRow","rowsGroups.searchMetadataRow","rowsGroups.expandableSearchResult"])
        #expect(RowsGroupsEntries.entries.map(\.typeName) == ["BraisenlyActionRow","BraisenlyActionGroup","BraisenlyConversationRow","BraisenlySearchMetadataRow","BraisenlyExpandableSearchResult"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: RowsGroupsEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["rowsGroups.actionRow": ["icon","title","isChecked","platform"], "rowsGroups.actionGroup": ["itemCount","platform"], "rowsGroups.conversationRow": ["title","subtitle","timestampText","isSelected","isPinned","platform"], "rowsGroups.searchMetadataRow": ["stageWidth"], "rowsGroups.expandableSearchResult": ["query","platform"]])
    }
}

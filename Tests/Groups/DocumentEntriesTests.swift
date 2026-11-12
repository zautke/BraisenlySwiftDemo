import Testing
@testable import BraisenlySwiftDemo

@Suite struct DocumentEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(DocumentEntries.entries.map(\.id) == ["document.chrome","document.canvas","document.actionSheet","document.bottomToolbar"])
        #expect(DocumentEntries.entries.map(\.typeName) == ["BraisenlyDocumentChrome","BraisenlyDocumentCanvas","BraisenlyDocumentActionSheet","BraisenlyBottomToolbar"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: DocumentEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["document.chrome": ["platform"], "document.canvas": ["title","bodyText","platform"], "document.actionSheet": ["platform"], "document.bottomToolbar": ["tabCount","platform"]])
    }
}

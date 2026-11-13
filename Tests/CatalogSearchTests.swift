import Testing
import SwiftUI
import BraisenlySwiftUI
@testable import BraisenlySwiftDemo

@Suite struct CatalogSearchTests {
    private let entries: [CatalogEntry] = [
        CatalogEntry(id: "buttonsPills.circleIconButton", group: .buttonsPills, typeName: "BraisenlyCircleIconButton", title: "Circle Icon Button", summary: "Round glass button", snippet: "", knobs: [.bool(key: "x", label: "X", default: true)]) { _ in AnyView(BraisenlySpacer()) },
        CatalogEntry(id: "cards.statusCard", group: .cards, typeName: "BraisenlyStatusCard", title: "Status Card", summary: "Shows model readiness", snippet: "", knobs: [.bool(key: "x", label: "X", default: true)]) { _ in AnyView(BraisenlySpacer()) },
    ]
    private func groups(_ q: String) -> [CatalogGroup] { CatalogRegistry.sections(matching: q, in: entries).map(\.group) }

    @Test func sectionsMatchingEmptyQueryReturnsAllGroups() { #expect(groups("") == [.buttonsPills, .cards]) }
    @Test func sectionsMatchingWhitespaceQueryReturnsAll() { #expect(groups("   ") == [.buttonsPills, .cards]) }
    @Test func sectionsMatchingIsCaseAndDiacriticInsensitive() {
        #expect(groups("CIRCLE") == [.buttonsPills])
        #expect(groups("círcle") == [.buttonsPills])
    }
    @Test func sectionsMatchingTypeNameAndSummary() {
        #expect(groups("BraisenlyStatusCard") == [.cards])
        #expect(groups("readiness") == [.cards])
    }
    @Test func sectionsMatchingNothingIsEmpty() { #expect(CatalogRegistry.sections(matching: "zzz", in: entries).isEmpty) }
    @Test func emptyGroupsAreHidden() {
        let s = CatalogRegistry.sections(matching: "glass", in: entries)
        #expect(s.count == 1)
        #expect(s[0].entries.map(\.id) == ["buttonsPills.circleIconButton"])
    }
}

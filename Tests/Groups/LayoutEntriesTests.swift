import Testing
@testable import BraisenlySwiftDemo

@Suite struct LayoutEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        let ids = ["layout.vStack", "layout.hStack", "layout.zStack", "layout.scroll", "layout.spacer", "layout.divider", "layout.text", "layout.icon", "layout.grid", "layout.splitView"]
        let typeNames: [String?] = ["BraisenlyVStack", "BraisenlyHStack", "BraisenlyZStack", "BraisenlyScroll", "BraisenlySpacer", "BraisenlyDivider", "BraisenlyText", "BraisenlyIcon", "BraisenlyGrid", "BraisenlySplitView"]
        #expect(LayoutEntries.entries.map(\.id) == ids)
        #expect(LayoutEntries.entries.map(\.typeName) == typeNames)
    }

    @Test func knobKeysMatchSpec() {
        let knobKeys: [String: [String]] = [
            "layout.vStack": ["spacing", "alignment", "itemCount"],
            "layout.hStack": ["spacing", "alignment", "itemCount"],
            "layout.zStack": ["alignment", "layerCount"],
            "layout.scroll": ["axis", "itemCount", "showsIndicators"],
            "layout.spacer": ["minLength"],
            "layout.divider": ["context"],
            "layout.text": ["text", "style", "tone"],
            "layout.icon": ["systemName", "size", "tone"],
            "layout.grid": ["minimumColumnWidth", "itemCount", "spacing"],
            "layout.splitView": ["compactColumn", "extendsDetailBackground"],
        ]
        #expect(Dictionary(uniqueKeysWithValues: LayoutEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == knobKeys)
    }
}

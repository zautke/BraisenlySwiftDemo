import Testing
@testable import BraisenlySwiftDemo

@Suite struct SidebarEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(SidebarEntries.entries.map(\.id) == ["sidebar.searchHeader","sidebar.footer","sidebar.contextPopover","sidebar.drawer","sidebar.modes"])
        #expect(SidebarEntries.entries.map(\.typeName) == ["BraisenlySidebarSearchHeader","BraisenlySidebarFooter","BraisenlySidebarContextPopover","BraisenlySidebarDrawer",nil])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: SidebarEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["sidebar.searchHeader": ["platform"], "sidebar.footer": ["selectedMode","platform"], "sidebar.contextPopover": ["platform"], "sidebar.drawer": ["platform"], "sidebar.modes": ["showIcons"]])
    }
}

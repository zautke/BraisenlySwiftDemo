import Testing
@testable import BraisenlySwiftDemo

@Suite struct WorkspacesEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(WorkspacesEntries.entries.map(\.id) == ["workspaces.compact","workspaces.regular","workspaces.mobile"])
        #expect(WorkspacesEntries.entries.map(\.typeName) == ["BraisenlyCompactWorkspace","BraisenlyRegularWorkspace","BraisenlyMobileWorkspaceView"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: WorkspacesEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["workspaces.compact": ["documentTitle","documentText"], "workspaces.regular": ["documentTitle","documentText","platform"], "workspaces.mobile": ["documentTitle","documentText","initialTheme","platform"]])
    }
}

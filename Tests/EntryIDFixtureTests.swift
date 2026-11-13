import Testing
import Foundation
@testable import BraisenlySwiftDemo

@Suite struct EntryIDFixtureTests {
    private final class Marker {}

    /// `UITests/Fixtures/catalog-entry-ids.txt` drives the UI walk; it must equal the registry order exactly.
    @Test func fixtureMatchesRegistry() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
        let url = root.appending(path: "UITests/Fixtures/catalog-entry-ids.txt")
        let lines = try String(contentsOf: url, encoding: .utf8).split(separator: "\n").map(String.init)
        #expect(lines == CatalogRegistry.all.map(\.id))
    }
}

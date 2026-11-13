import Testing
import Foundation
@testable import BraisenlySwiftDemo

@Suite struct RegistryCompletenessTests {
    /// Bundled `public-views.txt`, or the file named by `CATALOG_PUBLIC_VIEWS_OVERRIDE` (negative test).
    private func fixtureLines() throws -> [String] {
        let url: URL
        if let override = ProcessInfo.processInfo.environment["CATALOG_PUBLIC_VIEWS_OVERRIDE"] {
            url = URL(fileURLWithPath: override)
        } else {
            url = try #require(Bundle(for: Marker.self).url(forResource: "public-views", withExtension: "txt", subdirectory: "Fixtures"))
        }
        return try String(contentsOf: url, encoding: .utf8).split(separator: "\n").map(String.init).filter { !$0.isEmpty }
    }
    private final class Marker {}

    @Test func catalogCoversEveryPublicView() throws {
        let fixture = Set(try fixtureLines())
        let catalogued = Set(CatalogRegistry.all.compactMap(\.typeName))
        let missing = fixture.subtracting(catalogued)
        let stale = catalogued.subtracting(fixture)
        if !missing.isEmpty || !stale.isEmpty {
            Issue.record("missing: \(missing.sorted()) stale: \(stale.sorted())")
        }
    }

    @Test func typeNamesAreUnique() {
        let names = CatalogRegistry.all.compactMap(\.typeName)
        #expect(Set(names).count == names.count)
    }

    @Test func fixtureIsSortedAndUnique() throws {
        let lines = try fixtureLines()
        #expect(lines == Array(Set(lines)).sorted())
    }
}

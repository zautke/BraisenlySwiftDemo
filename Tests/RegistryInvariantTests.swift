import Testing
import SwiftUI
import BraisenlySwiftUI
@testable import BraisenlySwiftDemo

@Suite struct RegistryInvariantTests {
    nonisolated private static let ids = CatalogRegistry.all.map(\.id)
    private func entry(_ id: String) throws -> CatalogEntry { try #require(CatalogRegistry.entry(id: id)) }
    @MainActor private func defaults(_ e: CatalogEntry) -> KnobValues { KnobValues(knobs: e.knobs, theme: BraisenlyThemes.liquidGlass, log: ActionLog()) }

    @Test(arguments: ids) func idIsPrefixedByGroup(id: String) throws {
        let e = try entry(id)
        #expect(e.id.hasPrefix(e.group.rawValue + "."))
    }

    @Test(arguments: ids) func hasAtLeastOneKnob(id: String) throws {
        #expect(try entry(id).knobs.count >= 1)
    }

    @Test(arguments: ids) func knobKeysUnique(id: String) throws {
        let keys = try entry(id).knobs.map(\.key)
        #expect(Set(keys).count == keys.count)
    }

    @Test(arguments: ids) func snippetPlaceholdersAreKnobKeys(id: String) throws {
        let e = try entry(id)
        let keys = Set(e.knobs.map(\.key))
        let placeholders = e.snippet.matches(of: /\{\{([A-Za-z0-9_]+)\}\}/).map { String($0.output.1) }
        let unknown = placeholders.filter { !keys.contains($0) }
        #expect(unknown.isEmpty, "unknown placeholders: \(unknown)")
    }

    @Test(arguments: ids) func pickDefaultsInOptions(id: String) throws {
        for knob in try entry(id).knobs {
            switch knob {
            case .pick(_, _, let options, let def): #expect(options.contains(def), "\(knob.key)")
            case .color(_, _, let options, let def): #expect(options.contains(def), "\(knob.key)")
            default: break
            }
        }
    }

    @Test(arguments: ids) func numericDefaultsInRange(id: String) throws {
        for knob in try entry(id).knobs {
            switch knob {
            case .int(_, _, let range, let def): #expect(range.contains(def), "\(knob.key)")
            case .double(_, _, let range, _, let def): #expect(range.contains(def), "\(knob.key)")
            default: break
            }
        }
    }

    @Test(arguments: ids) @MainActor func makeWithDefaultsReadsOnlyDeclaredKeys(id: String) throws {
        let e = try entry(id)
        let v = defaults(e)
        _ = e.make(v)
        #expect(v.missingKeys.isEmpty, "missing: \(v.missingKeys)")
    }

    /// Picks whose display value is not a Swift expression must still render compilable snippet text.
    @Test @MainActor func pickSnippetsRenderSwiftExpressions() throws {
        let expected = [
            "modifiers.glassSurfaces": "themed.surface = .glass(.regular)",
            "rowsGroups.searchMetadataRow": ".frame(maxWidth: .infinity)",
            "sidebar.footer": "selectedMode: .files,",
            "tokens.colors": "theme(withID: \"liquidGlass\")",
        ]
        for (id, text) in expected {
            let e = try entry(id)
            #expect(e.renderSnippet(defaults(e)).contains(text), "\(id): \(e.renderSnippet(defaults(e)))")
        }
    }

    @Test(arguments: ids) @MainActor func rendersWithDefaults(id: String) throws {
        let e = try entry(id)
        #expect(Self.renders(e, defaults(e)))
    }

    @Test(arguments: ids) @MainActor func rendersAtKnobBounds(id: String) throws {
        let e = try entry(id)
        for knob in e.knobs {
            let variants: [KnobValue]
            switch knob {
            case .int(_, _, let r, _): variants = [.int(r.lowerBound), .int(r.upperBound)]
            case .double(_, _, let r, _, _): variants = [.double(r.lowerBound), .double(r.upperBound)]
            case .text: variants = [.string("")]
            default: continue
            }
            for value in variants {
                var v = defaults(e)
                v[knob.key] = value
                #expect(Self.renders(e, v), "\(knob.key) = \(value)")
            }
        }
    }

    @Test func idsAreGloballyUnique() {
        #expect(Set(Self.ids).count == Self.ids.count)
    }

    @Test func allFollowsGroupOrder() {
        let groups = CatalogRegistry.all.map(\.group)
        let order = CatalogGroup.allCases.filter { groups.contains($0) }
        var seen: [CatalogGroup] = []
        for g in groups where seen.last != g { seen.append(g) }
        #expect(seen == order)
    }

    @MainActor private static func renders(_ e: CatalogEntry, _ v: KnobValues) -> Bool {
        #if os(macOS)
        let renderer = ImageRenderer(content: e.make(v).braisenlyTheme(v.theme).frame(width: 600, height: 600))
        return renderer.nsImage != nil
        #else
        _ = e.make(v)
        return true
        #endif
    }
}

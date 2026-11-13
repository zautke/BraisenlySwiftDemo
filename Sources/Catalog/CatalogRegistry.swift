nonisolated enum CatalogRegistry {
    static let all: [CatalogEntry] = {
        var entries = TokensEntries.entries + LayoutEntries.entries + ModifiersEntries.entries + ButtonsPillsEntries.entries
            + IndicatorsEntries.entries + FieldsEntries.entries + ControlsEntries.entries + CardsEntries.entries
            + RowsGroupsEntries.entries + SidebarEntries.entries + DocumentEntries.entries + WorkspacesEntries.entries
        #if BRAISENLY_AI
        entries += AIEntries.entries
        #endif
        return entries
    }()

    static func entries(in group: CatalogGroup) -> [CatalogEntry] { all.filter { $0.group == group } }

    static func entry(id: String) -> CatalogEntry? { all.first { $0.id == id } }

    static func sections(matching query: String, in entries: [CatalogEntry] = all) -> [(group: CatalogGroup, entries: [CatalogEntry])] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let hits = q.isEmpty ? entries : entries.filter {
            $0.title.localizedStandardContains(q) || ($0.typeName?.localizedStandardContains(q) ?? false) || $0.summary.localizedStandardContains(q)
        }
        return CatalogGroup.allCases.compactMap { g in
            let e = hits.filter { $0.group == g }
            return e.isEmpty ? nil : (group: g, entries: e)
        }
    }
}

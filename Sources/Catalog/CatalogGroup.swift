nonisolated enum CatalogGroup: String, CaseIterable, Identifiable {
    case tokens, layout, modifiers, buttonsPills, indicators, fields, controls, cards, rowsGroups, sidebar, document, workspaces
    #if BRAISENLY_AI
    case ai
    #endif

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tokens: "Tokens"
        case .layout: "Layout"
        case .modifiers: "Modifiers"
        case .buttonsPills: "Buttons & Pills"
        case .indicators: "Indicators"
        case .fields: "Fields"
        case .controls: "Controls"
        case .cards: "Cards"
        case .rowsGroups: "Rows & Groups"
        case .sidebar: "Sidebar"
        case .document: "Document"
        case .workspaces: "Workspaces"
        #if BRAISENLY_AI
        case .ai: "AI"
        #endif
        }
    }

    var symbolName: String {
        switch self {
        case .tokens: "paintpalette"
        case .layout: "square.grid.3x1.below.line.grid.1x2"
        case .modifiers: "wand.and.stars"
        case .buttonsPills: "capsule"
        case .indicators: "dot.radiowaves.left.and.right"
        case .fields: "character.cursor.ibeam"
        case .controls: "slider.horizontal.3"
        case .cards: "rectangle.on.rectangle"
        case .rowsGroups: "list.bullet"
        case .sidebar: "sidebar.left"
        case .document: "doc.text"
        case .workspaces: "macwindow"
        #if BRAISENLY_AI
        case .ai: "sparkles"
        #endif
        }
    }
}

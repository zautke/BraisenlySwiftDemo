import SwiftUI
import BraisenlySwiftUI

nonisolated enum ControlsEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "controls.segmentedControl", group: .controls, typeName: "BraisenlySegmentedControl",
            title: "Segmented Control", summary: "Capsule segments for a small set of options.",
            snippet: "@State private var selection = \"Files\"\nBraisenlySegmentedControl(selection: $selection, options: options.prefix({{optionCount}}), title: { $0 }, platform: .{{platform}})",
            knobs: [.int(key: "optionCount", label: "Options", range: 2...5, default: 3), .platform()]
        ) { values in
            var v = values
            let options = Array(Fixtures.segmentOptions.prefix(v.int("optionCount")))
            let platform = v.platform()
            return AnyView(StateHost(options[0]) { BraisenlySegmentedControl(selection: $0, options: options, title: { $0 }, platform: platform) })
        },
        CatalogEntry(
            id: "controls.toggleRow", group: .controls, typeName: "BraisenlyToggleRow",
            title: "Toggle Row", summary: "Labelled switch row with an optional subtitle.",
            snippet: "@State private var isOn = true\nBraisenlyToggleRow({{title}}, subtitle: {{subtitle}}, isOn: $isOn)",
            knobs: [
                .text(key: "title", label: "Title", default: "Enable tools"),
                .text(key: "subtitle", label: "Subtitle", default: "Lets the model call built-in tools"),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), subtitle = v.optionalString("subtitle")
            return AnyView(StateHost(true) { BraisenlyToggleRow(title, subtitle: subtitle, isOn: $0) })
        },
        CatalogEntry(
            id: "controls.stepperRow", group: .controls, typeName: "BraisenlyStepperRow",
            title: "Stepper Row", summary: "Integer stepper with a label and clamped range.",
            snippet: "@State private var value = 3\nBraisenlyStepperRow({{title}}, value: $value, in: 0...{{upperBound}}, step: {{step}})",
            knobs: [
                .text(key: "title", label: "Title", default: "Max results"),
                .int(key: "upperBound", label: "Upper bound", range: 1...100, default: 10),
                .int(key: "step", label: "Step", range: 1...5, default: 1),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), upper = v.int("upperBound"), step = v.int("step")
            return AnyView(StateHost(min(3, upper)) { BraisenlyStepperRow(title, value: $0, in: 0...upper, step: step) })
        },
        CatalogEntry(
            id: "controls.chipGroup", group: .controls, typeName: "BraisenlyChipGroup",
            title: "Chip Group", summary: "Wrapping single-select chips for larger option sets.",
            snippet: "@State private var selection = models[0]\nBraisenlyChipGroup(selection: $selection, options: models.prefix({{optionCount}}), title: { $0 })",
            knobs: [.int(key: "optionCount", label: "Options", range: 1...8, default: 5)]
        ) { values in
            var v = values
            let options = Array(Fixtures.modelNames.prefix(v.int("optionCount")))
            return AnyView(StateHost(options[0]) { BraisenlyChipGroup(selection: $0, options: options, title: { $0 }) })
        },
        CatalogEntry(
            id: "controls.sectionHeader", group: .controls, typeName: "BraisenlySectionHeader",
            title: "Section Header", summary: "Sidebar section title with optional symbol and trailing text.",
            snippet: "BraisenlySectionHeader({{title}}, systemImage: {{systemImage}}, trailing: {{trailing}})",
            knobs: [
                .text(key: "title", label: "Title", default: "Section"),
                .text(key: "systemImage", label: "System image", default: "square.grid.2x2"),
                .text(key: "trailing", label: "Trailing", default: "12"),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), image = v.optionalString("systemImage"), trailing = v.optionalString("trailing")
            return AnyView(BraisenlySectionHeader(title, systemImage: image, trailing: trailing))
        },
        CatalogEntry(
            id: "controls.navRow", group: .controls, typeName: "BraisenlyNavRow",
            title: "Nav Row", summary: "Selectable sidebar row with optional symbol and badge.",
            snippet: "BraisenlyNavRow(title: {{title}}, systemImage: {{systemImage}}, badge: {{badge}}, isSelected: {{isSelected}}, platform: .{{platform}}) { }",
            knobs: [
                .text(key: "title", label: "Title", default: "Buttons & Pills"),
                .text(key: "systemImage", label: "System image", default: "capsule"),
                .text(key: "badge", label: "Badge", default: "9"),
                .bool(key: "isSelected", label: "Selected", default: false),
                .platform(),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), image = v.optionalString("systemImage"), badge = v.optionalString("badge")
            let selected = v.bool("isSelected"), platform = v.platform()
            return AnyView(BraisenlyNavRow(title: title, systemImage: image, badge: badge, isSelected: selected, platform: platform, action: v.action("navRow.action")))
        },
        CatalogEntry(
            id: "controls.propertyTable", group: .controls, typeName: "BraisenlyPropertyTable",
            title: "Property Table", summary: "Key/value rows for metadata.",
            snippet: "BraisenlyPropertyTable(rows: rows.prefix({{rowCount}}))",
            knobs: [.int(key: "rowCount", label: "Rows", range: 1...8, default: 4)]
        ) { values in
            var v = values
            let rows = Array(Fixtures.propertyRows.prefix(v.int("rowCount")))
            return AnyView(BraisenlyPropertyTable(rows: rows))
        },
        CatalogEntry(
            id: "controls.emptyState", group: .controls, typeName: "BraisenlyEmptyState",
            title: "Empty State", summary: "Centered placeholder with symbol, message and optional action.",
            snippet: "BraisenlyEmptyState(title: {{title}}, message: {{message}}, systemImage: {{systemImage}}, actionTitle: {{actionTitle}}) { }",
            knobs: [
                .text(key: "title", label: "Title", default: "No results"),
                .text(key: "message", label: "Message", default: "Try another search."),
                .text(key: "systemImage", label: "System image", default: "magnifyingglass"),
                .text(key: "actionTitle", label: "Action title", default: "Clear search"),
            ]
        ) { values in
            var v = values
            let title = v.string("title"), message = v.optionalString("message")
            let image = v.string("systemImage"), actionTitle = v.optionalString("actionTitle")
            let action: (() -> Void)? = actionTitle == nil ? nil : v.action("emptyState.action")
            return AnyView(BraisenlyEmptyState(title: title, message: message, systemImage: image.isEmpty ? "square.dashed" : image, actionTitle: actionTitle, action: action))
        },
    ]
}

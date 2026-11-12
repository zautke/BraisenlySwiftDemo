import SwiftUI
import BraisenlySwiftUI

struct KnobsPane: View {
    let knobs: [Knob]
    @Binding var values: KnobValues
    let typeName: String?
    let lastAction: String?

    var body: some View {
        BraisenlySectionHeader("Knobs", systemImage: "slider.horizontal.3")
        ForEach(knobs) { knob in
            control(for: knob)
                .accessibilityIdentifier("knob.\(knob.key)")
                .accessibilityLabel(knob.label)
        }
        BraisenlyPropertyTable(rows: [
            .init(key: "Type", value: typeName ?? "Token"),
            .init(key: "Last action", value: lastAction ?? "—"),
        ])
    }

    @ViewBuilder private func control(for knob: Knob) -> some View {
        switch knob {
        case .bool(let key, let label, _):
            BraisenlyToggleRow(label, isOn: Binding(
                get: { if case .bool(let b) = values[key] { b } else { false } },
                set: { values[key] = .bool($0) }))
        case .int(let key, let label, let range, _):
            BraisenlyStepperRow(label, value: Binding(
                get: { if case .int(let i) = values[key] { i } else { range.lowerBound } },
                set: { values[key] = .int($0) }), in: range)
        case .double(let key, let label, let range, let step, _):
            BraisenlyParameterSliderRow(title: label, value: Binding(
                get: { if case .double(let d) = values[key] { d } else { range.lowerBound } },
                set: { values[key] = .double($0) }), in: range, step: step,
                formatString: step < 0.1 ? "%.2f" : step < 1 ? "%.1f" : "%.0f")
        case .pick(let key, let label, let options, let def):
            let selection = Binding(
                get: { if case .string(let s) = values[key] { s } else { def } },
                set: { values[key] = .string($0) })
            BraisenlyVStack(alignment: .leading, spacing: .xs) {
                BraisenlyText(label, style: .metadata, tone: .secondary)
                if options.count <= 4 {
                    BraisenlySegmentedControl(selection: selection, options: options, title: { $0 })
                } else {
                    BraisenlyChipGroup(selection: selection, options: options, title: { $0 })
                }
            }
        case .text(let key, let label, let def):
            BraisenlyTextFieldRow(label, text: Binding(
                get: { if case .string(let s) = values[key] { s } else { "" } },
                set: { values[key] = .string($0) }), axis: def.contains("\n") ? .vertical : .horizontal)
        case .color(let key, let label, let options, let def):
            let current: ColorToken = if case .color(let c) = values[key] { c } else { def }
            BraisenlyVStack(alignment: .leading, spacing: .xs) {
                BraisenlyText(label, style: .metadata, tone: .secondary)
                BraisenlyGrid(minimumColumnWidth: 56, spacing: .s) {
                    ForEach(options, id: \.self) { token in
                        BraisenlyColorSwatch(color: token.color(in: values.theme), name: token.rawValue, isSelected: token == current) {
                            values[key] = .color(token)
                        }
                    }
                }
            }
        }
    }
}

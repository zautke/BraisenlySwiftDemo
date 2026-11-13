import SwiftUI
import BraisenlySwiftUI

nonisolated enum FieldsEntries {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "fields.promptField", group: .fields, typeName: "BraisenlyPromptField",
            title: "Prompt Field",
            summary: "Multi-line message input on a chrome card; submit fires onSubmit.",
            snippet: """
            @State private var text = ""
            BraisenlyPromptField({{placeholder}}, text: $text, cornerRadius: {{cornerRadius}}, fill: {{fill}}) { }
            """,
            knobs: [
                .text(key: "placeholder", label: "Placeholder", default: "Message Braisenly…"),
                .double(key: "cornerRadius", label: "Corner radius", range: 0...32, step: 1, default: 18),
                .color(key: "fill", label: "Fill", options: ColorToken.themeTokens, default: .surfaceElevated),
            ],
            make: { values in
                var v = values
                let placeholder = v.string("placeholder")
                let cornerRadius = v.double("cornerRadius")
                let fill = v.color("fill")
                let onSubmit = v.action("onSubmit")
                return AnyView(StateHost("") { text in
                    BraisenlyPromptField(LocalizedStringResource(String.LocalizationValue(placeholder)), text: text,
                                         cornerRadius: cornerRadius, fill: fill, onSubmit: onSubmit)
                })
            }),
        CatalogEntry(
            id: "fields.keyEntryField", group: .fields, typeName: "BraisenlyKeyEntryField",
            title: "Key Entry Field",
            summary: "Secret entry with reveal toggle.",
            snippet: """
            @State private var key = ""
            BraisenlyKeyEntryField(title: {{title}}, placeholder: {{placeholder}}, text: $key)
            """,
            knobs: [
                .text(key: "title", label: "Title", default: "OpenAI API key"),
                .text(key: "placeholder", label: "Placeholder", default: "sk-…"),
            ],
            make: { values in
                var v = values
                let title = v.string("title")
                let placeholder = v.string("placeholder")
                return AnyView(StateHost("") { text in
                    BraisenlyKeyEntryField(title: title, placeholder: placeholder, text: text)
                })
            }),
        CatalogEntry(
            id: "fields.parameterSliderRow", group: .fields, typeName: "BraisenlyParameterSliderRow",
            title: "Parameter Slider Row",
            summary: "Titled slider with a formatted value readout.",
            snippet: """
            @State private var value = 0.6
            BraisenlyParameterSliderRow(title: {{title}}, value: $value, in: 0...{{upperBound}}, step: {{step}}, formatString: "{{formatString}}")
            """,
            knobs: [
                .text(key: "title", label: "Title", default: "Temperature"),
                .double(key: "upperBound", label: "Upper bound", range: 0.5...5, step: 0.5, default: 1.5),
                .double(key: "step", label: "Step", range: 0.01...1, step: 0.01, default: 0.1),
                .pick(key: "formatString", label: "Format", options: ["%.0f", "%.1f", "%.2f"], default: "%.1f"),
            ],
            make: { values in
                var v = values
                let title = v.string("title")
                let upperBound = v.double("upperBound")
                let step = v.double("step")
                let formatString = v.string("formatString")
                return AnyView(StateHost(0.6) { value in
                    BraisenlyParameterSliderRow(title: title, value: value, in: 0...upperBound, step: step, formatString: formatString)
                })
            }),
        CatalogEntry(
            id: "fields.textFieldRow", group: .fields, typeName: "BraisenlyTextFieldRow",
            title: "Text Field Row",
            summary: "Captioned single- or multi-line text row on a content card.",
            snippet: """
            @State private var text = ""
            BraisenlyTextFieldRow({{title}}, text: $text, prompt: {{prompt}}, axis: .{{axis}})
            """,
            knobs: [
                .text(key: "title", label: "Title", default: "Name"),
                .text(key: "prompt", label: "Prompt", default: "Untitled"),
                .pick(key: "axis", label: "Axis", options: ["horizontal", "vertical"], default: "horizontal"),
            ],
            make: { values in
                var v = values
                let title = v.string("title")
                let prompt = v.string("prompt")
                let axis: Axis = v.string("axis") == "vertical" ? .vertical : .horizontal
                return AnyView(StateHost("") { text in
                    BraisenlyTextFieldRow(title, text: text, prompt: prompt, axis: axis)
                })
            }),
    ]
}

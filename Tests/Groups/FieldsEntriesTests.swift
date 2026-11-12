import Testing
@testable import BraisenlySwiftDemo

@Suite struct FieldsEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(FieldsEntries.entries.map(\.id) == ["fields.promptField", "fields.keyEntryField", "fields.parameterSliderRow", "fields.textFieldRow"])
        #expect(FieldsEntries.entries.map(\.typeName) == ["BraisenlyPromptField", "BraisenlyKeyEntryField", "BraisenlyParameterSliderRow", "BraisenlyTextFieldRow"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: FieldsEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == [
            "fields.promptField": ["placeholder", "cornerRadius", "fill"],
            "fields.keyEntryField": ["title", "placeholder"],
            "fields.parameterSliderRow": ["title", "upperBound", "step", "formatString"],
            "fields.textFieldRow": ["title", "prompt", "axis"],
        ])
    }
}

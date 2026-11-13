import Testing
@testable import BraisenlySwiftDemo

@Suite struct ControlsEntriesTests {
    @Test func idsAndTypeNamesMatchSpec() {
        #expect(ControlsEntries.entries.map(\.id) == ["controls.segmentedControl","controls.toggleRow","controls.stepperRow","controls.chipGroup","controls.sectionHeader","controls.navRow","controls.propertyTable","controls.emptyState"])
        #expect(ControlsEntries.entries.map(\.typeName) == ["BraisenlySegmentedControl","BraisenlyToggleRow","BraisenlyStepperRow","BraisenlyChipGroup","BraisenlySectionHeader","BraisenlyNavRow","BraisenlyPropertyTable","BraisenlyEmptyState"])
    }

    @Test func knobKeysMatchSpec() {
        #expect(Dictionary(uniqueKeysWithValues: ControlsEntries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == ["controls.segmentedControl": ["optionCount","platform"], "controls.toggleRow": ["title","subtitle"], "controls.stepperRow": ["title","upperBound","step"], "controls.chipGroup": ["optionCount"], "controls.sectionHeader": ["title","systemImage","trailing"], "controls.navRow": ["title","systemImage","badge","isSelected","platform"], "controls.propertyTable": ["rowCount"], "controls.emptyState": ["title","message","systemImage","actionTitle"]])
    }
}

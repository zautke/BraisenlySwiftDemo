import BraisenlySwiftUI

/// Static sample data shared by group entry files. No model loads, no I/O.
enum Fixtures {
    static let documentText = """
    Liquid Glass belongs on controls and navigation, never on the content it frames. The reading surface stays solid so \
    text keeps its contrast while the chrome around it refracts the page beneath.

    Every token in this catalog comes from the environment theme. Switch between Liquid Glass and the two Solarized themes \
    and the same views re-resolve their colors, fonts and metrics without rebuilding.

    The glass surfaces here are grouped by one container per screen, so morphing between controls stays smooth and the \
    renderer never nests glass inside glass.
    """

    static let searchParagraph = "Liquid Glass is applied only to control and chrome surfaces; content surfaces stay solid so that long passages of glass-free text remain legible on every theme."

    static let codeSample = """
    struct ReadyCard: View {
        var body: some View {
            BraisenlyText("Model ready", style: .rowLabelMedium)
                .braisenlyPadding(.all, .l)
                .braisenlyCard()
        }
    }
    """

    static let actionItems: [BraisenlyActionItem] = [
        BraisenlyActionItem(id: "pin", icon: "pin", title: "Pin"),
        BraisenlyActionItem(id: "rename", icon: "pencil", title: "Rename"),
        BraisenlyActionItem(id: "share", icon: "square.and.arrow.up", title: "Share"),
        BraisenlyActionItem(id: "duplicate", icon: "doc.on.doc", title: "Duplicate"),
        BraisenlyActionItem(id: "archive", icon: "archivebox", title: "Archive", isChecked: true),
        BraisenlyActionItem(id: "trash", icon: "trash", title: "Delete"),
    ]

    static let modelNames = ["LFM3 1.7B", "Qwen3.5 4B", "Gemma4 E4B", "Apple On-Device", "Claude Sonnet", "GPT-4o", "LFM3 Omni", "LFM3 bf16"]

    static let propertyRows: [BraisenlyPropertyTable.Row] = [
        .init(key: "Model", value: "LFM3 1.7B"),
        .init(key: "Quantization", value: "4-bit"),
        .init(key: "Context", value: "32k tokens"),
        .init(key: "Temperature", value: "0.6"),
        .init(key: "Top-p", value: "0.9"),
        .init(key: "Tools", value: "enabled"),
        .init(key: "Memory", value: "1.2 GB"),
        .init(key: "Updated", value: "2m ago"),
    ]

    static let segmentOptions = ["Files", "Search", "Tags", "Bookmarks", "All"]
}

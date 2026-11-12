import SwiftUI
import BraisenlySwiftUI

struct CatalogDetail: View {
    let entry: CatalogEntry
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var log = ActionLog()
    @State private var values: KnobValues

    init(entry: CatalogEntry) {
        self.entry = entry
        let log = ActionLog()
        _log = State(initialValue: log)
        _values = State(initialValue: KnobValues(knobs: entry.knobs, theme: .liquidGlass, log: log))
    }

    var body: some View {
        BraisenlyScroll {
            BraisenlyVStack(alignment: .leading, spacing: .l) {
                BraisenlyText(entry.title, style: .documentTitle)
                BraisenlyText(entry.summary, style: .bodyReading, tone: .secondary)
                stage
                KnobsPane(knobs: entry.knobs, values: $values, typeName: entry.typeName, lastAction: log.last)
                SnippetPane(title: entry.title, code: entry.renderSnippet(values)) { log.record("Copied snippet") }
            }
            .braisenlyPadding(.all, .l)
            .frame(maxWidth: BraisenlyPlatform.automatic.resolved(horizontalSizeClass: sizeClass).contentMaxWidth)
        }
        .accessibilityIdentifier("catalog.detail")
        .accessibilityValue(entry.id)
        .onChange(of: theme.id, initial: true) { values.theme = theme }
    }

    @ViewBuilder private var stage: some View {
        switch entry.presentation {
        case .inline:
            BraisenlyHStack {
                BraisenlySpacer()
                entry.make(values)
                BraisenlySpacer()
            }
            .braisenlyPadding(.all, .l)
            .frame(minHeight: 160)
            .braisenlyCard()
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Live preview of \(entry.title)")
            .accessibilityIdentifier("catalog.stage")
        case .canvas(let height):
            entry.make(values)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipped()
                .braisenlyCard()
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Live preview of \(entry.title)")
                .accessibilityIdentifier("catalog.stage")
        }
    }
}

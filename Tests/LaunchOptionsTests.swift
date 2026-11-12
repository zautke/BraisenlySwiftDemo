import Testing
import Foundation
import BraisenlySwiftUI
@testable import BraisenlySwiftDemo

@Suite struct LaunchOptionsTests {
    private func defaults(_ pairs: [String: String]) -> UserDefaults {
        let d = UserDefaults(suiteName: "LaunchOptionsTests.\(UUID())")!
        for (k, v) in pairs { d.set(v, forKey: k) }
        return d
    }

    @Test func readsEntryAndTheme() {
        let o = LaunchOptions(defaults: defaults(["catalogEntry": "cards.statusCard", "catalogTheme": "solarizedDark"]))
        #expect(o.entryID == "cards.statusCard")
        #expect(o.themeID == "solarizedDark")
    }

    @Test func missingKeysAreNil() {
        let o = LaunchOptions(defaults: defaults([:]))
        #expect(o.entryID == nil)
        #expect(o.themeID == nil)
    }

    @Test func unknownEntryIDYieldsNoSelection() {
        #expect(DemoApp.initialSelection(for: LaunchOptions(defaults: defaults(["catalogEntry": "nope"]))) == nil)
    }

    @Test func unknownThemeIDNormalisesToLiquidGlass() {
        #expect(DemoApp.initialThemeID(for: LaunchOptions(defaults: defaults(["catalogTheme": "nope"]))) == "liquidGlass")
        #expect(DemoApp.initialThemeID(for: LaunchOptions(defaults: defaults([:]))) == "liquidGlass")
        #expect(DemoApp.initialThemeID(for: LaunchOptions(defaults: defaults(["catalogTheme": "solarizedDark"]))) == "solarizedDark")
    }
}

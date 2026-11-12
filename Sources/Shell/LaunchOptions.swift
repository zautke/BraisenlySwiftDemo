import Foundation

/// `-catalogEntry <id>` and `-catalogTheme <id>` launch arguments (UserDefaults argument domain).
nonisolated struct LaunchOptions {
    let entryID: String?
    let themeID: String?

    init(defaults: UserDefaults) {
        entryID = defaults.string(forKey: "catalogEntry")
        themeID = defaults.string(forKey: "catalogTheme")
    }
}

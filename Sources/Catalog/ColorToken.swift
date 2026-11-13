import SwiftUI
import BraisenlySwiftUI

nonisolated enum ColorToken: String, CaseIterable {
    case backgroundPrimary, backgroundDimmed, surfaceSheet, surfaceElevated, surfaceHighlight, surfaceSnippet, borderSubtle,
         divider, accentTeal, textPrimary, textBright, textSecondary, textDisabled, matchBackground, matchForeground,
         danger, warning, success, scrim, shadow
    case solarizedBase03, solarizedBase02, solarizedBase01, solarizedBase00, solarizedBase0, solarizedBase1, solarizedBase2,
         solarizedBase3, solarizedYellow, solarizedOrange, solarizedRed, solarizedMagenta, solarizedViolet, solarizedBlue,
         solarizedCyan, solarizedGreen

    static var themeTokens: [ColorToken] { Array(allCases.prefix(20)) }
    static var solarized: [ColorToken] { Array(allCases.suffix(16)) }

    private var solarizedName: String? {
        guard rawValue.hasPrefix("solarized") else { return nil }
        let rest = rawValue.dropFirst("solarized".count)
        return rest.prefix(1).lowercased() + rest.dropFirst()
    }

    var snippetExpression: String {
        if let s = solarizedName { "BraisenlyDS.Solarized.\(s)" } else { "theme.colors.\(rawValue)" }
    }

    func color(in theme: BraisenlyThemeDefinition) -> Color {
        let c = theme.colors
        return switch self {
        case .backgroundPrimary: c.backgroundPrimary
        case .backgroundDimmed: c.backgroundDimmed
        case .surfaceSheet: c.surfaceSheet
        case .surfaceElevated: c.surfaceElevated
        case .surfaceHighlight: c.surfaceHighlight
        case .surfaceSnippet: c.surfaceSnippet
        case .borderSubtle: c.borderSubtle
        case .divider: c.divider
        case .accentTeal: c.accentTeal
        case .textPrimary: c.textPrimary
        case .textBright: c.textBright
        case .textSecondary: c.textSecondary
        case .textDisabled: c.textDisabled
        case .matchBackground: c.matchBackground
        case .matchForeground: c.matchForeground
        case .danger: c.danger
        case .warning: c.warning
        case .success: c.success
        case .scrim: c.scrim
        case .shadow: c.shadow
        case .solarizedBase03: BraisenlyDS.Solarized.base03
        case .solarizedBase02: BraisenlyDS.Solarized.base02
        case .solarizedBase01: BraisenlyDS.Solarized.base01
        case .solarizedBase00: BraisenlyDS.Solarized.base00
        case .solarizedBase0: BraisenlyDS.Solarized.base0
        case .solarizedBase1: BraisenlyDS.Solarized.base1
        case .solarizedBase2: BraisenlyDS.Solarized.base2
        case .solarizedBase3: BraisenlyDS.Solarized.base3
        case .solarizedYellow: BraisenlyDS.Solarized.yellow
        case .solarizedOrange: BraisenlyDS.Solarized.orange
        case .solarizedRed: BraisenlyDS.Solarized.red
        case .solarizedMagenta: BraisenlyDS.Solarized.magenta
        case .solarizedViolet: BraisenlyDS.Solarized.violet
        case .solarizedBlue: BraisenlyDS.Solarized.blue
        case .solarizedCyan: BraisenlyDS.Solarized.cyan
        case .solarizedGreen: BraisenlyDS.Solarized.green
        }
    }
}

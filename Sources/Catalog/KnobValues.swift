import SwiftUI
import BraisenlySwiftUI

nonisolated struct KnobValues {
    var theme: BraisenlyThemeDefinition
    private var storage: [String: KnobValue]
    private let log: ActionLog
    // Reads of undeclared keys are recorded here instead of trapping; the registry invariant test asserts it stays empty.
    private(set) var missingKeys: Set<String> = []

    init(knobs: [Knob], theme: BraisenlyThemeDefinition, log: ActionLog) {
        self.theme = theme
        self.log = log
        storage = Dictionary(uniqueKeysWithValues: knobs.map { ($0.key, $0.defaultValue) })
    }

    subscript(key: String) -> KnobValue? {
        get { storage[key] }
        set { storage[key] = newValue }
    }

    private mutating func read(_ key: String) -> KnobValue? {
        if let v = storage[key] { return v }
        missingKeys.insert(key)
        return nil
    }

    mutating func bool(_ key: String) -> Bool { if case .bool(let b) = read(key) { b } else { false } }
    mutating func int(_ key: String) -> Int { if case .int(let i) = read(key) { i } else { 0 } }
    mutating func double(_ key: String) -> Double { if case .double(let d) = read(key) { d } else { 0 } }
    mutating func string(_ key: String) -> String { if case .string(let s) = read(key) { s } else { "" } }
    mutating func optionalString(_ key: String) -> String? { let s = string(key); return s.isEmpty ? nil : s }
    mutating func colorToken(_ key: String) -> ColorToken { if case .color(let c) = read(key) { c } else { .textPrimary } }
    mutating func color(_ key: String) -> Color { colorToken(key).color(in: theme) }

    func action(_ name: String) -> () -> Void { let log = log; return { log.record(name) } }

    mutating func platform(_ key: String = "platform") -> BraisenlyPlatform {
        switch string(key) {
        case "iPhone": .iPhone
        case "iPad": .iPad
        case "mac": .mac
        default: .automatic
        }
    }
    mutating func step(_ key: String = "spacing") -> BraisenlyStep { BraisenlyStep(rawValue: string(key)) ?? .zero }
    mutating func textStyle(_ key: String = "style") -> BraisenlyTextStyle { BraisenlyTextStyle(rawValue: string(key)) ?? .documentTitle }
    mutating func tone(_ key: String = "tone") -> BraisenlyTone { BraisenlyTone(rawValue: string(key)) ?? .primary }
    mutating func font(_ key: String) -> Font { textStyle(key).font(in: theme.typography) }
}

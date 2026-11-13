import BraisenlySwiftUI

nonisolated enum Knob: Identifiable, Sendable {
    case bool(key: String, label: String, default: Bool)
    case int(key: String, label: String, range: ClosedRange<Int>, default: Int)
    case double(key: String, label: String, range: ClosedRange<Double>, step: Double, default: Double)
    case pick(key: String, label: String, options: [String], default: String)
    case text(key: String, label: String, default: String)
    case color(key: String, label: String, options: [ColorToken], default: ColorToken)

    var id: String { key }

    var key: String {
        switch self {
        case .bool(let k, _, _), .int(let k, _, _, _), .double(let k, _, _, _, _), .pick(let k, _, _, _), .text(let k, _, _), .color(let k, _, _, _): k
        }
    }

    var label: String {
        switch self {
        case .bool(_, let l, _), .int(_, let l, _, _), .double(_, let l, _, _, _), .pick(_, let l, _, _), .text(_, let l, _), .color(_, let l, _, _): l
        }
    }

    var defaultValue: KnobValue {
        switch self {
        case .bool(_, _, let d): .bool(d)
        case .int(_, _, _, let d): .int(d)
        case .double(_, _, _, _, let d): .double(d)
        case .pick(_, _, _, let d): .string(d)
        case .text(_, _, let d): .string(d)
        case .color(_, _, _, let d): .color(d)
        }
    }

    static let platformOptions = ["automatic", "iPhone", "iPad", "mac"]

    static func platform(default: String = "automatic") -> Knob {
        .pick(key: "platform", label: "Platform", options: platformOptions, default: `default`)
    }
    static func step(key: String = "spacing", label: String = "Spacing", default: String = "m") -> Knob {
        .pick(key: key, label: label, options: BraisenlyStep.allCases.map(\.rawValue), default: `default`)
    }
    static func textStyle(key: String = "style", label: String = "Text style", default: String = "rowLabel") -> Knob {
        .pick(key: key, label: label, options: BraisenlyTextStyle.allCases.map(\.rawValue), default: `default`)
    }
    static func tone(key: String = "tone", default: String = "primary") -> Knob {
        .pick(key: key, label: "Tone", options: BraisenlyTone.allCases.map(\.rawValue), default: `default`)
    }
}

nonisolated enum KnobValue: Hashable, Sendable { case bool(Bool), int(Int), double(Double), string(String), color(ColorToken) }

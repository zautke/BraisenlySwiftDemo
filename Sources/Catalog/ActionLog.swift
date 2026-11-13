import Observation

@Observable nonisolated final class ActionLog {
    private(set) var last: String?
    private(set) var count = 0
    // Undeclared knob keys read through any copy of the KnobValues that share this log.
    @ObservationIgnored private(set) var missingKeys: Set<String> = []
    func recordMissing(_ key: String) { missingKeys.insert(key) }
    func record(_ name: String) { last = name; count += 1 }
    func clear() { last = nil; count = 0 }
}

import Observation

@Observable nonisolated final class ActionLog {
    private(set) var last: String?
    private(set) var count = 0
    func record(_ name: String) { last = name; count += 1 }
    func clear() { last = nil; count = 0 }
}

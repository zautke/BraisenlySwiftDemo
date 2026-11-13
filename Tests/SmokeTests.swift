import Testing

@Suite struct SmokeTests {
    @Test func appModuleLoads() { #expect(Bool(true)) }
}

import XCTest

/// Walks every catalog entry in every theme and attaches one screenshot per (theme, entry). Spec §13.
final class CatalogWalkTests: XCTestCase {
    nonisolated(unsafe) private static let entryIDs: [String] = {
        let url = Bundle(for: CatalogWalkTests.self).url(forResource: "catalog-entry-ids", withExtension: "txt", subdirectory: "Fixtures")!
        return try! String(contentsOf: url, encoding: .utf8).split(separator: "\n").map(String.init)
    }()

    override func setUpWithError() throws { continueAfterFailure = true }

    @MainActor private func launch(entry: String, theme: String) -> XCUIApplication {
        let app = XCUIApplication()
        // Ignore restored window frames: XCTest cannot screenshot a window restored onto a secondary display.
        app.launchArguments = ["-catalogEntry", entry, "-catalogTheme", theme, "-ApplePersistenceIgnoreState", "YES"]
        app.launch()
        return app
    }

    @MainActor private func attach(_ app: XCUIApplication, name: String) {
        #if os(macOS)
        let a = XCTAttachment(image: windowImage(app))
        #else
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        #endif
        a.name = name.replacingOccurrences(of: "/", with: "-").replacingOccurrences(of: ".", with: "-")  // xcresulttool export truncates at "." and drops "/"
        a.lifetime = .keepAlways
        add(a)
    }

    #if os(macOS)
    /// XCTest fails element screenshots for windows on a secondary display ("Image creation failed"),
    /// so capture the whole display that holds the window and crop to the window frame.
    @MainActor private func windowImage(_ app: XCUIApplication) -> NSImage {
        let frame = app.windows.firstMatch.frame  // global points, top-left origin
        let mainHeight = NSScreen.screens[0].frame.height
        let index = NSScreen.screens.firstIndex { screen in
            CGRect(x: screen.frame.minX, y: mainHeight - screen.frame.maxY, width: screen.frame.width, height: screen.frame.height)
                .contains(CGPoint(x: frame.midX, y: frame.midY))
        } ?? 0
        let screen = NSScreen.screens[index]
        let full = XCUIScreen.screens[index].screenshot().image
        guard let cg = full.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return full }
        let scale = CGFloat(cg.width) / screen.frame.width
        let crop = CGRect(x: (frame.minX - screen.frame.minX) * scale, y: (frame.minY - (mainHeight - screen.frame.maxY)) * scale,
                          width: frame.width * scale, height: frame.height * scale)
        guard let cut = cg.cropping(to: crop) else { return full }
        return NSImage(cgImage: cut, size: frame.size)
    }
    #endif

    @MainActor private func walk(theme: String) {
        for id in Self.entryIDs {
            let app = launch(entry: id, theme: theme)
            let stage = app.descendants(matching: .any)["catalog.stage"].firstMatch
            XCTAssertTrue(stage.waitForExistence(timeout: 10), "\(theme)/\(id): stage missing")
            let detail = app.descendants(matching: .any)["catalog.detail"].firstMatch
            XCTAssertEqual(detail.value as? String, id, "\(theme)/\(id): detail value")
            attach(app, name: "\(theme)/\(id)")
            app.terminate()
        }
    }

    @MainActor func testWalkLiquidGlass() { walk(theme: "liquidGlass") }
    @MainActor func testWalkSolarizedLight() { walk(theme: "solarizedLight") }
    @MainActor func testWalkSolarizedDark() { walk(theme: "solarizedDark") }

    /// One entry per group: screenshot, mutate the named knob, screenshot, assert the snippet changed.
    @MainActor func testKnobSmoke() {
        let cases: [(entry: String, knob: String, kind: String)] = [
            ("tokens.colors", "showNames", "toggle"), ("layout.vStack", "alignment", "segment"),
            ("modifiers.glassSurfaces", "surface", "segment"), ("buttonsPills.sendStopButton", "isResponding", "toggle"),
            ("indicators.colorSwatch", "isSelected", "toggle"), ("fields.textFieldRow", "title", "text"),
            ("controls.toggleRow", "title", "text"), ("cards.bannerCard", "dismissible", "toggle"),
            ("rowsGroups.conversationRow", "isSelected", "toggle"), ("sidebar.modes", "showIcons", "toggle"),
            ("document.bottomToolbar", "tabCount", "stepper"), ("workspaces.regular", "platform", "segment"),
        ]
        for c in cases {
            let app = launch(entry: c.entry, theme: "liquidGlass")
            let snippet = app.descendants(matching: .any)["catalog.snippet"].firstMatch
            XCTAssertTrue(snippet.waitForExistence(timeout: 10), "\(c.entry): snippet missing")
            let before = snippet.label + (snippet.value as? String ?? "")
            attach(app, name: "knob/\(c.entry)/before")
            let knob = app.descendants(matching: .any)["knob.\(c.knob)"].firstMatch
            XCTAssertTrue(knob.waitForExistence(timeout: 5), "\(c.entry): knob \(c.knob) missing")
            reveal(knob, in: app)
            mutate(knob, kind: c.kind, in: app)
            attach(app, name: "knob/\(c.entry)/after")
            let after = snippet.label + (snippet.value as? String ?? "")
            XCTAssertNotEqual(before, after, "\(c.entry): snippet unchanged after \(c.knob)")
            app.terminate()
        }
    }

    /// macOS does not scroll an off-screen control into view before clicking; iOS tap does.
    @MainActor private func reveal(_ knob: XCUIElement, in app: XCUIApplication) {
        #if os(macOS)
        let detail = app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.5))
        for _ in 0..<10 where !knob.isHittable { detail.scroll(byDeltaX: 0, deltaY: -160) }
        #endif
    }

    @MainActor private func mutate(_ knob: XCUIElement, kind: String, in app: XCUIApplication) {
        switch kind {
        case "toggle":
            let sw = knob.switches.firstMatch.exists ? knob.switches.firstMatch : knob.checkBoxes.firstMatch
            (sw.exists ? sw : knob).activate()
        case "stepper":
            #if os(macOS)
            let arrow = knob.incrementArrows.firstMatch
            if arrow.exists { arrow.click() } else { knob.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.25)).click() }
            #else
            (knob.buttons.allElementsBoundByIndex.last ?? knob).activate()
            #endif
        case "segment":
            let buttons = knob.buttons.allElementsBoundByIndex
            (buttons.first { !$0.isSelected } ?? knob).activate()
        default:
            let field = knob.textFields.firstMatch.exists ? knob.textFields.firstMatch : knob
            field.activate()
            field.typeText("x")
        }
    }

    /// Typed stage text survives a theme switch (view structure is constant across themes).
    @MainActor func testStatePersistsAcrossThemeSwitch() {
        let app = launch(entry: "fields.textFieldRow", theme: "liquidGlass")
        let stage = app.descendants(matching: .any)["catalog.stage"].firstMatch
        XCTAssertTrue(stage.waitForExistence(timeout: 10))
        let field = stage.textFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.activate()
        field.typeText("abc")
        let pill = app.buttons["Solarized Dark"].firstMatch
        XCTAssertTrue(pill.waitForExistence(timeout: 5), "theme pill missing")
        pill.activate()
        XCTAssertEqual(stage.textFields.firstMatch.value as? String, "abc")
        app.terminate()
    }

    /// A split view nested in the detail must not trap the app's own sidebar navigation.
    @MainActor func testSplitViewEntryDoesNotTrapNavigation() {
        let app = launch(entry: "layout.splitView", theme: "liquidGlass")
        XCTAssertTrue(app.descendants(matching: .any)["catalog.stage"].firstMatch.waitForExistence(timeout: 10))
        let row = app.descendants(matching: .any)["catalog.row.layout.text"].firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        row.activate()
        let detail = app.descendants(matching: .any)["catalog.detail"].firstMatch
        let ok = NSPredicate(format: "value == 'layout.text'")
        let exp = expectation(for: ok, evaluatedWith: detail)
        wait(for: [exp], timeout: 10)
        app.terminate()
    }
}

private extension XCUIElement {
    @MainActor func activate() {
        #if os(macOS)
        click()
        #else
        tap()
        #endif
    }
}

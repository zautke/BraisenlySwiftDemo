# BraisenlySwiftDemo Catalog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship BraisenlySwiftDemo 0.1.0, a Storybook-style catalog app that renders every public BraisenlySwiftUI view live with typed knobs, built only from package components, on iPadOS/iOS 26+ and macOS 26+.

**Architecture:** One multiplatform xcodegen target (`project.yml` SSoT, values from `.env`) consuming the package as a local path dependency. An explicit typed registry (`CatalogEntry` per component, one file per `CatalogGroup`) feeds a `BraisenlySplitView` shell (sidebar, detail with stage, knobs pane, snippet). Correctness nets: Swift Testing registry/completeness tests, a dog-food lint, and an XCUITest walk that screenshots every entry in every theme on presto and macOS.

**Tech Stack:** Swift 6.4.2 (Swift 6 mode, default MainActor isolation), SwiftUI, BraisenlySwiftUI (local package), xcodegen 2.44.1, Swift Testing, XCTest/XCUITest, bash scripts, `jq`, `swift symbolgraph-extract`, `xcrun devicectl`.

**Spec:** `docs/superpowers/specs/2026-11-08-demo-catalog-design.md` (section refs below are "spec §n"). Lockstep, not implemented here: `docs/superpowers/specs/2026-11-08-ai-catalog-design.md` (only its stub, AI spec §3, lands in Task 3).

## Global Constraints

- Zero bare SwiftUI in `Sources/` (U-3): banned tokens and allowed constructs exactly as spec §2 AG-1 and §11. Run `scripts/dogfood-lint.sh` before every commit once Task 2 lands.
- No component, wrapper or token defined in the demo; missing building blocks are reported as a package gap (`open_issues`), never worked around.
- Destinations: iOS 26.0 and macOS 26.0 deployment targets; physical devices only — presto `id=$DEVICE_UDID`, macOS `$MAC_DESTINATION`. Any `Simulator` destination is refused (exit 2).
- All config from `.env` (keys: `BRAISENLY_PACKAGE_PATH`, `DEVELOPMENT_TEAM`, `BUNDLE_ID_PREFIX`, `DEVICE_UDID`, `MAC_DESTINATION`, `SYMBOLGRAPH_TARGET`). No literal team id, UDID, bundle prefix or package path in scripts or Swift.
- During development `.env` has `BRAISENLY_PACKAGE_PATH=../BraisenlySwiftUI-catalog`; `.env.example` ships `../BraisenlySwiftUI`.
- Swift 6 language mode, `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, `SWIFT_APPROACHABLE_CONCURRENCY = YES` on every target.
- Scripts: `#!/usr/bin/env bash`, `set -euo pipefail`, a `Usage()` function, every switch with short and long form, no positional arguments.
- Unit tests: Swift Testing (`import Testing`, `@Test`, `#expect`, `#require`). UI tests: XCTest.
- Versions: `MARKETING_VERSION = 0.1.0`, three numbers only. `CHANGELOG.md` (not `changeset.md`).
- Commits: Conventional Commits with scopes, pushed to the demo repo's draft PR into `development`. Each commit ends with the session attribution lines the coordinator supplies.
- Parallel tasks run in isolated git worktrees branched from the feature branch (Agent `isolation: "worktree"`), each copying `.env` in and using its own `-derivedDataPath build/DerivedData-T<n>`; the coordinator merges them in task order.
- Precondition for Task 1 (spec §3): the package 0.2.0 work (package spec `BraisenlySwiftUI-catalog/docs/superpowers/specs/2026-11-08-themable-tokens-and-catalog-primitives-design.md`) is on the package worktree. Demo tasks never edit the package; a missing or different package API is reported as `blocked` with the exact compiler error.

## Review Focus

1. Nested split view: `layout.splitView` renders a `BraisenlySplitView` inside the app's split view detail; selecting another sidebar row afterwards must still change the detail (Task 18 `testSplitViewEntryDoesNotTrapNavigation`).
2. Bad launch arguments: unknown `-catalogEntry` gives no selection and the empty state, unknown `-catalogTheme` gives Liquid Glass, never a crash (Task 4 `unknownEntryIDYieldsNoSelection`, `unknownThemeIDNormalisesToLiquidGlass`).
3. Search input: whitespace-only query shows everything, matching is case- and diacritic-insensitive, no-match shows the empty state (Task 3 `sectionsMatching*` tests).
4. Knobs at their bounds: every int/double knob at its lower and upper bound, and every text knob set to `""`, must render without trapping (Task 3 `rendersAtKnobBounds`, via `ImageRenderer`).
5. Snippet literals: text knob values containing quotes, backslashes or newlines must render as valid escaped Swift string literals (Task 3 `snippetEscapesStringLiterals`).

---

## Parallel groups

| Group | Tasks | Runs after |
|---|---|---|
| P0 | 1 | package D-1..D-3 available |
| P1 | 2, 3 | P0 |
| P2 | 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 | P1 |
| P3 | 17, 18, 19 | P2 |
| P4 | 20 | P3 |

---

### Task 1: Scaffold, project generation and both-destination builds

**Files:**
- Create: `project.yml`, `.env.example`, `scripts/lib/common.sh`, `scripts/gen.sh`, `scripts/build-mac.sh`, `scripts/build-ios.sh`, `scripts/test-unit.sh`, `scripts/deploy-presto.sh`, `scripts/run-mac.sh`, `scripts/check.sh`, `scripts/tests/simulator-refusal-negative.sh`
- Create: `Sources/DemoApp.swift` (placeholder), `Tests/SmokeTests.swift`, `Tests/Fixtures/.gitkeep`, `UITests/LaunchSmokeTests.swift`, `UITests/Fixtures/.gitkeep`

**Interfaces:**
- Consumes: package products `BraisenlySwiftUI`, `BraisenlyAI` at `$BRAISENLY_PACKAGE_PATH`.
- Produces: targets/schemes `BraisenlySwiftDemo`, `BraisenlySwiftDemo-AI`, `BraisenlySwiftDemoTests`, `BraisenlySwiftDemoUITests` exactly as spec §12; `scripts/lib/common.sh` functions `load_env`, `require_vars <VAR...>`, `refuse_simulator <destination>`, `repo_root`; `scripts/test-unit.sh -o/--only <xcodebuild only-testing id>` (default all of `BraisenlySwiftDemoTests`, destination `$MAC_DESTINATION`, accepts `-d/--derived-data <path>`); every later task runs tests through it.

- [ ] **Step 1: Write the failing negative test** `scripts/tests/simulator-refusal-negative.sh`: runs `scripts/build-ios.sh -d "platform=iOS Simulator,name=iPad Pro"`; PASS iff exit code is 2 and stderr contains `refusing simulator destination`; prints `PASS simulator-refusal` / `FAIL ...`.
- [ ] **Step 2: Run it to verify it fails**
  Run: `bash scripts/tests/simulator-refusal-negative.sh`
  Expected: FAIL (build-ios.sh does not exist yet).
- [ ] **Step 3: Write `.env.example` (spec §12 verbatim) and a local `.env`** copied from it with `BRAISENLY_PACKAGE_PATH=../BraisenlySwiftUI-catalog`.
- [ ] **Step 4: Write `scripts/lib/common.sh` and all scripts in the Files list** with the switches and behaviour of spec §12 table (`check.sh` at this stage: gen → test-unit → build-mac → build-ios, with `-a/--ai`; later tasks insert their steps). Placeholder `Sources/DemoApp.swift`: `@main struct DemoApp: App` whose `WindowGroup` shows `BraisenlyEmptyState(title: "Braisenly Catalog", message: "Scaffold", systemImage: "sparkles")`. `Tests/SmokeTests.swift`: `@Test func appModuleLoads() { #expect(Bool(true)) }`. `UITests/LaunchSmokeTests.swift`: launches the app and asserts `app.wait(for: .runningForeground, timeout: 10)`.
- [ ] **Step 5: Write `project.yml`** per spec §12 (no pre-build lint phase yet; Task 2 adds it).
- [ ] **Step 6: Generate and build both destinations**
  Run: `scripts/gen.sh && scripts/build-mac.sh && scripts/build-ios.sh -g && scripts/build-mac.sh -s BraisenlySwiftDemo-AI`
  Expected: four `** BUILD SUCCEEDED **` (the AI build compiles MLX, allow ~5 min cold).
- [ ] **Step 7: Run unit smoke test and the negative test**
  Run: `scripts/test-unit.sh && bash scripts/tests/simulator-refusal-negative.sh`
  Expected: `** TEST SUCCEEDED **` then `PASS simulator-refusal`.
- [ ] **Step 8: Verify `gen.sh` refuses a missing key**
  Run: `mv .env .env.bak; env -u BRAISENLY_PACKAGE_PATH scripts/gen.sh; echo "exit=$?"; mv .env.bak .env`
  Expected: message naming `BRAISENLY_PACKAGE_PATH`, `exit=2`.
- [ ] **Step 9: Commit**
  `git add project.yml .env.example .gitignore scripts Sources Tests UITests && git commit -m "build(scaffold): add xcodegen project, env template and device-only scripts"`

### Task 2: Dog-food lint and its negative test

**Files:**
- Create: `scripts/dogfood-lint.sh`, `scripts/tests/dogfood-lint-negative.sh`
- Modify: `scripts/check.sh` (insert lint as step 2 and the negative test at the end), `project.yml` (add `preBuildScripts` "Dog-food lint" running `"$SRCROOT/scripts/dogfood-lint.sh" -p "$SRCROOT/Sources"` and `ENABLE_USER_SCRIPT_SANDBOXING: NO` on both app targets)

**Interfaces:**
- Consumes: `scripts/lib/common.sh` (Task 1).
- Produces: `scripts/dogfood-lint.sh -p/--path <dir>`; exit 0 clean, 1 on hits (`path:line: banned: <match>` lines + `dogfood-lint: <n> hit(s)`), 2 usage error. Regex exactly spec §11.

- [ ] **Step 1: Write the failing negative test** `scripts/tests/dogfood-lint-negative.sh` exactly as spec §11 (temp dir via `mktemp -d`, `Bad.swift` 5 lines, `Good.swift` 4 lines; PASS iff exit 1, exactly 5 hit lines, all `Bad.swift`).
- [ ] **Step 2: Run it to verify it fails**
  Run: `bash scripts/tests/dogfood-lint-negative.sh`
  Expected: FAIL (lint script missing).
- [ ] **Step 3: Implement `scripts/dogfood-lint.sh`** with `grep -rnE` over `*.swift` under the path, dropping lines whose content starts with optional whitespace then `//`.
- [ ] **Step 4: Run negative test and lint the real tree**
  Run: `bash scripts/tests/dogfood-lint-negative.sh && scripts/dogfood-lint.sh`
  Expected: `PASS dogfood-lint-negative`, then `dogfood-lint: 0 hit(s)` exit 0.
- [ ] **Step 5: Wire into project and check; rebuild**
  Run: `scripts/gen.sh && scripts/build-mac.sh`
  Expected: build log contains the "Dog-food lint" phase and `** BUILD SUCCEEDED **`.
- [ ] **Step 6: Commit** `git commit -m "build(lint): enforce zero bare SwiftUI in Sources with negative test"`

### Task 3: Catalog model, knobs, registry, invariants

**Files:**
- Create: `Sources/Catalog/CatalogGroup.swift`, `CatalogEntry.swift`, `Knob.swift` (Knob, KnobValue), `KnobValues.swift` (incl. `platform/step/textStyle/tone/font` helpers), `ColorToken.swift`, `ActionLog.swift`, `StateHost.swift`, `CatalogRegistry.swift`, `Fixtures.swift`
- Create stubs (each `enum <Name>Entries { static let entries: [CatalogEntry] = [] }`, file owned by its group task later): `Sources/Catalog/Groups/{Tokens,Layout,Modifiers,ButtonsPills,Indicators,Fields,Controls,Cards,RowsGroups,Sidebar,Document,Workspaces}Entries.swift`; `Sources/Catalog/Groups/AIEntries.swift` wholly inside `#if BRAISENLY_AI` (AI spec §3 stub)
- Test: `Tests/KnobTests.swift`, `Tests/RegistryInvariantTests.swift`, `Tests/CatalogSearchTests.swift`

**Interfaces:**
- Consumes: package contract spec §4 (as reconciled in spec §17).
- Produces: every type and signature in spec §6 verbatim, plus `CatalogGroup.title`/`symbolName` values from spec §6, `Fixtures` members from spec §6, and `enum <Group>Entries { static let entries: [CatalogEntry] }` per group. `CatalogRegistry.all` concatenates the 12 group arrays in `CatalogGroup.allCases` order (+ `AIEntries.entries` under `#if BRAISENLY_AI`).

- [ ] **Step 1: Write failing tests**
  - `KnobTests`: `defaultsSeedEveryKnob` (`KnobValues(knobs: [.bool(key:"a",…,default:true), .int(key:"b",…,range:0...5,default:2), .text(key:"c",…,default:"x")], theme: BraisenlyThemes.liquidGlass, log: ActionLog())` → `bool("a") == true`, `int("b") == 2`, `string("c") == "x"`, `missingKeys.isEmpty`); `missingKeyIsRecordedNotTrapped` (`int("zzz") == 0`, `missingKeys == ["zzz"]`); `optionalStringMapsEmptyToNil`; `actionRecordsName` (`values.action("onSend")()` → `log.last == "onSend"`, `log.count == 1`); `colorTokenSplits` (`ColorToken.themeTokens.count == 20`, `ColorToken.solarized.count == 16`, `ColorToken.danger.snippetExpression == "theme.colors.danger"`); `enumPicksParseWithFallback` (pick `"l"` → `step("spacing") == .l`; pick `"bogus"` → `.zero`, first case; `tone` likewise → `.primary`); `snippetRendersEachKind` (template `X({{t}}, {{b}}, {{i}}, {{d}}, .{{p}}, {{c}})` with text "hi", true, 3, 0.5, pick "iPad", color accentTeal → `X("hi", true, 3, 0.5, .iPad, theme.colors.accentTeal)`; Solarized red → `BraisenlyDS.Solarized.red`); `snippetEscapesStringLiterals` (text `He said "hi"\` + newline + `x` → `"He said \"hi\"\\\nx"` escaped per Swift literal rules); `snippetLeavesUnknownPlaceholder` (`{{nope}}` stays).
  - `RegistryInvariantTests` (parameterised `@Test(arguments: CatalogRegistry.all.map(\.id))` where per-entry): `idIsPrefixedByGroup`, `hasAtLeastOneKnob`, `knobKeysUnique`, `snippetPlaceholdersAreKnobKeys`, `pickDefaultsInOptions`, `numericDefaultsInRange`, `makeWithDefaultsReadsOnlyDeclaredKeys` (`missingKeys.isEmpty` after `make`), `rendersWithDefaults` and `rendersAtKnobBounds` (each int/double knob at `range.lowerBound` and `range.upperBound`, each text knob at `""`; render with `ImageRenderer(content: entry.make(values).braisenlyTheme(values.theme)).nsImage` on macOS — non-nil is enough; `#if os(macOS)` guard); plus non-parameterised `idsAreGloballyUnique` and `allFollowsGroupOrder`. With empty stubs the parameterised tests have zero cases and pass; group tasks give them cases.
  - `CatalogSearchTests` with a two-entry test registry injected via `CatalogRegistry.sections(matching:in:)` overload taking `[CatalogEntry]`: `sectionsMatchingEmptyQueryReturnsAllGroups`, `sectionsMatchingWhitespaceQueryReturnsAll` (`"   "`), `sectionsMatchingIsCaseAndDiacriticInsensitive` (`"CIRCLE"` and `"círcle"` find "Circle Icon Button"), `sectionsMatchingTypeNameAndSummary`, `sectionsMatchingNothingIsEmpty` (`"zzz"` → `[]`), `emptyGroupsAreHidden`. (Unknown theme ids are resolved by the package's `BraisenlyThemes.theme(withID:)`; Task 4 tests the app's use of it.)
- [ ] **Step 2: Run to verify they fail**
  Run: `scripts/test-unit.sh -o BraisenlySwiftDemoTests/KnobTests`
  Expected: build FAIL, `cannot find 'KnobValues' in scope`.
- [ ] **Step 3: Implement the model files** per spec §6. `sections(matching:)` trims whitespace, uses `localizedStandardContains` on title, typeName, summary. `renderSnippet` uses one pass over `{{([A-Za-z0-9_]+)}}` matches (`Regex`), escaping strings with `\\`, `\"`, `\n`, `\t`.
- [ ] **Step 4: Run all unit tests and lint**
  Run: `scripts/test-unit.sh && scripts/dogfood-lint.sh`
  Expected: `** TEST SUCCEEDED **`, `dogfood-lint: 0 hit(s)`.
- [ ] **Step 5: Build the AI scheme to prove the stub compiles under the flag**
  Run: `scripts/build-mac.sh -s BraisenlySwiftDemo-AI`
  Expected: `** BUILD SUCCEEDED **`.
- [ ] **Step 6: Commit** `git commit -m "feat(catalog): add typed registry, knobs, snippet rendering and invariant tests"`

### Task 4: App shell (DemoApp, sidebar, detail, knobs, snippet, launch options)

**Files:**
- Modify: `Sources/DemoApp.swift` (replace placeholder)
- Create: `Sources/Shell/CatalogSidebar.swift`, `Sources/Shell/CatalogDetail.swift`, `Sources/Shell/KnobsPane.swift`, `Sources/Shell/SnippetPane.swift`, `Sources/Shell/LaunchOptions.swift`
- Test: `Tests/LaunchOptionsTests.swift`

**Interfaces:**
- Consumes: Task 3 (`CatalogRegistry`, `CatalogEntry`, `KnobValues`, `ActionLog`), package `BraisenlyThemes.theme(withID:)`; package layout wrappers and controls (spec §4).
- Produces: `struct LaunchOptions { let entryID: String?; let themeID: String?; init(defaults: UserDefaults) }` reading keys `catalogEntry`, `catalogTheme`; accessibility identifiers `catalog.themeSwitcher`, `catalog.search`, `catalog.row.<id>`, `catalog.detail` (value = entry id), `catalog.stage`, `catalog.snippet`, `knob.<key>` — Task 18 depends on these exact strings.

- [ ] **Step 1: Write failing tests** `LaunchOptionsTests`: `readsEntryAndTheme` (suite `UserDefaults(suiteName: "LaunchOptionsTests.\(UUID())")!` with both keys set → both read), `missingKeysAreNil`, `unknownEntryIDYieldsNoSelection` (`entryID = "nope"` → `DemoApp.initialSelection(for: options) == nil`; expose `static func initialSelection(for: LaunchOptions) -> CatalogEntry.ID?`), `unknownThemeIDNormalisesToLiquidGlass` (`DemoApp.initialThemeID(for:)` with `"nope"` and with nil → `"liquidGlass"`, with `"solarizedDark"` → `"solarizedDark"`; expose `static func initialThemeID(for: LaunchOptions) -> BraisenlyThemeDefinition.ID`).
- [ ] **Step 2: Run to verify they fail**
  Run: `scripts/test-unit.sh -o BraisenlySwiftDemoTests/LaunchOptionsTests`
  Expected: build FAIL, `cannot find 'LaunchOptions' in scope`.
- [ ] **Step 3: Implement the shell** exactly per spec §5 (layout, order, empty states, `BraisenlyThemeSwitcher(style: .row)` at sidebar top, snippet copy via platform pasteboard, `compactColumn` handling, detail keyed `.id(entry.id)`) and spec §7 (knob control mapping, identifiers and labels). `DemoApp` holds `@State themeID`, `@State selection: CatalogEntry.ID?`, `@State compactColumn: NavigationSplitViewColumn`, seeded from `LaunchOptions(defaults: .standard)`.
- [ ] **Step 4: Run tests and lint**
  Run: `scripts/test-unit.sh && scripts/dogfood-lint.sh`
  Expected: `** TEST SUCCEEDED **`, `dogfood-lint: 0 hit(s)`.
- [ ] **Step 5: Build both destinations and launch on macOS**
  Run: `scripts/build-mac.sh && scripts/build-ios.sh -g && scripts/run-mac.sh -t solarizedDark`
  Expected: both builds succeed; the app window opens showing the theme switcher, search field and "Pick a component" empty state (groups are empty until P2 group tasks merge). Capture `screencapture -l <windowid> build/shots/T4-mac.png` as evidence.
- [ ] **Step 6: Commit** `git commit -m "feat(shell): add split-view catalog shell with knobs and snippet panes"`

### Tasks 5–16: Group entry files (one task per group, all parallel)

Every group task has the same shape; the per-task block below fixes its file, ids, typeNames and knob keys. Entry content
(titles, knob kinds, defaults, ranges, closures, state, presentation) comes verbatim from the named spec section.

**Files (per task):**
- Modify: `Sources/Catalog/Groups/<Group>Entries.swift` (replace the stub; private fixtures and per-entry state structs live here)
- Test: `Tests/Groups/<Group>EntriesTests.swift`

**Interfaces (all group tasks):**
- Consumes: Task 3 `CatalogEntry`, `Knob` (+ `Knob.platform()`, `Knob.step()`, `Knob.textStyle()`, `Knob.tone()`), `KnobValues` accessors, `StateHost`, `ColorToken`, `Fixtures`, `BraisenlyThemes.theme(withID:)`; package types listed in the group's spec section.
- Produces: `static let entries: [CatalogEntry]` in spec table order. Nothing else is public to other tasks.

**Steps (all group tasks):**
- [ ] **Step 1: Write the failing test** `<Group>EntriesTests` with two tests using the exact arrays in the task block: `idsAndTypeNamesMatchSpec` (`#expect(<Group>Entries.entries.map(\.id) == ids)`, `#expect(<Group>Entries.entries.map(\.typeName) == typeNames)`) and `knobKeysMatchSpec` (`#expect(Dictionary(uniqueKeysWithValues: <Group>Entries.entries.map { ($0.id, $0.knobs.map(\.key)) }) == knobKeys)`).
- [ ] **Step 2: Run to verify it fails**
  Run: `scripts/test-unit.sh -d build/DerivedData-T<n> -o BraisenlySwiftDemoTests/<Group>EntriesTests`
  Expected: FAIL, ids array is empty.
- [ ] **Step 3: Implement the entries** per the spec section: read all knob values into locals before building the view; wire every closure through `values.action("<param>")`; wrap `Binding` parameters in `StateHost`; snippet uses `{{key}}` for every knob (spec §8 snippet convention).
- [ ] **Step 4: Run the group test plus the registry invariants**
  Run: `scripts/test-unit.sh -d build/DerivedData-T<n> -o BraisenlySwiftDemoTests/<Group>EntriesTests -o BraisenlySwiftDemoTests/RegistryInvariantTests && scripts/dogfood-lint.sh`
  Expected: `** TEST SUCCEEDED **` (invariants now have this group's cases, including `rendersAtKnobBounds`), `dogfood-lint: 0 hit(s)`.
- [ ] **Step 5: Build for presto**
  Run: `scripts/build-ios.sh -g -s BraisenlySwiftDemo`
  Expected: `** BUILD SUCCEEDED **`.
- [ ] **Step 6: Commit** `git commit -m "feat(catalog): add <group title> entries"`

#### Task 5: Tokens — spec §8.1
- ids: `["tokens.solarizedPalette","tokens.colors","tokens.typography","tokens.metrics","tokens.platformDensity","tokens.themeDefinitions"]`
- typeNames: six `nil`
- knobKeys: solarizedPalette `["minColumnWidth","showNames"]`; colors `["minColumnWidth","showNames","theme"]`; typography `["sample"]`; metrics `["step"]`; platformDensity `["platform"]`; themeDefinitions `["theme"]`

#### Task 6: Layout — spec §8.2
- ids: `["layout.vStack","layout.hStack","layout.zStack","layout.scroll","layout.spacer","layout.divider","layout.text","layout.icon","layout.grid","layout.splitView"]`
- typeNames: `["BraisenlyVStack","BraisenlyHStack","BraisenlyZStack","BraisenlyScroll","BraisenlySpacer","BraisenlyDivider","BraisenlyText","BraisenlyIcon","BraisenlyGrid","BraisenlySplitView"]`
- knobKeys: vStack `["spacing","alignment","itemCount"]`; hStack same; zStack `["alignment","layerCount"]`; scroll `["axis","itemCount","showsIndicators"]`; spacer `["minLength"]`; divider `["context"]`; text `["text","style","tone"]`; icon `["systemName","size","tone"]`; grid `["minimumColumnWidth","itemCount","spacing"]`; splitView `["compactColumn","extendsDetailBackground"]`

#### Task 7: Modifiers — spec §8.3
- ids: `["modifiers.braisenlyCard","modifiers.braisenlyCapsule","modifiers.braisenlyPadding","modifiers.braisenlyTheme","modifiers.glassSurfaces","modifiers.braisenlySheetBackground"]`
- typeNames: `["BraisenlyCardModifier","BraisenlyCapsuleModifier",nil,nil,nil,nil]`
- knobKeys: braisenlyCard `["content","cornerRadius","fill","role"]`; braisenlyCapsule `["content","fill","role"]`; braisenlyPadding `["edges","step"]`; braisenlyTheme `["theme"]`; glassSurfaces `["surface","glass","role"]`; braisenlySheetBackground `["title"]`

#### Task 8: Buttons & Pills — spec §8.4
- ids: `["buttonsPills.button","buttonsPills.circleIconButton","buttonsPills.toolbarIconButton","buttonsPills.sendStopButton","buttonsPills.dualActionPill","buttonsPills.messageActionPill","buttonsPills.modelPill","buttonsPills.citationPill","buttonsPills.themeSwitcher"]`
- typeNames: `["BraisenlyButton","BraisenlyCircleIconButton","BraisenlyToolbarIconButton","BraisenlySendStopButton","BraisenlyDualActionPill","BraisenlyMessageActionPill","BraisenlyModelPill","BraisenlyCitationPill","BraisenlyThemeSwitcher"]`
- knobKeys: button `["title","systemImage","prominence"]`; circleIconButton `["systemName","accessibilityLabel","iconSize","platform"]`; toolbarIconButton `["systemName","label","isEnabled"]`; sendStopButton `["isResponding","canSend","size"]`; dualActionPill `["platform"]`; messageActionPill `["isCopied","canRegenerate"]`; modelPill `["title","systemImage","tappable"]`; citationPill `["title","source","hasURL","systemImage"]`; themeSwitcher `["style","includeLiquidGlass","platform"]`

#### Task 9: Indicators — spec §8.5
- ids: `["indicators.pulseIndicator","indicators.tabCounterBadge","indicators.avatarBadge","indicators.highlightedText","indicators.colorSwatch"]`
- typeNames: `["BraisenlyPulseIndicator","BraisenlyTabCounterBadge","BraisenlyAvatarBadge","BraisenlyHighlightedText","BraisenlyColorSwatch"]`
- knobKeys: pulseIndicator `["label"]`; tabCounterBadge `["count"]`; avatarBadge `["systemName","foregroundColor","backgroundColor","borderColor","size","iconSize"]`; highlightedText `["text","highlight","font","baseColor"]`; colorSwatch `["color","name","detail","isSelected"]`

#### Task 10: Fields — spec §8.6
- ids: `["fields.promptField","fields.keyEntryField","fields.parameterSliderRow","fields.textFieldRow"]`
- typeNames: `["BraisenlyPromptField","BraisenlyKeyEntryField","BraisenlyParameterSliderRow","BraisenlyTextFieldRow"]`
- knobKeys: promptField `["placeholder","cornerRadius","fill"]`; keyEntryField `["title","placeholder"]`; parameterSliderRow `["title","upperBound","step","formatString"]`; textFieldRow `["title","prompt","axis"]`

#### Task 11: Controls — spec §8.7
- ids: `["controls.segmentedControl","controls.toggleRow","controls.stepperRow","controls.chipGroup","controls.sectionHeader","controls.navRow","controls.propertyTable","controls.emptyState"]`
- typeNames: `["BraisenlySegmentedControl","BraisenlyToggleRow","BraisenlyStepperRow","BraisenlyChipGroup","BraisenlySectionHeader","BraisenlyNavRow","BraisenlyPropertyTable","BraisenlyEmptyState"]`
- knobKeys: segmentedControl `["optionCount","platform"]`; toggleRow `["title","subtitle"]`; stepperRow `["title","upperBound","step"]`; chipGroup `["optionCount"]`; sectionHeader `["title","systemImage","trailing"]`; navRow `["title","systemImage","badge","isSelected","platform"]`; propertyTable `["rowCount"]`; emptyState `["title","message","systemImage","actionTitle"]`

#### Task 12: Cards — spec §8.8
- ids: `["cards.bannerCard","cards.statusCard","cards.suggestionCard","cards.codeBlockCard","cards.searchSnippetCard","cards.chatBubbleSurface"]`
- typeNames: `["BraisenlyBannerCard","BraisenlyStatusCard","BraisenlySuggestionCard","BraisenlyCodeBlockCard","BraisenlySearchSnippetCard","BraisenlyChatBubbleSurface"]`
- knobKeys: bannerCard `["message","systemImage","iconColor","dismissible"]`; statusCard `["title","subtitle","systemImage","iconColor"]`; suggestionCard `["title","systemImage"]`; codeBlockCard `["language","code","copyable"]`; searchSnippetCard `["text","query","platform"]`; chatBubbleSurface `["text","fill","foregroundColor","cornerRadius"]`

#### Task 13: Rows & Groups — spec §8.9
- ids: `["rowsGroups.actionRow","rowsGroups.actionGroup","rowsGroups.conversationRow","rowsGroups.searchMetadataRow","rowsGroups.expandableSearchResult"]`
- typeNames: `["BraisenlyActionRow","BraisenlyActionGroup","BraisenlyConversationRow","BraisenlySearchMetadataRow","BraisenlyExpandableSearchResult"]`
- knobKeys: actionRow `["icon","title","isChecked","platform"]`; actionGroup `["itemCount","platform"]`; conversationRow `["title","subtitle","timestampText","isSelected","isPinned","platform"]`; searchMetadataRow `["stageWidth"]`; expandableSearchResult `["query","platform"]`

#### Task 14: Sidebar — spec §8.10
- ids: `["sidebar.searchHeader","sidebar.footer","sidebar.contextPopover","sidebar.drawer","sidebar.modes"]`
- typeNames: `["BraisenlySidebarSearchHeader","BraisenlySidebarFooter","BraisenlySidebarContextPopover","BraisenlySidebarDrawer",nil]`
- knobKeys: searchHeader `["platform"]`; footer `["selectedMode","platform"]`; contextPopover `["platform"]`; drawer `["platform"]`; modes `["showIcons"]`

#### Task 15: Document — spec §8.11
- ids: `["document.chrome","document.canvas","document.actionSheet","document.bottomToolbar"]`
- typeNames: `["BraisenlyDocumentChrome","BraisenlyDocumentCanvas","BraisenlyDocumentActionSheet","BraisenlyBottomToolbar"]`
- knobKeys: chrome `["platform"]`; canvas `["title","bodyText","platform"]`; actionSheet `["platform"]`; bottomToolbar `["tabCount","platform"]`

#### Task 16: Workspaces — spec §8.12
- ids: `["workspaces.compact","workspaces.regular","workspaces.mobile"]`
- typeNames: `["BraisenlyCompactWorkspace","BraisenlyRegularWorkspace","BraisenlyMobileWorkspaceView"]`
- knobKeys: compact `["documentTitle","documentText"]`; regular `["documentTitle","documentText","platform"]`; mobile `["documentTitle","documentText","initialTheme","platform"]`

### Task 17: Completeness test, public-views script and its negative test

**Files:**
- Create: `scripts/public-views.sh`, `Tests/Fixtures/public-views.txt` (generated), `Tests/RegistryCompletenessTests.swift`, `scripts/tests/completeness-negative.sh`
- Modify: `scripts/check.sh` (insert `public-views.sh --check` after lint; append the negative test)

**Interfaces:**
- Consumes: all group entries (Tasks 5–16); `.env` `SYMBOLGRAPH_TARGET`, `BRAISENLY_PACKAGE_PATH`.
- Produces: `scripts/public-views.sh -m/--module <name> -o/--output <path> -c/--check`; fixture format one sorted type name per line; test-side override env var `CATALOG_PUBLIC_VIEWS_OVERRIDE` (absolute path) read by `RegistryCompletenessTests` instead of the bundled fixture when set. The AI spec reuses `-m BraisenlyAI`.

- [ ] **Step 1: Write the failing test** `RegistryCompletenessTests`: `catalogCoversEveryPublicView` (sets per spec §10; on mismatch `Issue.record("missing: \(missing.sorted()) stale: \(stale.sorted())")`), `typeNamesAreUnique`, `fixtureIsSortedAndUnique`.
- [ ] **Step 2: Run to verify it fails**
  Run: `scripts/test-unit.sh -o BraisenlySwiftDemoTests/RegistryCompletenessTests`
  Expected: FAIL, fixture resource `public-views.txt` not found.
- [ ] **Step 3: Implement `scripts/public-views.sh`** per spec §10 and §12; generate the fixture.
  Run: `scripts/public-views.sh && wc -l Tests/Fixtures/public-views.txt`
  Expected: 60 lines (spec §8 typed entries); every line starts with `Braisenly`. A different count means the package surface moved: report the `missing`/`stale` names, do not edit group files owned by other tasks.
- [ ] **Step 4: Run the test**
  Run: `scripts/gen.sh && scripts/test-unit.sh -o BraisenlySwiftDemoTests/RegistryCompletenessTests`
  Expected: PASS. If it fails, the `missing:`/`stale:` lists name the entries to fix in their group file (report to the coordinator; do not edit other tasks' files).
- [ ] **Step 5: Write and run the negative test** `scripts/tests/completeness-negative.sh` per spec §10.
  Run: `bash scripts/tests/completeness-negative.sh && scripts/public-views.sh -c`
  Expected: `PASS completeness-negative` (the test failed and named `BraisenlyNonexistentView` under `missing`), then drift check exit 0.
- [ ] **Step 6: Commit** `git commit -m "test(catalog): enforce one entry per public package view via symbol graph"`

### Task 18: UI walk tests

**Files:**
- Create: `UITests/Fixtures/catalog-entry-ids.txt`, `UITests/CatalogWalkTests.swift`, `Tests/EntryIDFixtureTests.swift`
- Delete: `UITests/LaunchSmokeTests.swift` (superseded)

**Interfaces:**
- Consumes: Task 4 identifiers (`catalog.detail` value, `catalog.stage`, `catalog.row.<id>`, `catalog.themeSwitcher`, `catalog.snippet`, `knob.<key>`), launch arguments spec §9, `CatalogRegistry.all`.
- Produces: xcresult bundles under `build/xcresult/`; attachment names `"<theme>/<entry id>"` (Team B Live Witness and Metrics Recorder read these).

- [ ] **Step 1: Write the failing unit test** `EntryIDFixtureTests.fixtureMatchesRegistry` (`fixture lines == CatalogRegistry.all.map(\.id)`).
- [ ] **Step 2: Run to verify it fails**
  Run: `scripts/test-unit.sh -o BraisenlySwiftDemoTests/EntryIDFixtureTests`
  Expected: FAIL, resource missing.
- [ ] **Step 3: Write the fixture** (71 ids, registry order) and rerun Step 2's command. Expected: PASS.
- [ ] **Step 4: Write `CatalogWalkTests`** per spec §13 (`testWalkLiquidGlass`, `testWalkSolarizedLight`, `testWalkSolarizedDark`, `testKnobSmoke`), plus `testStatePersistsAcrossThemeSwitch` (launch `fields.textFieldRow`, type "abc" into the stage field, tap `catalog.themeSwitcher` to another theme, assert the stage field value is still "abc") and `testSplitViewEntryDoesNotTrapNavigation` (launch `layout.splitView` on a regular-width destination, tap `catalog.row.layout.text`, assert `catalog.detail` value becomes `layout.text`).
- [ ] **Step 5: Run on macOS**
  Run: `xcodebuild test -project BraisenlySwiftDemo.xcodeproj -scheme BraisenlySwiftDemo -destination "$MAC_DESTINATION" -only-testing:BraisenlySwiftDemoUITests -resultBundlePath build/xcresult/mac-$(date +%Y%m%dT%H%M%S).xcresult`
  Expected: `** TEST SUCCEEDED **`; `xcrun xcresulttool get test-results attachments --path <bundle> --output-path build/shots/mac` yields 213 walk screenshots + 24 knob-smoke screenshots.
- [ ] **Step 6: Run on presto** (device connected, unlocked; if the tunnel is down, report `blocked` with `xcrun devicectl list devices` output instead of retrying)
  Run: same command with `-destination "id=$DEVICE_UDID"` and result path `build/xcresult/presto-<ts>.xcresult`
  Expected: `** TEST SUCCEEDED **`, same attachment counts.
- [ ] **Step 7: Commit** `git commit -m "test(ui): walk every catalog entry in every theme with screenshots"`

### Task 19: README and CHANGELOG 0.1.0

**Files:**
- Modify: `README.md`, `CHANGELOG.md`
- Modify: `docs/superpowers/specs/2026-11-08-demo-catalog-design.md` §11 scripts table only if any script switch changed during Tasks 1–18

**Interfaces:**
- Consumes: final script switches (Tasks 1, 2, 17), launch arguments (spec §9), entry count from `wc -l UITests/Fixtures/catalog-entry-ids.txt`.
- Produces: README sections Setup, Scripts (table: script, switches, purpose), Launch arguments, Adding an entry (spec §15 five steps), Devices (presto, macOS; no simulators); CHANGELOG `## 0.1.0 - 2026-11-08` with Added bullets: catalog shell, 12 groups / <n> entries, knobs, completeness test, dog-food lint, UI walk, AI scheme stub.

- [ ] **Step 1: Verify every command shown in the README** by running each script with `-h`.
  Run: `for s in scripts/*.sh; do "$s" -h >/dev/null || echo "FAIL $s"; done`
  Expected: no output.
- [ ] **Step 2: Write README and CHANGELOG** content listed above; `## Unreleased` stays above `## 0.1.0`.
- [ ] **Step 3: Commit** `git commit -m "docs: document catalog setup, scripts and 0.1.0 changes"`

### Task 20: Final verification

**Files:** none created; evidence under `build/` (gitignored), summary in the task's JSON handoff.

**Interfaces:**
- Consumes: everything above.
- Produces: verification evidence for Phase 3 gate (lint 0 hits, completeness green, both builds green) and the Phase 5 hand-off (xcresult paths, screenshot dirs).

- [ ] **Step 1: Full check**
  Run: `scripts/check.sh`
  Expected: every step passes; final lines `PASS simulator-refusal`, `PASS dogfood-lint-negative`, `PASS completeness-negative`.
- [ ] **Step 2: Deploy and launch on presto**
  Run: `scripts/deploy-presto.sh -e buttonsPills.circleIconButton -t liquidGlass`
  Expected: install succeeds, console shows app launch with no `error`/`fault` lines from the app's subsystem in the first 30 s; take a device screenshot via Xcode MCP `DeviceInteractionSynthesize` screenshot (D-9 primary path) or report the fallback used.
- [ ] **Step 3: Run on macOS in all three themes**
  Run: `for t in liquidGlass solarizedLight solarizedDark; do scripts/run-mac.sh -e cards.statusCard -t $t; sleep 3; screencapture -l $(osascript -e 'tell app "System Events" to id of first window of (first process whose name is "BraisenlySwiftDemo")') build/shots/final-mac-$t.png; osascript -e 'quit app "BraisenlySwiftDemo"'; done`
  Expected: three PNGs exist and differ (`shasum build/shots/final-mac-*.png` gives three hashes).
- [ ] **Step 4: Confirm no simulator was used anywhere**
  Run: `rg -n "Simulator" scripts project.yml UITests Tests Sources | rg -v "refuse_simulator|refusing simulator|simulator-refusal"`
  Expected: no output.
- [ ] **Step 5: Report** JSON handoff `{role, tasks_done[], files_changed[], tests[{cmd,result}], evidence[], open_issues[], blocked[]}`; no commit.

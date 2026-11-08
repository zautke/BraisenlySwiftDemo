# BraisenlyAI catalog group — lockstep design spec

Date: 2026-11-08. Author: Architect (demo side), BSD-001. Status: draft for user approval; implemented after the first
catalog release (U-1). Same method as `2026-11-08-demo-catalog-design.md` (the "demo spec"): registry, knobs, completeness,
dog-food lint, live proof. Everything not restated here follows the demo spec.

## 1. Intent

Catalog the 14 public `AI*` views of product `BraisenlyAI` in the same app, as a second scheme/target
`BraisenlySwiftDemo-AI` that shares `Sources/` and adds `CatalogGroup.ai` (U-8, D-8). The AI group renders every view
against in-memory fixtures and a mock chat client: no model weights are downloaded, loaded or initialised, no network
request is made, and nothing is written outside a per-launch temporary directory.

## 2. Goals, non-goals, anti-goals

- Goals: one entry per public View type of module `BraisenlyAI`, each with ≥ 1 knob; completeness test for that module;
  same lint, UI walk and live gates (presto + macOS full walk, three themes) as the core catalog.
- Non-goals: exercising real inference, model downloads, provider API keys, or persistence across launches.
- Anti-goals: any code path in the AI scheme that constructs an MLX, FoundationModels, Anthropic or OpenAI client;
  `UserDefaults.standard` or the default `AIConversationStore()` location; bare SwiftUI (demo spec AG-1).

## 3. Build wiring

- `project.yml` target `BraisenlySwiftDemo-AI` (already defined by the demo spec §12): products `BraisenlySwiftUI` and
  `BraisenlyAI`, `SWIFT_ACTIVE_COMPILATION_CONDITIONS: "$(inherited) BRAISENLY_AI"`, bundle id
  `${BUNDLE_ID_PREFIX}.BraisenlySwiftDemoAI`. Added when this spec is implemented: test target `BraisenlySwiftDemo-AITests`
  (sources `Tests` + `TestsAI`, resources `Tests/Fixtures`, same flag, host `BraisenlySwiftDemo-AI`) and the scheme's
  test action running it.
- `CatalogGroup.ai` exists only under `#if BRAISENLY_AI` (title "AI", symbol "sparkles", last in `allCases`).
  `Sources/Catalog/Groups/AIEntries.swift` and `Sources/Catalog/Groups/AIFixtures.swift` are wholly wrapped in
  `#if BRAISENLY_AI` and `import BraisenlyAI` inside the guard. `CatalogRegistry.all` appends `AIEntries.entries` under the
  same guard. The core scheme never imports `BraisenlyAI` and never links MLX.
- Stub now (first catalog release): `CatalogGroup.ai` case and an `AIEntries` enum with `static let entries: [CatalogEntry] = []`,
  both guarded. The sidebar hides empty groups, so the AI scheme shows the core catalog only.

## 4. Fixtures (`AIFixtures.swift`, no model load)

- `AIFixtures.messages`: 6 `AIMessage`s — user question; assistant answer `.complete` with 2 `AICitation`s; user follow-up;
  assistant `.streaming` partial text; assistant `.complete` with 2 `AIToolCall`s (`.complete`, `.running`); assistant
  `.failed`. Fixed UUIDs and a fixed `createdAt` (2026-11-08T12:00:00Z) so screenshots are stable.
- `AIFixtures.citations` (3: with url+source, source only, title only), `AIFixtures.toolCalls` (4, one per state).
- `AIFixtures.conversations`: 4 `AIConversation`s, one pinned, titles "Design review", "Trip planning", "Swift 6 migration",
  "New conversation" (empty).
- `MockChatClient: AIChatClient`: `streamResponse(to:)` returns an `AsyncThrowingStream` that yields the text
  "This is a catalog response. No model was loaded." as 6 deltas, 80 ms apart, then finishes. Never throws. Event case
  names come from `AIChatResponseEvent` (package; see §8).
- `AIFixtures.session() -> AIChatSession`: `AIChatSession(conversation: conversations[0] with messages, client: MockChatClient())`.
- `AIFixtures.workspaceController() -> AIChatWorkspaceController`: `AIConversationStore(fileURL: <NSTemporaryDirectory()/catalog-ai-<uuid>.json>)`,
  `UserDefaults(suiteName: "com.braisenly.catalog.ai.<uuid>")`, `initialConfiguration` with a profile and client path that
  cannot load a model (§8 AI-C3 decides how).

## 5. Entries (`AIEntries.swift`, group `ai`, ids `ai.<lowerCamel>`)

| id | typeName | Knobs | Fixtures / closures / state | Presentation |
|---|---|---|---|---|
| ai.chatErrorBanner | AIChatErrorBanner | failure: pick(responseUnavailable; emptyPrompt/responseUnavailable/provider), providerMessage: text("Rate limited") (used for `.provider`) | onDismiss log | inline |
| ai.chatHeader | AIChatHeader | title: text("Design review"), modelName: text("LFM3 1.7B") ("" → nil), platform, sidebarButton/newChatButton/modelButton/moreButton: bool(true) each (closure log or nil) | StateHost("liquidGlass") as `theme: Binding<BraisenlyThemeDefinition.ID>` | canvas(120) |
| ai.chatView | AIChatView | platform, modelName: text("LFM3 1.7B"), emptyConversation: bool(false), initialTheme: pick(liquidGlass; 3 ids) | `AIFixtures.session()` (fresh per make), 4 closures log, `theme: nil` (view owns and applies its theme) | canvas(640) |
| ai.chatWorkspaceView | AIChatWorkspaceView | platform, initialTheme: pick(liquidGlass; 3 ids) | `AIFixtures.workspaceController()` | canvas(640) |
| ai.citationChip | AICitationChip | title: text("Swift Evolution"), source: text("swift.org") ("" → nil), hasURL: bool(true) | builds `AICitation` | inline |
| ai.composer | AIComposer | isResponding: bool(false) | StateHost("") text; onSend, onCancel log | inline |
| ai.conversationActionSheet | AIConversationActionSheet | conversationTitle: text("Design review"), isPinned: bool(false), platform | onRename/onTogglePin/onClearMessages/onDeleteConversation log; onExportMarkdown returns `"# Design review\n…"` and logs | canvas(520) |
| ai.conversationSidebar | AIConversationSidebar | activeModelName: text("LFM3 1.7B"), conversationCount: int(4; 0…4), platform | `AIFixtures.conversations.prefix(n)`, selection first id, StateHost("") searchText, 4 closures log | canvas(560) |
| ai.emptyState | AIEmptyState | suggestionCount: int(3; 0…3) | suggestions from the 3 package defaults; onSelectSuggestion log | inline |
| ai.messageBubble | AIMessageBubble | role: pick(assistant; user/assistant), status: pick(complete; sending/streaming/complete/failed), text: text("Here is the summary…"), citationCount: int(1; 0…3), toolCallCount: int(0; 0…2), canRegenerate: bool(true) | onRegenerate log | inline |
| ai.messageList | AIMessageList | messageCount: int(6; 0…6) | `AIFixtures.messages.prefix(n)` (0 shows the empty state); 2 closures log | canvas(560) |
| ai.modelSettingsSheet | AIModelSettingsSheet | profileCount: int(all; 1…defaultProfiles.count), platform | StateHost(`AIInferenceConfiguration()`), rendered inline not presented | canvas(640) |
| ai.streamingIndicator | AIStreamingIndicator | label: text("Thinking…") | — | inline |
| ai.toolCallCard | AIToolCallCard | name: text("web_search"), summary: text("Searching swift.org"), state: pick(running; pending/running/complete/failed) | builds `AIToolCall` | inline |

Snippets follow demo spec §8 conventions. `ai.chatView`'s snippet shows the real app wiring
(`AIChatView(session: session)`), not the mock.

## 6. Completeness, lint, UI walk

- `scripts/public-views.sh -m BraisenlyAI -o Tests/Fixtures/public-views-ai.txt` (builds target `BraisenlyAI`, which compiles
  MLX: ~4 min cold on largo; run only when the AI package surface changes). `check.sh -a/--ai` adds the AI drift check,
  the AI test target and `build-mac.sh -s BraisenlySwiftDemo-AI` + `build-ios.sh -s BraisenlySwiftDemo-AI`.
- `TestsAI/AIRegistryCompletenessTests.swift`: `Set(AIEntries.entries.compactMap(\.typeName)) == public-views-ai.txt`;
  the demo spec's invariant tests already iterate `CatalogRegistry.all`, so AI entries get them for free in the AI test target.
- `TestsAI/AIFixtureIsolationTests.swift`: making every AI entry with defaults leaves `UserDefaults.standard` untouched for
  keys prefixed `AIChat`/`Askenly`, creates no file under `Documents/AskenlyConversations`, and `MockChatClient` delivers exactly
  6 deltas then finishes.
- Lint: unchanged; `AIEntries.swift` and `AIFixtures.swift` are under `Sources/`.
- UI walk: `UITests/Fixtures/catalog-entry-ids-ai.txt` (ids of `ai.*` entries) and `CatalogWalkTests` gains
  `testWalkAI<Theme>` methods that run only when the app under test is the AI target (`TEST_TARGET_NAME` per scheme; the AI
  UI test target is added with this spec).

## 7. What the first AI build must verify (gate before any AI entry is written)

1. `BraisenlySwiftDemo-AI` builds and links for macOS (`build-mac.sh -s BraisenlySwiftDemo-AI`) and for presto
   (`build-ios.sh -s BraisenlySwiftDemo-AI`), never a simulator (MLX needs Metal on device).
2. Launch on both shows the core catalog, console free of MLX/Metal initialisation, model download or HuggingFace URLs,
   and no network activity at launch (Xcode network report or console).
3. `AIChatWorkspaceController` construction path chosen per AI-C3 does not instantiate any inference client
   (verified by `AIFixtureIsolationTests` plus a breakpoint/log check on the client factory).
4. App bundle size of the AI build recorded in the test-metrics registry (moderate band > 150 MB).
5. Public symbol graph of `BraisenlyAI` lists exactly the 14 views of §5 (else update §5 first).

## 8. Contract deltas (package)

- AI-C1 `AIChatResponseEvent` case names for text deltas/finish are needed by `MockChatClient` (not in inventory).
- AI-C2 Resolved by package spec 0.2.0 §6.5: `AIChatHeader(theme: Binding<BraisenlyThemeDefinition.ID>)`,
  `AIChatView(initialTheme: BraisenlyThemeDefinition.ID, theme: Binding<…ID>? = nil)`, `AIChatWorkspaceView(initialTheme:)`;
  §5 rows above use these.
- AI-C3 `AIChatWorkspaceController` has no client injection in the inventoried API; if sending from its composer can reach
  a real client, the package must add an injection point (e.g. `clientFactory: (AIInferenceConfiguration) -> any AIChatClient`)
  before `ai.chatWorkspaceView` ships. RESOLVED (U-17, 2026-11-08): filed as a package follow-up issue, scheduled with the AI
  group; until it lands that entry's composer send is the open risk.
- AI-C4 `AIConversationActionSheet` and `AIMessageBubble` write to the system pasteboard on copy; acceptable in the catalog
  (user action), logged via the closure where one exists.

## 9. Explicitly deferred

Implementation of §3–§7 (separate plan written after the core catalog ships); live AI battery (Team B, same gate as core);
streaming animation tuning of the mock; a per-entry "simulate send" knob; hemoila smoke of the AI scheme; AI release
version and release records.

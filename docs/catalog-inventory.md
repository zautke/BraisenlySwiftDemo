# BraisenlySwiftUI catalog inventory (BSD-001, Inventory Analyst, 2026-11-08)

## 0. Source of truth and caveats
- **`development` (3aa0034) is NOT the package the brief describes.** It holds 7 files in `Sources/BraisenlySwiftUI`, one product, no `BraisenlyAI`, no Solarized, iOS 17 / macOS 14 floor. Public surface there: `BraisenlyDesignSystem`, ActionSheet/Primitives/Sidebar/Surfaces/Toolbar/Workspace monoliths.
- Everything below inventories **`ai-chat-components` tip `8570eb1`** (exported with `git archive`, read-only). It is a strict superset of `adaptive-solarized-themes` (`e5050bc`) and contains the 45 public declarations in `Sources/BraisenlySwiftUI` plus 14 views in `Sources/AI/UI`. Products `BraisenlySwiftUI` + `BraisenlyAI`; platforms still `.iOS(.v17)`, `.macOS(.v14)`; tools 6.4; `ApproachableConcurrency` upcoming feature on all targets.
- Counts: **45 public type declarations** in Sources/BraisenlySwiftUI (incl. `typealias BraisenlyDS`, `BraisenlyActionItem`, `BraisenlySidebarMode`, `BraisenlyTheme`, `BraisenlyPlatform`, `BraisenlyDesignSystem`) + **3** `public extension View` methods (`braisenlyCard`, `braisenlyCapsule`, `braisenlyTheme`) + **14** AI UI views. Internal (not public): `BraisenlyAdaptiveColor`, `BraisenlyRGB`, `BraisenlyHighlightedTextSegment`.
- No Liquid Glass / `.glassEffect` / material usage anywhere (`grep -i 'glass|material'` hits only `magnifyingglass`). Only `@available` is `iOS 26/macOS 26` around FoundationModels in `AI/Models`.
- codemunch was unreachable (local server `CONNECT_TIMEOUT`; the adagio server cannot see `/Volumes/MACDEV`), so rg/git/awk were used.
- Worktree `/Volumes/MACDEV/BraisenlySwiftUI-fix-lfm3` (branch `fix/lfm3-inference-corrections`, at 8570eb1) has **9 uncommitted modified files** (+486/-82: Package.swift, AIChatSession, BraisenlyAITests, ...). Not inventoried; not ours.
- Worktree `/Volumes/MACDEV/BraisenlySwiftUI-catalog` (branch `feat/themable-tokens-and-catalog-primitives`) is at 3aa0034 = development (no work yet).

## 1. Public API table
Signatures are extracted verbatim from source (whitespace collapsed; `;` separates multiple inits). Types without a declared `init` get a synthesized one. `Binding` = takes `Binding<…>`; `closure` = `@escaping`/optional closure; `model` = takes an AI model type.

| type | kind | file | public init signature(s) | bindings/closures/models needed | catalog group |
|---|---|---|---|---|---|
| `BraisenlyActionGroup` | View | `BraisenlySwiftUI/BraisenlyActionGroup.swift` | `init(items: [BraisenlyActionItem], platform: BraisenlyPlatform = .automatic, action: @escaping (BraisenlyActionItem) -> Void)` | closure | rowsGroups |
| `BraisenlyActionItem` | struct | `BraisenlySwiftUI/BraisenlyActionItem.swift` | `init(id: String, icon: String, title: LocalizedStringResource, isChecked: Bool = false)` | - | rowsGroups |
| `BraisenlyActionRow` | View | `BraisenlySwiftUI/BraisenlyActionRow.swift` | `init(item: BraisenlyActionItem, platform: BraisenlyPlatform = .automatic)` | - | rowsGroups |
| `BraisenlyAvatarBadge` | View | `BraisenlySwiftUI/BraisenlyAvatarBadge.swift` | `init(systemName: String, foregroundColor: Color = BraisenlyDS.Colors.accentTeal, backgroundColor: Color = BraisenlyDS.Colors.surfaceElevated, borderColor: Color = BraisenlyDS.Colors.borderSubtle, size: CGFloat = 32, iconSize: CGFloat = 14)` | - | indicators |
| `BraisenlyBannerCard` | View | `BraisenlySwiftUI/BraisenlyBannerCard.swift` | `init(message: String, systemImage: String = "exclamationmark.triangle.fill", iconColor: Color = BraisenlyDS.Solarized.red, onDismiss: (() -> Void)? = nil)` | closure | cards |
| `BraisenlyBottomToolbar` | View | `BraisenlySwiftUI/BraisenlyBottomToolbar.swift` | `init(tabCount: Int = 23, platform: BraisenlyPlatform = .automatic, onBack: @escaping () -> Void = {}, onForward: @escaping () -> Void = {}, onSearch: @escaping () -> Void = {}, onAdd: @escaping () -> Void = {}, onTabs: @escaping () -> Void = {}, onMenu: @escaping () -> Void = {})` | closure | workspaces |
| `BraisenlyCapsuleModifier` | ViewModifier | `BraisenlySwiftUI/BraisenlyCapsuleModifier.swift` | `init(fill: Color = BraisenlyDS.Colors.surfaceElevated)` | - | modifiers |
| `braisenlyCapsule(…)` | extension View method | `BraisenlySwiftUI/BraisenlyCapsuleModifier.swift` | `func braisenlyCapsule(fill: Color = BraisenlyDS.Colors.surfaceElevated)` | - | modifiers |
| `BraisenlyCardModifier` | ViewModifier | `BraisenlySwiftUI/BraisenlyCardModifier.swift` | `init(cornerRadius: CGFloat = BraisenlyDS.Metrics.cardRadius, fill: Color = BraisenlyDS.Colors.surfaceElevated)` | - | modifiers |
| `braisenlyCard(…)` | extension View method | `BraisenlySwiftUI/BraisenlyCardModifier.swift` | `func braisenlyCard(cornerRadius: CGFloat = BraisenlyDS.Metrics.cardRadius, fill: Color = BraisenlyDS.Colors.surfaceElevated)` | - | modifiers |
| `BraisenlyChatBubbleSurface` | View | `BraisenlySwiftUI/BraisenlyChatBubbleSurface.swift` | `init(text: String, fill: Color = BraisenlyDS.Colors.surfaceElevated, foregroundColor: Color = BraisenlyDS.Colors.textPrimary, cornerRadius: CGFloat = 18)` | - | cards |
| `BraisenlyCircleIconButton` | View | `BraisenlySwiftUI/BraisenlyCircleIconButton.swift` | `init(systemName: String, accessibilityLabel: LocalizedStringResource, iconSize: CGFloat = 18, platform: BraisenlyPlatform = .automatic, action: @escaping () -> Void)` | closure | buttonsPills |
| `BraisenlyCitationPill` | View | `BraisenlySwiftUI/BraisenlyCitationPill.swift` | `init(title: String, source: String? = nil, url: URL? = nil, systemImage: String = "link")` | - | buttonsPills |
| `BraisenlyCodeBlockCard` | View | `BraisenlySwiftUI/BraisenlyCodeBlockCard.swift` | `init(language: String? = nil, code: String, onCopy: (() -> Void)? = nil)` | closure | cards |
| `BraisenlyCompactWorkspace` | View | `BraisenlySwiftUI/BraisenlyCompactWorkspace.swift` | `init(documentTitle: String, documentText: String, isSidebarOpen: Binding<Bool>, isActionSheetPresented: Binding<Bool>, isContextPopoverOpen: Binding<Bool>, searchText: Binding<String>, selectedMode: Binding<BraisenlySidebarMode>, theme: Binding<BraisenlyTheme>)` | Binding | workspaces |
| `BraisenlyConversationRow` | View | `BraisenlySwiftUI/BraisenlyConversationRow.swift` | `init(title: String, subtitle: String? = nil, timestampText: String? = nil, isSelected: Bool = false, isPinned: Bool = false, platform: BraisenlyPlatform = .automatic, action: @escaping () -> Void)` | closure | rowsGroups |
| `BraisenlyDesignSystem` | enum | `BraisenlySwiftUI/BraisenlyDesignSystem.swift` | `(memberwise/none)` | - | tokens |
| `BraisenlyDS` | typealias | `BraisenlySwiftUI/BraisenlyDesignSystem.swift` | `(memberwise/none)` | - | tokens |
| `BraisenlyDocumentActionSheet` | View | `BraisenlySwiftUI/BraisenlyDocumentActionSheet.swift` | `init(platform: BraisenlyPlatform = .automatic)` | - | document |
| `BraisenlyDocumentCanvas` | View | `BraisenlySwiftUI/BraisenlyDocumentCanvas.swift` | `init(title: String = "Home", bodyText: String, theme: Binding<BraisenlyTheme> = .constant(.dark), platform: BraisenlyPlatform = .automatic, onToggleSidebar: @escaping () -> Void = {}, onEdit: @escaping () -> Void = {}, onOpenActionSheet: @escaping () -> Void = {})` | Binding, closure | document |
| `BraisenlyDocumentChrome` | View | `BraisenlySwiftUI/BraisenlyDocumentChrome.swift` | `init(theme: Binding<BraisenlyTheme> = .constant(.dark), platform: BraisenlyPlatform = .automatic, onToggleSidebar: @escaping () -> Void = {}, onEdit: @escaping () -> Void = {}, onOpenActionSheet: @escaping () -> Void = {})` | Binding, closure | document |
| `BraisenlyDualActionPill` | View | `BraisenlySwiftUI/BraisenlyDualActionPill.swift` | `init(platform: BraisenlyPlatform = .automatic, onEdit: @escaping () -> Void, onMore: @escaping () -> Void)` | closure | buttonsPills |
| `BraisenlyExpandableSearchResult` | View | `BraisenlySwiftUI/BraisenlyExpandableSearchResult.swift` | `init(query: String, platform: BraisenlyPlatform = .automatic, isExpanded: Binding<Bool>)` | Binding | rowsGroups |
| `BraisenlyHighlightedText` | View | `BraisenlySwiftUI/BraisenlyHighlightedText.swift` | `init(_ text: String, highlight: String, font: Font = BraisenlyDS.Typography.rowLabel, baseColor: Color = BraisenlyDS.Colors.textPrimary)` | - | document |
| `BraisenlyKeyEntryField` | View | `BraisenlySwiftUI/BraisenlyKeyEntryField.swift` | `init(title: String, placeholder: String = "sk-…", text: Binding<String>)` | Binding | fields |
| `BraisenlyMessageActionPill` | View | `BraisenlySwiftUI/BraisenlyMessageActionPill.swift` | `init(isCopied: Bool = false, canRegenerate: Bool = false, onCopy: @escaping () -> Void, onRegenerate: (() -> Void)? = nil)` | closure | buttonsPills |
| `BraisenlyMobileWorkspaceView` | View | `BraisenlySwiftUI/BraisenlyMobileWorkspaceView.swift` | `init(documentTitle: String = "Home", documentText: String = BraisenlyMobileWorkspaceView.sampleText, initialTheme: BraisenlyTheme = .dark, platform: BraisenlyPlatform = .automatic)` | - | workspaces |
| `BraisenlyModelPill` | View | `BraisenlySwiftUI/BraisenlyModelPill.swift` | `init(title: String, systemImage: String = "cpu", action: (() -> Void)? = nil)` | closure | buttonsPills |
| `BraisenlyParameterSliderRow` | View | `BraisenlySwiftUI/BraisenlyParameterSliderRow.swift` | `init(title: String, value: Binding<Double>, in range: ClosedRange<Double> = 0.0...1.5, step: Double = 0.1, formatString: String = "%.1f")` | Binding | controls |
| `BraisenlyPlatform` | enum | `BraisenlySwiftUI/BraisenlyPlatform.swift` | `(memberwise/none)` | - | tokens |
| `BraisenlyPromptField` | View | `BraisenlySwiftUI/BraisenlyPromptField.swift` | `init(_ placeholder: LocalizedStringResource = "Message Braisenly…", text: Binding<String>, cornerRadius: CGFloat = 18, fill: Color = BraisenlyDS.Colors.surfaceElevated, onSubmit: @escaping () -> Void = {})` | Binding, closure | fields |
| `BraisenlyPulseIndicator` | View | `BraisenlySwiftUI/BraisenlyPulseIndicator.swift` | `init(label: String = "Thinking…")` | - | indicators |
| `BraisenlyRegularWorkspace` | View | `BraisenlySwiftUI/BraisenlyRegularWorkspace.swift` | `init(documentTitle: String, documentText: String, platform: BraisenlyPlatform, isActionSheetPresented: Binding<Bool>, isContextPopoverOpen: Binding<Bool>, searchText: Binding<String>, selectedMode: Binding<BraisenlySidebarMode>, theme: Binding<BraisenlyTheme>)` | Binding | workspaces |
| `BraisenlySearchMetadataRow` | View | `BraisenlySwiftUI/BraisenlySearchMetadataRow.swift` | `init()` | - | rowsGroups |
| `BraisenlySearchSnippetCard` | View | `BraisenlySwiftUI/BraisenlySearchSnippetCard.swift` | `init(text: String, query: String, platform: BraisenlyPlatform = .automatic)` | - | cards |
| `BraisenlySendStopButton` | View | `BraisenlySwiftUI/BraisenlySendStopButton.swift` | `init(isResponding: Bool, canSend: Bool, size: CGFloat = 44, onSend: @escaping () -> Void, onCancel: @escaping () -> Void)` | closure | buttonsPills |
| `BraisenlySidebarContextPopover` | View | `BraisenlySwiftUI/BraisenlySidebarContextPopover.swift` | `init(selectedMode: Binding<BraisenlySidebarMode>, isPresented: Binding<Bool>, platform: BraisenlyPlatform = .automatic)` | Binding | sidebar |
| `BraisenlySidebarDrawer` | View | `BraisenlySwiftUI/BraisenlySidebarDrawer.swift` | `init(searchText: Binding<String>, selectedMode: Binding<BraisenlySidebarMode>, isShowingContextPopover: Binding<Bool>, platform: BraisenlyPlatform = .automatic)` | Binding | sidebar |
| `BraisenlySidebarFooter` | View | `BraisenlySwiftUI/BraisenlySidebarFooter.swift` | `init(selectedMode: BraisenlySidebarMode, platform: BraisenlyPlatform = .automatic, onModePickerTap: @escaping () -> Void)` | closure | sidebar |
| `BraisenlySidebarMode` | enum | `BraisenlySwiftUI/BraisenlySidebarMode.swift` | `(memberwise/none)` | - | sidebar |
| `BraisenlySidebarSearchHeader` | View | `BraisenlySwiftUI/BraisenlySidebarSearchHeader.swift` | `init(searchText: Binding<String>, platform: BraisenlyPlatform = .automatic)` | Binding | sidebar |
| `BraisenlyStatusCard` | View | `BraisenlySwiftUI/BraisenlyStatusCard.swift` | `init(title: String, subtitle: String = "", systemImage: String, iconColor: Color = BraisenlyDS.Colors.accentTeal)` | - | cards |
| `BraisenlySuggestionCard` | View | `BraisenlySwiftUI/BraisenlySuggestionCard.swift` | `init(title: String, systemImage: String? = "arrow.up.right", action: @escaping () -> Void)` | closure | cards |
| `BraisenlyTabCounterBadge` | View | `BraisenlySwiftUI/BraisenlyTabCounterBadge.swift` | `init(count: Int)` | - | indicators |
| `BraisenlyTheme` | enum | `BraisenlySwiftUI/BraisenlyTheme.swift` | `(memberwise/none)` | - | tokens |
| `braisenlyTheme(…)` | extension View method | `BraisenlySwiftUI/BraisenlyTheme.swift` | `func braisenlyTheme(_ theme: BraisenlyTheme)` | - | tokens |
| `BraisenlyThemeToggle` | View | `BraisenlySwiftUI/BraisenlyThemeToggle.swift` | `init(theme: Binding<BraisenlyTheme>, platform: BraisenlyPlatform = .automatic)` | Binding | controls |
| `BraisenlyToolbarIconButton` | View | `BraisenlySwiftUI/BraisenlyToolbarIconButton.swift` | `init(systemName: String, label: LocalizedStringResource, isEnabled: Bool = true, action: @escaping () -> Void)` | closure | buttonsPills |
| `AIChatErrorBanner` | View | `AI/UI/AIChatErrorBanner.swift` | `init(failure: AIChatFailure, onDismiss: @escaping () -> Void)` | closure, model | ai |
| `AIChatHeader` | View | `AI/UI/AIChatHeader.swift` | `init(title: String, modelName: String? = nil, theme: Binding<BraisenlyTheme>, platform: BraisenlyPlatform = .automatic, onToggleSidebar: (() -> Void)? = nil, onNewChat: (() -> Void)? = nil, onSelectModel: (() -> Void)? = nil, onMoreActions: (() -> Void)? = nil)` | Binding, closure | ai |
| `AIChatView` | View | `AI/UI/AIChatView.swift` | `init(session: AIChatSession, platform: BraisenlyPlatform = .automatic, initialTheme: BraisenlyTheme = .dark, theme: Binding<BraisenlyTheme>? = nil, modelName: String? = nil, onToggleSidebar: (() -> Void)? = nil, onNewChat: (() -> Void)? = nil, onSelectModel: (() -> Void)? = nil, onMoreActions: (() -> Void)? = nil)` | Binding, closure, model | ai |
| `AIChatWorkspaceView` | View | `AI/UI/AIChatWorkspaceView.swift` | `init(controller: AIChatWorkspaceController, initialTheme: BraisenlyTheme = .dark, platform: BraisenlyPlatform = .automatic)` | model | ai |
| `AICitationChip` | View | `AI/UI/AICitationChip.swift` | `init(citation: AICitation)` | model | ai |
| `AIComposer` | View | `AI/UI/AIComposer.swift` | `init(text: Binding<String>, isResponding: Bool, onSend: @escaping () -> Void, onCancel: @escaping () -> Void)` | Binding, closure | ai |
| `AIConversationActionSheet` | View | `AI/UI/AIConversationActionSheet.swift` | `init(conversationTitle: String, isPinned: Bool, platform: BraisenlyPlatform = .automatic, onRename: @escaping (String) -> Void, onTogglePin: @escaping () -> Void, onExportMarkdown: @escaping () -> String, onClearMessages: @escaping () -> Void, onDeleteConversation: @escaping () -> Void)` | closure | ai |
| `AIConversationSidebar` | View | `AI/UI/AIConversationSidebar.swift` | `init(conversations: [AIConversation], selectedConversationID: UUID, searchText: Binding<String>, activeModelName: String, platform: BraisenlyPlatform = .automatic, onSelectConversation: @escaping (UUID) -> Void, onNewConversation: @escaping () -> Void, onDeleteConversation: @escaping (UUID) -> Void, onOpenSettings: @escaping () -> Void)` | Binding, closure, model | ai |
| `AIEmptyState` | View | `AI/UI/AIEmptyState.swift` | `init(suggestions: [String] = [ "Summarize my research", "Help me explore an idea", "Draft a structured outline" ], onSelectSuggestion: @escaping (String) -> Void)` | closure | ai |
| `AIMessageBubble` | View | `AI/UI/AIMessageBubble.swift` | `init(message: AIMessage, canRegenerate: Bool = false, onRegenerate: (() -> Void)? = nil)` | closure, model | ai |
| `AIMessageList` | View | `AI/UI/AIMessageList.swift` | `init(messages: [AIMessage], onSelectSuggestion: @escaping (String) -> Void, onRegenerate: @escaping () -> Void)` | closure, model | ai |
| `AIModelSettingsSheet` | View | `AI/UI/AIModelSettingsSheet.swift` | `init(configuration: Binding<AIInferenceConfiguration>, profiles: [AIModelProfile] = AIModelProfile.defaultProfiles, platform: BraisenlyPlatform = .automatic)` | Binding, model | ai |
| `AIStreamingIndicator` | View | `AI/UI/AIStreamingIndicator.swift` | `init(label: String = "Thinking…")` | - | ai |
| `AIToolCallCard` | View | `AI/UI/AIToolCallCard.swift` | `init(toolCall: AIToolCall)` | model | ai |

Nested public token namespaces (inside `BraisenlyDesignSystem`, alias `BraisenlyDS`): `Solarized` (16 colors: base03/02/01/00/0/1/2/3, yellow, orange, red, magenta, violet, blue, cyan, green), `Colors` (backgroundPrimary, backgroundDimmed, surfaceSheet, surfaceElevated, surfaceHighlight, surfaceSnippet, borderSubtle, divider, accentTeal, textPrimary, textBright, textSecondary, textDisabled, matchBackground, matchForeground), `Typography` (documentTitle 30 bold, bodyReading 17.5, vaultTitle 20 bold, rowLabel 16.5, rowLabelMedium 16.5 medium, snippetBody 14, metadata 13.5, badgeNumber 12 bold rounded), `Metrics` (circleButtonSize 44, toolbarHeight 54, rowHeight 48, cardRadius 20, popoverRadius 24, snippetRadius 10, sidebarWidthRatio 0.84). Colors are static `let`s built by `BraisenlyAdaptiveColor.make(light:dark:)` (UIColor/NSColor dynamic provider) — **not environment-driven**; this is the core of the planned refactor.
`BraisenlyPlatform` (enum automatic/iPhone/iPad/mac): `resolved(horizontalSizeClass:)`, `controlSize` 44/48/36, `rowHeight` 48/52/40, `contentMaxWidth` ∞/760/860. `BraisenlyTheme` (light/dark): `colorScheme`, `symbolName`, `next`, `braisenlyTheme(_:)`. `BraisenlySidebarMode` cases: files, search, tags, bookmarks, allProperties (`icon`). 

AI model types needed as fixtures (all public, in `Sources/AI/Models`):
- `AIMessage(id: UUID = UUID(), role: AIMessageRole, text: String, createdAt: Date = .now, status: AIMessageStatus = .complete, citations: [AICitation] = [], toolCalls: [AIToolCall] = [])`; roles system/user/assistant/tool; status sending/streaming/complete/failed.
- `AIConversation(id:, title: String = "New conversation", messages: [AIMessage] = [], isPinned: Bool = false, createdAt:, updatedAt:)`.
- `AICitation(id:, title: String, url: URL? = nil, source: String? = nil)`; `AIToolCall(id:, name: String, summary: String = "", state: .pending/.running/.complete/.failed)`.
- `AIChatFailure`: `.emptyPrompt`, `.responseUnavailable`, `.provider(String)`.
- `AIInferenceConfiguration(activeProfile: AIModelProfile = .lfm3_1_7B_4bit, systemPrompt:, temperature: Double = 0.6, openAIBaseURL:, openAIAPIKey:, anthropicAPIKey:, enableBuiltInTools: Bool = true)`; `AIModelProfile.defaultProfiles` (lfm3_1_7B_4bit, lfm3_1_7B_bf16, lfm3Omni, qwen3_5_4B, gemma4_e4b, appleOnDevice, claudeSonnet, gpt4o, …).
- `AIChatSession(conversation: AIConversation = AIConversation(), draft: String = "", modelID: String? = nil, systemPrompt: String? = nil, temperature: Double = 0.7, client: any AIChatClient, onConversationUpdated: ((AIConversation) -> Void)? = nil)`; `AIChatClient` protocol: `streamResponse(to: AIChatRequest) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error>` (mock client trivial).
- `AIChatWorkspaceController(store: AIConversationStore = AIConversationStore(), defaults: UserDefaults = .standard, initialConfiguration: AIInferenceConfiguration? = nil)`; `AIConversationStore(fileURL: URL? = nil)` (default writes under Documents/AskenlyConversations → pass a temp `fileURL` + isolated `UserDefaults(suiteName:)` for catalog).
- `BraisenlyAI` pulls mlx-swift 0.31.4+ and mlx-swift-lm (pinned revision): heavy dependency for a catalog; the AI UI views themselves only need the model structs above.

## 2. Knob candidates
Knob kinds: bool / int / double / pick / text / color. "fixture" = needs mock data. Defaults are the source defaults.

| View | param → knob (default; range) | needs mock / fixture |
|---|---|---|
| BraisenlyActionGroup | items → fixture `[BraisenlyActionItem]` (3–5, vary `isChecked`); platform → pick(automatic/iPhone/iPad/mac) | action closure → log sink |
| BraisenlyActionItem (data) | id text; icon text (SF Symbol); title text; isChecked bool(false) | – |
| BraisenlyActionRow | item → fixture; platform pick | – |
| BraisenlyAvatarBadge | systemName text("sparkles"); foregroundColor color(accentTeal); backgroundColor color(surfaceElevated); borderColor color(borderSubtle); size double(32; 16–96); iconSize double(14; 8–48) | – |
| BraisenlyBannerCard | message text; systemImage text; iconColor color(Solarized.red); onDismiss → bool "dismissible" (nil vs log) | closure |
| BraisenlyBottomToolbar | tabCount int(23; 0–150); platform pick | 6 closures → log sink |
| BraisenlyCapsuleModifier / `.braisenlyCapsule` | fill color(surfaceElevated) | host content (Text) |
| BraisenlyCardModifier / `.braisenlyCard` | cornerRadius double(20; 0–48); fill color(surfaceElevated) | host content |
| BraisenlyChatBubbleSurface | text text; fill color; foregroundColor color; cornerRadius double(18; 0–36) | – |
| BraisenlyCircleIconButton | systemName text; accessibilityLabel text; iconSize double(18; 10–32); platform pick | action → log |
| BraisenlyCitationPill | title text; source text? (toggle nil); url bool→sample URL; systemImage text("link") | – |
| BraisenlyCodeBlockCard | language text? ; code text(multiline); onCopy bool (nil vs log) | closure |
| BraisenlyCompactWorkspace | documentTitle/documentText text | 6 Bindings (isSidebarOpen, isActionSheetPresented, isContextPopoverOpen, searchText, selectedMode, theme) → `@State` harness |
| BraisenlyConversationRow | title text; subtitle text?; timestampText text?; isSelected bool; isPinned bool; platform pick | action → log |
| BraisenlyDocumentActionSheet | platform pick | none (self-contained) |
| BraisenlyDocumentCanvas | title text("Home"); bodyText text; theme pick; platform pick | theme Binding (default `.constant(.dark)` — must pass real Binding to toggle), 3 closures |
| BraisenlyDocumentChrome | theme, platform | Binding + 3 closures |
| BraisenlyDualActionPill | platform pick | onEdit, onMore → log |
| BraisenlyExpandableSearchResult | query text; platform pick | isExpanded Binding → @State |
| BraisenlyHighlightedText | text text; highlight text; font pick(Typography tokens); baseColor color | – |
| BraisenlyKeyEntryField | title text; placeholder text("sk-…") | text Binding → @State |
| BraisenlyMessageActionPill | isCopied bool; canRegenerate bool | onCopy, onRegenerate → log |
| BraisenlyMobileWorkspaceView | documentTitle text; documentText text; initialTheme pick; platform pick | self-contained (owns state) |
| BraisenlyModelPill | title text; systemImage text("cpu"); action bool (nil/log) | closure |
| BraisenlyParameterSliderRow | title text; range double pair (0.0…1.5); step double(0.1; 0.01–1); formatString pick("%.1f","%.2f","%.0f") | value Binding<Double> → @State |
| BraisenlyPromptField | placeholder text; cornerRadius double(18; 0–32); fill color | text Binding → @State; onSubmit |
| BraisenlyPulseIndicator | label text("Thinking…") | – |
| BraisenlyRegularWorkspace | documentTitle/Text text; platform pick | 5 Bindings (isActionSheetPresented, isContextPopoverOpen, searchText, selectedMode, theme) |
| BraisenlySearchMetadataRow | none | – |
| BraisenlySearchSnippetCard | text text; query text; platform pick | – |
| BraisenlySendStopButton | isResponding bool; canSend bool; size double(44; 24–72) | onSend/onCancel → log |
| BraisenlySidebarContextPopover | platform pick | selectedMode, isPresented Bindings |
| BraisenlySidebarDrawer | platform pick | searchText, selectedMode, isShowingContextPopover Bindings |
| BraisenlySidebarFooter | selectedMode pick(5 cases); platform pick | onModePickerTap → log |
| BraisenlySidebarSearchHeader | platform pick | searchText Binding |
| BraisenlyStatusCard | title text; subtitle text; systemImage text; iconColor color(accentTeal) | – |
| BraisenlySuggestionCard | title text; systemImage text? ("arrow.up.right") | action → log |
| BraisenlyTabCounterBadge | count int(23; 0–150) | – |
| BraisenlyThemeToggle | platform pick | theme Binding<BraisenlyTheme> |
| BraisenlyToolbarIconButton | systemName text; label text; isEnabled bool(true) | action → log |
| AIChatErrorBanner | failure pick(`.emptyPrompt/.responseUnavailable/.provider("…")`) | onDismiss → log |
| AIChatHeader | title text; modelName text?; platform pick | theme Binding; 4 optional closures (bool each: nil vs log) |
| AIChatView | platform pick; initialTheme pick; modelName text?; closures | `AIChatSession` fixture: conversation + `MockChatClient: AIChatClient` (canned stream) |
| AIChatWorkspaceView | initialTheme pick; platform pick | `AIChatWorkspaceController` fixture: isolated `AIConversationStore(fileURL: tmp)` + `UserDefaults(suiteName:)` |
| AICitationChip | citation → fixture `AICitation` (title text, source text?, url bool) | – |
| AIComposer | isResponding bool | text Binding; onSend/onCancel |
| AIConversationActionSheet | conversationTitle text; isPinned bool; platform pick | 5 closures (`onExportMarkdown` returns String → fixture `"# …"`), uses pasteboard |
| AIConversationSidebar | activeModelName text; platform pick | `[AIConversation]` fixture (≥3, one pinned), selectedConversationID UUID, searchText Binding, 4 closures |
| AIEmptyState | suggestions → text list (3 defaults) | onSelectSuggestion closure |
| AIMessageBubble | canRegenerate bool; message → fixture (role pick user/assistant; status pick; text; citations 0–3; toolCalls 0–2) | onRegenerate closure |
| AIMessageList | messages → fixture `[AIMessage]` (0 shows empty state; 3–6) | 2 closures |
| AIModelSettingsSheet | profiles pick; platform pick | `Binding<AIInferenceConfiguration>` → @State(AIInferenceConfiguration()) |
| AIStreamingIndicator | label text("Thinking…") | – |
| AIToolCallCard | toolCall → fixture (name text; summary text; state pick 4) | – |

## 3. Token usage census
Counted as literal occurrences of `BraisenlyDS.Colors.` / `.Typography.` / `.Metrics.` / `.Solarized.` per file (files with zero omitted). **Totals over 47 files: Colors 120, Typography 44, Metrics 10, Solarized 5.** (`BraisenlyDesignSystem.swift` itself excluded: it defines them.)

| file | Colors | Typography | Metrics | Solarized |
|---|---|---|---|---|
| `AI/UI/AIChatErrorBanner.swift` | 0 | 0 | 0 | 1 |
| `AI/UI/AIChatHeader.swift` | 3 | 1 | 0 | 0 |
| `AI/UI/AIChatView.swift` | 1 | 0 | 0 | 0 |
| `AI/UI/AIChatWorkspaceView.swift` | 2 | 0 | 1 | 0 |
| `AI/UI/AIConversationActionSheet.swift` | 3 | 1 | 0 | 0 |
| `AI/UI/AIConversationSidebar.swift` | 9 | 4 | 0 | 0 |
| `AI/UI/AIEmptyState.swift` | 3 | 2 | 0 | 0 |
| `AI/UI/AIMessageBubble.swift` | 4 | 0 | 0 | 0 |
| `AI/UI/AIModelSettingsSheet.swift` | 9 | 6 | 0 | 0 |
| `AI/UI/AIToolCallCard.swift` | 1 | 0 | 0 | 2 |
| `BraisenlySwiftUI/BraisenlyActionGroup.swift` | 1 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyActionRow.swift` | 1 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyAvatarBadge.swift` | 3 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyBannerCard.swift` | 3 | 1 | 0 | 1 |
| `BraisenlySwiftUI/BraisenlyBottomToolbar.swift` | 0 | 0 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlyCapsuleModifier.swift` | 3 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyCardModifier.swift` | 3 | 0 | 2 | 0 |
| `BraisenlySwiftUI/BraisenlyChatBubbleSurface.swift` | 2 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyCircleIconButton.swift` | 1 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyCitationPill.swift` | 2 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyCodeBlockCard.swift` | 6 | 2 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlyCompactWorkspace.swift` | 0 | 0 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlyConversationRow.swift` | 8 | 3 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyDocumentActionSheet.swift` | 2 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyDocumentCanvas.swift` | 3 | 2 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyDualActionPill.swift` | 1 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyExpandableSearchResult.swift` | 1 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyHighlightedText.swift` | 3 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyKeyEntryField.swift` | 5 | 2 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlyMessageActionPill.swift` | 2 | 2 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyMobileWorkspaceView.swift` | 1 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyModelPill.swift` | 4 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyParameterSliderRow.swift` | 3 | 2 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyPromptField.swift` | 2 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyPulseIndicator.swift` | 2 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlySearchMetadataRow.swift` | 1 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlySearchSnippetCard.swift` | 1 | 1 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlySendStopButton.swift` | 2 | 0 | 0 | 1 |
| `BraisenlySwiftUI/BraisenlySidebarContextPopover.swift` | 2 | 1 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlySidebarDrawer.swift` | 3 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlySidebarFooter.swift` | 1 | 2 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlySidebarSearchHeader.swift` | 2 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyStatusCard.swift` | 4 | 2 | 1 | 0 |
| `BraisenlySwiftUI/BraisenlySuggestionCard.swift` | 2 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyTabCounterBadge.swift` | 2 | 1 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyThemeToggle.swift` | 1 | 0 | 0 | 0 |
| `BraisenlySwiftUI/BraisenlyToolbarIconButton.swift` | 2 | 0 | 0 | 0 |

### 3a. Ad-hoc values the theme migration must fold into tokens (file:line)
**`.font(.system(size:…))`** (12): SendStopButton:28 (16 bold); CodeBlockCard:42 (13.5 mono); AvatarBadge:29 (iconSize, semibold); DualActionPill:28 (18 medium); ConversationRow:37 (14 medium); ModelPill:32 (11 semibold), :40 (10 semibold); ThemeToggle:19 (18 medium); SuggestionCard:28 (13 semibold); CircleIconButton:30 (iconSize, medium); ToolbarIconButton:24 (18 medium); CitationPill:33 (11 semibold). (All under `Sources/BraisenlySwiftUI/Braisenly…`.) No `.font(.title/.body/…)` text styles anywhere; every font is a fixed point size → **no Dynamic Type support**.

**`Color.black/.white/.gray` literals** (2, both scrims): CompactWorkspace:48 `Color.black.opacity(0.38)`; AI/UI/AIChatWorkspaceView:85 `Color.black.opacity(0.38)`. No `.white`/`.gray` literals. (Raw `Color(red:…)` only inside AdaptiveColor.swift:26,35 fallback.)

**Hardcoded `.padding(<number>)`** (all under `Sources/…`; platform ternaries marked ⇄): 
CodeBlockCard:34 (h12), :35 (v8), :45 (12); SidebarSearchHeader:25 (h14), :32 (⇄ h12/16), :33 (⇄ v10/14); ChatBubbleSurface:27 (14); HighlightedText:27 (h1.5/0), :28 (v0.5/0); MessageActionPill:41 (h10), :42 (v5); SidebarDrawer:42 (⇄ 12/16), :56 (h14), :57 (⇄ bottom 104/126); SidebarFooter:27 (h18), :46 (h14), :47 (b12); SearchSnippetCard:19 (⇄ 10/12); BottomToolbar:47 (⇄ h18/26); StatusCard:38 (12); ActionRow:24 (h16); ActionGroup:24 (h16); TabCounterBadge:14 (h4), :15 (v2); DocumentActionSheet:51 (h16), :52 (b24), :57 (⇄ top 16/10); ExpandableSearchResult:36 (lead12); PromptField:31 (h14), :32 (v12); SidebarContextPopover:34 (h14), :45 (⇄ 8/10); ConversationRow:59 (h14), :60 (v10); SearchMetadataRow:14 (h16), :15 (v12); ModelPill:44 (h10), :45 (v5); ParameterSliderRow:39 (h16), :40 (v12); DocumentChrome:38 (⇄ h20/16), :39 (⇄ top 12/6), :46 (⇄ b16/12); DocumentCanvas:48 (⇄ h20/32), :49 (⇄ top 82/74), :50 (b110); SuggestionCard:32 (h16), :33 (v10); KeyEntryField:48 (h14); BannerCard:38 (12); CitationPill:39 (h10), :40 (v6); AI/UI: AIModelSettingsSheet:151 (h16), :152 (b24), :157 (⇄ top 16/10); AIConversationActionSheet:133 (h16), :134 (b24), :139 (⇄ top 16/10); AIConversationSidebar:56 (h10), :57 (v5), :62 (h16), :63 (v10), :86 (⇄ h10/12), :87 (v6), :110 (h14), :111 (v12); AIChatHeader:84 (h16), :85 (v10); AIChatView:61 (h16), :62 (b8), :71 (h16), :72 (v12); AIMessageList:38 (16); AIEmptyState:45 (24). **≈100 sites; recurring values 4/5/6/8/10/12/14/16/18/24 → spacing scale candidates {2,4,5,6,8,10,12,14,16,18,24}.**
Also hardcoded `VStack/HStack(spacing:)` values exist (not enumerated; `grep 'spacing:'`).

**Hardcoded corner radii**: HighlightedText:31 (3); TabCounterBadge:17 (5); ConversationRow:65,:71 (14); `braisenlyCard(cornerRadius:)` overrides: DocumentActionSheet:41 (24), AIConversationActionSheet:85 (24), KeyEntryField:50 (14), ParameterSliderRow:41 (16), SuggestionCard:35 (14), BannerCard:39 (12). Param defaults: ChatBubbleSurface init `cornerRadius: CGFloat = 18`, PromptField init `cornerRadius: CGFloat = 18`. Token radii in use: cardRadius 20 (CardModifier default), popoverRadius 24, snippetRadius 10 (these exist but 24/14/12/16/18 are untokenized).

**Hardcoded `.frame(width:/height:/maxWidth:)`**: SidebarSearchHeader:26 (h ⇄ 34/42), :28 (36×42); SendStopButton:31 (size param); StatusCard:25 (w20); DocumentActionSheet:32 (capsule 46×5), :53 (maxW ⇄ 480/620), :59 (min 440/620 mac); SidebarDrawer:62 (hairline w0.5); BottomToolbar:48 (⇄ h44/toolbarHeight); ConversationRow:39 (w20); ActionRow:17 (w22); KeyEntryField:28 (w20); SidebarContextPopover:29 (w24); SuggestionCard:34 (maxW420, minH44); AIConversationSidebar:117 (w0.5); AIModelSettingsSheet:33 (46×5), :153 (maxW ⇄ 500/620), :159 (min 480×640 mac); AIMessageBubble:59 (maxW680); AIConversationActionSheet:75 (46×5), :135 (maxW ⇄ 480/620), :141 (min 440×520 mac); AIChatView:70 (maxW860); AIMessageList:39 (maxW860). Already token/Platform-driven: CircleIconButton:32, ThemeToggle:22 (Platform.controlSize), ConversationRow:61/ActionRow:25/SidebarFooter:28/SidebarContextPopover:35 (Platform.rowHeight), DocumentCanvas:46 (contentMaxWidth), KeyEntryField:49 (Metrics.rowHeight). Sidebar width: CompactWorkspace:58 and AIChatWorkspaceView:112 use `sidebarWidth` computed from `Metrics.sidebarWidthRatio`.

**Duplicate hand-rolled sheet grabber**: `Capsule 46×5` in DocumentActionSheet, AIModelSettingsSheet, AIConversationActionSheet (→ one token/component).

## 4. Bare-SwiftUI surface census
Per file: constructor/modifier × count (regex census; `Text/Image` counted only when written as constructors). Files with no entry are pure composites of other Braisenly views.

| file | constructs |
|---|---|
| `AI/UI/AIChatHeader.swift` | Divider×1 HStack×1 Spacer×1 Text×1 VStack×1  |
| `AI/UI/AIChatView.swift` | VStack×1  |
| `AI/UI/AIChatWorkspaceView.swift` | .presentationDetents×2 .presentationDragIndicator×2 .sheet×2 NavigationSplitView×1 ZStack×1  |
| `AI/UI/AIComposer.swift` | HStack×1  |
| `AI/UI/AIConversationActionSheet.swift` | Capsule×1 HStack×1 Text×1 VStack×3  |
| `AI/UI/AIConversationSidebar.swift` | Button×2 Divider×2 ForEach×1 Label×2 LazyVStack×1 Rectangle×1 Spacer×2 Text×3 VStack×2 ZStack×1  |
| `AI/UI/AIEmptyState.swift` | ForEach×1 Text×2 VStack×3  |
| `AI/UI/AIMessageBubble.swift` | ForEach×2 HStack×2 ScrollView×1 VStack×1  |
| `AI/UI/AIMessageList.swift` | ForEach×1 LazyVStack×1  |
| `AI/UI/AIModelSettingsSheet.swift` | Capsule×1 Spacer×1 Text×6 VStack×5  |
| `BraisenlySwiftUI/BraisenlyActionGroup.swift` | Divider×1 ForEach×1 VStack×1  |
| `BraisenlySwiftUI/BraisenlyActionRow.swift` | HStack×1 Image×2 Rectangle×1 Spacer×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyAvatarBadge.swift` | Circle×2 Image×1  |
| `BraisenlySwiftUI/BraisenlyBannerCard.swift` | Button×1 HStack×1 Image×2 Spacer×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyBottomToolbar.swift` | Button×1 HStack×1  |
| `BraisenlySwiftUI/BraisenlyCapsuleModifier.swift` | Capsule×2  |
| `BraisenlySwiftUI/BraisenlyCardModifier.swift` | RoundedRectangle×2  |
| `BraisenlySwiftUI/BraisenlyChatBubbleSurface.swift` | Text×1  |
| `BraisenlySwiftUI/BraisenlyCircleIconButton.swift` | Button×1 Image×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyCitationPill.swift` | HStack×1 Image×1 Link×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyCodeBlockCard.swift` | Button×1 Divider×1 Label×1 ScrollView×1 Spacer×1 Text×2 VStack×1  |
| `BraisenlySwiftUI/BraisenlyCompactWorkspace.swift` | ZStack×1  |
| `BraisenlySwiftUI/BraisenlyConversationRow.swift` | Button×1 HStack×1 Image×1 Rectangle×1 RoundedRectangle×2 Spacer×1 Text×3 VStack×1  |
| `BraisenlySwiftUI/BraisenlyDocumentActionSheet.swift` | Capsule×1 VStack×2  |
| `BraisenlySwiftUI/BraisenlyDocumentCanvas.swift` | Text×2 VStack×1  |
| `BraisenlySwiftUI/BraisenlyDocumentChrome.swift` | Spacer×2  |
| `BraisenlySwiftUI/BraisenlyDualActionPill.swift` | Button×2 HStack×1 Image×2  |
| `BraisenlySwiftUI/BraisenlyExpandableSearchResult.swift` | Image×1 Spacer×1 Text×2 VStack×1  |
| `BraisenlySwiftUI/BraisenlyHighlightedText.swift` | ForEach×1 HStack×1 RoundedRectangle×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyKeyEntryField.swift` | HStack×1 Image×2 SecureField×1 Text×1 TextField×1 VStack×1  |
| `BraisenlySwiftUI/BraisenlyMessageActionPill.swift` | Button×2 HStack×1 Label×2  |
| `BraisenlySwiftUI/BraisenlyMobileWorkspaceView.swift` | .presentationDetents×1 .presentationDragIndicator×1 .sheet×1  |
| `BraisenlySwiftUI/BraisenlyModelPill.swift` | Button×1 HStack×1 Image×2 Text×1  |
| `BraisenlySwiftUI/BraisenlyParameterSliderRow.swift` | Slider×1 Spacer×1 Text×2 VStack×1  |
| `BraisenlySwiftUI/BraisenlyPromptField.swift` | TextField×1  |
| `BraisenlySwiftUI/BraisenlyPulseIndicator.swift` | HStack×1 ProgressView×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyRegularWorkspace.swift` | NavigationSplitView×1  |
| `BraisenlySwiftUI/BraisenlySearchMetadataRow.swift` | Label×1 Spacer×1 Text×1  |
| `BraisenlySwiftUI/BraisenlySendStopButton.swift` | Button×1 Circle×1 Image×1  |
| `BraisenlySwiftUI/BraisenlySidebarContextPopover.swift` | Capsule×1 ForEach×1 HStack×1 Image×1 Spacer×1 Text×1 VStack×1  |
| `BraisenlySwiftUI/BraisenlySidebarDrawer.swift` | Divider×1 Rectangle×1 VStack×2 ZStack×1  |
| `BraisenlySwiftUI/BraisenlySidebarFooter.swift` | Button×1 Image×2 Spacer×2 Text×3 VStack×2  |
| `BraisenlySwiftUI/BraisenlySidebarSearchHeader.swift` | HStack×2 Image×3 Text×1 TextField×1  |
| `BraisenlySwiftUI/BraisenlyStatusCard.swift` | HStack×1 Image×1 Spacer×1 Text×2 VStack×1  |
| `BraisenlySwiftUI/BraisenlySuggestionCard.swift` | Button×1 HStack×1 Image×1 Spacer×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyTabCounterBadge.swift` | RoundedRectangle×1 Text×1  |
| `BraisenlySwiftUI/BraisenlyThemeToggle.swift` | Button×1 Image×1  |
| `BraisenlySwiftUI/BraisenlyToolbarIconButton.swift` | Button×1 Image×1 Text×1  |

Totals of structural interest: **NavigationSplitView** only in BraisenlyRegularWorkspace and AIChatWorkspaceView; **GeometryReader: 0**; **ScrollView**: AIMessageBubble (code), CodeBlockCard; **LazyVStack**: AIConversationSidebar, AIMessageList, **List/Form/Toggle/Picker/Menu/Stepper/TabView: 0**; **sheet + presentationDetents + presentationDragIndicator**: BraisenlyMobileWorkspaceView, AIChatWorkspaceView (×2); **popover: 0** (BraisenlySidebarContextPopover is a hand-rolled overlay card, not `.popover`); **Slider**: only ParameterSliderRow; **TextField/SecureField**: KeyEntryField, PromptField, SidebarSearchHeader; **Divider**: ActionGroup, SidebarDrawer, CodeBlockCard, AIChatHeader, AIConversationSidebar; **Capsule** (grabber/pill): CapsuleModifier, DocumentActionSheet, SidebarContextPopover, AIModelSettingsSheet, AIConversationActionSheet; **Circle**: AvatarBadge, SendStopButton; **RoundedRectangle**: CardModifier, ConversationRow, HighlightedText, TabCounterBadge. `.buttonStyle(.plain)` is used throughout; no `ButtonStyle`/`LabelStyle`/`ToggleStyle` types exist.

## 5. Gap list (what a catalog shell needs)
| needed | exists? |
|---|---|
| section header | **absent.** Closest: `BraisenlySearchMetadataRow` (label+spacer row, no title API), `BraisenlySidebarFooter` |
| selectable nav row | partial: `BraisenlyConversationRow(isSelected:isPinned:)` (title/subtitle/timestamp row with selection fill); `BraisenlyActionRow` (icon+title+check, not selectable-styled). No icon-leading nav row |
| segmented control | **absent.** `BraisenlySidebarContextPopover` is a 5-way mode picker (hardcoded to `BraisenlySidebarMode`) |
| toggle row | **absent** (no `Toggle` anywhere). `BraisenlyThemeToggle` is a fixed light/dark circle button |
| stepper row | **absent** |
| text-field row | partial: `BraisenlyKeyEntryField` (titled secure/plain field card), `BraisenlyPromptField`, `BraisenlySidebarSearchHeader` — all purpose-specific |
| chip group | **absent.** Single chips only: `BraisenlyCitationPill`, `BraisenlyModelPill`, `AICitationChip`; no wrapping/flow layout |
| color swatch | **absent** |
| property table (key/value rows) | **absent.** Closest: `BraisenlyParameterSliderRow`, `BraisenlyActionGroup` (list of rows in a card) |
| empty state | in AI product only: `AIEmptyState(suggestions:onSelectSuggestion:)` (suggestion-specific; core target has none) |
| theme switcher | partial: `BraisenlyThemeToggle` + `BraisenlyTheme{light,dark}` (2-state only; no multi-theme/`BraisenlyThemeDefinition`; `braisenlyTheme(_:)` only sets `preferredColorScheme`) |
| layout wrappers VStack/HStack/ZStack/Scroll/Spacer/Divider/Text/Icon/Grid/SplitView | **all absent.** Components call bare SwiftUI directly (see §4). Only layout-ish helpers: `BraisenlyCardModifier`, `BraisenlyCapsuleModifier`, `BraisenlyPlatform.contentMaxWidth`, `BraisenlyRegularWorkspace`/`CompactWorkspace` (document-app specific `NavigationSplitView`/`ZStack` compositions) |
| also needed by a catalog | no `View` to render a code/knob panel; no environment keys at all (`@Environment` use is only `horizontalSizeClass`, `dismiss`); no `ButtonStyle`s; no glass surface |

## 6. Unmerged branches
Merge base of both branches with `development` is `50722d7` (main). `development` = main + 2 xcscheme files only (`3aa0034`).

**`adaptive-solarized-themes`** — `git log development..` → `e5050bc Add adaptive components and Solarized themes`. `git diff --stat development..` : 40 files, +1294/−899. Replaces the 7 monolith files (Primitives/Sidebar/Surfaces/Toolbar/Workspace/ActionSheet) with the one-type-per-file layout; adds Solarized palette + adaptive light/dark colors (`BraisenlyAdaptiveColor`, new `BraisenlyDesignSystem`), `BraisenlyPlatform`, `BraisenlyTheme`/`ThemeToggle`, workspace/sidebar/document components, 6 tests, README. Deletes the two xcschemes development added (merge-tree still resolves cleanly).

**`ai-chat-components`** — `git log development..` → `8570eb1`, `364b181`, `95f0c02`, `4c290eb`, `e5050bc` (5 commits, includes the whole adaptive branch). `git diff --stat development..` : 98 files, +8306/−907. Adds AI chat primitives in core (AvatarBadge, BannerCard, ChatBubbleSurface, CitationPill, CodeBlockCard, KeyEntryField, MessageActionPill, ModelPill, ParameterSliderRow, PromptField, PulseIndicator, SendStopButton, StatusCard, SuggestionCard, ConversationRow), the `BraisenlyAI` target (Models: 25 files incl. MLX LFM3/Gemma4 inference, Anthropic/OpenAI/FoundationModels clients; UI: 14 views), mlx-swift deps in Package.swift, `BraisenlyAITests` (7 tests).
`git merge-tree --write-tree development ai-chat-components` → clean tree (no conflicts) `c413c1d`.

**Overlap with planned refactor** (env-driven `BraisenlyThemeDefinition`, Liquid Glass default, iOS 26 floor): both branches touch exactly the files the refactor rewrites (`BraisenlyDesignSystem`, `BraisenlyTheme`, `BraisenlyAdaptiveColor`, every component using `BraisenlyDS.Colors.*`). Doing the refactor on `development` first would make each branch a conflict magnet (development has none of these files). The refactor also depends on the one-type-per-file split and the Platform type that only exist on these branches. Neither branch adds environment-driven theming or glass, so they do not pre-empt it; they are its necessary base.

**Recommendation:**
- `adaptive-solarized-themes` → **merge first** (into `development`): clean, small, is the base for everything.
- `ai-chat-components` → **merge second** (it already contains adaptive; merging it after, or instead, yields identical tree). Needs the open decision on the 9-file uncommitted work in `-fix-lfm3` (same branch lineage). If the catalog app only needs core + AI UI, the heavy mlx deps in `BraisenlyAI` remain a build-cost concern → consider cherry-picking only the UI/model-struct subset later; the clean merge is the safer first step.
- Ignore neither; do not start the theme refactor until the first merge lands on `development`.

## 7. Existing tests
Swift Testing (`@Test`), 13 total.
`Tests/BraisenlySwiftUITests/BraisenlySwiftUITests.swift` (6): `sidebarModesExposeStableSymbols` (SidebarMode.icon/ids), `actionItemsPreserveIdentityAndSelection` (ActionItem id/isChecked), `explicitPlatformsRemainStable` (Platform.resolved), `platformsUseDistinctControlDensity` (controlSize/rowHeight differ), `themesToggleBidirectionally` (Theme.next), `chatPrimitivesStoreConfigurationProperties` (init-stored props of chat primitives).
`Tests/BraisenlyAITests/BraisenlyAITests.swift` (7): `sessionStreamsAssistantResponse` (AIChatSession + mock client stream), `sessionRejectsEmptyPrompt`, `conversationRoundTripsThroughCodable`, `sseLineParserExtractsValidJSONPayloads`, `smartLocalAssistantBuildsToolCallsAndTextDeltas`, `openWeightCatalogIncludesLFM3AndOmniModels`, `workspaceControllerManagesMultipleConversationsAndPersistence` (store + UserDefaults).
Nothing tests view bodies, tokens/colors, snapshots, or accessibility. `development` has 1 test file (13 lines).

## 8. Platform-conditional code
| site | what |
|---|---|
| BraisenlyPlatform.swift:12-16 | `#if os(macOS)` → `.mac` else size-class → iPad/iPhone in `resolved` |
| BraisenlyAdaptiveColor.swift:3-7 | `#if canImport(UIKit)` import UIKit / `#elseif canImport(AppKit)` import AppKit |
| BraisenlyAdaptiveColor.swift:23-36 | `UIColor` dynamic provider / `NSColor(name:)` appearance provider (`bestMatch([.darkAqua,.aqua])`) / `#else` static light fallback |
| AI/UI/AIMessageBubble.swift:4-8, 76-81 | UIKit/AppKit import; copy to `UIPasteboard.general` vs `NSPasteboard` |
| AI/UI/AIConversationActionSheet.swift:4-8, 115-120 | same import + pasteboard copy (markdown export) |
| AI/Models/AIFoundationModelsChatClient.swift:2-4, 14-18, 25-30, 34-98 | `#if canImport(FoundationModels)` + `@available(iOS 26.0, macOS 26.0, *)` / `#available` gates |
No `os(iOS)`/`os(visionOS)`/`os(watchOS)` sites. Runtime branching on `BraisenlyPlatform` (`.mac` ternaries) appears in ~20 view files (see ⇄ marks in §3a).

## 9. development vs ai-chat-components (8570eb1)
`development` (3aa0034) = main + 2 xcscheme files. Its `Sources/BraisenlySwiftUI` has 7 files / 19 public types; the inventory above is of `ai-chat-components` 8570eb1 (confirmed by team lead as the real component set).

| development file | public types |
|---|---|
| BraisenlyDesignSystem.swift | `BraisenlyDesignSystem` (Colors/Typography/Metrics), `typealias BraisenlyDS` |
| BraisenlyPrimitives.swift | `BraisenlyCircleIconButton`, `BraisenlyDualActionPill`, `BraisenlyTabCounterBadge`, `BraisenlyHighlightedText` |
| BraisenlySurfaces.swift | `BraisenlyCapsuleModifier`, `BraisenlyCardModifier`, `View.braisenlyCapsule(fill:)`, `View.braisenlyCard(cornerRadius:fill:)` |
| BraisenlySidebar.swift | `BraisenlySidebarMode`, `BraisenlySearchSnippetCard`, `BraisenlySidebarContextPopover`, `BraisenlySidebarDrawer` |
| BraisenlyToolbar.swift | `BraisenlyBottomToolbar` |
| BraisenlyWorkspace.swift | `BraisenlyDocumentCanvas`, `BraisenlyMobileWorkspaceView` |
| BraisenlyActionSheet.swift | `BraisenlyActionItem`, `BraisenlyActionRow`, `BraisenlyActionGroup`, `BraisenlyDocumentActionSheet` |

**API dropped on 8570eb1: none.** Every public declaration above (diffed by name) is still present; the 7 files were split into one-type-per-file. Changes that are not drops:
- Source-compatible additions: a `platform: BraisenlyPlatform = .automatic` parameter on CircleIconButton, DualActionPill, SearchSnippetCard, SidebarContextPopover, SidebarDrawer, BottomToolbar, DocumentCanvas, MobileWorkspaceView(+`initialTheme`), ActionRow, ActionGroup, DocumentActionSheet; `theme: Binding<BraisenlyTheme> = .constant(.dark)` on DocumentCanvas.
- Value change: every `BraisenlyDS.Colors.*` changes from a fixed dark teal `Color(red:…)` to a Solarized light/dark adaptive color (same names, same Typography/Metrics names and values). Existing consumers keep compiling but get new colors.
- New (not on development): everything else in §1 (`BraisenlyPlatform`, `BraisenlyTheme`, `BraisenlyThemeToggle`, `Solarized`, the 14 `AI*` views, ~25 more core types).

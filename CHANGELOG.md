# Changelog

## Unreleased

## 0.2.0 - 2026-11-25

Catalog visual-audit fixes from the macOS walk (screenshots in the package repo's `docs/audits/2026-11-13-catalog-visual-audit.md`).

### Fixed
- Detail content keeps a constant left edge aligned with the toolbar title; leading padding `l + xs` (F5, F7).
- `workspaces.compact` stage constrains the preview to ~390 pt, centred (F15).
- Stage heights for `document.chrome` and `document.actionSheet`; compact workspace shrinks below 390 pt in narrow columns (F13, F14, F22).
- Colour knob grids: rows spaced by one theme step, grid starts under its label, selected token name visible (F12).
- `layout.vStack`/`hStack`/`scroll`/`grid`/`zStack` and `tokens.metrics` capsules carry theme-step padding (F9, F16).
- Fields entries retitled to human names ("Key Entry Field", "Parameter Slider Row", "Prompt Field", "Text Field Row") (F21).
- `workspaces.compact` entry follows the app theme unless its `initialTheme` knob is set; UI test uses the themed stepper (F4, F20).
- `layout.icon`, `indicators.*`, `buttonsPills.toolbarIconButton` stages render at clearly visible default sizes (F22).
- `scripts/shot.sh`: aborts on build failure; propagates `screencapture` failure (exit 1, app cleaned up); passes parameters to the locked child shell via the environment instead of shell interpolation.
- `CatalogWalkTests`: scrolls the sidebar row into view before tapping (fixes deterministic failure in `testSplitViewEntryDoesNotTrapNavigation`).

### Added
- `catalog.sidebar` accessibility identifier on the sidebar scroll view.

### Known gaps
- Presto (iPad) verification of F7/F8 skipped by user decision (2026-11-25); macOS walk 6/6 green.

## 0.1.0 - 2026-11-13

### Added
- Catalog shell: split view with theme switcher, search, grouped sidebar, live stage, knobs pane and code snippet.
- 12 groups, 71 entries (60 typed views and modifiers, 11 token and concept entries), each with typed knobs and a tracking snippet.
- Launch arguments `-catalogEntry` and `-catalogTheme` for scripts and UI tests.
- Registry completeness test against the package symbol graph (`scripts/public-views.sh`), registry invariants including render-at-knob-bounds, and knob and search tests.
- Dog-food lint (`scripts/dogfood-lint.sh`) as a pre-build phase and in `check.sh`; zero bare SwiftUI in `Sources`.
- UI walk (`CatalogWalkTests`) screenshotting every entry in every theme, knob smoke, theme-switch state persistence and nested split view navigation checks.
- `BraisenlySwiftDemo-AI` scheme stub behind `BRAISENLY_AI` (empty AI group).
- Device-only scripts (`gen`, `build-mac`, `build-ios`, `test-unit`, `deploy-presto`, `run-mac`, `check`) with simulator refusal and negative tests.

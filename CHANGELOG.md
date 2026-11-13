# Changelog

## Unreleased

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

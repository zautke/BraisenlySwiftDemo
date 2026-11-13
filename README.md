# BraisenlySwiftDemo

Storybook-style catalog app for the [BraisenlySwiftUI](https://github.com/zautke/BraisenlySwiftUI) design system.
Every public primitive and compound component is listed in a grouped sidebar and rendered live with typed knobs.
The app is built exclusively from BraisenlySwiftUI components (dog food): no bare SwiftUI controls, surfaces or layout.

Targets: iOS 26+ (iPad, iPhone) and macOS 26+. Verified live on physical devices only; no simulators.

## Setup

```sh
cp .env.example .env   # BRAISENLY_PACKAGE_PATH, DEVELOPMENT_TEAM, BUNDLE_ID_PREFIX, DEVICE_UDID, MAC_DESTINATION, SYMBOLGRAPH_TARGET
scripts/gen.sh         # xcodegen generate (the .xcodeproj is gitignored; project.yml is the source of truth)
scripts/check.sh       # lint, public-view drift check, unit tests, both builds, negative tests
```

The package is consumed as a local path dependency (`BRAISENLY_PACKAGE_PATH`, default `../BraisenlySwiftUI`).

## Scripts

All scripts are bash, take `-h/--help`, use short and long switches, and refuse simulator destinations.

| Script | Switches | Purpose |
|---|---|---|
| `scripts/gen.sh` | | Generate `BraisenlySwiftDemo.xcodeproj` from `project.yml` with `.env` values |
| `scripts/dogfood-lint.sh` | `-p/--path DIR` | Fail on any bare SwiftUI construct under `Sources` (exit 1 on hits) |
| `scripts/public-views.sh` | `-m/--module`, `-o/--output`, `-c/--check` | Regenerate `Tests/Fixtures/public-views.txt` from the package symbol graph; `-c` fails on drift |
| `scripts/test-unit.sh` | `-o/--only ID` (repeatable), `-d/--derived-data PATH` | Run unit tests on macOS |
| `scripts/build-mac.sh` | `-s/--scheme`, `-d/--derived-data` | Build for macOS |
| `scripts/build-ios.sh` | `-s/--scheme`, `-d/--destination`, `-g/--generic`, `-D/--derived-data` | Build for the device in `DEVICE_UDID` (or generic iOS) |
| `scripts/deploy-presto.sh` | `-s/--scheme`, `-e/--entry`, `-t/--theme`, `-n/--no-console` | Build, install and launch on the device |
| `scripts/run-mac.sh` | `-s/--scheme`, `-e/--entry`, `-t/--theme` | Build and open the macOS app |
| `scripts/check.sh` | `-a/--ai` | Full gate; `-a` also attempts the AI scheme (reported, never fails the run) |

Negative tests under `scripts/tests/` prove each guard fires: simulator refusal, dog-food lint, registry completeness.

## Launch arguments

- `-catalogEntry <id>` selects an entry on launch (unknown id: no selection).
- `-catalogTheme <id>` picks `liquidGlass`, `solarizedLight` or `solarizedDark` (unknown id: Liquid Glass).

Entry ids are `<group>.<name>`, e.g. `cards.statusCard`; the full list is `UITests/Fixtures/catalog-entry-ids.txt`.

## Adding an entry

1. Add a `CatalogEntry` to the group file under `Sources/Catalog/Groups/`, with at least one knob and a `{{key}}` snippet.
2. Run `scripts/test-unit.sh` (registry invariants render the entry at every knob bound).
3. Run `scripts/dogfood-lint.sh`.
4. If the package gained or lost a public view, run `scripts/public-views.sh` to regenerate the fixture.
5. Append the id to `UITests/Fixtures/catalog-entry-ids.txt` in registry order.

## Devices

- presto, iPad Pro 11-inch (M4): `scripts/deploy-presto.sh -e <entry> -t <theme>`.
- macOS on largo: `scripts/run-mac.sh -e <entry> -t <theme>`.
- UI walk: `xcodebuild test … -only-testing:BraisenlySwiftDemoUITests` on either destination attaches one screenshot per entry per theme.

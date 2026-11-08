# BraisenlySwiftDemo

Storybook-style catalog app for the [BraisenlySwiftUI](https://github.com/zautke/BraisenlySwiftUI) design system.
Every public primitive and compound component is listed in a grouped sidebar and rendered live with typed knobs.
The app is built exclusively from BraisenlySwiftUI components (dog food): no bare SwiftUI controls, surfaces or layout.

Targets: iOS 26+ (iPad, iPhone) and macOS 26+. Verified live on physical devices only.

## Setup

```sh
cp .env.example .env   # set DEVICE_UDID, DEVELOPMENT_TEAM, BRAISENLY_PACKAGE_PATH
scripts/gen.sh         # xcodegen generate
scripts/check.sh       # lint + unit tests + builds
```

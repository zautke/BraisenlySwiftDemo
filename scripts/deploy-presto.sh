#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: deploy-presto.sh [-s|--scheme NAME] [-e|--entry ID] [-t|--theme ID] [-n|--no-console] [-h|--help]
  Builds for presto, installs with devicectl and launches with optional -catalogEntry/-catalogTheme."; }
scheme=BraisenlySwiftDemo; entry=""; theme=""; console="--console"
while [[ $# -gt 0 ]]; do case "$1" in
  -s|--scheme) scheme="$2"; shift 2;;
  -e|--entry) entry="$2"; shift 2;;
  -t|--theme) theme="$2"; shift 2;;
  -n|--no-console) console=""; shift;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
load_env; require_vars DEVICE_UDID BUNDLE_ID_PREFIX
root="$(repo_root)"; cd "$root"
scripts/build-ios.sh -s "$scheme"
product="$scheme"; bundle="$BUNDLE_ID_PREFIX.${scheme//-/}"
xcrun devicectl device install app --device "$DEVICE_UDID" "build/DerivedData/Build/Products/Debug-iphoneos/$product.app"
args=(); [[ -n "$entry" ]] && args+=(-catalogEntry "$entry"); [[ -n "$theme" ]] && args+=(-catalogTheme "$theme")
# shellcheck disable=SC2086
xcrun devicectl device process launch --device "$DEVICE_UDID" --terminate-existing $console "$bundle" -- "${args[@]}"

#!/usr/bin/env bash
# Build the macOS app, open one catalog entry in one theme, save a PNG of its window, quit the app.
# Builds are serialized machine-wide through a lock file so concurrent callers queue instead of overloading the host.
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: shot.sh -e|--entry ID -t|--theme ID -o|--output FILE.png [-n|--no-build] [-h|--help]
  Themes: liquidGlass, solarizedLight, solarizedDark. Entry ids: UITests/Fixtures/catalog-entry-ids.txt"; }
entry=""; theme=""; out=""; build=1
while [[ $# -gt 0 ]]; do case "$1" in
  -e|--entry) entry="$2"; shift 2;;
  -t|--theme) theme="$2"; shift 2;;
  -o|--output) out="$2"; shift 2;;
  -n|--no-build) build=0; shift;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
[[ -n "$entry" && -n "$theme" && -n "$out" ]] || { Usage >&2; exit 2; }
load_env; require_vars BUILD_LOCK_FILE BUNDLE_ID_PREFIX; cd "$(repo_root)"
run() {
  if [[ $build == 1 ]]; then scripts/gen.sh >/dev/null; scripts/build-mac.sh 2>&1 | grep -E "error:|\*\* BUILD" || true; fi
  local app="build/DerivedData/Build/Products/Debug/BraisenlySwiftDemo.app"
  pkill -x BraisenlySwiftDemo 2>/dev/null || true
  defaults delete "$BUNDLE_ID_PREFIX.BraisenlySwiftDemo" 2>/dev/null || true  # drop saved window frames so defaultSize applies
  open -n "$app" --args -catalogEntry "$entry" -catalogTheme "$theme" -ApplePersistenceIgnoreState YES
  local id="" i
  for i in $(seq 1 40); do
    id=$(swift scripts/lib/window-id.swift "Braisenly Catalog" 2>/dev/null || true)
    [[ -n "$id" ]] && break; sleep 0.5
  done
  [[ -n "$id" ]] || { echo "shot.sh: no window appeared" >&2; pkill -x BraisenlySwiftDemo || true; exit 1; }
  sleep 1.5
  mkdir -p "$(dirname "$out")"; screencapture -x -o -l "$id" "$out"
  pkill -x BraisenlySwiftDemo || true
  echo "$out"
}
/usr/bin/lockf "$BUILD_LOCK_FILE" bash -c "$(declare -f run); BUNDLE_ID_PREFIX='$BUNDLE_ID_PREFIX'; build=$build entry='$entry' theme='$theme' out='$out'; run"

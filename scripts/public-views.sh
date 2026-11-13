#!/usr/bin/env bash
# Lists public View/ViewModifier types of a package module via swift symbolgraph-extract (spec §10).
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: public-views.sh [-m|--module NAME] [-o|--output PATH] [-c|--check] [-h|--help]
  Default module BraisenlySwiftUI, output Tests/Fixtures/public-views.txt. -c regenerates to a temp file and exits 1 on drift."; }
module=BraisenlySwiftUI; output=""; check=0
while [[ $# -gt 0 ]]; do case "$1" in
  -m|--module) module="$2"; shift 2;;
  -o|--output) output="$2"; shift 2;;
  -c|--check) check=1; shift;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
load_env; require_vars BRAISENLY_PACKAGE_PATH SYMBOLGRAPH_TARGET
root="$(repo_root)"; cd "$root"
[[ -z "$output" ]] && output="$root/Tests/Fixtures/public-views.txt"
pkg="$root/$BRAISENLY_PACKAGE_PATH"; [[ "$BRAISENLY_PACKAGE_PATH" = /* ]] && pkg="$BRAISENLY_PACKAGE_PATH"
scratch="$root/.build/pkg"; graph="$root/.build/symgraph"
swift build --package-path "$pkg" --scratch-path "$scratch" --target "$module" >/dev/null
rm -rf "$graph"; mkdir -p "$graph"
swift symbolgraph-extract -module-name "$module" -target "$SYMBOLGRAPH_TARGET" \
  -I "$scratch/debug/Modules" -I "$scratch/debug" -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
  -output-dir "$graph" -minimum-access-level public
tmp=$(mktemp)
jq -r '
  (.relationships | map(select(.kind == "conformsTo" and (.targetFallback // .target | tostring | test("View$|ViewModifier$")))) | map(.source)) as $conforming
  | .symbols[]
  | select(.accessLevel == "public" and (.pathComponents | length) == 1)
  | select(.identifier.precise as $id | $conforming | index($id))
  | .names.title' "$graph/$module.symbols.json" | LC_ALL=C sort -u > "$tmp"
if [[ $check -eq 1 ]]; then
  if diff -u "$output" "$tmp"; then echo "public-views: no drift ($(wc -l < "$tmp" | tr -d ' ') types)"; rm -f "$tmp"; exit 0; fi
  echo "public-views: drift detected" >&2; rm -f "$tmp"; exit 1
fi
mkdir -p "$(dirname "$output")"; mv "$tmp" "$output"
echo "public-views: wrote $(wc -l < "$output" | tr -d ' ') types to $output"

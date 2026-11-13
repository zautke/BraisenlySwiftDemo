#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: run-mac.sh [-s|--scheme NAME] [-e|--entry ID] [-t|--theme ID] [-h|--help]
  Builds for macOS and opens the app with optional -catalogEntry/-catalogTheme."; }
scheme=BraisenlySwiftDemo; entry=""; theme=""
while [[ $# -gt 0 ]]; do case "$1" in
  -s|--scheme) scheme="$2"; shift 2;;
  -e|--entry) entry="$2"; shift 2;;
  -t|--theme) theme="$2"; shift 2;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
load_env; cd "$(repo_root)"
scripts/build-mac.sh -s "$scheme"
args=(); [[ -n "$entry" ]] && args+=(-catalogEntry "$entry"); [[ -n "$theme" ]] && args+=(-catalogTheme "$theme")
open -n "build/DerivedData/Build/Products/Debug/$scheme.app" --args "${args[@]}"

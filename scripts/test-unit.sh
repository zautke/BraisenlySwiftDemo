#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: test-unit.sh [-o|--only ID]... [-d|--derived-data PATH] [-h|--help]
  Runs xcodebuild test on \$MAC_DESTINATION. -o repeatable (-only-testing id); default BraisenlySwiftDemoTests."; }
only=(); dd=build/DerivedData
while [[ $# -gt 0 ]]; do case "$1" in
  -o|--only) only+=("-only-testing:$2"); shift 2;;
  -d|--derived-data) dd="$2"; shift 2;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
[[ ${#only[@]} -eq 0 ]] && only=("-only-testing:BraisenlySwiftDemoTests")
load_env; require_vars MAC_DESTINATION
cd "$(repo_root)"
xcodebuild test -project "$PROJECT" -scheme BraisenlySwiftDemo -destination "$MAC_DESTINATION" -derivedDataPath "$dd" "${only[@]}"

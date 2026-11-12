#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: build-mac.sh [-s|--scheme NAME] [-d|--derived-data PATH] [-h|--help]"; }
scheme=BraisenlySwiftDemo; dd=build/DerivedData
while [[ $# -gt 0 ]]; do case "$1" in
  -s|--scheme) scheme="$2"; shift 2;;
  -d|--derived-data) dd="$2"; shift 2;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
load_env; require_vars MAC_DESTINATION
cd "$(repo_root)"
xcodebuild -project "$PROJECT" -scheme "$scheme" -destination "$MAC_DESTINATION" -derivedDataPath "$dd" -allowProvisioningUpdates build

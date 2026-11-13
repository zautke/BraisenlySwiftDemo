#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: build-ios.sh [-s|--scheme NAME] [-d|--destination DEST] [-g|--generic] [-D|--derived-data PATH] [-h|--help]
  Default destination id=\$DEVICE_UDID; -g uses generic/platform=iOS. Simulator destinations are refused (exit 2)."; }
scheme=BraisenlySwiftDemo; dest=""; dd=build/DerivedData
while [[ $# -gt 0 ]]; do case "$1" in
  -s|--scheme) scheme="$2"; shift 2;;
  -d|--destination) dest="$2"; shift 2;;
  -g|--generic) dest="generic/platform=iOS"; shift;;
  -D|--derived-data) dd="$2"; shift 2;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
load_env
if [[ -z "$dest" ]]; then require_vars DEVICE_UDID; dest="id=$DEVICE_UDID"; fi
refuse_simulator "$dest"
cd "$(repo_root)"
xcodebuild -project "$PROJECT" -scheme "$scheme" -destination "$dest" -derivedDataPath "$dd" -allowProvisioningUpdates build

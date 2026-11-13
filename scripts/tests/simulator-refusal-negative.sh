#!/usr/bin/env bash
# Negative test: build-ios.sh must refuse a simulator destination with exit 2.
set -uo pipefail
cd "$(dirname "$0")/../.."
err=$(scripts/build-ios.sh -d "platform=iOS Simulator,name=iPad Pro" 2>&1 >/dev/null)
code=$?
if [[ $code -eq 2 && "$err" == *"refusing simulator destination"* ]]; then
  echo "PASS simulator-refusal"; exit 0
fi
echo "FAIL simulator-refusal: exit=$code stderr=$err"; exit 1

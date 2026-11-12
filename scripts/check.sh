#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: check.sh [-a|--ai] [-h|--help]
  gen -> dogfood-lint -> test-unit -> build-mac -> build-ios -> negative tests. -a also attempts the AI scheme (reported, never fails)."; }
ai=0
while [[ $# -gt 0 ]]; do case "$1" in -a|--ai) ai=1; shift;; -h|--help) Usage; exit 0;; *) Usage >&2; exit 2;; esac; done
load_env; cd "$(repo_root)"
scripts/gen.sh
scripts/dogfood-lint.sh
scripts/test-unit.sh
scripts/build-mac.sh
if xcrun devicectl list devices 2>/dev/null | grep -q "${DEVICE_UDID:-__none__}.*connected"; then scripts/build-ios.sh; else scripts/build-ios.sh -g; fi
if [[ $ai -eq 1 ]]; then
  scripts/build-mac.sh -s BraisenlySwiftDemo-AI && echo "ai-build-mac=pass" || echo "ai-build-mac=fail (reported, not gated)"
  scripts/build-ios.sh -g -s BraisenlySwiftDemo-AI && echo "ai-build-ios=pass" || echo "ai-build-ios=fail (reported, not gated)"
fi
bash scripts/tests/simulator-refusal-negative.sh
bash scripts/tests/dogfood-lint-negative.sh

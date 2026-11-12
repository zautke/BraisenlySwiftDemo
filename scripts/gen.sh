#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: gen.sh [-h|--help]  Generate BraisenlySwiftDemo.xcodeproj from project.yml using .env values."; }
while [[ $# -gt 0 ]]; do case "$1" in -h|--help) Usage; exit 0;; *) Usage >&2; exit 2;; esac; done
load_env
require_vars BRAISENLY_PACKAGE_PATH DEVELOPMENT_TEAM BUNDLE_ID_PREFIX
cd "$(repo_root)"
xcodegen generate --spec project.yml

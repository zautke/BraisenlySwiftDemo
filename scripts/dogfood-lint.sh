#!/usr/bin/env bash
# Zero bare SwiftUI in Sources (U-3). Exit 0 clean, 1 on hits, 2 usage error.
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
Usage() { echo "Usage: dogfood-lint.sh [-p|--path DIR] [-h|--help]   (default DIR: Sources)"; }
path=""
while [[ $# -gt 0 ]]; do case "$1" in
  -p|--path) path="$2"; shift 2;;
  -h|--help) Usage; exit 0;;
  *) Usage >&2; exit 2;; esac; done
[[ -z "$path" ]] && path="$(repo_root)/Sources"
[[ -d "$path" ]] || { echo "dogfood-lint: no such directory: $path" >&2; exit 2; }
pattern='(^|[^A-Za-z0-9_])(VStack|HStack|ZStack|ScrollView|List|Spacer|Divider|Text|Image|Button|Toggle|Picker|Slider|Stepper|TextField|Label|NavigationSplitView|NavigationStack)\(|\.font\(|(^|[^A-Za-z0-9_])Color\.|\.padding\([0-9]'
n=0
while IFS= read -r line; do
  content=${line#*:*:}
  [[ "$content" =~ ^[[:space:]]*// ]] && continue
  # Package API `BraisenlyTextStyle.font(in:)` is the only allowed `.font(` call; SwiftUI's `.font(.body)` stays banned.
  match=$(sed 's/\.font(in:/.FONT_IN(/g' <<<"$content" | grep -oE "$pattern" | head -1 || true)
  [[ -z "$match" ]] && continue
  echo "${line%%:*}:$(cut -d: -f2 <<<"$line"): banned: $match"
  n=$((n+1))
done < <(grep -rnE --include='*.swift' "$pattern" "$path" || true)
echo "dogfood-lint: $n hit(s)"
[[ $n -eq 0 ]]

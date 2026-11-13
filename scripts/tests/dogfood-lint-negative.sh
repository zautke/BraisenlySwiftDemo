#!/usr/bin/env bash
# Negative test: dogfood-lint.sh must flag exactly the five banned lines in Bad.swift and nothing in Good.swift.
set -uo pipefail
cd "$(dirname "$0")/../.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/Bad.swift" <<'SWIFT'
let a = VStack(
let b = Text("x")
let c = Color.red
x.padding(8)
x.font(.body)
SWIFT
cat > "$tmp/Good.swift" <<'SWIFT'
BraisenlyText("x", style: .rowLabel)
.accessibilityLabel("x")
// VStack(
BraisenlyColorTokens.self
SWIFT
out=$(scripts/dogfood-lint.sh -p "$tmp" 2>&1); code=$?
hits=$(grep -c ': banned: ' <<<"$out")
bad=$(grep ': banned: ' <<<"$out" | grep -c 'Bad.swift')
if [[ $code -eq 1 && $hits -eq 5 && $bad -eq 5 ]]; then echo "PASS dogfood-lint-negative"; exit 0; fi
echo "FAIL dogfood-lint-negative: exit=$code hits=$hits badHits=$bad"; echo "$out"; exit 1

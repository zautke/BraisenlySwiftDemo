#!/usr/bin/env bash
# Negative test: a fixture naming a type the catalog lacks must fail RegistryCompletenessTests and name it under `missing`.
set -uo pipefail
cd "$(dirname "$0")/../.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
{ cat Tests/Fixtures/public-views.txt; echo BraisenlyNonexistentView; } | LC_ALL=C sort -u > "$tmp/public-views.txt"
out=$(TEST_RUNNER_CATALOG_PUBLIC_VIEWS_OVERRIDE="$tmp/public-views.txt" scripts/test-unit.sh -o BraisenlySwiftDemoTests/RegistryCompletenessTests 2>&1)
code=$?
if [[ $code -ne 0 ]] && grep -q 'missing: \[.*BraisenlyNonexistentView' <<<"$out"; then echo "PASS completeness-negative"; exit 0; fi
echo "FAIL completeness-negative: exit=$code"; grep -E "missing:|TEST " <<<"$out" | head -5; exit 1

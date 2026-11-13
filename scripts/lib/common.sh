#!/usr/bin/env bash
# Shared helpers for BraisenlySwiftDemo scripts. Source only.

repo_root() { cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd; }

load_env() {
  local root; root="$(repo_root)"
  if [[ -f "$root/.env" ]]; then
    set -a; # shellcheck disable=SC1091
    source "$root/.env"; set +a
  fi
}

require_vars() {
  local v
  for v in "$@"; do
    if [[ -z "${!v:-}" ]]; then
      echo "$(basename "$0"): required .env key $v is unset" >&2
      exit 2
    fi
  done
}

refuse_simulator() {
  if [[ "$1" == *Simulator* ]]; then
    echo "$(basename "$0"): refusing simulator destination '$1' (physical devices only)" >&2
    exit 2
  fi
}

PROJECT=BraisenlySwiftDemo.xcodeproj

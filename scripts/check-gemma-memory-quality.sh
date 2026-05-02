#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH='' cd -- "${SCRIPT_DIR}/.." && pwd)"
HELPER="${REPO_ROOT}/helpers/gemma-memory-quality-check"

if [ ! -f "$HELPER" ]; then
  printf 'ERROR: helper not found: %s\n' "$HELPER" >&2
  exit 1
fi

exec "$HELPER" --static-only "$@"
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH='' cd -- "${SCRIPT_DIR}/.." && pwd)"
HELPER_DIR="${REPO_ROOT}/helpers"
LIVE_DIR="${HOME}/.local/bin"
HELPERS=(gemma-memory-search gemma-memory-rag)

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'ERROR: required command not found: %s\n' "$1" >&2
    exit 1
  }
}

is_python_helper() {
  local file="$1"
  [ -f "$file" ] || return 1
  IFS= read -r first_line < "$file" || first_line=''
  case "$first_line" in
    *python*) return 0 ;;
  esac
  return 1
}

checksum_of() {
  sha256sum "$1" | awk '{print $1}'
}

syntax_check() {
  local file="$1"
  if is_python_helper "$file"; then
    python3 - "$file" <<'PY'
import ast
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
PY
  fi
}

require_cmd sha256sum
require_cmd python3

printf 'gemma-memory-helper drift check\n'
printf 'repo root: %s\n' "$REPO_ROOT"
printf 'live dir: %s\n' "$LIVE_DIR"

for helper in "${HELPERS[@]}"; do
  repo_file="${HELPER_DIR}/${helper}"
  live_file="${LIVE_DIR}/${helper}"

  [ -f "$repo_file" ] || {
    printf 'ERROR: missing repo template: %s\n' "$repo_file" >&2
    exit 1
  }

  repo_exec='no'
  live_exec='no'

  [ -x "$repo_file" ] && repo_exec='yes'

  syntax_check "$repo_file"

  if [ ! -e "$live_file" ]; then
    printf '%s MISSING repo_exec=%s live_exec=%s\n' "$helper" "$repo_exec" "$live_exec"
    continue
  fi

  [ -f "$live_file" ] || {
    printf 'ERROR: live helper exists but is not a regular file: %s\n' "$live_file" >&2
    exit 1
  }

  [ -x "$live_file" ] && live_exec='yes'
  syntax_check "$live_file"

  repo_sum="$(checksum_of "$repo_file")"
  live_sum="$(checksum_of "$live_file")"

  if [ "$repo_sum" = "$live_sum" ]; then
    status='MATCH'
  else
    status='DRIFT'
  fi

  printf '%s %s repo_exec=%s live_exec=%s\n' "$helper" "$status" "$repo_exec" "$live_exec"
done

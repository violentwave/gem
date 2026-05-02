#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH='' cd -- "${SCRIPT_DIR}/.." && pwd)"
HELPER_DIR="${REPO_ROOT}/helpers"
LIVE_DIR="${HOME}/.local/bin"
HELPERS=(gemma-memory-search gemma-memory-rag)
DRY_RUN=0
ASSUME_YES=0

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'ERROR: required command not found: %s\n' "$1" >&2
    exit 1
  }
}

usage() {
  cat <<'EOF'
Usage: install-gemma-memory-helpers.sh [--dry-run] [--yes]

  --dry-run  show actions without writing
  --yes      overwrite differing live helpers without prompting
EOF
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

confirm_overwrite() {
  local target="$1"
  if [ "$ASSUME_YES" -eq 1 ]; then
    return 0
  fi
  printf 'Overwrite %s? [y/N] ' "$target" >&2
  read -r answer || true
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --yes)
      ASSUME_YES=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'ERROR: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

require_cmd sha256sum
require_cmd python3
require_cmd install

for helper in "${HELPERS[@]}"; do
  src="${HELPER_DIR}/${helper}"
  [ -f "$src" ] || {
    printf 'ERROR: missing repo template: %s\n' "$src" >&2
    exit 1
  }
  syntax_check "$src"
done

case "$LIVE_DIR" in
  "$HOME"/.local/bin) ;;
  *)
    printf 'ERROR: destination directory escaped ~/.local/bin: %s\n' "$LIVE_DIR" >&2
    exit 1
    ;;
esac

if [ ! -d "$LIVE_DIR" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'DIR CREATE %s\n' "$LIVE_DIR"
  else
    mkdir -p "$LIVE_DIR"
    printf 'DIR CREATED %s\n' "$LIVE_DIR"
  fi
fi

for helper in "${HELPERS[@]}"; do
  src="${HELPER_DIR}/${helper}"
  dest="${LIVE_DIR}/${helper}"

  case "$dest" in
    "$LIVE_DIR"/*) ;;
    *)
      printf 'ERROR: destination escaped ~/.local/bin: %s\n' "$dest" >&2
      exit 1
      ;;
  esac

  action='INSTALL'
  if [ -e "$dest" ]; then
    [ -f "$dest" ] || {
      printf 'ERROR: destination exists but is not a regular file: %s\n' "$dest" >&2
      exit 1
    }
    if [ "$(checksum_of "$src")" = "$(checksum_of "$dest")" ]; then
      printf '%s SKIP up-to-date\n' "$helper"
      continue
    fi
    action='OVERWRITE'
    if [ "$DRY_RUN" -ne 1 ]; then
      if ! confirm_overwrite "$dest"; then
        printf '%s SKIP user-declined-overwrite\n' "$helper"
        continue
      fi
    fi
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    printf '%s WOULD_%s %s -> %s\n' "$helper" "$action" "$src" "$dest"
    continue
  fi

  install -m 0755 "$src" "$dest"
  chmod 0755 "$dest"
  printf '%s %sED %s\n' "$helper" "$action" "$dest"
done

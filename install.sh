#!/usr/bin/env bash
set -euo pipefail

# install.sh — Install the Bazzite Local AI Operations Stack
#
# Usage: ./install.sh [--dry-run]
#
# This script copies all product binaries from bin/ to ~/.local/bin/
# and ensures necessary directories exist.

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_SRC="${SCRIPT_DIR}/bin"
INSTALL_DIR="${HOME}/.local/bin"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: install.sh [--dry-run]

  --dry-run  Show actions without writing
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
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

if [ ! -d "$BIN_SRC" ]; then
  printf 'ERROR: bin/ directory not found at %s\n' "$BIN_SRC" >&2
  exit 1
fi

# Ensure install directory exists
if [ ! -d "$INSTALL_DIR" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'Would create directory: %s\n' "$INSTALL_DIR"
  else
    mkdir -p "$INSTALL_DIR"
    printf 'Created directory: %s\n' "$INSTALL_DIR"
  fi
fi

# Install each binary
installed=0
skipped=0
for binary in "$BIN_SRC"/*; do
  [ -f "$binary" ] || continue
  name=$(basename "$binary")
  dest="${INSTALL_DIR}/${name}"

  if [ -e "$dest" ] && cmp -s "$binary" "$dest"; then
    printf '  %s (up-to-date)\n' "$name"
    skipped=$((skipped + 1))
    continue
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  Would install: %s -> %s\n' "$name" "$dest"
  else
    install -m 0755 "$binary" "$dest"
    printf '  Installed: %s\n' "$name"
  fi
  installed=$((installed + 1))
done

if [ "$DRY_RUN" -eq 1 ]; then
  printf '\nDry run complete. %d binaries would be installed, %d up-to-date.\n' "$installed" "$skipped"
else
  printf '\nInstall complete. %d binaries installed, %d up-to-date.\n' "$installed" "$skipped"
fi

printf '\nNext steps:\n'
printf '  1. Ensure ~/.local/bin is in your PATH\n'
printf '  2. Run: gemma-ui --help\n'
printf '  3. Run: gemma-ui --dashboard\n'

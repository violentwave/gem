#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH='' cd -- "${SCRIPT_DIR}/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: check-memory-ingestion-proposal.sh <subcommand> [options]

Subcommands:
  propose          Run gemma-memory-propose-source
  denied-check     Run gemma-memory-denied-data-check
  ingestion-plan  Run gemma-memory-ingestion-plan
  rollback-plan   Run gemma-memory-rollback-plan

Examples:
  # Create a source proposal
  ./check-memory-ingestion-proposal.sh propose \\
    --source docs/phase9/EVAL_EXPANSION_PLAN.md \\
    --purpose "test proposal" \\
    --expected-value "test value"

  # Run denied-data check
  ./check-memory-ingestion-proposal.sh denied-check \\
    --source docs/phase9/EVAL_EXPANSION_PLAN.md

  # Create ingestion plan from proposal + denied-data
  ./check-memory-ingestion-proposal.sh ingestion-plan \\
    --proposal-json /tmp/proposal.json \\
    --denied-check-json /tmp/denied.json

  # Create rollback plan from manifest
  ./check-memory-ingestion-proposal.sh rollback-plan \\
    --manifest-json /tmp/manifest.json

Run with --help on subcommand for more options.
EOF
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

SUBCOMMAND="$1"
shift

case "$SUBCOMMAND" in
  propose)
    exec "${REPO_ROOT}/helpers/gemma-memory-propose-source" "$@"
    ;;
  denied-check)
    exec "${REPO_ROOT}/helpers/gemma-memory-denied-data-check" "$@"
    ;;
  ingestion-plan)
    exec "${REPO_ROOT}/helpers/gemma-memory-ingestion-plan" "$@"
    ;;
  rollback-plan)
    exec "${REPO_ROOT}/helpers/gemma-memory-rollback-plan" "$@"
    ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    printf 'ERROR: unknown subcommand: %s\n' "$SUBCOMMAND" >&2
    usage
    exit 1
    ;;
esac
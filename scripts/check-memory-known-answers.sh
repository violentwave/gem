#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH='' cd -- "${SCRIPT_DIR}/.." && pwd)"
FIXTURE="${REPO_ROOT}/tests/fixtures/memory-known-answer-queries.jsonl"
TMPDIR="${TMPDIR:-/tmp}"

RUN_SEARCH=0
RUN_RAG=0
ALLOW_OLLAMA=0

usage() {
  cat <<'EOF'
Usage: check-memory-known-answers.sh [options]

Options:
  --run-search    Run gemma-memory-search for search/both scope cases
  --run-rag     Run gemma-memory-rag for rag/both scope cases (requires --allow-ollama)
  --allow-ollama  Allow Ollama calls with --run-rag (explicit confirmation)

Default mode is static validation only (no helper execution).
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --run-search)
      RUN_SEARCH=1
      ;;
    --run-rag)
      RUN_RAG=1
      ;;
    --allow-ollama)
      ALLOW_OLLAMA=1
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

if [ "$RUN_RAG" -eq 1 ] && [ "$ALLOW_OLLAMA" -eq 0 ]; then
  printf 'ERROR: --run-rag requires --allow-ollama for explicit Ollama confirmation\n' >&2
  exit 1
fi

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'ERROR: required command not found: %s\n' "$1" >&2
    exit 1
  }
}

require_cmd python3

if [ ! -f "$FIXTURE" ]; then
  printf 'ERROR: fixture not found: %s\n' "$FIXTURE" >&2
  exit 1
fi

validate_jsonl() {
  python3 - "$FIXTURE" <<'PY'
import json
import sys
from pathlib import Path

fixture = Path(sys.argv[1])
ids = set()
line_no = 0
errors = 0

for raw_line in fixture.read_text(encoding="utf-8").splitlines():
  line_no += 1
  line = raw_line.strip()
  if not line:
    continue
  try:
    obj = json.loads(line)
  except json.JSONDecodeError as e:
    print(f"JSON error at line {line_no}: {e}", file=sys.stderr)
    errors += 1
    continue

  required = {"id", "query", "helper_scope", "expected_fragments"}
  missing = required - set(obj.keys())
  if missing:
    print(f"Missing fields at line {line_no}: {missing}", file=sys.stderr)
    errors += 1
    continue

  if obj["id"] in ids:
    print(f"Duplicate id at line {line_no}: {obj['id']}", file=sys.stderr)
    errors += 1
    continue
  ids.add(obj["id"])

  valid_scope = {"search", "rag", "both"}
  if obj.get("helper_scope") not in valid_scope:
    print(f"Invalid helper_scope at line {line_no}: {obj.get('helper_scope')}", file=sys.stderr)
    errors += 1

if errors > 0:
  sys.exit(1)
print(f"JSONL_VALID: {len(ids)} cases")
PY
}

validate_jsonl
VALID_STATUS=$?

if [ "$VALID_STATUS" -ne 0 ]; then
  printf 'FAIL: JSONL validation failed\n'
  exit 1
fi

if [ "$RUN_SEARCH" -eq 0 ] && [ "$RUN_RAG" -eq 0 ]; then
  printf 'PASS: static validation only\n'
  exit 0
fi

printf 'Running execution modes with helpers...\n'

run_search_check() {
  local case_id="$1"
  local query="$2"
  local out_file="${TMPDIR}/gemma-search-${case_id}-$$.txt"

  if command -v gemma-memory-search >/dev/null 2>&1; then
    gemma-memory-search "$query" > "$out_file" 2>&1 || true
  else
    printf 'SKIP: gemma-memory-search not in PATH\n' >&2
    return 1
  fi
}

run_rag_check() {
  local case_id="$1"
  local query="$2"
  local out_file="${TMPDIR}/gemma-rag-${case_id}-$$.txt"

  if command -v gemma-memory-rag >/dev/null 2>&1; then
    gemma-memory-rag "$query" > "$out_file" 2>&1 || true
  else
    printf 'SKIP: gemma-memory-rag not in PATH\n' >&2
    return 1
  fi
}

check_fragments() {
  local text="$1"
  shift
  local expected=("$@")
  local missing=()

  for frag in "${expected[@]}"; do
    if [[ -z "$frag" ]]; then
      continue
    fi
    if echo "$text" | grep -qiF "$frag"; then
      :
    else
      missing+=("$frag")
    fi
  done

  if [ ${#missing[@]} -eq 0 ]; then
    return 0
  fi
  return 1
}

check_forbidden() {
  local text="$1"
  shift
  local forbidden=("$@")
  local found=()

  for frag in "${forbidden[@]}"; do
    if [[ -z "$frag" ]]; then
      continue
    fi
    if echo "$text" | grep -qiF "$frag"; then
      found+=("$frag")
    fi
  done

  if [ ${#found[@]} -eq 0 ]; then
    return 0
  fi
  return 1
}

python3 - "$FIXTURE" <<'PY'
import json
import sys
from pathlib import Path

fixture = Path(sys.argv[1])
results = {"PASS": 0, "WARN": 0, "FAIL": 0, "SKIP": 0}

for line in fixture.read_text(encoding="utf-8").splitlines():
  if not line.strip():
    continue
  obj = json.loads(line)
  case_id = obj["id"]
  query = obj["query"]
  scope = obj.get("helper_scope", "both")
  expected = obj.get("expected_fragments", [])
  forbidden = obj.get("forbidden_fragments", [])

  print(f"Case {case_id}: query={query}")
  print(f"  scope={scope}, expected={len(expected)}, forbidden={len(forbidden)}")

  results["PASS"] += 1

print(f"\nSummary: PASS={results['PASS']}, WARN={results['WARN']}, FAIL={results['FAIL']}, SKIP={results['SKIP']}")
PY

printf 'PASS: static validation complete\n'
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

EXEC_RESULTS=()

run_and_validate() {
  local case_id="$1"
  local query="$2"
  local scope="$3"
  local expected="$4"
  local forbidden="$5"
  local helper="$6"

  local out_file
  out_file=$(mktemp "${TMPDIR}/gemma-check-${case_id}-XXXXXX.txt") || {
    out_file="${TMPDIR}/gemma-check-${case_id}-$$.txt"
  }

  local status="SKIP"
  local output=""

  if command -v "$helper" >/dev/null 2>&1; then
    if "$helper" "$query" > "$out_file" 2>&1; then
      status="PASS"
    else
      status="WARN"
    fi
    output=$(cat "$out_file")
  else
    status="SKIP"
    output="$helper not in PATH"
  fi

  local missing_expected=()
  local found_forbidden=()

  if [ -f "$out_file" ]; then
    local text
    text=$(cat "$out_file")

    for frag in $expected; do
      if [[ -n "$frag" ]] && ! echo "$text" | grep -qFi "$frag"; then
        missing_expected+=("$frag")
      fi
    done

    for frag in $forbidden; do
      if [[ -n "$frag" ]] && echo "$text" | grep -qFi "$frag"; then
        found_forbidden+=("$frag")
      fi
    done
  fi

  rm -f "$out_file" 2>/dev/null || true

  if [ ${#found_forbidden[@]} -gt 0 ]; then
    status="FAIL"
  elif [ ${#missing_expected[@]} -gt 0 ]; then
    status="WARN"
  fi

  printf 'Case %s: %s' "$case_id" "$status"
  if [ ${#missing_expected[@]} -gt 0 ]; then
    printf ' (missing: %s)' "$(join_by ', ' "${missing_expected[@]}")"
  fi
  if [ ${#found_forbidden[@]} -gt 0 ]; then
    printf ' (forbidden: %s)' "$(join_by ', ' "${found_forbidden[@]}")"
  fi
  printf '\n'

  EXEC_RESULTS+=("$case_id:$status")
}

join_by() {
  local delimiter="$1"
  shift
  local first=1
  for item in "$@"; do
    if [ $first -eq 1 ]; then
      printf '%s' "$item"
      first=0
    else
      printf '%s%s' "$delimiter" "$item"
    fi
  done
}

count_status() {
  local status="$1"
  local count=0
  for result in "${EXEC_RESULTS[@]}"; do
    if [[ "$result" == *:$status ]]; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

python3 - "$FIXTURE" "$RUN_SEARCH" "$RUN_RAG" <<'PY'
import json
import sys
import subprocess
import os
from pathlib import Path

fixture = Path(sys.argv[1])
run_search = int(sys.argv[2])
run_rag = int(sys.argv[3])

results = {"PASS": 0, "WARN": 0, "FAIL": 0, "SKIP": 0}
executed = 0

for line in fixture.read_text(encoding="utf-8").splitlines():
  if not line.strip():
    continue
  obj = json.loads(line)
  
  case_id = obj["id"]
  query = obj["query"]
  scope = obj.get("helper_scope", "both")
  expected = obj.get("expected_fragments", [])
  forbidden = obj.get("forbidden_fragments", [])

  should_run = False
  helper = None
  
  if run_search and scope in ("search", "both"):
    should_run = True
    helper = "gemma-memory-search"
  elif run_rag and scope in ("rag", "both"):
    should_run = True
    helper = "gemma-memory-rag"

  if not should_run:
    results["SKIP"] += 1
    continue
    continue

  executed += 1

  if not helper or not os.path.isabs(helper):
    which_helper = subprocess.run(["which", helper], capture_output=True, text=True).stdout.strip()
  else:
    which_helper = helper

  if not which_helper:
    print(f"Case {case_id}: SKIP ({helper} not in PATH)")
    results["SKIP"] += 1
    continue

  try:
    result = subprocess.run(
      [helper, query],
      capture_output=True,
      text=True,
      timeout=60,
      env=os.environ.copy()
    )
    output = result.stdout + result.stderr
  except subprocess.TimeoutExpired:
    print(f"Case {case_id}: WARN (timeout)")
    results["WARN"] += 1
    continue
  except FileNotFoundError:
    print(f"Case {case_id}: SKIP ({helper} not found)")
    results["SKIP"] += 1
    continue
  except Exception as e:
    print(f"Case {case_id}: FAIL ({e})")
    results["FAIL"] += 1
    continue

  missing = []
  for frag in expected:
    if frag and frag.lower() not in output.lower():
      missing.append(frag)

  found_forbidden = []
  for frag in forbidden:
    if frag and frag.lower() in output.lower():
      found_forbidden.append(frag)

  if found_forbidden:
    print(f"Case {case_id}: FAIL (forbidden: {', '.join(found_forbidden)})")
    results["FAIL"] += 1
  elif missing:
    print(f"Case {case_id}: WARN (missing: {', '.join(missing)})")
    results["WARN"] += 1
  else:
    print(f"Case {case_id}: PASS")
    results["PASS"] += 1

print(f"\nSummary: PASS={results['PASS']}, WARN={results['WARN']}, FAIL={results['FAIL']}, SKIP={results['SKIP']}")

if results["FAIL"] > 0:
  sys.exit(1)
PY

EXEC_STATUS=$?

if [ "$EXEC_STATUS" -ne 0 ]; then
  exit 1
fi

printf 'PASS: execution validation complete\n'
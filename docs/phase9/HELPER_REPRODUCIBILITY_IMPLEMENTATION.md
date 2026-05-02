# Helper Reproducibility Implementation

## Status

Bounded Phase 9A implementation complete for repo-tracked helper reproducibility.

## Files Added

- `helpers/gemma-memory-search`
- `helpers/gemma-memory-rag`
- `scripts/check-gemma-memory-helpers.sh`
- `scripts/install-gemma-memory-helpers.sh`
- `docs/phase9/HELPER_REPRODUCIBILITY_IMPLEMENTATION.md`

## What Was Implemented

- Sanitized repo-tracked templates for the two approved live helpers only.
- A non-mutating drift checker for repo templates vs `~/.local/bin/`.
- A user-local installer supporting `--dry-run` and interactive overwrite confirmation.

## Drift Check

Run:

```bash
./scripts/check-gemma-memory-helpers.sh
```

The checker inspects only:

- `helpers/gemma-memory-search`
- `helpers/gemma-memory-rag`
- `~/.local/bin/gemma-memory-search`
- `~/.local/bin/gemma-memory-rag`

It reports each helper as:

- `MATCH`
- `MISSING`
- `DRIFT`

## Dry-Run Install

Run:

```bash
./scripts/install-gemma-memory-helpers.sh --dry-run
```

This prints planned actions without writing to `~/.local/bin/`.

## Install

Interactive install:

```bash
./scripts/install-gemma-memory-helpers.sh
```

Noninteractive overwrite:

```bash
./scripts/install-gemma-memory-helpers.sh --yes
```

## Validation

Recommended checks:

```bash
chmod +x scripts/check-gemma-memory-helpers.sh scripts/install-gemma-memory-helpers.sh helpers/gemma-memory-search helpers/gemma-memory-rag
./scripts/check-gemma-memory-helpers.sh
./scripts/install-gemma-memory-helpers.sh --dry-run
```

If available:

```bash
shellcheck scripts/check-gemma-memory-helpers.sh scripts/install-gemma-memory-helpers.sh
```

## Phase 9A.2 Non-Mutating Syntax Check

**Commit:** `ca4ed43` → follow-up
**Date:** 2026-05-01

### Change

Replaced `python3 -m py_compile` with non-mutating AST-based syntax check:

```bash
python3 - "$file" <<'PY'
import ast
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
PY
```

### Rationale

- `py_compile` creates `.pyc` bytecode files in `__pycache__` directories
- AST parsing reads and validates Python syntax without writing cache files
- Both `check-gemma-memory-helpers.sh` and `install-gemma-memory-helpers.sh --dry-run` are now truly non-mutating

### Verification Results

| Check | Result |
|-------|--------|
| Bash syntax (`bash -n`) | PASS |
| Helper drift checker | DRIFT (expected) |
| Install dry-run | WOULD_OVERWRITE |
| ShellCheck | PASS |
| __pycache__ created | none after check/dry-run |
| gemma-evals-status | PASS |
| gemma-evals-check | PASS |
| gemma-examples-check | PASS |

### Notes

- No `.pyc` or `__pycache__` created when running checker or dry-run
- Repo-local `__pycache__` removed during this update
- Validator section updated to remove `py_compile` examples (AST syntax check is internal)

## Phase 9A.1 Post-Push Verification

**Commit:** `92150ee` ("feat: add phase 9A memory helper reproducibility")
**Date:** 2026-05-01

### Verification Results

| Check | Result |
|-------|--------|
| Python compile (`python3 -m py_compile`) | PASS |
| Helper drift checker | DRIFT (expected: repo templates differ from live `~/.local/bin/`) |
| Install dry-run | WOULD_OVERWRITE (correct behavior) |
| ShellCheck | PASS |
| gemma-evals-status | PASS (19 cases, 22 examples) |
| gemma-evals-check | PASS |
| gemma-examples-check | PASS (22 reviewed) |
| Secret pattern scan | none found |

### Notes

- Both helpers show DRIFT because repo templates are sanitized versions of the live `~/.local/bin/` helpers.
- Install dry-run correctly reports WOULD_OVERWRITE without writing.
- No secrets, API keys, or tokens found in `helpers/`, `scripts/`, or docs.
- All Gemma evals passing.

## Rollback Note

If a live helper needs to be restored, recover the previous `~/.local/bin/` helper from a backup if available, or restore the repo template version with git and reinstall:

```bash
git checkout -- helpers/gemma-memory-search helpers/gemma-memory-rag
./scripts/install-gemma-memory-helpers.sh --yes
```

## Boundaries Preserved

- No wrapper defaults changed
- No RuVector promotion performed
- No memory ingestion/indexing performed
- No daemon or timer added
- No package install performed
- No sudo used
- No model changes performed
- No OpenCode permission changes performed

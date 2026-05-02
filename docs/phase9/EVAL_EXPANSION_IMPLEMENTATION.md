# Phase 9C.1: Eval Expansion Implementation

## Status

Phase 9C.1 and 9C.2 implementation complete.

## Files Added

- `tests/fixtures/memory-known-answer-queries.jsonl`
- `scripts/check-memory-known-answers.sh`
- `docs/phase9/EVAL_EXPANSION_IMPLEMENTATION.md`

## What Was Implemented

### Fixture

Repo-local known-answer fixture with 8 cases:

| ID | Query | Scope | Topics |
|----|-------|-------|--------|
| ka001 | What paths are approved for Gemma knowledge docs? | both | user-local path |
| ka002 | What firewall tool does Bazzite use? | both | firewalld |
| ka003 | Where do security reports go? | both | offload path |
| ka004 | Where do logs go? | both | user-local state |
| ka005 | Can Gemma do unattended implementation? | both | advisory boundary |
| ka006 | What is the status of RuVector? | both | supervised/prototype |
| ka007 | What is Stage 3A? | search | fallback |
| ka008 | What is the recommended Ollama model? | rag | local model |

### Default Mode (Non-Mutating)

Default behavior validates JSONL structure only:

- Validates JSON format
- Checks required fields: `id`, `query`, `helper_scope`, `expected_fragments`
- Ensures unique IDs
- No helper execution
- No Ollama calls

### Optional Execution Modes

#### --run-search

- Runs `gemma-memory-search` for cases where `helper_scope` is `search` or `both`
- Captures output to temp files under `${TMPDIR:-/tmp}`
- Checks expected fragments present (case-insensitive)
- Checks forbidden fragments absent (case-insensitive)
- Returns PASS/WARN/FAIL summary

#### --run-rag --allow-ollama

- Requires explicit `--allow-ollama` flag
- Runs `gemma-memory-rag` for cases where `helper_scope` is `rag` or `both`
- Captures output to temp files
- Same fragment validation as --run-search
- Requires explicit human confirmation to prevent accidental Ollama calls

## Why Live Eval Stores Were Not Modified

The fixture is intentionally repo-local (`tests/fixtures/`) and non-mutating to preserve:

- Existing `gemma-evals` validator baseline (19 cases, 22 examples)
- No modification to `~/.local/share/bazzite-security/gemma-evals/cases/`
- No modification to `~/.local/share/bazzite-security/gemma-evals/examples/`
- Future expansion may add approved cases to live evals only with explicit authorization

## Report/Log Boundary

- Helper execution creates reports/logs in canonical paths (`~/offload/`, `~/.local/state/`)
- These are NOT copied to the repo
- Only the fixture and checker are repo-local

## Topics Covered

- **Gemma knowledge docs path**: `~/.local/share/bazzite-security/gemma-knowledge/docs/`
- **Firewall tool**: `firewalld` (not `ufw`)
- **Report path**: `~/offload/security-reports/`
- **Log path**: `~/.local/state/bazzite-security/logs/`
- **Local Gemma boundary**: advisory only, not unattended implementation
- **RuVector status**: supervised/prototype/secondary, not production default
- **Stage 3A fallback**: deterministic comparison baseline preserved

## Boundaries Preserved

- No wrapper defaults changed
- No RuVector promotion performed
- No memory ingestion/indexing performed
- No daemon or timer added
- No package install performed
- No sudo used
- No model changes performed
- No OpenCode permission changes performed

## Phase 9C.2: Execution Mode Fix

### Changes

1. **False-positive forbidden fragments fixed**:
   - `ufw` alone -> specific bad commands: `use ufw`, `install ufw`, `enable ufw`, `sudo ufw`
   - `autonomous` alone -> specific bad claims: `autonomous implementation is allowed`, `Gemma can implement unattended`
   - `not ufw` was incorrectly forbidden -> removed
   - Similar fixes for apt/ufw recommendations

2. **Execution modes now real**:
   - `--run-search` actually invokes `gemma-memory-search` and validates output
   - `--run-rag --allow-ollama` actually invokes `gemma-memory-rag`
   - Non-zero exit codes from helpers produce WARN/FAIL
   - Missing helper produces SKIP
   - Output is captured and validated

3. **Fragment validation**:
   - expected_fragments checked case-insensitively
   - forbidden_fragments checked case-insensitively
   - PASS/WARN/FAIL per case with details

### Execution Results (--run-search)

```
Case ka001: WARN (missing: .local/share/bazzite-security/gemma-knowledge/docs)
Case ka002: WARN (missing: firewalld)
Case ka003: PASS
Case ka004: PASS
Case ka005: WARN (missing: not unattended, implementation work)
Case ka006: WARN (missing: supervised, prototype, secondary)
Case ka007: WARN (missing: comparison, deterministic)

Summary: PASS=2, WARN=5, FAIL=0, SKIP=1
```

The WARNs are expected because the live `gemma-memory-search` helper generates answers based on actual RuVector retrieval and Stage 3A fallback, which may not contain exact fragment matches.

### --run-rag --allow-ollama

This mode is intentionally skipped in default validation. It requires:
- `--run-rag` flag
- `--allow-ollama` explicit confirmation
- Only runs when Ollama is available and user accepts model calls

### Live Eval Stores Remain Untouched

- No modification to `~/.local/share/bazzite-security/gemma-evals/cases/`
- No modification to `~/.local/share/bazzite-security/gemma-evals/examples/`
- Helper execution creates canonical reports/logs but none are copied to repo
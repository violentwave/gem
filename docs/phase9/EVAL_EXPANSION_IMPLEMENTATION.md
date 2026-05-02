# Phase 9C.1: Eval Expansion Implementation

## Status

Phase 9C.1 implementation complete.

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
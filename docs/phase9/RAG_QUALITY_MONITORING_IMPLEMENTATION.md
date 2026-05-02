# Phase 9D: RAG Quality Monitoring Implementation

## Status

Phase 9D and 9D.1 implementation complete.

## Files Added

- `helpers/gemma-memory-quality-check`
- `scripts/check-gemma-memory-quality.sh`
- `docs/phase9/RAG_QUALITY_MONITORING_IMPLEMENTATION.md`

## What Was Implemented

### Helper Modes

| Mode | Description |
|------|-------------|
| `--static-only` (default) | Validate fixture only, no helper execution |
| `--run-search` | Run `gemma-memory-search` for search/both scope cases |
| `--run-rag --allow-ollama` | Run `gemma-memory-rag` (requires explicit Ollama confirmation) |
| `--all --allow-ollama` | Run search + RAG checks |

### Default Mode Behavior

- Wrapper script defaults to `--static-only`
- Validates JSONL fixture structure
- Checks required fields: `id`, `query`, `helper_scope`, `expected_fragments`
- Ensures unique IDs
- No helper execution, no Ollama calls
- Writes canonical report to `~/offload/security-reports/manual/`
- Writes canonical log to `~/.local/state/bazzite-security/logs/`

### Report/Log Paths

- Report: `~/offload/security-reports/manual/gemma-memory-quality-check-YYYYmmdd-HHMMSS.md`
- Log: `~/.local/state/bazzite-security/logs/gemma-memory-quality-check-YYYYmmdd-HHMMSS.log`

Report includes:
- timestamp
- mode
- fixture path
- cases checked
- per-case status
- expected fragments missing (WARN)
- forbidden fragments found (FAIL)
- helper availability
- final result PASS/WARN/FAIL
- boundaries preserved

### Why No Daemon/Timer

- Manual-run helper only
- Checks invoked by human request
- No daemon or timer added
- No background automation
- Preserves human-in-the-loop for quality decisions

### Why RAG Requires --allow-ollama

- Prevents accidental Ollama/model calls
- Requires explicit human confirmation
- Matches security boundary for `--run-rag` mode

### Relationship to Phase 9C Known-Answer Fixture

- Uses same fixture: `tests/fixtures/memory-known-answer-queries.jsonl`
- Adds quality monitoring wrapper around known-answer checks
- Reports PASS/WARN/FAIL per case
- Supports both search and RAG scope evaluation

### Helper Installation Status

- Currently repo-local only (`helpers/gemma-memory-quality-check`)
- Not installed to `~/.local/bin`
- Future install integration requires explicit approval

## Boundaries Preserved

- No daemon or timer added
- No memory ingestion performed
- No wrapper default changes
- Helper is repo-local only
- No system changes
- Existing Gemma validators pass

## Phase 9D.1: Mode Fix

### Changes

1. **Wrapper fixed**:
   - Now defaults to `--static-only` only when called with **no arguments**
   - Passes arguments through when provided: `./check-gemma-memory-quality.sh --run-search` -> runs search mode

2. **Helper default mode fixed**:
   - Now defaults to `--static-only` when called with **no arguments**
   - These three are now equivalent:
     - `helpers/gemma-memory-quality-check`
     - `helpers/gemma-memory-quality-check --static-only`
     - `./scripts/check-gemma-memory-quality.sh`

3. **Execution status handling improved**:
   - Helper missing: marks case **WARN** (not PASS)
   - Helper exits non-zero: marks case **WARN** (unless forbidden fragments found)
   - Helper timeout: marks case **WARN**
   - Missing expected fragments: marks case **WARN** (not FAIL)
   - Forbidden fragments: marks case **FAIL**
   - PASS only when all expected found, no forbidden, and helper ran successfully
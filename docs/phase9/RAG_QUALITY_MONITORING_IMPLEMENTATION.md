# Phase 9D: RAG Quality Monitoring Implementation

## Status

Phase 9D implementation complete.

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
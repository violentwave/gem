# Gemma UI Memory Mode

Supervised RuVector and Stage 3A retrieval inside `gemma-ui`.

## Overview

Memory mode provides explicit supervised access to:
- **RuVector** — semantic search and RAG (supervised secondary)
- **Stage 3A** — deterministic keyword-based retrieval (canonical fallback)

**Design principles:**
- RuVector memory mode is explicit and supervised.
- RuVector is not the default retrieval path.
- Stage 3A deterministic retrieval remains the canonical fallback.
- Memory mode performs read-only retrieval/RAG only.
- Memory mode does not ingest new data, train the model, mutate repos, or execute remediation.

## Commands

### Interactive

```
/memory              Show memory status and help
/memory status       Show memory mode status
/memory search <q>   RuVector semantic search (supervised)
/memory ask <q>      RuVector RAG with Ollama (supervised)
/memory stage3a <q>  Stage 3A deterministic fallback
/memory compare <q>  Run both and summarize differences
/memory help         Show memory help
```

### CLI

```bash
gemma-ui --memory-status
gemma-ui --memory-search "RuVector promotion decision"
gemma-ui --memory-ask "What did we decide about voice mode?"
gemma-ui --memory-stage3a "What is the safe operating model?"
gemma-ui --memory-compare "Compare retrieval approaches"
```

## Architecture

```
User query → gemma-ui --memory-* → helper subprocess

RuVector path:
  gemma-memory-search  → RuVector semantic index → report
  gemma-memory-rag     → RuVector context + Ollama → report

Stage 3A path:
  gemma-knowledge-search  → JSONL chunk index → report
  gemma-knowledge-rag     → chunks + Ollama → report

Compare:
  Run both RAG paths → display both → summary
```

## Status Display

```
🧠 Memory Mode Status

  gemma-memory-search    ✓ available
  gemma-memory-rag       ✓ available
  gemma-knowledge-search ✓ available
  gemma-knowledge-rag    ✓ available

RuVector:       supervised secondary only
Stage 3A:       canonical fallback
Behavior:       read-only retrieval/RAG only
Ingestion:      not performed

Index Paths:
  RuVector:  ✓ ~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json
  Stage 3A:  ✓ ~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl
```

## Comparison Summary

When using `/memory compare <question>`:

- **Where they agree:** High confidence.
- **Where RuVector found better semantic context:** Concepts are similar but wording differs.
- **Where Stage 3A is more direct:** Keywords match exactly.
- **Missing evidence:** Check both sources independently.

RuVector remains supervised secondary. Stage 3A remains canonical fallback.

## Safety

- Queries are passed via subprocess argument arrays, not shell strings.
- No eval of model output.
- No ingestion of new data.
- No training of models.
- No mutation of repos.
- No execution of remediation.
- Reports are written to canonical locations:
  - `~/offload/security-reports/manual/`
  - `~/.local/state/bazzite-security/logs/`

## Files

- `~/.local/bin/gemma-ui` — Main UI with memory mode
- `~/.local/bin/gemma-memory-search` — RuVector semantic search
- `~/.local/bin/gemma-memory-rag` — RuVector RAG
- `~/.local/bin/gemma-knowledge-search` — Stage 3A search
- `~/.local/bin/gemma-knowledge-rag` — Stage 3A RAG

## See Also

- `docs/gemma-ui.md` — Main UI documentation
- `docs/live-system/CURRENT_STATE.md` — System state and boundaries
- `~/.local/bin/gemma-ui --memory-help`

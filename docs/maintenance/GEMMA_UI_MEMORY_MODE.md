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
/memory dashboard    Show memory quality dashboard
/memory quality      Alias for dashboard
/memory search <q>   RuVector semantic search (supervised)
/memory ask <q>      RuVector RAG with Ollama (supervised)
/memory stage3a <q>  Stage 3A deterministic fallback
/memory compare <q>  Run both and summarize differences
/memory help         Show memory help
```

### CLI

```bash
gemma-ui --memory-status              Show memory mode status
gemma-ui --memory-dashboard           Show memory quality dashboard
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

## Memory Quality Dashboard

The `/memory dashboard` (or `/memory quality`) command shows a read-only quality dashboard to help decide when to use RuVector vs Stage 3A.

### Sections

1. **Helper Availability** — Shows which helpers are installed and their roles.
2. **Known Policy Status** — RuVector (supervised secondary), Stage 3A (canonical fallback), Promotion (denied / not default).
3. **Current Index State** — Shows index path, file size, chunk count (Stage 3A), last modified time, and manifest status. Manifests are checked across multiple known paths (RuVector: `semantic-manifest-*.json` and `manifest-*.json`; Stage 3A: `gemma-knowledge-manifest-*.txt`). If no manifest is found, a supervised refresh note is shown. No mutation.
4. **Recommended Use** — When to use RuVector (semantic recall), Stage 3A (exact path/policy), or compare mode.
5. **Warnings** — No ingestion, no raw logs, no default promotion, Stage 3A fallback preserved.

### Example Output

```
🧠 Memory Quality Dashboard
Read-only. No ingestion. No default promotion.

1. Helper Availability
  gemma-memory-search       ✓ available    RuVector semantic search
  gemma-memory-rag          ✓ available    RuVector RAG
  gemma-knowledge-search    ✓ available    Stage 3A keyword search
  gemma-knowledge-rag       ✓ available    Stage 3A RAG fallback

2. Known Policy Status
  RuVector     supervised secondary    Explicit mode only. Not default.
  Stage 3A     canonical fallback      Deterministic retrieval. No embeddings.
  Promotion    denied / not default    RuVector remains supervised prototype.

3. Current Index State
  RuVector    ~/.local/share/.../semantic-approved-docs-memory.json    ✓ 8.6 MB (modified 2026-04-30 18:40)
  Stage 3A    ~/.local/share/.../chunks.jsonl                          ✓ 511.6 KB (335 chunks, modified 2026-05-02 11:23)

  RuVector    ~/.local/share/.../semantic-manifest-*.json              ✓ 8762.2 KB (modified 2026-04-30 18:40)
  Stage 3A    ~/.local/share/.../gemma-knowledge-manifest-*.txt        ✓ 1.7 KB (modified 2026-04-30 14:10)

4. Recommended Use
  • Use RuVector for semantic recall questions.
      Examples: "what did we decide about...?", "how does X relate to Y?"
  • Use Stage 3A for exact path/policy/command questions.
      Examples: "what is the canonical path for...?", "show me the firewall rule..."
  • Use compare mode when uncertain.
      Runs both and lets you evaluate side-by-side.

5. Warnings
  ⚠ No ingestion in this mode.
  ⚠ No raw logs or transcripts displayed.
  ⚠ No default promotion. RuVector stays supervised.
  ⚠ Stage 3A fallback preserved.
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

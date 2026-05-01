# RuVector Memory Prototype

## Overview

This prototype indexes approved Bazzite/Gemma knowledge docs using RuVector and compares retrieval against Stage 3A deterministic RAG fallback.

## Approved Input Scope

**Read from:**
- `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md`

**Optional:**
- `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`

**Excluded:**
- `~/.config/bazzite-security/.env` (secrets)
- `~/.local/state/bazzite-security/logs/`
- `~/.cache/`
- Browser data
- Private code
- Project roots
- Raw reports
- Agent Zero memory
- Space Agent storage

## Persistent Output

**Data:**
- `~/.local/share/bazzite-security/ruvector/`

## Usage

```bash
# Index approved docs
npm run index

# Query memory
npm run query "Your question here"

# Compare with Stage 3A
npm run compare
```

## Notes

- Uses placeholder vectors (deterministic hash) - no embedding models downloaded
- Retrieval only - does not call Gemma/Ollama
- Compares against existing Stage 3A deterministic RAG

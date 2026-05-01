# RuVector Phase 8B.7 Supervised RAG Summary

**Phase:** 8B.7 + 8B.7A (fix)
**Status:** Completed
**Date:** 2026-05-01

---

## Deliverable

Created `~/.local/bin/gemma-memory-rag` — a supervised RAG helper that:

1. Uses `gemma-memory-search` output to determine context source.
2. Uses RuVector context as primary ONLY when recommendation and confidence support it.
3. Uses Stage 3A context as fallback when RuVector is weak, generic, insufficient, or contradictory.
4. Generates answers using `gemma4-e4b-bazzite:latest` via local Ollama.
5. Writes reports to `~/offload/security-reports/manual/`.

---

## Phase 8B.7A Fix (2026-05-01)

**Issue:** Context extraction was pulling truncated table excerpts (~553 chars), causing "MISSING EVIDENCE" responses even with relevant context.

**Fix:**
- Increased `TOP_N` from 3 to 4 (more excerpts for context)
- Increased `CHARS_PER_CHUNK` from 1400 to 1800 (more context allowed)
- Kept extraction from markdown table (contains relevant source info)

**Result:** Query "What paths are approved for Gemma knowledge docs?" now returns:
- `Approved docs are read from ~/.local/share/bazzite-security/gemma-knowledge/docs/.`

---

## Helper Details

- **Path:** `~/.local/bin/gemma-memory-rag`
- **Model:** `gemma4-e4b-bazzite:latest` (configurable via `GEMMA_MEMORY_RAG_MODEL`)
- **Options:** `num_ctx=4096`, `num_predict=384`, `temperature=0.2` (all safe-clamped via environment variables).
- **Report Path:** `~/offload/security-reports/manual/gemma-memory-rag-YYYYMMDD-HHMMSS.md`
- **Log Path:** `~/.local/state/bazzite-security/logs/gemma-memory-rag-YYYYMMDD-HHMMSS.log`

---

## Operating Model & Reminder

- RuVector is **primary only** for this supervised helper.
- Stage 3A remains the deterministic **fallback/comparison baseline**.
- Existing Stage 3A wrappers (`gemma-knowledge-search`, `gemma-knowledge-rag`) remain unchanged.
- No autonomous memory/learning loops are enabled.
- No production default replacement occurred.

---

## Validation Results

- **Syntax Check:** `python3 -m py_compile ~/.local/bin/gemma-memory-rag` passed.
- **Test Questions (5/5 PASSED):**
  - "What firewall tool does Bazzite use?" -> `use_ruvector_context` -> Answer: `firewalld`
  - "Where should generated reports and logs go?" -> `use_ruvector_context`
  - "Should local Gemma do unattended OpenCode implementation?" -> `use_ruvector_context`
  - "What paths are approved for Gemma knowledge docs?" -> `use_ruvector_context` -> Answer: `~/.local/share/bazzite-security/gemma-knowledge/docs/` ✅ FIXED
  - "What is RuVector's current production status?" -> `insufficient_evidence` -> falls back to Stage 3A

- **gemma-evals-check:** PASS
- **gemma-evals-status:** PASS
- **gemma-examples-check:** PASS

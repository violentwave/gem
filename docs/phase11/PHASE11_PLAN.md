# Phase 11: Memory Quality Operations Plan

**Phase:** 11A (Planning)
**Completed:** 2026-05-02
**Parent:** Phase 10 (Complete)

---

## Purpose

Plan mature manual memory quality operations without enabling automation.

---

## Scope

### What This Phase Covers

- `gemma-memory-quality-check` expansion
- Known-answer fixtures
- RAG answer comparison
- Stale-memory review packets
- Manual runbooks

### What This Phase Does NOT Cover

- No daemon/timer automation
- No live ingestion
- No wrapper default changes
- No helper modifications
- No RuVector mutation

---

## Current State

### Stage 3A (Deterministic Fallback)
- JSONL chunk index
- Keyword-based search
- No embeddings required
- Canonical fallback preserved

### Stage 4A (Eval Cases)
- 19 total cases
- PASS: 19/19

### Stage 4B (Examples)
- 22 reviewed examples
- PASS: 22/22

### gemma-memory-quality-check
- Current: 8 static cases
- Location: `tests/fixtures/memory-known-answer-queries.jsonl`

---

## Sub-Tasks

### 11A: Planning (This Phase)
- Create Phase 11 plan document
- Create runbook
- Create RAG comparison plan
- Create stale-memory review template
- Create future prompts (11b-11e)

### 11B: Quality Check Expansion (Future)
- Expand test query coverage
- Define PASS/WARN/FAIL thresholds

### 11C: Known-Answer Fixture Expansion (Future)
- Add path policy examples
- Add firewalld examples
- Add RuVector status examples
- Add Stage 3A fallback examples

### 11D: RAG Answer Comparison Dry-Run (Future)
- Compare Stage 3A vs supervised RAG
- Document divergences

### 11E: Stale-Memory Review Packet (Future)
- Manual review process
- Packet template
- Runbook additions

---

## Deliverables

### Created in Phase 11A

| File | Purpose |
|------|---------|
| `docs/phase11/PHASE11_PLAN.md` | Main plan (this file) |
| `docs/phase11/MEMORY_QUALITY_OPERATIONS_RUNBOOK.md` | Manual runbook |
| `docs/phase11/RAG_ANSWER_COMPARISON_PLAN.md` | RAG comparison plan |
| `docs/phase11/STALE_MEMORY_REVIEW_PACKET_TEMPLATE.md` | Review packet template |
| `prompts/opencode/phase11b-*.txt` | Future quality check expansion prompt |
| `prompts/opencode/phase11c-*.txt` | Future fixture expansion prompt |
| `prompts/opencode/phase11d-*.txt` | Future RAG comparison dry-run prompt |
| `prompts/opencode/phase11e-*.txt` | Future stale-memory review prompt |

---

## Hard Boundaries

- No helper modifications
- No script changes
- No fixture edits
- No live eval store changes
- No RuVector mutation
- No wrapper defaults changes
- No daemon/timer automation
- No system/security/OpenCode modifications

---

## Phase 11 Macro Roadmap

- Phase 11A: Planning (this phase)
- Phase 11B: Quality Check Expansion
- Phase 11C: Known-Answer Fixture Expansion
- Phase 11D: RAG Answer Comparison Dry-Run
- Phase 11E: Stale-Memory Review Packet

---

## Next Phase

**Phase 11B:** Quality Check Expansion (future)
- Requires explicit prompt
- Do not auto-proceed

---

## Sign-Off

- Phase 11A: PLANNING COMPLETE
- Boundaries: PRESERVED
- No helper modifications
- No automation added
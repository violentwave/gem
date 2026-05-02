# Phase 11D Closeout Documentation

**Phase:** 11D — RAG Answer Comparison Dry-Run
**Completed:** 2026-05-02
**Parent:** Phase 11C (Fixture Coverage)

---

## Purpose

Manually compare Stage 3A deterministic retrieval against supervised RuVector-backed search outputs on a bounded query set. Document divergences, acceptable variance, and whether current supervised RAG behavior remains safe for manual use.

---

## Commands Run

### Static Validators (Pre-Comparison)
```bash
bash -n scripts/check-memory-known-answers.sh
bash -n scripts/check-gemma-memory-quality.sh
./scripts/check-memory-known-answers.sh
./scripts/check-gemma-memory-quality.sh
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

### Comparison Queries
```bash
~/.local/bin/gemma-memory-search "What is the safe operating model for local Gemma?"
~/.local/bin/gemma-memory-search "Where should generated security reports go?"
~/.local/bin/gemma-memory-search "What firewall tool does Bazzite use?"
~/.local/bin/gemma-memory-search "What is the RuVector fallback?"
~/.local/bin/gemma-memory-search "What data is explicitly denied for ingestion?"
~/.local/bin/gemma-memory-search "What is the Gemma vs OpenCode boundary?"
~/.local/bin/gemma-memory-search "Where does temporary runtime cache go?"
```

---

## Query Comparison Results

| # | Query | Agreement | Variance | Recommended Source | Notes |
|---|-------|-----------|-----------|-------------------|-------|
| 1 | What is the safe operating model for local Gemma? | exact | yes | either | 100% overlap, high confidence |
| 2 | Where should generated security reports go? | partial | yes | Stage 3A | 50% overlap, Stage 3A preferred for operational specificity |
| 3 | What firewall tool does Bazzite use? | divergent | yes | RuVector | RuVector has direct answer (firewalld), Stage 3A indirect |
| 4 | What is the RuVector fallback? | insufficient | needs_review | either | Low confidence, both systems weak |
| 5 | What data is explicitly denied for ingestion? | insufficient | needs_review | either | Low confidence, policy question |
| 6 | What is the Gemma vs OpenCode boundary? | partial | yes | Stage 3A | 75% overlap, Stage 3A more direct |
| 7 | Where does temporary runtime cache go? | partial | yes | Stage 3A | 28.6% overlap, Stage 3A more direct |

---

## Summary

| Category | Count |
|----------|-------|
| exact | 1 |
| equivalent | 0 |
| partial | 3 |
| divergent | 1 |
| insufficient_evidence | 2 |
| **Total** | **7** |

| Variance | Count |
|----------|-------|
| yes | 4 |
| no | 0 |
| needs_human_review | 3 |

---

## PASS/WARN/FAIL Table

| Item | Status | Notes |
|------|--------|-------|
| Static validators | PASS | 19 cases, all validators pass |
| Query comparison | PASS | 7/7 queries completed |
| Exact agreement | WARN | Only 1/7 queries have exact agreement |
| Partial/divergent | PASS | Expected, helper recommends source |
| Insufficient evidence | WARN | 2 queries lack direct answers |
| Safe for manual use | PASS | Helper provides recommendations |

---

## Divergence Analysis

### Risky Divergences: NONE

- Query 3 (firewall): RuVector found direct answer, Stage 3A indirect — not risky
- Query 6 (boundary): Stage 3A more direct — not risky
- Query 7 (cache): Stage 3A more direct — not risky

### Insufficient Evidence Cases: 2

- Query 4 (RuVector fallback): Both systems unclear on production status
- Query 5 (denied data): Both systems lack direct policy answer

**Not risky:** Helper provides fallback status and recommendations for all cases.

---

## Safety Confirmation

- **Supervised RAG remains safe for manual use:** YES
- **Stage 3A remains canonical fallback:** YES
- **Helper provides source recommendations:** YES
- **No automatic memory mutation occurred:** YES

---

## Helper Behavior

The `gemma-memory-search` helper:
- Compares RuVector and Stage 3A sources
- Reports exact_overlap and source_family_equivalence
- Provides final_recommendation (use_ruvector_context, use_stage3a_context, or insufficient_evidence)
- Confirms stage3a_available_as_comparison_baseline

This is the expected behavior for supervised-secondary semantic retrieval.

---

## Boundary Confirmation

- No ingestion execution
- No indexing
- No RuVector mutation
- No memory promotion
- No wrapper default changes
- No live eval store changes
- No helper installation
- No daemon/timer automation
- No system/security/OpenCode changes

---

## Files Created

- `docs/phase11/PHASE11D_RAG_ANSWER_COMPARISON_DRY_RUN.md` (this file)

---

## Report Paths

Comparison reports written to:
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015604.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015613.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015620.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015631.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015637.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015645.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015653.md`
- `/home/lch/offload/security-reports/manual/gemma-memory-search-20260502-015701.md`

---

## Next Phase Recommendation

**Phase 11E:** Stale-Memory Review Packet (future)

Current Phase 11 status:
- 11A: Planning ✅
- 11B: Static expansion ✅
- 11C: Fixture coverage ✅
- 11C-RV: RuVector alignment ✅
- 11D: RAG comparison ✅
- 11E: Stale-memory review ⏳

---

## Closeout Sign-Off

- Phase 11D: COMPLETE
- Query comparison: PASS
- Supervised RAG safe: YES
- Stage 3A fallback: PRESERVED
- Boundaries: PRESERVED
- Next: Phase 11E (Stale-Memory Review)
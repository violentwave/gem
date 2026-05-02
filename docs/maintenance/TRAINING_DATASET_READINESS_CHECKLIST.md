# Training Dataset Readiness Checklist

**Version:** 1.0  
**Date:** 2026-05-02  
**Status:** ACTIVE (gates not yet met)

---

## Purpose

Define the minimum gates that must be satisfied before the Bazzite Local AI Operations Stack can be considered ready for any form of model training (LoRA, QLoRA, SFT).

This checklist is a **readiness gate**, not a training plan. All items must be checked before training is approved.

---

## Gate 1: Minimum Dataset Size

| Tier | Count | Suitable For | Current | Status |
|------|-------|--------------|---------|--------|
| **Minimum** | 100 examples | Tiny LoRA (proof of concept) | 32 | FAIL |
| **Preferred** | 300–500 examples | Small LoRA (usable adapter) | 32 | FAIL |
| **Meaningful SFT** | 1,000+ examples | Supervised fine-tuning | 32 | FAIL |
| **Production** | 5,000–10,000+ examples | Full model behavior change | 32 | FAIL |

**Current:** 32 supervised examples (21 generation-suitable)  
**Gap:** +68 minimum, +268 preferred, +968 meaningful  

**Requirement:** At least 100 curated, human-reviewed examples before any training consideration.

---

## Gate 2: Generation-Suitable Composition

Training requires examples in generation format (instruction → response), not just classification.

| Type | Count | Generation-Suitable? |
|------|-------|----------------------|
| command_review_example | 11 | Partial (classification labels) |
| rag_answer_example | 8 | Yes |
| bad_to_corrected_example | 6 | Yes |
| path_policy_example | 7 | Yes |
| **Total** | **32** | **21 (66%)** |

**Requirement:** At least 50% generation-suitable (currently 66% — PASS on ratio, FAIL on absolute count).

---

## Gate 3: Eval Case Coverage

| Metric | Minimum | Current | Status |
|--------|---------|---------|--------|
| Total eval cases | 50 | 25 | FAIL |
| Categories covered | All target categories | 4/4 | PASS |
| Forbidden output cases | 5+ | 1 | FAIL |
| Edge cases | 10+ | ~5 | FAIL |

**Requirement:** Minimum 50 eval cases before training, covering all target categories, forbidden outputs, and edge cases.

---

## Gate 4: Zero Drafts

| Metric | Requirement | Current | Status |
|--------|-------------|---------|--------|
| Draft examples | 0 | 0 | PASS |
| Unreviewed examples | 0 | 0 | PASS |
| Deprecated examples | 0 | 0 | PASS |

**Requirement:** All examples must be reviewed. No drafts, no unreviewed, no deprecated.

---

## Gate 5: Zero Secrets

| Check | Requirement | Current | Status |
|-------|-------------|---------|--------|
| API keys in examples | None | None | PASS |
| Tokens in examples | None | None | PASS |
| Passwords in examples | None | None | PASS |
| PII in examples | None | None | PASS |
| Private paths in examples | None | None | PASS |
| `.env` contents | None | None | PASS |

**Requirement:** No secrets, tokens, PII, or private data in any training example.

---

## Gate 6: Zero Raw Logs / Browser Data / Private Code

| Check | Requirement | Current | Status |
|-------|-------------|---------|--------|
| Raw log excerpts | None | None | PASS |
| Browser data | None | None | PASS |
| Private code snippets | None | None | PASS |
| Cookie/session data | None | None | PASS |
| Auth file contents | None | None | PASS |

**Requirement:** No raw logs, browser data, private code, or auth data in training material.

---

## Gate 7: Human Review Required

| Step | Requirement | Current | Status |
|------|-------------|---------|--------|
| All examples reviewed by human | Yes | Yes (32/32) | PASS |
| Contradictions resolved | Yes | None found | PASS |
| Quality standards met | Yes | Yes | PASS |

**Requirement:** 100% human review with contradiction resolution.

---

## Gate 8: RAG Baseline Required

| Metric | Requirement | Current | Status |
|--------|-------------|---------|--------|
| RAG system operational | Yes | Yes (Stage 3A + RuVector) | PASS |
| Baseline accuracy recorded | Yes | Informal only | FAIL |
| RAG failure cases documented | Yes | Partial | FAIL |

**Requirement:** Formal RAG baseline accuracy must be recorded before training. Training must improve upon this baseline.

---

## Gate 9: Clear RAG Failure Cases Required

| Metric | Requirement | Current | Status |
|--------|-------------|---------|--------|
| Identified cases where RAG fails | 10+ documented | ~3 identified | FAIL |
| Failure categorized (retrieval vs generation) | Yes | Partial | FAIL |
| Training would address failure | Documented | Not proven | FAIL |

**Requirement:** Document specific cases where RAG fails and prove training would address them.

---

## Gate 10: Rollback / Import Plan Required

| Component | Requirement | Current | Status |
|-----------|-------------|---------|--------|
| Base model backup | Preserved | Yes (gemma4:e4b always available) | PASS |
| Adapter weights stored separately | Yes | N/A (no adapters) | PASS |
| Ollama can load base without adapter | Yes | Yes | PASS |
| Rollback procedure documented | Yes | Yes (Phase 14E) | PASS |
| Import procedure documented | Yes | Yes (Phase 14E) | PASS |

**Requirement:** Rollback and import procedures documented and tested.

---

## Gate 11: Explicit Human Approval Required

| Item | Requirement | Current | Status |
|------|-------------|---------|--------|
| Training goal approved | Explicit yes | Not requested (blocked) | FAIL |
| Dataset approved | Explicit yes | Not requested (blocked) | FAIL |
| Expected outcome documented | Explicit yes | Not requested (blocked) | FAIL |
| Cost reviewed (cloud) | Explicit yes | Not requested (blocked) | FAIL |
| Risk accepted | Explicit yes | Not requested (blocked) | FAIL |

**Requirement:** Explicit human approval for training goal, dataset, outcome, cost, and risk.

---

## Summary

| Gate | Status | Blocker? |
|------|--------|----------|
| 1: Dataset size (100+) | FAIL | YES |
| 2: Generation-suitable (50%+) | PASS | NO |
| 3: Eval cases (50+) | FAIL | YES |
| 4: Zero drafts | PASS | NO |
| 5: Zero secrets | PASS | NO |
| 6: Zero raw data | PASS | NO |
| 7: Human review | PASS | NO |
| 8: RAG baseline | FAIL | YES |
| 9: RAG failure cases | FAIL | YES |
| 10: Rollback plan | PASS | NO |
| 11: Human approval | FAIL | YES |

**Gates met:** 6/11  
**Critical blockers:** 5 (Gates 1, 3, 8, 9, 11)

---

## Readiness Decision

**Training readiness: NOT READY**

The dataset and evaluation infrastructure do not meet the minimum thresholds for safe, effective training. The most critical gaps are:

1. **Dataset size:** Need +68 examples minimum (+268 preferred)
2. **Eval coverage:** Need +25 eval cases minimum
3. **RAG baseline:** Need formal accuracy measurement
4. **RAG failure cases:** Need documented proof that training would help
5. **Human approval:** Cannot be granted until all other gates pass

**Recommended next step:** Expand examples and evals through manual curation (M3, Phase 13 style), not through automated training.

---

## Sign-Off

- Checklist: ACTIVE
- Readiness: NOT READY
- Critical blockers: 5
- Date: 2026-05-02

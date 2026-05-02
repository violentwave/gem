# Phase 14D: Tiny SFT Smoke Test Decision

**Phase:** 14D — Tiny SFT Smoke Test Decision
**Date:** 2026-05-02
**Parent:** Phase 14C (Training Scaffold Scripts)
**Status:** COMPLETE

---

## Purpose

Decide whether to attempt a tiny supervised fine-tuning (SFT) smoke test on the local GTX 1060 6GB, or defer training entirely.

---

## Smoke Test Definition

A "tiny SFT smoke test" would:
- Use 10-20 hand-picked examples
- Run for 1-3 training steps
- Use rank=4 LoRA with 4-bit quantization
- Maximum sequence length 128 tokens
- Goal: Verify the training loop starts without crashing (not to produce a useful model)

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| OOM crash | High | Low | Process dies, no system harm |
| System slowdown | High | Medium | Training starves desktop GPU |
| Driver timeout | Medium | Medium | NVIDIA TDR may reset GPU |
| Model corruption | Very Low | Low | Base model is read-only in Ollama |
| Time waste | High | Low | 30-60 minutes for setup + test |

## Prerequisites for Smoke Test

Before ANY smoke test:

1. [ ] All Phase 14B eval gates passed
2. [ ] Dataset expanded to 100+ examples
3. [ ] Training environment isolated (Distrobox or venv)
4. [ ] Base model weights backed up
5. [ ] Human explicitly approves the smoke test
6. [ ] Rollback plan documented

## Current Status vs. Prerequisites

| Prerequisite | Current Status | Met? |
|--------------|---------------|------|
| Eval Gate 1 (100+ examples) | 32 examples | ❌ NO |
| Eval Gate 2 (quality review) | All reviewed | ✅ YES |
| Eval Gate 3 (baseline recorded) | Partial | ⚠️ PARTIAL |
| Eval Gate 4 (hardware) | 6GB GTX 1060 | ❌ NO |
| Eval Gate 5 (rollback) | Not prepared | ❌ NO |
| Eval Gate 6 (human approval) | Pending | ❌ NO |
| Eval Gate 7 (safety) | Not tested | ❌ NO |

**Result:** 1 of 7 gates met. Smoke test is BLOCKED.

---

## Decision

**`DEFER` — Do NOT run tiny SFT smoke test at this time.**

### Reasons:

1. **Dataset too small** — 32 examples is insufficient even for a smoke test
2. **Hardware inadequate** — 6GB VRAM is below the practical minimum for QLoRA on 4B models
3. **Gates not met** — 6 of 7 eval gates are unmet
4. **Risk > reward** — Smoke test would likely OOM or be too slow to provide meaningful signal
5. **Better alternatives exist** — RAG (Stage 3A + RuVector) already provides good results

### Conditions for Reconsideration:

Smoke test may be reconsidered when:
- Dataset reaches 100+ curated examples
- Hardware upgraded to 16GB+ VRAM OR cloud GPU is available
- All 7 eval gates are met
- Human explicitly approves

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Risk assessment complete | PASS | 5 risks identified |
| Prerequisites checked | PASS | 7 gates assessed |
| Gates met count | FAIL | 1/7 |
| Decision made | PASS | DEFER |
| Conditions documented | PASS | 4 conditions for reconsideration |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 1 |

---

## Sign-Off

- Phase 14D: COMPLETE
- Smoke test decision: **DEFERRED**
- Blocker: Dataset size + hardware insufficient
- Next: Phase 14E (Local Import Eval as Non-Default Profile)

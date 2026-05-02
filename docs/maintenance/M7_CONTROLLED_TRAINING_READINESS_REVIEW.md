# M7 — Controlled Training Readiness Review

**Phase:** M7 — Controlled Training Readiness Review  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Review-only maintenance phase (no training performed)

---

## Purpose

Review whether the Bazzite Local AI Operations Stack is approaching readiness for future fine-tuning, LoRA, or Hugging Face dataset usage. This is a documentation and assessment phase only — no training, fine-tuning, model pulling, or dataset downloading occurs.

---

## Current Training Status

| Aspect | Status | Details |
|--------|--------|---------|
| **Training readiness** | **NOT READY** | Multiple blockers remain |
| **Fine-tuning (LoRA/QLoRA)** | **DEFERRED** | Hardware and dataset insufficient |
| **SFT (Supervised Fine-Tuning)** | **BLOCKED** | Dataset << 1,000 examples minimum |
| **Hugging Face datasets** | **REVIEW-ONLY** | May be reviewed as candidates, not used for training |
| **RAG** | **PREFERRED** | Current canonical approach |

---

## Current Model Status

| Model | Size | Role | Status |
|-------|------|------|--------|
| `gemma4:e4b` | 9.6 GB | Base model | ACTIVE, optimal for hardware |
| `gemma4-e4b-bazzite:latest` | 9.6 GB | Custom profile | ACTIVE (system prompt only) |
| `nomic-embed-text` | 274 MB | Embedding | ACTIVE (RuVector prototype) |

- **Architecture:** Standard transformer decoder — compatible with PEFT/LoRA
- **Custom profile:** Modelfile-based system prompt only; no weight modification
- **Adapter compatibility:** CONFIRMED (PEFT/LoRA compatible)

---

## Current Hardware Status

| Component | Specification | Status |
|-----------|--------------|--------|
| **GPU** | NVIDIA GeForce GTX 1060 6GB | HEALTHY |
| **VRAM used** | 31 MiB / 6144 MiB | Normal |
| **Temperature** | 56°C | Normal |
| **Driver** | 580.95.05 | Current |

### Hardware Feasibility for Training

| Training Type | VRAM Required | Current VRAM | Feasible |
|---------------|--------------|--------------|----------|
| Inference (current) | 3-4 GB | 6 GB | YES |
| QLoRA (4B model) | 5.5-6.2 GB | 6 GB | MARGINAL (high OOM risk) |
| Full fine-tuning | 16+ GB | 6 GB | NO |
| LoRA (practical) | 8-12 GB | 6 GB | NO |

**Assessment:** Local training is **NOT VIABLE** on current hardware. QLoRA is technically marginal but practically unreliable on 6GB.

---

## Current Dataset / Eval Status

### Supervised Examples

| Type | Count | Suitable for SFT? |
|------|-------|-------------------|
| command_review_example | 11 | Partial (classification, not generation) |
| rag_answer_example | 8 | Yes |
| bad_to_corrected_example | 6 | Yes |
| path_policy_example | 7 | Yes |
| **Total** | **32** | **21 generation-suitable** |

### Eval Cases

| Type | Count | Status |
|------|-------|--------|
| command_review | 10 | PASS |
| knowledge_rag | 7 | PASS |
| path_policy | 7 | PASS |
| forbidden_output | 1 | PASS |
| **Total** | **25** | **All validated** |

### Dataset Size Assessment

| Metric | Current | Minimum for LoRA | Minimum for SFT | Status |
|--------|---------|------------------|-----------------|--------|
| Total examples | 32 | 100 | 1,000 | FAIL |
| Generation-suitable | 21 | 50 | 500 | FAIL |
| Human-reviewed | 32/32 (100%) | 100% | 100% | PASS |
| Drafts | 0 | 0 | 0 | PASS |

**Assessment:** Dataset is **INSUFFICIENT** for any training approach.

---

## Phase 14 Decision Recap

Phase 14 (LoRA / Fine-Tuning Feasibility Assessment) concluded:

| Decision | Status |
|----------|--------|
| **RAG preferred** | CONFIRMED |
| **LoRA deferred** | CONFIRMED indefinitely |
| **Hardware blocker** | GTX 1060 6GB insufficient |
| **Dataset blocker** | 32 examples << 100 minimum |
| **Expected benefit** | Marginal (~+3%), with edge-case degradation risk |

Key Phase 14 finding: LoRA is not viable locally due to VRAM constraints. RAG is proven, working, and hardware-friendly.

---

## Phase 25 Decision Recap

Phase 25 (Optional Advanced Model Work Review) concluded:

| Decision | Status |
|----------|--------|
| **No changes** | CONFIRMED |
| **Gemma 4 optimal** | CONFIRMED for current hardware |
| **No hardware upgrade needed** | CONFIRMED |
| **Local-only correct** | CONFIRMED |
| **Cloud training not needed** | CONFIRMED |

---

## Current Blockers

| Blocker | Severity | Details |
|---------|----------|---------|
| **Hardware (VRAM)** | CRITICAL | 6GB insufficient for practical LoRA; QLoRA marginal/high OOM risk |
| **Dataset size** | CRITICAL | 32 examples << 100 minimum for LoRA, << 1,000 for SFT |
| **Dataset composition** | MEDIUM | Only 21/32 are generation-suitable |
| **No baseline scores** | MEDIUM | No formal RAG vs fine-tuned accuracy baselines recorded |
| **No rollback tested** | LOW | Rollback plan documented but not executed for model weights |
| **No human approval** | LOW | Not requested because other blockers prevent readiness |

**Blockers met:** 0/6 critical blockers resolved.

---

## Gates Required Before Future Training

All gates must pass before any training attempt:

1. **Gate 1: Dataset Size** — Minimum 100 curated examples (300-500 preferred for LoRA; 1,000+ for SFT)
2. **Gate 2: Dataset Quality** — All examples human-reviewed, validated, no contradictions
3. **Gate 3: Baseline Performance** — Base model and RAG baselines recorded; training must improve both
4. **Gate 4: Hardware Feasibility** — 16GB+ VRAM or confirmed cloud GPU; training time < 4 hours
5. **Gate 5: Rollback Plan** — Base model preserved, adapter weights stored separately, Ollama can load base without adapter
6. **Gate 6: Human Approval** — Training goal, dataset, and expected outcome explicitly approved
7. **Gate 7: Safety Verification** — No overfitting, model refuses out-of-bounds requests, no secrets leaked

Current gate status: **1/7 PASS** (Gate 2: dataset quality only)

---

## Training Permission Matrix

| Training Type | Local | Cloud | Notes |
|---------------|-------|-------|-------|
| **LoRA / QLoRA** | ❌ NOT ALLOWED | ⚠️ REVIEW-ONLY | Local: hardware insufficient. Cloud: requires explicit human approval and cost review. |
| **SFT** | ❌ NOT ALLOWED | ⚠️ REVIEW-ONLY | Local: impossible. Cloud: requires explicit human approval and dataset readiness. |
| **Prompt engineering** | ✅ ALLOWED | N/A | Modelfile system prompt changes — zero cost, immediate, reversible |
| **RAG improvement** | ✅ ALLOWED | N/A | Add knowledge docs, improve chunking — no training needed |
| **Eval expansion** | ✅ ALLOWED | N/A | Add eval cases and examples — strengthens quality without training |

---

## Hugging Face Dataset Policy

| Action | Status |
|--------|--------|
| **Download by default** | ❌ NOT ALLOWED |
| **Bulk import** | ❌ NOT ALLOWED |
| **Direct training** | ❌ NOT ALLOWED |
| **Review as candidate material** | ✅ ALLOWED (with vetting policy) |
| **Sample inspection** | ✅ ALLOWED (manual, single samples) |
| **License review** | ✅ ALLOWED |
| **Rewrite/sanitize for examples** | ✅ ALLOWED (with human approval) |

See [HUGGINGFACE_DATASET_VETTING_POLICY.md](HUGGINGFACE_DATASET_VETTING_POLICY.md) for full policy.

---

## Decision

### Training Readiness: **NOT READY**

The Bazzite Local AI Operations Stack is **not ready** for fine-tuning, LoRA, or SFT training.

### Rationale

1. **Hardware:** GTX 1060 6GB is insufficient for practical local training. QLoRA is marginal with high OOM risk.
2. **Dataset:** 32 examples is far below the 100 minimum for LoRA and 1,000 minimum for meaningful SFT.
3. **Benefit:** Expected marginal gain (~+3%) does not justify the cost, complexity, or risk.
4. **Alternative:** RAG is proven, working, and requires no training.

### Fine-Tuning: **DEFERRED**

LoRA and all forms of weight-modifying training are deferred indefinitely.

### Hugging Face Datasets: **REVIEW-ONLY**

Hugging Face datasets may be reviewed as candidate material for future example curation, but may not be downloaded by default, bulk-imported, or used for direct training.

### RAG: **REMAINS PREFERRED**

Retrieval-Augmented Generation remains the canonical approach for augmenting model responses with Bazzite-specific knowledge.

---

## Recommendation for M8

If continuing the training track, M8 should be:

**M8 — External Dataset Vetting (Hugging Face Review)**

Purpose: Review specific Hugging Face dataset candidates for potential future example curation, without downloading or training.

Scope:
- Identify candidate datasets matching Bazzite domain (Linux, security, system administration)
- Review licenses, samples, and metadata
- Scan for contradictions with Bazzite policies
- Produce candidate packets for human review
- No download, no training, no bulk import

Alternative: Skip M8 and return to regular maintenance (M1/M2 on 2026-05-09).

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| Examples validated | PASS | 32/32 reviewed, 0 drafts |
| Evals validated | PASS | 25/25 cases pass |
| Dataset size | FAIL | 32 << 100 minimum |
| Hardware feasibility | FAIL | 6GB insufficient |
| Gate status | FAIL | 1/7 gates met |
| Phase 14 recap | PASS | Decisions reaffirmed |
| Phase 25 recap | PASS | Decisions reaffirmed |
| Training decision | PASS | NOT READY documented |
| HF policy | PASS | Review-only documented |
| RAG status | PASS | Preferred confirmed |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 3 (dataset size, hardware, gates) |

**Overall: TRAINING NOT READY — this is the expected and correct outcome.**

---

## Artifacts

| Artifact | Location |
|----------|----------|
| This review | `docs/maintenance/M7_CONTROLLED_TRAINING_READINESS_REVIEW.md` |
| Dataset readiness checklist | `docs/maintenance/TRAINING_DATASET_READINESS_CHECKLIST.md` |
| HF vetting policy | `docs/maintenance/HUGGINGFACE_DATASET_VETTING_POLICY.md` |
| RAG vs LoRA matrix | `docs/maintenance/RAG_VS_LORA_RECHECK_MATRIX.md` |
| M8 prompt | `prompts/opencode/m8-external-dataset-vetting-huggingface-review.prompt.txt` |

---

## Sign-Off

- M7: COMPLETE
- Training readiness: **NOT READY**
- Fine-tuning: **DEFERRED**
- Hugging Face datasets: **REVIEW-ONLY**
- RAG: **PREFERRED**
- No training occurred
- No models pulled
- No datasets downloaded
- No secrets printed
- All safety boundaries: MAINTAINED
- Date: 2026-05-02

# RAG vs LoRA Recheck Matrix

**Version:** 1.0  
**Date:** 2026-05-02  
**Status:** ACTIVE

---

## Purpose

Provide a decision matrix for determining when RAG (Retrieval-Augmented Generation) is sufficient versus when LoRA fine-tuning might be reconsidered. This is a living document that should be rechecked whenever the system state changes (new hardware, expanded dataset, new requirements).

---

## When RAG Is Sufficient

| Scenario | RAG Handles? | Notes |
|----------|--------------|-------|
| **Canonical path questions** | YES | "Where are logs stored?" → Retrieval finds PATHS.md |
| **Policy questions** | YES | "What firewall tool?" → Retrieval finds FINAL_POLICY.md |
| **Command classification** | YES | "Is `sudo rpm-ostree install` safe?" → Retrieval finds RUNBOOK.md |
| **Documentation lookup** | YES | "What is Stage 3A?" → Retrieval finds architecture docs |
| **Procedural guidance** | YES | "How do I back up?" → Retrieval finds rollback procedures |
| **Factual recall** | YES | "What GPU do I have?" → Retrieval finds inventory |
| **Out-of-scope detection** | YES | RAG returns no results → model correctly uncertain |

**RAG is sufficient when:** The question can be answered by retrieving relevant context from the knowledge pack and presenting it to the model.

---

## When Prompt Engineering Is Sufficient

| Scenario | Prompt Engineering Handles? | Notes |
|----------|---------------------------|-------|
| **Tone adjustment** | YES | Modify Modelfile system prompt |
| **Format preferences** | YES | "Always respond in Markdown tables" |
| **Boundary reinforcement** | YES | "Never recommend apt" in system prompt |
| **Verbosity control** | YES | "Be concise" / "Explain step by step" |
| **Safety reminders** | YES | "Always ask before sudo" |

**Prompt engineering is sufficient when:** The desired behavior change is about how the model responds, not what it knows.

---

## When Eval Expansion Is Sufficient

| Scenario | Eval Expansion Handles? | Notes |
|----------|------------------------|-------|
| **Regression prevention** | YES | More eval cases catch drift |
| **Coverage gaps** | YES | Add cases for untested categories |
| **Quality monitoring** | YES | Track pass rate over time |
| **False-positive reduction** | YES | Add negative examples |

**Eval expansion is sufficient when:** The goal is to maintain or improve quality without changing model weights.

---

## When LoRA Could Be Reconsidered

| Condition | Current Status | Required for Reconsideration |
|-----------|---------------|------------------------------|
| **Hardware** | GTX 1060 6GB | 16GB+ VRAM (RTX 4060 Ti or better) |
| **Dataset** | 32 examples | 500+ curated, generation-suitable examples |
| **RAG failure** | ~3 documented | 10+ documented cases where RAG demonstrably fails |
| **RAG baseline** | Informal | Formal accuracy measurement recorded |
| **Use case** | Advisory only | Complex multi-step reasoning required |
| **Latency** | Acceptable | Retrieval latency becomes unacceptable |
| **Style need** | Moderate | Strong need for Bazzite-specific tone/writing style |

**LoRA reconsideration requires ALL of:**
1. Hardware upgraded to 16GB+ VRAM
2. Dataset expanded to 500+ examples
3. 10+ documented RAG failure cases
4. Formal RAG baseline recorded
5. Human explicitly approves training effort
6. Clear use case where LoRA outperforms RAG + prompt engineering

---

## Proof Required Before Training

Before any training is approved, the following proof must be provided:

| Proof | Format | Owner |
|-------|--------|-------|
| **RAG accuracy baseline** | JSON/CSV with query + expected + actual | Eval system |
| **RAG failure cases** | Documented queries where RAG returns wrong/insufficient context | Human reviewer |
| **Training target accuracy** | Specific target (e.g., "improve from 80% to 90%") | Human reviewer |
| **Dataset quality report** | `gemma-examples-check` output + human review notes | Human reviewer |
| **Hardware benchmark** | VRAM usage during training simulation | Training executor |
| **Cost estimate** | Cloud GPU hours or hardware purchase cost | Human reviewer |
| **Rollback test** | Verified ability to revert to base model | Training executor |
| **Safety test** | Model still refuses out-of-bounds requests post-training | Eval system |

---

## Comparison Against Stage 3A

| Factor | Stage 3A (Deterministic) | LoRA (Hypothetical) |
|--------|-------------------------|---------------------|
| **Setup** | Simple (JSONL index) | Complex (training pipeline) |
| **Update** | Re-index (minutes) | Retrain (hours) |
| **Hardware** | Any GPU for inference | 16GB+ VRAM for training |
| **Transparency** | High (inspect chunks) | Low (black box weights) |
| **Reversibility** | Delete chunks | Delete adapter |
| **Accuracy** | Proven (~85% path/policy) | Hypothetical (~+3%) |
| **Maintenance** | Low | Medium (retrain on drift) |

**Conclusion:** Stage 3A is simpler, cheaper, and proven. LoRA is complex, expensive, and unproven for this use case.

---

## Comparison Against RuVector

| Factor | RuVector (Semantic) | LoRA (Hypothetical) |
|--------|--------------------|---------------------|
| **Setup** | Moderate (embedding model) | Complex (training pipeline) |
| **Update** | Re-index (minutes) | Retrain (hours) |
| **Hardware** | Any GPU for inference + embedding | 16GB+ VRAM for training |
| **Transparency** | Medium (inspect embeddings) | Low (black box weights) |
| **Reversibility** | Delete index | Delete adapter |
| **Accuracy** | Prototype (Gate 1: 75% pass) | Hypothetical |
| **Status** | Approved secondary | Not viable locally |

**Conclusion:** RuVector is a viable secondary retrieval source. LoRA is not viable on current hardware.

---

## Decision Tree

```
Need better model responses?
├── Can it be solved by better retrieval?
│   ├── YES → Improve RAG (Stage 3A or RuVector)
│   └── NO → Continue
├── Can it be solved by prompt engineering?
│   ├── YES → Update Modelfile system prompt
│   └── NO → Continue
├── Can it be solved by more evals/examples?
│   ├── YES → Expand eval system
│   └── NO → Continue
├── Is hardware 16GB+ VRAM?
│   ├── NO → STOP (training not viable)
│   └── YES → Continue
├── Are there 500+ curated examples?
│   ├── NO → STOP (dataset insufficient)
│   └── YES → Continue
├── Are there 10+ documented RAG failures?
│   ├── NO → STOP (RAG likely sufficient)
│   └── YES → Continue
├── Has human explicitly approved training?
│   ├── NO → STOP (approval required)
│   └── YES → Proceed to training planning
```

---

## Recheck Schedule

| Trigger | Action |
|---------|--------|
| **Hardware upgrade** | Re-run full matrix |
| **Dataset > 100 examples** | Re-check Gate 1 |
| **Dataset > 500 examples** | Re-run full matrix |
| **New RAG failure identified** | Add to failure case log |
| **Quarterly review (M6)** | Re-check all conditions |
| **New model release** | Assess if model change affects matrix |

---

## Current Decision

| Approach | Status |
|----------|--------|
| **RAG (Stage 3A)** | PRIMARY — proven, working |
| **RAG (RuVector)** | SECONDARY — supervised prototype |
| **Prompt engineering** | ALLOWED — zero cost |
| **Eval expansion** | ALLOWED — strengthens quality |
| **LoRA / QLoRA** | DEFERRED — hardware insufficient |
| **SFT** | BLOCKED — dataset insufficient |

**Recheck date:** 2026-08-02 (next M6) or upon hardware/dataset change.

---

## Sign-Off

- Matrix: ACTIVE
- Current decision: RAG preferred, LoRA deferred
- Next recheck: 2026-08-02 or on state change
- Date: 2026-05-02

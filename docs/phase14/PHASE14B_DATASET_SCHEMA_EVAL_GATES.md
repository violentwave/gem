# Phase 14B: Dataset Schema and Eval Gates

**Phase:** 14B — Dataset Schema and Eval Gates
**Date:** 2026-05-02
**Parent:** Phase 14A (Base Model Identity and Adapter Compatibility)
**Status:** COMPLETE

---

## Purpose

Define the dataset schema for any future fine-tuning attempt and establish eval gates that must be passed before training proceeds.

---

## Current Dataset

### Source: Stage 4B Supervised Examples

**Location:** `~/.local/share/bazzite-security/gemma-evals/examples/`

**Current Count:** 32 reviewed examples

| Type | Count | Suitable for SFT? |
|------|-------|-------------------|
| command_review_example | 11 | ⚠️ Partial (classification tasks, not generation) |
| rag_answer_example | 8 | ✅ Yes (question-answer pairs) |
| bad_to_corrected_example | 6 | ✅ Yes (instruction + correction pairs) |
| path_policy_example | 7 | ✅ Yes (question-answer pairs) |

### Dataset Size Assessment

| Metric | Value | Assessment |
|--------|-------|------------|
| Total examples | 32 | Very small for fine-tuning |
| Generation-suitable examples | 21 | Still insufficient |
| Recommended minimum for LoRA | 100-500 | Not met |
| Recommended minimum for meaningful SFT | 1,000+ | Not met |

**Finding:** The current curated example set is designed for regression testing and eval validation, not for model training. It is far too small for effective fine-tuning.

---

## Dataset Schema (If Expanded)

### SFT Format (Alpaca-style)

```json
{
  "instruction": "What firewall tool does Bazzite use?",
  "input": "",
  "output": "Bazzite uses firewalld (firewall-cmd) for firewall management, not ufw or iptables.",
  "system": "You are a Bazzite/Fedora Atomic advisor. Use firewalld, rpm-ostree, Flatpak. Never apt or ufw.",
  "metadata": {
    "source": "synthetic",
    "category": "rag_answer",
    "reviewed_by": "human",
    "id": "ex-rag-005"
  }
}
```

### Conversation Format (ChatML-style)

```json
{
  "messages": [
    {"role": "system", "content": "You are a Bazzite/Fedora Atomic advisor..."},
    {"role": "user", "content": "What firewall tool does Bazzite use?"},
    {"role": "assistant", "content": "Bazzite uses firewalld (firewall-cmd)..."}
  ],
  "metadata": {
    "source": "synthetic",
    "reviewed": true
  }
}
```

---

## Eval Gates (Mandatory Before Training)

Any future training attempt must pass ALL gates:

### Gate 1: Dataset Size
- [ ] Minimum 100 curated examples
- [ ] Minimum 50% are generation-suitable (QA, instruction-following)
- [ ] No secrets, PII, or private data

### Gate 2: Dataset Quality
- [ ] All examples human-reviewed
- [ ] All examples validated with `gemma-examples-check`
- [ ] Coverage across all target categories
- [ ] No contradictory examples

### Gate 3: Baseline Performance
- [ ] Base model eval score recorded (before training)
- [ ] RAG baseline score recorded (Stage 3A + RuVector)
- [ ] Training must improve upon both baselines

### Gate 4: Hardware Feasibility
- [ ] Training hardware has 16GB+ VRAM OR cloud GPU confirmed
- [ ] Training time estimate < 4 hours for prototype
- [ ] No system services disrupted during training

### Gate 5: Rollback Plan
- [ ] Original base model preserved (Modelfile backup)
- [ ] Adapter weights stored separately (not merged)
- [ ] Ollama can load base model without adapter

### Gate 6: Human Approval
- [ ] Training goal explicitly approved by human
- [ ] Dataset reviewed and approved by human
- [ ] Expected outcome documented and agreed

### Gate 7: Safety Verification
- [ ] No overfitting to small dataset
- [ ] Model still refuses out-of-bounds requests
- [ ] Canonical path discipline maintained
- [ ] No secrets leaked in model outputs

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Dataset schema defined | PASS | Alpaca + ChatML formats documented |
| Current dataset size | FAIL | 32 examples << 100 minimum |
| Dataset quality | PASS | All reviewed, validated |
| Eval gates defined | PASS | 7 gates documented |
| Generation-suitable ratio | WARN | 21/32 = 66% (acceptable but small) |

| Category | Count |
|----------|-------|
| PASS | 3 |
| WARN | 1 |
| FAIL | 1 |

---

## Sign-Off

- Phase 14B: COMPLETE
- Dataset schema: DEFINED
- Eval gates: ESTABLISHED (7 gates)
- Dataset size: INSUFFICIENT for training (blocker)
- Next: Phase 14C (Training Scaffold Scripts)

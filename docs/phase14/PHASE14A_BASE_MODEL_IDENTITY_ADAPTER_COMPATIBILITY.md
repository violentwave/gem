# Phase 14A: Base Model Identity and Adapter Compatibility

**Phase:** 14A — Base Model Identity and Adapter Compatibility
**Date:** 2026-05-02
**Parent:** Phase 13E (Phase 13 Closeout)
**Status:** COMPLETE

---

## Purpose

Identify the exact base model used for the custom Gemma profile and assess whether it supports LoRA/adapter-based fine-tuning.

---

## Base Model Identification

| Property | Value |
|----------|-------|
| **Custom Profile** | `gemma4-e4b-bazzite:latest` |
| **Base Model** | `gemma4:e4b` |
| **Ollama ID** | `09502e686675` (custom), `c6eb396dbd59` (base) |
| **Size** | 9.6 GB each |
| **Architecture** | Gemma (Google) — dense transformer decoder |
| **Parameters** | ~4B (e4b = 4 billion parameters) |
| **Context Length** | 128K tokens |

## Custom Profile Details

**Modelfile Location:** `~/.config/bazzite-security/ollama/Modelfile.gemma4-e4b-bazzite`

**System Prompt Includes:**
- Bazzite/Fedora Atomic identity
- Firewalld (not ufw)
- RPM-ostree (not apt)
- Flatpak/Homebrew preferences
- Security boundaries
- Canonical paths

**Note:** The system prompt is applied at inference time via the Modelfile, not baked into model weights. The base weights remain unchanged.

---

## Adapter Compatibility Assessment

### LoRA / QLoRA Feasibility

| Aspect | Status | Notes |
|--------|--------|-------|
| Architecture supports adapters | ✅ Yes | Gemma uses standard transformer blocks compatible with PEFT |
| PEFT library support | ✅ Yes | `peft` library supports Gemma via `AutoModelForCausalLM` |
| Quantization available | ✅ Yes | 4-bit (BitsAndBytes) or 8-bit loading possible |
| Ollama import of adapters | ⚠️ Partial | Ollama supports importing GGUF; adapter merging requires extra steps |

### VRAM Constraint Analysis

| Operation | Estimated VRAM | GTX 1060 6GB | Feasible? |
|-----------|---------------|--------------|-----------|
| Full fine-tuning (FP16) | ~16-20 GB | ❌ No | Not possible |
| LoRA (FP16, rank=8) | ~12-14 GB | ❌ No | Marginal, likely OOM |
| QLoRA (4-bit, rank=8) | ~6-8 GB | ⚠️ Maybe | Extremely tight, high risk of OOM |
| QLoRA (4-bit, rank=4) | ~5-7 GB | ⚠️ Maybe | Might fit but leaves no headroom |
| Inference only (current) | ~3-4 GB | ✅ Yes | Comfortable |

**Key Finding:** Even with 4-bit QLoRA, the 6GB GTX 1060 has insufficient VRAM headroom for stable training of a 4B parameter model. Training would be extremely slow, prone to OOM, and offer no margin for system processes or context windows.

---

## Alternative Approaches

Given the VRAM constraint, these alternatives are more practical:

1. **Cloud/Distributed Training** — Train LoRA on a GPU rental (Colab, RunPod, Lambda) with 16GB+ VRAM, then import the adapter locally
2. **Smaller Base Model** — Switch to a 2B or 1B parameter model (e.g., Gemma 2B) which would fit in 6GB for QLoRA
3. **RAG-Only Approach** — Continue using Stage 3A deterministic retrieval + RuVector semantic prototype without model fine-tuning
4. **CPU Offloading** — Use DeepSpeed or similar to offload optimizer states to CPU (very slow, not recommended)

---

## Decision

**Base Model:** `gemma4:e4b` (4B params, 9.6GB on disk)
**Adapter Support:** Compatible with LoRA/QLoRA via PEFT
**Local Training Feasibility:** ❌ **NOT FEASIBLE** on GTX 1060 6GB
**Recommendation:** If fine-tuning is desired, use cloud GPU or switch to a smaller base model

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Base model identified | PASS | gemma4:e4b |
| Custom profile documented | PASS | Modelfile location recorded |
| Architecture supports adapters | PASS | Standard transformer |
| PEFT compatibility | PASS | AutoModelForCausalLM |
| VRAM sufficient for training | FAIL | 6GB < minimum 8GB for stable QLoRA |
| Alternative paths documented | PASS | 4 alternatives listed |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 1 |

---

## Sign-Off

- Phase 14A: COMPLETE
- Base model: IDENTIFIED
- Adapter compatibility: CONFIRMED (but impractical locally)
- Next: Phase 14B (Dataset Schema and Eval Gates)

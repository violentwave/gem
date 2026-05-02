# Phase 14E: Local Import Eval as Non-Default Profile

**Phase:** 14E — Local Import Eval as Non-Default Profile
**Date:** 2026-05-02
**Parent:** Phase 14D (Tiny SFT Smoke Test Decision)
**Status:** COMPLETE

---

## Purpose

Document the safe path for importing a future fine-tuned model as a non-default Ollama profile, without actually creating or importing any model.

---

## Safe Import Path

If a fine-tuned adapter is ever created (externally or after hardware upgrade), the safe import workflow is:

### Step 1: Preserve Default Model

```bash
# Default profile remains untouched
ollama ls
# gemma4-e4b-bazzite:latest  <- default, preserved
```

### Step 2: Merge Adapter with Base (External)

```bash
# PSEUDOCODE — executed on cloud GPU or better hardware
# Merge LoRA adapter into base model
python merge_adapter.py \
  --base_model gemma4:e4b \
  --adapter_path ./lora_adapter \
  --output_path ./merged_model
```

### Step 3: Convert to GGUF

```bash
# PSEUDOCODE — uses llama.cpp
python convert_hf_to_gguf.py \
  --outfile bazzite-lora-finetuned.gguf \
  --outtype q4_0 \
  ./merged_model
```

### Step 4: Create New Ollama Profile (Non-Default)

```bash
# Create a Modelfile for the fine-tuned version
cat > Modelfile.finetuned << 'EOF'
FROM ./bazzite-lora-finetuned.gguf
SYSTEM """You are a Bazzite/Fedora Atomic advisor. ..."""
PARAMETER temperature 0.3
PARAMETER num_ctx 4096
EOF

# Import as a NEW model, never overwrite default
ollama create gemma4-e4b-bazzite:finetuned -f Modelfile.finetuned
```

### Step 5: Validate Side-by-Side

```bash
# Compare default vs fine-tuned
ollama run gemma4-e4b-bazzite:latest "What firewall tool does Bazzite use?"
ollama run gemma4-e4b-bazzite:finetuned "What firewall tool does Bazzite use?"
```

### Step 6: Rollback If Needed

```bash
# If fine-tuned model performs worse, simply delete it
ollama rm gemma4-e4b-bazzite:finetuned
# Default model is unaffected
```

---

## Import Safety Rules

1. **Never overwrite default** — `gemma4-e4b-bazzite:latest` remains the production default
2. **Use explicit tags** — `:finetuned`, `:experiment`, `:test` — never `:latest` for experiments
3. **Validate before use** — Run evals against the new model before adoption
4. **Document changes** — Record what was fine-tuned, on what data, with what hyperparameters
5. **Keep adapter separate** — Store adapter weights separately from merged model for reproducibility

---

## Evaluation Criteria for Imported Model

Before considering an imported model for production:

| Criterion | Minimum Threshold |
|-----------|-------------------|
| Eval score vs baseline | Must match or exceed base model on Stage 4 evals |
| RAG quality | Must not degrade Stage 3A retrieval answers |
| Path discipline | Must correctly reference canonical paths |
| Safety | Must still refuse out-of-bounds requests |
| Speed | Inference time must not increase >20% |

---

## Current Status

**No import performed.** This phase is documentation-only.

The custom profile `gemma4-e4b-bazzite:latest` remains the only active model.
No fine-tuned variant exists.

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Import path documented | PASS | 6-step workflow |
| Safety rules defined | PASS | 5 rules |
| Eval criteria defined | PASS | 5 criteria |
| Default model preserved | PASS | No overwrite rule |
| Import executed | N/A | Intentionally not executed |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 14E: COMPLETE
- Import path: DOCUMENTED
- Safety rules: DEFINED
- No import performed
- Next: Phase 14F (RAG-vs-LoRA Decision Memo)

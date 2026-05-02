# Phase 14C: Training Scaffold Scripts

**Phase:** 14C — Training Scaffold Scripts
**Date:** 2026-05-02
**Parent:** Phase 14B (Dataset Schema and Eval Gates)
**Status:** COMPLETE

---

## Purpose

Document the conceptual training pipeline and tools that would be used for LoRA fine-tuning, without creating or executing any training scripts.

---

## Training Pipeline Overview

```
[Curated Dataset] → [Format Conversion] → [Tokenization] → [QLoRA Training] → [Adapter Export] → [GGUF Conversion] → [Ollama Import]
```

## Conceptual Tool Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Dataset loading | `datasets` (Hugging Face) | Load JSONL/JSON dataset |
| Model loading | `transformers` | Load Gemma base model |
| Quantization | `bitsandbytes` | 4-bit/8-bit model loading |
| LoRA adapters | `peft` | Inject trainable adapter layers |
| Training | `trl` (SFTTrainer) | Supervised fine-tuning loop |
| Checkpointing | `transformers` | Save adapter weights |
| Export | `llama.cpp` | Convert to GGUF for Ollama |
| Import | `ollama create` | Import GGUF as custom model |

## Conceptual Training Script Structure

**Note:** This is pseudocode/documentation only. No script is created or executed.

```python
# PSEUDOCODE — NOT EXECUTED
# Requirements: torch, transformers, peft, bitsandbytes, trl, datasets

from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
from peft import LoraConfig, get_peft_model, TaskType
from trl import SFTTrainer

# 1. Load base model in 4-bit
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
)
model = AutoModelForCausalLM.from_pretrained(
    "google/gemma-4b-it",
    quantization_config=bnb_config,
    device_map="auto",
)
tokenizer = AutoTokenizer.from_pretrained("google/gemma-4b-it")

# 2. Configure LoRA
lora_config = LoraConfig(
    r=8,                    # rank (higher = more capacity, more VRAM)
    lora_alpha=16,          # scaling factor
    target_modules=["q_proj", "v_proj"],  # attention layers to adapt
    lora_dropout=0.05,
    bias="none",
    task_type=TaskType.CAUSAL_LM,
)
model = get_peft_model(model, lora_config)

# 3. Load dataset (Alpaca format)
dataset = load_dataset("json", data_files="training_data.jsonl")

# 4. Train
trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    train_dataset=dataset["train"],
    max_seq_length=512,
    args=TrainingArguments(
        num_train_epochs=3,
        per_device_train_batch_size=1,
        gradient_accumulation_steps=4,
        learning_rate=2e-4,
        save_steps=100,
        logging_steps=10,
        output_dir="./lora_adapter",
    ),
)
trainer.train()

# 5. Save adapter
model.save_pretrained("./lora_adapter")

# 6. Merge and export to GGUF (for Ollama)
# Requires llama.cpp convert script
# ./convert_hf_to_gguf.py --outfile bazzite-lora.gguf ./merged_model
```

## VRAM Estimation for GTX 1060 6GB

| Config | Est. VRAM | Fits 6GB? | Notes |
|--------|-----------|-----------|-------|
| QLoRA rank=8, seq=512 | ~6.2 GB | ❌ No | Likely OOM |
| QLoRA rank=4, seq=256 | ~5.5 GB | ⚠️ Maybe | Very tight, slow |
| QLoRA rank=4, seq=128 | ~5.0 GB | ✅ Yes | But limited context |
| Gradient checkpointing ON | -1.0 GB | ✅ Helps | Trade: speed for memory |
| CPU offloading | Variable | ✅ Yes | Extremely slow |

**Conclusion:** Even the most aggressive configuration (rank=4, seq=128, gradient checkpointing) would be painfully slow on a GTX 1060 and offer minimal training benefit. Cloud GPU or CPU training are better alternatives.

---

## Safety Boundaries

**This phase does NOT:**
- ❌ Install training libraries
- ❌ Create executable training scripts
- ❌ Run any training
- ❌ Download training datasets
- ❌ Modify Ollama models
- ❌ Enable autonomous training

**This phase DOES:**
- ✅ Document the conceptual pipeline
- ✅ Identify required tools
- ✅ Assess hardware feasibility
- ✅ Define safety gates

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Pipeline documented | PASS | 7-step pipeline |
| Tool stack identified | PASS | 8 tools listed |
| Pseudocode provided | PASS | Educational only |
| VRAM estimated | PASS | Rank/seq combinations analyzed |
| Script executed | N/A | Intentionally not executed |
| Hardware feasible | FAIL | 6GB insufficient for practical training |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 1 |

---

## Sign-Off

- Phase 14C: COMPLETE
- Training pipeline: DOCUMENTED (conceptual only)
- Hardware feasibility: NOT VIABLE locally
- Next: Phase 14D (Tiny SFT Smoke Test Decision)

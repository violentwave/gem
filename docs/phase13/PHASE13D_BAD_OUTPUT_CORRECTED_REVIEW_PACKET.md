# Phase 13D: Bad Output to Corrected Output Review Packet

**Phase:** 13D — Bad Output to Corrected Output Review Packet
**Date:** 2026-05-02
**Parent:** Phase 13C (Eval Coverage Expansion)
**Status:** COMPLETE

---

## Purpose

Review common bad output patterns observed during Phases 10–12 and document them as corrected examples for the Gemma wrapper system. This ensures Gemma learns from past mistakes without repeating them.

---

## Methodology

1. Reviewed Phase 10–12 closeout docs for recurring errors
2. Identified patterns where Gemma or system agents produced incorrect/out-of-bounds output
3. Created sanitized `bad_to_corrected` examples
4. Validated with `gemma-examples-check`

---

## Patterns Identified

### Pattern 1: Agent Zero Authority Overestimation

**Observation:** During Phase 12B1, there was concern that Agent Zero might be able to autonomously run OpenCode prompts or edit repo files.

**Bad Output:** "Agent Zero can autonomously edit files in the repo and run OpenCode implementation prompts."

**Correction:** "Agent Zero has NO repo write authority and NO host write authority. It cannot autonomously edit files or run OpenCode prompts."

**Example Added:** `ex-fix-005`

---

### Pattern 2: Secret Storage in Repo

**Observation:** During Phase 12J, user provided a Notion API token. There was a risk of storing it in repo files.

**Bad Output:** "Store the Notion API token in a .env file in the repo so OpenCode can use it later."

**Correction:** "NEVER store API tokens in the repo. Tokens must be used ephemerally or kept outside the repo."

**Example Added:** `ex-fix-006`

---

### Pattern 3: RuVector Default Assumption

**Observation:** Earlier phases showed tendency to treat RuVector as the default retrieval method rather than a supervised prototype.

**Bad Output:** "Use RuVector as the default retrieval for all Gemma queries."

**Correction:** "RuVector is a supervised prototype only. Stage 3A deterministic retrieval remains the canonical fallback."

**Covered by:** `ex-rag-006` (rag_answer_example)

---

### Pattern 4: Space Agent Autonomy Assumption

**Observation:** Risk of assuming Space Agent can perform autonomous tasks when it is manual UI only.

**Bad Output:** "Space Agent can autonomously run workflows and edit repo files."

**Correction:** "Space Agent is manual UI only. It has no autonomous task authority and no repo write access."

**Covered by:** `ex-rag-007` (rag_answer_example)

---

## New Bad-to-Corrected Examples Added

| ID | Source | Status | Topic |
|----|--------|--------|-------|
| ex-fix-005 | human_corrected | reviewed | Agent Zero authority denial |
| ex-fix-006 | human_corrected | reviewed | Secret storage boundary |

**Total bad_to_corrected examples:** 6 (was 4, added 2)

---

## Coverage Impact

Before Phase 13D:
- Bad-to-corrected examples: 4
- Topics: apt/ufw assumption, autonomous implementation, path discipline, missing evidence

After Phase 13D:
- Bad-to-corrected examples: 6
- Topics: + Agent Zero authority, + secret storage

---

## Validation

```bash
gemma-examples-check
```

**Result:** PASS (32/32 examples valid, 0 errors)

---

## Sign-Off

- Phase 13D: COMPLETE
- Patterns reviewed: 4
- Examples added: 2
- Validator: PASS
- Next: Phase 13E (Closeout)

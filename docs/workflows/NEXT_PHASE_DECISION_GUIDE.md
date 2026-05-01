# Next Phase Decision Guide

**Phase:** 8D — Workflow Library Closeout
**Status:** Guide for choosing the next phase after Phase 8 closeout
**Scope:** Documentation-only — no phase execution

---

## How to Choose the Next Phase

### Run 8B.4 if:
**Goal:** Test RuVector semantic quality with bounded validation (not full validation).

**Conditions:**
- You want to validate RuVector prototype quality
- You want to run Gate 2 validators (gemma-evals-status, gemma-evals-check, gemma-examples-check)
- You want to run Gate 6 manifest checks
- You want to run a **limited** Gate 1 (3-5 sample queries comparing RuVector vs Stage 3A)
- You do **NOT** want to run full Gate 3 (10+ queries), Gate 4 (10 spot-checks), or Gate 5 (answer generation)

**What it does:**
- Bounded dry-run: Gate 2 (full) + Gate 6 (full) + limited Gate 1 (3-5 samples)
- Generates dry-run report to `~/offload/security-reports/manual/quality-dry-run-*.md`
- Does **NOT** promote RuVector
- Does **NOT** run full validation

**Prompt:** `prompts/opencode/phase8b4-memory-quality-dry-run.prompt.txt` (already exists)

**Prerequisite:** Phase 8B.3 ✅ (Quality gates defined)

---

### Run 8C.1 only if:
**Goal:** Verify Space Agent provider/workspace behavior with more manual testing.

**Conditions:**
- Space Agent provider setup needs more manual verification
- You want to test OpenRouter, local Gemma, or Gemini native API manually
- You want to document provider test results (no secrets)

**What it does:**
- Manual provider/model testing in Space Agent UI
- Human enters secrets manually (not recorded in repo)
- Saves test notes to `~/offload/security-reports/manual/`
- Does **NOT** grant Space Agent repo edit access
- Does **NOT** modify `~/conf/onscreen-agent.yaml`

**Prerequisite:** Phase 8C ✅ (Workspace workflows defined)

**Note:** Phase 8C workspace workflows are already complete. Only run 8C.1 if additional manual verification is specifically needed.

---

### Run 8D.1 only if:
**Goal:** Verify workflow docs, links, templates, and roadmap references for consistency.

**Conditions:**
- You want to verify all workflow documents are consistent
- You want to check all cross-references and links work
- You want to validate roadmap reflects all Phase 8 completions

**What it does:**
- Documentation-only consistency check
- Verifies workflow docs exist and match roadmap
- Verifies templates are referenced correctly
- Checks all cross-document links
- Does **NOT** run any workflow execution
- Does **NOT** enable autonomy

**Prompt:** `prompts/opencode/phase8d1-workflow-index-verification.prompt.txt` (to be created)

**Prerequisite:** Phase 8D closeout ✅

---

### Run 8B.7 only if:
**Goal:** Evaluate supervised RuVector RAG integration after helper hardening.

**Conditions:**
- Phase 8B.6B answerability calibration is complete
- `gemma-memory-search` reports direct evidence, confidence, and fallback status
- Stage 3A remains deterministic fallback/comparison baseline
- No autonomous learning, ingestion, or production default replacement is requested

**What it does:**
- Supervised integration planning/testing only
- Keeps existing `gemma-knowledge-search` and `gemma-knowledge-rag` defaults unchanged unless a future prompt explicitly authorizes a bounded change
- Does **NOT** enable autonomous memory or production default promotion

**Prerequisite:** Phase 8B.6B ✅ and Phase 8D.1 verification reviewed

---

### Do NOT run 8B.5 unless:
**Goal:** Review production promotion gate for RuVector.

**CRITICAL CONDITIONS (all must be true):**
1. **8B.4 dry-run has been executed**
2. **Dry-run results justify promotion review** (enough gates pass)
3. **Human explicitly requests promotion review**

**What it does:**
- Documentation-only (does **NOT** promote RuVector)
- Defines promotion checklist (all 8 gates must PASS)
- Requires explicit human approval for promotion
- Confirms Stage 3A fallback remains even after promotion

**Prompt:** `prompts/opencode/phase8b5-memory-production-promotion-review.prompt.txt` (already exists)

**Prerequisite:** 8B.4 dry-run results justify promotion review

**IMPORTANT:** RuVector stays prototype until explicit human approval in a **future** phase. Phase 8B.5 is documentation-only — no promotion executed.

---

### Do NOT begin Phase 9 until:
**Goal:** Plan Memory & Training Loop (future phases).

**Conditions (all must be true):**
1. **Phase 8B.4 dry-run is complete**
2. **Phase 8D closeout is reviewed**
3. **Human is ready to move to planning**

**What it does:**
- Planning-only, no autonomy enabled
- No production memory promotion
- No autonomy or production memory enabled
- Prepares for future Phase 9A (Learning Integration), 9B, etc.

**Prompt:** `prompts/opencode/phase9-planning.prompt.txt` (to be created)

**Prerequisite:** After 8B.4 dry-run and 8D closeout reviewed

---

## Decision Flowchart

```
Start
  │
  ▼
What is your goal?
  │
  ├─► Test RuVector quality? ───► Run 8B.4 (dry-run)
  │
  ├─► More Space Agent testing? ─► Run 8C.1 (manual only)
  │
  ├─► Check doc consistency? ──► Run 8D.1 (doc-only)
  │
  ├─► Review promotion? ──► CHECK: 8B.4 done + justifies it?
  │                  │
  │                  ├─ YES ──► Run 8B.5 (doc-only, NO promotion)
  │                  │
  │                  └─ NO ──► Run 8B.4 first
  │
  └─► Plan next phases? ──► CHECK: 8B.4 + 8D done?
                     │
                     ├─ YES ──► Run Phase 9 (planning-only)
                     │
                     └─ NO ──► Complete 8B.4 + 8D first
```

---

## Recommended Operating Order

1. **8D.1** — Workflow index verification (doc-only)
2. **8B.7** — Supervised RuVector RAG integration, if repo hygiene is acceptable
3. **9** — Planning only after supervised integration verification and explicit human approval

**Do NOT enable autonomous learning or production default promotion.** RuVector remains supervised/non-default and Stage 3A remains the deterministic fallback/comparison baseline.

---

## Phase Status Quick Reference

| Phase | Name | Status | Production? |
|-------|------|--------|-------------|
| 8A | Agent Zero Workflow Library | ✅ Complete | Defined, not executed |
| 8A.1 | Repo Briefing Workflow | ✅ Complete | Defined, not executed |
| 8A.2 | Validation Orchestration | ✅ Complete | Defined, not executed |
| 8B | Memory Workflow Library | ✅ Complete | Defined, prototype-only |
| 8B.1 | Memory Query Workflow | ✅ Complete | Defined, prototype-only |
| 8B.2 | Memory Ingestion Review | ✅ Complete | Defined, prototype-only |
| 8B.3 | Memory Quality Validation | ✅ Complete | Defined, prototype-only |
| 8B.4 | Memory Quality Dry-Run | ✅ Complete | Bounded validation |
| 8B.4A-8B.4E | Quality hardening and Gate 5 | ✅ Complete | Validation only |
| 8B.5 | Production Promotion Review | ✅ Complete | Approved secondary, not default |
| 8B.6 | Primary Supervised RuVector Search | ✅ Complete | Supervised helper only |
| 8B.6A | Helper Hardening | ✅ Complete | Comparison/recommendation logic |
| 8B.6B | Answerability Calibration | ✅ Complete | Direct-evidence gating |
| 8B.7 | Supervised RuVector RAG Integration | ⏳ Upcoming | Supervised only |
| 8C | Space Agent Workspace Library | ✅ Complete | Defined, manual-only |
| 8D | Workflow Library Closeout | ✅ Complete | Doc-only, no execution |
| 8D.1 | Workflow Index Verification | ⏳ Current | Doc-only consistency check |
| 9 | Planning | ⏳ Future | Planning-only |

---

## Related Documents

- Master Index: `docs/workflows/WORKFLOW_LIBRARY_INDEX.md`
- Phase 8 Closeout: `docs/workflows/PHASE8_WORKFLOW_CLOSEOUT.md`
- Boundary Matrix: `docs/workflows/WORKFLOW_BOUNDARY_MATRIX.md`
- Roadmap: `docs/roadmap/ROADMAP.md`
- Agent Zero Library: `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md`
- Memory Library: `docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md`
- Space Agent Library: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md`

---

*Guide version: 1.0*
*Phase: 8D*
*Status: Documentation-only — no phase execution*

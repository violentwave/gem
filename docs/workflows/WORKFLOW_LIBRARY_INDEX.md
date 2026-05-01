# Workflow Library Index (Master Index)

**Phase:** 8D — Workflow Library Closeout
**Status:** Master index for all L5/L6/L7 workflow libraries
**Scope:** Documentation-only — no workflow execution, no autonomous tasks

---

## Overview

This is the master index for all workflow libraries in the Bazzite Local AI Operations Stack Phase 8. It covers:

- **L5:** Agent Zero workflows (Phase 8A)
- **L6:** Memory workflows (Phase 8B)
- **L7:** Space Agent workspace workflows (Phase 8C)

All workflows are **documentation-only** in Phase 8. No autonomous execution, no production promotion, no repo edits.

---

## Capability Level Map

| Level | Component | Library | Status |
|-------|-----------|---------|--------|
| **L5** | Agent Zero | `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md` | Defined, not executed |
| **L6** | RuVector Memory | `docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md` | Defined, prototype-only |
| **L7** | Space Agent | `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` | Defined, manual-only |

---

## Completed Workflow List

### L5 — Agent Zero Workflows (Phase 8A ✅)

**Library:** `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md`
**Status:** Defined, not yet executed — requires explicit human authorization

| # | Workflow | Doc | Capability | Status |
|---|-----------|-----|-----------|--------|
| 1 | Read-Only Repo Briefing | `docs/workflows/agent-zero/WORKFLOW_8A1_REPO_BRIEFING.md` | L5 | Defined |
| 2 | Validation Orchestration | `docs/workflows/agent-zero/WORKFLOW_8A2_VALIDATION_ORCHESTRATION.md` | L5 | Defined |
| 3 | Supervised Task Execution | (in library) | L5 | Defined |
| 4 | Multi-Agent Coordination | (in library) | L5 | Defined |
| 5 | Audit Log Review | (in library) | L5 | Defined |

**Boundaries:**
- No autonomous execution in Phase 8A
- Human approval required for all A0 tasks
- `~/projects/gem` repo edits only via OpenCode (not A0 directly)
- No A0 connector tasks run in Phase 8

**Checklist:** `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_CHECKLIST.md`
**Boundaries:** `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_BOUNDARIES.md`

---

### L6 — Memory Workflows (Phase 8B ✅)

**Library:** `docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md`
**Status:** Defined, RuVector remains supervised-only/non-default — Stage 3A is canonical fallback

| # | Workflow | Doc | Capability | Status |
|---|-----------|-----|-----------|--------|
| 1 | Semantic Context Lookup | `docs/workflows/memory/WORKFLOW_8B1_MEMORY_QUERY.md` | L6 | Defined |
| 2 | Memory Ingestion Review | `docs/workflows/memory/WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md` | L6 | Defined |
| 3 | Memory Quality Validation | `docs/workflows/memory/WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` | L6 | Defined |
| 4 | Primary Supervised RuVector Search | `docs/workflows/memory/WORKFLOW_8B6_PRIMARY_SUPERVISED_RUVECTOR_SEARCH.md` | L6 | Defined, supervised-only |

**Quality Gates (Gate 1-8):** `docs/workflows/memory/MEMORY_QUALITY_GATES.md`
**Checklists:**
- `docs/workflows/memory/MEMORY_QUERY_CHECKLIST.md`
- `docs/workflows/memory/MEMORY_INGESTION_REVIEW_CHECKLIST.md`
- `docs/workflows/memory/MEMORY_QUALITY_VALIDATION_CHECKLIST.md`

**Boundaries:**
- RuVector is prototype-only — no production promotion in Phase 8B
- Stage 3A remains canonical fallback for all memory operations
- `gemma-memory-search` may use RuVector as supervised primary retrieval with Stage 3A fallback/comparison, but wrapper defaults are unchanged
- No autonomous memory ingestion
- No secrets, `.env` files, raw logs, or private data ingested
- Gate 2 validation requires: `gemma-evals-status`, `gemma-evals-check`, `gemma-examples-check` all PASS

---

### L7 — Space Agent Workspace Workflows (Phase 8C ✅)

**Library:** `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md`
**Status:** Defined, **manual UI only** — no autonomous tasks

| # | Workflow | Doc | Capability | Status |
|---|-----------|-----|-----------|--------|
| 1 | Workspace Task Definition | (in library) | L7 | Defined |
| 2 | Provider/Model Configuration | (in library) | L7 | Defined |
| 3 | Workspace State Inspection | (in library) | L7 | Defined |
| 4 | Manual Task Execution | (in library) | L7 | Defined |
| 5 | Workspace Reporting | (in library) | L7 | Defined |

**Checklist:** `docs/workflows/space-agent/WORKSPACE_CHECKLIST.md`

**Boundaries:**
- Space Agent does **NOT** have `~/projects/gem` repo edit access
- `~/conf/onscreen-agent.yaml` is **NOT** created or edited by this repo
- All provider secrets entered **manually by human** in UI
- No autonomous Space Agent tasks
- No `~/projects/gem` repo edits by Space Agent
- Approved output path: `~/offload/security-reports/manual/`

---

## Associated Templates

| Template | Path | Used By |
|-----------|------|---------|
| Agent Zero workflow template | `docs/workflows/templates/agent-zero-workflow-template.md` | L5 workflows |
| Repo briefing output template | `docs/workflows/templates/repo-briefing-output-template.md` | 8A.1 |
| Validation summary output template | `docs/workflows/templates/validation-summary-output-template.md` | 8A.2 |
| Memory query output template | `docs/workflows/templates/memory-query-output-template.md` | 8B.1 |
| Memory ingestion review template | `docs/workflows/templates/memory-ingestion-review-template.md` | 8B.2 |
| Memory quality validation template | `docs/workflows/templates/memory-quality-validation-output-template.md` | 8B.3 |
| Space Agent workspace template | `docs/workflows/templates/space-agent-workspace-template.md` | L7 workflows |

---

## Associated Checklists

| Checklist | Path | Used By |
|-----------|------|---------|
| Agent Zero workflow checklist | `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_CHECKLIST.md` | L5 workflows |
| Memory query checklist | `docs/workflows/memory/MEMORY_QUERY_CHECKLIST.md` | 8B.1 |
| Memory ingestion review checklist | `docs/workflows/memory/MEMORY_INGESTION_REVIEW_CHECKLIST.md` | 8B.2 |
| Memory quality validation checklist | `docs/workflows/memory/MEMORY_QUALITY_VALIDATION_CHECKLIST.md` | 8B.3 |
| Space Agent workspace checklist | `docs/workflows/space-agent/WORKSPACE_CHECKLIST.md` | L7 workflows |

---

## Allowed Components by Workflow Family

| Component | L5 (A0) | L6 (Memory) | L7 (Space Agent) |
|-----------|-----------|-------------|------------------|
| Agent Zero | Primary (future) | Secondary | Secondary (display only) |
| OpenCode | Implementation | Implementation | Prompt staging (read-only) |
| RuVector | Secondary | Primary (prototype) | Display only |
| Space Agent | Display only | Display only | Primary (manual UI) |
| Gemma Wrappers | Advisory | Advisory | Manual chat |
| Stage 3A RAG | Fallback | Fallback | Fallback |
| Human | Approval authority | Approval authority | Approval authority |

---

## Forbidden Actions by Workflow Family

| Action | L5 (A0) | L6 (Memory) | L7 (Space Agent) |
|--------|-----------|-------------|------------------|
| Autonomous task execution | ❌ Not in Phase 8 | ❌ Not in Phase 8 | ❌ Never |
| `~/projects/gem` repo edits | ❌ Via A0 | ❌ Not allowed | ❌ Not allowed |
| `~/conf/onscreen-agent.yaml` edit | ❌ Not by repo | ❌ Not by repo | ❌ Not by repo |
| Secret ingestion | ❌ Not allowed | ❌ Not allowed | ❌ Not allowed |
| Autonomous memory promotion | N/A | ❌ Not in Phase 8 | N/A |
| Sudo/package installs | ❌ Not allowed | ❌ Not allowed | ❌ Not allowed |
| Model downloads | ❌ Not allowed | ❌ Not allowed | ❌ Not allowed |

---

## Next Executable/Dry-Run Phases

| Phase | Name | Type | Prerequisite |
|-------|------|------|-------------|
| **8D.1** | Workflow Index Verification | Doc-only consistency check | Phase 8D closeout ✅ |
| **8B.7** | Supervised RuVector RAG Integration | Future supervised integration only | 8B.6B answerability calibration ✅ |
| **9** | Planning | Planning-only, no autonomy enabled | After integration verification + hygiene review |

**Ordering Recommendation:**
1. 8D.1 — Workflow index verification (doc-only)
2. 8B.7 — Supervised RuVector RAG integration (if hygiene review is acceptable)
3. Phase 9 — Planning only after integration verification and explicit human approval

---

## Known Non-Production Statuses

| Component | Status | Fallback |
|-----------|--------|----------|
| Agent Zero workflows | Defined, not executed | OpenCode for implementation |
| RuVector | Semantic prototype only | Stage 3A deterministic RAG |
| Space Agent | Manual UI only | Terminal + Gemma wrappers |
| Stage 3A | Canonical fallback (L3) | Human for context |
| OpenCode | Implementation surface (L3) | Human implements |

---

## Related Documents

- Agent Zero Library: `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md`
- Memory Library: `docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md`
- Space Agent Library: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md`
- Boundary Matrix: `docs/workflows/WORKFLOW_BOUNDARY_MATRIX.md`
- Phase 8 Closeout: `docs/workflows/PHASE8_WORKFLOW_CLOSEOUT.md`
- Next Phase Guide: `docs/workflows/NEXT_PHASE_DECISION_GUIDE.md`
- Component Routing: `docs/architecture/COMPONENT_ROUTING_MATRIX.md`
- Data Flow Map: `docs/architecture/DATA_FLOW_AND_STATE_MAP.md`
- Unified Operator Layer: `docs/architecture/UNIFIED_OPERATOR_LAYER.md`
- Roadmap: `docs/roadmap/ROADMAP.md`
- Integration Decisions: `docs/integrations/INTEGRATION_DECISIONS.md`

---

*Index version: 1.0*
*Phase: 8D*
*Status: Documentation-only — no workflow execution*

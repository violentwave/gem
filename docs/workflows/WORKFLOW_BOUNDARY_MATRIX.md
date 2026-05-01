# Workflow Boundary Matrix

**Phase:** 8D — Workflow Library Closeout
**Status:** Compact matrix showing allowed/forbidden actions across all workflow families
**Scope:** Documentation-only — no workflow execution

---

## Matrix

| Action / Component | Agent Zero (L5) | Memory (L6) | Space Agent (L7) | OpenCode Prompts | Gemma Wrappers | Stage 3A Fallback | RuVector Prototype |
|----------------------|-------------------|----------------|---------------------|---------------------|------------------|-------------------|----------------------|
| **may read approved docs** | ✅ allowed | ✅ allowed | ✅ allowed | ✅ allowed | ✅ allowed | ✅ allowed (fallback) | ✅ allowed (prototype) |
| **may write reports** | ✅ `~/offload/security-reports/manual/` | ✅ `~/offload/security-reports/manual/` | ✅ `~/offload/security-reports/manual/` | ✅ `~/offload/security-reports/manual/` | ❌ not applicable | ❌ not applicable | ✅ (prototype output) |
| **may edit repo** | ❌ not by A0 (use OpenCode) | ❌ not allowed | ❌ not allowed | ✅ OpenCode only | ❌ not applicable | ❌ not applicable | ❌ not allowed |
| **may run validators** | ✅ gemma-evals-* (A0 coordinates) | ✅ gemma-evals-* (required for Gate 2) | ❌ not by Space Agent | ✅ OpenCode can run | ❌ not applicable | ❌ not applicable | ❌ not in Phase 8 |
| **may start Agent Zero** | ❌ not in Phase 8 | ❌ not in Phase 8 | ❌ not allowed | ❌ not applicable | ❌ not applicable | ❌ not applicable | ❌ not applicable |
| **may run A0 tasks** | ❌ not in Phase 8 | ❌ not in Phase 8 | ❌ not allowed | ❌ not applicable | ❌ not applicable | ❌ not applicable | ❌ not applicable |
| **may use Space Agent** | ✅ display only | ✅ display only | ✅ primary (manual UI) | ✅ prompt staging (read-only) | ✅ manual chat | ❌ not applicable | ❌ display only |
| **may ingest memory** | ❌ not in Phase 8 | ❌ not in Phase 8 | ❌ not allowed | ❌ not applicable | ❌ not applicable | ❌ not applicable | ❌ prototype only |
| **may promote memory** | N/A | ❌ not in Phase 8 (RuVector prototype) | N/A | N/A | N/A | N/A | ❌ not until explicit human approval |
| **may touch system config** | ❌ not allowed | ❌ not allowed | ❌ not allowed | ❌ not allowed | ❌ not applicable | ❌ not applicable | ❌ not allowed |
| **may access secrets** | ❌ not allowed | ❌ not allowed | ❌ not allowed (entered manually in UI) | ❌ not allowed | ❌ not applicable | ❌ not applicable | ❌ not allowed |

---

## Value Definitions

| Value | Meaning |
|-------|---------|
| ✅ **allowed** | Action permitted within defined boundaries |
| ❌ **not allowed** | Action explicitly prohibited |
| ❌ **not in Phase 8** | Action defined but not executed in Phase 8 (requires future phase) |
| ✅ **display only** | Component can display results but not execute |
| ✅ **primary (manual UI)** | Component is primary but manual-only, no autonomous tasks |
| ❌ **prototype only** | Action possible but only at prototype level, not production |
| ❌ **not applicable** | Action does not apply to this component |
| ✅ **OpenCode only** | Action allowed only via OpenCode (not directly by component) |
| ❌ **until explicit human approval** | Action requires explicit human approval in a future phase |

---

## Workflow Family Summaries

### Agent Zero (L5)
- **Status:** Defined, not executed in Phase 8
- **Allowed:** Read approved docs, write reports to `~/offload/security-reports/manual/`, coordinate validators (not run autonomously)
- **Forbidden:** Edit repo (use OpenCode), start A0, run A0 tasks, ingest memory, promote memory, touch system config, access secrets

### Memory (L6)
- **Status:** Defined, RuVector prototype-only
- **Allowed:** Read approved docs, write reports to `~/offload/security-reports/manual/`, run Gate 2 validators (required), display RuVector results
- **Forbidden:** Edit repo, ingest memory (Phase 8), promote memory (prototype), touch system config, access secrets
- **Fallback:** Stage 3A deterministic RAG always available

### Space Agent (L7)
- **Status:** Defined, manual UI only
- **Allowed:** Read approved docs, write reports to `~/offload/security-reports/manual/`, manual chat via UI, prompt staging (read-only)
- **Forbidden:** Edit repo, run validators, start A0, run A0 tasks, ingest memory, promote memory, touch system config, access secrets (entered manually in UI, not stored in repo)

### OpenCode Prompts
- **Status:** Active implementation surface (L3)
- **Allowed:** Read approved docs, write reports to `~/offload/security-reports/manual/`, edit repo (with human approval), run validators
- **Forbidden:** Touch system config, access secrets

### Gemma Wrappers
- **Status:** Advisory and RAG (L0-L2)
- **Allowed:** Read approved docs, advisory queries, RAG lookups
- **Forbidden:** Edit repo, ingest memory, promote memory, touch system config, access secrets

### Stage 3A Fallback
- **Status:** Canonical fallback (L3)
- **Allowed:** Deterministic keyword search, RAG lookups
- **Forbidden:** Autonomous ingestion, memory promotion, system config changes

### RuVector Prototype
- **Status:** Semantic prototype only (L6)
- **Allowed:** Prototype semantic retrieval, display results
- **Forbidden:** Production promotion (until explicit human approval), autonomous ingestion, system config changes

---

## Key Boundary Rules (All Workflow Families)

1. **No Autonomous Execution in Phase 8:** All workflows are documentation-only
2. **Human Approval Required:** All workflow operations require human approval
3. **Stage 3A Fallback:** Always available for memory queries
4. **No Repo Edits by A0/Space Agent:** OpenCode is the implementation surface
5. **No `~/conf/onscreen-agent.yaml` Edits:** Real config file, not modified by repo
6. **No Secret Ingestion:** Provider secrets entered manually in UI, not stored in repo
7. **Approved Output Path:** `~/offload/security-reports/manual/` only
8. **No Sudo/Package Installs/Model Downloads:** Not allowed in any workflow

---

## Related Documents

- Master Index: `docs/workflows/WORKFLOW_LIBRARY_INDEX.md`
- Phase 8 Closeout: `docs/workflows/PHASE8_WORKFLOW_CLOSEOUT.md`
- Next Phase Guide: `docs/workflows/NEXT_PHASE_DECISION_GUIDE.md`
- Agent Zero Library: `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md`
- Memory Library: `docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md`
- Space Agent Library: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md`
- Component Routing: `docs/architecture/COMPONENT_ROUTING_MATRIX.md`
- Roadmap: `docs/roadmap/ROADMAP.md`

---

*Matrix version: 1.0*
*Phase: 8D*
*Status: Documentation-only — no workflow execution*

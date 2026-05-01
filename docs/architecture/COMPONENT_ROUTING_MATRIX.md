# Component Routing Matrix

## Overview

This matrix defines which component handles which task in the Bazzite Local AI Operations Stack. It establishes clear responsibility boundaries while allowing fallback paths.

## Task-Component Matrix

| Task | Gemma Wrappers | Stage 3A RAG | RuVector | Agent Zero | A0 CLI | Space Agent | OpenCode | Human |
|------|-----------------|--------------|----------|-------------|--------|--------------|----------|-------|
| Bazzite advisory Q&A | **primary** | secondary | - | - | - | - | - | fallback |
| Local docs RAG | primary | **primary** | prototype | - | - | - | - | fallback |
| Command review | **primary** | secondary | - | - | - | - | - | fallback |
| Security report summary | **primary** | secondary | - | - | - | secondary | - | fallback |
| Repo briefing | **primary** | secondary | - | - | - | - | - | fallback |
| Code implementation | - | - | - | - | - | - | **primary** | approval |
| Repo edits | - | - | - | - | - | - | **primary** | approval |
| Validated patch generation | - | - | - | - | - | - | **primary** | approval |
| Long-term memory query | - | fallback | supervised primary via `gemma-memory-search` | - | - | secondary | - | fallback |
| Memory ingestion | - | - | prototype | - | - | secondary | - | approval |
| Agent Zero autonomous workflow | - | - | secondary | **primary** | secondary | secondary | secondary | approval |
| Space Agent workspace action | - | - | - | - | - | **primary** | - | fallback |
| OpenCode implementation prompt | - | - | - | - | - | - | **primary** | approval |
| System change proposal | - | - | - | - | - | - | - | **primary** |
| System change execution | - | - | - | - | - | - | - | **primary** |

## Component Definitions

### Components

| Component | Abbreviation | Description |
|-----------|--------------|-------------|
| Gemma Wrappers | GW | L0-L2: gemma-bazzite, gemma-knowledge-rag, etc. |
| Stage 3A RAG | RAG | Deterministic JSONL keyword search |
| RuVector | RV | L6: Scoped memory prototype working; semantic retrieval not production-ready |
| Agent Zero | A0 | L5: Multi-agent orchestration |
| A0 CLI Connector | CLI | Bridge between OpenCode and A0 |
| Space Agent | SA | L7: Workspace UI; OpenRouter and local Gemma/Ollama work, Gemini remains optional unresolved retry |
| OpenCode | OC | L3: Implementation engine |
| Human | H | User operator |

### Role Values

| Role | Meaning |
|------|---------|
| **primary** | Default handler for this task |
| secondary | Can handle if primary unavailable |
| fallback | Available but not optimal |
| future | Not yet implemented |
| prototype | Implemented only as a scoped prototype; not a primary production route |
| - | Not applicable |
| **not allowed** | Explicitly prohibited |

---

## Detailed Routing Rules

### Advisory Tasks (L0-L1)

**Bazzite advisory Q&A**
- Primary: Gemma Wrappers
- Secondary: Stage 3A RAG (for knowledge lookup)
- Fallback: Human answers
- Not allowed: Agent Zero autonomous

**Rule:** Advisory remains human-initiated. A0 does not auto-advise.

### Retrieval Tasks

**Local docs RAG**
- Primary: Stage 3A (deterministic)
- Secondary: Gemma Wrappers
- Prototype: RuVector (placeholder-vector retrieval only; not semantic primary)
- Fallback: Human provides context

**Rule:** Deterministic RAG is always available fallback. RuVector enhances but never replaces; Phase 7B does not promote RuVector to production semantic retrieval.

**Long-term memory query**
- Supervised primary: RuVector via `gemma-memory-search`
- Fallback/comparison: Stage 3A (if memories in knowledge pack)
- Fallback: Human recall
- Not allowed: Direct memory access without authorization

**Rule:** Memory queries require explicit authorization. `gemma-memory-search` must keep Stage 3A comparison/fallback, answerability confidence, and no autonomous ingestion/default replacement.

### Implementation Tasks (L3)

**Code implementation**
- Primary: OpenCode
- Fallback: Human implements
- Not allowed: A0 autonomous code writing

**Rule:** Implementation requires user approval. No autonomous code generation.

**Repo edits**
- Primary: OpenCode
- Fallback: Human edits
- Not allowed: A0 autonomous edits

**Rule:** All repo edits go through OpenCode with user review.

**Validated patch generation**
- Primary: OpenCode
- Requirement: Validation before commit
- Fallback: Human-generated patches

**Rule:** Patches must pass validators (gemma-evals-check, lsp_diagnostics).

### Orchestration Tasks (L5)

**Agent Zero autonomous workflow**
- Primary: Agent Zero
- Secondary: OpenCode (direct), Space Agent (UI)
- Approval: Human must authorize each task
- Fallback: OpenCode direct execution

**Rule:** A0 tasks require explicit authorization. No autonomous system changes.

### Workspace Tasks (L7)

**Space Agent workspace action**
- Primary: Space Agent
- Fallback: Terminal + wrappers
- Not allowed: Automatic browser actions without approval

**Rule:** Browser automation requires user approval. During Phase 7E.1, Space Agent is manual exploration only and must not edit `~/projects/gem` while OpenCode is active. OpenRouter and local Gemma/Ollama are verified working in Space Agent; Gemini remains optional unresolved retry, and direct `~/conf/onscreen-agent.yaml` edits remain out of scope.

**Phase 8C Workspace Workflows (L7, Manual-Only):**
- Workspace Task Definition: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 1)
- Provider/Model Configuration: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 2)
- Workspace State Inspection: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 3)
- Manual Task Execution: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 4)
- Workspace Reporting: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 5)
- Checklist: `docs/workflows/space-agent/WORKSPACE_CHECKLIST.md`
- Template: `docs/workflows/templates/space-agent-workspace-template.md`

**All L7 workflows are manual-only:**
- Space Agent does NOT have `~/projects/gem` repo edit access
- `~/conf/onscreen-agent.yaml` is NOT created or edited by repo
- No autonomous tasks defined or enabled
- All provider secrets entered manually by human in UI

### System Tasks (L8+)

**System change proposal**
- Primary: Human
- Secondary: Gemma (advisory only)
- Not allowed: A0, OpenCode, Space Agent

**Rule:** System changes are human-only. AI recommends, human decides.

**System change execution**
- Primary: Human
- Not allowed: Any AI component

**Rule:** System changes require sudo - never delegated to AI.

---

## Authorization Requirements

| Task Type | Authorization Required |
|-----------|----------------------|
| Advisory queries | Per-query (implicit) |
| RAG retrieval | Per-query (implicit) |
| Implementation | Per-task (explicit) |
| A0 workflow | Per-task (explicit) |
| Memory ingestion | Per-source (explicit) |
| System changes | Always human |

---

## Fallback Chains

### Advisory Fallback

```
Gemma Wrapper → Stage 3A RAG → Human Answer
     │
     │ (if fails)
     ▼
Stage 3A RAG → Gemma Wrapper → Human
```

### Implementation Fallback

```
OpenCode → Human Implementation
   │
   │ (if unavailable)
   ▼
Human implements directly
```

### Memory Fallback

```
RuVector → Stage 3A RAG → Human Context
   │
   │ (if fails)
   ▼
Stage 3A RAG → Human Context
```

### Orchestration Fallback

```
Agent Zero → OpenCode direct → Human
   │
   │ (if fails)
   ▼
OpenCode direct → Human
```

---

## Validation Matrix

| Task Category | Required Validator |
|---------------|-------------------|
| Advisory | None (pass-through) |
| RAG retrieval | gemma-evals-check |
| Implementation | lsp_diagnostics + tests |
| A0 workflow | Manual review + audit log |
| Memory ops | Access log |
| System changes | Human-only |

---

## Future Routing

As components mature, routing may evolve:

| Task | Current | Future |
|------|---------|--------|
| Semantic search | Stage 3A | RuVector primary |
| Memory recall | Stage 3A | RuVector primary |
| Complex workflow | OpenCode | Agent Zero + A0 |
| Visual interface | Terminal | Space Agent |
| Workspace UI | Terminal | Space Agent (L7 workflows defined in Phase 8C) |

**Rule:** Transitions require validation testing before switching primary.

**Phase 8C L7 Workflow References:**
- Workspace Task Definition: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 1)
- Provider/Model Configuration: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 2)
- Workspace State Inspection: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 3)
- Manual Task Execution: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 4)
- Workspace Reporting: `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (Workflow 5)

---

## Validation Commands

```bash
# Verify current routing
gemma-evals-status

# Check component availability
which gemma-bazzite
which opencode
ls ~/.local/bin/agent-zero-* 2>/dev/null

# Validate fallback chain
gemma-knowledge-rag "test query"
```

---

## Summary

The routing matrix ensures:
- Clear responsibility boundaries
- Explicit authorization at each level
- Fallback paths for resilience
- No unauthorized autonomous execution
- Human remains in control loop

See `UNIFIED_OPERATOR_LAYER.md` for detailed component relationships.

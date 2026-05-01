# Integration Decisions

## Overview

This document records explicit architectural decisions for the Bazzite Local AI Operations Stack integration. These decisions guide future implementation phases.

---

## Decision 1: Agent Zero as Operator Runtime

**Decision:** Agent Zero is the primary candidate for the operator runtime layer (L5).

**Rationale:**
- Multi-agent orchestration capability
- Container-based sandbox isolation
- A0 CLI connector available for OpenCode bridge
- Same organization as Space Agent (likely integration)
- Existing container image in system

**Constraints:**
- Must start container before use
- Requires verification in Phase 6A sandbox
- No autonomous execution until L5 fully validated

**Alternatives Considered:**
- Custom agent framework → Rejected (too much dev)
- Direct OpenCode orchestration → Rejected (limited multi-agent)
- No operator layer → Rejected (goal is full stack)

---

## Decision 2: RuVector as Memory/Retrieval Layer

**Decision:** RuVector is the primary candidate for supervised memory and semantic retrieval experiments (L6), but it is not a global default replacement for Stage 3A.

**Rationale:**
- High-performance vector operations
- Local-only operation (no external services)
- HNSW indexing with SIMD acceleration
- Memory graph capabilities
- Self-learning optional (can disable)
- No sudo required for npm install

**Constraints:**
- Must use approved source paths only
- No secret ingestion allowed
- Must fall back to Stage 3A if unavailable
- Current supervised helper use (`gemma-memory-search`) must preserve Stage 3A comparison/fallback and recommendation confidence
- No autonomous memory/learning or production default promotion without explicit future approval
- Requires verification in Phase 6B sandbox

**Alternatives Considered:**
- Pinecone/Weaviate cloud → Rejected (not local)
- pgvector only → Rejected (limited features)
- Continue Stage 3A only → Rejected (goal is enhancement)

---

## Decision 3: Space Agent as Workspace/UI

**Decision:** Space Agent is the primary candidate for workspace and UI layer (L7).

**Rationale:**
- Browser-first architecture
- Linux AppImage available
- Self-host option (localhost binding)
- Same organization as Agent Zero
- Desktop app for local operation

**Constraints:**
- Requires Electron (test on Bazzite)
- Not required for stack operation (fallback to terminal)
- Requires verification in Phase 6C sandbox

**Alternatives Considered:**
- Custom web UI → Rejected (too much dev)
- Terminal only → Rejected (goal is visual interface)
- Browser extension → Rejected (not desktop-focused)

---

## Decision 4: Gemma Wrappers Remain Local Tool Interface

**Decision:** Gemma wrappers continue serving as the local Bazzite-aware advisory interface.

**Rationale:**
- Already operational with custom Modelfile
- Bazzite/Fedora Atomic context embedded
- RAG via Stage 3A deterministic retrieval
- No external API dependencies
- User trust established through Stage 4 evals

**Constraints:**
- Not used for implementation (OpenCode handles)
- Not used for autonomous tasks (Agent Zero handles)
- Remains advisory only

**No change to:**
- Modelfile location
- Wrapper scripts
- RAG implementation

**Phase 8B.6B note:** `gemma-memory-search` is a separate supervised helper. Existing Gemma wrapper defaults remain unchanged; Stage 3A deterministic retrieval remains the fallback/comparison baseline.

---

## Decision 5: OpenCode/Codex Remains Implementation Engine

**Decision:** OpenCode/Codex continues handling all implementation work (L3).

**Rationale:**
- Already operational with MCPs
- User review required before commit
- Validation (lsp_diagnostics) before completion
- Not replaced by Agent Zero (complementary)

**Relationship to A0:**
- A0 may invoke OpenCode for code tasks
- OpenCode can fallback if A0 unavailable
- A0 does not bypass OpenCode for implementation

---

## Decision 6: Deterministic RAG Remains Fallback

**Decision:** Stage 3A deterministic JSONL RAG remains the fallback even if RuVector succeeds.

**Rationale:**
- Proven reliable (Stage 4 validation)
- No embeddings required
- Keyword-based (deterministic)
- Always available (no service needed)
- Baseline retrieval capability

**Implementation:**
- RuVector enhances, never replaces
- If RuVector unavailable → Stage 3A
- If RuVector fails → Stage 3A
- Both can coexist

---

## Decision 7: Stage 4 Evals/Examples Remain Quality Gates

**Decision:** Stage 4 eval cases and supervised examples continue as quality validation.

**Rationale:**
- 19 eval cases for regression testing
- 22 reviewed examples (100%)
- Validators passing (gemma-evals-check, gemma-examples-check)
- Established baseline for quality

**Usage:**
- Any component change → Run evals
- Any integration → Verify examples
- Regression detection → Compare results

---

## Decision 8: No Full Trust Jump - Autonomy Graduates by Level

**Decision:** No component receives full trust. Autonomy progresses by validated level.

**Progression:**
```
L0-L2: Advisory (implicit trust, no changes)
L3: Implementation (explicit per-task, review required)
L4: Orchestration (MCPs, tool-specific permissions)
L5: Agent Zero (sandboxed, audit logged, fallback ready)
L6: RuVector (scoped access, no secrets, fallback ready)
L7: Space Agent (browser-level, user approval required)
L8: Supervised (human-in-loop, explicit approval)
L9: Full autonomy (supervised, override available)
```

**Validation gates:**
- Each level requires proofs before transition
- Rollback must be tested before proceeding
- Fallback chain always maintained

---

## Decision 9: Sandbox-First Integration

**Decision:** All components tested in sandbox before live integration.

**Phase mapping:**
- Phase 6A: Agent Zero sandbox
- Phase 6B: RuVector sandbox
- Phase 6C: Space Agent sandbox
- Phase 6D: Integration smoke test
- Phase 7A-C: Live integration (after sandbox)

**No live integration without:**
- Sandbox tests passing
- Security validation
- Fallback confirmed

---

## Decision 10: Read-Only Assessment Before Action

**Decision:** All integration phases begin with read-only assessment.

**Assessment phases:**
- Phase 5C: Agent Zero inventory (read-only)
- Phase 5D: RuVector assessment (research only)
- Phase 5E: Space Agent assessment (research only)
- Phase 5F: Integration design (documentation only)

**No installation in assessment phases.**

---

## Decisions Not Made Yet

These require Phase 6 sandbox results:

| Decision | Depends On |
|-----------|------------|
| A0 CLI connector exact interface | Phase 6A |
| RuVector install method | Phase 6B |
| Space Agent integration approach | Phase 6C |
| Full operator mode enablement | Phase 6D + 7A |

---

## Review Schedule

These decisions should be reviewed:
- After each Phase 6 sandbox completion
- At Phase 7 gate (before live integration)
- Annually for relevance

---

## Summary

| Decision | Component | Status |
|----------|-----------|--------|
| 1 | Agent Zero | L5 candidate |
| 2 | RuVector | L6 candidate |
| 3 | Space Agent | L7 candidate |
| 4 | Gemma Wrappers | Unchanged |
| 5 | OpenCode | Unchanged |
| 6 | Deterministic RAG | Fallback confirmed |
| 7 | Stage 4 evals | Quality gates |
| 8 | Gradual autonomy | By level |
| 9 | Sandbox-first | Enforced |
| 10 | Read-only first | Enforced |

See `ROADMAP.md` for implementation timeline.

---

## Phase 7D Smoke Test Outcome

**Decision:** `phase7_smoke_passed_with_manual_space_agent_confirmation_pending`

**Implications:**
- Agent Zero/A0 connector works but autonomous tasks remain disabled unless explicitly approved.
- RuVector semantic prototype works with scoped approved sources but is not production semantic memory.
- Stage 3A deterministic retrieval remains the canonical fallback.
- Space Agent can run manually, but exact non-secret provider result still needs user confirmation.
- Phase 8 workflow-library design can proceed without broad host access or production autonomy.

---

## Decision 8: Phase 8 Workflow Libraries Closed Out

**Decision:** All Phase 8 workflow libraries (8A Agent Zero L5, 8B Memory L6, 8C Space Agent L7) are defined but not executed. No production autonomy enabled.

**Details:**
- Phase 8A: 5 L5 Agent Zero workflows defined (read-only repo briefing, validation orchestration, supervised task execution, multi-agent coordination, audit log review)
- Phase 8B: 7 L6 Memory workflows defined (semantic context lookup, memory ingestion review, memory quality validation, +4 more)
- Phase 8B.3: All 8 quality gates documented (Gate 1-8), 5 failure handling categories, promotion checklist
- Phase 8C: 5 L7 Space Agent workspace workflows defined (manual-only, no autonomous tasks)
- Phase 8D: Closeout complete (master index, closeout doc, boundary matrix, next phase guide)

**Constraints:**
- All workflows are documentation-only in Phase 8
- No Agent Zero workflows executed
- RuVector remains prototype-only (no production promotion)
- Space Agent is manual UI only (no autonomous tasks)
- Stage 3A remains canonical fallback
- No `~/projects/gem` repo edits by Space Agent
- `~/conf/onscreen-agent.yaml` NOT created or edited by repo
- All provider secrets entered manually by human in UI

**Next Phases:**
- Run 8B.4 (memory quality dry-run) if testing RuVector quality
- Run 8D.1 (workflow index verification) for doc consistency check
- Run 8B.5 (production promotion review) ONLY if 8B.4 justifies it
- Phase 9 planning only after dry-runs and closeout reviewed

See `docs/workflows/WORKFLOW_LIBRARY_INDEX.md` for master index.
See `docs/workflows/PHASE8_WORKFLOW_CLOSEOUT.md` for closeout summary.
See `docs/workflows/WORKFLOW_BOUNDARY_MATRIX.md` for boundary matrix.
See `docs/workflows/NEXT_PHASE_DECISION_GUIDE.md` for next phase guide.

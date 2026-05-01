# Bazzite Local AI Operations Stack

**Repo Path:** `~/projects/gem`

## Purpose

This is the coordination repository for the broader Bazzite Local AI Operations Stack. It tracks architecture, prompts, inventory summaries, and integration plans for local AI tooling.

This repo does **not** replace live canonical files. It coordinates them.

## What This Repo Tracks

- **Architecture & Design:** System architecture, capability levels, integration patterns
- **Planning:** Roadmaps, integration plans, assessment documents
- **Prompts:** OpenCode/Codex prompts for future phases
- **Inventory:** Sanitized summaries of live system state
- **Documentation:** Current state, canonical paths, operational notes

## Live Canonical Paths (Source of Truth)

These paths remain the live system source-of-truth and are not moved:

- `~/.config/bazzite-security/` - Config docs, policies, runbooks
- `~/.local/bin/` - Helper scripts (gemma-*, bazzite-*)
- `~/.local/share/bazzite-security/` - Persistent state, evals, knowledge packs
- `~/.local/state/bazzite-security/logs/` - Logs
- `~/.cache/bazzite-security/` - Runtime cache
- `~/offload/security-reports/` - Generated reports

## Current Completed State

### Stage 1: Profile Teaching
- Custom Gemma profile with Bazzite/Fedora Atomic context
- Location: `~/.config/bazzite-security/ollama/Modelfile.gemma4-e4b-bazzite`

### Stage 2: Curated Knowledge Pack
- Approved docs copied to knowledge pack
- RAG-enabled via deterministic retrieval

### Stage 3A: Deterministic Retrieval
- JSONL chunk index
- Keyword-based search (no embeddings)
- Bounded RAG queries

### Stage 4A-G: Eval & Example System
- 19 eval cases for regression testing
- 22 supervised examples (100% reviewed)
- Status reporting, draft review, validation tools
- All validators passing

## Current Phase: Phase 5F ✅ Complete

### Phase 5A: Repo Bootstrap ✅
- Create coordination repo (this work)
- Bootstrap documentation structure
- Create inventory and planning artifacts

### Phase 5B: Architecture Expansion ✅
- Define integration architecture
- Document capability levels
- Plan progressive expansion

### Phase 5C: Agent Zero Inventory ✅
- Verify A0 installation
- Assess connector state
- Plan integration approach

### Phase 5D: RuVector Assessment ✅
- Review RuVector architecture
- Assess local-only operation feasibility
- Plan integration or alternative

### Phase 5E: Space Agent Assessment ✅
- Research Space Agent availability
- Assess Linux/Bazzite compatibility
- Plan integration approach

### Phase 5F: Integration Design ✅
- Unified operator layer design
- Component routing matrix
- Data flow and state map
- Autonomy graduation plan
- Phase 6 sandbox plan
- Integration decisions documented

## Operating Model

### Current State
- **Gemma wrappers:** L1 advisory, L2 report writing, RAG queries
- **OpenCode/Codex:** Implementation work, repo operations
- **Agent Zero:** Not yet integrated (assessment phase)
- **RuVector:** Not yet integrated (assessment phase)
- **Space Agent:** Not yet integrated (assessment phase)

### Future Goal
Progressive local AI operations platform spanning:
- Advisory models (Gemma)
- Implementation agents (OpenCode)
- Operator layer (Agent Zero)
- Memory/vector layer (RuVector)
- Workspace UI (Space Agent)

## Safe Validation Commands

```bash
# Check repo structure
find ~/projects/gem -type f -name "*.md" | head -20

# Run validators
gemma-examples-check
gemma-evals-check
gemma-evals-status

# Check inventory
ls -la ~/projects/gem/inventory/

# Check git status
cd ~/projects/gem && git status --short
```

## Security Boundaries

- No secrets in repo
- No `.env` files
- No raw logs
- No private code
- No browser data
- Runtime artifacts stay in canonical paths

## Next Steps

See `docs/roadmap/ROADMAP.md` for full roadmap.

### Phase 6: Sandbox Prototypes (Upcoming)
- Phase 6A: Agent Zero sandbox
- Phase 6B: RuVector sandbox
- Phase 6C: Space Agent sandbox
- Phase 6D: Integration smoke test

See `docs/roadmap/PHASE6_SANDBOX_PLAN.md` for details.

## License

Internal project documentation. Not for distribution.

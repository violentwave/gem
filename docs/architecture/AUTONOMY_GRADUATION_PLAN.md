# Autonomy Graduation Plan

## Overview

This document defines the progressive autonomy levels for the Bazzite Local AI Operations Stack. Each level builds on the previous with explicit validation gates, required proofs, and rollback expectations.

The goal is to enable comprehensive local AI operations while maintaining human control and staged validation.

---

## Level Progression Overview

| Level | Name | Current Status | Next Trigger |
|-------|------|-----------------|--------------|
| L0 | Advisory Model | ✅ Operational | - |
| L1 | Report Writer | ✅ Operational | - |
| L2 | User Config/Docs Editor | ✅ Operational | - |
| L3 | Project Repo Operator | ✅ Operational | - |
| L4 | Tool Orchestrator | ⚡ Partial (MCPs) | Phase 6D |
| L5 | Agent Zero Operator | ⏳ Assessment | Phase 6A sandbox |
| L6 | RuVector Memory Operator | ⏳ Assessment | Phase 6B sandbox |
| L7 | Space Agent Workspace | ⏳ Assessment | Phase 6C sandbox |
| L8 | Supervised System Operator | 🔜 Future | Phase 7+ |
| L9 | High-Authority Local Operator | 🔜 Future | Phase 9 |

---

## L0: Advisory Model

### Description
Basic chat and advisory interactions with Gemma.

### Allowed Capabilities
- General Q&A about Bazzite/Fedora Atomic
- Policy explanation and guidance
- Path and tool recommendations
- Safety recommendations

### Not Allowed
- File modifications
- Command execution
- System changes
- External tool invocations

### Required Validators
- None (pass-through queries)

### Required Logs/Reports
- None (ephemeral interactions)

### Rollback Expectations
- N/A (stateless)

### Progression Requirements
- Already operational
- No additional proof required

---

## L1: Report Writer

### Description
Generate structured reports from data using Gemma wrappers.

### Allowed Capabilities
- Summarize security reports
- Analyze file contents
- Review command safety
- Knowledge RAG queries

### Required Validators
- None (user reviews output)

### Required Logs/Reports
- Report output (optional, in ~/offload/security-reports/)

### Rollback Expectations
- Re-run with different parameters

### Progression Requirements
- Already operational

---

## L2: User Config/Docs Editor

### Description
Read and analyze user config and documentation, suggest changes.

### Allowed Capabilities
- Read files in user paths (~/.config, ~/.local)
- Analyze documentation
- Review repository state
- Suggest config changes (not implement)

### Required Validators
- None (suggestions only, user implements)

### Required Logs/Reports
- None

### Rollback Expectations
- N/A (no changes made)

### Progression Requirements
- Already operational

---

## L3: Project Repo Operator

### Description
Implement changes in project repositories via OpenCode.

### Allowed Capabilities
- Edit files in project repos
- Create documentation
- Update configurations
- Run safe validation commands

### Required Validators
- `lsp_diagnostics` clean on changed files
- Build passes (if applicable)
- Tests pass (if applicable)

### Required Logs/Reports
- Git commit history with messages
- Validation output in terminal

### Rollback Expectations
- Git revert available for any commit

### Progression Requirements
- Already operational
- Validation chain proven

---

## L4: Tool Orchestrator

### Description
Coordinate multiple tools and MCPs via OpenCode.

### Allowed Capabilities
- MCP server invocation
- Tool registry operations
- Multi-tool workflows
- Skill system execution

### Required Validators
- MCP health checks
- Skill execution logs

### Required Logs/Reports
- MCP call logs
- Tool execution audit

### Rollback Expectations
- Disable problematic MCP
- Revert skill changes

### Current Gaps
- A0 MCP not yet integrated
- RuVector MCP not yet integrated

### Progression Requirements
- Complete Phase 6D integration smoke
- Verify MCP coexistence

---

## L5: Agent Zero Operator

### Description
Multi-agent orchestration layer via Agent Zero.

### Allowed Capabilities
- Spawn and coordinate agents
- Define agent skills
- Agent-to-agent communication
- A0 CLI connector to OpenCode

### Required Validators
- Sandbox isolation confirmed
- Agent timeout handling verified
- Fallback to OpenCode tested

### Required Logs/Reports
- Agent spawn/done logs
- Task audit trail
- Error reports with context

### Rollback Expectations
- Stop agent container
- Fallback to OpenCode direct
- Clear agent state

### Progression Requirements
- Phase 6A sandbox passes
- Phase 7A integration complete
- Security audit passed
- Fallback tested

### Proofs Required
- [ ] Container starts and responds
- [ ] Agent spawns without host access
- [ ] Task completes with audit log
- [ ] Fallback to OpenCode works
- [ ] Timeout handling works

---

## L6: RuVector Memory Operator

### Description
Vector database and memory system via RuVector.

### Allowed Capabilities
- HNSW vector indexing (approved sources)
- Semantic search
- Memory graphs
- Hybrid search (BM25 + vector)
- Optional self-learning

### Required Validators
- Index integrity checks
- Query accuracy tests
- Fallback to Stage 3A verified

### Required Logs/Reports
- Ingestion audit trail
- Query performance metrics
- Memory size tracking

### Rollback Expectations
- Disable RuVector
- Fallback to Stage 3A RAG
- Clear vector store

### Progression Requirements
- Phase 6B sandbox passes
- Phase 7B integration complete
- Local-only operation confirmed
- No external API calls

### Proofs Required
- [ ] npm package installs without sudo
- [ ] Index builds from approved docs
- [ ] Semantic search works
- [ ] Fallback to Stage 3A works
- [ ] No secrets ingested

---

## L7: Space Agent Workspace

### Description
Multi-workspace UI and browser agent via Space Agent.

### Allowed Capabilities
- Browser automation
- Workspace management
- Task queue
- Visual UI interactions

### Required Validators
- Linux compatibility confirmed
- Browser isolation verified
- Fallback to terminal tested

### Required Logs/Reports
- Task queue logs
- Browser action audit

### Rollback Expectations
- Close Space Agent
- Use terminal interface

### Progression Requirements
- Phase 6C sandbox passes
- Phase 7C integration complete
- Linux/Bazzite compatibility confirmed

### Proofs Required
- [ ] AppImage runs on Bazzite
- [ ] Workspace creation works
- [ ] Browser automation functional
- [ ] Fallback to terminal works

---

## L8: Supervised System Operator

### Description
Coordinated system operations with human oversight.

### Allowed Capabilities
- System-level changes with explicit review
- Package management proposals
- Service management proposals
- Security policy updates (proposed)

### Not Allowed
- Automatic system changes
- sudo execution
- Firewall changes

### Required Validators
- Human review of every change
- Rollback plan documented
- Audit trail complete

### Required Logs/Reports
- System change proposals
- Human approvals
- Rollback documentation

### Rollback Expectations
- rpm-ostree rollback
- System restore from backup

### Progression Requirements
- L5-L7 fully operational
- L8 human review process defined
- Rollback capabilities tested

### Proofs Required
- [ ] Change proposal workflow defined
- [ ] Human approval process implemented
- [ ] Rollback tested in staging

---

## L9: High-Authority Local Operator

### Description
Full local AI operations platform with supervised autonomy.

### Allowed Capabilities
- Comprehensive local AI operations
- Autonomous planning (with supervision)
- Continuous learning (scoped)
- Full stack integration

### Authorization
- Supervised autonomy with user override
- Learning scoped to authorized data
- Full audit trail

### Required Validators
- Full stack validation passed
- Safety mechanisms proven
- User override tested

### Required Logs/Reports
- Complete system audit
- Learning system logs
- Override test results

### Progression Requirements
- Phase 9B complete
- Security audit passed
- Performance validated
- Documentation complete

---

## Graduation Criteria Summary

| Level | Validators Required | Proofs Required | Rollback |
|-------|--------------------|--------------------|---------|
| L0-L3 | Pass (built-in) | Operational | Git revert |
| L4 | MCP health | Coexistence verified | Disable MCP |
| L5 | Sandbox + audit | 5 proofs | Stop container |
| L6 | Index + fallback | 5 proofs | Disable + Stage 3A |
| L7 | Linux + isolation | 4 proofs | Terminal fallback |
| L8 | Human review | Process defined | rpm-ostree |
| L9 | Full audit | Complete validation | Full restore |

---

## Progression Rules

1. **No skipping:** Must pass each level before advancing
2. **Explicit authorization:** User must opt-in to each new level
3. **Validation gates:** Must prove capabilities before transition
4. **Rollback ready:** Must have tested rollback before proceeding
5. **Fallback maintained:** Lower levels always remain functional

---

## Current Position

```
Completed: L0, L1, L2, L3 ✅
Current:   L4 (partial), L5-L7 (assessment) ⏳
Next:      L4 completion (Phase 6D), L5-L7 sandbox (Phase 6)
Future:    L8, L9
```

---

## Validation Commands

```bash
# Check current level status
gemma-evals-status
gemma-examples-check

# Check pending validations
gemma-bazzite-health
opencode --version

# Check upgrade path readiness
cat ~/projects/gem/docs/roadmap/ROADMAP.md | grep "Phase 6"
```

---

## Summary

The autonomy graduation plan ensures:
- Staged capability progression
- Explicit validation at each level
- Tested rollback capabilities
- Human control maintained
- No unauthorized autonomous execution

See `ROADMAP.md` for phase-by-phase progression.

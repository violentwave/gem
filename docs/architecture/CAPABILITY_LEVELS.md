# Capability Levels

## Overview

The Bazzite Local AI Operations Stack defines 10 capability levels (L0-L9) representing progressive operational authority. Each level builds on the previous, with explicit authorization gates.

## L0: Advisory Model

**Description:** Basic chat and advisory interactions

**Capabilities:**
- General Q&A about Bazzite/Fedora Atomic
- Policy explanation
- Path guidance
- Safety recommendations

**Components:**
- `gemma-bazzite` - Interactive chat
- `gemma-bazzite-health` - System health check
- `gemma-knowledge-check` - Knowledge pack validation

**Authorization:** User initiates each query

**Current Status:** ✅ Operational

## L1: Report Writer

**Description:** Generate structured reports from data

**Capabilities:**
- Summarize security reports
- Analyze file contents
- Review command safety
- Knowledge RAG queries

**Components:**
- `gemma-security-summary` - Security report analysis
- `gemma-file-brief` - File summarization
- `gemma-knowledge-rag` - RAG-based answers
- `gemma-command-review` - Command safety review

**Authorization:** User initiates, reviews output

**Current Status:** ✅ Operational

## L2: User Config/Docs Editor

**Description:** Read and analyze user config and documentation

**Capabilities:**
- Read config files
- Analyze documentation
- Review repository state
- Suggest config changes

**Components:**
- `gemma-repo-brief` - Repository analysis
- `gemma-file-brief` - Config file analysis
- `gemma-knowledge-ask` - Knowledge base queries

**Authorization:** Read-only analysis, user implements changes

**Current Status:** ✅ Operational

**Limitation:** Gemma is not reliable for unattended editing. Changes are suggestions only.

## L3: Project Repo Operator

**Description:** Implement changes in project repositories

**Capabilities:**
- Edit files in project repos
- Create documentation
- Update configurations
- Run safe validation commands

**Components:**
- OpenCode/Codex implementation
- Coordination repo (`~/projects/gem`)
- Skill system

**Authorization:** Explicit user request per implementation task

**Current Status:** ✅ Operational

**Primary Agent:** OpenCode/Codex (GPT-5.4 class)

## L4: Tool Orchestrator

**Description:** Coordinate multiple tools and MCPs

**Capabilities:**
- MCP server management
- Tool registry
- Skill system integration
- Multi-tool workflows

**Components:**
- MCP ecosystem (Tavily, Semgrep, Context7, etc.)
- Tool registry
- Workflow definitions

**Authorization:** Tool-specific permissions, user approval for sensitive operations

**Current Status:** ✅ Partial (OpenCode MCPs operational)

## L5: Agent Zero Operator

**Description:** Multi-agent orchestration layer

**Capabilities:**
- Spawn and coordinate multiple agents
- Agent definitions and skills
- Agent-to-agent communication
- A0 CLI connector

**Components:**
- Agent Zero installation
- A0 UI/CLI
- A0 CLI connector for OpenCode
- Agent definitions

**Authorization:** Sandboxed execution, explicit task authorization

**Current Status:** ⏳ Assessment phase (Phase 5C)

**Blockers:** Verify installation, assess connector state

## L6: RuVector Memory Operator

**Description:** Vector database and memory system

**Capabilities:**
- HNSW vector indexing
- Semantic search
- Memory graphs
- Hybrid search (BM25 + vector)
- Optional self-learning

**Components:**
- RuVector service
- Vector database
- Memory graph storage
- Query interface

**Authorization:** Scoped to authorized data paths, no system-wide access

**Current Status:** ⏳ Assessment phase (Phase 5D)

**Blockers:** Assess local-only operation, review architecture

## L7: Space Agent Workspace Operator

**Description:** Multi-workspace UI and browser agent

**Capabilities:**
- Browser automation
- Workspace management
- Task queue
- Visual UI interactions

**Components:**
- Space Agent installation
- Browser integration
- Workspace definitions
- Task management UI

**Authorization:** Browser-level permissions, user approval for actions

**Current Status:** ⏳ Assessment phase (Phase 5E)

**Blockers:** Research Linux compatibility, assess integration

## L8: Supervised System Operator

**Description:** Coordinated system operations with human oversight

**Capabilities:**
- System-level changes with explicit review
- Package management (rpm-ostree)
- Service management
- Security policy updates

**Components:**
- All lower layers integrated
- Human-in-the-loop review
- Rollback capabilities
- Audit logging

**Authorization:** Every system change requires explicit user review and approval

**Current Status:** ⏳ Future (Phase 7-8)

## L9: High-Authority Local Operator

**Description:** Full local AI operations platform

**Capabilities:**
- Comprehensive local AI operations
- Autonomous planning (supervised)
- Continuous learning (scoped)
- Full stack integration

**Components:**
- All layers L0-L8 operational
- Unified operator interface
- Advanced memory and learning
- Complete tool ecosystem

**Authorization:** Supervised autonomy with user override

**Current Status:** ⏳ Future (Phase 9)

## Progression Rules

1. **No skipping levels:** Each level must be operational before advancing
2. **Explicit authorization:** Each new capability requires user opt-in
3. **Sandboxing:** Higher levels require stronger isolation
4. **Fallback:** Always maintain lower-level capabilities
5. **Review gates:** Major level transitions require architecture review

## Current Position

**L0-L3:** Operational
**L4:** Partial (MCPs)
**L5-L7:** Assessment phase
**L8-L9:** Future

## Next Milestones

1. **L5:** Verify Agent Zero, assess A0 CLI connector
2. **L6:** Assess RuVector local-only feasibility
3. **L7:** Research Space Agent Linux compatibility
4. **L5-L7 Integration:** Design unified operator layer

## Validation

```bash
# Check current level capabilities
gemma-bazzite-health
gemma-evals-status
opencode --version

# Verify coordination repo
cat ~/projects/gem/docs/architecture/LOCAL_AI_OPERATIONS_ARCHITECTURE.md
```

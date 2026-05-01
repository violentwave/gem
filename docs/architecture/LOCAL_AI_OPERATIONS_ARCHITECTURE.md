# Local AI Operations Architecture

## System Purpose

The Bazzite Local AI Operations Stack is a progressive capability platform for local AI operations on Bazzite/Fedora Atomic desktop systems. It spans advisory models, implementation agents, operator layers, memory systems, and workspace UIs.

## Core Principle

**Least-Invasive, User-Local, Explicit Authorization**

- No unattended system changes
- No sudo without explicit review
- Canonical paths preserved
- Secrets stay out of coordination repo

## Layered Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  L9: High-Authority Local Operator                          │
│  (Full local AI operations platform - Future)              │
├─────────────────────────────────────────────────────────────┤
│  L8: Supervised System Operator                             │
│  (Agent Zero + RuVector + Space Agent integration)         │
├─────────────────────────────────────────────────────────────┤
│  L7: Space Agent Workspace Operator                         │
│  (Multi-workspace UI, browser agent, task management)      │
├─────────────────────────────────────────────────────────────┤
│  L6: RuVector Memory Operator                               │
│  (Vector DB, HNSW, memory graphs, hybrid search)           │
├─────────────────────────────────────────────────────────────┤
│  L5: Agent Zero Operator                                    │
│  (Multi-agent orchestration, A0 CLI connector)             │
├─────────────────────────────────────────────────────────────┤
│  L4: Tool Orchestrator                                      │
│  (OpenCode MCPs, skill system, tool registry)              │
├─────────────────────────────────────────────────────────────┤
│  L3: Project Repo Operator                                  │
│  (OpenCode implementation, repo coordination)              │
│  ← Current target for OpenCode/Codex                       │
├─────────────────────────────────────────────────────────────┤
│  L2: User Config/Docs Editor                                │
│  (Gemma wrappers: file-brief, command-review, repo-brief)  │
│  ← Current target for Gemma wrappers                       │
├─────────────────────────────────────────────────────────────┤
│  L1: Report Writer                                          │
│  (Gemma wrappers: security-summary, knowledge-rag)         │
│  ← Current capability level                                │
├─────────────────────────────────────────────────────────────┤
│  L0: Advisory Model                                         │
│  (Gemma chat, knowledge-check, bazzite-health)             │
│  ← Current capability level                                │
└─────────────────────────────────────────────────────────────┘
```

## Component Layers

### Models Layer (L0)
- **Gemma 4B E4B** via Ollama
- **Custom profile:** `gemma4-e4b-bazzite`
- **Purpose:** Advisory, RAG, bounded reporting
- **Limitation:** Not reliable for unattended implementation

### Wrappers Layer (L1-L2)
- **Location:** `~/.local/bin/gemma-*`
- **Purpose:** Bounded, safe Gemma interactions
- **Current scripts:** ~20 helper scripts
- **Capabilities:**
  - Report writing (L1)
  - File/repo briefs (L2)
  - Command review (L2)
  - Knowledge RAG (L1-L2)

### Retrieval/Memory Layer
- **Stage 3A:** Deterministic JSONL keyword retrieval
- **Future (RuVector):** HNSW vector search, memory graphs
- **Current:** Bounded, no embeddings

### Evals/Examples Layer
- **Stage 4A:** 19 eval cases for regression testing
- **Stage 4B:** 22 supervised examples (100% reviewed)
- **Validators:** `gemma-evals-check`, `gemma-examples-check`

### OpenCode Implementation Layer (L3)
- **Current:** OpenCode/Codex for repo operations
- **MCPs:** Tavily, Semgrep, Context7, etc.
- **Role:** Implementation agent for config/docs changes
- **Constraint:** Explicit authorization required for system changes

### Operator Layers (L5-L7) - Future

#### L5: Agent Zero Operator
- **Purpose:** Multi-agent orchestration
- **Components:**
  - A0 UI/CLI
  - A0 CLI connector
  - Agent definitions
  - Skill system

#### L6: RuVector Memory Operator
- **Purpose:** Vector DB, memory, search
- **Components:**
  - HNSW indexing
  - Memory graphs
  - Hybrid search
  - Self-learning (optional/scoped)

#### L7: Space Agent Workspace Operator
- **Purpose:** Multi-workspace UI
- **Components:**
  - Browser agent
  - Task management
  - Workspace coordination

## Data Flow

### Current State (L0-L3)

```
User → Gemma Wrapper → Ollama API → Gemma Model
                    ↓
              Knowledge Pack (RAG)
                    ↓
              Report/Analysis
                    ↓
User Review → OpenCode → Implementation
```

### Future State (L0-L7)

```
User → Space Agent UI → Agent Zero → RuVector Memory
                           ↓
                    Tool Orchestrator
                           ↓
              Gemma | OpenCode | MCPs
                           ↓
              Implementation + Learning
```

## Security Model

### Per-Level Authorization

| Level | Authorization Required | Can Modify |
|-------|----------------------|------------|
| L0-L2 | User approval per query | Read-only advisory |
| L3 | User approval per implementation | Repo/config files |
| L4-L5 | Explicit tool authorization | Tools, agents |
| L6-L7 | Sandboxed/scoped | Memory, workspaces |
| L8-L9 | Full supervised mode | System (reviewed) |

### Data Isolation

- **Models:** Local Ollama, no external API calls
- **Memory:** RuVector local-only paths
- **Agents:** Agent Zero container/sandbox
- **Workspace:** Space Agent browser isolation

## Integration Points

### Agent Zero Integration
- A0 CLI connector for OpenCode
- Agent definitions in coordination repo
- Memory via RuVector

### RuVector Integration
- Vector DB for long-term memory
- HNSW for fast search
- Memory graphs for relationships
- Optional self-learning (scoped)

### Space Agent Integration
- Browser agent for web tasks
- Workspace management
- Task queue coordination

### OpenCode Integration
- MCP server ecosystem
- Skill system
- Tool registry

## Canonical Path Preservation

All components respect canonical paths:
- Config stays in `~/.config/bazzite-security/`
- Scripts stay in `~/.local/bin/`
- State stays in `~/.local/share/bazzite-security/`
- Logs stay in `~/.local/state/bazzite-security/logs/`
- Cache stays in `~/.cache/bazzite-security/`
- Reports go to `~/offload/security-reports/`

## Roadmap Integration

See `docs/roadmap/ROADMAP.md` for phase-by-phase progression through capability levels.

## Validation

```bash
# Check current layer status
gemma-evals-status
ls -la ~/.local/bin/gemma-*
ls -la ~/.config/bazzite-security/

# Verify architecture docs
cat ~/projects/gem/docs/architecture/CAPABILITY_LEVELS.md
```

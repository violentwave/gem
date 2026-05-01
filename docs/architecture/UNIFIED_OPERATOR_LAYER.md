# Unified Operator Layer

## Overview

This document defines the unified operator layer spanning L5-L7 of the Bazzite Local AI Operations Stack. It establishes how Agent Zero, RuVector, and Space Agent work together as a cohesive system while maintaining clear boundaries and fallbacks.

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Unified Operator Layer (L5-L7)                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│    ┌─────────────┐      ┌─────────────┐      ┌─────────────┐              │
│    │   L7:       │      │   L6:       │      │   L5:       │              │
│    │   Space     │◄────►│   RuVector  │◄────►│   Agent     │              │
│    │   Agent     │      │   Memory    │      │   Zero      │              │
│    │   Workspace │      │   Operator  │      │   Operator  │              │
│    └─────────────┘      └─────────────┘      └─────────────┘              │
│         │                      │                      │                   │
│         └──────────────────────┼──────────────────────┘                   │
│                                ▼                                            │
│                    ┌─────────────────────┐                                 │
│                    │   Unified Control   │                                 │
│                    │      Interface       │                                 │
│                    └─────────────────────┘                                 │
│                                │                                            │
│                                ▼                                            │
│    ┌─────────────┐      ┌─────────────┐      ┌─────────────┐              │
│    │   L4:       │      │   L3:       │      │   L0-L2:    │              │
│    │   Tool      │◄────►│   Project   │◄────►│   Gemma     │              │
│    │   Orchestr  │      │   Repo Op   │      │   Wrappers  │              │
│    └─────────────┘      └─────────────┘      └─────────────┘              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## L5: Agent Zero Operator

### Role Definition

**Primary Role:** Autonomous task executor and multi-agent runtime

The Agent Zero operator serves as the central orchestration engine for the local AI operations stack. It coordinates task execution across specialized agents while maintaining sandbox isolation and explicit authorization boundaries.

### Expected Inputs

| Input Type | Description | Example |
|-----------|-------------|---------|
| Task definition | Structured task with goals and constraints | `{goal: "analyze repo", constraints: ["no system changes"]}` |
| Context data | Retrieved memory, documents, prior results | RuVector recall, file contents |
| Authorization scope | Explicit bounds on allowed actions | `{filesystem: ["~/projects/*"], network: false}` |
| Success criteria | Measurable outcomes for completion | `{output: "summary.md", format: "markdown"}` |

### Expected Outputs

| Output Type | Description | Example |
|-------------|-------------|---------|
| Task result | Completed task output | `{status: "success", data: {...}}` |
| Error report | Failure with reason | `{status: "failed", error: "timeout", partial: {...}}` |
| Audit log | Action record for review | `[{action: "read", target: "file", timestamp: ...}]` |

### Host Access Boundary

```
┌─────────────────────────────────────────────────────────────────┐
│                    Agent Zero Boundary                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ALLOWED:                                                      │
│   - Read files in authorized project paths                      │
│   - Write to designated output directories                      │
│   - Execute in sandboxed environment                             │
│   - Communicate with A0 CLI connector                           │
│   - Query RuVector memory                                        │
│                                                                  │
│   NOT ALLOWED:                                                  │
│   - sudo or root access                                          │
│   - System service manipulation                                  │
│   - Firewall/USBGuard/ClamAV changes                             │
│   - ~/.env or secrets access                                     │
│   - Raw logs or browser data                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Component Relationships

#### Relationship to A0 CLI Connector

The A0 CLI connector serves as the bridge between OpenCode and Agent Zero:

```
OpenCode (task) → A0 CLI Connector → Agent Zero (execute)
                   ↓
              JSON protocol
                   ↓
            stdin/stdout or Unix socket
```

**Requirements:**
- Must be installable without sudo
- Must bind to localhost only
- Must support explicit task authorization
- Must provide structured output for parsing

#### Relationship to OpenCode

| Aspect | Relationship |
|--------|--------------|
| Task origin | OpenCode dispatches tasks to A0 |
| Implementation | Agent Zero may invoke OpenCode for code work |
| Fallback | If A0 unavailable, OpenCode handles directly |
| Review | A0 output reviewed by user before commit |

#### Relationship to Gemma Wrappers

| Aspect | Relationship |
|--------|--------------|
| Advisory | A0 may invoke Gemma for advisory queries |
| Context | Gemma RAG provides background knowledge |
| Fallback | Gemma wrappers available if A0 fails |
| No direct control | A0 does not modify Gemma configs |

#### Relationship to RuVector Memory

| Aspect | Relationship |
|--------|--------------|
| Context retrieval | A0 queries RuVector for relevant memory |
| Memory persistence | A0 can store results in RuVector |
| Scoped access | Only authorized paths accessible |
| Fallback | Reverts to Stage 3A deterministic RAG if unavailable |

#### Relationship to Space Agent Workspace

| Aspect | Relationship |
|--------|--------------|
| Task dispatch | A0 may use Space Agent for browser tasks |
| UI presentation | Space Agent can display A0 status/results |
| Workspace integration | A0 workspace state in Space Agent |
| Complementary | Not required - either can operate solo |

---

## L6: RuVector Memory Operator

### Role Definition

**Primary Role:** Local memory, vector storage, and graph retrieval layer

The RuVector memory operator provides semantic search, vector storage, and memory graph capabilities. It operates as a local-only system without external service dependencies.

### Approved Source Types

| Source Type | Description | Example |
|-------------|-------------|---------|
| Project docs | Approved documentation | `~/projects/*/docs/**` |
| Knowledge pack | Stage 2 curated knowledge | `~/.local/share/bazzite-security/knowledge-pack/**` |
| Eval cases | Stage 4 eval definitions | `~/.local/share/bazzite-security/gemma-evals/evals/*.jsonl` |
| Example cases | Stage 4 supervised examples | `~/.local/share/bazzite-security/gemma-evals/examples/*.jsonl` |
| Generated reports | Non-sensitive summaries | `~/offload/security-reports/*.md` |
| User-approved content | Explicitly authorized files | Config-defined allowed paths |

### Excluded Source Types

| Source Type | Reason |
|-------------|--------|
| `.env` files | Contains secrets |
| Raw log files | May contain sensitive data |
| Browser data | Cookies, sessions, history |
| Private code | Unredacted source from other repos |
| System configs | `/etc/`, `/var/` - not user-scoped |
| Database dumps | May contain PII |
| `.git/` directories | Not for indexing |

### Ingestion Boundaries

```
┌─────────────────────────────────────────────────────────────────┐
│                    RuVector Ingestion Boundary                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   INGESTION RULES:                                               │
│   - Must be user-authorized before first ingest                 │
│   - Source must be in approved path list                         │
│   - No secrets, no logs, no browser data                         │
│   - File size limit: 10MB per document                           │
│   - Embedding model: local ONNX only (no external API)           │
│                                                                  │
│   PRE-INGEST CHECKLIST:                                          │
│   □ Is path in approved list?                                    │
│   □ Is file type allowed?                                        │
│   □ Does file contain secrets?                                   │
│   □ Is file size under limit?                                    │
│   □ Has user authorized this source?                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Write Paths

| Path | Purpose | Access |
|------|---------|--------|
| `~/.local/share/bazzite-security/ruvector/vectors/` | Vector store | User only |
| `~/.local/share/bazzite-security/ruvector/graph/` | Memory graph | User only |
| `~/.local/share/bazzite-security/ruvector/metadata/` | Index metadata | User only |
| `~/.local/share/bazzite-security/ruvector/checkpoints/` | Backup points | User only |

### Retrieval Paths

| Path | Purpose | Access |
|------|---------|--------|
| `~/.local/share/bazzite-security/ruvector/` | All retrieval | Scoped to authorized |
| `~/.local/share/bazzite-security/` | Knowledge pack | Read-only for context |
| `~/projects/gem/docs/` | Coordination docs | Read-only |

### Relationship to Existing Deterministic RAG

The Stage 3A deterministic JSONL RAG remains the fallback:

```
Query Request
      │
      ▼
┌─────────────────┐
│  RuVector       │ ───► If available, use semantic search
│  (L6)
└─────────────────┘
      │
      ▼ (if unavailable)
┌─────────────────┐
│  Stage 3A      │ ───► Fallback to keyword search
│  JSONL RAG
└─────────────────┘
      │
      ▼
┌─────────────────┐
│  Results        │
│  + Source Tag   │
└─────────────────┘
```

**Key Principle:** RuVector enhances but never replaces the deterministic RAG. If RuVector fails or is unavailable, Stage 3A provides baseline retrieval.

### Fallback to Stage 3A JSONL Retrieval

| Scenario | Fallback Behavior |
|----------|-------------------|
| RuVector service unavailable | Use in-memory cache + disk fallback |
| Index corruption | Rebuild from source files |
| Storage full | Prevent writes, alert user |
| Learning system failure | Disable learning, preserve existing |

---

## L7: Space Agent Workspace Operator

### Role Definition

**Primary Role:** Workspace UI, control surface, and browser automation

The Space Agent workspace operator provides the visual/interface layer for the local AI operations stack. It can serve as a dashboard, task workspace, operator panel, or local agent frontend.

### Possible Use Cases

| Use Case | Description | Components Used |
|----------|-------------|-----------------|
| **Dashboard** | Overview of stack status | A0 status, RuVector stats, task queue |
| **Task Workspace** | Active task management | Task queue, progress tracking |
| **Operator Panel** | Unified control interface | All components via API |
| **Agent Frontend** | Chat/command interface | Gemma context, A0 execution |
| **Browser Agent** | Web automation tasks | Browser control, scraping |

### Relationship to Agent Zero

| Aspect | Relationship |
|--------|--------------|
| Task submission | Can submit tasks to A0 |
| Status display | Shows A0 agent status |
| Result presentation | Displays A0 output |
| Workspace state | A0 can store state in Space Agent |

**Integration:** Both from agent0ai organization - likely compatible but requires testing in Phase 6C.

### Relationship to Gemma Wrappers

| Aspect | Relationship |
|--------|--------------|
| Advisory queries | Can invoke Gemma via wrapper |
| Context display | Shows RAG results |
| Fallback UI | Gemma wrappers available in browser |

### Relationship to RuVector

| Aspect | Relationship |
|--------|--------------|
| Memory query | Can invoke RuVector search |
| Status display | Shows memory statistics |
| Context panel | Displays retrieved memories |

### Relationship to Repo Workflows

| Aspect | Relationship |
|--------|--------------|
| Project access | Can read ~/projects/* |
| Documentation | Can display gem repo docs |
| Planning | Can show roadmap/phase status |

### Fallback if Space Agent Unavailable

If Space Agent is not running or not installed:

| Alternative | Description |
|-------------|-------------|
| Terminal interface | Use gemma-* wrappers directly |
| OpenCode interface | Use OpenCode CLI for tasks |
| Agent Zero UI | Use A0 UI if available |
| Custom dashboard | Future: simple HTML dashboard |

**Key Principle:** Space Agent enhances the UX but is not required. The stack operates without it.

---

## Unified Control Interface

### Entry Points

| Entry Point | Primary User | Purpose |
|-------------|-------------|---------|
| Gemma wrappers | Human | Advisory, reports, RAG |
| OpenCode | Human/Agent | Implementation |
| A0 CLI | Agent | Task execution |
| Space Agent | Human | Visual control |
| RuVector API | Agents | Memory ops |

### Data Flow

```
Human Request
      │
      ▼
┌─────────────────────────────────────────────────────────────┐
│                      Unified Router                          │
│  (Determines which component handles the request)           │
└─────────────────────────────────────────────────────────────┘
      │
      ├──► Gemma Wrappers ──► RAG (Stage 3A) ──► Response
      │
      ├──► OpenCode ──► Implementation ──► Review ──► Commit
      │
      ├──► Agent Zero ──► Agents ──► RuVector ──► Result
      │
      └──► Space Agent ──► UI/Tasks ──► A0/RuVector ──► Display
```

### Error Handling

| Scenario | Handling |
|----------|----------|
| A0 unavailable | Fallback to OpenCode |
| RuVector unavailable | Fallback to Stage 3A |
| Space Agent unavailable | Fallback to terminal |
| All L5-L7 unavailable | Use L0-L4 baseline |

### Authorization Flow

```
Task Request
      │
      ▼
Authorization Check
      │
      ├─► L0-L2: User approves per query
      │
      ├─► L3: User approves per implementation
      │
      ├─► L5: Explicit task auth + sandbox
      │
      ├─► L6: Scoped memory access
      │
      └─► L7: Browser-level + user approval
```

---

## Validation Commands

```bash
# Check unified layer status
ls -la ~/.local/share/agent-zero/    # A0 data
ls -la ~/.local/share/ruvector/      # RuVector data
ls -la ~/.config/space-agent/       # Space Agent config

# Test component availability
curl -s http://localhost:5080/health    # A0 (if running)
curl -s http://localhost:8080/health   # RuVector (if running)
curl -s http://localhost:3000/health    # Space Agent (if running)

# Check fallback chain
gemma-evals-status                    # Stage 4 validators
gemma-knowledge-rag "test"            # RAG test
```

---

## Next Steps

- Phase 6A: Agent Zero sandbox testing
- Phase 6B: RuVector sandbox testing
- Phase 6C: Space Agent sandbox testing
- Phase 6D: Integration smoke test

See `docs/roadmap/PHASE6_SANDBOX_PLAN.md` for details.

# L5-L7 Component Specifications

## Overview

This document provides detailed specifications for the L5 (Agent Zero), L6 (RuVector), and L7 (Space Agent) capability levels.

## L5: Agent Zero Operator

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Agent Zero Core                          │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   A0 UI      │  │   A0 CLI     │  │ A0 Connector │    │
│  │  (optional)  │  │              │  │   (OpenCode) │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Agent Definitions Store                 │  │
│  │   - Skill definitions                                │  │
│  │   - Agent configs                                     │  │
│  │   - Capability manifests                             │  │
│  └──────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Agent Spawner/Orchestrator              │  │
│  │   - Agent lifecycle                                  │  │
│  │   - Inter-agent communication                        │  │
│  │   - Task distribution                                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Component Specifications

#### A0 CLI Connector

**Purpose:** Bridge between OpenCode and Agent Zero

**Interface:**
- Command: `a0` or similar CLI
- Communication: stdin/stdout or Unix socket
- Protocol: JSON messages for task dispatch

**Data Paths:**
- Config: `~/.config/agent-zero/` (if installed)
- Agents: `~/.local/share/agent-zero/agents/`
- Skills: `~/.local/share/agent-zero/skills/`

**Constraints:**
- Must run in isolated container/sandbox
- No direct system access
- User approval required for agent spawn

#### Agent Definitions Store

**Purpose:** Define agent capabilities and behaviors

**Structure:**
```
agents/
├── base-agents/
│   ├── researcher.yaml
│   ├── coder.yaml
│   └── reviewer.yaml
├── skills/
│   ├── skill-*.yaml
│   └── workflow-*.yaml
└── manifests/
    └── capability-manifest.json
```

**Schema:**
```yaml
# Example agent definition
name: researcher
type: general
capabilities:
  - web-search
  - content-summarization
  - data-gathering
max_concurrent: 3
timeout: 300
isolation: sandboxed
```

#### Agent Spawner/Orchestrator

**Purpose:** Manage agent lifecycle and coordination

**Capabilities:**
- Spawn agents from definitions
- Route tasks to appropriate agents
- Aggregate agent results
- Handle agent-to-agent messaging

**Constraints:**
- Max concurrent agents: configurable (default: 5)
- Agent timeout: configurable (default: 300s)
- Resource limits: enforced via container/cgroups

### Integration Points

| Component | Interface | Protocol |
|-----------|-----------|----------|
| OpenCode | A0 CLI Connector | JSON CLI |
| RuVector | Memory API | HTTP/Unix socket |
| Space Agent | Task queue | Message bus |

### Security Model

- Agent execution in sandboxed container
- No direct filesystem access (mounts via config)
- Network isolation by default
- User approval required per task
- Audit logging of all agent actions

### Fallback Strategies

1. **Connector failure:** Fall back to OpenCode direct execution
2. **Agent timeout:** Retry once, then report failure
3. **Resource exhaustion:** Queue pending tasks, notify user

---

## L6: RuVector Memory Operator

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      RuVector Core                          │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  HNSW Index  │  │Memory Graph  │  │  Query API   │    │
│  │              │  │              │  │              │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Storage Layer                            │  │
│  │   - Vector store (local files)                        │  │
│  │   - Graph store (local files)                         │  │
│  │   - Metadata store (SQLite)                          │  │
│  └──────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Learning System (Optional)             │  │
│  │   - Feedback collection                              │  │
│  │   - Pattern extraction                               │  │
│  │   - Memory consolidation                             │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Component Specifications

#### HNSW Index

**Purpose:** Fast vector similarity search

**Configuration:**
- Index type: Hierarchical NSW
- Metric: Cosine similarity
- M parameter: 16 (configurable)
- efConstruction: 200 (configurable)
- Max elements: 1M (default, scalable)

**Data Paths:**
- Index: `~/.local/share/ruvector/hnsw/`
- Config: `~/.config/ruvector/`

**Constraints:**
- Local-only operation (no network)
- Scoped to authorized data paths
- No external model downloads

#### Memory Graph

**Purpose:** Track relationships between memory entries

**Structure:**
```
graph/
├── nodes/       # Memory entry nodes
├── edges/       # Relationship edges
└── metadata/    # Graph metadata
```

**Edge Types:**
- `caused` - Causal relationships
- `preceded` - Temporal ordering
- `succeeded` - Follow-up relationships
- `related` - General association

**Schema:**
```json
{
  "node_id": "mem_001",
  "content": "User prefers dark mode",
  "embedding": [0.1, 0.2, ...],
  "tier": "semantic",
  "timestamp": "2026-04-30T12:00:00Z"
}
```

#### Query API

**Purpose:** Interface for memory queries

**Interface:**
- Protocol: HTTP or Unix socket
- Format: JSON
- Endpoints:
  - `POST /query` - Semantic search
  - `POST /store` - Add memory
  - `GET /recall` - Retrieve by key
  - `POST /consolidate` - Trigger consolidation

**Example:**
```bash
# Semantic search
curl -X POST http://localhost:8080/query \
  -d '{"query": "user preferences", "top_k": 5}'

# Store memory
curl -X POST http://localhost:8080/store \
  -d '{"key": "pref_dark_mode", "value": "dark mode enabled"}'
```

#### Learning System (Optional)

**Purpose:** Self-improvement via feedback

**Components:**
- Feedback collector: Gather task outcomes
- Pattern extractor: Identify successful strategies
- Memory consolidator: Promote/refine memories
- (Optional) Model fine-tuning: Scoped learning

**Constraints:**
- Learning scoped to user-authorized data
- No external data sharing
- User can disable at any time
- Full audit of learning operations

### Integration Points

| Component | Interface | Protocol |
|-----------|-----------|----------|
| Agent Zero | HTTP/Unix socket | JSON |
| OpenCode | MCP or direct | JSON |
| Space Agent | HTTP | JSON |

### Security Model

- Data stored locally only (no cloud)
- Access scoped to authorized paths
- No embeddings sent to external APIs
- User-owned data remains user-owned
- Optional encryption at rest

### Fallback Strategies

1. **Service unavailable:** Use in-memory cache, queue writes
2. **Index corruption:** Rebuild from source data
3. **Storage full:** Alert user, offer cleanup
4. **Learning failure:** Disable, preserve existing memories

---

## L7: Space Agent Workspace Operator

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Space Agent Core                         │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   Browser    │  │   Workspace  │  │    Task      │    │
│  │   Agent      │  │   Manager    │  │    Queue     │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │              UI/Visual Layer                          │  │
│  │   - Dashboard (optional)                              │  │
│  │   - Task status                                       │  │
│  │   - Workspace view                                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Component Specifications

#### Browser Agent

**Purpose:** Automate web interactions

**Capabilities:**
- Navigate pages
- Fill forms
- Click elements
- Extract data
- Handle auth (scoped)

**Interface:**
- Protocol: DevTools Protocol or CDP
- Control: MCP server or direct API
- Isolation: Browser context isolation

**Data Paths:**
- Profiles: `~/.config/space-agent/profiles/`
- State: `~/.local/share/space-agent/`

#### Workspace Manager

**Purpose:** Organize multiple workspaces

**Structure:**
```
workspaces/
├── workspace-1/
│   ├── config.yaml
│   ├── state.json
│   └── tasks/
├── workspace-2/
│   └── ...
```

**Capabilities:**
- Create/delete workspaces
- Switch between workspaces
- Share state between workspaces (opt-in)
- Workspace isolation

**Schema:**
```yaml
name: research-workspace
isolation: strict
members:
  - browser-agent
  - task-queue
share_with: []  # Explicit opt-in
```

#### Task Queue

**Purpose:** Manage pending and running tasks

**Interface:**
- API: REST or message queue
- Operations: enqueue, dequeue, status, cancel

**Task States:**
- `pending` - Queued, not started
- `running` - Currently executing
- `completed` - Finished successfully
- `failed` - Finished with error
- `cancelled` - User cancelled

**Schema:**
```json
{
  "task_id": "task_001",
  "type": "browser-action",
  "workspace": "research-workspace",
  "status": "pending",
  "input": {...},
  "created": "2026-04-30T12:00:00Z",
  "result": null
}
```

#### UI/Visual Layer

**Purpose:** User-facing workspace interface

**Components:**
- Dashboard: Overview of workspaces and tasks
- Task status: Real-time progress
- Workspace view: Current workspace state

**Constraints:**
- Local-only (no cloud sync unless user opts in)
- Browser-level permissions required
- User approval for sensitive actions

### Integration Points

| Component | Interface | Protocol |
|-----------|-----------|----------|
| Agent Zero | Task queue API | JSON |
| Browser | DevTools Protocol | HTTP/WS |

### Security Model

- Browser context isolation
- No persistent cookies unless user-authorized
- No access to other browser profiles
- User approval for form submissions
- Audit logging of all actions

### Fallback Strategies

1. **Browser unavailable:** Report error, skip browser tasks
2. **Task timeout:** Cancel, report to user
3. **Workspace corruption:** Reset workspace, preserve config
4. **UI failure:** Use CLI fallback for all operations

---

## Cross-Component Integration

### Data Flow L5-L7

```
User → Space Agent → Agent Zero → Tools/Models
                        ↓
                  RuVector Memory
                        ↓
                  Persistence Layer
```

### API Boundaries

| From | To | API | Purpose |
|------|----|-----|---------|
| Space Agent | Agent Zero | Task dispatch | Submit task |
| Agent Zero | RuVector | Memory store/recall | Context |
| Agent Zero | OpenCode | Tool invocation | Execute |
| Space Agent | Browser | CDP | Web automation |

### Error Handling

| Scenario | Handling |
|----------|----------|
| Component unavailable | Fallback to lower capability |
| Task timeout | Retry once, then fail gracefully |
| Data corruption | Rebuild from source/checkpoint |
| Resource exhaustion | Queue, notify user |

### Scaling (Local-Only)

- Agent concurrency: Max 5 (configurable)
- Memory entries: Up to 1M vectors
- Workspaces: Up to 10 concurrent
- All local, no horizontal scaling needed

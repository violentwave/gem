# Integration Patterns

## Overview

This document defines the integration patterns between L0-L9 components in the Bazzite Local AI Operations Stack.

## Integration Architecture

### High-Level Data Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│                         User Interaction Layer                       │
│   ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐   │
│   │   Gemma    │  │  OpenCode  │  │Space Agent │  │  Terminal  │   │
│   │  (Advisory)│  │ (Implement)│  │  (Browser) │  │  (Direct)  │   │
│   └────────────┘  └────────────┘  └────────────┘  └────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Orchestration Layer (L5)                     │
│                         Agent Zero + A0 Connector                    │
└──────────────────────────────────────────────────────────────────────┘
                                    │
              ┌─────────────────────┴─────────────────────┐
              ▼                                           ▼
┌─────────────────────────────┐         ┌─────────────────────────────┐
│   Tool Orchestration (L4)   │         │    Memory System (L6)        │
│   OpenCode MCPs + Skills    │         │    RuVector + Graph          │
└─────────────────────────────┘         └─────────────────────────────┘
              │                                           │
              ▼                                           ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Execution Layer (L3)                         │
│                    OpenCode Implementation                          │
└──────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Model Layer (L0-L2)                          │
│                    Gemma + Ollama + RAG                              │
└──────────────────────────────────────────────────────────────────────┘
```

## Pattern Categories

### 1. Advisory Pattern (L0-L2)

**Flow:** User → Wrapper → Ollama → Gemma → Response

**Components:**
- `gemma-*` wrappers in `~/.local/bin/`
- Custom Modelfile in `~/.config/bazzite-security/`
- Knowledge pack in `~/.local/share/bazzite-security/`

**Example:**
```bash
gemma-bazzite "How do I check system health?"
# → Ollama API → Gemma → Response
```

**Characteristics:**
- Synchronous
- User-initiated
- No system changes
- Read-only advisory

### 2. Implementation Pattern (L3)

**Flow:** User → OpenCode → Edit → User Review → Commit

**Components:**
- OpenCode with MCPs
- Project repos
- Skill system

**Example:**
```
User: "Add error handling to auth.ts"
OpenCode: [Analyzes, proposes changes]
User: [Reviews, approves]
OpenCode: [Implements, validates]
```

**Characteristics:**
- Requires explicit authorization
- User reviews before commit
- Bounded to project repos
- Validation before completion

### 3. Orchestration Pattern (L5)

**Flow:** User → Agent Zero → Agent(s) → Aggregated Result

**Components:**
- A0 CLI connector
- Agent definitions
- Agent spawner

**Example:**
```
User: "Research Bazzite security and create a summary"
Agent Zero: [Spawns researcher agent]
Researcher: [Searches, summarizes]
Agent Zero: [Aggregates, presents]
```

**Characteristics:**
- Multi-agent coordination
- Task distribution
- Result aggregation
- Requires sandbox isolation

### 4. Memory Pattern (L6)

**Flow:** Component → RuVector → Store/Recall → Component

**Components:**
- HNSW index
- Memory graph
- Query API
- Learning system (optional)

**Example:**
```
Agent Zero: "Recall user preferences"
RuVector: [Semantic search] → [Returns preferences]
Agent Zero: [Uses context]
```

**Characteristics:**
- Scoped data access
- Local-only storage
- Optional self-learning
- Vector + graph hybrid

### 5. Browser Automation Pattern (L7)

**Flow:** User → Space Agent → Browser → Action → Result

**Components:**
- Browser agent
- CDP/DevTools
- Workspace manager
- Task queue

**Example:**
```
User: "Find pricing for Model X on example.com"
Space Agent: [Navigates to site]
           [Searches, extracts]
           [Returns pricing data]
```

**Characteristics:**
- Visual UI interaction
- Form automation
- Data extraction
- Context isolation

## Integration Patterns by Scenario

### Scenario 1: Research Task

```
User → Space Agent → Agent Zero → RuVector (recall context)
                              → Web search (via MCP)
                              → Summarize (Gemma)
                              → Present result
```

**Components:** L7 → L5 → L6 → L4 → L0

### Scenario 2: Code Implementation

```
User → OpenCode → Project repo analysis
              → Edit files
              → User review
              → Commit
```

**Components:** L3 → L2 (for analysis)

### Scenario 3: Multi-Agent Investigation

```
User → Agent Zero → Spawn researcher (L5)
                   Spawn coder (L5)
                   Spawn reviewer (L5)
                   Aggregate results (L5)
                   Store in memory (L6)
                   Present to user
```

**Components:** L5 → L6 → L4 → L0

### Scenario 4: Knowledge Retrieval

```
User → Wrapper → Knowledge RAG
              → JSONL search
              → Present findings
```

**Components:** L1 → L3A (retrieval)

## Error Recovery Patterns

### Pattern A: Component Failure

**Scenario:** RuVector unavailable

**Recovery:**
1. Detect failure
2. Fall back to in-memory cache
3. Queue writes for later
4. Notify user

**Flow:**
```
RuVector query → [FAIL] → In-memory cache
                              ↓
                         Return cached
                         ↓
                 Queue write for retry
```

### Pattern B: Timeout

**Scenario:** Agent takes too long

**Recovery:**
1. Detect timeout
2. Retry once with exponential backoff
3. If still fails, report to user
4. Preserve partial results if any

### Pattern C: Resource Exhaustion

**Scenario:** Memory/graph full

**Recovery:**
1. Detect threshold
2. Alert user
3. Offer cleanup options
4. Prevent new writes until resolved

## Security Patterns

### Pattern 1: Sandboxed Execution

All agent execution happens in isolated containers/sandboxes with:
- No direct system access
- Network isolation by default
- Filesystem scoped to config
- Resource limits enforced

### Pattern 2: User Approval Gate

Before system-modifying actions:
- Present proposed action
- Require explicit user approval
- Log decision
- Allow cancellation

### Pattern 3: Scoped Memory

RuVector memory access:
- Only authorized paths
- No cross-user data
- User can audit/clear
- Optional encryption

### Pattern 4: Audit Trail

All operations logged:
- Who (user/agent)
- What (action)
- When (timestamp)
- Result (success/failure)

## API Contracts

### OpenCode ↔ Agent Zero

```
Command: a0 spawn --agent <type> --task <task> [--context <json>]
Output: JSON with task_id, status
```

### Agent Zero ↔ RuVector

```
POST /store {key, value, tier, tags}
GET /recall?key=<key>
POST /query {query, top_k, tier_filter}
POST /consolidate {min_age_hours}
```

### Space Agent ↔ Agent Zero

```
POST /enqueue {workspace, task_type, input}
GET /status?task_id=<id>
POST /cancel?task_id=<id>
```

## Validation Commands

```bash
# Check integration points
curl -X POST http://localhost:8080/query -d '{"query": "test", "top_k": 1}'

# Check Agent Zero
a0 --version

# Check Space Agent (if installed)
space-agent status

# Validate patterns
gemma-evals-status
```

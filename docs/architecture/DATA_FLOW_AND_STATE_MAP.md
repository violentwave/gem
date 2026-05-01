# Data Flow and State Map

## Overview

This document maps all data flows, storage locations, and state management in the Bazzite Local AI Operations Stack. It establishes canonical path rules and clearly separates source-of-truth from generated artifacts.

---

## Data Categories

### 1. Source of Truth (Live Canonical Files)

These are the live system files that remain in their original locations:

| Path | Contents | Access |
|------|-----------|--------|
| `~/.config/bazzite-security/` | Config docs, policies, runbooks | Read for context |
| `~/.config/bazzite-security/ollama/` | Gemma Modelfile | Read-only |
| `~/.local/bin/gemma-*` | Wrapper scripts (20+) | Execute for queries |
| `~/.local/bin/bazzite-*` | Helper scripts | Execute |
| `~/.local/share/bazzite-security/` | Persistent state | Read/write per component |
| `~/.local/share/bazzite-security/gemma-evals/` | Evals and examples | Read for validation |
| `~/.local/share/bazzite-security/knowledge-pack/` | Stage 2 knowledge | Read for RAG |
| `~/.local/state/bazzite-security/logs/` | Runtime logs | Append-only |
| `~/.cache/bazzite-security/` | Runtime cache | Ephemeral |
| `~/offload/security-reports/` | Generated reports | Write output here |

### 2. Generated Planning Copies

These are sanitized copies in the coordination repo:

| Path | Source | Purpose |
|------|--------|---------|
| `~/projects/gem/docs/live-system/CURRENT_STATE.md` | Config summary | Planning reference |
| `~/projects/gem/docs/live-system/CANONICAL_PATHS.md` | Path documentation | Path reference |
| `~/projects/gem/inventory/live-paths/tool-availability.md` | Tool check | Inventory |
| `~/projects/gem/inventory/live-paths/agent-zero-state.md` | A0 assessment | Integration |
| `~/.local/share/bazzite-security/gemma-evals/evals/` | (symlink or copy reference) | Eval source |

### 3. Deterministic Index

| Path | Contents | Purpose |
|------|-----------|---------|
| `~/.local/share/bazzite-security/gemma-evals/evals/*.jsonl` | 19 eval cases | Regression testing |
| `~/.local/share/bazzite-security/gemma-evals/examples/*.jsonl` | 22 examples | Supervision |
| `~/.local/share/bazzite-security/gemma-evals/evals/chunk-index.jsonl` | Stage 3A index | Retrieval |

### 4. Eval Cases and Examples

| Category | Count | Status | Validator |
|----------|-------|--------|-----------|
| Eval cases | 19 | Active | gemma-evals-check |
| Supervised examples | 22 | 100% reviewed | gemma-examples-check |
| Draft examples | 0 | - | - |

### 5. Reports

| Path | Contents | Trigger |
|------|-----------|---------|
| `~/offload/security-reports/` | Generated summaries | gemma-security-summary |
| `~/.local/state/bazzite-security/logs/` | Operation logs | Runtime |
| `~/projects/gem/reports/` | Coordination reports | Phase milestones |

### 6. Memory Stores (L6)

| Path | Purpose | Status |
|------|---------|--------|
| `~/.local/share/bazzite-security/ruvector/approved-docs-memory.json` | Phase 7B prototype index | Prototype working |
| `~/.local/share/bazzite-security/ruvector/manifest-*.json` | Phase 7B prototype manifests | Prototype working |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/` | Phase 7B.2 semantic prototype artifacts | Prototype working |
| `~/.local/share/bazzite-security/ruvector/vectors/` | Future production vector store | Future |
| `~/.local/share/bazzite-security/ruvector/graph/` | Future memory graph | Future |
| `~/.local/share/bazzite-security/ruvector/metadata/` | Future index metadata | Future |
| `~/.local/share/bazzite-security/ruvector/checkpoints/` | Future backups | Future |

### 7. Future Agent Zero State (L5)

| Path | Purpose | Status |
|------|---------|--------|
| `~/.local/share/agent-zero/agents/` | Agent definitions | Existing, empty |
| `~/.local/share/agent-zero/skills/` | Skill definitions | Existing, empty |
| `~/.local/share/agent-zero/workdir/` | Workspace | Existing |
| `~/.local/share/agent-zero/memory/` | Agent memory | Existing |
| `~/.local/state/agent-zero/` | Runtime logs | Existing |

### 8. Space Agent State (L7)

| Path | Purpose | Status |
|------|---------|--------|
| `~/.config/space-agent/` | Electron/AppImage configuration and browser-style state | Existing |
| `~/.local/share/space-agent/` | Workspace data | Not present in Phase 7C check |
| `~/.local/share/space-agent/workspaces/` | Workspace definitions | Future |
| `~/.local/share/space-agent/tasks/` | Task queue | Future |

### 9. Repo-Local Planning Docs

These exist only in the coordination repo:

| Path | Purpose |
|------|---------|
| `~/projects/gem/docs/architecture/*.md` | Architecture docs |
| `~/projects/gem/docs/integrations/*/` | Integration plans |
| `~/projects/gem/docs/roadmap/ROADMAP.md` | Master roadmap |
| `~/projects/gem/prompts/opencode/*.txt` | Future phase prompts |
| `~/projects/gem/AGENTS.md` | Agent rules |

---

## Data Flow Diagrams

### Current State (L0-L4)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Data Flow: Current State                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  User Input                                                                  │
│      │                                                                       │
│      ▼                                                                       │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                    │
│  │   Gemma    │────►│   Stage 3A  │────►│   Gemma    │                    │
│  │  Wrappers  │     │     RAG      │     │  Response  │                    │
│  └─────────────┘     └─────────────┘     └─────────────┘                    │
│      │                     │                                                   │
│      ▼                     ▼                                                   │
│  ┌─────────────┐     ┌─────────────┐                                         │
│  │  Knowledge  │     │   JSONL     │                                         │
│  │    Pack    │     │    Index    │                                         │
│  └─────────────┘     └─────────────┘                                         │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    OpenCode (Implementation)                        │   │
│  │  User Request ──► OpenCode ──► Edit ──► User Review ──► Commit      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Future State (L5-L7)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Data Flow: Future State                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                         Unified Router                                │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│      │                                                                       │
│      ├──► Gemma Wrappers ──► RAG ──► Response                              │
│      │         │                    │                                       │
│      │         │                    ▼                                       │
│      │         │              ┌─────────────┐                               │
│      │         │              │  Stage 3A   │ (fallback)                  │
│      │         │              │    RAG      │                               │
│      │         │              └─────────────┘                               │
│      │         │                                                             │
│      ├──► OpenCode ──► Implementation ──► Review ──► Commit                │
│      │         │                                                             │
│      ├──► Agent Zero ──► Agents ──► RuVector ◄── Memory Graph              │
│      │         │                  │                                        │
│      │         │                  ▼                                        │
│      │         │           ┌─────────────┐                                  │
│      │         │           │   Output    │                                  │
│      │         │           │  +  Audit   │                                  │
│      │         │           └─────────────┘                                  │
│      │         │                                                             │
│      └──► Space Agent ──► UI/Task ──► A0/RuVector ◄── Display              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Canonical Path Rules

### Rule 1: Live Files Stay Put

```
✅ DO: Reference ~/.config/bazzite-security/ in docs
❌ DON'T: Copy ~/.config/bazzite-security/ into ~/projects/gem/
```

### Rule 2: Generated Artifacts in Canonical Paths

```
✅ DO: Write reports to ~/offload/security-reports/
✅ DO: Write logs to ~/.local/state/bazzite-security/logs/
❌ DON'T: Write runtime artifacts into ~/projects/gem/
```

### Rule 3: Repo-Local Planning Only

```
✅ DO: Create architecture docs in ~/projects/gem/docs/
✅ DO: Create prompts in ~/projects/gem/prompts/
✅ DO: Create inventory summaries in ~/projects/gem/inventory/
❌ DON'T: Copy live files (configs, logs, secrets) into repo
```

### Rule 4: No Secrets in Repo

```
❌ DON'T: Copy .env files
❌ DON'T: Copy raw logs
❌ DON'T: Copy browser data
❌ DON'T: Copy private code
❌ DON'T: Copy unredacted transcripts
```

### Rule 5: Symlink or Reference (Don't Copy)

```
✅ DO: Reference eval paths in documentation
✅ DO: Use symlinks for path references
❌ DON'T: Copy eval cases into repo
```

---

## State Transitions

### State: Advisory (L0-L1)

```
Input: User query
Process: Wrapper → RAG → Model → Response
Output: Answer
State: Ephemeral (no persistence)
```

### State: Implementation (L3)

```
Input: User request for change
Process: OpenCode → Analysis → Edit → User Review → Commit
Output: Changed files
State: Git-tracked (in project repos)
```

### State: Orchestration (L5)

```
Input: Authorized task
Process: A0 → Agent spawn → Execute → Aggregate → Result
Output: Task output + audit log
State: Persistent in agent-zero dirs
```

### State: Memory (L6)

```
Input: Store/Query request
Process: Embed → Index → Store / Embed → Search → Recall
Output: Vectors / Results
State: Persistent in ruvector dirs
```

Phase 8B.6B status: the current RuVector path contains scoped semantic prototype output using `nomic-embed-text:latest`. `gemma-memory-search` may use RuVector as supervised primary retrieval with source-family comparison and answerability calibration, but Stage 3A remains the canonical retrieval fallback/comparison baseline. No autonomous memory ingestion, learning loop, or production default replacement is enabled.

### State: Workspace (L7)

```
Input: UI interaction
Process: Space Agent → Task Queue → Execute → Display
Output: UI state + results
State: Persistent in space-agent dirs
```

Phase 7C status: Space Agent is running manually as an AppImage. Config metadata was inspected, but cookies, tokens, Local Storage, Session Storage, Trust Tokens, and secrets were not printed. Space Agent is not approved to edit `~/projects/gem` in this phase.

---

## Validation Commands

```bash
# Check source of truth paths
ls -la ~/.config/bazzite-security/
ls -la ~/.local/bin/gemma-*
ls -la ~/.local/share/bazzite-security/

# Check eval status
gemma-evals-status
gemma-examples-check

# Check repo state
cd ~/projects/gem && git status

# Verify no secrets leaked
grep -r "password\|secret\|key" ~/projects/gem/docs/ || echo "No secrets found"
```

---

## Data Retention

| Data Type | Retention | Cleanup |
|-----------|-----------|---------|
| Logs | 30 days | logrotate or manual |
| Reports | Until superseded | Manual |
| Memory (RuVector) | User-defined | Manual or auto |
| Agent state (A0) | Until reset | Manual |
| Workspace (Space) | Until deleted | Manual |
| Eval results | Permanent | - |
| Examples | Permanent | - |

---

## Summary

The data flow and state map ensures:
- Clear separation of source vs. generated
- Canonical path preservation
- No secrets in repo
- Explicit state transitions
- Retention policies defined

See `UNIFIED_OPERATOR_LAYER.md` for component relationships.

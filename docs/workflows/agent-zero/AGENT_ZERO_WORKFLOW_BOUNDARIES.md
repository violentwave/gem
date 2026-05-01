# Agent Zero Workflow Boundaries

**Phase:** 8A
**Status:** Documentation-only boundaries document
**Production status:** Not enforced; requires future authorization

---

## Overview

This document defines what Agent Zero may do in future supervised L5 workflows, what it may not do yet, and how it differs from other components in the stack. All boundaries are designed to preserve human control and system integrity.

---

## What Agent Zero May Do Later

### When Explicitly Authorized

1. **Orchestrate read-only workflows**
   - Coordinate multiple Gemma advisory queries
   - Route validation requests
   - Manage handoff generation

2. **Coordinate component interactions**
   - Trigger Stage 3A RAG lookups
   - Query RuVector prototype for context
   - Prepare Space Agent workspace context

3. **Generate reports and summaries**
   - Triage and summarize outputs
   - Create evidence packages
   - Compile status reports

4. **Validate against criteria**
   - Run Stage 4 eval checks
   - Verify file state
   - Confirm completion criteria

### When Properly Bounded

5. **Operate within authorized paths**
   - Project directory scope (e.g., `~/projects/gem`)
   - Documentation-only files
   - Non-system paths

6. **Use approved tools**
   - Gemma wrappers (advisory only)
   - Stage 3A RAG (deterministic)
   - RuVector prototype (semantic lookup only)
   - OpenCode (implementation)

---

## What Agent Zero May Not Do Yet

### Prohibited Actions

1. **No broad host access**
   - Cannot access `/etc/`, `/var/`, system directories
   - Cannot read user home beyond project scope
   - Cannot access system configs

2. **No unsupervised repo edits**
   - Cannot modify code without human approval
   - Cannot commit changes automatically
   - Cannot create branches without authorization

3. **No system/security changes**
   - Cannot modify firewall rules
   - Cannot change systemd services
   - Cannot alter package state
   - Cannot modify security configs

4. **No secret ingestion**
   - Cannot access `.env` files
   - Cannot read raw logs with sensitive data
   - Cannot process browser data
   - Cannot ingest private credentials

5. **No autonomous remediation**
   - Cannot auto-fix failures
   - Cannot self-heal without approval
   - Cannot escalate without human decision

6. **No persistent daemon changes**
   - Cannot enable autostart
   - Cannot register systemd units
   - Cannot modify service configs
   - Cannot create cron jobs

---

## Component Differentiation

### Agent Zero vs OpenCode

| Aspect | Agent Zero | OpenCode |
|--------|------------|----------|
| **Primary role** | Orchestration, workflow coordination | Implementation, repo edits |
| **Execution** | Supervised task sequences | Direct code changes |
| **Authority** | Requires explicit authorization | Requires approval |
| **Scope** | Multi-component coordination | Single-repo operations |
| **Current state** | Documentation-only (Phase 8A) | Active implementation |

**Rule:** Agent Zero orchestrates; OpenCode implements.

### Agent Zero vs Gemma Wrappers

| Aspect | Agent Zero | Gemma |
|--------|------------|-------|
| **Primary role** | Task orchestration | Advisory, RAG, command review |
| **Output** | Workflow results | Recommendations, summaries |
| **Execution** | Coordinates agents/tools | Responds to queries |
| **Autonomy** | Requires authorization | Per-query implicit |
| **Current state** | Documentation-only | Active |

**Rule:** Agent Zero may invoke Gemma for advisory context; Gemma does not orchestrate Agent Zero.

### Agent Zero vs RuVector

| Aspect | Agent Zero | RuVector |
|--------|------------|----------|
| **Primary role** | Workflow orchestration | Memory lookup |
| **Usage** | Query for context | Semantic retrieval |
| **Scope** | Full workflow | Scoped memory only |
| **Production status** | Not enabled | Prototype only |
| **Fallback** | OpenCode direct | Stage 3A |

**Rule:** Agent Zero queries RuVector for context; RuVector remains prototype-only with Stage 3A fallback.

### Agent Zero vs Space Agent

| Aspect | Agent Zero | Space Agent |
|--------|------------|-------------|
| **Primary role** | Background orchestration | UI/workspace layer |
| **Interface** | Command-line/API | Visual browser |
| **Execution** | Task automation | Manual exploration |
| **Repo access** | Bounded | Manual only |
| **Current state** | Documentation-only | Manual working |

**Rule:** Agent Zero coordinates; Space Agent displays. Space Agent does not edit `~/projects/gem` while OpenCode is active.

---

## Authorization Model

### Per-Workflow Authorization

Each Agent Zero workflow requires:
1. **Task definition** - What to do, scope, constraints
2. **Authorization scope** - What paths and tools are allowed
3. **Success criteria** - How to measure completion
4. **Human approval** - Before start and before commit

### Approval Points

| Phase | Authorization Required |
|-------|----------------------|
| Workflow definition | Human reviews workflow design |
| Task initiation | Human approves specific task |
| Execution | No autonomous actions without approval |
| Completion | Human reviews outputs |
| Commit/merge | Human approves final changes |

---

## Hard Boundaries

```
┌─────────────────────────────────────────────────────────────────┐
│                    Agent Zero Hard Boundaries                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   NEVER:                                                         │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │ • sudo or root access                                     │  │
│   │ • System service manipulation                            │  │
│   │ • Firewall, USBGuard, ClamAV changes                     │  │
│   │ • Package installs or updates                             │  │
│   │ • Model downloads                                         │  │
│   │ • Secret/credential access                                │  │
│   │ • Raw log or browser data processing                     │  │
│   │ • Autonomous code generation without approval            │  │
│   │ • Automatic repo edits                                    │  │
│   │ • Persistent autostart or daemon configuration           │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                  │
│   REQUIRES APPROVAL:                                            │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │ • File reads outside project scope                       │  │
│   │ • Multi-component coordination                           │  │
│   │ • Report generation                                      │  │
│   │ • Handoff preparation                                    │  │
│   │ • Validation orchestration                               │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Validation Commands

```bash
# Verify boundaries doc exists
test -f docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_BOUNDARIES.md

# Verify no unauthorized access
git diff -- docs/workflows/agent-zero/
```

---

## Next Steps

The boundaries in this document apply to all future Agent Zero workflow implementations. See:
- `AGENT_ZERO_WORKFLOW_LIBRARY.md` for workflow categories
- `AGENT_ZERO_WORKFLOW_CHECKLIST.md` for reusable checklist
- `prompts/opencode/phase8a1-*.prompt.txt` for first workflow prompts

---

## Production Status

**Phase 8A:** Documentation-only. No Agent Zero workflows are enabled for execution. This document defines boundaries for future supervised use.

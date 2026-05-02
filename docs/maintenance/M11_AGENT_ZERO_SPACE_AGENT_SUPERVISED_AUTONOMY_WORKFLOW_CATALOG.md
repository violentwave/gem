# M11 — Agent Zero + Space Agent Supervised Autonomy Workflow Catalog

**Phase:** M11 — Agent Zero + Space Agent Supervised Autonomy Workflow Catalog  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Workflow design phase (no execution, no autonomy enabled)

---

## Purpose

Define safe supervised workflows where Agent Zero and Space Agent can brief, classify, or propose actions — but NEVER execute them without human approval. This catalog documents the boundary between assistance and autonomy.

---

## Core Principle

**Agents may SUGGEST. Humans DECIDE. Agents never ACT without approval.**

---

## Workflow Catalog

### Workflow 1: Read-Only System Briefing

| Property | Value |
|----------|-------|
| **Agent** | Agent Zero |
| **Action** | Brief human on system status |
| **Allowed** | Summarize monitor reports, list helpers, report eval status |
| **Forbidden** | Execute commands, modify configs, start/stop services |
| **Human Approval** | Not required for briefing; required for any action |

**Steps:**
1. Human requests briefing via Agent Zero chat
2. Agent Zero reads dashboard packets (read-only)
3. Agent Zero summarizes findings
4. Human reviews summary
5. Human decides next action (if any)

---

### Workflow 2: Classification and Routing Proposal

| Property | Value |
|----------|-------|
| **Agent** | Agent Zero |
| **Action** | Propose which component should handle a task |
| **Allowed** | Suggest OpenCode for implementation, Gemma for advisory, human for decision |
| **Forbidden** | Auto-route without human confirmation, execute via chosen component |
| **Human Approval** | REQUIRED — human must confirm routing decision |

**Steps:**
1. Human describes task to Agent Zero
2. Agent Zero classifies task type (implementation, advisory, research)
3. Agent Zero proposes routing (OpenCode/Gemma/Human)
4. Human approves or overrides routing
5. Human executes via chosen component

---

### Workflow 3: Command Review Request

| Property | Value |
|----------|-------|
| **Agent** | Space Agent (via Gemma) |
| **Action** | Review proposed command for safety |
| **Allowed** | Analyze command, reference policy docs, recommend approve/deny |
| **Forbidden** | Execute command, auto-approve without human confirmation |
| **Human Approval** | REQUIRED — human must confirm before execution |

**Steps:**
1. Human pastes proposed command into Space Agent
2. Space Agent (via Gemma) analyzes command
3. Space Agent references FINAL_POLICY.md and RUNBOOK.md
4. Space Agent recommends SAFE, UNSAFE, or NEEDS_REVIEW
5. Human decides whether to execute

---

### Workflow 4: Memory Query Proposal

| Property | Value |
|----------|-------|
| **Agent** | Agent Zero + Gemma |
| **Action** | Propose memory query to answer a question |
| **Allowed** | Suggest query formulation, suggest retrieval method |
| **Forbidden** | Auto-execute query, auto-ingest results |
| **Human Approval** | REQUIRED for query execution; NOT required for suggestion |

**Steps:**
1. Human asks question
2. Agent Zero proposes query formulation
3. Agent Zero suggests retrieval method (Stage 3A vs RuVector)
4. Human approves query and method
5. Human executes query via appropriate helper

---

### Workflow 5: Eval Expansion Proposal

| Property | Value |
|----------|-------|
| **Agent** | Agent Zero |
| **Action** | Propose new eval cases based on observed patterns |
| **Allowed** | Suggest case type, suggest expected behavior, suggest test command |
| **Forbidden** | Auto-create eval cases, auto-run evals, auto-update examples |
| **Human Approval** | REQUIRED — human must review and approve each proposed case |

**Steps:**
1. Agent Zero observes pattern (e.g., recurring command type)
2. Agent Zero proposes eval case (type, scenario, expected result)
3. Human reviews proposal
4. Human approves, modifies, or rejects
5. If approved, human creates case manually

---

## Forbidden Actions (All Workflows)

| Action | Reason |
|--------|--------|
| **Auto-execute commands** | Safety — commands may modify system |
| **Auto-modify configs** | Safety — configs affect behavior |
| **Auto-start/stop services** | Safety — may disrupt operations |
| **Auto-ingest memory** | Safety — may ingest unapproved data |
| **Auto-create evals/examples** | Quality — human review required |
| **Auto-route to implementation** | Safety — OpenCode must be invoked by human |
| **Auto-approve its own proposals** | Governance — human is approval authority |

---

## Human Approval Points

Every workflow has these approval gates:

| Gate | When | Default |
|------|------|---------|
| **Proposal review** | After agent suggests action | Human must explicitly approve |
| **Execution confirmation** | Before any system change | Human must explicitly confirm |
| **Override authority** | Human disagrees with agent | Human decision always wins |
| **Emergency stop** | Any time | Human can halt any workflow |

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| Workflows defined | PASS | 5 workflows |
| Allowed actions documented | PASS | Each workflow has allowed list |
| Forbidden actions documented | PASS | Global forbidden list |
| Approval points defined | PASS | 4 gates per workflow |
| No autonomy enabled | PASS | Design only |
| No execution performed | PASS | Documentation only |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- M11: COMPLETE
- Workflows: 5 defined
- Autonomy: NONE — all workflows require human approval
- Execution: NONE — design only
- Date: 2026-05-02

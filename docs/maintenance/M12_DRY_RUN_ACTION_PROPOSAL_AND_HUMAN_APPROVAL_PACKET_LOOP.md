# M12 — Dry-Run Action Proposal and Human Approval Packet Loop

**Phase:** M12 — Dry-Run Action Proposal and Human Approval Packet Loop  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Design phase (no autonomous execution, no dry-runs performed)

---

## Purpose

Define the edge of autonomous behavior: agents may PROPOSE actions and PERFORM dry-runs, but NEVER execute changes without explicit human approval. This phase designs the proposal packet format and approval loop.

---

## Core Principle

**Propose → Dry-Run → Review → Approve → Execute (human only)**

Agents never cross the review/approve boundary.

---

## Proposal Packet Format

Every proposed action must generate a proposal packet:

```json
{
  "packet_type": "action_proposal",
  "proposal_id": "prop-20260502-001",
  "generated_at": "2026-05-02T12:00:00Z",
  "agent": "Agent Zero|Space Agent|Gemma",
  "proposed_by": "agent-name",
  
  "action": {
    "type": "command|config_change|file_edit|service_action|other",
    "description": "Human-readable description of proposed action",
    "target": "What the action affects",
    "command": "Exact command or change (if applicable)",
    "rollback_command": "How to undo the action"
  },
  
  "dry_run": {
    "performed": true|false,
    "result": "What would happen (simulated or actual dry-run)",
    "expected_outcome": "Expected result if executed",
    "risk_assessment": "low|medium|high|critical"
  },
  
  "policy_check": {
    "violates_sudo_policy": true|false,
    "violates_firewall_policy": true|false,
    "violates_package_policy": true|false,
    "violates_secret_policy": true|false,
    "violates_autonomy_policy": true|false,
    "violations": ["list of violated policies"]
  },
  
  "approval": {
    "required": true,
    "approver": "human-operator",
    "status": "pending|approved|rejected|cancelled",
    "approved_at": null,
    "approved_by": null,
    "conditions": ["any conditions on approval"]
  },
  
  "metadata": {
    "source_workflow": "M11-workflow-name",
    "related_proposals": ["prop-ids"],
    "estimated_duration": "time estimate",
    "estimated_risk": "low|medium|high"
  }
}
```

---

## Approval Loop States

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  PROPOSED   │────>│  DRY-RUN    │────>│   PENDING   │
│  (by agent) │     │  (simulated)│     │  (review)   │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                                │
              ┌─────────────────────────────────┼─────────────────────────────────┐
              │                                 │                                 │
              ▼                                 ▼                                 ▼
       ┌─────────────┐                  ┌─────────────┐                  ┌─────────────┐
       │  APPROVED   │                  │  REJECTED   │                  │  CANCELLED  │
       │(human says  │                  │(human says  │                  │(human says  │
       │   "yes")    │                  │   "no")     │                  │  "stop")    │
       └──────┬──────┘                  └─────────────┘                  └─────────────┘
              │
              ▼
       ┌─────────────┐
       │   EXECUTE   │
       │(human runs  │
       │  command)   │
       └──────┬──────┘
              │
              ▼
       ┌─────────────┐
       │  VERIFY     │
       │(human checks│
       │  result)    │
       └─────────────┘
```

**Critical rule:** The arrow from PENDING to APPROVED requires human action. No automated approval.

---

## Dry-Run Types

| Type | Description | Example |
|------|-------------|---------|
| **Simulation** | Agent predicts outcome without executing | "If you run this, it would update 3 files" |
| **Read-Only Check** | Agent runs read-only variant of command | `git diff` instead of `git apply` |
| **Validation** | Agent validates syntax/format without applying | `bash -n script.sh` |
| **Preview** | Agent shows what would change | `rsync --dry-run` equivalent |

**Dry-runs must NEVER:**
- Modify system state
- Write files
- Start/stop services
- Install packages
- Change configs
- Delete data

---

## Policy Violation Auto-Rejection

If a proposal violates any of these policies, it is AUTO-REJECTED before reaching human review:

| Policy | Violation Examples | Auto-Reject? |
|--------|-------------------|--------------|
| **No sudo** | Proposal includes `sudo` | YES |
| **No firewall changes** | Proposal modifies firewalld | YES |
| **No package installs** | Proposal installs packages | YES |
| **No secrets** | Proposal accesses `.env` | YES |
| **No autonomous execution** | Proposal executes without approval | YES |
| **No model changes** | Proposal modifies Ollama config | YES |

**Auto-rejected proposals are logged but not presented for approval.**

---

## Human Approval Interface

When a proposal reaches PENDING state, the human sees:

```
PROPOSAL #prop-20260502-001
─────────────────────────────
Action: {description}
Target: {target}
Risk: {risk_assessment}
Dry-Run Result: {dry_run.result}
Policy Violations: {violations or "None"}

[APPROVE]  [REJECT]  [CANCEL]  [REQUEST_MORE_INFO]
```

**Human must explicitly select one option. Default is NO ACTION.**

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| Packet format defined | PASS | JSON schema |
| Approval loop defined | PASS | State machine |
| Dry-run types defined | PASS | 4 types |
| Policy violations defined | PASS | 6 auto-reject policies |
| Auto-rejection rules defined | PASS | Violations auto-rejected |
| Human interface defined | PASS | CLI-style interface |
| No execution performed | PASS | Design only |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- M12: COMPLETE
- Proposal format: DEFINED
- Approval loop: DEFINED
- Auto-rejection: ENABLED for policy violations
- Execution: NONE — design only
- Date: 2026-05-02

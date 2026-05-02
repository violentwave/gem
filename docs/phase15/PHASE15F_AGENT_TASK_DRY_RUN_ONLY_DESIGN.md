# Phase 15F: Agent-Task Dry-Run-Only Design

**Phase:** 15F — Agent-Task Dry-Run-Only Design
**Date:** 2026-05-02
**Parent:** Phase 15 (Production Hardening)
**Status:** COMPLETE

---

## Purpose

Design a dry-run-only framework for Agent Zero tasks that simulates execution without modifying system state.

---

## Design Principles

1. **Simulation over execution** — Every task is simulated first
2. **State isolation** — Dry-run must not touch live systems
3. **Deterministic output** — Same input always produces same simulation output
4. **Observable** — Human can inspect every simulated step
5. **Abortable** — Human can abort at any step

---

## Dry-Run Framework

### Task Lifecycle

```
[Task Proposal] → [Dry-Run Simulation] → [Human Review] → [Approve/Reject] → [Execute or Abort]
                     ↑                    |
                     └──── Abort ←────────┘
```

### Simulation Components

| Component | Purpose | Output |
|-----------|---------|--------|
| Command preview | Show what commands would run | Command list |
| File preview | Show what files would change | Diff preview |
| Resource preview | Show CPU/memory/network impact | Resource estimate |
| Risk assessment | Evaluate safety boundaries | Risk score |
| Rollback preview | Show how to undo changes | Rollback steps |

### Dry-Run Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `preview` | Show command list only | Quick assessment |
| `simulate` | Run commands in isolated env | Detailed validation |
| `diff` | Show file changes without applying | Code review |
| `resource` | Estimate resource usage | Capacity planning |

---

## Agent Zero Dry-Run Integration

### Current Limitation

Agent Zero `message_send` times out for complex prompts (documented in Phase 12G). Direct OpenCode bridge is the operational fallback.

### Proposed Dry-Run Layer

Instead of sending tasks directly to Agent Zero, wrap them in a dry-run envelope:

```json
{
  "task": "security-summary",
  "mode": "dry-run",
  "steps": [
    {"action": "read", "target": "~/.config/bazzite-security/"},
    {"action": "analyze", "target": "security state"},
    {"action": "write", "target": "~/offload/security-reports/manual/"}
  ],
  "boundaries": {
    "read_only": ["~/.config/bazzite-security/", "~/.local/share/bazzite-security/"],
    "write_only": ["~/offload/security-reports/"],
    "denied": ["/etc/", "/usr/", "~/.env", "~/.ssh/"]
  }
}
```

### Simulation Output Format

```
[DRY-RUN] Task: security-summary
[MODE] preview

[STEP 1/3] read: ~/.config/bazzite-security/
  → Would read 6 files
  → Estimated time: 0.5s
  → Risk: LOW

[STEP 2/3] analyze: security state
  → Would process 6 files
  → Estimated time: 2s
  → Risk: LOW

[STEP 3/3] write: ~/offload/security-reports/manual/
  → Would create 1 file
  → Estimated time: 0.5s
  → Risk: LOW

[SUMMARY]
Total steps: 3
Read operations: 1
Write operations: 1
Estimated duration: 3s
Risk score: LOW (1/10)
Rollback steps: 1 (delete report)

[RECOMMENDATION]
✅ Safe to execute. All boundaries respected.
```

---

## Safety Boundaries for Dry-Run

### Forbidden in Dry-Run (Always Blocked)

| Action | Reason |
|--------|--------|
| `sudo` | Privilege escalation |
| `rm -rf` | Destructive |
| `systemctl` | Service modification |
| `firewall-cmd` | Firewall changes |
| `rpm-ostree` | System modification |
| Write to `/etc/` | System config |
| Write to `~/.ssh/` | Security sensitive |
| Read `~/.env` | Secrets |

### Allowed in Dry-Run (Read-Only)

| Action | Reason |
|--------|--------|
| Read `~/.config/bazzite-security/` | Config docs |
| Read `~/.local/share/bazzite-security/` | State |
| Read `~/projects/gem/` | Repo |
| Write `~/offload/security-reports/` | Reports |
| Write `~/.local/state/bazzite-security/logs/` | Logs |

---

## Human Approval Points

| Point | Trigger | Action |
|-------|---------|--------|
| After dry-run | Every task | Review simulation output |
| Risk threshold | Risk score > 5 | Require explicit confirmation |
| Boundary check | Any denied path accessed | Block and warn |
| Resource limit | Estimated > 1 min | Require confirmation |
| Write operation | Any file creation | Show diff preview |

---

## Implementation Status

**This phase is DESIGN-ONLY.** No implementation is performed.

The dry-run framework is documented for future implementation when:
- Agent Zero message_send timeout is resolved
- Human explicitly approves dry-run implementation
- A use case emerges that benefits from simulation

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Framework designed | PASS | 4 components, 4 modes |
| Safety boundaries defined | PASS | 8 forbidden, 5 allowed |
| Approval points defined | PASS | 5 points |
| Simulation format defined | PASS | Structured output |
| Integration with Agent Zero | PASS | Documented limitation + proposal |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 15F: COMPLETE
- Dry-run framework: DESIGNED
- Safety boundaries: DEFINED
- Implementation: DEFERRED (design-only)
- Next: Phase 15 Macro Closeout

# Agent Zero / Space Agent Bridge Boundaries

**Phase:** 12A
**Purpose:** Define hard boundaries for the supervised bridge
**Status:** Documentation-only

---

## Agent Zero Supervised-Only Boundary

### Allowed (When Explicitly Triggered)
- Read repo docs and produce structured briefings
- Consume existing validator outputs and produce summaries
- Display existing comparison results (e.g., Phase 11D)
- Present checklists for human approval
- Route advisory queries to Gemma wrappers

### Forbidden (Always)
- Edit files in `~/projects/gem`
- Run system commands with sudo
- Modify firewall, USBGuard, ClamAV, Lynis configs
- Install packages via rpm-ostree, dnf, or other means
- Start/stop systemd services
- Modify Ollama model or service config
- Ingest, index, or promote memory
- Enable autonomous learning or training
- Execute AgenticDB learning/session APIs
- Schedule recurring tasks (daemon/timer)
- Run OpenCode prompts autonomously
- Use `--dangerously-skip-permissions`
- Modify OpenCode permissions or config

---

## Space Agent Manual UI-Only Boundary

### Allowed (When Explicitly Triggered)
- Display task definitions and checklists
- Show validation results and status summaries
- Present draft prompts for human review
- Manual provider/model testing
- Workspace context display

### Forbidden (Always)
- Edit files in `~/projects/gem` while OpenCode is active
- Run system commands
- Modify configs outside `~/conf/onscreen-agent.yaml`
- Run unattended or autonomous tasks
- Ingest, index, or promote memory
- Enable autonomous learning or training
- Schedule recurring tasks
- Execute OpenCode prompts
- Modify firewall, USBGuard, ClamAV, Lynis configs
- Install packages

---

## No Repo-Write Authority by Default

Neither Agent Zero nor Space Agent has write authority to `~/projects/gem` by default.

- OpenCode remains the sole implementation engine with repo write authority
- Any future repo write delegation requires explicit human authorization
- Any repo write must be supervised and reversible
- No broad filesystem write authority

---

## No Host-Write Authority by Default

Neither Agent Zero nor Space Agent has host write authority by default.

- No sudo/root access
- No system config modifications
- No package installations
- No service management
- No firewall changes
- No security policy changes

---

## No Root/System/Security Authority

- No firewall changes (firewalld, ufw)
- No USBGuard changes
- No ClamAV/Lynis changes
- No rpm-ostree changes
- No systemd timer changes
- No package state changes
- No model config changes
- No Ollama service config changes

---

## No Autonomous Remediation

- Agent Zero detects a problem → reports to human → human decides action
- Space Agent detects a problem → displays to human → human decides action
- No automatic fixes
- No automatic patch application
- No automatic config changes

---

## No Unattended Implementation

- All OpenCode prompts remain human-triggered
- No scheduled or background implementation
- No automatic PR creation
- No automatic commit/push
- No automatic deployment

---

## No Memory Mutation

- No ingestion of new docs into knowledge pack
- No reindexing of Stage 3A chunks
- No RuVector state mutation
- No memory promotion
- No wrapper default changes
- No live eval store modifications

---

## No Learning/Training Execution

- No autonomous learning loops
- No controlled learning execution
- No fine-tuning or LoRA execution
- No AgenticDB learning/session API calls
- Future controlled learning remains roadmap-only
- Graduation gates must be met before any learning is considered

---

## Authority Matrix

| Authority | OpenCode | Agent Zero | Space Agent |
|-----------|----------|------------|-------------|
| Repo write (`~/projects/gem`) | ✅ Yes | ❌ No | ❌ No |
| Host write (system configs) | ❌ No | ❌ No | ❌ No |
| Sudo/root | ❌ No | ❌ No | ❌ No |
| Package install | ❌ No | ❌ No | ❌ No |
| Firewall changes | ❌ No | ❌ No | ❌ No |
| Ollama config | ❌ No | ❌ No | ❌ No |
| Memory mutation | ❌ No | ❌ No | ❌ No |
| Learning/training | ❌ No | ❌ No | ❌ No |
| Read repo docs | ✅ Yes | ✅ Yes* | ✅ Yes* |
| Read reports | ✅ Yes | ✅ Yes* | ✅ Yes* |
| Produce summaries | ✅ Yes | ✅ Yes* | ✅ Yes* |
| Display checklists | ✅ Yes | ✅ Yes* | ✅ Yes* |

*Requires explicit human trigger

---

## Enforcement

These boundaries are enforced by:
1. **Documentation:** This document and AGENTS.md
2. **Human review:** All outputs reviewed by human before action
3. **Explicit prompts:** Future Phase 12B/C prompts will restate boundaries
4. **Emergency stop:** Stop immediately if boundaries are violated

---

## Sign-Off

- Boundaries documented: YES
- No authority granted: CONFIRMED
- Future execution requires explicit prompt: CONFIRMED
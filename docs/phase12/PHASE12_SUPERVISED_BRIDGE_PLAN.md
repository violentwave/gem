# Phase 12A: Supervised Agent Zero / Space Agent Bridge Plan

**Phase:** 12A — Supervised Bridge Planning
**Date:** 2026-05-02
**Parent:** Phase 11 Macro (Complete)
**Status:** Planning / Open

---

## Purpose

Plan a supervised bridge where Agent Zero and/or Space Agent can act as **display, orchestration, or advisory layers** over the existing Bazzite Local AI Operations Stack. This phase is **documentation and planning only**. No Agent Zero tasks are run, no Space Agent tasks are run, and no local machine write authority is granted.

---

## Non-Goals

- Do not execute Agent Zero tasks
- Do not execute Space Agent tasks
- Do not modify Agent Zero config
- Do not modify Space Agent config
- Do not create or edit `~/conf/onscreen-agent.yaml`
- Do not grant local machine write authority
- Do not grant repo write authority to A0 or Space Agent
- Do not change OpenCode permissions
- Do not run OpenCode in unattended mode
- Do not use `--dangerously-skip-permissions`
- Do not enable autonomous remediation
- Do not add daemon/timer/background automation
- Do not ingest, index, mutate, or promote memory
- Do not enable autonomous learning/training
- Do not execute AgenticDB learning/session APIs

---

## Current System State (Pre-Phase 12)

### OpenCode / Sisyphus
- Primary implementation engine for repo operations
- Has repo write authority to `~/projects/gem`
- Runs with standard permission checks
- No unattended mode

### Gemma Wrappers (L1-L2)
- Advisory-only through local Ollama
- gemma4-e4b-bazzite:latest (9.6 GB)
- RAG via Stage 3A deterministic retrieval
- gemma-memory-search/rag as supervised helpers (not wrapper defaults)

### Stage 3A (Deterministic Fallback)
- Canonical fallback preserved
- 234 chunks, keyword-based search
- No embeddings required

### RuVector (Supervised Prototype)
- JSON + cosine similarity prototype (not official VectorDB)
- nomic-embed-text:latest (768d)
- 398 chunks
- Supervised-secondary only
- NOT production default

### Agent Zero (L5)
- Containerized via Podman: `agent0ai/agent-zero:latest`
- CLI not installed in host PATH
- Helper scripts: `agent-zero-up`, `agent-zero-down`
- Previous startup: Phase 7A (success, with findings)
- Status: Available but **not active**; requires explicit start
- Memory/learning features: Available but **not enabled**
- Browser automation: Available but **not enabled**

### Space Agent (L7)
- Manual UI/workspace layer
- Providers: OpenRouter, local Gemma/Ollama, Gemini native
- Config: `~/conf/onscreen-agent.yaml` (real file, not repo-managed)
- Status: Manual-only, no autonomous tasks
- No `~/projects/gem` edit access while OpenCode is active

---

## Agent Zero Role in Bridge

**Approved Role:** Orchestration and Display

Agent Zero can act as:
- **Orchestrator:** Coordinate read-only validation workflows
- **Display layer:** Present summaries of validation results
- **Advisory layer:** Route advisory queries to Gemma
- **Read-only briefing generator:** Consume existing docs/reports and produce structured briefings

**Denied Role:** Implementation and Mutation

Agent Zero must NOT:
- Edit files in `~/projects/gem`
- Run system commands with sudo
- Modify firewall/security configs
- Install packages
- Start/stop services
- Modify Ollama config
- Ingest or mutate memory
- Enable autonomous learning

---

## Space Agent Role in Bridge

**Approved Role:** Manual UI and Workspace Display

Space Agent can act as:
- **Workspace UI:** Display task definitions, prompts, and checklists
- **Manual orchestration UI:** Human-triggered workflow initiation
- **Provider testing UI:** Manual model/provider verification
- **Read-only display:** Show validation results, security reports, and status summaries

**Denied Role:** Autonomous Implementation

Space Agent must NOT:
- Edit files in `~/projects/gem` while OpenCode is active
- Run system commands
- Modify configs outside its own `~/conf/onscreen-agent.yaml`
- Run unattended tasks
- Ingest or mutate memory

---

## Allowed Bridge Modes

### Mode 1: Read-Only Repo Briefing Display
- Agent Zero reads existing repo docs and produces a structured briefing
- No file edits, no system commands
- Output: Markdown summary for human review

### Mode 2: Validation Result Summarization
- Agent Zero consumes existing validator outputs (evals, quality checks)
- Produces a status dashboard or summary
- No new validators launched autonomously

### Mode 3: Memory/RAG Comparison Display
- Agent Zero displays existing Phase 11D comparison results
- No new queries launched autonomously
- Output: Formatted comparison table

### Mode 4: Security Report Briefing Display
- Agent Zero or Space Agent reads existing reports from `~/offload/security-reports/`
- Produces a human-readable briefing
- No new reports generated autonomously

### Mode 5: OpenCode Prompt Staging/Review
- Space Agent displays draft prompts for human review
- Human copies prompts to OpenCode manually
- No automatic prompt execution

### Mode 6: Human Approval Packet Display
- Agent Zero or Space Agent presents a checklist of items awaiting human approval
- Human clicks/approves each item manually
- No automatic execution of approved items

---

## Forbidden Bridge Modes

- **Autonomous remediation:** Agent Zero detects a problem and fixes it without human approval
- **Unattended implementation:** Agent Zero executes OpenCode prompts while human is away
- **Broad host authority:** Agent Zero or Space Agent has write access to entire filesystem
- **Repo write delegation:** Agent Zero edits `~/projects/gem` files
- **System security changes:** Agent Zero modifies firewall, USBGuard, ClamAV, etc.
- **Memory mutation:** Agent Zero ingests, indexes, or promotes memory
- **Learning/training execution:** Agent Zero triggers controlled learning or fine-tuning
- **Daemon/timer automation:** Agent Zero schedules recurring tasks

---

## Approval Points

Every bridge workflow must have explicit approval points:

1. **Trigger Approval:** Human explicitly triggers the workflow
2. **Input Review:** Human reviews and approves inputs before processing
3. **Output Review:** Human reviews output before any action is taken
4. **Execution Gate:** No automatic execution of recommendations

---

## Stop Conditions

Stop immediately if:
- Agent Zero or Space Agent requests sudo/root access
- Agent Zero or Space Agent requests repo write access
- Agent Zero or Space Agent requests system config changes
- Agent Zero or Space Agent requests memory mutation
- Agent Zero or Space Agent requests learning/training execution
- Output contains suspicious or out-of-bounds recommendations
- Human reviewer is not available to approve outputs

---

## Safe Data Flow

```
Human → Trigger → Agent Zero/Space Agent (read-only)
         ↓
    Read existing docs/reports/validators
         ↓
    Produce summary/briefing/display
         ↓
    Human reviews output
         ↓
    Human decides next action
         ↓
    OpenCode (if implementation needed)
```

**Key principle:** Agent Zero/Space Agent are **display/orchestration** layers. They do NOT implement.

---

## Fallback Behavior

If Agent Zero or Space Agent is unavailable:
- Fall back to manual execution via existing helpers
- OpenCode remains primary implementation engine
- Gemma wrappers remain advisory-only
- Stage 3A remains canonical fallback

---

## Validation Gates

Before any future Phase 12B/C execution:

1. **Read-only verification:** Confirm no file edits occurred
2. **Permission audit:** Confirm no new permissions granted
3. **Config audit:** Confirm no config files modified
4. **Memory audit:** Confirm no memory mutation occurred
5. **Human approval:** Confirm human reviewed and approved all outputs

---

## Recommended Phase 12B

**Phase 12B:** Agent Zero Read-Only Bridge Dry-Run
- Purpose: Test Agent Zero read-only briefing generation on existing docs
- Trigger: Explicit human prompt
- Scope: Single repo briefing or single validation summary
- Boundaries: All boundaries from this document apply
- Stop conditions: All stop conditions from this document apply
- Expected output: Structured briefing for human review

**Requires:** Future explicit prompt to proceed

---

## Recommended Phase 12C

**Phase 12C:** Space Agent Manual UI Bridge Dry-Run
- Purpose: Test Space Agent as display/orchestration UI
- Trigger: Explicit human prompt
- Scope: Single workspace workflow display
- Boundaries: All boundaries from this document apply
- Stop conditions: All stop conditions from this document apply
- Expected output: Human-triggered workflow display

**Requires:** Future explicit prompt to proceed

---

## Sign-Off

- Phase 12A: PLANNING COMPLETE
- No Agent Zero execution: CONFIRMED
- No Space Agent execution: CONFIRMED
- No config changes: CONFIRMED
- No authority granted: CONFIRMED
- Boundaries: DOCUMENTED
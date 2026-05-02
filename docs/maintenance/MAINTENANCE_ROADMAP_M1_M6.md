# Maintenance Roadmap M1–M6

**Date:** 2026-05-02
**Status:** Active

---

## Overview

This document defines the maintenance phases for the Bazzite Local AI Operations Stack after completing Phases 19–25.

---

## M1 — Weekly Health / Drift Operating Cycle

**Status:** Ready
**Cadence:** Weekly
**Backend:** OpenCode
**Execution Mode:** Manual review
**Risk Level:** Low

### Purpose

Keep the system healthy and detect drift early.

### Actions

1. Run `gemma-monitor-daily`
2. Run `gemma-monitor-drift`
3. Review results
4. Update Notion tracker if needed
5. Document any issues in CURRENT_STATE.md

### Trigger

- Every Monday morning (manual)
- After any significant changes

### Data Paths

- Monitor output: terminal
- Logs: `~/.local/state/bazzite-security/logs/`
- Reports: `~/offload/security-reports/dashboard-packets/`

---

## M2 — Space Agent Dashboard Operating Cycle

**Status:** Planned
**Cadence:** Weekly
**Backend:** OpenCode / Space Agent
**Execution Mode:** Manual review
**Risk Level:** Low

### Purpose

Keep the Space Agent dashboard current with system status.

### Actions

1. Generate dashboard packet (`gemma-monitor-daily > packet.md`)
2. Launch Space Agent
3. Paste packet into dashboard
4. Review with Gemma
5. Document insights

### Trigger

- Before Space Agent sessions
- Weekly status review

### Data Paths

- Packets: `~/offload/security-reports/dashboard-packets/`
- Space Agent: `~/Applications/Space-Agent.AppImage`

---

## M3 — Knowledge + Eval Refresh Cycle

**Status:** Planned
**Cadence:** Monthly
**Backend:** OpenCode / Gemma
**Execution Mode:** Manual review
**Risk Level:** Medium

### Purpose

Keep knowledge pack and evals current.

### Actions

1. Review knowledge pack docs for staleness
2. Update docs if needed
3. Re-index if docs changed
4. Run eval validators
5. Add new eval cases if gaps found
6. Update Notion tracker

### Trigger

- First of month (manual)
- After policy changes
- After adding new docs

### Data Paths

- Knowledge pack: `~/.local/share/bazzite-security/gemma-knowledge/`
- Evals: `~/.local/share/bazzite-security/gemma-evals/`

---

## M4 — Security Review + Localhost Exposure Audit

**Status:** Planned
**Cadence:** Monthly
**Backend:** OpenCode
**Execution Mode:** Manual review
**Risk Level:** Medium

### Purpose

Verify security posture and confirm localhost-only exposure.

### Actions

1. Run `gemma-monitor-daily` (includes security checks)
2. Verify Ollama bound to 127.0.0.1
3. Verify OpenCode bridge bound to 127.0.0.1
4. Check for any exposed ports
5. Review Agent Zero boundaries
6. Document findings

### Trigger

- First of month (manual)
- After any network changes

### Denied Actions

- Do NOT modify firewall rules
- Do NOT change service configs without explicit approval
- Do NOT expose services on LAN

---

## M5 — Backup / Restore / Release Snapshot Cycle

**Status:** Planned
**Cadence:** Per-release
**Backend:** OpenCode
**Execution Mode:** Docs-only
**Risk Level:** Medium

### Purpose

Create versioned snapshots and test recovery.

### Actions

1. Run `gemma-rollback-bundle` before releases
2. Run `gemma-recovery-test` to validate bundle
3. Tag release with `gemma-release-tag`
4. Document release notes
5. Store bundle in canonical path

### Trigger

- Before git tag
- After major changes
- Monthly (manual)

### Data Paths

- Bundles: `~/.local/share/bazzite-security/rollback-bundles/`
- Latest symlink: `latest.tar.gz`

---

## M6 — Quarterly Model / Hardware / Architecture Review

**Status:** Planned
**Cadence:** Quarterly
**Backend:** OpenCode / Gemma
**Execution Mode:** Docs-only
**Risk Level:** Low

### Purpose

Revisit model, hardware, and architecture decisions quarterly.

### Actions

1. Review Phase 25 docs
2. Check if Gemma 4 still sufficient
3. Check if hardware still adequate
4. Revisit cloud vs local decision
5. Document findings
6. Update roadmap if changes needed

### Trigger

- First day of quarter (manual)
- After major model releases
- After hardware changes

### Boundaries

- Do NOT pull new models without approval
- Do NOT change hardware without approval
- Do NOT migrate to cloud without approval

---

## Allowed Actions (All Maintenance Phases)

- Run read-only monitors and validators
- Update documentation
- Create Notion update packets
- Generate dashboard packets
- Review logs and reports
- Commit docs to git
- Push to GitHub

## Denied Actions (All Maintenance Phases)

- Enable timers or automation
- Modify system security policy
- Expose services on LAN
- Train or fine-tune models
- Run ingestion/indexing
- Mutate RuVector
- Enable autonomous learning
- Install packages
- Use sudo

---

## Notion Update Policy

- Update tracker after each maintenance cycle
- Use local snapshots (Option 2)
- Copy/paste into Notion manually
- Do not store tokens in repo
- Do not automate pushes

## Space Agent Dashboard Role

- Manual UI only
- Paste dashboard packets for review
- No always-on dashboard
- No separate dashboard service

## Agent Zero Role

- Supervised orchestration only
- No repo/host write authority
- Start only when explicitly needed
- Stop when task complete

## OpenCode Role

- Implementation layer
- Explicit prompts only
- Review work before committing
- No unattended implementation

## Gemma / RAG Role

- Local advisory only
- RAG over knowledge pack
- No training/fine-tuning
- No cloud APIs

---

## Rollback / Stop Conditions

If any of the following occur, stop maintenance and escalate:

1. System compromise detected
2. Unauthorized service exposure
3. Data loss or corruption
4. Model producing dangerous outputs
5. Validator failures that cannot be resolved
6. Any boundary violation by Agent Zero

---

## Sign-Off

- Maintenance roadmap: DEFINED
- M1: Ready to start
- Boundaries: CONFIRMED
- Next action: Run M1 weekly checklist

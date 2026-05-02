# Phase 22B: Define Workflow Trigger Conditions

**Phase:** 22B — Define Workflow Trigger Conditions
**Date:** 2026-05-02
**Parent:** Phase 22 (Agent Zero + Space Agent Operator Workflow Catalog)
**Status:** COMPLETE

---

## Purpose

Define when each workflow should be triggered.

---

## Document: WORKFLOW_TRIGGER_CONDITIONS.md

**Path:** `~/.config/bazzite-security/WORKFLOW_TRIGGER_CONDITIONS.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/WORKFLOW_TRIGGER_CONDITIONS.md`

### Trigger Categories

| Category | Workflows |
|----------|-----------|
| Daily | Daily Health Check, Eval Validation |
| Weekly | Weekly Deep Check, Drift Detection, Notion Sync, State Review |
| Event-Based | Knowledge Search, RAG Query, Helper Rollout, Knowledge Update, Git Commit, Rollback |
| Conditional | Based on monitor results or search quality |
| Preventive | Before git push, before adding helpers, before config changes |
| Emergency | Rollback, Security Report, Container stop |

### Key Conditional Triggers

| Condition | Action |
|-----------|--------|
| monitor-daily shows FAIL | Identify, diagnose, fix or rollback |
| monitor-drift shows WARN (unexpected) | Review changes, update manifest |
| evals-check shows FAIL | Do not commit, fix first |
| Knowledge search weak | Try semantic search or add new doc |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Document created | PASS | All triggers defined |
| Copied to knowledge pack | PASS | Yes |

| Category | Count |
|----------|-------|
| PASS | 2 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 22B: COMPLETE
- Next: Phase 22C (Workflow Decision Tree)

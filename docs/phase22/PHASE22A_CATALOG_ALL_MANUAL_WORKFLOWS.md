# Phase 22A: Catalog All Manual Workflows

**Phase:** 22A — Catalog All Manual Workflows
**Date:** 2026-05-02
**Parent:** Phase 22 (Agent Zero + Space Agent Operator Workflow Catalog)
**Status:** COMPLETE

---

## Purpose

Create a comprehensive catalog of all manual workflows the operator performs.

---

## Document: OPERATOR_WORKFLOW_CATALOG.md

**Path:** `~/.config/bazzite-security/OPERATOR_WORKFLOW_CATALOG.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/OPERATOR_WORKFLOW_CATALOG.md`

### Workflows Cataloged: 20

| # | Workflow | Purpose |
|---|----------|---------|
| 1 | Daily Health Check | Verify system health |
| 2 | Weekly Deep Check | Comprehensive system check |
| 3 | Drift Detection | Detect documentation/config drift |
| 4 | Knowledge Search (3A) | Deterministic knowledge search |
| 5 | Knowledge Search (RuVector) | Semantic search with comparison |
| 6 | RAG Query (3A) | Query Gemma with knowledge context |
| 7 | RAG Query (RuVector) | Query Gemma with semantic context |
| 8 | Eval Validation | Run all eval validators |
| 9 | Dashboard Packet | Generate Space Agent reports |
| 10 | Git Commit | Commit changes to repo |
| 11 | Notion Sync | Update Notion tracker |
| 12 | Agent Zero Inspection | Read-only A0 state check |
| 13 | Agent Zero Start | Start A0 container (explicit only) |
| 14 | Space Agent Launch | Launch Space Agent AppImage |
| 15 | Ollama Management | Start/stop/verify Ollama |
| 16 | Knowledge Update | Add docs and re-index |
| 17 | Security Report | Generate security reports |
| 18 | Helper Rollout | Add new helper scripts |
| 19 | Rollback | Revert to known-good state |
| 20 | State Review | Review current system state |

Each workflow includes: trigger, steps, duration, artifacts.

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Document created | PASS | 20 workflows cataloged |
| Copied to knowledge pack | PASS | Yes |
| Steps documented | PASS | All 20 workflows |

| Category | Count |
|----------|-------|
| PASS | 3 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 22A: COMPLETE
- Next: Phase 22B (Workflow Trigger Conditions)

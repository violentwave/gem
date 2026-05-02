# Phase 23A: Learning Ledger Schema

**Phase:** 23A — Learning Ledger Schema
**Date:** 2026-05-02
**Parent:** Phase 23 (Controlled Learning Loop v1)
**Status:** COMPLETE

---

## Purpose

Design the schema for tracking learning events in a supervised, human-approved system.

---

## Document: LEARNING_LEDGER_SCHEMA.md

**Path:** `~/.config/bazzite-security/LEARNING_LEDGER_SCHEMA.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/LEARNING_LEDGER_SCHEMA.md`

### Key Design Decisions

| Principle | Implementation |
|-----------|----------------|
| Human approval required | Approval block mandatory for approved entries |
| Immutable ledger | Append-only, invalidation entries for corrections |
| Attributable | Operator identity required |
| Reversible | Invalidation entries, never delete |
| Bounded | 10MB max, 90-day retention |

### Entry Types

- `example_approved` — Supervised example approved
- `example_rejected` — Supervised example rejected
- `correction_applied` — Operator correction recorded
- `feedback_recorded` — Eval-driven feedback captured
- `boundary_violation` — Agent violation documented
- `policy_update` — Knowledge pack policy updated

### Ledger Location

`~/.local/share/bazzite-security/gemma-learning/ledger.jsonl`

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Schema designed | PASS | JSON schema with 6 entry types |
| Human approval gate | PASS | Required for all approved entries |
| Immutability | PASS | Append-only with invalidation |

| Category | Count |
|----------|-------|
| PASS | 3 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 23A: COMPLETE
- Next: Phase 23B (Example Approval Workflow)

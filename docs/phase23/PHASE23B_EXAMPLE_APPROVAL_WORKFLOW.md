# Phase 23B: Example Approval Workflow

**Phase:** 23B — Example Approval Workflow
**Date:** 2026-05-02
**Parent:** Phase 23 (Controlled Learning Loop v1)
**Status:** COMPLETE

---

## Purpose

Define the human-in-the-loop workflow for approving supervised examples.

---

## Document: EXAMPLE_APPROVAL_WORKFLOW.md

**Path:** `~/.config/bazzite-security/EXAMPLE_APPROVAL_WORKFLOW.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/EXAMPLE_APPROVAL_WORKFLOW.md`

### Workflow Steps

1. Example Generation — Operator creates/encounters example
2. Initial Validation — Run eval validators
3. Operator Review — Check factual correctness, sources, secrets
4. Explicit Approval — Human gate (not implicit)
5. Ledger Entry — Append to learning ledger
6. Verification — Validate ledger entry

### Rejection Workflow

- Document rejection reason
- Append rejection entry
- Do not use for training

### Correction Workflow

- Record original + corrected
- Document correction reason
- Append correction entry

### Approval Authority

- Operator (lch): Full authority
- Gemma/Agent Zero/OpenCode: No approval authority

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Workflow defined | PASS | 6 steps |
| Human gate | PASS | Explicit approval required |
| Rejection path | PASS | Documented |
| Correction path | PASS | Documented |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 23B: COMPLETE
- Next: Phase 23C (Eval-Driven Feedback Loop)

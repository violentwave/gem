# M13 — Controlled Learning Event Ledger Integration

**Phase:** M13 — Controlled Learning Event Ledger Integration  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Design phase (no learning enabled, no training data created)

---

## Purpose

Design how successful supervised workflows (M11) and approved dry-run proposals (M12) are converted into candidate learning events — NOT training data. These events are logged for future human review, not fed into models.

---

## Core Principle

**Learning events are CANDIDATES for human review. They are NOT automatically training data.**

---

## Learning Event Types

| Event Type | Trigger | Human Review Required? |
|------------|---------|----------------------|
| **workflow_success** | M11 workflow completed successfully | YES |
| **proposal_approved** | M12 proposal approved and executed successfully | YES |
| **proposal_rejected** | M12 proposal rejected (lessons learned) | YES |
| **correction_applied** | Human corrected agent suggestion | YES |
| **boundary_respected** | Agent correctly refused autonomous action | OPTIONAL |
| **policy_violation_blocked** | Auto-rejection prevented unsafe action | OPTIONAL |

---

## Learning Event Schema

```json
{
  "event_id": "evt-20260502-001",
  "event_type": "workflow_success|proposal_approved|proposal_rejected|correction_applied|boundary_respected|policy_violation_blocked",
  "timestamp": "2026-05-02T12:00:00Z",
  "source": {
    "phase": "M11|M12",
    "workflow": "workflow-name",
    "proposal_id": "prop-id (if applicable)"
  },
  
  "context": {
    "query": "Original human query or task",
    "agent_suggestion": "What the agent proposed",
    "human_action": "What the human actually did",
    "outcome": "What happened"
  },
  
  "quality": {
    "agent_was_correct": true|false,
    "human_agreed_with_agent": true|false,
    "outcome_positive": true|false,
    "would_repeat": true|false
  },
  
  "curation": {
    "status": "pending_review|approved_for_examples|rejected|deferred",
    "reviewed_by": null,
    "reviewed_at": null,
    "example_type": "command_review|rag_answer|path_policy|bad_to_corrected",
    "example_draft": null
  },
  
  "metadata": {
    "ruvector_used": true|false,
    "stage3a_used": true|false,
    "models_involved": ["gemma4-e4b-bazzite", "nomic-embed-text"],
    "helper_used": "gemma-memory-search|gemma-memory-rag|..."
  }
}
```

---

## Ledger Integration Flow

```
Workflow/Proposal Complete
    │
    ├──> Outcome positive?
    │       ├──> YES → Create learning event (PENDING_REVIEW)
    │       └──> NO  → Create learning event (PENDING_REVIEW, flagged)
    │
    ├──> Human reviews event
    │       ├──> APPROVE → Convert to example draft (if suitable)
    │       ├──> REJECT → Discard or flag as negative example
    │       └──> DEFER → Keep in ledger for future review
    │
    └──> Approved examples go to human-curated example set
           (NOT automatically added — requires separate approval)
```

---

## Example Curation Criteria

A learning event may be converted to an example ONLY if:

| Criterion | Requirement |
|-----------|-------------|
| **Event type** | `workflow_success` or `proposal_approved` |
| **Quality** | `agent_was_correct` AND `outcome_positive` |
| **Relevance** | Related to Bazzite operations, security, or policy |
| **No secrets** | No API keys, tokens, PII in context |
| **Rewriteable** | Can be sanitized for general use |
| **Human approval** | Explicit approval from human reviewer |

---

## Ledger Storage

| Property | Value |
|----------|-------|
| **Location** | `~/.local/share/bazzite-security/learning-ledger/` |
| **Format** | JSONL (one event per line) |
| **Retention** | Indefinite (events are small text) |
| **Access** | Human read-only; agent append-only |
| **Backup** | Included in rollback bundles |

---

## NOT Training Data

**Critical distinction:**

| Learning Event | Training Data |
|----------------|---------------|
| Logged for review | Used to train models |
| Human decides fate | Automatically consumed |
| May become example | Directly fed to model |
| Stored in ledger | Stored in dataset |
| Optional review | Mandatory ingestion |

**Learning events are NEVER:**
- Automatically fed to Ollama
- Used for fine-tuning
- Used for LoRA
- Bulk-imported as examples
- Used without human review

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| Event types defined | PASS | 6 types |
| Event schema defined | PASS | JSON schema |
| Ledger flow defined | PASS | 3-step flow |
| Curation criteria defined | PASS | 6 criteria |
| Storage defined | PASS | Path, format, retention |
| NOT training data | PASS | Distinction documented |
| No learning enabled | PASS | Design only |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- M13: COMPLETE
- Learning events: DEFINED
- Training data: NONE — events are candidates only
- Ledger: DEFINED but not created
- Human review: REQUIRED for all events
- Date: 2026-05-02

# Stale Memory Review Packet Template

**Phase:** 11A Planning
**Purpose:** Manual stale-memory review packet template
**Status:** Planning artifact only

---

## Overview

This is a manual-only stale-memory review packet template. No daemon, no timer, no automation.

---

## Packet Header

### Metadata

| Field | Value |
|-------|-------|
| Packet ID | `[packet-id]` |
| Created | `[YYYY-MM-DD]` |
| Reviewer | `[human-name]` |
| Phase | Phase 11E (future) |
| Status | PENDING_REVIEW |

---

## Review Scope

### What to Review

Review memory entries that may be stale:
- Old knowledge pack entries
- Deprecated policy entries
- Outdated documentation references
- Legacy runbook references

### What NOT to Review

Do NOT attempt review of:
- Active eval cases
- Reviewed examples
- Runtime state
- Helper scripts

---

## Checklist

### Pre-Review

- [ ] List all memory entries
- [ ] Identify entry age
- [ ] Flag entries older than threshold
- [ ] Prepare comparison data

### During Review

- [ ] Check entry relevance
- [ ] Verify accuracy
- [ ] Flag stale entries
- [ ] Document findings

### Post-Review

- [ ] Summarize findings
- [ ] Flag for cleanup (manual)
- [ ] Do NOT auto-delete
- [ ] Report findings

---

## Entry Assessment

### Entry Template

| Field | Value |
|-------|-------|
| Entry ID | `[entry-id]` |
| Source | `[source-file]` |
| Last Modified | `[YYYY-MM-DD]` |
| Relevance | KEEP / REVIEW / REMOVE |
| Notes | `[notes]` |

### Relevance Criteria

| Status | Definition |
|--------|------------|
| KEEP | Still relevant and accurate |
| REVIEW | May be stale, needs human check |
| REMOVE | Deprecated, schedule manual removal |

---

## Manual Process

### Step 1: List Entries

```bash
# List knowledge pack entries
ls -la ~/.local/share/bazzite-security/gemma-knowledge/docs/

# List RuVector entries
ls -la ~/.local/share/bazzite-security/ruvector/semantic-prototype/
```

### Step 2: Identify Age

Note last-modified dates for each entry.

### Step 3: Flag Stale

Manually flag entries that are:
- Older than threshold (e.g., 90 days)
- Referencing deprecated policies
- Containing outdated paths

### Step 4: Document Review

Complete this packet with findings.

### Step 5: Manual Action

- Human reviews flagged entries
- Manual removal if approved
- No automatic deletion

---

## Report Template

### Summary Section

```markdown
## Stale Memory Review Summary

**Review Date:** [YYYY-MM-DD]
**Reviewer:** [human-name]
**Total Entries Reviewed:** [N]
**Flagged for Removal:** [N]
**Kept:** [N]
```

### Flagged Entries Table

| Entry ID | Source | Last Modified | Reason |
|---------|--------|-------------|--------|
| ... | ... | ... | ... |

### Notes

```markdown
## Notes

[Manual notes about findings]
```

---

## Hard Boundaries

- No automatic deletion
- No automatic flagging
- No daemon triggers
- No timer automation
- Manual review only
- Human approval required for removal

---

## Future Use

This template is for Phase 11E (future). Only use when:
- Explicitly triggered by Phase 11E prompt
- Human-initiated review
- No automation enabled

---

## Sign-Off

- Template: PLANNING COMPLETE
- Review: MANUAL-ONLY
- No automation: CONFIRMED
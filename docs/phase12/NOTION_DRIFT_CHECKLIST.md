# Notion Drift Checklist

**Version:** 1.0
**Date:** 2026-05-02
**Purpose:** Verify Notion phase tracker matches repo state

---

## How to Use

1. Export Notion data (CSV/JSON/Markdown) or use ChatGPT snapshot
2. Compare each row against repo docs
3. Check each item below
4. Document any drift found
5. Create update packet for human review

---

## Phase-Level Checks

For every phase in Notion:

### Identity Checks
- [ ] Phase name matches repo roadmap
- [ ] Phase number is sequential (no gaps)
- [ ] Subphase name matches if applicable

### Status Checks
- [ ] Status matches CURRENT_STATE.md
- [ ] If Status = COMPLETE, closeout doc exists in repo
- [ ] If Status = BLOCKED, blocker text is non-empty
- [ ] If Status = IN_PROGRESS, next action is defined
- [ ] If Status = NOT_STARTED, no commit SHA recorded

### Commit Checks
- [ ] Commit SHA matches closeout doc commit
- [ ] Commit exists in git log
- [ ] Closeout doc path exists in repo
- [ ] Closeout doc contains commit SHA

### Validation Checks
- [ ] Validation summary exists (if COMPLETE)
- [ ] Validation summary mentions PASS/WARN/FAIL
- [ ] Validation commands listed
- [ ] No validation errors unaddressed

### Approval Checks
- [ ] If Approval Required = Yes, Approval State is set
- [ ] If Approval Required = No, Approval State = N/A
- [ ] Approval State matches actual approval

### Dependency Checks
- [ ] Depends On phases exist in Notion
- [ ] Depends On phases are COMPLETE before current phase marked COMPLETE
- [ ] Blocks phases are documented
- [ ] No circular dependencies

---

## Macro-Level Checks

### Sequence Checks
- [ ] Phase 12A is COMPLETE before 12B starts
- [ ] Phase 12B is COMPLETE before 12B1 starts
- [ ] Phase 12 sub-phases are in correct order
- [ ] Phase 13 is NOT marked COMPLETE or IN_PROGRESS
- [ ] Phase 13 is NOT_STARTED until 12I-12M are resolved

### Gap Checks
- [ ] No missing phases between completed phases
- [ ] No orphaned sub-phases (missing parent phase)
- [ ] All blocked phases have blocker text
- [ ] All future phases have reasonable next action

### Consistency Checks
- [ ] Notion Status matches ROADMAP.md Status
- [ ] Notion Status matches CURRENT_STATE.md Status
- [ ] Commit SHAs match across all docs
- [ ] Closeout doc paths are consistent

---

## Phase 13 Gate Checks

**Phase 13 must NOT start until ALL are true:**

- [ ] Phase 12I (Notion access) is COMPLETE
- [ ] Phase 12J (Notion sync design) is COMPLETE or DEFERRED
- [ ] Phase 12K (Space Agent readiness) is COMPLETE or DEFERRED
- [ ] Phase 12L (Space Agent install/dry-run) is COMPLETE or DEFERRED
- [ ] Phase 12M (Final readiness closeout) is COMPLETE
- [ ] Agent Zero is operational (with accepted limitations)
- [ ] OpenCode bridge is operational
- [ ] Notion drift is resolved or accepted

---

## Known Drift Patterns

### Pattern 1: Status Mismatch
**Symptom:** Notion says COMPLETE, repo says IN_PROGRESS
**Fix:** Update whichever is wrong

### Pattern 2: Missing Commit SHA
**Symptom:** COMPLETE phase has no commit SHA
**Fix:** Find closeout commit and add SHA

### Pattern 3: Missing Closeout Doc
**Symptom:** COMPLETE phase has no closeout doc path
**Fix:** Verify closeout doc exists, add path

### Pattern 4: Blocker Not Documented
**Symptom:** BLOCKED phase has empty blocker field
**Fix:** Add blocker text from CURRENT_STATE.md

### Pattern 5: Phase 13 Started Early
**Symptom:** Phase 13 marked IN_PROGRESS before 12M complete
**Fix:** Revert Phase 13 to NOT_STARTED

---

## Drift Report Template

```markdown
# Notion Drift Report — YYYY-MM-DD

## Summary
- Total phases checked: __
- Drift found: __
- Critical drift: __
- Minor drift: __

## Critical Drift

### Phase X
- Field: Status
- Notion: COMPLETE
- Repo: IN_PROGRESS
- Action: Update Notion to IN_PROGRESS

## Minor Drift

### Phase Y
- Field: Next Action
- Notion: "Proceed to Phase 13"
- Repo: "Proceed to Phase 12J"
- Action: Update Notion to match repo

## Recommendations
1. __
2. __

## Human Review
Reviewer: ________________
Approved: [ ] YES  [ ] NO  [ ] DEFER
Date: ________________
```

---

## Sign-Off

- Checklist version: 1.0
- Phase 13 gate: ENFORCED
- Drift report template: INCLUDED
- Last updated: 2026-05-02
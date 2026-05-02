# Phase 12I: Notion Phase Tracker Access + Drift Audit

**Phase:** 12I — Notion Phase Tracker Access + Drift Audit
**Date:** 2026-05-02
**Parent:** Phase 12H (Bridge Readiness Closeout)
**Status:** COMPLETE

---

## Purpose

Extend Phase 12 readiness so the Bazzite Local AI Operations Stack can use the Notion phase tracker accurately. This phase documents Notion database access, compares Notion state against repo roadmap/current-state docs, and creates a safe plan for OpenCode to consume Notion tracking data without secrets or direct write access by default.

---

## Notion Database Details

| Field | Value |
|-------|-------|
| **URL** | `https://www.notion.so/6af4cb83c91d416a9917a631dcf69449?v=5389736d2d3740c0b3f03d1aa55221b4` |
| **Title** | Bazzite Local Gemma Agent — Phase Tracker |
| **Data Source** | `collection://c2918acb-dddf-40ac-9787-ab1254199ff2` |
| **Access** | ChatGPT Notion connector (NOT OpenCode by default) |

---

## Notion Schema Summary

| Field | Purpose | Critical for Drift? |
|-------|---------|---------------------|
| Phase | Phase name | ✅ Yes |
| Phase Number | Numeric identifier | ✅ Yes |
| Subphase | Sub-phase name | ✅ Yes |
| Status | Current status | ✅ Yes |
| Backend | Execution backend | No |
| Execution Mode | How phase runs | No |
| Phase Group | Grouping category | No |
| Allowed Tools | Permitted tools | No |
| Denied Actions | Forbidden actions | No |
| Approval Required | Needs human approval | ✅ Yes |
| Approval State | Current approval status | ✅ Yes |
| Commit SHA | Associated commit | ✅ Yes |
| Closeout Doc | Path to closeout doc | ✅ Yes |
| Prompt Path | Path to prompt file | No |
| Repo Doc Path | Path to repo docs | ✅ Yes |
| Validation Commands | Commands to validate | ✅ Yes |
| Validation Summary | Validation results | ✅ Yes |
| Current Blocker | Blocking issue | ✅ Yes |
| Next Action | Next step | ✅ Yes |
| Runner Host | Execution host | No |
| Risk Level | Risk assessment | No |
| Started At | Start timestamp | No |
| Finished At | End timestamp | No |
| Depends On | Dependencies | ✅ Yes |
| Blocks | Blocked items | ✅ Yes |
| Run ID | Execution ID | No |

---

## Current Access Model

### ChatGPT (via Notion Connector)

**Capabilities:**
- Read Notion database rows
- Update Notion database rows
- Add new rows
- Change status fields

**Limitations:**
- Requires active Notion connector
- Subject to Notion API rate limits
- Cannot operate without internet connectivity

### OpenCode (Default)

**Capabilities:**
- Read repo docs (docs/phase12/, docs/roadmap/, docs/live-system/)
- Run local validators
- Generate reports

**Limitations:**
- NO direct Notion connector by default
- NO Notion API token configured
- Cannot read Notion without explicit integration

---

## Recommended OpenCode/Notion Pattern

### Phase 1: Read-Only Snapshot (Current)

**Method:**
- User exports Notion data as CSV/Markdown/JSON
- Or ChatGPT generates snapshot
- Snapshot stored in `docs/phase12/notion-snapshots/` (schema only) or `~/.cache/bazzite-security/notion/` (runtime)

**OpenCode reads:**
- Snapshot file
- Repo docs
- Compares for drift

**No Notion writes.**

### Phase 2: Reviewed Update Packet (Future)

**Method:**
- OpenCode analyzes repo state
- Proposes Notion updates as structured packet
- Human reviews packet
- Human (or ChatGPT with connector) applies to Notion

**OpenCode produces:**
- Update packet (Markdown/JSON)
- Human reviews and approves
- Human applies to Notion manually or via ChatGPT

**No direct Notion writes from OpenCode.**

### Phase 3: Direct Notion Sync (Future, Explicit Approval Only)

**Method:**
- User provides Notion API token (stored outside repo)
- OpenCode configured with token
- Read-only sync by default
- Write access only with explicit human approval per update

**Requirements:**
- Token stored in `~/.config/bazzite-security/keys.env` (NOT in repo)
- Integration wrapper reviewed
- Write audit log maintained
- Rollback capability documented

---

## Drift Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Notion status doesn't match repo | High | Medium | Regular drift audits |
| Commit SHA missing in Notion | Medium | Low | Closeout doc validation |
| Phase marked done before validation | Medium | High | Drift checklist |
| Blocker not documented in Notion | Medium | Medium | Blocker field mandatory |
| Phase 13 started before readiness | High | High | Gate Phase 13 on 12I-12M |
| Approval state incorrect | Low | Medium | Approval field audit |

---

## Drift Audit Checklist

For every phase row in Notion:

- [ ] Phase name matches repo roadmap
- [ ] Phase number is sequential
- [ ] Status matches current-state doc
- [ ] Commit SHA matches closeout commit (if COMPLETE)
- [ ] Closeout doc path exists in repo
- [ ] Validation summary is present (if COMPLETE)
- [ ] Blocker text exists (if BLOCKED)
- [ ] Approval state is correct (if Approval Required = Yes)
- [ ] Future phases are NOT marked DONE
- [ ] Dependencies (Depends On) are satisfied before status = DONE

---

## Required Fields for Every Phase Row

| Field | Required? | Validation |
|-------|-----------|------------|
| Phase | ✅ Yes | Non-empty string |
| Phase Number | ✅ Yes | Positive integer |
| Subphase | ⚠️ Optional | String if present |
| Status | ✅ Yes | One of: NOT_STARTED, IN_PROGRESS, COMPLETE, BLOCKED, DEFERRED |
| Commit SHA | ⚠️ Conditional | Required if Status = COMPLETE |
| Closeout Doc | ⚠️ Conditional | Required if Status = COMPLETE |
| Validation Summary | ⚠️ Conditional | Required if Status = COMPLETE |
| Current Blocker | ⚠️ Conditional | Required if Status = BLOCKED |
| Next Action | ⚠️ Conditional | Required if Status = IN_PROGRESS or BLOCKED |

---

## Acceptance Criteria for "Phase Complete"

A phase is COMPLETE in Notion ONLY when ALL are true:

1. Repo closeout doc exists and is committed
2. Commit SHA is recorded in closeout doc
3. Validators passed ( documented in closeout )
4. No uncommitted changes remain
5. Current-state.md updated
6. Roadmap.md updated
7. Boundary compliance confirmed
8. No secrets exposed
9. No unauthorized system changes made

---

## Current Known Gap

**Gap:** Phase 12H says Phase 13 next, but user wants Agent Zero/Space Agent/Notion fully ready before Phase 13.

**Resolution:** Insert Phase 12I through 12M before Phase 13.

---

## Updated Next-Phase Sequence

| Phase | Purpose | Status |
|-------|---------|--------|
| Phase 12I | Notion tracker access + drift audit | ✅ COMPLETE (this doc) |
| Phase 12J | OpenCode Notion read-only sync design | ⏳ Future |
| Phase 12K | Space Agent installation readiness | ⏳ Future |
| Phase 12L | Space Agent install/manual UI provider dry-run | ⏳ Future |
| Phase 12M | Final readiness closeout | ⏳ Future |
| Phase 13A | Curated learning examples intake planning | ⏳ Paused until 12M |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Notion database documented | PASS | URL, title, data source recorded |
| Schema documented | PASS | All 24 fields listed |
| Access model documented | PASS | ChatGPT vs OpenCode |
| Drift risks identified | PASS | 6 risks documented |
| Drift checklist created | PASS | 10 checks defined |
| Required fields defined | PASS | Conditional logic documented |
| Phase complete criteria | PASS | 9 criteria defined |
| Gap identified | PASS | Phase 13 dependency gap found |
| Updated sequence | PASS | 12I-12M inserted |
| No secrets stored | PASS | No Notion token in repo |
| No Notion writes | PASS | Read-only in this phase |
| No system changes | PASS | Documentation only |

| Category | Count |
|----------|-------|
| PASS | 12 |
| WARN | 0 |
| FAIL | 0 |

---

## Boundary Confirmation

- ✅ No Notion token created
- ✅ No Notion secrets stored
- ✅ No Notion schema changed
- ✅ No Notion pages updated
- ✅ No services started
- ✅ No configs modified
- ✅ No system/security changes
- ✅ Read-only documentation only

---

## Sign-Off

- Phase 12I: COMPLETE
- Notion database access: DOCUMENTED
- Drift audit framework: CREATED
- Next-phase sequence: UPDATED
- Phase 13: PAUSED until 12J-12M complete
- Boundaries: PRESERVED

---

## Files Created

- Closeout: `docs/phase12/PHASE12I_NOTION_PHASE_TRACKER_ACCESS_AND_DRIFT_AUDIT.md`
- Sync policy: `docs/phase12/NOTION_OPENCODE_SYNC_POLICY.md`
- Snapshot schema: `docs/phase12/NOTION_PHASE_TRACKER_SNAPSHOT_SCHEMA.md`
- Drift checklist: `docs/phase12/NOTION_DRIFT_CHECKLIST.md`
- Future prompt 12J: `prompts/opencode/phase12j-opencode-notion-readonly-sync-design.prompt.txt`
- Future prompt 12J1: `prompts/opencode/phase12j1-notion-update-packet-review.prompt.txt`
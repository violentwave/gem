# Notion/OpenCode Sync Policy

**Version:** 1.0
**Date:** 2026-05-02
**Scope:** How OpenCode interacts with Notion phase tracker data

---

## Core Principles

1. **No secrets in repo:** Notion tokens, API keys, and credentials never stored in `~/projects/gem`
2. **No direct writes by default:** OpenCode does not write to Notion unless explicitly configured and approved
3. **Read-only first:** All initial sync is read-only snapshot comparison
4. **Human review required:** All proposed Notion updates require human review before application
5. **Audit trail:** All sync operations logged and reversible

---

## No Secrets in Repo

**Forbidden:**
- Storing Notion API tokens in repo files
- Storing Notion OAuth credentials in repo
- Storing Notion integration secrets in `.env` files in repo
- Printing Notion tokens in commit messages or docs

**Allowed:**
- Referencing Notion database URL (public or workspace-visible)
- Referencing data source ID (already exposed in Notion URL)
- Documenting schema fields (public knowledge)

**Token Storage (if needed in future):**
- Primary: `~/.config/bazzite-security/keys.env` (outside repo)
- Secondary: Environment variable set in shell profile
- Never: Any file in `~/projects/gem`

---

## No Direct Writes by Default

### Default Mode: Read-Only

**OpenCode can:**
- Read Notion snapshots exported by user
- Compare snapshot to repo state
- Generate drift reports
- Propose updates as structured packets

**OpenCode cannot:**
- Write to Notion directly
- Modify Notion database schema
- Delete Notion rows
- Update Notion status fields automatically

### Exception Mode: Reviewed Writes

**Requirements for write access:**
1. Human explicitly enables Notion integration
2. Token stored outside repo
3. Write scope limited to specific fields (e.g., Status, Commit SHA)
4. Each write requires explicit human approval
5. Write logged with timestamp and before/after values

---

## Snapshot Path Policy

### Repo Docs (Schema/Spec Only)

**Path:** `docs/phase12/notion-snapshots/`

**Contains:**
- Snapshot schema definition (JSON structure)
- Example snapshot (sanitized, no secrets)
- Sync policy (this doc)
- Drift checklist

**Does NOT contain:**
- Live Notion data
- API tokens
- Real row content (unless explicitly approved)

### Runtime Cache (Live Snapshots)

**Path:** `~/.cache/bazzite-security/notion/`

**Contains:**
- Exported Notion data (CSV/JSON/Markdown)
- Generated snapshots
- Drift reports

**Managed by:**
- User exports from Notion
- OpenCode reads and compares
- Auto-cleaned if stale (>30 days)

---

## Update Packet Path Policy

### Update Packet Format

**Location:** `docs/phase12/notion-update-packets/` (schema only) or `~/.cache/bazzite-security/notion/update-packets/`

**Structure:**
```markdown
# Notion Update Packet — YYYY-MM-DD

## Proposed Changes

### Row: Phase X
- Field: Status
- Current: IN_PROGRESS
- Proposed: COMPLETE
- Reason: Closeout doc committed, validators passed

### Row: Phase Y
- Field: Current Blocker
- Current: (empty)
- Proposed: Space Agent not installed
- Reason: Phase 12C1 blocked

## Validation
- [ ] Closeout doc exists
- [ ] Commit SHA matches
- [ ] Validators passed

## Human Review
Reviewer: ________________
Approved: [ ] YES  [ ] NO  [ ] DEFER
Date: ________________
```

### Application Workflow

1. OpenCode generates update packet
2. Human reviews packet
3. If approved, human applies to Notion (manually or via ChatGPT connector)
4. If rejected, human documents reason
5. Packet archived with approval status

---

## Allowed Fields to Read

| Field | OpenCode Can Read? | Notes |
|-------|-------------------|-------|
| Phase | ✅ Yes | Public |
| Phase Number | ✅ Yes | Public |
| Subphase | ✅ Yes | Public |
| Status | ✅ Yes | Public |
| Backend | ✅ Yes | Public |
| Execution Mode | ✅ Yes | Public |
| Phase Group | ✅ Yes | Public |
| Approval Required | ✅ Yes | Public |
| Approval State | ✅ Yes | Public |
| Commit SHA | ✅ Yes | Public (in git) |
| Closeout Doc | ✅ Yes | Public (in repo) |
| Prompt Path | ✅ Yes | Public (in repo) |
| Repo Doc Path | ✅ Yes | Public (in repo) |
| Validation Summary | ✅ Yes | Public (in reports) |
| Current Blocker | ✅ Yes | Public |
| Next Action | ✅ Yes | Public |
| Risk Level | ✅ Yes | Public |
| Started At | ✅ Yes | Public |
| Finished At | ✅ Yes | Public |
| Depends On | ✅ Yes | Public |
| Blocks | ✅ Yes | Public |

---

## Allowed Fields to Propose Updates For

| Field | OpenCode Can Propose? | Human Approval Required? |
|-------|----------------------|--------------------------|
| Status | ✅ Yes | ✅ Yes |
| Commit SHA | ✅ Yes | ✅ Yes |
| Closeout Doc | ✅ Yes | ✅ Yes |
| Validation Summary | ✅ Yes | ✅ Yes |
| Current Blocker | ✅ Yes | ✅ Yes |
| Next Action | ✅ Yes | ⚠️ Recommended |
| Approval State | ✅ Yes | ✅ Yes |
| Finished At | ✅ Yes | ⚠️ Recommended |

**OpenCode cannot propose updates for:**
- Phase name
- Phase Number
- Schema fields
- Database structure

---

## Denied Actions

**OpenCode must NEVER:**
- Create new Notion databases
- Delete Notion rows
- Modify Notion schema
- Change field types
- Add/remove columns
- Rename phases without explicit approval
- Mark future phases as DONE early
- Update Notion without human review
- Store Notion credentials in repo
- Share Notion data externally

---

## Human Review Workflow

```
[OpenCode generates update packet]
        |
        v
[Human reviews packet]
        |
    +---+---+
    |       |
    v       v
[Approve] [Reject]
    |       |
    v       v
[Apply to  [Document
 Notion]   reason]
    |       |
    v       v
[Log update] [Archive packet]
```

---

## Drift Detection Workflow

1. **Export:** User exports Notion data or ChatGPT generates snapshot
2. **Compare:** OpenCode compares snapshot to repo state
3. **Report:** OpenCode generates drift report
4. **Review:** Human reviews drift report
5. **Action:** Human decides to update Notion, update repo, or accept drift
6. **Log:** Drift detection logged with timestamp

---

## Rollback/Undo Strategy

### For Notion Updates

**If update was wrong:**
1. Human manually reverts in Notion
2. Document rollback in update packet
3. Update packet marked as "rolled back"

**Prevention:**
- Always review before applying
- Test with one row before bulk update
- Keep snapshot before update

### For Repo Updates

**If repo docs are wrong:**
1. OpenCode fixes repo docs (its primary role)
2. Commit fix
3. Update Notion to match (via reviewed packet)

---

## Sign-Off

- Sync policy version: 1.0
- Default mode: Read-only
- Write access: Human-reviewed only
- Secrets in repo: FORBIDDEN
- Direct Notion writes by OpenCode: FORBIDDEN by default
- Last updated: 2026-05-02
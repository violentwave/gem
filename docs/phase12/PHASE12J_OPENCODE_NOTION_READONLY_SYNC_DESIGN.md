# Phase 12J: OpenCode Notion Read-Only Sync Design

**Phase:** 12J — OpenCode Notion Read-Only Sync Design
**Date:** 2026-05-02
**Parent:** Phase 12I (Notion Tracker Access and Drift Audit)
**Status:** COMPLETE

---

## Purpose

Design and execute the repo-side Notion read-only sync framework for the Bazzite Local AI Operations Stack. This phase documents how OpenCode interacts with the Notion phase tracker, establishes safe sync patterns, and produces actionable update packets for human or ChatGPT application.

This phase also executed a one-time direct Notion API update after user explicitly provided the `bazzite` integration token and shared the integration with the database.

---

## Notion Database Details

| Field | Value |
|-------|-------|
| **URL** | `https://www.notion.so/6af4cb83c91d416a9917a631dcf69449?v=5389736d2d3740c0b3f03d1aa55221b4` |
| **Title** | Bazzite Local Gemma Agent — Phase Tracker |
| **Data Source** | `collection://c2918acb-dddf-40ac-9787-ab1254199ff2` |
| **Integration** | `bazzite` (bot user) |
| **Workspace** | logan hurley's Workspace |

---

## OpenCode Capability Model

### Default Capabilities (No Token)
- Read repo docs (docs/phase12/, docs/roadmap/, docs/live-system/)
- Run local validators
- Generate Markdown/JSON update packets
- Compare repo state to last known snapshot

### Extended Capabilities (With Reviewed Token)
- Query Notion API for existing rows
- Update existing database rows
- Create new database rows
- Generate redacted update logs

### Explicitly Denied (Even With Token)
- Delete Notion rows
- Modify database schema
- Store token in repo
- Autonomous updates without human approval
- Mark future phases as Done early

---

## Direct Notion Write Limitations

Even when a token is available, OpenCode direct writes are subject to:

1. **Human approval requirement:** Each direct update session requires explicit user authorization
2. **Schema validation:** Only pre-approved fields may be updated
3. **Select option constraints:** Status, Phase Group, Risk Level, etc. must match existing database options
4. **No relation setup:** Depends On / Blocks (relation fields) are not automatically set during creation
5. **No deletion:** Cannot delete or archive rows
6. **Token ephemerality:** Token is not stored between sessions

---

## Read-Only Snapshot Approach

### When to Use
- No token available
- User prefers manual review
- High-risk phase updates
- Bulk drift detection

### Inputs
- ChatGPT-generated Notion snapshot
- User-exported Notion CSV/Markdown/JSON
- Previous update packet JSON

### Process
1. Read snapshot into runtime cache (`~/.cache/bazzite-security/notion/`)
2. Compare to repo state (CURRENT_STATE.md, ROADMAP.md, closeout docs)
3. Identify drift
4. Generate drift report
5. Propose update packet
6. Human reviews
7. Human applies (manually or via ChatGPT connector)

---

## Update Packet Approach

### When to Use
- Token not configured or not approved for writes
- User wants review before application
- Audit trail required

### Packet Format
- **Markdown:** Human-readable with tables and checklists
- **JSON:** Machine-readable for scripted application

### Storage
- **Repo packets (schema/template):** `docs/phase12/notion-update-packets/`
- **Runtime packets (live data):** `~/.cache/bazzite-security/notion/update-packets/`

### Application Workflow
1. OpenCode generates packet from repo state
2. Human reviews packet
3. If approved, human applies via ChatGPT connector or manual entry
4. If rejected, human documents reason
5. Packet archived with approval status

---

## Recommended Snapshot Paths

| Purpose | Path | Contains |
|---------|------|----------|
| Runtime snapshots | `~/.cache/bazzite-security/notion/` | Exported Notion data, drift reports, live packets |
| Repo packets | `docs/phase12/notion-update-packets/` | Reviewed update packets, schema definitions |
| Reports | `~/offload/security-reports/manual/` | Redacted API update logs |

---

## Accepted Sync Inputs

- ChatGPT-generated Notion snapshot (shared via paste/file)
- User-exported Notion CSV/Markdown/JSON
- Future user-local Notion API token stored outside repo (`~/.config/bazzite-security/keys.env`)
- Previous update packet JSON

## Denied Sync Inputs

- Secrets, tokens, API keys embedded in repo files
- Browser session data or cookies
- Raw authentication files
- Unreviewed .env files
- Private logs or transcripts

---

## Drift Detection Rules

1. **Status mismatch:** Notion status != repo status → propose update
2. **Missing commit SHA:** COMPLETE row lacks SHA → propose addition
3. **Missing closeout doc:** COMPLETE row lacks doc path → propose addition
4. **Missing blocker:** BLOCKED row lacks blocker text → propose addition
5. **Early Phase 13:** Phase 13 marked active before 12M complete → flag critical drift
6. **Stale next action:** IN_PROGRESS row has outdated next action → propose update

---

## Update Packet Rules

1. **No blind overwrites:** Always show current vs. proposed
2. **Validation required:** Every proposed update must reference evidence (commit SHA, closeout doc, validator output)
3. **No schema changes:** Cannot propose new columns or field types
4. **No deletion:** Cannot propose row deletion
5. **Human review mandatory:** Packet must include review section
6. **Future phases protected:** Cannot mark phases beyond current as Done

---

## Validation Checklist

- [x] Closeout docs exist for all COMPLETE phases
- [x] Commit SHA matches for completed phases
- [x] No secrets exposed in packet
- [x] No schema changes proposed
- [x] No duplicate rows proposed
- [x] Blocker text present for BLOCKED phases
- [x] Approval state correct for all phases
- [x] Phase 13 clearly deferred until 12M

---

## Direct API Update Log (This Run)

| Operation | Phase | Result |
|-----------|-------|--------|
| UPDATE | Phase 12H — Bridge Readiness Closeout | ✅ Success |
| UPDATE | Phase 13A — Curated Learning Examples Intake Planning | ✅ Success |
| CREATE | Phase 12I — Notion Tracker Access and Drift Audit | ✅ Success |
| CREATE | Phase 12J — OpenCode Notion Read-Only Sync Design | ✅ Success |
| CREATE | Phase 12K — Space Agent Installation Readiness Assessment | ✅ Success |
| CREATE | Phase 12L — Space Agent Install and Manual UI Provider Dry-Run | ✅ Success |
| CREATE | Phase 12M — Agent Zero / Space Agent / Notion Final Readiness Closeout | ✅ Success |

**Security:** Token used ephemerally. NOT stored in repo. NOT written to disk.

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Notion update packet Markdown | PASS | Created |
| Notion update packet JSON | PASS | Created |
| Phase 12H stale row corrected | PASS | Updated via API |
| Phase 12I-12M rows created | PASS | 5 new rows |
| Phase 13A updated | PASS | Status = Deferred |
| Phase 13 clearly deferred | PASS | Until 12M |
| Phase 12J design doc | PASS | This doc |
| Future 12K/12L/12M prompts | PASS | Created |
| No Notion token stored | PASS | Ephemeral use only |
| No secrets printed | PASS | Token redacted |
| No schema changes | PASS | Existing fields only |
| No services started | PASS | API calls only |

| Category | Count |
|----------|-------|
| PASS | 12 |
| WARN | 0 |
| FAIL | 0 |

---

## Boundary Confirmation

- ✅ No Notion token stored in repo
- ✅ No Notion secrets printed in persistent output
- ✅ No Notion schema modified
- ✅ No Notion rows deleted
- ✅ No services started
- ✅ No configs modified
- ✅ No system/security changes
- ✅ Direct API updates applied only after explicit user approval

---

## Recommended Phase 12K

**Phase 12K — Space Agent Installation Readiness Assessment**

**Goal:** Assess whether Space Agent can be safely installed on Bazzite without system changes.

**Prerequisites:**
- Phase 12J complete ✅
- Notion tracker up to date ✅

**Scope:**
- Research official Space Agent install source (GitHub, website, package manager)
- Determine if AppImage, Flatpak, or container is available
- Check if install requires sudo
- Document installation steps
- Do NOT install in this phase

**Prompt:** `prompts/opencode/phase12k-space-agent-installation-readiness.prompt.txt`

---

## Files Created

- Closeout: `docs/phase12/PHASE12J_OPENCODE_NOTION_READONLY_SYNC_DESIGN.md`
- Update packet (Markdown): `docs/phase12/notion-update-packets/phase12j-notion-phase-tracker-update-packet.md`
- Update packet (JSON): `docs/phase12/notion-update-packets/phase12j-notion-phase-tracker-update-packet.json`
- Redacted report: `~/offload/security-reports/manual/phase12j-notion-update-20260502-075000.md`
- Prompt 12K: `prompts/opencode/phase12k-space-agent-installation-readiness.prompt.txt`
- Prompt 12L: `prompts/opencode/phase12l-space-agent-install-manual-ui-dry-run.prompt.txt`
- Prompt 12M: `prompts/opencode/phase12m-final-readiness-closeout.prompt.txt`

---

## Sign-Off

- Phase 12J: COMPLETE
- Notion tracker: UP TO DATE
- Direct API updates: APPLIED (7 operations)
- Token handling: EPHEMERAL ONLY
- Next: Phase 12K (Space Agent Installation Readiness Assessment)

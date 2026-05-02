# Phase 20D: Write NOTION_SYNC_GUIDE.md

**Phase:** 20D — Write NOTION_SYNC_GUIDE.md
**Date:** 2026-05-02
**Parent:** Phase 20 (Knowledge Pack Expansion Implementation)
**Status:** COMPLETE

---

## Purpose

Document how to synchronize project state with Notion using local snapshots.

---

## Document: NOTION_SYNC_GUIDE.md

**Path:** `~/.config/bazzite-security/NOTION_SYNC_GUIDE.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/NOTION_SYNC_GUIDE.md`

### Approach

Option 2: Local Snapshot
- Generate Markdown locally
- Copy/paste into Notion manually
- No API tokens in repo
- No network dependencies

### Snapshot Types

1. Phase Status Snapshot — Current phase pass/warn/fail
2. Component Health Snapshot — Infrastructure status
3. Full Dashboard Packet — All monitors combined

### Sync Workflow

1. Generate snapshot: `gemma-monitor-daily > packet-$(date +%Y-%m-%d).md`
2. Open Notion tracker
3. Copy snapshot content
4. Paste into Notion
5. Update status columns manually

### Best Practices

- Generate snapshots locally
- Review before pasting
- Update status accurately
- Include commit hashes
- Link to closeout docs
- Do NOT store API tokens
- Do NOT automate pushes

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Document created | PASS | ~/.config/bazzite-security/NOTION_SYNC_GUIDE.md |
| Copied to knowledge pack | PASS | ~/.local/share/bazzite-security/gemma-knowledge/docs/ |
| 3 snapshot types | PASS | Documented |
| 6 best practices | PASS | Documented |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 20D: COMPLETE
- NOTION_SYNC_GUIDE.md: CREATED
- Next: Phase 20E (Re-index knowledge pack)

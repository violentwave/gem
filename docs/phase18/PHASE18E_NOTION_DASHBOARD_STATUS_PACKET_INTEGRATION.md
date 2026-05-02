# Phase 18E: Notion Dashboard/Status Packet Integration

**Phase:** 18E — Notion Dashboard/Status Packet Integration
**Date:** 2026-05-02
**Parent:** Phase 18 (Space Agent Operator Dashboard Integration)
**Status:** COMPLETE

---

## Purpose

Integrate Notion status updates with the Space Agent dashboard workflow.

---

## Integration Concept

Notion tracks phases/tasks. Space Agent displays status. The integration is:

```
[Notion] ←── Status Sync ──→ [Space Agent Dashboard]
   │                              │
   └── Phase status               └── Human asks "What's pending?"
       └── Task completion            └── Gemma checks Notion via API
```

### Use Case

**Human asks Space Agent:**
```
"What phases are pending?"
```

**Space Agent (via Gemma):**
1. Queries Notion API for phases with status "Planned" or "In Progress"
2. Returns formatted list

**Example response:**
```markdown
## Pending Phases

| Phase | Status | Next Action |
|-------|--------|-------------|
| Phase 18B | Planned | Dashboard data contract |
| Phase 18C | Planned | Packet generator design |
| Phase 19A | Planned | Create gemma-monitor-daily |

## Recently Completed

| Phase | Completed |
|-------|-----------|
| Phase 18A | 2026-05-02 |
| Phase 17F | 2026-05-02 |
```

---

## Implementation Options

### Option 1: Notion API Query (Read-Only)

**Pros:** Real-time, accurate
**Cons:** Requires API token, rate limits

```bash
# Conceptual only
curl -s -X POST "https://api.notion.com/v1/databases/DB_ID/query" \
  -H "Authorization: Bearer $NOTION_TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -d '{"filter": {"property":"Status","select":{"equals":"Planned"}}}'
```

### Option 2: Local Snapshot Sync

**Pros:** No API calls during dashboard use
**Cons:** Stale data possible

```bash
# Periodic sync (manual)
curl -s ... > ~/.local/share/bazzite-security/notion-snapshot.json
```

### Selected Approach: Option 2 (Local Snapshot)

**Rationale:**
- No real-time requirement
- Reduces API load
- Token used only during sync
- Human triggers sync manually

---

## Snapshot Format

```json
{
  "snapshot_version": "1.0",
  "captured_at": "2026-05-02T12:00:00Z",
  "phases": [
    {
      "phase": "18A",
      "title": "Space Agent dashboard requirements",
      "status": "Done",
      "group": "Integration"
    },
    {
      "phase": "18B",
      "title": "Dashboard data contract",
      "status": "Planned",
      "group": "Integration"
    }
  ]
}
```

---

## Sync Workflow

1. **Human triggers sync:**
   ```bash
   gemma-notion-sync
   ```

2. **Script queries Notion API:**
   - Fetch all phases
   - Filter relevant fields
   - Save to snapshot

3. **Space Agent reads snapshot:**
   - Human asks "What's pending?"
   - Gemma reads snapshot
   - Returns formatted list

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Integration concept | PASS | Notion ↔ Space Agent |
| Use case defined | PASS | "What's pending?" |
| Options evaluated | PASS | 2 options |
| Approach selected | PASS | Local snapshot |
| Snapshot format | PASS | JSON defined |
| Workflow | PASS | 3 steps |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 18E: COMPLETE
- Integration: Notion snapshot → Space Agent
- Approach: Local snapshot (Option 2)
- Next: Phase 18F (Phase 18 Closeout)

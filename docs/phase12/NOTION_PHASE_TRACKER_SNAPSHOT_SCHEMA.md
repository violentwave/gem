# Notion Phase Tracker Snapshot Schema

**Version:** 1.0
**Date:** 2026-05-02
**Purpose:** Define repo-local snapshot format for Notion phase tracker data

---

## Snapshot Storage Policy

### Repo Docs (Schema/Spec Only)

**Path:** `docs/phase12/notion-snapshots/`

**Contains:**
- This schema definition
- Example snapshot (sanitized)
- Sync policy
- Drift checklist

**Does NOT contain live runtime snapshots.**

### Runtime Cache (Live Snapshots)

**Path:** `~/.cache/bazzite-security/notion/`

**Contains:**
- Exported Notion data (CSV/JSON/Markdown)
- Generated snapshots
- Drift reports
- Update packets

**Auto-cleanup:** Files older than 30 days may be removed.

---

## JSON Snapshot Schema

```json
{
  "snapshot_metadata": {
    "generated_at": "2026-05-02T12:00:00Z",
    "source_database_url": "https://www.notion.so/6af4cb83c91d416a9917a631dcf69449?v=5389736d2d3740c0b3f03d1aa55221b4",
    "data_source_id": "collection://c2918acb-dddf-40ac-9787-ab1254199ff2",
    "exported_by": "user|chatgpt|script",
    "export_format": "csv|json|markdown",
    "total_rows": 25
  },
  "rows": [
    {
      "id": "notion-page-id-123",
      "phase": "Phase 12A",
      "phase_number": 12.1,
      "subphase": "Supervised Bridge Planning",
      "status": "COMPLETE",
      "backend": "OpenCode",
      "execution_mode": "Manual",
      "phase_group": "Bridge Readiness",
      "allowed_tools": "read, write",
      "denied_actions": "sudo, firewall, package-install",
      "approval_required": false,
      "approval_state": "N/A",
      "commit_sha": "668cb5b",
      "closeout_doc": "docs/phase12/PHASE12_SUPERVISED_BRIDGE_PLAN.md",
      "prompt_path": "prompts/opencode/phase12a-supervised-bridge-planning.prompt.txt",
      "repo_doc_path": "docs/phase12/PHASE12_SUPERVISED_BRIDGE_PLAN.md",
      "validation_commands": "gemma-evals-check, gemma-examples-check",
      "validation_summary": "PASS: all validators passed",
      "current_blocker": null,
      "next_action": "Proceed to Phase 12B",
      "runner_host": "bazzite-laptop",
      "risk_level": "LOW",
      "started_at": "2026-05-02T00:00:00Z",
      "finished_at": "2026-05-02T01:00:00Z",
      "depends_on": ["Phase 11"],
      "blocks": ["Phase 12B"],
      "run_id": null
    }
  ]
}
```

---

## Field Definitions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `snapshot_metadata` | object | ✅ Yes | Snapshot header |
| `snapshot_metadata.generated_at` | ISO 8601 | ✅ Yes | Export timestamp |
| `snapshot_metadata.source_database_url` | URL | ✅ Yes | Notion database URL |
| `snapshot_metadata.data_source_id` | string | ✅ Yes | Data source identifier |
| `snapshot_metadata.exported_by` | enum | ✅ Yes | Who exported |
| `snapshot_metadata.export_format` | enum | ✅ Yes | Export format |
| `snapshot_metadata.total_rows` | integer | ✅ Yes | Row count |
| `rows` | array | ✅ Yes | Phase rows |
| `rows[].id` | string | ✅ Yes | Notion page ID |
| `rows[].phase` | string | ✅ Yes | Phase name |
| `rows[].phase_number` | number | ✅ Yes | Phase number |
| `rows[].subphase` | string | ⚠️ Optional | Sub-phase name |
| `rows[].status` | enum | ✅ Yes | Current status |
| `rows[].backend` | string | ⚠️ Optional | Execution backend |
| `rows[].execution_mode` | string | ⚠️ Optional | Execution mode |
| `rows[].phase_group` | string | ⚠️ Optional | Grouping |
| `rows[].allowed_tools` | string | ⚠️ Optional | Permitted tools |
| `rows[].denied_actions` | string | ⚠️ Optional | Forbidden actions |
| `rows[].approval_required` | boolean | ✅ Yes | Needs approval |
| `rows[].approval_state` | string | ⚠️ Conditional | Approval status |
| `rows[].commit_sha` | string | ⚠️ Conditional | Git commit |
| `rows[].closeout_doc` | path | ⚠️ Conditional | Closeout doc path |
| `rows[].prompt_path` | path | ⚠️ Optional | Prompt file path |
| `rows[].repo_doc_path` | path | ⚠️ Optional | Repo doc path |
| `rows[].validation_commands` | string | ⚠️ Conditional | Validation commands |
| `rows[].validation_summary` | string | ⚠️ Conditional | Validation results |
| `rows[].current_blocker` | string | ⚠️ Conditional | Blocking issue |
| `rows[].next_action` | string | ⚠️ Conditional | Next step |
| `rows[].runner_host` | string | ⚠️ Optional | Host name |
| `rows[].risk_level` | enum | ⚠️ Optional | Risk level |
| `rows[].started_at` | ISO 8601 | ⚠️ Optional | Start time |
| `rows[].finished_at` | ISO 8601 | ⚠️ Optional | End time |
| `rows[].depends_on` | array | ⚠️ Optional | Dependencies |
| `rows[].blocks` | array | ⚠️ Optional | Blocked items |
| `rows[].run_id` | string | ⚠️ Optional | Run ID |

---

## Status Enum

```
NOT_STARTED
IN_PROGRESS
COMPLETE
BLOCKED
DEFERRED
CANCELLED
```

---

## Risk Level Enum

```
CRITICAL
HIGH
MEDIUM
LOW
NONE
```

---

## Validation Rules

1. `generated_at` must be valid ISO 8601
2. `source_database_url` must be valid URL
3. `phase_number` must be positive number
4. `status` must be one of enum values
5. If `status` = COMPLETE, then `commit_sha` and `closeout_doc` are required
6. If `status` = BLOCKED, then `current_blocker` is required
7. If `approval_required` = true, then `approval_state` is required
8. `depends_on` and `blocks` must reference valid phase numbers

---

## Example Validation Script

```bash
#!/usr/bin/env bash
# Validate snapshot JSON structure
# Usage: ./validate-snapshot.sh snapshot.json

SNAPSHOT="$1"
python3 -c "
import json, sys
with open('$SNAPSHOT') as f:
    data = json.load(f)

# Required top-level keys
assert 'snapshot_metadata' in data, 'Missing snapshot_metadata'
assert 'rows' in data, 'Missing rows'

# Required metadata fields
meta = data['snapshot_metadata']
for field in ['generated_at', 'source_database_url', 'data_source_id']:
    assert field in meta, f'Missing metadata field: {field}'

# Validate rows
for row in data['rows']:
    assert 'phase' in row, 'Missing phase'
    assert 'status' in row, 'Missing status'
    if row.get('status') == 'COMPLETE':
        assert row.get('commit_sha'), f'COMPLETE row missing commit_sha: {row[\"phase\"]}'
        assert row.get('closeout_doc'), f'COMPLETE row missing closeout_doc: {row[\"phase\"]}'

print('Validation passed')
"
```

---

## Sign-Off

- Schema version: 1.0
- Snapshot path (repo): `docs/phase12/notion-snapshots/`
- Snapshot path (runtime): `~/.cache/bazzite-security/notion/`
- Last updated: 2026-05-02
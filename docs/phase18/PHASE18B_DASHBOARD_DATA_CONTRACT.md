# Phase 18B: Dashboard Data Contract

**Phase:** 18B — Dashboard Data Contract
**Date:** 2026-05-02
**Parent:** Phase 18 (Space Agent Operator Dashboard Integration)
**Status:** COMPLETE

---

## Purpose

Define the JSON/Markdown packet format that report generators produce and Space Agent consumes.

---

## Data Contract: JSON Packet

### Schema

```json
{
  "packet_version": "1.0",
  "packet_type": "dashboard_status",
  "generated_at": "2026-05-02T12:00:00Z",
  "generator": "gemma-monitor-daily",
  "generator_version": "1.0",
  "title": "System Status Report",
  "summary": {
    "pass": 6,
    "warn": 1,
    "fail": 0,
    "duration_seconds": 8.2
  },
  "sections": [
    {
      "name": "Infrastructure",
      "items": [
        {"label": "Ollama", "status": "pass", "value": "v0.22.0 running"},
        {"label": "Gemma", "status": "pass", "value": "gemma4-e4b-bazzite available"},
        {"label": "GPU", "status": "pass", "value": "GTX 1060 6GB (3.2GB used)"}
      ]
    },
    {
      "name": "Validation",
      "items": [
        {"label": "Eval cases", "status": "pass", "value": "25/25 PASS"},
        {"label": "Examples", "status": "pass", "value": "32/32 reviewed"}
      ]
    }
  ],
  "recommendations": [
    "Review log file: ~/.local/state/.../gemma-memory-search.log (120MB)"
  ],
  "report_path": "~/offload/security-reports/manual/dashboard-status-20260502-120000.md"
}
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `packet_version` | string | Schema version (e.g., "1.0") |
| `packet_type` | string | Type of packet |
| `generated_at` | ISO 8601 | Timestamp |
| `generator` | string | Script name |
| `title` | string | Human-readable title |
| `summary` | object | Pass/warn/fail counts |
| `sections` | array | Grouped status items |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `generator_version` | string | Script version |
| `recommendations` | array | Action items |
| `report_path` | string | Full report location |
| `baseline_id` | string | Regression baseline reference |

---

## Data Contract: Markdown Report

### Template

```markdown
# {{title}}

**Date:** {{generated_at}}
**Generator:** {{generator}}

## Summary

Pass: {{pass}} | Warn: {{warn}} | Fail: {{fail}}
Duration: {{duration}}s

{{#sections}}
## {{name}}

{{#items}}
- {{status_icon}} {{label}}: {{value}}
{{/items}}

{{/sections}}

{{#recommendations}}
## Recommendations

{{#recommendations}}
1. {{.}}
{{/recommendations}}
{{/recommendations}}
```

### Status Icons

| Status | Icon | Markdown |
|--------|------|----------|
| pass | ✅ | `:heavy_check_mark:` |
| warn | ⚠️ | `:warning:` |
| fail | ❌ | `:x:` |
| info | ℹ️ | `:information_source:` |

---

## Packet Types

| Type | Purpose | Generator |
|------|---------|-----------|
| `dashboard_status` | Overall system health | gemma-monitor-daily |
| `dashboard_weekly` | Deep weekly check | gemma-monitor-weekly |
| `dashboard_drift` | Configuration drift | gemma-monitor-drift |
| `security_report` | Security summary | gemma-security-summary |
| `eval_report` | Eval validation | gemma-evals-check |
| `knowledge_report` | Knowledge pack status | gemma-knowledge-check |

---

## File Naming Convention

```
{packet-type}-{YYYYMMDD-HHMMSS}.md
{packet-type}-{YYYYMMDD-HHMMSS}.json
```

Examples:
- `dashboard-status-20260502-120000.md`
- `security-report-20260502-120000.md`
- `eval-report-20260502-120000.json`

---

## Storage Paths

| Type | Path | Retention |
|------|------|-----------|
| Markdown reports | `~/offload/security-reports/manual/` | 30 days |
| JSON packets | `~/.local/share/bazzite-security/dashboard-packets/` | 7 days |
| Logs | `~/.local/state/bazzite-security/logs/` | 7 days |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| JSON schema defined | PASS | 7 required fields |
| Markdown template defined | PASS | Mustache-style |
| Status icons defined | PASS | 4 icons |
| Packet types defined | PASS | 6 types |
| Naming convention | PASS | `{type}-{timestamp}.{ext}` |
| Storage paths | PASS | 3 paths with retention |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 18B: COMPLETE
- JSON schema: DEFINED
- Markdown template: DEFINED
- Packet types: 6 defined
- Next: Phase 18C (Read-Only Dashboard Packet Generator Design)

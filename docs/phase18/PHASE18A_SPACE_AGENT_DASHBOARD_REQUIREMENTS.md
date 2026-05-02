# Phase 18A: Space Agent Dashboard Requirements and Source Inventory

**Phase:** 18A — Space Agent Dashboard Requirements and Source Inventory
**Date:** 2026-05-02
**Parent:** Phase 18 (Space Agent Operator Dashboard Integration)
**Status:** COMPLETE

---

## Purpose

Inventory all data sources that feed the Space Agent dashboard and define what the dashboard should display. Answer: What exactly should Space Agent display? Which scripts/reports feed it? Which actions are manual-only? Which buttons/workflows are forbidden?

---

## Space Agent Capabilities (Current)

From Phase 7E.1 and 12L:

| Property | Value |
|----------|-------|
| **Type** | Electron AppImage (manual UI) |
| **Version** | v0.66.0 |
| **Location** | `~/Applications/Space-Agent.AppImage` |
| **Providers** | OpenRouter, Local Ollama/Gemma |
| **Local Gemma** | `gemma4-e4b-bazzite:latest` via `http://127.0.0.1:11434/v1/chat/completions` |
| **API key** | `ollama` (placeholder) |
| **Autonomy** | Manual UI only — no autonomous tasks |
| **Repo editing** | NOT APPROVED |
| **Host tasks** | NOT APPROVED |

### What Space Agent Can Display

Space Agent is a **chat-based UI**. It does not have:
- Custom widgets
- Real-time graphs
- Automated refresh
- Programmatic API for display

It **can** display:
- Markdown text (formatted)
- Code blocks
- Tables (rendered)
- Links (clickable)
- File attachments (if supported)

---

## Dashboard Concept: Conversational Status Interface

Since Space Agent is a chat UI, the "dashboard" is actually a **conversational status interface**:

```
Human: "What's the system status?"
Space Agent (via Gemma): Reads latest reports, summarizes:
"System Status Summary (2026-05-02):
- Ollama: Running (v0.22.0)
- Gemma: Available
- Bridge: Operational
- Evals: 25/25 PASS
- Examples: 32/32 reviewed
- Disk: 45% used
- No critical issues."

Human: "Show me the latest security report"
Space Agent: Displays ~/offload/security-reports/manual/latest-report.md
```

### Dashboard Categories

| Category | Data Source | Display Method |
|----------|-------------|----------------|
| **Health** | gemma-bazzite-health, gemma-monitor-daily | Summary text |
| **Status** | gemma-evals-status, gemma-opencode-check | Table or list |
| **Reports** | ~/offload/security-reports/manual/*.md | Full report display |
| **Logs** | ~/.local/state/bazzite-security/logs/ | Tail or summary |
| **Actions** | Human-triggered only | Command suggestions |

---

## Data Source Inventory

### Report Generators (23 scripts)

| # | Script | Output | Dashboard Relevance |
|---|--------|--------|---------------------|
| 1 | gemma-bazzite-health | Health status | HIGH |
| 2 | gemma-evals-check | Eval validation | HIGH |
| 3 | gemma-evals-status | Full status report | HIGH |
| 4 | gemma-examples-check | Example validation | MEDIUM |
| 5 | gemma-opencode-check | Bridge status | HIGH |
| 6 | gemma-security-summary | Security report | HIGH |
| 7 | gemma-knowledge-check | Knowledge pack status | MEDIUM |
| 8 | gemma-memory-search | Semantic search results | LOW |
| 9 | gemma-memory-rag | RAG answers | LOW |
| 10 | gemma-command-review | Command safety | MEDIUM |
| 11 | gemma-file-brief | File summary | LOW |
| 12 | gemma-repo-brief | Repo summary | LOW |
| 13-23 | (other helpers) | Various | LOW |

### Report Files

| Path | Type | Dashboard Relevance |
|------|------|---------------------|
| `~/offload/security-reports/manual/*.md` | Security reports | HIGH |
| `~/offload/security-reports/daily/*.md` | Daily reports | HIGH |
| `~/offload/security-reports/weekly/*.md` | Weekly reports | HIGH |
| `~/.local/state/bazzite-security/logs/*.log` | Logs | MEDIUM |
| `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt` | Validation manifests | LOW |

### Config Files

| Path | Type | Dashboard Relevance |
|------|------|---------------------|
| `~/.config/bazzite-security/*.md` | Policies and docs | MEDIUM |
| `~/.config/bazzite-security/ollama/Modelfile.*` | Model configs | LOW |

---

## Manual-Only Actions

These actions MUST be human-triggered (not autonomous):

| Action | Trigger | Script |
|--------|---------|--------|
| Run daily monitor | Human types command | gemma-monitor-daily |
| Run weekly monitor | Human types command | gemma-monitor-weekly |
| Check evals | Human types command | gemma-evals-check |
| Generate report | Human types command | gemma-security-summary |
| Re-index knowledge | Human types command | gemma-knowledge-index |
| Review examples | Human types command | gemma-examples-review-drafts |
| Start Agent Zero | Human types command | agent-zero-up |
| Stop Agent Zero | Human types command | agent-zero-down |

---

## Forbidden Buttons/Workflows

These are NOT ALLOWED in Space Agent:

| Forbidden | Reason |
|-----------|--------|
| Auto-remediate button | No autonomous fixes |
| Auto-restart Ollama | No service management |
| Auto-update firewall | No system changes |
| Auto-commit to repo | No autonomous commits |
| Auto-start Agent Zero | No autonomous agent spawning |
| Auto-ingest documents | No autonomous knowledge changes |
| Auto-delete files | No destructive operations |
| sudo button | No privilege escalation |

---

## Report Packet Format for Space Agent

Since Space Agent displays Markdown, reports should be:

```markdown
# System Status Report
**Date:** 2026-05-02 08:00:00
**Generator:** gemma-monitor-daily

## Infrastructure
- Ollama: ✅ v0.22.0 running
- Gemma: ✅ gemma4-e4b-bazzite available
- GPU: ✅ GTX 1060 6GB (3.2GB used)

## Integration
- OpenCode bridge: ✅ 127.0.0.1:4141 reachable

## Validation
- Eval cases: ✅ 25/25 PASS
- Examples: ✅ 32/32 reviewed

## Resources
- Disk: ✅ 45% used
- Logs: ⚠️ 1 log > 100MB

## Summary
Pass: 6 | Warn: 1 | Fail: 0
Duration: 8.2s
```

### Packet Requirements

| Requirement | Standard |
|-------------|----------|
| Format | Markdown |
| Date | ISO 8601 |
| Generator | Script name |
| Status | ✅ PASS / ⚠️ WARN / ❌ FAIL |
| Duration | Seconds |
| Path | `~/offload/security-reports/manual/` |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Space Agent capabilities | PASS | Chat UI, Markdown support |
| Data sources inventoried | PASS | 23 scripts, 5 report paths, 2 config paths |
| Dashboard categories | PASS | 5 categories defined |
| Manual actions | PASS | 8 actions listed |
| Forbidden workflows | PASS | 8 forbidden items |
| Packet format | PASS | Markdown standard defined |
| No autonomous features | PASS | All human-triggered |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 18A: COMPLETE
- Dashboard type: Conversational status interface (chat-based)
- Data sources: 23 scripts, 5 report paths
- Manual actions: 8 defined
- Forbidden workflows: 8 documented
- Report format: Markdown standard
- Next: Phase 18B (Dashboard Data Contract)

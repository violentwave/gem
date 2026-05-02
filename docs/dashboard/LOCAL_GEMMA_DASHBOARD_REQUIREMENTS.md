# Local Gemma Dashboard Requirements

**Document:** Local Gemma Dashboard Requirements
**Date:** 2026-05-02
**Version:** 1.0
**Status:** Current

---

## Purpose

Define requirements for a minimal, static, read-only local dashboard that gives the operator a single-page view of the Bazzite Local Gemma Agent stack health, status, and recent activity. The dashboard is a status display only — it does not take actions, execute commands, or enable autonomy.

---

## Non-Goals

The dashboard explicitly does NOT:

- Start, stop, or restart services.
- Modify configuration files.
- Execute commands that change system state.
- Enable autonomous agent behavior.
- Expose secrets, API keys, tokens, or session data.
- Run as a daemon or always-on server.
- Open a browser automatically (unless `--open` flag is explicitly passed).
- Replace Space Agent as the interactive chat UI.
- Replace Agent Zero as an orchestration layer.

---

## Safety Boundaries

- Read-only inspection only.
- Graceful degradation if a tool or command is missing.
- Secret redaction for any field that might contain credentials.
- No sudo required.
- No package installation.
- No model pulling.
- No firewall, USBGuard, ClamAV, Lynis, rpm-ostree, systemd, or service changes.
- No Agent Zero config changes.
- No Space Agent config changes.
- No Ollama config changes.

---

## Data Sources

The dashboard inspects the following read-only data sources:

| Source | What It Provides |
|--------|------------------|
| `ollama list` | Available models and sizes |
| `ollama --version` | Ollama version |
| `curl http://127.0.0.1:11434/api/version` | Ollama API health |
| `ps aux` | Space Agent process status |
| `~/.config/space-agent/` | Space Agent config existence (names/sizes only) |
| `~/.local/bin/gemma-*` | Helper script inventory |
| `~/.local/share/bazzite-security/gemma-evals/` | Eval case/example counts |
| `~/.local/share/bazzite-security/ruvector/` | RuVector prototype status |
| `~/offload/security-reports/manual/` | Recent report list |
| `~/.local/state/bazzite-security/logs/` | Recent log list |
| `nvidia-smi` | GPU memory usage (if available) |
| `podman ps` | Agent Zero container status (if available) |
| `curl http://127.0.0.1:4141` | OpenCode bridge status (if available) |

---

## Dashboard Panels

### 1. Stack Summary
- Host name, OS type, date/time
- Overall status indicator (PASS / WARN / FAIL based on critical checks)
- Quick count of models, helpers, reports

### 2. Space Agent
- Process status (running / not running)
- AppImage path and version (if detectable)
- Config directory existence
- Role: "Recommended manual local Gemma dashboard"

### 3. Ollama / Gemma
- Ollama version
- API health (127.0.0.1:11434)
- Model list with sizes
- GPU memory usage (if available)
- Custom profile name

### 4. Agent Zero
- Container status (running / not running)
- Version (if detectable from image or config)
- Role: "Experimental / no-go for local Gemma tool-loop use on v1.9"
- Link to M15 review doc

### 5. OpenCode
- Bridge status (127.0.0.1:4141)
- Role: "Implementation work, repo operations"

### 6. Knowledge / RAG
- Knowledge pack doc count
- Stage 3A chunk count (if index exists)
- RuVector chunk count (if prototype exists)
- `gemma-memory-search` and `gemma-memory-rag` availability

### 7. Evals / Examples
- Eval case count
- Example count
- Last validator run status

### 8. Recent Reports
- List of latest 5–10 reports from `~/offload/security-reports/manual/`
- File names and dates only

### 9. Guardrails / No-Go Items
- Bulleted list of current no-go policies:
  - No autonomous execution
  - No system config changes
  - Agent Zero local Gemma tool-loop: NO-GO
  - RuVector: supervised prototype only
  - Training/fine-tuning: deferred

### 10. Next Recommended Actions
- Dynamic suggestions based on status:
  - If evals stale → "Run gemma-evals-check"
  - If no recent reports → "Run gemma-monitor-daily"
  - If Space Agent not running → "Start Space Agent manually"

---

## Canonical Output Paths

| Output | Path |
|--------|------|
| HTML dashboard | `~/.local/share/bazzite-security/dashboard/index.html` |
| Markdown report | `~/offload/security-reports/manual/gemma-dashboard-YYYYMMDD-HHMMSS.md` |
| Log | `~/.local/state/bazzite-security/logs/gemma-dashboard-YYYYMMDD-HHMMSS.log` |

---

## Refresh Model

- The dashboard is **on-demand / manual refresh only**.
- The operator runs `scripts/gemma-dashboard-build` (or the installed helper) when they want an updated view.
- No timers, cron jobs, or systemd units are created.
- The HTML file is overwritten on each run.

---

## Secret-Redaction Policy

Any field that might contain a secret must be redacted:

- API keys → displayed as `[REDACTED]` or omitted.
- Tokens → `[REDACTED]`.
- Cookies → not inspected.
- Session storage → not inspected.
- Local storage → not inspected.
- Provider secrets → not inspected.

Only non-secret metadata (file names, sizes, process names, version strings) are displayed.

---

## Agent Zero No-Go Note

Agent Zero must be clearly labeled with the following statement:

> **Agent Zero (v1.9) — Experimental / no-go for local Gemma tool-loop use**
>
> Agent Zero can reach local Ollama at `10.0.2.2:11434`, but its agent-loop protocol requires JSON `tool_name`/`tool_args` responses. Local Gemma returns plain text. No chat-only or supervised profile exists in v1.9. Current profile is `hacker` (autonomous-oriented). See M15 review for details.

---

## Space Agent Role

Space Agent must be clearly labeled with the following statement:

> **Space Agent (v0.66.0) — Recommended manual local Gemma dashboard**
>
> Space Agent is a plain-text chat UI that works with local Gemma/Ollama via the OpenAI-compatible API. It does not parse tool requests or attempt autonomous actions. Start it manually from `~/Applications/Space-Agent.AppImage`.

---

## Acceptance Criteria

- [x] Dashboard requirements documented in this file.
- [x] Static dashboard generator script exists in `scripts/gemma-dashboard-build`.
- [x] Script uses bash or Python standard library only (no new dependencies).
- [x] Script does not start a server or daemon.
- [x] Script generates `~/.local/share/bazzite-security/dashboard/index.html`.
- [x] Script generates `~/offload/security-reports/manual/gemma-dashboard-YYYYMMDD-HHMMSS.md`.
- [x] Script generates `~/.local/state/bazzite-security/logs/gemma-dashboard-YYYYMMDD-HHMMSS.log`.
- [x] Script includes `--open` flag to optionally open the dashboard in a browser.
- [x] Script is read-only and does not modify system state.
- [x] Script redacts likely secrets.
- [x] Script degrades gracefully if tools are missing.
- [x] Script labels Agent Zero as experimental/no-go for local Gemma tool-loop use.
- [x] Script labels Space Agent as recommended manual local Gemma dashboard.
- [x] Script includes links/paths to latest relevant reports when available.
- [x] Dashboard passes `bash -n` syntax check.
- [x] Dashboard passes `shellcheck` if available.

---

## References

- `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`
- `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- `~/.config/bazzite-security/AGENT_ZERO_BOUNDARIES.md`

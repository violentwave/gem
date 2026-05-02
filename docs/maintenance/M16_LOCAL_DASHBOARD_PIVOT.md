# M16: Local Dashboard Pivot

**Maintenance Phase:** M16 — Local Dashboard Pivot
**Date:** 2026-05-02
**Status:** COMPLETE
**Classification:** Implementation / Read-Only Dashboard Generator

---

## Executive Summary

After M15 confirmed that Agent Zero v1.9 cannot safely use local Gemma for tool-loop operations, the stack pivots to a **local static dashboard** as the primary operator status view. Space Agent remains the recommended manual local Gemma chat UI. The dashboard is a read-only, on-demand HTML/Markdown generator that gives the operator a single-page view of stack health without starting services or enabling autonomy.

---

## M15 Recap

M15 findings that drive this pivot:

- Direct local Gemma API calls work from the Agent Zero container.
- Agent Zero's agent-loop expects JSON `tool_name`/`tool_args`; Gemma returns plain text.
- Current Agent Zero profile is `hacker` (autonomous-oriented, unsafe for supervised local use).
- No chat-only, local, supervised, or read-only Agent Zero profile exists in v1.9.
- Agent Zero supervised local profile design is documented but **not implementable** in v1.9.
- Space Agent works with local Gemma and is confirmed as the recommended manual dashboard.

**Decision:** Build a repo-tracked static dashboard generator that the operator runs on demand, rather than relying on Agent Zero for local Gemma status display.

---

## Space Agent Research (Read-Only)

### AppImage

- **Path:** `~/Applications/Space-Agent.AppImage`
- **Size:** 134,342,996 bytes (~128 MB)
- **Exists:** YES
- **Permissions:** Executable

### Process Status

- **Running:** YES
- **PID:** 927191 (main), 927187 (render), plus Electron helpers
- **Uptime:** Since 14:49 on 2026-05-02
- **User data dir:** `~/.config/space-agent/`

### Config Directory

- **Path:** `~/.config/space-agent/`
- **Contents:** Electron app data (cache, GPU cache, session storage, preferences, etc.)
- **Secrets:** Cookies, DIPS, Trust Tokens, Session Storage present but **not inspected**.
- **Preferences file:** Contains only spellcheck dictionary settings (`{"spellcheck":{"dictionaries":["en-US"],"dictionary":""}}`).
- **No provider config files found** in plain text.

### Provider State

| Provider | Status in Space Agent |
|----------|----------------------|
| OpenRouter | Works (from Phase 7E.1) |
| Local Gemma/Ollama | Works (from Phase 7E.1) |
| Google Gemini | Optional/unresolved retry |

### What Is Proven

- Space Agent AppImage exists and is executable.
- Space Agent can run manually without sudo.
- Space Agent works with local Gemma via Ollama OpenAI-compatible API.
- Space Agent does not require external API keys for local Gemma use.
- Space Agent is a manual UI, not an autonomous agent.

### What Is Unknown

- Exact provider secrets stored in Space Agent's encrypted storage (not inspected).
- Whether Space Agent auto-updates (updater ID present, but behavior unknown).
- Whether Space Agent writes to `~/conf/onscreen-agent.yaml` (not present, but documented as possible).

### What Is Unsafe to Assume

- Do not assume Space Agent config is stable across restarts.
- Do not assume provider selection persists without manual re-entry.
- Do not assume Space Agent can be scripted or automated.
- Do not assume Space Agent has no network activity beyond API calls.

### Is Space Agent Enough as the Manual Local Gemma Dashboard?

**YES, for chat.** Space Agent is a proven manual UI for local Gemma conversation.

**NO, for stack status.** Space Agent does not show Ollama health, eval status, report history, or guardrail status. The static dashboard fills this gap.

---

## Dashboard Design Decisions

### Why Static HTML?

- No server required.
- No daemon required.
- Can be opened in any browser from `file://`.
- Generated on demand, overwritten each run.
- Portable and archivable.

### Why Also Generate Markdown?

- Markdown is readable in terminal and Git.
- Can be copied into Space Agent or other UIs.
- Serves as an audit trail.

### Why Bash?

- Matches existing helper script conventions (`gemma-monitor-daily`, etc.).
- Uses `~/.local/lib/gemma-monitor-lib.sh` for consistent output formatting.
- No Python dependencies needed.
- Standard on Bazzite/Fedora Atomic.

---

## Created Artifacts

| Artifact | Path | Purpose |
|----------|------|---------|
| Dashboard requirements | `docs/dashboard/LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md` | Requirements spec |
| M16 closeout | `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md` | This document |
| Dashboard generator | `scripts/gemma-dashboard-build` | Build script (repo-tracked) |
| HTML output | `~/.local/share/bazzite-security/dashboard/index.html` | Generated dashboard |
| Markdown report | `~/offload/security-reports/manual/gemma-dashboard-YYYYMMDD-HHMMSS.md` | Generated report |
| Log | `~/.local/state/bazzite-security/logs/gemma-dashboard-YYYYMMDD-HHMMSS.log` | Build log |

---

## Dashboard Panels

1. **Stack Summary** — Overall PASS/WARN/FAIL, model count, helper count
2. **Space Agent** — Running status, AppImage path, recommended role
3. **Ollama / Gemma** — Version, API health, models, GPU usage
4. **Agent Zero** — Container status, version, no-go note
5. **OpenCode** — Bridge status, role
6. **Knowledge / RAG** — Doc count, chunk counts, helper availability
7. **Evals / Examples** — Case count, example count, validator status
8. **Recent Reports** — Latest 10 reports from manual directory
9. **Guardrails / No-Go** — Current policy boundaries
10. **Next Recommended Actions** — Dynamic suggestions

---

## Validation Results

| Check | Result |
|-------|--------|
| `bash -n scripts/gemma-dashboard-build` | PASS |
| `shellcheck scripts/gemma-dashboard-build` | PASS (if available) |
| Dashboard generation | PASS |
| HTML output exists | PASS |
| Markdown report exists | PASS |
| Log exists | PASS |
| No secrets in output | PASS |
| No system state changed | PASS |

---

## Boundary Confirmation

| Boundary | Status | Evidence |
|----------|--------|----------|
| No sudo | PASS | No sudo used |
| No package installs | PASS | No dnf/flatpak/brew |
| No model pulls | PASS | No ollama pull |
| No firewall changes | PASS | No firewalld |
| No Agent Zero config changes | PASS | No config modified |
| No Space Agent config changes | PASS | No config modified |
| No Ollama config changes | PASS | No config modified |
| No secrets exposed | PASS | Redaction applied |
| No daemon created | PASS | One-shot script |
| No LAN exposure | PASS | No server started |
| Read-only inspection | PASS | No state changes |

---

## Sign-Off

- M16 Pivot: COMPLETE
- Space Agent researched from local evidence: CONFIRMED
- Static dashboard generator created: CONFIRMED
- Dashboard output generated: CONFIRMED
- No system changes: CONFIRMED
- No secrets exposed: CONFIRMED
- Agent Zero remains supervised/experimental: CONFIRMED
- Space Agent remains recommended manual dashboard: CONFIRMED

---

## References

- `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`
- `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`
- `docs/dashboard/LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md`
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- `scripts/gemma-dashboard-build`

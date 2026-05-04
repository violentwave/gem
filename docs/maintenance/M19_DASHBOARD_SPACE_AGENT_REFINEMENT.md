# M19: Dashboard Data Quality and Space Agent Integration Refinement

**Maintenance Phase:** M19 — Dashboard Data Quality and Space Agent Integration Refinement
**Date:** 2026-05-03
**Status:** COMPLETE
**Classification:** Script Enhancement + Documentation

---

## Summary

M19 improves the dashboard's Space Agent detection reliability and clarifies the relationship between the static dashboard and Space Agent. The key insight is that **Space Agent is a chat UI**, while the **static dashboard is a status page** — they are complementary tools, not replacements for each other. The static dashboard does not appear inside Space Agent Spaces unless manually linked.

---

## Changes Made

### 1. Space Agent Detection Improved

**File:** `scripts/gemma-dashboard-build`

**Before:**
```bash
if pgrep -f "Space-Agent" >/dev/null 2>&1; then
```

**After:**
```bash
if pgrep -f "Space-Agent" >/dev/null 2>&1 || \
   pgrep -f "space-agent" >/dev/null 2>&1 || \
   pgrep -f "Space-Agent.AppImage" >/dev/null 2>&1; then
```

**Rationale:** The previous detection used a single case-sensitive pattern. While it worked in most cases, making it check multiple patterns (AppImage name, mount path binary, lowercase variant) ensures robustness across different process naming conventions.

### 2. Space Agent Panel Text Updated

**HTML panel now shows:**
- If running: `Chat UI running. Use the Space Agent window for conversation.`
- If not running: `Chat UI not running. Start: ~/Applications/Space-Agent.AppImage`
- Always: `This static dashboard does not appear inside Space Agent Spaces.`

**Markdown panel now shows:**
- Role: `Recommended manual local Gemma chat UI.`
- Dynamic status message based on running state
- Note: `This static dashboard does not appear inside Space Agent Spaces unless manually linked/imported.`

### 3. Operator Guide Updated

**File:** `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`

Added sections:
- **"How to Chat with Gemma"** — Step-by-step instructions for using Space Agent as the chat UI
- **"How Space Agent Fits In"** — Table comparing Space Agent (chat), static dashboard (status), and Markdown reports
- **Clarification:** The static dashboard does NOT appear inside Space Agent Spaces

### 4. Space Agent Local Evidence Researched (Read-Only)

**Findings:**
- Space Agent config path: `~/.config/space-agent/`
- Space Agent spaces directory: `~/.config/space-agent/customware/L2/user/spaces/`
- Each space is a subdirectory containing `space.yaml` (schema: `spaces/v2`)
- Existing spaces: `big-bang`, `crypto-dashboard`, `daily-news`
- Widget types observed: `news-feed`, `top-news`, `weather`, `tetris-game`, `minesweeper-game`, `snake-game`, `retro-marquee`, `pacman-game`
- **No evidence of a generic "web-view" or "local-html" widget type** in existing spaces
- **Conclusion:** Embedding the static dashboard inside Space Agent Spaces is not straightforward and would require either:
  - A custom widget type not yet observed
  - Manual experimentation with the `spaces/v2` schema
  - Upstream Space Agent support for local file embedding

**No Space Agent config was modified.**

---

## Validation

| Check | Command | Result |
|-------|---------|--------|
| Syntax check | `bash -n scripts/gemma-dashboard-build` | PASS |
| shellcheck | `shellcheck scripts/gemma-dashboard-build` | PASS (info only) |
| Dashboard generation | `scripts/gemma-dashboard-build` | PASS |
| HTML output exists | `test -f ~/.local/share/bazzite-security/dashboard/index.html` | PASS |
| Report output exists | `ls -lt ~/offload/security-reports/manual/gemma-dashboard-*.md` | PASS |
| Space Agent panel text | Checked HTML output | PASS — shows "Chat UI running" |

---

## No-Go Boundaries Preserved

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
| Read-only inspection | PASS | No state changes |

---

## Remaining Uncertainty

1. **Space Agent widget types:** The `spaces/v2` schema supports built-in widgets like `news-feed` and `weather`, but no generic HTML/local-file widget was observed. Whether such a widget exists or can be created is unknown.
2. **Space Agent auto-update:** The `.updaterId` file exists but update behavior is unknown.
3. **Dashboard inside Space Agent:** Would require either a custom widget or upstream Space Agent support. Not attempted in this phase.
4. **Process detection edge cases:** If Space Agent changes its process naming in a future version, detection may need further refinement.

---

## Sign-Off

- M19 Dashboard Space Agent Refinement: COMPLETE
- Space Agent detection improved: CONFIRMED
- Panel text clarified: CONFIRMED
- Operator guide updated: CONFIRMED
- Space Agent local evidence researched: CONFIRMED
- No system changes: CONFIRMED
- No secrets exposed: CONFIRMED

---

## References

- `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- `docs/dashboard/LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md`
- `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md`
- `docs/maintenance/M17_DASHBOARD_OPERATOR_WORKFLOW.md`
- `scripts/gemma-dashboard-build`

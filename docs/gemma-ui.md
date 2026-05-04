# gemma-ui — Unified Terminal UI

**Path:** `~/.local/bin/gemma-ui`  
**Alias:** `~/.local/bin/gemma-agent -> gemma-ui`  
**Config:** `~/.config/bazzite-security/gemma-ui.json`

---

## What It Is

gemma-ui is the main local terminal front door for the Bazzite Local AI Operations Stack. It provides a single entry point that routes to all Gemma helpers and security tools.

gemma-security-chat remains available as the security console helper.

---

## Philosophy

- **Delegate, don't duplicate.** `gemma-ui` is a router, not a replacement. It calls existing helpers.
- **Graceful degradation.** Missing helpers show "not configured" rather than crashing.
- **Advisory only.** No autonomous actions. No sudo without confirmation.
- **Local-only.** No always-listening daemon, web server, LiveKit dependency, or network exposure is part of this phase.

---

## Usage

```bash
# Interactive mode selector (default)
gemma-ui

# Start directly in a mode
gemma-ui --mode general
gemma-ui --mode security
gemma-ui --mode memory
gemma-ui --mode repo
gemma-ui --mode reports
gemma-ui --mode health

# Render demo UI without running tools
gemma-ui --demo-ui

# List available modes
gemma-ui --list-modes

# Show help
gemma-ui --help
```

---

## Welcome Screen

On startup, gemma-ui shows a polished welcome panel:

```
╭─ Bazzite Local AI Operations Stack ──────────────────────────────────────────╮
│                                                                              │
│  Gemma Local Agent                                                           │
│  Bazzite assistant — terminal UI                                             │
│                                                                              │
│  Model:     gemma4-e4b-bazzite                                               │
│  Ollama:    online  (3 models)                                               │
│  Tools:     13/15 available                                                  │
│  Memory:    RuVector ready                                                   │
│  Voice:     not configured                                                   │
│                                                                              │
│  Local  ·  Advisory  ·  Human-confirmed tools                                │
│                                                                              │
╰──────────────────────────────────────────────────────────────────────────────╯
```

---

## Status Bar

A compact status bar shows live system state:

```
─ mode welcome | ollama online | tools 13/15 | mem RuVector | voice not configured ─
```

---

## Modes

Modes can be selected by number or command:

| # | Mode | Command | Delegates To | Description | Status |
|---|------|---------|-------------|-------------|--------|
| 1 | General | `/general` or `/1` | `gemma-bazzite` | Chat with local Gemma | ready |
| 2 | Security | `/security` or `/2` | `gemma-security-chat` | Security tool console | ready |
| 3 | Memory | `/memory` or `/3` | `gemma-memory-search`, `gemma-knowledge-search` | RuVector / Stage 3A search | ready |
| 4 | Repo | `/repo` or `/4` | `gemma-repo-brief` | Repo summaries | ready |
| 5 | Voice | `/voice` or `/5` | `gemma-voice-chat` | Voice chat (status only if not configured) | not configured |
| 6 | Reports | `/reports` or `/6` | built-in | Browse recent reports | built-in |
| 7 | Health | `/health` or `/7` | built-in + `gemma-bazzite-health` | Safe status checks | ready |

---

## UI Commands

| Command | Description |
|---------|-------------|
| `/help` | Show help |
| `/mode` | Show mode selector |
| `/clear` | Clear the screen |
| `/save` | Save current session state |
| `/back` | Return to welcome screen |
| `/quit` | Exit |

---

## Transcript-Style Output

Conversations are displayed in panel format with clear labels:

```
╭──────────────────────────────────────────────────────────────────────────────╮
│ 15:11:21 You                                                                 │
│ Check my firewall status                                                     │
╰──────────────────────────────────────────────────────────────────────────────╯
╭──────────────────────────────────────────────────────────────────────────────╮
│ 15:11:21 Gemma                                                               │
│ firewalld is active. Default zone: public. Default target: DROP.             │
╰──────────────────────────────────────────────────────────────────────────────╯
```

Timestamps are shown when `show_timestamps: true` in config.

---

## Risk Labels

Each tool displays a risk label:

| Label | Meaning |
|-------|---------|
| **SAFE READ-ONLY** | No system changes, no sudo |
| **CONFIRM REQUIRED** | May prompt before action |
| **SUDO / MANUAL** | Requires explicit sudo or manual review |
| **UNAVAILABLE** | Helper not configured |

---

## Helper Detection

`gemma-ui` scans `~/.local/bin/` for known helpers on startup:

- **✓ ready** — helper found and ready
- **✗ not configured** — helper missing, mode still accessible

Detected helpers (15 total):
- ✅ `gemma-bazzite` — General chat
- ✅ `gemma-security-chat` — Security console
- ✅ `gemma-security-analyzer` — Security analysis
- ✅ `gemma-memory-search` — RuVector semantic search
- ✅ `gemma-memory-rag` — RuVector RAG
- ✅ `gemma-knowledge-search` — Stage 3A deterministic search
- ✅ `gemma-knowledge-rag` — Stage 3A RAG
- ✅ `gemma-command-review` — Command safety review
- ✅ `gemma-repo-brief` — Repo summaries
- ✅ `gemma-file-brief` — File summaries
- ✅ `gemma-bazzite-health` — Health checks
- ✅ `gemma-monitor-daily` — Daily monitor
- ✅ `gemma-monitor-drift` — Drift detection
- ❌ `gemma-dashboard-build` — Not in PATH
- ❌ `gemma-voice-chat` — Not configured

---

## Voice Mode

Voice mode is local push-to-talk only when configured.

**Interaction:**
- Use `r` or `/r` or `/record` to record.
- `pw-record` duration is controlled by `timeout`.
- Voice mode remains push-to-talk only.
- Voice mode does not bypass confirmation gates.
- No always-listening daemon or wake word is used.

When `gemma-voice-chat` is not installed, the UI shows:
- Current configuration status
- Setup guide for local STT/TTS options (whisper.cpp, piper)
- No automatic installation

---

## Config

`~/.config/bazzite-security/gemma-ui.json`:

```json
{
  "version": "1.0.0",
  "default_mode": "general",
  "theme": "default",
  "show_icons": true,
  "show_timestamps": true,
  "features": {
    "voice": false,
    "memory": true,
    "repo": true,
    "dashboard": false,
    "auto_health_check": false
  },
  "paths": {
    "helpers_dir": "~/.local/bin",
    "reports_dir": "~/offload/security-reports/manual",
    "logs_dir": "~/.local/state/bazzite-security/logs",
    "config_dir": "~/.config/bazzite-security"
  }
}
```

---

## Safety Boundaries

- No sudo without explicit user confirmation
- No autonomous remediation
- Missing helpers handled gracefully
- Delegates to existing helpers rather than duplicating logic

---

## Files

| File | Purpose |
|------|---------|
| `~/.local/bin/gemma-ui` | Main unified UI script |
| `~/.local/bin/gemma-agent` | Symlink to gemma-ui |
| `~/.config/bazzite-security/gemma-ui.json` | Config |
| `~/.local/state/bazzite-security/logs/` | Logs |

---

## Related

- `gemma-security-chat` — Rich security tool console (still works independently)
- `gemma-bazzite` — Direct Ollama wrapper (still works independently)
- `gemma-memory-search` — RuVector search (still works independently)
- `gemma-repo-brief` — Repo briefs (still works independently)

---

## Validation Commands

```bash
# Syntax check
python3 -m py_compile ~/.local/bin/gemma-ui

# Help
~/.local/bin/gemma-ui --help

# List modes
~/.local/bin/gemma-ui --list-modes

# Demo UI
~/.local/bin/gemma-ui --demo-ui

# Verify alias
ls -la ~/.local/bin/gemma-agent

# Verify config
cat ~/.config/bazzite-security/gemma-ui.json
```

---

## Changelog

- **2026-05-04** — v1.0.0. Initial unified front door. 8 modes. 15 helpers.
- **2026-05-04** — v1.1.0. LiveKit-inspired UI overhaul:
  - Welcome screen with model/status display
  - Top status bar (mode, Ollama, tools, voice, memory)
  - Numbered mode selector [1]-[7]
  - Transcript-style output panels
  - Consistent footer (/help, /mode, /back, /quit)
  - Risk labels per tool (SAFE, CONFIRM, SUDO)
  - Grouped tool display by category
  - `--demo-ui` flag for UI preview

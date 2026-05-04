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
| 3 | Memory | `/memory` or `/3` | `gemma-memory-search`, `gemma-knowledge-search` | Supervised RuVector + Stage 3A fallback | ready |
| 4 | Repo | `/repo` or `/4` | `gemma-repo-brief` | Repo summaries | ready |
| 5 | Voice | `/voice` or `/5` | `gemma-voice-chat` | Voice chat (status only if not configured) | not configured |
| 6 | Reports | `/reports` or `/6` | built-in | Browse recent reports | built-in |
| 7 | Health | `/health` or `/7` | built-in + `gemma-bazzite-health` | Safe status checks | ready |
| 8 | Dashboard | `/dashboard` or `/8` | built-in | Read-only status dashboard | built-in |

---

## UI Commands

| Command | Description |
|---------|-------------|
| `/help` | Show help |
| `/mode` | Show mode selector |
| `/dashboard` | Show read-only status dashboard |
| `/status` | Alias for `/dashboard` |
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

## Memory Mode

Memory mode provides explicit supervised access to RuVector and Stage 3A retrieval.

**Commands:**
```
/memory status          Show memory mode status
/memory search <query>  RuVector semantic search (supervised)
/memory ask <question>  RuVector RAG with Ollama (supervised)
/memory stage3a <q>     Stage 3A deterministic fallback
/memory compare <q>     Run both and summarize differences
/memory help            Show memory help
```

**CLI flags:**
```bash
gemma-ui --memory-status
gemma-ui --memory-search "<query>"
gemma-ui --memory-ask "<question>"
gemma-ui --memory-stage3a "<question>"
gemma-ui --memory-compare "<question>"
```

**Safety:**
- RuVector memory mode is explicit and supervised.
- RuVector is not the default retrieval path.
- Stage 3A deterministic retrieval remains the canonical fallback.
- Memory mode performs read-only retrieval/RAG only.
- Memory mode does not ingest new data, train the model, mutate repos, or execute remediation.

---

## Config

`~/.config/bazzite-security/gemma-ui.json`:

```json
{
  "version": "1.2.0",
  "default_mode": "general",
  "theme": "default",
  "accent": "cyan",
  "show_icons": true,
  "show_timestamps": true,
  "compact_mode": false,
  "confirm_tools": true,
  "confirm_sudo_tools": true,
  "features": {
    "general": true,
    "security": true,
    "memory": true,
    "repo": true,
    "voice": true,
    "reports": true,
    "health": true,
    "dashboard": false,
    "web_ui": false,
    "livekit": false
  },
  "voice": {
    "duration_seconds": 6,
    "delete_audio_by_default": true,
    "recorder_preference": "auto",
    "stt_preference": "auto",
    "tts_preference": "auto"
  },
  "paths": {
    "helpers_dir": "~/.local/bin",
    "reports_dir": "~/offload/security-reports/manual",
    "logs_dir": "~/.local/state/bazzite-security/logs",
    "config_dir": "~/.config/bazzite-security"
  }
}
```

### Config Commands

```bash
gemma-ui --config        # Print current config
gemma-ui --config-check  # Validate config and show feature flags
```

### Config Behavior

- Missing keys are backfilled from defaults automatically.
- User-set values are preserved.
- Invalid values trigger warnings but do not crash the UI.
- `web_ui` and `livekit` remain disabled; enabling them produces a warning.

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

# Dashboard
~/.local/bin/gemma-ui --dashboard

# Config check
~/.local/bin/gemma-ui --config-check

# View config
~/.local/bin/gemma-ui --config

# Verify alias
ls -la ~/.local/bin/gemma-agent

# Verify config file
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
- **2026-05-04** — v1.2.0. Config-driven UI expansion:
  - Expanded config schema with accent, compact_mode, confirm_tools
  - Feature flags for all 10 modes (general, security, memory, repo, voice, reports, health, dashboard, web_ui, livekit)
  - Voice settings block (duration, delete_audio, recorder/stt/tts preference)
  - Config validation with safe fallbacks
  - `--config` and `--config-check` CLI flags
  - Deep merge backfill preserves user values
  - `web_ui` and `livekit` remain disabled with warnings
- **2026-05-04** — v1.3.0. Non-invasive status dashboard:
  - `/dashboard` and `/status` commands (mode [8])
  - `--dashboard` and `--status` CLI flags
  - Read-only dashboard: Core, Voice, Memory, Repo, Safety, Feature Flags
  - No scans run. No sudo. No system changes.
- **2026-05-04** — v1.4.0. Supervised memory mode:
  - `/memory` subcommands: status, search, ask, stage3a, compare
  - `--memory-status`, `--memory-search`, `--memory-ask`, `--memory-stage3a`, `--memory-compare` CLI flags
  - RuVector remains explicit supervised secondary
  - Stage 3A remains canonical deterministic fallback
  - Read-only retrieval/RAG only. No ingestion.

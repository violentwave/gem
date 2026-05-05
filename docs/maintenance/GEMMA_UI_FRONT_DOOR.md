# Gemma UI Front Door

**Status:** ✅ Operational  
**Created:** 2026-05-04  
**Location:** `~/.local/bin/gemma-ui`  
**Alias:** `~/.local/bin/gemma-agent -> gemma-ui`  
**Config:** `~/.config/bazzite-security/gemma-ui.json`

---

## What This Is

gemma-ui is the main local terminal front door for the Bazzite Local AI Operations Stack. It provides a single entry point that routes to all Gemma helpers and security tools.

gemma-security-chat remains available as the security console helper.

---

## Philosophy

- **Delegate, don't duplicate.** gemma-ui is a router, not a replacement. It calls existing helpers.
- **Graceful degradation.** Missing helpers show "not configured" rather than crashing.
- **Advisory only.** No autonomous actions. No sudo without confirmation.
- **Local-only.** No always-listening daemon, web server, LiveKit dependency, or network exposure is part of this phase.

---

## Modes

| Mode | Command | Delegates To | Description |
|------|---------|-------------|-------------|
| General | `/general` | `gemma-bazzite` | Normal chat with local Gemma |
| Security | `/security` | `gemma-security-chat` | Security tool console |
| Memory | `/memory` | `gemma-memory-search`, `gemma-knowledge-search` | RuVector / Stage 3A search |
| Repo | `/repo` | `gemma-repo-brief` | Repo summaries for gem, bazzite-laptop |
| Voice | `/voice` | `gemma-voice-chat` | Voice chat (status only if not configured) |
| Reports | `/reports` | built-in | Browse recent generated reports |
| Tools | `/tools` | built-in | List all available helpers |
| Health | `/health` | built-in + `gemma-bazzite-health` | Safe status checks |
| Dashboard | `/dashboard` | built-in | Read-only status dashboard |

### UI Commands

| Command | Description |
|---------|-------------|
| `/help` | Show help |
| `/mode` | Show mode selector |
| `/dashboard` | Show read-only status dashboard |
| `/status` | Alias for `/dashboard` |
| `/integration` | Show integration metadata (display-only) |
| `/clear` | Clear the screen |
| `/save` | Save current session state |
| `/quit` | Exit |

---

## Voice Mode

Voice mode is local push-to-talk only when configured.

When `gemma-voice-chat` is not installed, the UI shows:
- Current configuration status
- Setup guide for local STT/TTS options (whisper.cpp, piper, porcupine)
- No automatic installation

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

## Helper Detection

gemma-ui scans `~/.local/bin/` for known helpers on startup. Missing helpers are shown as "not configured" and do not crash the UI.

Detected helpers (as of 2026-05-04):
- ✅ `gemma-bazzite` — General chat
- ✅ `gemma-security-chat` — Security console
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

## Safety Boundaries

Same as the rest of the stack:
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

# Verify alias
ls -la ~/.local/bin/gemma-agent

# Verify config
cat ~/.config/bazzite-security/gemma-ui.json
```

---

## Changelog

- **2026-05-04** — v1.0.0. Unified front door. 10 modes. 15+ helpers. gemma-agent alias. Config-driven.

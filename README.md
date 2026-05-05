# Bazzite Local AI Operations Stack

**Repo Path:** `~/projects/gem`

## Purpose

Source of truth for the Bazzite Local AI Operations Stack. This repo contains all product source code, documentation, and the install script needed to reproduce the system on a fresh Bazzite/Fedora Atomic host.

## Repo Structure

| Directory | Contents |
|-----------|----------|
| `bin/` | Product source code — all `gemma-*` executables |
| `docs/` | Architecture, roadmaps, operational docs, maintenance guides |
| `artifacts/` | Compressed archives of completed phases and historical prototypes |
| `tests/` | Test fixtures |
| `install.sh` | One-command installer — copies `bin/*` to `~/.local/bin/` |

## Install

```bash
cd ~/projects/gem
./install.sh
```

Dry-run to preview:

```bash
./install.sh --dry-run
```

Ensure `~/.local/bin` is in your `PATH`, then:

```bash
gemma-ui --help
gemma-ui --dashboard       # Primary dashboard (built into TUI)
```

## Product Components

### Core UI
- `gemma-ui` — Unified terminal router (10 modes, 20+ helpers)
- `gemma-agent` — Alias wrapper for `gemma-ui`
- `gemma-security-chat` — Interactive security tool console
- `gemma-voice-chat` — Voice chat with intent routing

### Chat & Search
- `gemma-bazzite` — General chat with local Gemma
- `gemma-bazzite-health` — Safe system status checks
- `gemma-memory-search` — RuVector semantic search
- `gemma-memory-rag` — RuVector RAG helper
- `gemma-knowledge-search` — Knowledge base search
- `gemma-knowledge-rag` — Knowledge base RAG

### Repo & File Tools
- `gemma-repo-brief` — Repository summaries
- `gemma-file-brief` — File analysis
- `gemma-command-review` — Command safety review
- `gemma-security-analyzer` — Security analysis wrapper

### Monitoring & Dashboard
- `gemma-monitor-daily` — Daily health check
- `gemma-monitor-drift` — Configuration drift detection
- `gemma-monitor-weekly` — Weekly summary
- `gemma-dashboard` — Optional static HTML/Markdown export (legacy compatibility)

### Quality Assurance
- `gemma-evals-check` — Eval case validation
- `gemma-examples-check` — Example quality checks

## Configuration

Product configuration lives outside the repo at canonical paths:

- `~/.config/bazzite-security/` — Config files, policies, runbooks
- `~/.local/share/bazzite-security/` — Persistent state, indexes
- `~/.local/state/bazzite-security/logs/` — Logs
- `~/.cache/bazzite-security/` — Runtime cache
- `~/offload/security-reports/` — Generated reports

## Documentation

- `docs/gemma-ui.md` — Main UI specification
- `docs/roadmap/ROADMAP.md` — Full roadmap
- `docs/live-system/CURRENT_STATE.md` — Current system state
- `docs/ARCHIVE_INDEX.md` — How to access archived phase docs

## Security Boundaries

- No secrets in repo
- No `.env` files
- No raw logs
- No private code
- Runtime artifacts stay in canonical paths

## License

Internal project documentation. Not for distribution.

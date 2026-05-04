# Gemma UI Memory Mode Regression Closeout

## Version
- **gemma-ui:** v1.4.2
- **Date:** 2026-05-04
- **Commit:** daafc10 (origin/main)
- **Host:** Bazzite/Fedora Atomic
- **User:** lch

## Scope
Regression closeout for gemma-ui RuVector Memory Mode v1.4.2.
Validates that the memory mode feature set (status, dashboard, search, ask, stage3a, compare, voice routing) works without regression, does not ingest data, does not promote RuVector to default, and preserves Stage 3A as canonical fallback.

## Validation Checklist

### 1. Syntax Checks
| Check | Command | Result |
|---|---|---|
| gemma-ui syntax | `python3 -m py_compile ~/.local/bin/gemma-ui` | ✅ PASS |
| gemma-voice-chat syntax | `python3 -m py_compile ~/.local/bin/gemma-voice-chat` | ✅ PASS |

### 2. Safe Memory UI Checks
| Check | Command | Result |
|---|---|---|
| Memory status | `gemma-ui --memory-status` | ✅ PASS |
| Memory dashboard | `gemma-ui --memory-dashboard` | ✅ PASS |
| General dashboard | `gemma-ui --dashboard` | ✅ PASS |
| List modes | `gemma-ui --list-modes` | ✅ PASS |

### 3. Short Query Checks
| Check | Command | Result |
|---|---|---|
| RuVector search | `gemma-ui --memory-search "RuVector promotion decision"` | ✅ PASS |
| Stage 3a fallback | `gemma-ui --memory-stage3a "What is the safe operating model?"` | ✅ PASS |
| Compare both | `gemma-ui --memory-compare "What did we decide about RuVector?"` | ✅ PASS |

### 4. Safety Verification
| Requirement | Verification | Result |
|---|---|---|
| No sudo used | All commands run as user `lch` | ✅ CONFIRMED |
| No packages installed | No rpm-ostree, dnf, flatpak, brew calls | ✅ CONFIRMED |
| No host settings changed | No firewall, SSH, auditd, systemd changes | ✅ CONFIRMED |
| No security scans run | No lynis, clamav, audit tools invoked | ✅ CONFIRMED |
| No ingestion | Index files unchanged (RuVector 8.6M Apr 30, Stage 3A 512K May 2, 335 chunks) | ✅ CONFIRMED |
| No raw logs/transcripts indexed | No new files in knowledge dir; ruvector cache files predate this session | ✅ CONFIRMED |
| No default promotion | `print_memory_dashboard()` shows "Promotion: denied / not default" | ✅ CONFIRMED |
| Stage 3A fallback preserved | Dashboard shows "Stage 3A: canonical fallback"; `--memory-stage3a` works | ✅ CONFIRMED |
| RuVector supervised-secondary | Dashboard shows "RuVector: supervised secondary"; not default | ✅ CONFIRMED |

### 5. Feature Coverage

#### v1.4.0 Features (Base)
- `/memory status` — Shows helper availability and policy status
- `/memory search <q>` — RuVector semantic search (supervised)
- `/memory ask <q>` — RuVector RAG with Ollama (supervised)
- `/memory stage3a <q>` — Stage 3A deterministic fallback
- `/memory compare <q>` — Run both and summarize differences
- `/memory help` — Show memory help
- `--memory-status`, `--memory-search`, `--memory-ask`, `--memory-stage3a`, `--memory-compare` CLI flags

#### v1.4.1 Features (Voice Routing)
- Intent router detects memory subcommands: ask, search, compare, stage3a
- `route_intent()` returns `(mode, subcmd, reason)` triple
- Voice session prints detected route before executing
- Memory RAG requires confirmation before running in voice session
- No transcript ingestion; no training data storage

#### v1.4.2 Features (Quality Dashboard)
- `/memory dashboard` — Interactive memory quality dashboard
- `/memory quality` — Alias for dashboard
- `--memory-dashboard` CLI flag
- `print_memory_dashboard()` with 5 sections:
  1. Helper availability
  2. Known policy status
  3. Current index state (read-only)
  4. Recommended use
  5. Warnings

### 6. Policy Assertions (From Code)
- `mode_memory()` docstring: "RuVector is not the default retrieval path. Stage 3A deterministic retrieval remains the canonical fallback."
- `print_memory_dashboard()` shows: "Promotion: denied / not default"
- `print_memory_dashboard()` warnings: "No default promotion. RuVector stays supervised. Stage 3A fallback preserved."
- All memory helpers use subprocess argument arrays (no shell injection).
- All outputs go to canonical read-only report/log paths.

## Files Validated
- `~/.local/bin/gemma-ui` — v1.4.2, syntax valid, all modes functional
- `~/.local/bin/gemma-voice-chat` — syntax valid, intent routing functional

## Docs Validated
- `docs/gemma-ui.md` — Updated with v1.4.2 changelog, dashboard commands, CLI flags
- `docs/maintenance/GEMMA_UI_MEMORY_MODE.md` — Updated with dashboard section and example output

## Index State (Read-Only Verification)
| Index | Path | Size | Chunks | Status |
|---|---|---|---|---|
| RuVector | `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` | 8.6 MB | N/A (semantic) | ✅ Present, unchanged |
| Stage 3A | `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | 512 KB | 335 | ✅ Present, unchanged |
| Manifest | `~/.local/share/bazzite-security/gemma-knowledge/index/manifest.json` | — | — | ⚠ Not found |

## Regression Verdict
**✅ PASS**

All syntax checks pass. All UI checks pass. All short query checks pass. No ingestion occurred. No default promotion. Stage 3A fallback preserved. RuVector remains supervised secondary. No sudo, no packages, no host changes, no scans.

## Signoff
- **Regression performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-04
- **Commit:** daafc10
- **Next phase:** Phase 6 — Sandbox Prototypes (⏳ Upcoming)

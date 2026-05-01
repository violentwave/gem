# Agent Instructions for Bazzite Local AI Operations Stack

**Read First:** `README.md`

**Read Before Implementation:** `docs/live-system/CURRENT_STATE.md`

## Core Rules

### No Unauthorized System Changes
- **No sudo** unless a future prompt explicitly authorizes a reviewed sudo step
- **No firewall changes** (firewalld, ufw)
- **No USBGuard changes**
- **No ClamAV/Lynis changes**
- **No rpm-ostree changes**
- **No systemd timer changes**
- **No package state changes**
- **No OpenCode permission changes**
- **No Ollama service config changes**
- **No model config changes**

### Preserve Live Canonical Paths
Live files remain in place. This repo coordinates, does not replace:
- `~/.config/bazzite-security/` - Config source of truth
- `~/.local/bin/` - Helper scripts
- `~/.local/share/bazzite-security/` - Persistent state
- `~/.local/state/bazzite-security/logs/` - Logs
- `~/.cache/bazzite-security/` - Cache
- `~/offload/security-reports/` - Reports

### No Secrets in Repo
- Do not copy `.env` files
- Do not copy secrets, tokens, API keys
- Do not copy raw private logs
- Do not copy browser data, cookies, sessions
- Do not copy unredacted OpenCode transcripts
- Do not copy private project source code

### Bazzite/Fedora Atomic Context
- Use **firewalld**, not ufw
- Use **rpm-ostree**, not apt
- Prefer Flatpak for GUI apps
- Prefer Homebrew for non-root CLI tools
- Prefer containers/distrobox/quadlet for isolation
- Never assume Ubuntu/Debian

### Model Roles
- **Gemma:** Advisory only through wrappers. Not unattended implementation agent.
- **gemma-memory-search:** Supervised semantic search using RuVector. Primary when evidence supports it.
- **gemma-memory-rag:** Supervised RAG using RuVector context + local Ollama. NOT a wrapper default.
- **OpenCode/Codex:** Implementation work. Use GPT-5.4-class models.
- **Agent Zero:** Assessment phase. Not yet integrated.
- **RuVector:** Supervised prototype only. NOT production default. Stage 3A remains canonical fallback.

### Package Installation
- Do not install packages unless explicitly authorized
- Prefer Flatpak/Distrobox over rpm-ostree layering
- Use least-invasive options first

### Runtime Artifacts
- Keep generated artifacts in canonical paths
- Do not write runtime state into this repo unless explicitly sanitized and intended as project metadata
- Reports go to `~/offload/security-reports/`
- Logs go to `~/.local/state/bazzite-security/logs/`

## Implementation Guidelines

### Before Starting
1. Read `README.md`
2. Read `docs/live-system/CURRENT_STATE.md`
3. Check `docs/roadmap/ROADMAP.md` for current phase
4. Verify no blocking issues in current phase

### During Implementation
1. Match existing patterns in codebase
2. Use canonical paths, not relative assumptions
3. Validate with existing validators when applicable
4. Document changes in repo, not just code

### After Implementation
1. Run safe validation commands
2. Check no secrets leaked
3. Verify no system changes made
4. Update relevant docs if needed

## Phase-Specific Rules

### Phase 8 (Workflow Libraries - Completed 2026-05-01)
- Phase 8A: Agent Zero workflow library defined (L5), NOT executed
- Phase 8B: Memory workflow library defined (L6), RuVector remains supervised prototype
- Phase 8B.6: gemma-memory-search helper created — supervised semantic search
- Phase 8B.7: gemma-memory-rag helper created — supervised RAG with Ollama
- Phase 8B.7A: Context extraction fix (TOP_N=4, CHARS_PER_CHUNK=1800)
- Phase 8C: Space Agent workspace workflows defined (L7, manual only)
- Phase 8D: Workflow index, repo baseline, GitHub remote completed
- **Important:** RuVector is NOT the default — Stage 3A remains fallback
- **Important:** No autonomous memory/learning loops enabled

### Phase 5A (Repo Bootstrap)
- Create coordination repo structure
- Create documentation
- Create planning artifacts
- Do not install Agent Zero, RuVector, or Space Agent yet

### Phase 5B (Architecture Expansion)
- Document architecture
- Define capability levels
- Plan integration approach
- Do not modify live system configs

### Phase 5C (Agent Zero Inventory)
- Verify A0 installation only
- Identify paths and connectors
- Do not start A0 services
- Do not modify A0 config

### Phase 5D (RuVector Assessment)
- Review RuVector architecture only
- Assess local-only feasibility
- Do not clone RuVector repo yet
- Do not install Rust/Docker dependencies yet

### Phase 5E (Space Agent Assessment)
- Research Space Agent only
- Assess Linux compatibility
- Do not install Space Agent yet

## Emergency Stop Conditions

Stop and ask for clarification if:
- A prompt asks to change firewall rules
- A prompt asks to install system-wide packages with sudo
- A prompt asks to modify Ollama model config
- A prompt asks to copy `.env` or secrets into repo
- A prompt asks to run Agent Zero or Space Agent
- A prompt asks to start RuVector services

## Questions?

Check `docs/` for architecture, roadmap, and integration plans.
Check `inventory/` for current system state.
Check `prompts/` for phase-specific prompts.

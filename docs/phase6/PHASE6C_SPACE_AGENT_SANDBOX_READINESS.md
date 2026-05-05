# Phase 6C: Space Agent Sandbox Readiness Review

## Version
- **Date:** 2026-05-05
- **Host:** Bazzite/Fedora Atomic
- **User:** lch
- **gemma-ui:** v1.4.3
- **Repo:** ~/projects/gem
- **Classification:** Read-Only Assessment / No Authority Granted

## Scope
Read-only sandbox readiness review for Space Agent in the Bazzite Local AI Operations Stack.
This document assesses whether Space Agent is in a safe state for supervised manual UI use.

## Safety Rules
- **No authority granted to Space Agent.**
- **No root/system/security write authority.**
- **Space Agent must not become the security control plane.**
- **No sudo, no packages, no host changes.**
- **Space Agent must remain manual UI only.**
- **No autonomous behavior enabled.**
- **No secrets exposed.**

## Current Status

### Installation State
| Attribute | Value |
|-----------|-------|
| AppImage Path | `~/Applications/Space-Agent.AppImage` |
| Size | 129 MB (134,342,996 bytes) |
| Version | v0.66.0 |
| File Type | ELF 64-bit LSB executable, x86-64, dynamically linked |
| Executable | Yes (`chmod +x` applied) |
| Install Method | AppImage (user-local) |

### Runtime State
| Attribute | Value |
|-----------|-------|
| Currently Running | **No** |
| Matching Processes | None found |
| Last Launch | 2026-05-02 (Phase 12L) |
| Stop Verification | Clean (all processes terminated) |

### Config / Data Paths
| Path | Exists | Contents |
|------|--------|----------|
| `~/.config/space-agent/` | ✅ Yes | Electron app data (cache, cookies, storage, preferences) |
| `~/.local/share/space-agent/` | ❌ No | Not present |
| `~/conf/onscreen-agent.yaml` | ❌ No | Not present |
| Desktop entry | ❌ No | Not present |
| Helper scripts in `~/.local/bin/` | ❌ No | Not present |

### Config Directory Breakdown
| Item | Type | Notes |
|------|------|-------|
| `blob_storage/` | Dir | Electron app storage |
| `Cache/`, `Code Cache/` | Dir | Browser caches |
| `Cookies` | File | Browser cookies (NOT read in this phase) |
| `Crashpad/` | Dir | Crash reports |
| `customware/` | Dir | Custom data / spaces |
| `DawnGraphiteCache/`, `DawnWebGPUCache/` | Dir | GPU caches |
| `GPUCache/` | Dir | GPU shader cache |
| `Local Storage/`, `Session Storage/`, `WebStorage/` | Dir | Web storage |
| `Network Persistent State` | File | Network state (NOT read) |
| `Preferences` | File | App preferences (NOT read) |
| `server/` | Dir | Local server data |
| `TransportSecurity`, `Trust Tokens` | File | TLS/trust state (NOT read) |
| `.updaterId` | File | Updater identifier |

## Security Findings

### ✅ No System Installation Required
- AppImage runs user-local from `~/Applications/`.
- No sudo, no rpm-ostree, no dnf, no system packages.
- No systemd services created.
- Self-contained; no conflicts with existing packages.

### ✅ No Persistent Background Service
- Space Agent is a desktop Electron application.
- No daemon, timer, or background service runs when closed.
- When the user closes the window, all processes terminate.
- No auto-restart or keep-alive mechanism observed.

### ✅ No Host Network Exposure When Closed
- When running, Space Agent uses localhost-only ports for its internal Electron processes.
- No external network ports opened.
- Auto-update check contacts GitHub releases (can be disabled).

### ⚠️ Writable Config Directory
- `~/.config/space-agent/` is writable by the user.
- Contains browser data (cookies, localStorage, cache).
- **Mitigation:** Space Agent does not write outside its config dir. No system config files modified.

### ⚠️ Auto-Update Check
- Space Agent checks GitHub for updates on launch.
- **Mitigation:** This is read-only (checks latest version). No automatic download/install without user action.

### ⚠️ Electron / Chromium Attack Surface
- Space Agent is an Electron app with a full Chromium runtime.
- Standard Electron security considerations apply (renderer process isolation, CSP, etc.).
- **Mitigation:** Used only as manual UI; no untrusted content loaded; no browser extensions installed.

## Known Limitations

### Manual UI Only
- Space Agent is a manual desktop UI application.
- No API for autonomous task execution.
- No scriptable automation interface.
- All actions require explicit human interaction.

### Local LLM Panel is NOT Ollama Chat
- **Critical Finding (M20):** Space Agent's "Local LLM" panel is a Hugging Face/Transformers.js browser loader.
- It expects Hugging Face repo IDs (e.g., `google/gemma-2b`), NOT Ollama model tags.
- Entering `gemma4-e4b-bazzite:latest` fails because Space Agent looks for `config.json` in HF format.
- **Verified Fallback:** Local Ollama CAN work via Space Agent's **Provider settings** using OpenAI-compatible endpoint (`http://127.0.0.1:11434/v1/chat/completions`). This is separate from the Local LLM panel.

### No Repo Write Authority
- Space Agent has no access to `~/projects/gem`.
- No git operations possible from within Space Agent.
- No file system write outside its config directory.

### Provider Configuration Requires Manual Setup
- OpenRouter: Verified working (Phase 7E.1).
- Local Ollama (via Provider settings): Verified working (Phase 7E.1, endpoint `http://127.0.0.1:11434/v1/chat/completions`, model `gemma4-e4b-bazzite:latest`).
- Gemini: Optional unresolved retry.
- Local LLM panel (HF/Transformers.js): NOT compatible with Ollama tags.

## What Must Not Be Granted

| Authority | Status | Reason |
|-----------|--------|--------|
| Root on host | ❌ Denied | AppImage runs user-local |
| System config changes | ❌ Denied | No rpm-ostree, firewall, SSH changes |
| Security control plane | ❌ Denied | Space Agent is UI only, not security ops |
| Autonomous task execution | ❌ Denied | No automation API; manual only |
| Repo write authority | ❌ Denied | No git/file write to `~/projects/gem` |
| Memory mutation | ❌ Denied | No memory/learning/indexing via Space Agent |
| Network changes | ❌ Denied | No firewall changes |
| Package installation | ❌ Denied | No rpm-ostree layering |
| Sudo access | ❌ Denied | Never granted |

## Explicit "No Authority Granted" Statement

**Space Agent has been granted NO authority in this assessment.**

- Space Agent was NOT launched in this phase.
- No system commands executed via Space Agent.
- No files modified by Space Agent in this phase.
- No network routes opened for Space Agent.
- No secrets read from Space Agent config files.
- No provider secrets inspected.
- No autonomous behavior enabled.
- Space Agent remains manual UI only.

## Prior Docs Record

### Phase 5E: Space Agent Assessment
- **Phase:** Assessment
- **Status:** COMPLETE
- **Key finding:** Linux/Bazzite compatible via AppImage
- **File:** `docs/integrations/space-agent/SPACE_AGENT_INTEGRATION_PLAN.md`

### Phase 12K: Space Agent Installation Readiness
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Decision:** `APPROVED_FOR_INSTALL`
- **File:** `docs/phase12/PHASE12K_SPACE_AGENT_INSTALLATION_READINESS.md`

### Phase 12L: Space Agent Install and Manual UI Provider Dry-Run
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Result:** Launch SUCCESS, version v0.66.0, stop CLEAN
- **File:** `docs/phase12/PHASE12L_SPACE_AGENT_INSTALL_AND_MANUAL_UI_DRY_RUN.md`

### Phase 12C: Space Agent Manual UI Bridge Review
- **Date:** 2026-05-02
- **Status:** COMPLETE (was BLOCKED at the time due to not installed; now unblocked by Phase 12L)
- **File:** `docs/phase12/PHASE12C_SPACE_AGENT_MANUAL_UI_BRIDGE_REVIEW.md`

### M16: Local Dashboard Pivot
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Key finding:** Space Agent confirmed as recommended local Gemma dashboard (later corrected by M20)
- **File:** `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md`

### M20: Space Agent Provider Reality Check
- **Date:** 2026-05-04
- **Status:** COMPLETE
- **Key finding:** Local LLM panel is HF/Transformers.js loader, NOT Ollama chat
- **File:** `docs/maintenance/M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md`

### Phase 7E.1: Space Agent Provider Finalization
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Key finding:** OpenRouter and local Ollama (via Provider settings) working
- **File:** `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`

## Readiness Verdict

### ✅ Ready for Manual UI Use
- AppImage installed and verified working.
- Launches successfully (v0.66.0).
- Stops cleanly.
- No system changes required.
- No background service when closed.
- Provider settings support OpenRouter and local Ollama.

### ⚠️ Limitations to Keep in Mind
- Local LLM panel is NOT for Ollama tags (use Provider settings instead).
- Electron/Chromium attack surface.
- Writable config dir with browser data.
- Auto-update check on launch.
- Must remain manual-only; no automation.

### ❌ Not Ready for Autonomous or Security Control Plane Use
- No automation API.
- No scriptable interface.
- No repo write capability.
- Manual interaction required for all operations.

## Next Dry-Run Criteria

### Phase 6C.1: Launch and Provider Verification
- [ ] Launch Space Agent via `~/Applications/Space-Agent.AppImage`
- [ ] Verify UI loads without errors
- [ ] Verify provider settings show OpenRouter or local Ollama config
- [ ] Confirm Local LLM panel behavior matches M20 findings
- [ ] Stop Space Agent cleanly after verification

### Phase 6C.2: Manual UI Boundary Test
- [ ] Load a read-only doc or checklist into Space Agent (copy/paste)
- [ ] Verify no file writes to `~/projects/gem`
- [ ] Verify no system commands suggested
- [ ] Verify no autonomous workflow triggers

### Phase 6C.3: Dashboard Packet Display Test
- [ ] Copy a dashboard packet from `~/offload/security-reports/dashboard-packets/` into Space Agent
- [ ] Verify display-only behavior
- [ ] Document any formatting issues

### Phase 6C.4: Coexistence Check
- [ ] Verify Space Agent port usage does not conflict with Ollama (11434) or Agent Zero (5080) or OpenCode bridge (4141)
- [ ] Verify no file lock conflicts with `~/.config/space-agent/`

## Signoff
- **Review performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **gemma-ui version:** v1.4.3
- **Space Agent version:** v0.66.0
- **Space Agent status:** Installed, not running (assessed read-only)
- **No authority granted:** Confirmed
- **Next phase:** Phase 6C.1 Launch and Provider Verification (requires human approval)

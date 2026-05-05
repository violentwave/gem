# Phase 6D: Integration Smoke Test

## Version
- **Date:** 2026-05-05
- **Host:** Bazzite/Fedora Atomic
- **User:** lch
- **gemma-ui:** v1.4.3
- **Repo:** ~/projects/gem
- **Classification:** Read-Only Smoke Test / No Authority Granted

## Scope
Integration smoke test to verify L5-L7 components can coexist without enabling autonomy, mutating host state, or changing security posture.

## Safety Rules
- **No authority granted to any component.**
- **No root/system/security write authority.**
- **No component must become the security control plane.**
- **No sudo, no packages, no host changes.**
- **No containers started/stopped/mutated.**
- **No Space Agent launched.**
- **No RuVector index rebuilt.**
- **No data ingested.**
- **No default promotion.**
- **No security scans run.**
- **No secrets exposed.**

## Component Summary Table

| Component | Current Status | Smoke Result | Boundary |
|-----------|---------------|--------------|----------|
| gemma-ui | Main terminal front door | ✅ PASS | Advisory / local-only |
| gemma-voice-chat | Push-to-talk voice agent | ✅ PASS | No daemon / no wake word |
| gemma-security-chat | Supervised security console | ✅ PASS | Confirmation required |
| RuVector | Supervised semantic memory | ✅ PASS | Not default |
| Stage 3A | Deterministic fallback | ✅ PASS | Canonical fallback |
| Agent Zero | Sandbox candidate (running) | ⚠️ WARN | No authority granted |
| Space Agent | Manual UI candidate (installed) | ✅ PASS | No autonomy |
| OpenCode/Codex | Implementation adapter | ✅ PASS | Bounded prompts only |

## Syntax Validation

| Script | Check | Result |
|--------|-------|--------|
| `~/.local/bin/gemma-ui` | `python3 -m py_compile` | ✅ PASS |
| `~/.local/bin/gemma-voice-chat` | `python3 -m py_compile` | ✅ PASS |
| `~/.local/bin/gemma-security-chat` | `python3 -m py_compile` | ✅ PASS |

## Helper Availability

| Helper | Status |
|--------|--------|
| gemma-ui | ✅ available |
| gemma-voice-chat | ✅ available |
| gemma-security-chat | ✅ available |
| gemma-memory-search | ✅ available |
| gemma-memory-rag | ✅ available |
| gemma-knowledge-search | ✅ available |
| gemma-knowledge-rag | ✅ available |
| podman | ✅ available |
| ollama | ✅ available |

## gemma-ui UI Checks

| Check | Result | Notes |
|-------|--------|-------|
| `--help` | ✅ PASS | Shows all modes and CLI flags |
| `--list-modes` | ✅ PASS | 9 modes, all available |
| `--dashboard` | ✅ PASS | Core, voice, memory, repo, safety all green |
| `--memory-dashboard` | ✅ PASS | Helper availability, policy status, index state shown |
| `--voice-status` | ✅ PASS | Recorder, STT, TTS all ready |
| `--route-intent "memory ask ..."` | ✅ PASS | Routes to memory mode |
| `--route-intent "repo gem status"` | ✅ PASS | Routes to repo mode |
| `--route-intent "check firewall"` | ✅ PASS | Routes to security mode with confirmation gate |
| `--route-intent "what can you help me with"` | ✅ PASS | Falls back to general mode |

## Port Coexistence

| Port | Service | Status |
|------|---------|--------|
| 127.0.0.1:5080 | Agent Zero UI | ✅ Active (container) |
| 127.0.0.1:11434 | Ollama API | ✅ Active |
| 127.0.0.1:4141 | OpenCode bridge | ❌ Not active (expected) |
| 127.0.0.1:3000 | (unused) | ✅ Free |
| 127.0.0.1:8080 | (unused) | ✅ Free |

**No port conflicts detected.**

**Other observed ports:**
- 127.0.0.53:53 — system DNS (systemd-resolved)
- 127.0.0.54:53 — system DNS (systemd-resolved)
- *:1716 — unknown (likely KDE Connect or similar user service)

## Component State Read-Only Checks

### Agent Zero (L5)
- **Container:** Running (Up 13 hours)
- **Ports:** 127.0.0.1:5080→80/tcp, 22/tcp, 9000-9009/tcp
- **Image:** docker.io/agent0ai/agent-zero:latest
- **Status:** Assessed read-only in Phase 6A
- **Authority:** NONE granted

### RuVector (L6)
- **Index:** Present (36 MB, 1,635 chunks)
- **Path:** `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json`
- **Model:** nomic-embed-text:latest (768d)
- **Status:** Supervised secondary only
- **Authority:** NONE granted

### Stage 3A (L6 Fallback)
- **Index:** Present (512 KB, 335 chunks)
- **Path:** `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
- **Status:** Canonical fallback
- **Authority:** N/A (deterministic retrieval)

### Space Agent (L7)
- **AppImage:** Present (129 MB, v0.66.0)
- **Path:** `~/Applications/Space-Agent.AppImage`
- **Processes:** None running
- **Status:** Manual UI only
- **Authority:** NONE granted

### Voice
- **Recorder:** pw-record ✅
- **STT:** whisper-cli ✅
- **TTS:** piper ✅
- **Mode:** Push-to-talk only
- **No recording performed in this phase.**

## Fallback Chain Verification

| Layer | Component | Fallback | Verified |
|-------|-----------|----------|----------|
| L1-L2 | Gemma / Ollama | Local inference | ✅ Ollama online, 3 models |
| L3 | Stage 3A | Deterministic retrieval | ✅ Index present, helpers available |
| L4 | Evals / Examples | Validation gates | ✅ 25 cases, 32 examples, all passing |
| L5 | Agent Zero | Manual orchestration | ⚠️ Running but no authority granted |
| L6 | RuVector | Stage 3A fallback | ✅ Both indices present, helpers available |
| L7 | Space Agent | Manual UI | ✅ Installed, not running, manual only |
| Implementation | OpenCode/Codex | Bounded prompts | ✅ No permission changes |

## Path Coexistence

| Path | Component | Conflict |
|------|-----------|----------|
| `~/.config/bazzite-security/` | Gemma config | None |
| `~/.local/bin/` | Helpers | None |
| `~/.local/share/bazzite-security/` | Persistent state | None |
| `~/.local/share/agent-zero/` | Agent Zero data | None |
| `~/.config/space-agent/` | Space Agent config | None |
| `~/projects/gem/` | Coordination repo | None |
| `~/Applications/` | Space Agent AppImage | None |

**No path conflicts detected.**

## Known Warnings

### Agent Zero
- ⚠️ Container has writable root filesystem (ReadonlyRootfs: False)
- ⚠️ No capabilities dropped (CapDrop: [])
- ⚠️ Running as root inside container
- ⚠️ Tool-protocol incompatibility with local Gemma (expects JSON, Gemma returns plain text)
- **Mitigation:** Hardened script exists but unused. Direct Ollama route works for non-Agent-Zero consumers.

### RuVector
- ⚠️ Large single-file JSON index (36 MB)
- ⚠️ Stale manifest files accumulating (~11 MB)
- ⚠️ Writable data directory
- **Mitigation:** Search is bounded. Index is rebuilt from approved docs only.

### Space Agent
- ⚠️ Electron/Chromium attack surface
- ⚠️ Writable config directory with browser data
- ⚠️ Auto-update check on launch
- ⚠️ Local LLM panel is Hugging Face loader, not Ollama chat (M20)
- **Mitigation:** Manual UI only. No automation. Provider settings support OpenRouter/local Ollama.

### LiveKit / Next.js / Web UI
- These are **not part of the current baseline**.
- The current stack is terminal-only with no web server or daemon.

## "No Authority Granted" Statement

**Agent Zero:**
- No system commands executed via Agent Zero.
- No files modified by Agent Zero.
- No network routes opened for Agent Zero.
- No secrets read from Agent Zero.
- No agents or skills activated.
- No autonomous loops enabled.

**RuVector:**
- No new data ingested.
- No index rebuilt.
- No system commands executed.
- No files modified.
- No promotion to default.

**Space Agent:**
- Not launched in this phase.
- No system commands executed.
- No files modified.
- No secrets read.
- No autonomous behavior enabled.

## "No Host Changes" Statement

- No sudo used.
- No packages installed.
- No firewall changes.
- No USBGuard changes.
- No ClamAV/Lynis/auditd changes.
- No SSH changes.
- No rpm-ostree changes.
- No systemd timer changes.
- No OpenCode permission changes.
- No Ollama settings changed.
- No Agent Zero config changes.
- No RuVector index changes.
- No Space Agent config changes.

## Proceed / Do Not Proceed Decision

**DECISION: PROCEED**

All L5-L7 components coexist without conflicts:
- ✅ No port conflicts
- ✅ No path conflicts
- ✅ Fallback chain verified
- ✅ Syntax checks pass
- ✅ UI checks pass
- ✅ Helper availability confirmed

**Conditions for proceeding:**
1. Agent Zero remains supervised/experimental (no authority granted).
2. RuVector remains supervised secondary (Stage 3A remains canonical fallback).
3. Space Agent remains manual UI only (no autonomy).
4. All future phases maintain read-only or supervised boundaries.

## Recommended Next Work After 6D

### Immediate (Phase 7+ Ready)
- Phase 7A: Agent Zero L5 Integration (requires explicit human approval)
- Phase 7B: RuVector L6 Memory Prototype expansion (requires explicit human approval)
- Phase 7C: Space Agent L7 Manual UI workflows (requires explicit human approval)

### From Research Reports (Backlog)
- bazzite-laptop config import design
- gemma-ui safety/budget config display
- tool registry risk normalization
- read-only bazzite-laptop tool review
- MCP bridge design only
- RuVector upgrade feasibility review
- reports/alerts panel refinement
- code quality pipeline
- future static web UI plan
- model switching review

## Signoff
- **Test performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **gemma-ui version:** v1.4.3
- **No authority granted:** Confirmed
- **No host changes:** Confirmed
- **Next phase:** Phase 7 readiness assessment (requires explicit human approval)

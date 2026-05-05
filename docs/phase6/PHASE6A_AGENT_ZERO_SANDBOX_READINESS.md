# Phase 6A: Agent Zero Sandbox Readiness Review

## Version
- **Date:** 2026-05-05
- **Host:** Bazzite/Fedora Atomic
- **User:** lch
- **gemma-ui:** v1.4.3
- **Repo:** ~/projects/gem
- **Classification:** Read-Only Assessment / No Authority Granted

## Scope
Read-only sandbox readiness review for Agent Zero in the Bazzite Local AI Operations Stack.
This document assesses whether Agent Zero is in a safe state for supervised experimentation.

## Safety Rules
- **No authority granted to Agent Zero.**
- **No root/system/security write authority.**
- **Agent Zero must not become the security control plane.**
- **No sudo, no packages, no host changes.**
- **No containers mutated unless via existing reviewed helper flow.**
- **No secrets exposed.**

## Current Status

### Container State
| Attribute | Value |
|-----------|-------|
| Container Name | `agent-zero` |
| Status | **Running** (Up 9 hours) |
| Image | `docker.io/agent0ai/agent-zero:latest` |
| URL | `http://127.0.0.1:5080` |
| User | `root` (empty User field) |
| Read-only Root FS | **False** (writable) |
| Privileged | False |
| Capabilities Dropped | **None** (CapDrop: []) |
| Capabilities Added | None (CapAdd: []) |
| Network Mode | `slirp4netns` (allow_host_loopback=true) |
| Mount | `~/.local/share/agent-zero/usr` -> `/a0/usr` (bind) |

### Helper Scripts
| Script | Status | Purpose |
|--------|--------|---------|
| `agent-zero-up` | ✅ Present | Start container (docker/podman fallback chain) |
| `agent-zero-down` | ✅ Present | Stop/remove container |
| `agent-zero-status` | ✅ Present | Show runtime/exists/running state |
| `agent-zero-logs` | ✅ Present | Tail container logs |
| `agents-start` | ✅ Present | Start agents (wrapper) |
| `agents-stop` | ✅ Present | Stop agents (wrapper) |
| `agents-status` | ✅ Present | Show agents status |
| `run-agent-zero-secure.sh` | ✅ Present | Hardened runner (unused) |

### Data Directory
| Path | Contents |
|------|----------|
| `~/.local/share/agent-zero/agents/` | Empty (`.gitkeep` only) |
| `~/.local/share/agent-zero/skills/` | Empty (`.gitkeep` only) |
| `~/.local/share/agent-zero/usr/` | Data volume mounted to container |
| `~/.local/share/agent-zero/.env` | Exists (secrets — not inspected) |
| `~/.local/share/agent-zero/secrets.env` | Exists (secrets — not inspected) |
| `~/.local/share/agent-zero/settings.json` | Exists (config) |

### Configuration Files
| File | Purpose |
|------|---------|
| `~/.config/agent-zero/docker-compose.yml` | Docker compose definition |
| `~/.config/agent-zero/podman-compose.yml` | Podman compose definition |
| `~/.config/agent-zero/PROFILE_SETUP.md` | Profile setup guide |
| `~/.config/agent-zero/SECRETS_SETUP.md` | Secrets setup guide |

## Security Findings

### ⚠️ Container is Writable
- `ReadonlyRootfs: False`
- The container has a writable root filesystem.
- **Mitigation:** The hardened script `run-agent-zero-secure.sh` exists with `--read-only=true` but is not currently used.

### ⚠️ No Capabilities Dropped
- `CapDrop: []` (empty array)
- The container retains all default capabilities.
- **Mitigation:** The hardened script drops ALL capabilities (`--cap-drop=ALL`).

### ⚠️ Running as Root
- `User:` (empty = root)
- The container process runs as root inside the container.
- **Note:** This is the default for the official image. The hardened script does not specify a user.

### ✅ Network is Localhost-Only
- Port `127.0.0.1:5080:80` (localhost only)
- No external network exposure
- `slirp4netns` with `allow_host_loopback=true` allows container-to-host communication

### ✅ Not Privileged
- `Privileged: False`

## Known Limitations (from M15 Review)

### Tool-Protocol Incompatibility
- **Problem:** Agent Zero's agent-loop expects JSON tool-request format.
- **Problem:** Local Gemma (Ollama) returns plain text.
- **Result:** Agent Zero cannot use local Gemma as its reasoning model in agent-loop mode.
- **Workaround:** Direct API calls from the container to Ollama work fine for non-Agent-Zero consumers.

### Autonomous-Oriented Profile
- **Problem:** The current `hacker` profile is designed for autonomous operation.
- **Risk:** Unsafe for supervised local use.
- **Gap:** No chat-only or supervised local profile exists.

### Empty Agent/Skill State
- **Agents:** No agents configured (`agents/` is empty)
- **Skills:** No skills configured (`skills/` is empty)
- **Status:** Effectively a blank slate — no active orchestration occurring

## What Must Not Be Granted

| Authority | Status | Reason |
|-----------|--------|--------|
| Root on host | ❌ Denied | Container runs as root but is isolated; no host root |
| System config changes | ❌ Denied | No rpm-ostree, firewall, SSH, auditd changes |
| Security control plane | ❌ Denied | Agent Zero is assessment-only, not production security |
| OpenCode permissions | ❌ Denied | No opencode --dangerously-skip-permissions |
| Ollama config changes | ❌ Denied | Model configs remain unchanged |
| Network changes | ❌ Denied | No firewall/ufw changes |
| Package installation | ❌ Denied | No rpm-ostree layering |
| File system write outside bind mount | ❌ Denied | Writable root FS is contained |
| Sudo access | ❌ Denied | Never granted |

## Explicit "No Authority Granted" Statement

**Agent Zero has been granted NO authority in this assessment.**

- No system commands executed via Agent Zero.
- No files modified by Agent Zero.
- No network routes opened for Agent Zero.
- No secrets read from Agent Zero's `.env` or `secrets.env`.
- No agents or skills activated.
- No autonomous loops enabled.
- The container is running from a prior session; it was NOT started in this phase.
- The container will NOT be stopped in this phase (read-only assessment).

## Prior Docs Record

### M15: Agent Zero Local Gemma Compatibility Review
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Key finding:** Direct Ollama route works; tool-protocol incompatible
- **Recommendation:** Space Agent as recommended local Gemma dashboard
- **File:** `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`

### AGENT_ZERO_INTEGRATION_PLAN
- **Phase:** 5C (Assessment)
- **Status:** Assessment complete
- **File:** `docs/integrations/agent-zero/AGENT_ZERO_INTEGRATION_PLAN.md`

### AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS
- **File:** `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`

### AGENT_ZERO_SUPERVISED_PROFILE_DESIGN
- **File:** `docs/maintenance/AGENT_ZERO_SUPERVISED_PROFILE_DESIGN.md`

## Direct Bridge Fallback

The direct Ollama route from Agent Zero container to host works:
- Route: `http://10.0.2.2:11434` (slirp4netns host loopback)
- Tested models: `gemma4-e4b-bazzite:latest`, `gemma4:e4b`
- Works for: Direct API calls, chat completions
- Does NOT work for: Agent Zero agent-loop (protocol mismatch)

## Readiness Verdict

### ✅ Ready for Read-Only Experimentation
- Container exists and is running
- Helper scripts provide safe lifecycle controls
- Direct Ollama route confirmed working
- No agents/skills configured (blank slate)
- Network is localhost-only

### ⚠️ Security Hardening Recommended Before Full Use
- Use `--read-only=true` (hardened script available)
- Use `--cap-drop=ALL` (hardened script available)
- Consider running with `--network=none` if no external access needed
- The hardened script `run-agent-zero-secure.sh` exists but is unused

### ❌ Not Ready for Production Security Operations
- Tool-protocol incompatibility with local Gemma
- No supervised profile exists
- Autonomous-oriented `hacker` profile is unsafe
- Writable root filesystem
- No capability restrictions

## Next Dry-Run Criteria

### Phase 6A.1: Hardened Container Test
- [ ] Stop current container via `agent-zero-down`
- [ ] Start hardened container via `run-agent-zero-secure.sh`
- [ ] Verify UI loads at `http://127.0.0.1:5080`
- [ ] Verify Ollama reachability at `10.0.2.2:11434`
- [ ] Confirm read-only filesystem
- [ ] Confirm capability drop

### Phase 6A.2: Read-Only Profile Inspection
- [ ] Inspect current `hacker` profile (read-only)
- [ ] Document profile capabilities and risks
- [ ] Verify no autonomous loops are configured

### Phase 6A.3: Safe Agent Definition Test
- [ ] Create a read-only agent definition (no filesystem write)
- [ ] Test agent in manual mode (no auto-loop)
- [ ] Verify it cannot execute system commands

### Phase 6A.4: Bridge Compatibility Test
- [ ] Test OpenCode-A0 bridge if connector exists
- [ ] Verify plain-text vs JSON protocol behavior
- [ ] Document fallback behavior

## Signoff
- **Review performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **gemma-ui version:** v1.4.3
- **Agent Zero container status:** Running (assessed read-only)
- **No authority granted:** Confirmed
- **Next phase:** Phase 6A.1 Hardened Container Test (requires human approval)

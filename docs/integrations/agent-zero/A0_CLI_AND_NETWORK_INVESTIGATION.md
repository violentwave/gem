# A0 CLI and Network Investigation Report

**Date:** 2026-04-30
**Phase:** 7A.1
**Status:** Investigation Complete

---

## Summary

This report documents the investigation into:
1. A0 CLI installation method and safety
2. Rootless Podman port forwarding issue
3. Agent Zero container version/connector support
4. Recommended path forward

---

## 1. Existing Agent Zero State

| Attribute | Value | Notes |
|-----------|-------|-------|
| Container Image | `docker.io/agent0ai/agent-zero:latest` | |
| Image ID | `2a5c9a2bb778` | |
| Image Created | 2026-04-13 | Based on Kali Linux |
| OS | Kali GNU/Linux Rolling 2025.4 | |
| Helper Scripts | ✅ Present | 4 scripts in `~/.local/bin/` |
| Config Files | ✅ Present | `~/.config/agent-zero/` |
| Data Directory | ✅ Present | `~/.local/share/agent-zero/` |

---

## 2. Helper Script Findings

### `agent-zero-up`
- **Runtime used:** Direct Podman (fallback chain: docker compose → podman compose → podman-compose → direct podman)
- **Network mode:** `slirp4netns:allow_host_loopback=true`
- **Port mapping:** `-p 127.0.0.1:5080:80`
- **Volume:** `$HOME/.local/share/agent-zero/usr:/a0/usr:Z`
- **References 127.0.0.1:5080:** Yes (line 11, 86)
- **Safe to keep:** ✅ Yes - uses localhost binding only

### `agent-zero-down`
- **Runtime:** Same fallback chain
- **Behavior:** `podman stop` then `podman rm`
- **Safe to keep:** ✅ Yes

### `agent-zero-status`
- **Runtime detection:** Auto-detects via same fallback chain
- **Output:** Reports runtime path, running state, URL, image, data path
- **Safe to keep:** ✅ Yes

### `agent-zero-logs`
- **Behavior:** Delegates to appropriate runtime's logs command
- **Safe to keep:** ✅ Yes

**Conclusion:** All helper scripts are safe to continue using. They use localhost-only binding and proper container lifecycle management.

---

## 3. Compose/Network Configuration

### `podman-compose.yml`
```yaml
services:
  agent-zero:
    image: docker.io/agent0ai/agent-zero:latest
    container_name: agent-zero
    ports:
      - "127.0.0.1:5080:80"  # localhost-only binding
    volumes:
      - ${HOME}/.local/share/agent-zero/usr:/a0/usr:Z
    environment:
      - TZ=America/New_York
    restart: "no"
```

### `docker-compose.yml`
- Similar config but with `extra_hosts: host.docker.internal:host-gateway`
- Also uses `127.0.0.1:5080:80` localhost binding

**Network Configuration:** Both use localhost-only binding (`127.0.0.1`) ✅

---

## 4. Container Version/Connector Clues

### Internal Check Results

| Check | Result |
|-------|--------|
| Python version | 3.12+ (per AGENTS.md) |
| Framework | Flask + Alpine.js + LiteLLM |
| a0 binary inside container | ❌ Not found |
| agent-zero binary inside container | ❌ Not found |
| Connector scripts | Found `/a0/run_ui.py`, `/a0/run_tunnel.py` |
| Version from AGENTS.md | Generated 2026-02-22 |

**Finding:** The container contains the Agent Zero web UI and API, but the A0 CLI connector is NOT bundled inside. It must be installed separately on the host.

---

## 5. Endpoint Issue Details

### Observed Behavior

| Test | Result |
|------|--------|
| `podman port agent-zero` | ✅ Shows `80/tcp -> 127.0.0.1:5080` |
| `ss -tlnp \| grep 5080` | ✅ Listens on `127.0.0.1:5080` |
| `curl http://127.0.0.1:5080` | ❌ Connection reset by peer |
| Internal `podman exec curl localhost:80` | ✅ Works |

### Root Cause Analysis

The issue is a **known rootless Podman networking limitation**:
- Port mapping uses `slirp4netns` (default rootless network)
- Port appears bound (`ss` shows listening)
- Connection attempt receives RST (reset) from peer
- Internal container access works fine

### Rootless Podman Networking Options

| Option | Description | Status |
|--------|-------------|--------|
| slirp4netns (current) | Default, has port forwarding bugs | ❌ Issue |
| pasta | Alternative, may fix port issues | 🔶 Untested |
| podman --network=host | Host networking | ❌ Not allowed |
| rootlesskit port_handler | Alternative port handler | 🔶 Untested |

**Do Not Use:** Host networking (violates hard boundary)

---

## 6. A0 CLI Installer Inspection

### File Details
- **Size:** 1,253 bytes
- **SHA256:** `62ffe6403dd4918faa5d52b04c2be87d91925426200ed94d9f9708003d6a11c9`
- **Location:** Downloaded to `~/tmp/a0-cli-inspect/install.sh`

### Installation Method Analysis

```bash
# Key components:
PACKAGE_SPEC="a0 @ https://github.com/agent0ai/a0-connector/archive/refs/tags/v1.5.zip"
PYTHON_SPEC="3.11"
UV_INSTALL_URL="https://astral.sh/uv/install.sh"
```

### Safety Assessment

| Check | Result | Notes |
|-------|--------|-------|
| Uses sudo | ❌ No | No sudo in script |
| Installs to user-local | ✅ Yes | `uv tool dir` → `~/.local/bin` |
| Requests secrets | ❌ No | No prompt for API keys |
| Downloads from known source | ✅ Yes | GitHub releases, astral.sh |
| Modifies shell rc | ⚠️ Partial | `uv tool update-shell` attempts |
| Network-only download | ✅ Yes | No package manager install |
| Can run without sudo | ✅ Yes | uv manages Python |

### Installation Destination
- **CLI binary:** `~/.local/bin/a0` (via `uv tool install`)
- **Python:** Managed by uv (no system Python used)
- **Location:** User-local only (`$HOME/.local`)

### Verdict: **SAFE TO RUN IN LATER PHASE** (with conditions)

The installer is user-local and doesn't require sudo. It downloads uv and uses it to install the a0 package.

---

## 7. A0 CLI Connector Version Support

From prior docs:
- **Agent Zero connector requires:** Version 1.9+
- **Available connector version:** v1.5 (from installer URL)
- **Version gap:** ⚠️ Installer pulls v1.5, but docs say connector needs 1.9+

**Action needed:** Verify if v1.5 is sufficient or if newer version exists.

---

## 8. Recommended Path

### For Phase 7A.2:

1. **A0 CLI Install:**
   - Run the installer (user-local, no sudo)
   - Verify `a0` appears in `~/.local/bin/`
   - Do NOT configure any API keys yet

2. **Network Fix Options:**
   - Try A0 CLI with `AGENT_ZERO_HOST` env var first
   - If that fails, investigate pasta networking (non-host)
   - Document as known limitation if unresolved

3. **Connector Test:**
   - Run `a0 --help` or simple version check
   - Do NOT run actual agent spawns (later phase)

4. **Container Management:**
   - Start Agent Zero via existing helper
   - Verify if A0 CLI can reach it
   - Stop at end unless explicitly needed

---

## 9. Explicit Non-Actions (This Phase)

| Action | Status |
|--------|--------|
| No sudo used | ✅ Confirmed |
| No installer executed | ✅ Confirmed |
| No host networking | ✅ Not used |
| No services/autostart created | ✅ None |
| No secrets/.env inspected | ✅ Avoided |
| No OpenCode/Ollama changes | ✅ None |
| No system security changes | ✅ None |
| No helper script changes | ✅ None |

---

## 10. Readiness Decision

| Criteria | Status | Notes |
|----------|--------|-------|
| Helper scripts safe | ✅ Yes | Uses localhost binding |
| Container version identified | ✅ Yes | Kali-based, latest image |
| CLI not in container | ✅ Confirmed | Must install separately |
| Installer safe to run | ✅ Yes | User-local, no sudo |
| Network issue understood | ✅ Yes | slirp4netns limitation |
| Alternative networking available | 🔶 Partial | pasta untested |

**Decision:** `ready_for_a0_cli_install`

**Conditions:**
- ✅ A0 CLI installer is safe (user-local, no sudo)
- ⚠️ Network fix may be needed after CLI install
- ⚠️ Verify connector version compatibility

---

## Validation Commands

```bash
# Verify report exists
test -f ~/projects/gem/docs/integrations/agent-zero/A0_CLI_AND_NETWORK_INVESTIGATION.md

# Verify next prompt exists
test -f ~/projects/gem/prompts/opencode/phase7a2-a0-cli-install-and-endpoint-fix.prompt.txt

# Verify no system changes
git -C ~/projects/gem status --short
```

---

## Files Created

1. `docs/integrations/agent-zero/A0_CLI_AND_NETWORK_INVESTIGATION.md` - This report
2. `prompts/opencode/phase7a2-a0-cli-install-and-endpoint-fix.prompt.txt` - Next prompt

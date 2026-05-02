# Bridge Operator Runbook

**Version:** 1.0
**Date:** 2026-05-02
**Scope:** Safe operations for the Bazzite Local AI Operations Stack bridge layer

---

## Quick Status Check

### Check OpenCode Bridge

```bash
# Bridge status
opencode-bridge-status

# Expected output:
# Bridge URL: http://127.0.0.1:4141
# Bridge bind: 127.0.0.1:4141
# Bridge responding: yes

# Verify JSON endpoints
curl --max-time 10 -sS http://127.0.0.1:4141/health
curl --max-time 10 -sS http://127.0.0.1:4141/v1/models

# Verify bind address (should show 127.0.0.1, NOT 0.0.0.0)
ss -tlnp | grep 4141
```

### Check Agent Zero

```bash
# Is Agent Zero running?
podman ps --format '{{.Names}} {{.Status}} {{.Ports}}' | grep agent-zero

# If running, check health
curl --max-time 10 -sS http://127.0.0.1:5080/api/health

# Check container bridge route
podman exec agent-zero curl --max-time 10 -sS http://10.0.2.2:4141/health
```

### Check Ollama

```bash
# Is Ollama running?
curl --max-time 10 -sS http://127.0.0.1:11434/api/tags | head -c 200
```

---

## Safe Start/Stop Procedures

### Start OpenCode Bridge

```bash
# Only if not already running
opencode-bridge-status

# If not running:
opencode-bridge-up

# Verify:
curl --max-time 10 -sS http://127.0.0.1:4141/health
```

### Stop OpenCode Bridge

```bash
opencode-bridge-down

# Verify stopped:
ss -tlnp | grep 4141 || echo "Bridge stopped"
```

### Start Agent Zero

```bash
# Verify bridge is running first
opencode-bridge-status

# Start Agent Zero
agent-zero-up

# Wait 15-20 seconds for startup
sleep 15

# Verify health
curl --max-time 20 -sS http://127.0.0.1:5080/api/health
```

### Stop Agent Zero

```bash
agent-zero-down

# Verify stopped:
podman ps --format '{{.Names}} {{.Status}}' | grep agent-zero || echo "Agent Zero stopped"
```

---

## Container Bridge Route Verification

```bash
# From inside Agent Zero container, verify bridge reachability
podman exec agent-zero curl --max-time 20 -sS http://10.0.2.2:4141/health
podman exec agent-zero curl --max-time 20 -sS http://10.0.2.2:4141/v1/models
```

**Expected:** JSON responses from both endpoints.

**If fails:** Check that bridge is running and bound to 127.0.0.1:4141.

---

## Direct Bridge Simple Briefing

```bash
# Send a simple read-only briefing request directly to the bridge
curl --max-time 120 -sS http://127.0.0.1:4141/v1/chat/completions \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "model": "opencode-main",
    "messages": [
      {"role": "user", "content": "Brief docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md in 3 sentences."}
    ]
  }'
```

**Do NOT use for:**
- Complex multi-step prompts (may timeout)
- File editing requests
- System command execution
- Implementation work

---

## When NOT to Use Agent Zero message_send

**Do NOT use Agent Zero message_send when:**
- Prompt is longer than 100 words
- Prompt requires multi-step reasoning
- Response time is critical (message_send has ~180s timeout)
- You need guaranteed response (use direct bridge instead)

**Use direct bridge instead for:**
- Complex briefings
- Multi-step analysis
- Any prompt where reliability is critical

---

## Report Locations

| Report Type | Path |
|-------------|------|
| Phase 12 closeouts | `docs/phase12/` |
| Manual security reports | `~/offload/security-reports/manual/` |
| Bridge logs | `~/.local/state/opencode-bridge/` |
| Agent Zero logs | `~/.local/state/agent-zero/` |
| Gemma eval reports | `~/offload/security-reports/manual/gemma-*` |

---

## Stop Conditions

Stop immediately if any of the following occur:

- Bridge is bound to `0.0.0.0` instead of `127.0.0.1`
- Agent Zero requests file write access
- Agent Zero requests system commands
- Agent Zero requests network browsing
- Agent Zero requests memory mutation
- Agent Zero requests learning/training
- Response contains suspicious recommendations
- Secrets are exposed in output

---

## Forbidden Actions

**Never do the following through the bridge or Agent Zero:**

- Modify files in `~/projects/gem`
- Use sudo or root privileges
- Change firewall rules
- Install packages
- Start/stop systemd services
- Modify Ollama config
- Ingest, index, or promote memory
- Enable autonomous learning/training
- Run OpenCode prompts autonomously
- Use `--dangerously-skip-permissions`
- Expose services on LAN (bind to 0.0.0.0)

---

## Troubleshooting

### Bridge returns HTML instead of JSON

**Cause:** Wrong process on port 4141.
**Fix:**
```bash
# Stop bridge
opencode-bridge-down

# Kill any opencode serve on 4141
kill $(ss -tlnp | grep 4141 | awk '{print $7}' | cut -d',' -f2 | cut -d'=' -f2)

# Restart bridge
opencode-bridge-up
```

### Agent Zero health fails

**Cause:** Agent Zero UI still initializing.
**Fix:** Wait 20-30 seconds and retry.

### Bridge chat completions timeout

**Cause:** Bridge 60s timeout or stale session.
**Fix:**
```bash
# Clear stale session
mv ~/.local/share/opencode-bridge/session.json \
   ~/.local/share/opencode-bridge/session.json.backup-$(date +%Y%m%d-%H%M%S)

# Use simpler prompt
```

### Container cannot reach bridge

**Cause:** slirp4netns host-loopback not enabled.
**Fix:** Ensure Agent Zero started with `--network slirp4netns:allow_host_loopback=true`.

---

## Sign-Off

- Runbook version: 1.0
- Bridge status: Operational
- Agent Zero status: Operational (with limitations)
- Boundaries: Enforced
- Last updated: 2026-05-02
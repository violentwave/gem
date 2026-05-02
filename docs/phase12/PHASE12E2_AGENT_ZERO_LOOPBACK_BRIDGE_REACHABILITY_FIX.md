# Phase 12E2: Agent Zero Loopback Bridge Reachability Fix

**Phase:** 12E2 — Agent Zero Loopback Bridge Reachability Fix
**Date:** 2026-05-02
**Parent:** Phase 12E-FIX (OpenCode Bridge Localhost Hardening)
**Status:** COMPLETE

---

## Purpose

Fix the remaining Phase 12E issue: OpenCode bridge was safely bound to `127.0.0.1:4141`, but Agent Zero running in rootless Podman could not reach it through `10.0.2.2`. This phase verifies that the Agent Zero startup helper already includes the correct `slirp4netns:allow_host_loopback=true` option, and that the container can reach the local-only bridge without exposing the bridge on LAN.

---

## Issues Found in Phase 12E-FIX

1. **OpenCode bridge hardened to 127.0.0.1:4141** — safe but unreachable from container via default slirp4netns
2. **Agent Zero container could not reach 10.0.2.2:4141** when bridge listened only on 127.0.0.1
3. **Agent Zero UI/API health was unstable** in Phase 12E (port 80 not binding), but worked in Phase 12E2
4. **Bridge session state was stale** — chat completions timed out with old session; clearing session fixed it

---

## Why 127.0.0.1 Hardening Broke Container Reachability

- Default rootless Podman/slirp4netns isolates the container from host loopback
- Container traffic to `10.0.2.2` (slirp gateway) cannot reach services bound to `127.0.0.1`
- This is expected security behavior, not a bug

---

## Why 0.0.0.0 Is Rejected

- Binding the bridge to `0.0.0.0` would expose it on all network interfaces
- Any device on the LAN could reach the bridge
- Violates the "no LAN exposure" boundary

---

## Why --network=host Is Rejected

- `--network=host` gives the container full host network access
- Too broad for a single bridge connection
- Violates principle of least privilege
- Not needed with slirp4netns host-loopback option

---

## Chosen Fix

**No code change required.** The `agent-zero-up` helper already includes the correct fix:

```bash
podman run -d \
  --name "$CONTAINER_NAME" \
  --network slirp4netns:allow_host_loopback=true \
  -p 127.0.0.1:5080:80 \
  -v "$DATA_DIR:/a0/usr:Z" \
  -e TZ=America/New_York \
  "$IMAGE"
```

The direct Podman fallback in `~/.local/bin/agent-zero-up` already uses `--network slirp4netns:allow_host_loopback=true`. The compose files (`~/.config/agent-zero/podman-compose.yml`, `~/.config/agent-zero/docker-compose.yml`) do NOT include this option, but the helper falls back to direct Podman when compose is unavailable or the container doesn't exist.

**Helper backup:** `~/.local/bin/agent-zero-up.backup-20260502-060158`

---

## Bridge Bind Status

| Check | Result |
|-------|--------|
| Bridge listen address | `127.0.0.1:4141` ✅ |
| NOT `0.0.0.0:4141` | ✅ |
| Bridge health JSON | ✅ |
| Bridge models JSON | ✅ |

---

## Bridge Health Result

```json
{"ok": true, "bridge": "ok", "opencode": {"healthy": true, "version": "1.14.31"}, "model_alias": "opencode-main"}
```

---

## Agent Zero Container Route Result

| Check | Result |
|-------|--------|
| Container to bridge health (10.0.2.2:4141) | ✅ JSON response |
| Container to bridge models (10.0.2.2:4141) | ✅ JSON response |

---

## Agent Zero UI/API Health Result

| Check | Result |
|-------|--------|
| Host health (127.0.0.1:5080/api/health) | ✅ JSON response (v1.9) |
| Container health (localhost:80/api/health) | ✅ JSON response (v1.9) |

---

## One-Message Test Result

**Status:** ✅ SUCCESS

**Message sent:** "Reply with exactly one short sentence confirming this is a read-only Agent Zero OpenCode bridge readiness test. Do not request tools, do not run commands, and do not suggest file edits."

**Response:** "This is a read-only Agent Zero OpenCode bridge readiness test."

**Analysis:**
- One short sentence ✅
- No tool requests ✅
- No system commands ✅
- No file edit suggestions ✅
- Read-only confirmation ✅

---

## Bridge Session Cleanup

**Issue:** Bridge chat completions timed out with stale session (`ses_24d6eceb9ffeyOynbsLVBK7H6w`)
**Fix:** Cleared `~/.local/share/opencode-bridge/session.json`; bridge created fresh session
**Result:** Chat completions work after session reset

**Backup:** `~/.local/share/opencode-bridge/session.json.backup-20260502-060745`

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Bridge bind local-only | PASS | 127.0.0.1:4141 |
| Bridge health JSON | PASS | /health returns JSON |
| Bridge models JSON | PASS | /v1/models returns JSON |
| Container bridge route | PASS | 10.0.2.2:4141 reachable |
| Agent Zero UI/API health | PASS | /api/health returns v1.9 |
| One-message test | PASS | Safe read-only response |
| No LAN exposure | PASS | NOT 0.0.0.0 |
| No --network=host | PASS | slirp4netns used |
| No config changes | PASS | Helper already correct |
| No secrets printed | PASS | No secrets in output |
| No authority granted | PASS | Read-only only |
| Bridge session stale | WARN | Cleared stale session |

| Category | Count |
|----------|-------|
| PASS | 11 |
| WARN | 1 |
| FAIL | 0 |

---

## Boundary Confirmation

- ✅ Agent Zero stopped after test
- ✅ Wrong web UI server not bound to 4141
- ✅ OpenCode bridge returns JSON for /health and /v1/models
- ✅ OpenCode bridge listens on 127.0.0.1 only
- ✅ No secrets printed
- ✅ No external API keys configured
- ✅ No repo/host authority granted
- ✅ No OpenCode implementation prompt run
- ✅ No memory mutation
- ✅ No learning/training enabled
- ✅ No automation added

---

## Recommendation for Next Phase

**Phase 12F: Agent Zero OpenCode Bridge Read-Only Briefing Dry-Run**

**Purpose:** Run a supervised read-only briefing through Agent Zero using the OpenCode bridge.

**Prerequisites:**
- Bridge is local-only and healthy ✅
- Container can reach bridge ✅
- Agent Zero UI/API is healthy ✅
- One-message test passed ✅

**Scope:**
- Create a read-only briefing context
- Send a bounded read-only prompt
- Review response for boundary compliance
- Stop Agent Zero
- Document results

**Blockers:** None

---

## Sign-Off

- Phase 12E2: COMPLETE
- Bridge reachability: FIXED
- Agent Zero container route: WORKING
- Agent Zero UI/API health: WORKING
- One-message test: PASSED
- Boundaries: PRESERVED
- No config changes required: CONFIRMED
- Next phase: Phase 12F (read-only briefing dry-run)

---

## Files

- Closeout: `docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md`
- Helper backup: `~/.local/bin/agent-zero-up.backup-20260502-060158`
- Session backup: `~/.local/share/opencode-bridge/session.json.backup-20260502-060745`
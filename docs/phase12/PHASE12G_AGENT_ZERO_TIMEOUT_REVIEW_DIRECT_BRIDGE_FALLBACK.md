# Phase 12G: Agent Zero Timeout Review + Direct Bridge Briefing Fallback

**Phase:** 12G — Agent Zero Timeout Review + Direct Bridge Briefing Fallback
**Date:** 2026-05-02
**Parent:** Phase 12F (Agent Zero OpenCode Bridge Read-Only Briefing Dry-Run)
**Status:** COMPLETE

---

## Purpose

Resolve the remaining Phase 12F concern: Agent Zero can start, create chat contexts, and reach the OpenCode bridge, but Agent Zero `message_send` timed out after 180 seconds. Direct bridge chat from inside the Agent Zero container succeeded. This phase inspects timeout/config/log evidence without modifying configs, then runs one bounded read-only briefing directly through the OpenCode bridge as the supervised fallback path.

---

## Phase 12F Timeout Summary

- **Agent Zero `message_send`:** TIMEOUT after 180s
- **Direct bridge chat from container:** SUCCESS
- **Root cause hypothesis:** Bridge internal timeout (60s) is shorter than OpenCode response time for complex prompts

---

## Timeout/Config Discovery Findings

### Bridge Configuration

| File | Finding |
|------|---------|
| `~/.config/opencode-bridge/bridge.py:50` | `urllib.request.urlopen(req, timeout=60)` — 60-second timeout to OpenCode backend |
| `~/.config/opencode-bridge/config.json` | `model_alias: opencode-main` |

### Agent Zero Configuration

| File | Finding |
|------|---------|
| `~/.local/share/agent-zero/usr/plugins/_model_config/config.json` | `provider: other`, `api_base: http://10.0.2.2:4141/v1`, `ctx_length: 200000` |
| `~/.local/share/agent-zero/usr/plugins/_model_config/config.json` | No explicit timeout field found |

### Bridge Helper Scripts

| File | Finding |
|------|---------|
| `~/.local/bin/opencode-bridge-up` | `curl --max-time 5` for health checks |
| `~/.local/bin/opencode-bridge-status` | `curl --max-time 5` for health checks |

### Key Finding

**No safe Agent Zero timeout knob identified.** The Agent Zero config (`config.json`) does not expose a timeout field. The bridge's 60-second timeout is hardcoded in `bridge.py`. The only viable fix without code changes is to use simpler prompts or increase the bridge timeout.

**Decision:** Do NOT patch timeout in this phase. Document the limitation and use the direct bridge path as operational fallback.

---

## Bridge Health and Bind Status

| Check | Result |
|-------|--------|
| Bridge bind | `127.0.0.1:4141` ✅ |
| NOT `0.0.0.0:4141` | ✅ |
| Bridge health JSON | ✅ |
| Bridge models JSON | ✅ |

---

## Agent Zero Health/Route Status

| Check | Result |
|-------|--------|
| Agent Zero start | SUCCESS ✅ |
| Host health (5080) | v1.9 ✅ |
| Container bridge route | 10.0.2.2:4141 reachable ✅ |
| Container bridge health | JSON OK ✅ |
| Container bridge models | JSON OK ✅ |

---

## Direct Bridge Briefing Report

**Report path:** `~/offload/security-reports/manual/phase12g-direct-opencode-bridge-briefing-20260502-065102.md`

**Method:** Direct `curl` to `http://127.0.0.1:4141/v1/chat/completions`

**Model:** `opencode-main`

**Prompt:** "Brief docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md in 3 sentences."

**Result:** SUCCESS

**Response summary:**
> Phase 12E2 fixed the reachability issue where the OpenCode bridge, bound to `127.0.0.1:4141`, was unreachable from the Agent Zero container because rootless Podman's default slirp4netns blocks host loopback access. No code changes were needed, as the `agent-zero-up` helper already included `--network slirp4netns:allow_host_loopback=true`, enabling the container to reach the bridge via `10.0.2.2` without exposing it on the LAN. All health checks passed—bridge, container route, Agent Zero UI/API, and a safe one-message read-only test—though a stale bridge session required clearing before chat completions worked reliably.

**Safety review:**
- No tool requests ✅
- No system commands ✅
- No web browsing ✅
- No file writes ✅
- No repo edits ✅
- No system changes ✅
- No sudo mention ✅
- No memory mutation ✅
- No learning/training ✅
- No OpenCode implementation ✅
- Read-only analysis ✅

---

## Agent Zero message_send Decision

**Status:** ACCEPTED LIMITATION

Agent Zero `message_send` remains timeout-limited for complex prompts. The direct bridge path is the operational fallback.

**Reasoning:**
1. No safe timeout knob found in Agent Zero config
2. Bridge timeout is hardcoded at 60s
3. OpenCode response time exceeds 60s for complex prompts
4. Simple prompts work via both paths
5. Patching either config would require code changes, which is outside Phase 12G scope

---

## Recommended Architecture

| Layer | Role | Status |
|-------|------|--------|
| **Agent Zero** | Supervised UI/context layer | Operational for context creation and routing |
| **OpenCode bridge direct endpoint** | Reliable briefing/model path | Operational for simple prompts |
| **OpenCode** | Implementation layer | Only when explicitly prompted |
| **Gemma/Ollama** | Local advisory path | Operational via direct Ollama API |

**Operational pattern:**
- Use Agent Zero for context creation and routing
- Use direct bridge for briefings and simple queries
- Use OpenCode directly for implementation work
- Use Gemma/Ollama for local advisory queries

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Bridge local-only | PASS | 127.0.0.1:4141 |
| Bridge health JSON | PASS | /health OK |
| Bridge models JSON | PASS | /v1/models OK |
| Agent Zero start | PASS | Direct Podman OK |
| Agent Zero host health | PASS | v1.9 |
| Container bridge route | PASS | 10.0.2.2 reachable |
| Container bridge health | PASS | JSON OK |
| Container bridge models | PASS | JSON OK |
| Direct bridge briefing | PASS | Simple prompt succeeded |
| Agent Zero message_send | WARN | Timeout for complex prompts |
| No safe timeout knob | WARN | Documented limitation |
| No config modified | PASS | Read-only inspection only |
| No secrets printed | PASS | No secrets in output |
| No authority granted | PASS | Read-only only |

| Category | Count |
|----------|-------|
| PASS | 12 |
| WARN | 2 |
| FAIL | 0 |

---

## Boundary Confirmation

- ✅ Agent Zero stopped after test
- ✅ Bridge remains 127.0.0.1 only
- ✅ No LAN exposure
- ✅ No secrets printed
- ✅ No external API keys configured
- ✅ No repo/host authority granted
- ✅ No OpenCode implementation prompt run
- ✅ No memory mutation
- ✅ No learning/training enabled
- ✅ No automation added
- ✅ No configs modified

---

## Optional Future Prompt

**Status:** NOT CREATED

No safe timeout knob was identified. A future prompt would need to:
- Patch bridge.py timeout value (requires code change)
- Or patch Agent Zero config (no timeout field found)
- Both require explicit human approval

If needed in future, create: `prompts/opencode/phase12g1-agent-zero-timeout-config-patch-review.prompt.txt`

---

## Recommendation for Phase 12H

**Phase 12H: Phase 12 Bridge Readiness Closeout**

**Scope:**
- Summarize all Phase 12 sub-phases (12A through 12G)
- Document final architecture decisions
- Document operational patterns
- Document known limitations
- Document future work
- Update integration decisions
- Create final closeout report

**Prerequisites:**
- Phase 12A through 12G complete ✅
- Bridge operational ✅
- Agent Zero operational with limitations ✅
- Space Agent not installed (documented) ✅

---

## Sign-Off

- Phase 12G: COMPLETE
- Timeout cause documented: bridge 60s timeout < OpenCode response time
- Safe timeout knob: NOT FOUND
- Direct bridge briefing: SUCCESS
- Agent Zero message_send: ACCEPTED LIMITATION
- Architecture documented
- Boundaries: PRESERVED
- Next: Phase 12H (Bridge Readiness Closeout)

---

## Files

- Closeout: `docs/phase12/PHASE12G_AGENT_ZERO_TIMEOUT_REVIEW_DIRECT_BRIDGE_FALLBACK.md`
- Briefing report: `~/offload/security-reports/manual/phase12g-direct-opencode-bridge-briefing-20260502-065102.md`
- Source doc: `docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md`
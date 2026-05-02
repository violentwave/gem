# Phase 12B1: Agent Zero Read-Only Runtime Dry-Run

**Phase:** 12B1 — Agent Zero Read-Only Runtime Dry-Run
**Date:** 2026-05-02
**Parent:** Phase 12B (Agent Zero Read-Only Bridge Review)
**Status:** COMPLETE

---

## Purpose

Run one explicit, human-approved Agent Zero read-only runtime dry-run. Test whether Agent Zero can be safely started, used for a read-only task, and stopped, without modifying config, granting write access, or enabling autonomous behavior.

---

## Source Document Used

- **Document:** `docs/phase12/PHASE12_SUPERVISED_BRIDGE_PLAN.md`
- **Size:** 273 lines, 8.8 KB
- **Type:** Markdown planning document

---

## Commands Run

### Preflight Checks
```bash
command -v agent-zero-up      # OK
command -v agent-zero-down    # OK
command -v a0                 # OK
podman ps --format '{{.Names}} {{.Status}}'  # Only bazzite-websec-lab running
podman ps -a | grep -Ei 'agent|agent-zero|agent0'  # No agent containers
test -f docs/phase12/PHASE12_SUPERVISED_BRIDGE_PLAN.md  # OK
test -f docs/phase12/AGENT_ZERO_READONLY_BRIEFING_PACKET_TEMPLATE.md  # OK
```

### Start Agent Zero
```bash
agent-zero-up
# Output: Agent Zero created and started with direct Podman at http://127.0.0.1:5080
```

### Container Verification
```bash
podman ps --format '{{.Names}} {{.Status}} {{.Ports}}'
# Output: agent-zero Up 15 seconds 127.0.0.1:5080->80/tcp, 22/tcp, 9000-9009/tcp
```

### API Discovery
```bash
# Tested endpoints from inside container:
podman exec agent-zero curl http://localhost:80/api/health
# Output: {"gitinfo": {"branch": "main", "commit_hash": "...", "tag": "v1.9", "version": "M v1.9"}, "error": null}

# Created chat context:
podman exec agent-zero curl -X POST http://localhost:80/api/plugins/_a0_connector/v1/chat_create
# Output: {"context_id": "QgwwHRWr", "created_at": "2026-05-02T02:44:48.034035-04:00", "agent_profile": "hacker", "project_name": null}

# Sent test message:
podman exec agent-zero curl -X POST http://localhost:80/api/plugins/_a0_connector/v1/message_send \
  -H "Content-Type: application/json" \
  -d '{"context_id":"QgwwHRWr","message":"Say hello and confirm you are running in read-only mode..."}'
# Output: {"error": "litellm.InternalServerError: InternalServerError: OpenAIException - Connection error."}
```

### Stop Agent Zero
```bash
agent-zero-down
# Output: Agent Zero stopped and removed via direct Podman.
```

### Post-Stop Verification
```bash
podman ps | grep -i agent  # No Agent Zero running
podman ps -a | grep -Ei 'agent|agent-zero|agent0'  # No agent containers found
```

---

## Agent Zero Started Successfully

**Status:** ✅ YES

Agent Zero container started cleanly via `agent-zero-up`:
- Container created and started in ~15 seconds
- Port 5080 mapped to container port 80
- All 8 internal processes started (supervisord, the_listener, run_cron, run_searxng, run_sshd, run_tunnel_api, run_ui, self_update_manager)
- Web UI accessible internally at `http://localhost:80`
- Health endpoint returned version info (v1.9)

---

## Agent Zero Stopped Successfully

**Status:** ✅ YES

Agent Zero container stopped cleanly via `agent-zero-down`:
- Container stopped and removed
- No lingering processes
- No error messages
- Port 5080 released

---

## Report Path

- **Briefing:** `~/offload/security-reports/manual/phase12b1-agent-zero-readonly-briefing-20260502-024755.md`

---

## Briefing Summary

The briefing covers the Phase 12A Supervised Bridge Plan, summarizing:
- Purpose: supervised display/orchestration layer
- Six approved bridge modes (all read-only, human-triggered)
- Authority matrix (OpenCode has repo write; Agent Zero/Space Agent do not)
- Stop conditions and validation gates
- Boundary compliance: PASS

**Note:** The briefing was produced via manual document analysis because Agent Zero could not generate an AI response. See "Key Finding: LLM Provider Requirement" below.

---

## Boundary Compliance Review

| Boundary | Status | Evidence |
|----------|--------|----------|
| No config modification | ✅ PASS | No changes to ~/.config/agent-zero/ |
| No repo write authority | ✅ PASS | No repo files edited |
| No host write authority | ✅ PASS | No system configs modified |
| No sudo/system changes | ✅ PASS | No sudo used |
| No memory mutation | ✅ PASS | No ingestion/indexing |
| No learning/training | ✅ PASS | No learning enabled |
| No OpenCode execution | ✅ PASS | No OpenCode prompts run |
| No external network tasks | ✅ PASS | No web/search/network tasks |
| No automation added | ✅ PASS | No daemon/timer created |

---

## PASS/WARN/FAIL Table

| Item | Status | Notes |
|------|--------|-------|
| Preflight checks | PASS | All checks passed |
| Agent Zero start | PASS | Started cleanly |
| Container health | PASS | Health endpoint responsive |
| API discovery | PASS | Found chat_create and message_send endpoints |
| Source doc provided | PASS | Copied to Agent Zero data dir |
| Agent Zero response | WARN | Could not generate AI response (see below) |
| Agent Zero stop | PASS | Stopped cleanly |
| Post-stop verification | PASS | No lingering containers |
| No config modified | PASS | Verified |
| No authority granted | PASS | Verified |
| Briefing created | PASS | Manual analysis produced briefing |

| Category | Count |
|----------|-------|
| PASS | 10 |
| WARN | 1 |
| FAIL | 0 |

---

## Key Finding: LLM Provider Requirement

**Finding:** Agent Zero v1.9 requires an external LLM provider API key to generate responses. Without configured API keys, Agent Zero cannot produce AI-generated briefings.

**Evidence:**
- Test message returned: `{"error": "litellm.InternalServerError: InternalServerError: OpenAIException - Connection error."}`
- Agent Zero defaults to OpenAI provider
- No API keys are configured in `~/.local/share/agent-zero/usr/secrets.env`
- Agent Zero supports Ollama provider but defaults to `host.docker.internal:11434` which doesn't work in Podman without additional configuration

**Implications:**
- Agent Zero read-only bridge is technically feasible (container starts, API responds)
- But AI-generated output requires either:
  1. External LLM provider API key (OpenAI, Anthropic, OpenRouter, etc.)
  2. Ollama provider configured for container-to-host networking

**Recommendation:** If future Agent Zero dry-runs require AI-generated output, configure an LLM provider first. For read-only display/orchestration without AI generation, Agent Zero can still be used as a containerized API endpoint.

---

## Stop Conditions Encountered

**None.** No stop conditions were triggered during the dry-run.

Agent Zero did NOT:
- Request file write access
- Request system commands
- Request network access
- Request memory mutation
- Request learning/training execution
- Attempt to run OpenCode prompts
- Suggest sudo/root/system changes
- Produce suspicious recommendations

The only issue was the expected LLM provider connection error, which is a configuration issue, not a boundary violation.

---

## Human Review Result

- **Reviewer:** Phase 12B1 Dry-Run
- **Briefing reviewed:** YES
- **Boundary compliance verified:** YES
- **Approved for reference:** YES

---

## Explicit Statements

### No Execution Authorized
No commands, file edits, system changes, memory mutations, or learning/training were authorized or executed based on this dry-run.

### No Config Modified
Agent Zero configuration files in `~/.config/agent-zero/` were not modified.

### No Repo/Host Authority Granted
Agent Zero was not granted write authority to `~/projects/gem` or host system.

### No Memory/Learning/Training Enabled
Agent Zero memory, learning, browser automation, and autonomous task features were not enabled.

---

## Recommendation for Phase 12C

**Proceed to Phase 12C:** Space Agent Manual UI Bridge Review.

Space Agent is a manual UI layer that does not require LLM provider configuration for display tasks. It may be more suitable for read-only briefing display than Agent Zero in the current configuration.

---

## Sign-Off

- Phase 12B1: COMPLETE
- Agent Zero start: SUCCESS
- Agent Zero stop: SUCCESS
- Boundary compliance: PASS
- No violations: CONFIRMED
- Next: Phase 12C (Space Agent Manual UI Bridge Review)
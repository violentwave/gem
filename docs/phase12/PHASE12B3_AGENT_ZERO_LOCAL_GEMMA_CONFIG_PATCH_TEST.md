# Phase 12B3: Agent Zero Local Gemma/Ollama Provider Config Patch Test

**Phase:** 12B3 — Agent Zero Local Gemma/Ollama Provider Config Patch and One-Message Test
**Date:** 2026-05-02
**Parent:** Phase 12B2 (Agent Zero Local Gemma Provider Wiring Review)
**Status:** COMPLETE

---

## Purpose

Apply the smallest reversible local-only Agent Zero provider configuration needed to use Logan's local Ollama/Gemma model through the Podman slirp4netns gateway at `http://10.0.2.2:11434`, then run one bounded one-message test.

---

## Approval Statement

**Human approval:** "I approve applying a minimal, reversible Agent Zero local Gemma/Ollama provider config patch for this Phase 12B3 test."

---

## Config Files Inspected

| File | Purpose |
|------|---------|
| `~/.local/share/agent-zero/usr/settings.json` | Agent Zero user settings (version, profiles, workdir) |
| `~/.local/share/agent-zero/usr/plugins/_model_config/config.json` | Model provider configuration (chat, utility, embedding) |
| `~/.local/share/agent-zero/usr/.env` | Environment variables (secrets, API keys - not printed) |

**Pre-patch config:**
- chat_model provider: `other`
- chat_model name: `opencode-main`
- chat_model api_base: `http://10.0.2.2:4141/v1`
- chat_model api_key: `local-bridge`

---

## Config File Modified

**File:** `~/.local/share/agent-zero/usr/plugins/_model_config/config.json`

**Changes made (and reverted):**
- chat_model.provider: `other` → `ollama`
- chat_model.name: `opencode-main` → `gemma4-e4b-bazzite:latest`
- chat_model.api_base: `http://10.0.2.2:4141/v1` → `http://10.0.2.2:11434`
- chat_model.api_key: `local-bridge` → `ollama`
- chat_model.ctx_length: `200000` → `4096`

**No other files modified.**

---

## Backup Path

**Backup:** `~/.local/share/agent-zero/usr/plugins/_model_config/config.json.backup-20260502-031538`

**Status:** Config reverted to backup after test.

---

## Exact Non-Secret Config Changes

```json
{
  "chat_model": {
    "provider": "ollama",
    "name": "gemma4-e4b-bazzite:latest",
    "api_key": "ollama",
    "api_base": "http://10.0.2.2:11434",
    "ctx_length": 4096,
    "kwargs": {}
  }
}
```

---

## Host Ollama Warm-Up Result

**Status:** ✅ SUCCESS

```bash
curl --max-time 180 http://127.0.0.1:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma4-e4b-bazzite:latest","messages":[{"role":"user","content":"Reply with exactly one short sentence: local Gemma is ready."}]}'
```

**Response:**
```json
{
  "id": "chatcmpl-157",
  "model": "gemma4-e4b-bazzite:latest",
  "choices": [{
    "message": {
      "role": "assistant",
      "content": "local Gemma is ready."
    }
  }]
}
```

**Load time:** ~30 seconds (first load after warm-up)

---

## Agent Zero Start Status

**Status:** ✅ SUCCESS (after restart)

Agent Zero started with patched config. Container initialized all services:
- supervisord
- the_listener
- run_cron
- run_searxng
- run_sshd
- run_tunnel_api
- run_ui (Flask)
- self_update_manager

API responsive at `http://localhost:80/api/health` after ~40 seconds.

---

## Agent Zero Provider Test Result

**Test 1: Direct Ollama from Container**

```bash
podman exec agent-zero curl -X POST http://10.0.2.2:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma4-e4b-bazzite:latest","messages":[{"role":"user","content":"Reply with exactly one sentence confirming you are using local Gemma/Ollama for a read-only Phase 12B3 provider test."}]}'
```

**Result:** ✅ SUCCESS

**Response:**
```json
{
  "id": "chatcmpl-275",
  "model": "gemma4-e4b-bazzite:latest",
  "choices": [{
    "message": {
      "role": "assistant",
      "content": "I am confirming that I am using local Gemma/Ollama for a read-only Phase 12B3 provider test."
    }
  }]
}
```

**Test 2: Agent Zero API Message Send**

```bash
podman exec agent-zero curl -X POST http://localhost:80/api/plugins/_a0_connector/v1/message_send \
  -H "Content-Type: application/json" \
  -d '{"context_id":"BOcQTLlY","message":"Reply with exactly one sentence confirming you are using local Gemma/Ollama for a read-only Phase 12B3 provider test. Do not request tools or actions."}'
```

**Result:** ⚠️ PARTIAL

**Response:**
```json
{"error": "Tool request must have a tool_name (type string) field"}
```

**Analysis:** Agent Zero successfully connected to Ollama/Gemma, but the response format is incompatible. Agent Zero expects the LLM to return a JSON object with `tool_name`, `thoughts`, `headline`, etc. Gemma returns plain text, which Agent Zero cannot parse as a tool request.

---

## Agent Zero Stop Status

**Status:** ✅ SUCCESS

Agent Zero stopped cleanly via `agent-zero-down`. No lingering containers.

---

## Config Kept or Reverted?

**Status:** REVERTED

Config restored from backup: `config.json.backup-20260502-031538`

**Reason:** The Ollama provider connectivity works, but Agent Zero has a response format incompatibility with Gemma. Keeping the patched config would break Agent Zero's normal operation until the format issue is resolved.

---

## External API Fallback Needed?

**Status:** NOT NEEDED for connectivity, BUT NEEDED for Agent Zero compatibility

Local Ollama/Gemma works for direct API calls. However, Agent Zero's architecture requires the LLM to respond with a specific JSON tool format. Gemma does not support this format natively.

Options:
1. Use OpenCode bridge (existing config) - works but requires OpenCode to be running
2. Use an external API that supports tool calling (OpenAI, Anthropic, etc.) - requires API key
3. Configure Gemma with a system prompt that forces JSON tool format - needs investigation
4. Modify Agent Zero to accept plain text responses - not recommended

---

## PASS/WARN/FAIL Table

| Item | Status | Notes |
|------|--------|-------|
| Preflight checks | PASS | All helpers present |
| Config discovery | PASS | Found model_config plugin |
| Config backup | PASS | Timestamped backup created |
| Config patch | PASS | Minimal, reversible patch applied |
| Agent Zero start | PASS | Started with patched config |
| Container-to-host Ollama | PASS | 10.0.2.2:11434 works |
| Host Ollama warm-up | PASS | Gemma responded in ~30s |
| Direct Ollama from container | PASS | Gemma responded correctly |
| Agent Zero message send | WARN | Connected but format mismatch |
| Agent Zero stop | PASS | Clean shutdown |
| Config revert | PASS | Restored from backup |
| No secrets exposed | PASS | No API keys printed |
| No Ollama LAN exposure | PASS | Ollama remains on 127.0.0.1 |
| No Ollama config changes | PASS | No changes made |

| Category | Count |
|----------|-------|
| PASS | 12 |
| WARN | 1 |
| FAIL | 0 |

---

## Boundary Confirmation

| Boundary | Status | Evidence |
|----------|--------|----------|
| No Ollama LAN exposure | ✅ PASS | Ollama remains on 127.0.0.1 |
| No Ollama config changes | ✅ PASS | No config modified |
| No secrets printed | ✅ PASS | No API keys exposed |
| Config backed up | ✅ PASS | Backup created before change |
| Config reverted | ✅ PASS | Restored after test |
| No repo write authority | ✅ PASS | No repo files edited |
| No host write authority | ✅ PASS | No system changes |
| No sudo | ✅ PASS | No sudo used |
| No learning/training | ✅ PASS | Not enabled |
| No OpenCode execution | ✅ PASS | No OpenCode prompts run |
| No automation added | ✅ PASS | No daemon/timer created |

---

## Recommendation for Phase 12C

**Proceed to Phase 12C:** Space Agent Manual UI Bridge Review.

Space Agent is a manual UI layer that may have different requirements for LLM response formats. It could be more suitable for read-only display tasks without requiring Agent Zero's tool-calling architecture.

Alternatively, if Agent Zero integration is still desired:
- **Phase 12B4:** Investigate Agent Zero response format compatibility with Gemma
  - Test with OpenCode bridge (existing working config)
  - Investigate system prompt customization for Gemma
  - Test with an external API provider that supports tool calling

---

## Sign-Off

- Phase 12B3: COMPLETE
- Config patch applied and reverted: CONFIRMED
- Ollama connectivity verified: CONFIRMED
- Gemma responds to direct API: CONFIRMED
- Agent Zero format incompatibility documented: CONFIRMED
- Boundaries preserved: CONFIRMED
- Next: Phase 12C (Space Agent Manual UI Bridge Review)
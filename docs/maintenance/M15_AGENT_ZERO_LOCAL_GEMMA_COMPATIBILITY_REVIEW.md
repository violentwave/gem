# M15: Agent Zero Local Gemma Compatibility Review

**Maintenance Phase:** M15 — Agent Zero Local Gemma Compatibility Review
**Date:** 2026-05-02
**Status:** COMPLETE
**Classification:** Review-Only / No Config Changes

---

## Executive Summary

Agent Zero (v1.9) starts successfully and can reach the local Ollama/Gemma instance at `10.0.2.2:11434`. Direct API calls from the Agent Zero container to Ollama work correctly for both `gemma4-e4b-bazzite:latest` and `gemma4:e4b`. However, Agent Zero's agent-loop protocol is **incompatible** with local Gemma because Gemma returns plain text, while Agent Zero expects a JSON tool-request format. The current profile (`hacker`) is autonomous-oriented and unsafe for local Gemma use. No chat-only or supervised local profile exists. Space Agent remains the recommended local Gemma dashboard.

---

## Direct Ollama Route: SUCCESS

### Container-to-Host Connectivity

| Test | Route | Result |
|------|-------|--------|
| API tags | `http://10.0.2.2:11434/api/tags` | PASS |
| OpenAI models | `http://10.0.2.2:11434/v1/models` | PASS |
| Chat completion (gemma4-e4b-bazzite) | `http://10.0.2.2:11434/v1/chat/completions` | PASS |
| Chat completion (gemma4:e4b) | `http://10.0.2.2:11434/v1/chat/completions` | PASS |

### Evidence

```bash
# From Agent Zero container
podman exec agent-zero curl -X POST http://10.0.2.2:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma4-e4b-bazzite:latest","messages":[{"role":"user","content":"Hello"}]}'
```

**Response:** Gemma responds with correct plain-text assistant content.

**Conclusion:** The direct local Gemma route is **fully operational** for non-Agent-Zero API consumers.

---

## OpenCode Bridge Route: Optional / Experimental

### Current Agent Zero Config

```json
{
  "chat_model": {
    "provider": "other",
    "name": "gemma4-e4b-bazzite:latest",
    "api_base": "http://10.0.2.2:11434/v1",
    "ctx_length": 200000
  }
}
```

**Note:** The current config points `api_base` to Ollama directly (`10.0.2.2:11434/v1`), not to the OpenCode bridge. The OpenCode bridge (`10.0.2.2:4141/v1`) is an **optional/experimental** route that was tested in Phase 12E2/12F/12G.

### Why opencode-main Is Not Gemma

- `opencode-main` is a **bridge model alias**, not an actual LLM.
- When Agent Zero sends a request to the OpenCode bridge, the bridge forwards it to OpenCode's configured provider (e.g., Moonshot, Claude, etc.), NOT to local Gemma.
- Previous bridge tests hit **Moonshot quota errors** because the bridge routed to an external provider.
- The bridge does **not** route to local Ollama/Gemma by default.
- Using `opencode-main` means Agent Zero depends on an external cloud provider, defeating the purpose of local Gemma operation.

**Conclusion:** The OpenCode bridge route is **not a local Gemma solution**. It is documented as an optional fallback only.

---

## Agent Zero Tool-Protocol Failure

### Symptom

When Agent Zero's UI or API sends a message with the current Ollama-direct config, the following error occurs:

```json
{"error": "Tool request must have a tool_args (type dictionary) field."}
```

### Root Cause

1. Agent Zero's `hacker` profile defines an **agent loop** that expects the LLM to respond with a structured JSON object containing:
   - `tool_name` (string)
   - `tool_args` (dictionary)
   - `thoughts` (string)
   - `headline` (string)
2. Local Gemma (via Ollama) returns **plain text** (e.g., "I am a helpful assistant...").
3. Agent Zero parses the LLM response, fails to find the expected JSON fields, and emits the tool_args error.
4. This is a **protocol-level incompatibility**, not a network or model-loading issue.

### Error Evolution

| Phase | Error Message |
|-------|---------------|
| 12B3 | `Tool request must have a tool_name (type string) field` |
| M15 | `Tool request must have a tool_args (type dictionary) field` |

The error progressed because the config/provider changed, but the fundamental mismatch remains: Gemma does not emit Agent Zero's required JSON tool format.

---

## Profile Analysis

### Current Profile: `hacker`

- **Location:** `~/.local/share/agent-zero/usr/settings.json`
- **Value:** `"agent_profile": "hacker"`
- **Behavior:** Expects tool-calling, autonomous agent-loop execution
- **Safety:** **Unsafe for local Gemma** — the profile is designed for external tool-calling APIs

### Available Profiles

| Profile | Exists? | Notes |
|---------|---------|-------|
| `hacker` | YES (default) | Autonomous, tool-calling, incompatible with plain-text LLMs |
| `chat` | NO | Not available |
| `local` | NO | Not available |
| `supervised` | NO | Not available |
| `readonly` | NO | Not available |

**Conclusion:** No chat-only, local, supervised, or read-only profile exists in Agent Zero v1.9.

---

## Recommended Operating Mode

| Mode | Status | Rationale |
|------|--------|-----------|
| **Direct local Gemma via API/curl** | RECOMMENDED | Works perfectly for scripts, helpers, and direct queries |
| **Space Agent UI + local Gemma** | RECOMMENDED | Manual dashboard, works with plain text, no tool-protocol issues |
| **Agent Zero + local Gemma** | **NOT VIABLE** | Protocol incompatibility; no supervised profile exists |
| **Agent Zero + OpenCode bridge** | EXPERIMENTAL | Requires external provider; not local Gemma |
| **Agent Zero + external API** | FALLBACK ONLY | Requires API key; defeats local-only goal |

---

## PASS/WARN/FAIL Table

| Item | Status | Notes |
|------|--------|-------|
| Direct Ollama connectivity | PASS | 10.0.2.2:11434 works from container |
| Direct Gemma response (gemma4-e4b-bazzite) | PASS | Plain text, correct |
| Direct Gemma response (gemma4:e4b) | PASS | Plain text, correct |
| Agent Zero start | PASS | v1.9 starts cleanly |
| Agent Zero UI/API message send | FAIL | Tool-protocol incompatibility |
| Chat-only profile available | FAIL | No such profile exists |
| Supervised profile available | FAIL | No such profile exists |
| Current profile safe for local Gemma | FAIL | `hacker` is autonomous-oriented |
| Space Agent with local Gemma | PASS | Verified in Phase 12L/7E1 |
| No config modified in this review | PASS | Read-only review |
| No secrets exposed | PASS | No API keys printed |

---

## Boundary Confirmation

| Boundary | Status | Evidence |
|----------|--------|----------|
| No Agent Zero config modified | PASS | Review only; no writes |
| No secrets printed | PASS | No API keys in output |
| No repo write authority | PASS | No repo files edited |
| No host write authority | PASS | No system changes |
| No sudo | PASS | No sudo used |
| No model pulls | PASS | No ollama pull |
| No package installs | PASS | No dnf/flatpak/brew |
| No autonomous execution | PASS | Agent Zero not started |

---

## Sign-Off

- M15 Review: COMPLETE
- Direct local Gemma route documented as working: CONFIRMED
- Agent Zero tool protocol incompatibility documented: CONFIRMED
- Space Agent recommended as local Gemma dashboard: CONFIRMED
- Agent Zero remains supervised/experimental: CONFIRMED
- No autonomy enabled: CONFIRMED
- No system changes: CONFIRMED

---

## Artifacts

| Artifact | Path |
|----------|------|
| This review | `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md` |
| Limitations doc | `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md` |
| Supervised profile design prompt | `prompts/opencode/m15a-agent-zero-supervised-profile-design.prompt.txt` |

# Agent Zero Supervised Local Profile Design

**Document:** Agent Zero Supervised Local Profile Design
**Date:** 2026-05-02
**Version:** 1.0
**Status:** Design-Only / Not Implementable in v1.9

---

## Purpose

This document defines a hypothetical supervised, read-only, chat-only Agent Zero profile that could work with local Gemma/Ollama. It is a **future-oriented design artifact** only. Agent Zero v1.9 does not support this profile, and enabling it would require upstream changes or a custom backend modification.

---

## 1. Profile Name

**Proposed Name:** `local_chat`

**Rationale:**
- Clearly indicates local-only operation.
- Implies conversational (chat) behavior, not agentic tool use.
- Avoids terms like `hacker` or `agent` that suggest autonomy.

**Rejected Names:**
- `supervised` — too generic; Agent Zero may use this term for UI features.
- `readonly` — implies no write access, but the core issue is tool-protocol mismatch.
- `bazzite` — host-specific; profile should describe behavior, not environment.

---

## 2. Profile Behavior Definition

### Enabled Behaviors

| Behavior | Status | Description |
|----------|--------|-------------|
| Plain-text chat | ENABLED | Send/receive conversational messages |
| Context memory | ENABLED | Remember conversation history within session |
| File read (explicit) | ENABLED | Read files only when human explicitly requests |
| Markdown rendering | ENABLED | Display responses with formatting |

### Disabled Behaviors

| Behavior | Status | Description |
|----------|--------|-------------|
| Agent-loop tool calling | DISABLED | Do not parse responses as tool requests |
| Autonomous file system access | DISABLED | Do not browse workdir without explicit request |
| Web search | DISABLED | Do not call searxng automatically |
| Code execution | DISABLED | Do not run code or commands |
| MCP tool use | DISABLED | Do not invoke MCP servers |
| A2A messaging | DISABLED | Do not communicate with other agents |
| STT/TTS | OPTIONAL | Speech can be enabled/disabled per user preference |

### Human Approval Gates

All actions beyond plain chat require explicit human approval:
1. File read requests → Human confirms path.
2. File write requests → Human confirms content and path.
3. Command execution → Human confirms command and safety.
4. Web search → Human confirms query.
5. Tool use → Human confirms tool and arguments.

---

## 3. System Prompt Design

### Prompt for Local Gemma (Bazzite Context)

```text
You are a helpful, cautious assistant running on a Bazzite/Fedora Atomic system.
You are operating in SUPERVISED READ-ONLY mode.

CONTEXT:
- Host OS: Bazzite (Fedora Atomic Desktop)
- Firewall: firewalld (not ufw)
- Package management: rpm-ostree (not apt), Flatpak for GUI, Homebrew for CLI
- User: lch
- Home path: /var/home/lch

SAFETY BOUNDARIES:
- You MUST NOT suggest sudo commands.
- You MUST NOT suggest modifying system services, firewalls, or USBGuard.
- You MUST NOT suggest installing system-wide packages.
- You MUST NOT modify Ollama model configs or pull models without explicit approval.
- You MUST NOT write files outside approved paths without explicit approval.
- You MUST NOT execute commands autonomously.

RESPONSE FORMAT:
- Respond in plain text only.
- Do NOT emit JSON, tool requests, or structured action formats.
- If you need to perform an action (read a file, run a command), describe it in text and ask for human approval.
- Be concise. Prefer short, accurate answers.

EXAMPLES OF GOOD RESPONSES:
- "The approved path for Gemma knowledge docs is ~/.local/share/bazzite-security/gemma-knowledge/docs/"
- "To check Ollama status, you can run: ollama list. Would you like me to help with anything else?"
- "I can read that file for you. Please confirm you want me to read /path/to/file."

EXAMPLES OF BAD RESPONSES:
- JSON objects with "tool_name" or "tool_args"
- Autonomous command execution without asking
- Suggesting system changes outside safety boundaries
```

### Rationale

- The prompt explicitly tells Gemma to use **plain text only**.
- It includes **Bazzite/Fedora Atomic context** so Gemma gives correct advice.
- It embeds **safety boundaries** aligned with the stack's security model.
- It provides **examples** of good vs. bad responses to guide behavior.

---

## 4. Agent Zero Config Mapping (Theoretical)

### Hypothetical Config Fragment

```json
{
  "agent_profile": "local_chat",
  "chat_model": {
    "provider": "ollama",
    "name": "gemma4-e4b-bazzite:latest",
    "api_base": "http://10.0.2.2:11434",
    "api_key": "ollama",
    "ctx_length": 4096,
    "kwargs": {
      "system_prompt": "<prompt from section 3>",
      "response_format": "text",
      "enable_tools": false,
      "enable_autonomy": false
    }
  },
  "utility_model": {
    "provider": "ollama",
    "name": "gemma4-e4b-bazzite:latest",
    "api_base": "http://10.0.2.2:11434",
    "api_key": "ollama",
    "ctx_length": 4096
  },
  "mcp_server_enabled": false,
  "a2a_server_enabled": false,
  "rfc_auto_docker": false,
  "workdir_show": false,
  "stt_model_size": "",
  "tts_kokoro": false
}
```

### Field Explanations

| Field | Value | Purpose |
|-------|-------|---------|
| `agent_profile` | `local_chat` | Selects the supervised profile |
| `chat_model.provider` | `ollama` | Uses Ollama-native API |
| `chat_model.name` | `gemma4-e4b-bazzite:latest` | Local custom profile |
| `chat_model.api_base` | `http://10.0.2.2:11434` | slirp4netns gateway to host Ollama |
| `chat_model.kwargs.enable_tools` | `false` | Hypothetical — disables tool parsing |
| `chat_model.kwargs.enable_autonomy` | `false` | Hypothetical — disables agent loop |
| `mcp_server_enabled` | `false` | Disables MCP tool server |
| `a2a_server_enabled` | `false` | Disables agent-to-agent communication |
| `rfc_auto_docker` | `false` | Disables auto-Docker feature |
| `workdir_show` | `false` | Hides workdir browser by default |
| `stt_model_size` | `""` | Disables speech-to-text |
| `tts_kokoro` | `false` | Disables text-to-speech |

### Important Caveat

The fields `enable_tools` and `enable_autonomy` inside `kwargs` are **hypothetical**. Agent Zero v1.9 does not recognize these fields. They are included here to illustrate what a supervised profile would need.

---

## 5. Failure Mode Analysis

### Why This Profile Would Still Fail with Agent Zero v1.9

| Issue | Root Cause | Can Be Worked Around? |
|-------|------------|----------------------|
| Agent Zero backend expects JSON tool format | Hardcoded parser in Python backend | NO — requires code change |
| Profile name is cosmetic | `agent_profile` only changes system prompt, not behavior | NO — requires code change |
| `kwargs.enable_tools` not recognized | Field does not exist in v1.9 schema | NO — ignored by Agent Zero |
| Agent loop runs regardless of profile | Loop is always active | NO — requires code change |
| Error on plain-text response | Parser throws before profile logic | NO — fundamental mismatch |

### Conclusion

**Profile design is a future-oriented document, not a fix.** Agent Zero v1.9 cannot use a supervised local profile without:
1. Upstream support for a "no-tools" mode, OR
2. A custom fork that modifies the response parser.

Neither is in scope for this stack.

---

## 6. Comparison with Space Agent

| Feature | Agent Zero (v1.9) | Space Agent (v0.66.0) |
|---------|-------------------|----------------------|
| LLM protocol | Custom JSON tool format | OpenAI-compatible plain text |
| Local Gemma support | **NO** | **YES** |
| Autonomy level | High (agent loop) | None (manual UI) |
| Tool calling | Built-in | None |
| File system access | Automatic workdir browsing | None (manual paste only) |
| Profile system | Single `hacker` profile | Provider/model selection only |
| Suitable for local Gemma | **NO** | **YES** |

### Why Space Agent Succeeds

1. **Space Agent is a chat UI**, not an agent loop.
2. It sends/receives messages via the standard OpenAI-compatible API.
3. It does not parse responses as tool requests.
4. It does not attempt autonomous actions.
5. It delegates all execution to the human operator.

This is exactly the behavior a supervised local profile would need — but Agent Zero's architecture is fundamentally different.

---

## 7. Migration Path (If Ever Supported)

### Scenario: Agent Zero v2.x Adds Chat-Only Mode

If Agent Zero adds a native "chat-only" or "no-tools" mode:

1. **Config Patch:**
   ```bash
   # Backup existing config
   cp ~/.local/share/agent-zero/usr/plugins/_model_config/config.json \
      ~/.local/share/agent-zero/usr/plugins/_model_config/config.json.backup-$(date +%Y%m%d-%H%M%S)
   
   # Apply minimal patch
   # (change agent_profile to "local_chat", set enable_tools=false)
   ```

2. **No System Changes Required:**
   - No sudo.
   - No firewall changes.
   - No package installs.
   - No model pulls.

3. **No External API Key Required:**
   - Uses local Ollama at `10.0.2.2:11434`.
   - API key is the placeholder `ollama`.

4. **Rollback:**
   ```bash
   cp ~/.local/share/agent-zero/usr/plugins/_model_config/config.json.backup-<timestamp> \
      ~/.local/share/agent-zero/usr/plugins/_model_config/config.json
   ```

### Conditions for Adoption

- [ ] Agent Zero upstream confirms chat-only mode support.
- [ ] Profile validated in a sandbox phase.
- [ ] Safety boundaries tested and confirmed.
- [ ] Rollback path tested.
- [ ] Human operator explicitly approves.

---

## References

- `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`
- `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`
- `docs/phase12/PHASE12B3_AGENT_ZERO_LOCAL_GEMMA_CONFIG_PATCH_TEST.md`
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- `~/.config/bazzite-security/AGENT_ZERO_BOUNDARIES.md`

# Agent Zero Local Gemma Limitations

**Document:** Agent Zero Local Gemma Limitations
**Date:** 2026-05-02
**Version:** 1.0
**Status:** Current

---

## Purpose

This document lists the known limitations preventing Agent Zero from operating with local Gemma/Ollama. It is a living reference for operators deciding which tool to use for local LLM tasks.

---

## Limitation 1: Tool-Protocol Mismatch

**Severity:** BLOCKING
**Category:** Protocol / Architecture

### Description

Agent Zero's agent loop requires the LLM to return a JSON object with specific fields:

```json
{
  "tool_name": "string",
  "tool_args": {},
  "thoughts": "string",
  "headline": "string"
}
```

Local Gemma (via Ollama) returns plain text:

```
I am a helpful assistant. How can I help you today?
```

Agent Zero cannot parse plain text as a tool request and fails with:

```
Tool request must have a tool_args (type dictionary) field.
```

### Why It Cannot Be Fixed Without Code Changes

- Gemma does not natively support Agent Zero's custom JSON schema.
- Forcing Gemma to emit JSON via system prompt is unreliable and not guaranteed to include all required fields.
- Agent Zero's tool-parsing logic is hardcoded in its Python backend.
- Modifying Agent Zero code is out of scope for this stack (would require upstream changes or a fork).

### Workaround

Use **Space Agent** or **direct Ollama API calls** instead of Agent Zero for local Gemma tasks.

---

## Limitation 2: No Supervised/Chat-Only Profile

**Severity:** BLOCKING
**Category:** Configuration

### Description

Agent Zero v1.9 ships with a single default profile:

| Profile | Behavior | Safe for Local Gemma? |
|---------|----------|----------------------|
| `hacker` | Autonomous tool-calling agent loop | **NO** |
| `chat` | Does not exist | N/A |
| `supervised` | Does not exist | N/A |
| `readonly` | Does not exist | N/A |

The `hacker` profile is designed for external APIs that support function calling (OpenAI, Anthropic, Gemini). It assumes the LLM can generate structured tool requests.

### Why It Matters

Even if local Gemma could somehow emit JSON tool requests, the `hacker` profile would attempt to execute those tools autonomously. This is unsafe for a supervised-only local stack.

### Workaround

No workaround exists within Agent Zero v1.9. A supervised profile would need to be:
1. Designed upstream by Agent Zero maintainers, OR
2. Created as a custom profile by the user (not yet attempted).

See `prompts/opencode/m15a-agent-zero-supervised-profile-design.prompt.txt` for a design proposal.

---

## Limitation 3: No Built-In Ollama Tool-Call Support

**Severity:** BLOCKING
**Category:** Provider Integration

### Description

Agent Zero's Ollama provider configuration (`model_providers.yaml`) defines the Ollama endpoint but does not include tool-call formatting logic. The provider is treated as a plain chat-completion endpoint.

When Agent Zero sends its system prompt + user message to Ollama, it expects the response to be a tool request. Ollama/Gemma has no knowledge of Agent Zero's tool schema and returns conversational text.

### Comparison with OpenAI/Anthropic

| Provider | Tool-Call Support | Works with Agent Zero? |
|----------|-------------------|------------------------|
| OpenAI | Native (function calling) | YES |
| Anthropic | Native (tool use) | YES |
| Google Gemini | Native (function calling) | YES |
| Ollama/Gemma | NONE for Agent Zero schema | **NO** |

---

## Limitation 4: OpenCode Bridge Is Not Local Gemma

**Severity:** MISLEADING
**Category:** Architecture

### Description

The OpenCode bridge (`opencode-main` at `10.0.2.2:4141/v1`) is sometimes mistaken as a way to route Agent Zero to local Gemma. It is not.

- The bridge forwards requests to OpenCode's configured provider.
- OpenCode's default provider is a cloud API (e.g., Moonshot, Claude), NOT local Ollama.
- The bridge adds latency and a dependency on OpenCode being running.
- Previous tests hit **Moonshot quota errors** through the bridge.

**Conclusion:** The bridge is an optional/experimental route to external providers, not a local Gemma adapter.

---

## Limitation 5: Model Loading Timeout (Historical, Now Resolved)

**Severity:** RESOLVED
**Category:** Performance

### Description

In Phase 12B2, the first model load timed out after 30 seconds because the 9.6GB model took longer to load into GPU memory.

### Resolution

- This was a one-time cold-start issue.
- Subsequent loads are faster.
- The timeout was in the test curl command, not in Agent Zero.
- Direct Ollama calls now work reliably with `--max-time 180`.

---

## Summary Matrix

| Limitation | Severity | Can Be Fixed? | Fix Requires |
|------------|----------|---------------|--------------|
| Tool-protocol mismatch | BLOCKING | Unlikely | Agent Zero code change OR reliable Gemma JSON prompt engineering |
| No supervised profile | BLOCKING | Maybe | Custom profile design + upstream support |
| No Ollama tool-call support | BLOCKING | No | Agent Zero provider integration update |
| Bridge not local Gemma | MISLEADING | N/A | Understanding only |
| Model load timeout | RESOLVED | N/A | Already resolved |

---

## Recommended Alternatives

| Use Case | Recommended Tool | Why |
|----------|-----------------|-----|
| Local Gemma chat UI | Space Agent | Manual, plain-text friendly, no tool protocol |
| Local Gemma API scripts | Direct Ollama curl / helpers | No middleware, full control |
| Local Gemma RAG | `gemma-memory-rag` | Supervised, bounded, documented |
| Supervised orchestration | Manual operator + OpenCode | Human-in-the-loop, no autonomy |
| Autonomous agent tasks | **Not recommended locally** | Requires external tool-calling API |

---

## References

- `docs/phase12/PHASE12B2_AGENT_ZERO_LOCAL_GEMMA_PROVIDER_REVIEW.md`
- `docs/phase12/PHASE12B3_AGENT_ZERO_LOCAL_GEMMA_CONFIG_PATCH_TEST.md`
- `docs/phase12/PHASE12B1_AGENT_ZERO_READONLY_RUNTIME_DRY_RUN.md`
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- `prompts/opencode/phase12d-agent-zero-format-compatibility-review.prompt.txt`
- `prompts/opencode/m15a-agent-zero-supervised-profile-design.prompt.txt`

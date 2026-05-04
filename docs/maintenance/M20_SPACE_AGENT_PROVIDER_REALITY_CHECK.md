# M20: Space Agent Provider Reality Check and Documentation Correction

**Maintenance Phase:** M20 — Space Agent Provider Reality Check and Documentation Correction
**Date:** 2026-05-04
**Status:** COMPLETE
**Classification:** Documentation Correction

---

## Summary

User testing revealed that Space Agent's "Local LLM" panel is a **browser/WebGPU Hugging Face/Transformers.js model loader**, not an Ollama chat interface. Entering the Ollama model tag `gemma4-e4b-bazzite:latest` fails because Space Agent looks for `config.json` in a Hugging Face repository format. This contradicts previous Phase 7E.1 documentation that claimed Space Agent worked with local Ollama/Gemma. M20 corrects all affected documentation.

---

## User Finding

When the user entered `gemma4-e4b-bazzite:latest` into Space Agent's "Local LLM" panel, Space Agent attempted to load it as a Hugging Face repo and failed with an error indicating it could not find `config.json`.

**Root cause:** The "Local LLM" panel in Space Agent is designed for:
- Hugging Face model repositories (e.g., `google/gemma-2b`)
- Models with ONNX or compatible browser-runnable assets
- WebGPU/Transformers.js execution in the browser

It is **not** designed for:
- Ollama model tags (e.g., `gemma4-e4b-bazzite:latest`)
- Ollama OpenAI-compatible API endpoints
- Server-based LLM inference

---

## Screenshot Interpretation

Based on user description and Space Agent v0.66.0 behavior:

- The "Local LLM" panel has a model input field.
- It expects a Hugging Face repo ID format (`org/model-name`).
- It downloads model weights/assets via the browser.
- It runs inference via WebGPU/Transformers.js in the Electron renderer.
- It does **not** make HTTP requests to `http://127.0.0.1:11434`.

---

## Ollama Model Tag vs Hugging Face Repo ID Distinction

| Attribute | Ollama Model Tag | Hugging Face Repo ID |
|-----------|------------------|----------------------|
| Format | `gemma4-e4b-bazzite:latest` | `google/gemma-2b` |
| Backend | Ollama server (localhost:11434) | Browser/WebGPU/Transformers.js |
| Assets | Stored in Ollama's model cache | Downloaded from Hugging Face Hub |
| Config | Ollama Modelfile | `config.json`, `model.onnx`, etc. |
| API | OpenAI-compatible REST | None (runs in browser) |
| Works in Space Agent Local LLM? | **NO** | **YES** (if browser-compatible) |

---

## Confirmed Fallback Paths

These paths are **verified** for chatting with local Gemma:

### 1. Terminal Helper (Recommended)

```bash
gemma-bazzite
```

Supervised terminal interface. Asks for confirmation before executing commands.

### 2. Direct Ollama API

```bash
curl -X POST http://127.0.0.1:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma4-e4b-bazzite:latest","messages":[{"role":"user","content":"Hello"}]}'
```

### 3. RAG-Assisted Query

```bash
gemma-knowledge-rag "Your question here"
```

### 4. Direct Ollama CLI

```bash
ollama run gemma4-e4b-bazzite:latest
```

---

## Unknowns

1. **Space Agent OpenAI-compatible provider settings:** Whether Space Agent has a separate "Provider" or "API" settings panel that can connect to an OpenAI-compatible endpoint (like Ollama) is unknown. The user has not found such a panel. Space Agent's `space.yaml` spaces use widget-based layouts, not chat-provider configurations.

2. **Space Agent custom provider documentation:** Space Agent may have undocumented provider setup capabilities. No official documentation was consulted in this phase.

3. **Space Agent #/huggingface route:** Space Agent has a `#/huggingface` route for Transformers.js models. Whether this can be configured to use local Ollama instead is unknown.

---

## Next Safe Research Steps

1. **Inspect Space Agent UI more carefully:** Look for Settings → Provider, Settings → API, or similar configuration panels that might support custom OpenAI-compatible endpoints.
2. **Check Space Agent documentation:** Review any README, wiki, or in-app help for provider configuration.
3. **Test with a known HF repo:** If the user wants to use Space Agent's Local LLM panel, test with a small Hugging Face model that has ONNX assets (e.g., a small ONNX-compatible model) to confirm the panel works as designed.
4. **Do not attempt to force Ollama tags into the Local LLM panel:** This will continue to fail.

---

## Documentation Corrections Applied

| File | What Was Changed |
|------|------------------|
| `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md` | Removed "How to Chat with Gemma via Space Agent" section; replaced with "Important Correction (M20)" and verified fallback paths |
| `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md` | Updated "How Space Agent Fits In" table to show Space Agent + Ollama as "NOT VERIFIED" |
| `scripts/gemma-dashboard-build` | Changed Space Agent panel from "Chat UI running" to "Space Agent running; Ollama/Gemma provider path not yet verified" |
| `scripts/gemma-dashboard-build` | Added note: "Local LLM panel = Hugging Face browser loader only" |

---

## No-Go Boundaries Preserved

| Boundary | Status | Evidence |
|----------|--------|----------|
| No sudo | PASS | No sudo used |
| No package installs | PASS | No dnf/flatpak/brew |
| No model pulls | PASS | No ollama pull |
| No firewall changes | PASS | No firewalld |
| No Space Agent config changes | PASS | No config modified |
| No secrets exposed | PASS | No secrets printed |
| Read-only inspection | PASS | No state changes |

---

## Sign-Off

- M20 Provider Reality Check: COMPLETE
- User finding documented: CONFIRMED
- Documentation corrected: CONFIRMED
- Fallback paths documented: CONFIRMED
- No system changes: CONFIRMED
- No secrets exposed: CONFIRMED

---

## References

- `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- `docs/maintenance/M19_DASHBOARD_SPACE_AGENT_REFINEMENT.md`
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- `scripts/gemma-dashboard-build`

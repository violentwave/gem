# Space Agent Phase 7E Provider And Local Agent Report

**Generated:** 2026-04-30
**Decision:** `space_agent_local_gemma_endpoint_candidate_found`
**Production status:** OpenRouter works manually; local-agent configuration is documented but Space Agent remains manual-only and is not approved for repo editing or autonomous host tasks.

## Scope

Phase 7E records the verified manual provider state, safely tests local Ollama OpenAI-compatible endpoints outside Space Agent, inspects Space Agent process/config metadata without reading secrets, and investigates public Space Agent source/docs for local-agent configuration surfaces.

No sudo, package installs, model downloads, Space Agent config edits, Agent Zero starts, autonomous Space Agent tasks, broad filesystem access grants, provider-secret reads, cookie reads, Local Storage reads, Session Storage reads, Trust Token reads, raw log reads, or browser-state dumps were performed.

## Verified Manual Provider State

OpenRouter works in the Space Agent UI.

- Endpoint used: `https://openrouter.ai/api/v1/chat/completions`
- Model used: `openrouter/free`
- API keys recorded in repo: no

Manual provider failures reported by the user:

- Gemini native API did not work in the Space Agent UI.
- Local Gemma/Ollama did not work in the Space Agent UI.
- No Gemini, OpenRouter, or local provider secret was copied into this report.

## Local Ollama API Test Result

Local Ollama remained reachable outside Space Agent.

- `http://127.0.0.1:11434/api/version`: PASS, returned Ollama `0.22.0`
- `http://127.0.0.1:11434/v1/models`: PASS, listed:
  - `gemma4-e4b-bazzite:latest`
  - `gemma4:e4b`
  - `nomic-embed-text:latest`

Tiny OpenAI-compatible local chat test:

- Endpoint: `http://127.0.0.1:11434/v1/chat/completions`
- Model: `gemma4-e4b-bazzite:latest`
- Result: HTTP/chat-completion object returned from Ollama.
- Observed caveat: the requested `max_tokens: 8` produced an empty assistant `content` with `finish_reason: "length"` and a short `reasoning` field, so the endpoint/model candidate is confirmed reachable but the exact target phrase was not produced under the tiny cap.

Interpretation: local Ollama OpenAI compatibility is available outside Space Agent. Because Space Agent UI still failed for local Gemma/Ollama, the next retry should use the full chat-completions URL plus a non-secret placeholder API key value if the UI requires one.

## Space Agent Config Metadata Result

Space Agent is running manually as an AppImage.

Observed process metadata included:

- `./Space-Agent-0.66-linux-x64.AppImage`
- `/tmp/.mount_Space-*/space-agent`
- Electron helper processes using `--user-data-dir=/home/lch/.config/space-agent`

Config path exists:

- `~/.config/space-agent/`

Observed config directory entries included standard Electron/AppImage paths and Space Agent-specific state containers:

- `Cache/`
- `Code Cache/`
- `Cookies`
- `Crashpad/`
- `customware/`
- `DawnGraphiteCache/`
- `DawnWebGPUCache/`
- `GPUCache/`
- `Local Storage/`
- `Preferences`
- `server/`
- `Session Storage/`
- `SharedStorage*`
- `Trust Tokens*`
- `WebStorage/`
- `.updaterId`

Only names, permissions, sizes, process metadata, and safe file metadata were inspected. Contents were not printed from cookies, Local Storage, Session Storage, Trust Tokens, logs, token files, secret files, provider state, browser data, or API-key storage.

## Public Source Investigation

Public repository inspected read-only from an ephemeral source checkout:

- Repository: `https://github.com/agent0ai/space-agent`
- Local inspection path: `/tmp/space-agent-source-readonly`
- Source was searched only; it was not run or modified.

Relevant source/docs findings:

- `commands/params.yaml` defines `CUSTOMWARE_PATH` as an optional directory that owns writable `L1/` and `L2/` roots as `CUSTOMWARE_PATH/L1` and `CUSTOMWARE_PATH/L2`.
- Root `AGENTS.md` and `app/AGENTS.md` describe the layered app model: `L0` firmware, `L1` group customware, and `L2` user customware.
- `_core/onscreen_agent` is the floating routed overlay agent and first-party user-facing chat runtime.
- `_core/open_router` is a headless provider-policy module for OpenRouter-specific request headers.
- `_core/huggingface` is a browser-only Hugging Face Transformers.js local LLM test surface.
- `_core/webllm` is a browser-only WebLLM test surface.
- `SKILL.md` files are first-party/module extension metadata for the Space Agent skill system.

## `~/conf/onscreen-agent.yaml` Investigation

The path is real in Space Agent source.

- Documented: yes, in `app/L0/_all/mod/_core/onscreen_agent/AGENTS.md` and `app/L0/_all/mod/_core/documentation/docs/agent/onscreen-agent-runtime.md`.
- Source-referenced: yes, `app/L0/_all/mod/_core/onscreen_agent/config.js` exports `ONSCREEN_AGENT_CONFIG_PATH = "~/conf/onscreen-agent.yaml"`.
- UI-referenced: yes, the onscreen-agent panel says values and custom instructions are stored in `~/conf/onscreen-agent.yaml`.
- Repo action taken: no file was created or edited at `~/conf/onscreen-agent.yaml`.

Expected schema from source reads:

```yaml
api_endpoint: https://openrouter.ai/api/v1/chat/completions
api_key: userCrypto:<encrypted value, or UI-managed value>
huggingface_dtype: q4
huggingface_model: ""
local_provider: huggingface
llm_provider: api
max_tokens: 120000
model: anthropic/claude-sonnet-4.6
params: temperature:0.2
prompt_budget_ratios:
  history: 40
  single_message: 10
  system: 30
  transient: 30
custom_system_prompt: optional text
```

Do not manually write this file from `~/projects/gem`. It is Space Agent user app-file state, may contain encrypted or plaintext provider secrets depending on runtime mode, and should be managed through the Space Agent UI unless a future phase explicitly authorizes a reviewed Space Agent-side config edit.

## Local-Agent Configuration Options

| Option | Finding | Phase 7E interpretation |
|--------|---------|-------------------------|
| OpenRouter provider through API endpoint | Supported and verified manually | Works with full chat-completions endpoint and `openrouter/free`; OpenRouter-specific headers are applied by `_core/open_router` when endpoint host is `openrouter.ai` |
| Google Gemini OpenAI-compatible endpoint | Candidate through generic API mode | No Gemini-specific module found; retry should use full endpoint `https://generativelanguage.googleapis.com/v1beta/openai/chat/completions` and model `gemini-2.5-flash` or `gemini-2.5-pro` |
| Ollama OpenAI-compatible endpoint | Candidate through generic API mode | Local endpoint works outside Space Agent; retry should use full endpoint `http://127.0.0.1:11434/v1/chat/completions`, model `gemma4-e4b-bazzite:latest`, and API key `ollama` if Space Agent requires a non-empty key |
| Native Ollama endpoint | Not found as a first-party provider | No native Ollama provider branch was found in `_core/onscreen_agent`; using `http://127.0.0.1:11434` directly is likely unsupported unless a future source version adds it |
| WebLLM/browser local models | Supported as browser-only test surface | `_core/webllm` route exists at `#/webllm`, but it is not the advertised dashboard Local LLM page and requires WebGPU plus compatible WebLLM/MLC artifacts |
| Hugging Face Spaces/agents | No hosted Spaces-agent integration found | The visible Hugging Face path is browser-side Transformers.js model loading, not a Hugging Face Space/Agent handoff; user-facing prompts for an online Hugging Face model likely refer to model repo IDs/Hub URLs |
| Hugging Face Transformers.js local models | Supported as current local provider | `_core/huggingface` route at `#/huggingface` and onscreen/admin local-provider modals share the browser worker manager; models are downloaded/cached by the browser runtime |
| Space Agent internal `SKILL.md` modules | Supported | Skills are metadata-driven under readable `mod/*/*/ext/skills/*/SKILL.md` paths and can be auto-loaded into prompt context based on metadata |
| `onscreen_agent` configuration | Supported | The onscreen agent reads `~/conf/onscreen-agent.yaml`, but this phase does not write it |

## Corrected Retry Candidates

Gemini retry candidate:

- Provider/mode: API/OpenAI-compatible custom endpoint
- Endpoint: `https://generativelanguage.googleapis.com/v1beta/openai/chat/completions`
- Model: `gemini-2.5-flash` first, then `gemini-2.5-pro`
- API key: manually entered by user in Space Agent UI only
- Do not use OpenRouter-style model names such as `google/gemini-2.5-pro` with the Google endpoint.

Local Gemma/Ollama retry candidate:

- Provider/mode: API/OpenAI-compatible custom endpoint, not native Ollama unless a future UI explicitly offers it
- Endpoint: `http://127.0.0.1:11434/v1/chat/completions`
- Model: `gemma4-e4b-bazzite:latest`
- API key: `ollama` if Space Agent requires a non-empty value
- Params: keep generation small for retry; do not run large autonomous tasks

## Recommended Next Action

Use `prompts/opencode/phase7e1-space-agent-local-gemma-retry.prompt.txt` for a manual UI retry pass.

The next pass should record only non-secret results:

- whether OpenRouter still works
- whether local Gemma works with the full Ollama chat-completions URL and `API key: ollama`
- whether Gemini works with the full Google OpenAI-compatible chat-completions URL
- any visible non-secret UI error text

Do not create or edit `~/conf/onscreen-agent.yaml` unless a future phase explicitly authorizes a reviewed config edit.

## Boundaries Preserved

- No sudo used
- No package installs
- No npm global installs
- No model pulls or downloads
- No firewall, USBGuard, ClamAV, Lynis, rpm-ostree, systemd timer, package, Ollama config, model config, OpenCode permission, Agent Zero config, or Space Agent config changes
- No Agent Zero start
- No Space Agent autonomous task
- No Space Agent repo edits
- No Space Agent provider secrets copied into repo
- No cookies, Local Storage contents, Session Storage contents, Trust Token contents, raw logs, browser data, or private provider state printed
- No `~/conf/onscreen-agent.yaml` creation or modification

## Readiness Decision

`space_agent_local_gemma_endpoint_candidate_found`

OpenRouter is verified working in Space Agent. Local Ollama OpenAI-compatible endpoints work outside Space Agent, including a chat-completion response from `gemma4-e4b-bazzite:latest`, so local Gemma has a valid endpoint candidate even though the Space Agent UI still needs a corrected manual retry. Gemini remains a provider runtime/UI issue until the full Google OpenAI-compatible chat-completions endpoint is retried manually.

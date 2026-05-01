# Space Agent Integration Plan

## Overview

Space Agent is the L7 workspace/UI candidate for the Bazzite Local AI Operations Stack.

**Status:** Phase 7E.1 provider finalization complete; OpenRouter and local Gemma/Ollama work in Space Agent
**Decision:** `space_agent_openrouter_and_local_gemma_working`

## Current Role

- Manual workspace exploration
- Provider/model configuration testing
- Operator UI candidate

Space Agent is not approved for broad filesystem access, unattended host tasks, or repo editing in `~/projects/gem` while OpenCode is active.

## Provider Guidance

### OpenRouter

- Endpoint: `https://openrouter.ai/api/v1/chat/completions`
- Verified working model: `openrouter/free`
- Do not record API keys in repo docs or prompts.

### Google Gemini Native API

- Endpoint: `https://generativelanguage.googleapis.com/v1beta/openai/chat/completions`
- Models: `gemini-2.5-pro`, `gemini-2.5-flash`
- Do not use OpenRouter-style names such as `google/gemini-2.5-pro` with the Google native endpoint.
- Phase 7E.1 status: previous UI attempt failed; retry candidate remains optional and unresolved.

### Local Ollama / Gemma

- OpenAI-compatible endpoint: `http://127.0.0.1:11434/v1/chat/completions`
- Native endpoint: `http://127.0.0.1:11434` remains unverified in Space Agent and no native Ollama provider branch was found in the inspected source.
- Working model: `gemma4-e4b-bazzite:latest`
- API key placeholder used: `ollama`
- Max tokens used: `512` or `1024`
- Phase 7E.1 status: working in Space Agent UI.

### Local Browser Models

- Hugging Face Transformers.js local-provider support exists through Space Agent's browser runtime and `#/huggingface` route.
- WebLLM browser model testing exists through `#/webllm`, but it is not the advertised dashboard Local LLM path.
- `~/conf/onscreen-agent.yaml` is a real Space Agent per-user app-file config path, but this repo should not create or edit it directly.

## Safety Rules

- No broad filesystem access.
- No autonomous Space Agent tasks against the host.
- No repo editing while OpenCode is active.
- No secrets copied into repo docs or prompts.
- Provider secrets are entered manually by the user in the UI.

## Next Step

Proceed to Phase 8A workflow-library planning. Keep Space Agent manual-only and do not create or edit `~/conf/onscreen-agent.yaml` from this repo.

# Phase 7D Unified Local Ops Smoke Test

**Generated:** 2026-04-30T22:48:09Z
**Decision:** `phase7_smoke_passed_with_manual_space_agent_confirmation_pending`
**Production status:** Phase 7 components coexist; autonomous production workflows are not enabled.

## Scope

Phase 7D verified that the Phase 7 Agent Zero/A0 connector, RuVector semantic prototype, Space Agent manual workspace, Stage 3A fallback, Stage 4 validators, and local Ollama endpoints can coexist without promoting any component to autonomous production use.

No sudo, package installs, model downloads, config changes, Space Agent autonomous tasks, Agent Zero autonomous tasks, broad filesystem access, or secret/session/browser-data inspection was performed.

## Component Status Summary

| Component | Smoke Result | Notes |
|-----------|--------------|-------|
| Stage 3A deterministic retrieval | PASS | `gemma-knowledge-search` returned approved knowledge results |
| Stage 4 validators | PASS | `gemma-evals-status`, `gemma-evals-check`, `gemma-examples-check` passed |
| RuVector semantic prototype | PASS | 398 semantic chunks loaded; queries returned relevant approved sources |
| Ollama local endpoint | PASS | `/api/version`, `/api/tags`, and tiny embedding health check worked |
| Agent Zero / A0 connector | PASS | A0 CLI v1.5, endpoint HTML, connector version check passed |
| Space Agent | PASS with manual provider confirmation pending | Process/config metadata present; provider UI result still needs exact non-secret confirmation |
| Ports | PASS | No conflict after Agent Zero stop; only Ollama remains listening on checked ports |

## Stage 3A Fallback Result

Command:

- `gemma-knowledge-search "What is the safe operating model for local Gemma?"`

Result:

- PASS
- Top source: `GEMMA_LOCAL_AGENT.md`
- Additional approved source: `OPENCODE_GEMMA_NOTES.md`

Stage 3A remains the canonical fallback.

## Stage 4 Validator Results

Final validator results:

- `gemma-evals-status`: PASS
- `gemma-evals-check`: PASS
- `gemma-examples-check`: PASS

Observed counts:

- Stage 4A cases: 19
- Stage 4B examples: 22
- Reviewed examples: 22
- Validation errors: 0
- Documentation drift candidates: 0

## RuVector Semantic Query Results

Commands:

- `npm run semantic:query -- "What firewall tool does Bazzite use?"`
- `npm run semantic:query -- "What is the safe operating model for local Gemma?"`
- `npm run semantic:query -- "Where should generated security reports and logs go?"`

Result:

- PASS
- Model: `nomic-embed-text:latest`
- Dimensions: 768
- Chunks loaded: 398

Observed top/relevant sources:

- Firewall query: `FINAL_POLICY.md` and Stage 3A chunks referencing `firewalld`
- Safe operating model query: `OPENCODE_GEMMA_NOTES.md` and `GEMMA_LOCAL_AGENT.md`
- Reports/logs query: `FINAL_POLICY.md`, Stage 3A chunks, `GEMMA_LOCAL_AGENT.md`, `OPERATIONS.md`, `RUNBOOK.md`

Persistent semantic prototype data exists under:

- `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json`
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json`
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json`

RuVector remains prototype-only, not production semantic memory.

## Ollama Endpoint And Embedding Result

Endpoint checks:

- `http://127.0.0.1:11434/api/version`: PASS, version `0.22.0`
- `http://127.0.0.1:11434/api/tags`: PASS

Models listed:

- `gemma4-e4b-bazzite:latest`
- `gemma4:e4b`
- `nomic-embed-text:latest`

Tiny embedding health check:

- Model: `nomic-embed-text:latest`
- Prompt: `Phase 7D local ops smoke test`
- HTTP status: 200
- Embedding returned: yes
- Dimensions: 768

No generation task was run.

## Agent Zero / A0 Connector Result

Initial state:

- Agent Zero was already running before the smoke connector check.
- Container mapped `127.0.0.1:5080->80/tcp`.

Checks:

- `agent-zero-status`: PASS
- `podman ps -a | grep -i agent-zero`: PASS
- `a0 --version`: PASS, `1.5`
- `which a0`: PASS, `/home/lch/.local/bin/a0`
- `curl http://127.0.0.1:5080/`: PASS, returned Agent Zero HTML
- `AGENT_ZERO_HOST=http://127.0.0.1:5080 a0 --version`: PASS, `1.5`

No agents were spawned and no tasks were run.

Final state:

- `agent-zero-down` was run.
- `agent-zero-status`: stopped
- `podman ps | grep -i agent-zero`: no running container
- Agent Zero stopped at end: yes

## Space Agent Metadata Result

Space Agent is running manually as an AppImage.

Observed process metadata:

- `./Space-Agent-0.66-linux-x64.AppImage`
- `/tmp/.mount_Space-*/space-agent`
- Electron helper processes with `--user-data-dir=/home/lch/.config/space-agent`

Config path:

- `~/.config/space-agent/`

Observed config metadata included standard Electron/AppImage entries such as `Cache/`, `Code Cache/`, `Crashpad/`, `GPUCache/`, `Local Storage/`, `Session Storage/`, `SharedStorage*`, `Trust Tokens*`, `WebStorage/`, and `.updaterId`.

Only names, sizes, and process/config metadata were inspected. Contents were not printed from cookies, Local Storage, Session Storage, Trust Tokens, logs, tokens, secrets, API keys, browser data, or provider state.

Provider status remains:

- `space_agent_manual_confirmation_needed`

Reason: Space Agent is working manually, but the exact non-secret provider/model result has not been recorded.

## Port Conflict Check

Before stopping Agent Zero:

- `127.0.0.1:5080`: Agent Zero/rootlessport listening
- `127.0.0.1:11434`: Ollama listening

After stopping Agent Zero:

- `127.0.0.1:11434`: Ollama listening
- `127.0.0.1:5080`: no listener
- No listeners observed for checked ports `3000`, `5173`, or `8080`

No ports or configs were changed.

## Boundaries Preserved

- No sudo used
- No package installs
- No global npm installs
- No model pulls or downloads
- No firewall, USBGuard, ClamAV, Lynis, rpm-ostree, systemd timer, package, Ollama config, model config, OpenCode permission, Agent Zero config, or Space Agent config changes
- No services/autostart entries created
- No broad filesystem access granted
- No Space Agent repo edits
- No Space Agent autonomous tasks
- No Agent Zero autonomous tasks
- No secrets, `.env`, cookies, Local Storage contents, Session Storage contents, Trust Token contents, API keys, tokens, raw logs, private code, browser data, or unredacted transcripts inspected
- Stage 3A fallback behavior unchanged
- RuVector not promoted to production semantic memory

## Issues And Risks

- Space Agent provider verification still requires exact non-secret UI result capture.
- RuVector semantic retrieval is working but remains prototype-only; production promotion needs stricter quality gates and storage/query contracts.
- Agent Zero was already running before this smoke test; it was stopped at the end.
- Ollama embedding API works, but the smoke test did not run generation workloads.

## Readiness Decision

`phase7_smoke_passed_with_manual_space_agent_confirmation_pending`

Phase 7 components coexist and passed bounded smoke checks. The stack is ready to proceed to Phase 8 planning/workflow-library design, while keeping Space Agent provider finalization as a remaining manual confirmation item and keeping RuVector semantic memory prototype-only.

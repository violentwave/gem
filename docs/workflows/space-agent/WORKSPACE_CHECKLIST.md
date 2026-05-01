# Space Agent Workspace Checklist (L7)

**Phase:** 8C
**Capability Level:** L7 (Manual UI/Workspace Layer)
**Status:** Documentation-only — no autonomous tasks, no repo edits, no config changes

---

## Workspace Operation Checklist

### Before Starting Any Workspace Task

- [ ] Space Agent is running manually (AppImage) — verified by `ps aux | grep Space-Agent`
- [ ] Task is defined as **manual-only** (no autonomous flag)
- [ ] Space Agent does **NOT** have `~/projects/gem` repo edit access
- [ ] `~/conf/onscreen-agent.yaml` will **NOT** be created or edited by this repo
- [ ] Provider secrets will be entered **manually by human** in UI (not recorded in repo)
- [ ] Approved output path confirmed: `~/offload/security-reports/manual/`
- [ ] Denied paths confirmed: `~/projects/gem/` edits, `~/conf/onscreen-agent.yaml`, secrets

### Provider/Model Configuration (Manual Only)

- [ ] Provider selected manually in Space Agent UI (OpenRouter / Local Ollama / Gemini)
- [ ] API key entered manually by human (not stored in repo docs or prompts)
- [ ] Model verified working:
  - OpenRouter: `openrouter/free`
  - Local Ollama: `gemma4-e4b-bazzite:latest`
  - Gemini native (optional): `gemini-2.5-pro` or `gemini-2.5-flash`
- [ ] Endpoint verified:
  - OpenRouter: `https://openrouter.ai/api/v1/chat/completions`
  - Local Ollama: `http://127.0.0.1:11434/v1/chat/completions`
  - Gemini native: `https://generativelanguage.googleapis.com/v1beta/openai/chat/completions`
- [ ] Max tokens set appropriately (512 or 1024 for local Gemma; 8192 or 16384 for Gemini)
- [ ] `~/conf/onscreen-agent.yaml` NOT modified by repo
- [ ] No OpenRouter-style model names used with Gemini native endpoint (no `google/gemini-2.5-pro`)

### Workspace Task Definition

- [ ] Task defined as manual-only in Space Agent UI
- [ ] Scope documented (no autonomous tasks)
- [ ] Provider/model selected manually
- [ ] Human approval captured for task scope
- [ ] Space Agent confirmed NOT editing `~/projects/gem`
- [ ] `~/conf/onscreen-agent.yaml` confirmed NOT modified
- [ ] Task notes saved to `~/offload/security-reports/manual/space-agent-task-YYYYMMDD-HHMMSS.md`

### Workspace State Inspection (Read-Only)

- [ ] Only file names, sizes, metadata listed (not sensitive content)
- [ ] `~/.config/space-agent/` inspected read-only (metadata only)
- [ ] Cookies, Trust Tokens, Local Storage, Session Storage content NOT printed
- [ ] API keys, tokens, secrets NOT inspected
- [ ] `~/.local/share/space-agent/` checked read-only if present
- [ ] `~/conf/onscreen-agent.yaml` NOT modified
- [ ] Inspection report saved to `~/offload/security-reports/manual/space-agent-state-YYYYMMDD-HHMMSS.md` (no secrets)

### Manual Task Execution (No Autonomous Tasks)

- [ ] Task executed **manually** in Space Agent UI (not autonomous)
- [ ] No Agent Zero tasks spawned from Space Agent
- [ ] No autonomous browser actions
- [ ] Space Agent does NOT edit `~/projects/gem`
- [ ] `~/conf/onscreen-agent.yaml` NOT modified
- [ ] Output saved to `~/offload/security-reports/manual/space-agent-task-execution-YYYYMMDD-HHMMSS.md` (no secrets)
- [ ] Stage 3A RAG fallback available for memory queries

### Workspace Reporting (Output to ~/offload/security-reports/manual/)

- [ ] Report saved to `~/offload/security-reports/manual/` (not repo)
- [ ] No secrets in report (API keys, tokens, cookies, Local Storage, Session Storage)
- [ ] No `~/projects/gem` repo edits by Space Agent
- [ ] `~/conf/onscreen-agent.yaml` NOT modified or inappropriately referenced
- [ ] Report uses template: `docs/workflows/templates/space-agent-workspace-template.md`
- [ ] Human approved report content (no secrets)

### OpenCode Prompt Staging (Reference Only)

- [ ] Prompt staged from `~/projects/gem/prompts/opencode/` (read-only reference)
- [ ] No autonomous prompt execution by Space Agent
- [ ] Human reviews and approves staged prompt
- [ ] Prompt executed by OpenCode (not Space Agent)
- [ ] Human approval captured for prompt execution

### Agent Zero Workflow Handoff Display (Future L5)

- [ ] A0 workflow status displayed in Space Agent UI (future, read-only)
- [ ] No autonomous A0 tasks from Space Agent
- [ ] Human approves all A0 workflows
- [ ] A0 tasks executed by OpenCode/A0 CLI (not Space Agent)

### RuVector/Stage 3A Result Display

- [ ] Stage 3A RAG results displayed (canonical fallback)
- [ ] RuVector prototype results displayed (L6, prototype-only)
- [ ] No production promotion of RuVector without explicit human approval
- [ ] Stage 3A remains canonical fallback for memory queries

### Validation Result Presentation

- [ ] `gemma-evals-status` results displayed (if requested)
- [ ] `gemma-evals-check` results displayed (if requested)
- [ ] `gemma-examples-check` results displayed (if requested)
- [ ] Human reviews validation results in UI
- [ ] No autonomous validation by Space Agent

---

## Stop Conditions (STOP Immediately)

- [ ] Autonomous task requested → STOP, human must re-approve as manual
- [ ] Repo edit requested (`~/projects/gem`) → STOP, use OpenCode instead
- [ ] Config edit requested (`~/conf/onscreen-agent.yaml`) → STOP, human edits manually
- [ ] Secret detected in report → STOP, redact, re-save
- [ ] Sudo/package install requested → STOP, not allowed
- [ ] Model download requested → STOP, not allowed

---

## Human Decision Board (All Workflows)

All workspace operations require human approval:
- [ ] Workspace task definition → Human approves scope (manual only)
- [ ] Provider/model changes → Human enters secrets manually in UI
- [ ] Task execution → Human executes manually, reviews output
- [ ] Report generation → Human approves content (no secrets)
- [ ] OpenCode prompt staging → Human reviews staged prompt
- [ ] A0 workflow handoff → Human approves all A0 workflows

---

## Workspace Closeout

- [ ] All workspace tasks executed manually (no autonomous)
- [ ] All reports saved to `~/offload/security-reports/manual/` (no secrets)
- [ ] No `~/projects/gem` repo edits by Space Agent
- [ ] `~/conf/onscreen-agent.yaml` NOT modified by repo
- [ ] Provider secrets NOT recorded in repo docs or prompts
- [ ] Stage 3A fallback confirmed available
- [ ] Human approves workspace closeout

---

## Fallback Paths

| Component Unavailable | Fallback |
|----------------------|----------|
| Space Agent UI | Terminal + Gemma wrappers |
| OpenRouter | Local Gemma/Ollama via Space Agent or Terminal |
| Local Gemma | Stage 3A deterministic RAG |
| Memory query | Stage 3A deterministic RAG (canonical fallback) |

---

*Checklist version: 1.0*
*Phase: 8C*
*Capability Level: L7 (Manual UI/Workspace)*
*Status: Documentation-only — no autonomous tasks, no repo edits, no config changes*

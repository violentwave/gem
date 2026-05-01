# Space Agent Workspace Workflow Library (L7)

**Phase:** 8C
**Capability Level:** L7 (Manual UI/Workspace Layer)
**Status:** Documentation-only — no autonomous tasks, no repo edits, no config changes
**Space Agent Config:** `~/conf/onscreen-agent.yaml` — real file, NOT created or edited by this repo

---

## Overview

Space Agent is the **L7 manual UI/workspace layer** for the Bazzite Local AI Operations Stack. All workflows in this library are **manual or human-supervised only**.

**Key constraints:**
- Space Agent is **not** approved for autonomous tasks
- Space Agent **does not** have `~/projects/gem` edit access
- `~/conf/onscreen-agent.yaml` is **not** created or edited by this repo
- All provider secrets are entered **manually by the user** in the UI
- No sudo, no package installs, no model downloads

---

## Workspace Workflows

### 1. Workspace Task Definition

**Purpose:** Define what Space Agent should do in a manual workspace session.

**Capability Level:** L7

**When to use:**
- Setting up a Space Agent workspace for a specific task
- Defining manual provider/model testing scope
- Preparing workspace context for OpenCode prompt staging

**Inputs:**
- Task description (human-provided)
- Provider options: OpenRouter (`openrouter/free`), local Gemma (`gemma4-e4b-bazzite:latest`), Gemini native (optional retry)
- Scope boundary: manual only, no autonomous tasks

**Approved Paths:**
| Path | Purpose |
|------|---------|
| `~/.config/space-agent/` | Space Agent config/state (read-only for inventory) |
| `~/offload/security-reports/manual/` | Workspace reports output |
| `~/projects/gem/docs/` | Reference only (no edits) |

**Denied Paths:**
| Path | Reason |
|------|--------|
| `~/projects/gem/` | No repo edit access |
| `~/conf/onscreen-agent.yaml` | Real config file — not created/edited by repo |
| `~/.env` or any secrets | No secrets in workspace |
| Browser data (Cookies, Local Storage, Session Storage, Trust Tokens) | Not copied/printed |

**Allowed Components/Tools:**
- Space Agent UI (manual operation only)
- OpenCode (for repo documentation only, not Space Agent tasks)
- Human (approval authority for all workspace operations)

**Forbidden Actions:**
- No autonomous Space Agent tasks
- No `~/projects/gem` repo edits by Space Agent
- No `~/conf/onscreen-agent.yaml` creation or editing
- No provider secret recording in repo docs or prompts
- No autonomous Agent Zero tasks
- No sudo, package installs, or model downloads

**Execution Steps (Manual/Humn-Supervised):**
1. Human defines workspace task in Space Agent UI
2. Human selects provider/model manually (OpenRouter, local Gemma, or Gemini native)
3. Human enters provider secrets manually in UI (not recorded in repo)
4. Human defines task scope (manual only, no autonomous)
5. Human confirms Space Agent will not edit `~/projects/gem`
6. Human confirms `~/conf/onscreen-agent.yaml` will not be modified

**Validation Steps:**
- [ ] Task is manual-only (no autonomous flag)
- [ ] No repo edit permission granted to Space Agent
- [ ] Provider secrets entered manually, not stored in repo
- [ ] `~/conf/onscreen-agent.yaml` not modified by this workflow
- [ ] Scope documented in workspace notes (saved to `~/offload/security-reports/manual/`)

**Evidence Artifacts:**
- Workspace task notes → `~/offload/security-reports/manual/space-agent-task-YYYYMMDD-HHMMSS.md`
- Provider config notes (no secrets) → `~/offload/security-reports/manual/space-agent-provider-YYYYMMDD-HHMMSS.md`

**Fallback Path:**
- If Space Agent unavailable → Terminal + Gemma wrappers for manual queries
- If provider fails → Stage 3A RAG for deterministic retrieval

**Stop Conditions:**
- Autonomous task requested → STOP, human must re-approve as manual
- Repo edit requested → STOP, use OpenCode instead
- Config edit requested (`~/conf/onscreen-agent.yaml`) → STOP, human must edit manually

**Human Approval Points:**
- All workspace task definitions
- All provider/model changes
- All scope changes

---

### 2. Provider/Model Configuration (Manual Only)

**Purpose:** Document manual provider and model configuration for Space Agent.

**Capability Level:** L7

**When to use:**
- Setting up OpenRouter in Space Agent UI
- Configuring local Gemma/Ollama in Space Agent UI
- Testing Gemini native API (optional retry)
- Verifying provider connectivity

**Inputs:**
- Provider type: OpenRouter, local Ollama, Gemini native
- Model name (verified working)
- API endpoint (verified)
- Max tokens (verified)

**Approved Paths:**
| Path | Purpose |
|------|---------|
| `~/.config/space-agent/` | Config state (read-only inventory) |
| `~/offload/security-reports/manual/` | Provider test notes |
| `http://127.0.0.1:11434/v1/models` | Local Ollama model verification |
| `https://openrouter.ai/api/v1/models` | OpenRouter model list (requires API key) |

**Denied Paths:**
| Path | Reason |
|------|--------|
| `~/conf/onscreen-agent.yaml` | Real config — not edited by repo |
| `~/projects/gem/` | No repo edits |
| API keys / secrets | Not recorded in repo docs |

**Allowed Components/Tools:**
- Space Agent UI (manual provider entry only)
- Human (enters secrets manually in UI)
- OpenCode (for documentation only)

**Forbidden Actions:**
- No `~/conf/onscreen-agent.yaml` creation or editing by repo
- No provider secret recording in repo docs or prompts
- No autonomous provider testing
- No model downloads

**Execution Steps (Manual/Humn-Supervised):**
1. Human opens Space Agent UI
2. Human selects provider tab (OpenRouter / Local / Gemini)
3. Human enters API key manually (not recorded in repo)
4. Human selects verified working model:
   - OpenRouter: `openrouter/free`
   - Local Ollama: `gemma4-e4b-bazzite:latest`
   - Gemini native: `gemini-2.5-pro` or `gemini-2.5-flash` (optional)
5. Human sets max tokens (512 or 1024 for local Gemma; 8192 or 16384 for Gemini)
6. Human tests connection manually in UI
7. Human saves provider config in UI (no repo involvement)
8. Human documents test results (no secrets) to `~/offload/security-reports/manual/`

**Verified Working Configurations:**

| Provider | Endpoint | Model | Max Tokens | Status |
|----------|----------|-------|------------|--------|
| OpenRouter | `https://openrouter.ai/api/v1/chat/completions` | `openrouter/free` | 4096 | Working |
| Local Ollama (OpenAI-compat) | `http://127.0.0.1:11434/v1/chat/completions` | `gemma4-e4b-bazzite:latest` | 512 or 1024 | Working |
| Gemini Native (OpenAI-compat) | `https://generativelanguage.googleapis.com/v1beta/openai/chat/completions` | `gemini-2.5-pro` or `gemini-2.5-flash` | 8192 or 16384 | Optional retry |

**Important:** Do NOT use OpenRouter-style model names (`google/gemini-2.5-pro`) with the Gemini native endpoint. Do NOT mix Ollama native `/api` and OpenAI-compatible `/v1` in the same provider entry.

**Validation Steps:**
- [ ] Provider endpoint reachable (human-verified in UI)
- [ ] Model available in provider UI
- [ ] API key entered manually (not stored in repo)
- [ ] `~/conf/onscreen-agent.yaml` not modified by repo
- [ ] Test results saved to `~/offload/security-reports/manual/` (no secrets)

**Evidence Artifacts:**
- Provider test notes (no secrets) → `~/offload/security-reports/manual/space-agent-provider-test-YYYYMMDD-HHMMSS.md`

**Fallback Path:**
- If provider fails → Use Stage 3A deterministic RAG or Gemma wrappers

**Stop Conditions:**
- Provider secret requested in repo → STOP, human enters in UI only
- `~/conf/onscreen-agent.yaml` edit requested → STOP, human edits manually

**Human Approval Points:**
- All provider changes
- All model changes
- All API key entries (manual in UI)

---

### 3. Workspace State Inspection (Read-Only)

**Purpose:** Inspect Space Agent workspace state without modifications.

**Capability Level:** L7

**When to use:**
- Checking Space Agent config state
- Inventory of `~/.config/space-agent/` entries
- Verifying Space Agent is running/not running
- Checking workspace data without editing

**Inputs:**
- Space Agent config path: `~/.config/space-agent/`
- Space Agent state path: `~/.local/share/space-agent/` (if present)
- Process check: `ps aux | grep Space-Agent`

**Approved Paths (Read-Only):**
| Path | Purpose |
|------|---------|
| `~/.config/space-agent/` | Config state (list file names, sizes, metadata only) |
| `~/.local/share/space-agent/` | State data (if present, read-only inventory) |
| `~/offload/security-reports/manual/` | Inspection reports output |

**Denied Paths (Not Inspected/Copied):**
| Path | Reason |
|------|--------|
| `Cookies`, `Trust Tokens`, `Local Storage`, `Session Storage` | Browser data not copied/printed |
| `~/conf/onscreen-agent.yaml` | Not created/edited by repo |
| `~/projects/gem/` | No repo edits |
| API keys, tokens, secrets | Not inspected or printed |

**Allowed Components/Tools:**
- `ls`, `du`, `stat` (metadata only, not content of sensitive files)
- Space Agent UI (manual inspection)
- Human (approval for all inspections)

**Forbidden Actions:**
- No content inspection of Cookies, Trust Tokens, Local Storage, Session Storage
- No `~/conf/onscreen-agent.yaml` editing
- No secrets printing
- No autonomous inspection tasks

**Execution Steps (Manual/Humn-Supervised):**
1. Human runs `ps aux | grep Space-Agent` to check if running
2. Human lists `~/.config/space-agent/` files (metadata only, not content of sensitive files)
3. Human skips Cookies, Trust Tokens, Local Storage, Session Storage content
4. Human checks `~/.local/share/space-agent/` if present (read-only)
5. Human documents inventory (no secrets) to `~/offload/security-reports/manual/`

**Validation Steps:**
- [ ] Only file names, sizes, metadata listed (not sensitive content)
- [ ] Cookies, Trust Tokens, Local/Session Storage content not printed
- [ ] API keys/env vars not inspected
- [ ] `~/conf/onscreen-agent.yaml` not modified
- [ ] Report saved to `~/offload/security-reports/manual/` (no secrets)

**Evidence Artifacts:**
- Workspace state inventory → `~/offload/security-reports/manual/space-agent-state-YYYYMMDD-HHMMSS.md`

**Fallback Path:**
- If Space Agent not running → Manual config reference in `docs/integrations/space-agent/`

**Stop Conditions:**
- Sensitive file content requested → STOP, list metadata only
- `~/conf/onscreen-agent.yaml` edit requested → STOP

**Human Approval Points:**
- All workspace state inspections
- All inventory reports

---

### 4. Manual Task Execution (No Autonomous Tasks)

**Purpose:** Execute manual tasks in Space Agent UI without autonomy.

**Capability Level:** L7

**When to use:**
- Manual chat with local Gemma via Space Agent
- Manual chat with OpenRouter models
- Manual workspace interaction (no autonomous agents)
- Staging OpenCode prompts via workspace

**Inputs:**
- Task type: chat, query, prompt staging
- Provider: OpenRouter, local Gemma, or Gemini (manual selection)
- Query/prompt text (human-provided)

**Approved Paths:**
| Path | Purpose |
|------|---------|
| Space Agent UI | Manual chat/query execution |
| `~/offload/security-reports/manual/` | Task output reports |
| `~/projects/gem/prompts/opencode/` | Prompt staging reference (read-only) |

**Denied Paths:**
| Path | Reason |
|------|--------|
| `~/projects/gem/` | No repo edits by Space Agent |
| `~/conf/onscreen-agent.yaml` | Not modified by repo |
| Autonomous agent execution | Not allowed |

**Allowed Components/Tools:**
- Space Agent UI (manual chat only, no autonomous agents)
- Human (executes tasks manually, approves all actions)
- OpenCode (for implementation, not Space Agent tasks)

**Forbidden Actions:**
- No autonomous Space Agent tasks
- No Agent Zero task spawning from Space Agent
- No `~/projects/gem` repo edits
- No `~/conf/onscreen-agent.yaml` edits
- No autonomous browser actions

**Execution Steps (Manual/Humn-Supervised):**
1. Human opens Space Agent UI
2. Human selects provider/model manually
3. Human enters query/prompt manually
4. Human reviews response in UI
5. Human stages OpenCode prompt if needed (reference only, no autonomous handoff)
6. Human saves task output (no secrets) to `~/offload/security-reports/manual/`
7. Human confirms no autonomous tasks were executed

**Validation Steps:**
- [ ] Task executed manually (not autonomous)
- [ ] No Agent Zero tasks spawned
- [ ] No repo edits by Space Agent
- [ ] `~/conf/onscreen-agent.yaml` not modified
- [ ] Output saved to `~/offload/security-reports/manual/` (no secrets)
- [ ] Stage 3A fallback available for memory queries

**Evidence Artifacts:**
- Task execution notes → `~/offload/security-reports/manual/space-agent-task-execution-YYYYMMDD-HHMMSS.md`

**Fallback Path:**
- If Space Agent unavailable → Terminal + Gemma wrappers
- If memory query needed → Stage 3A deterministic RAG

**Stop Conditions:**
- Autonomous task detected → STOP, human must re-approve as manual
- Repo edit attempted → STOP, use OpenCode
- Config edit attempted → STOP

**Human Approval Points:**
- All manual task executions
- All prompt staging
- All provider/model selections

---

### 5. Workspace Reporting (Output to ~/offload/security-reports/manual/)

**Purpose:** Generate workspace reports and save to approved output path.

**Capability Level:** L7

**When to use:**
- Documenting Space Agent workspace session
- Saving provider test results
- Recording manual task outputs
- Staging OpenCode prompt context

**Inputs:**
- Workspace session data (human-collected)
- Provider test results (no secrets)
- Task execution notes

**Approved Paths:**
| Path | Purpose |
|------|---------|
| `~/offload/security-reports/manual/` | All workspace reports output |
| `~/projects/gem/prompts/opencode/` | Prompt staging (read-only reference) |

**Denied Paths:**
| Path | Reason |
|------|--------|
| `~/projects/gem/` | No repo edits |
| `~/conf/onscreen-agent.yaml` | Not modified by repo |
| `~/offload/security-reports/` subdirectories not under `manual/` | Use `manual/` only |

**Allowed Components/Tools:**
- Space Agent UI (manual report collection)
- Human (approves all reports, ensures no secrets)
- OpenCode (for repo documentation only)

**Forbidden Actions:**
- No secrets in reports
- No `~/projects/gem` repo edits
- No `~/conf/onscreen-agent.yaml` edits
- No autonomous report generation

**Execution Steps (Manual/Humn-Supervised):**
1. Human collects workspace session data (no secrets)
2. Human collects provider test results (no API keys)
3. Human stages OpenCode prompt context if needed (reference only)
4. Human writes report to `~/offload/security-reports/manual/space-agent-*-YYYYMMDD-HHMMSS.md`
5. Human verifies no secrets in report
6. Human verifies `~/conf/onscreen-agent.yaml` not referenced or modified

**Report Template:** Use `docs/workflows/templates/space-agent-workspace-template.md`

**Validation Steps:**
- [ ] Report saved to `~/offload/security-reports/manual/` (not repo)
- [ ] No secrets in report (API keys, tokens, cookies)
- [ ] No `~/projects/gem` repo edits
- [ ] `~/conf/onscreen-agent.yaml` not modified or referenced inappropriately
- [ ] Report uses template format

**Evidence Artifacts:**
- Workspace reports → `~/offload/security-reports/manual/space-agent-*-YYYYMMDD-HHMMSS.md`

**Fallback Path:**
- If `~/offload/security-reports/manual/` unavailable → Human keeps notes manually

**Stop Conditions:**
- Secret detected in report → STOP, redact, re-save
- Repo edit attempted → STOP

**Human Approval Points:**
- All workspace reports
- All prompt staging
- All output location selections

---

## Workspace Hygiene

### Rules for All Workflows

1. **Manual Only:** Space Agent is L7 manual UI — no autonomous tasks
2. **No Repo Edits:** Space Agent does NOT have `~/projects/gem` edit access
3. **No Config Edits:** `~/conf/onscreen-agent.yaml` is NOT created or edited by this repo
4. **Secrets in UI Only:** Provider secrets entered manually by human in UI, not recorded in repo
5. **Approved Output Path:** All reports → `~/offload/security-reports/manual/`
6. **Denied Browser Data:** Cookies, Trust Tokens, Local Storage, Session Storage not copied/printed
7. **Stage 3A Fallback:** Always available for memory queries

### Stop Conditions (All Workflows)

| Condition | Action |
|-----------|--------|
| Autonomous task requested | STOP, human must re-approve as manual |
| Repo edit requested (`~/projects/gem`) | STOP, use OpenCode instead |
| Config edit requested (`~/conf/onscreen-agent.yaml`) | STOP, human edits manually |
| Secret detected in report | STOP, redact, re-save |
| Sudo/package install requested | STOP, not allowed |

### Human Decision Board (All Workflows)

All workspace operations require human approval:
- Workspace task definition → Human approves scope (manual only)
- Provider/model changes → Human enters secrets manually in UI
- Task execution → Human executes manually, reviews output
- Report generation → Human approves content (no secrets)
- OpenCode prompt staging → Human reviews staged prompt

### Fallback Paths

| Component Unavailable | Fallback |
|----------------------|----------|
| Space Agent UI | Terminal + Gemma wrappers |
| OpenRouter | Local Gemma/Ollama via Space Agent or Terminal |
| Local Gemma | Stage 3A deterministic RAG |
| Memory query | Stage 3A deterministic RAG (canonical fallback) |

---

## Workspace Closeout

### Closeout Checklist

- [ ] All workspace tasks executed manually (no autonomous)
- [ ] All reports saved to `~/offload/security-reports/manual/` (no secrets)
- [ ] No `~/projects/gem` repo edits by Space Agent
- [ ] `~/conf/onscreen-agent.yaml` not modified by repo
- [ ] Provider secrets not recorded in repo docs or prompts
- [ ] Stage 3A fallback confirmed available
- [ ] Human approves workspace closeout

---

## Integration Points

### OpenCode Prompt Staging
- Space Agent can display OpenCode prompts for human review
- Prompts staged from `~/projects/gem/prompts/opencode/` (read-only)
- Human approves and executes prompts via OpenCode

### Agent Zero Workflow Handoff Display
- Space Agent can display A0 workflow status (future, L5)
- No autonomous A0 tasks from Space Agent
- Human approves all A0 workflows

### RuVector/Stage 3A Result Display
- Space Agent can display Stage 3A RAG results (canonical fallback)
- Space Agent can display RuVector prototype results (L6, prototype-only)
- No production promotion of RuVector without explicit human approval

### Validation Result Presentation
- Space Agent can display `gemma-evals-status`, `gemma-evals-check`, `gemma-examples-check` results
- Human reviews validation results in UI
- No autonomous validation by Space Agent

---

## Related Documents

- Space Agent Integration Plan: `docs/integrations/space-agent/SPACE_AGENT_INTEGRATION_PLAN.md`
- Phase 7C Workspace Report: `docs/integrations/space-agent/SPACE_AGENT_PHASE7C_WORKSPACE_AND_MODELS_REPORT.md`
- Phase 7E Provider Report: `docs/integrations/space-agent/SPACE_AGENT_PHASE7E_PROVIDER_AND_LOCAL_AGENT_REPORT.md`
- Phase 7E.1 Provider Finalization: `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- Component Routing Matrix: `docs/architecture/COMPONENT_ROUTING_MATRIX.md`
- Data Flow and State Map: `docs/architecture/DATA_FLOW_AND_STATE_MAP.md`
- Roadmap: `docs/roadmap/ROADMAP.md`
- Workspace template: `docs/workflows/templates/space-agent-workspace-template.md`
- Workspace checklist: `docs/workflows/space-agent/WORKSPACE_CHECKLIST.md`

---

*Workflow library version: 1.0*
*Phase: 8C*
*Capability Level: L7 (Manual UI/Workspace)*
*Status: Documentation-only — no autonomous tasks, no repo edits, no config changes*

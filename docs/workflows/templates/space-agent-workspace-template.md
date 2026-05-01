# Space Agent Workspace Report Template (L7)

**Phase:** 8C
**Capability Level:** L7 (Manual UI/Workspace Layer)
**Status:** Documentation-only — no autonomous tasks, no repo edits, no config changes

---

## Report Metadata

- **Report Type:** [Workspace Task / Provider Test / State Inspection / Task Execution / Validation Results]
- **Generated:** [YYYY-MM-DDTHH:MM:SSZ]
- **Space Agent Version:** [from `ps aux | grep Space-Agent` or UI]
- **Operator:** [Human name or "manual"]
- **Workspace Scope:** [Manual-only, no autonomous tasks]

---

## Workspace Configuration

### Provider/Model Used

| Field | Value |
|-------|-------|
| Provider | [OpenRouter / Local Ollama / Gemini Native] |
| Model | [openrouter/free / gemma4-e4b-bazzite:latest / gemini-2.5-pro / gemini-2.5-flash] |
| Endpoint | [Verified endpoint URL] |
| Max Tokens | [512 / 1024 / 8192 / 16384] |
| API Key | [ENTERED MANUALLY BY HUMAN — NOT RECORDED] |

### Space Agent State

| Field | Value |
|-------|-------|
| Running As | [AppImage / other] |
| Config Path | `~/.config/space-agent/` (read-only inventory) |
| State Path | `~/.local/share/space-agent/` (if present, read-only) |
| Repo Edit Access | **NO** — `~/projects/gem` not edited by Space Agent |
| Config Edited | **NO** — `~/conf/onscreen-agent.yaml` NOT modified by repo |

---

## Task Definition (Manual-Only)

### Task Description
[Human-provided task description — manual-only, no autonomous tasks]

### Scope Boundaries
- [ ] Task is manual-only (no autonomous flag)
- [ ] Space Agent does NOT have `~/projects/gem` edit access
- [ ] `~/conf/onscreen-agent.yaml` NOT created or edited by repo
- [ ] Provider secrets entered manually by human in UI (not recorded)
- [ ] No autonomous Agent Zero tasks
- [ ] No sudo, package installs, or model downloads

---

## Execution Notes (Manual/Humn-Supervised)

### Steps Performed
1. [Human opened Space Agent UI]
2. [Human selected provider/model manually]
3. [Human entered API key manually — NOT recorded]
4. [Human defined task scope — manual-only]
5. [Human executed task manually in UI]
6. [Human saved output to `~/offload/security-reports/manual/`]

### Queries/Prompts Used
[Human-provided queries or prompts — no secrets]

### Responses Received
[Summary of responses from Space Agent — no secrets, no sensitive data]

---

## Validation Results

### Stage 4 Validators (Gemma Wrappers)
- [ ] `gemma-evals-status` — PASS/FAIL
- [ ] `gemma-evals-check` — PASS/FAIL
- [ ] `gemma-examples-check` — PASS/FAIL

### Workspace Validation
- [ ] Task executed manually (not autonomous) — PASS/FAIL
- [ ] No repo edits by Space Agent — PASS/FAIL
- [ ] `~/conf/onscreen-agent.yaml` NOT modified — PASS/FAIL
- [ ] No secrets in report — PASS/FAIL
- [ ] Output saved to `~/offload/security-reports/manual/` — PASS/FAIL

---

## Evidence Artifacts

| Artifact | Path |
|----------|------|
| Workspace task notes | `~/offload/security-reports/manual/space-agent-task-YYYYMMDD-HHMMSS.md` |
| Provider test notes | `~/offload/security-reports/manual/space-agent-provider-YYYYMMDD-HHMMSS.md` |
| State inspection | `~/offload/security-reports/manual/space-agent-state-YYYYMMDD-HHMMSS.md` |
| Task execution | `~/offload/security-reports/manual/space-agent-task-execution-YYYYMMDD-HHMMSS.md` |

---

## Fallback Paths Used

| Component | Fallback Used | Reason |
|-----------|------------------|--------|
| Space Agent unavailable | Terminal + Gemma wrappers | [reason] |
| Provider failed | Stage 3A RAG | [reason] |
| Memory query | Stage 3A deterministic RAG | [canonical fallback] |

---

## Issues and Risks

### Issues Encountered
- [List any issues — no secrets, no sensitive data]

### Risks Identified
- [List any risks — provider secrets in UI, config paths, etc.]

---

## Human Approval

- [ ] Task scope approved (manual-only)
- [ ] Provider/model configuration approved (secrets entered manually)
- [ ] Task execution approved (manual)
- [ ] Report content approved (no secrets)
- [ ] Workspace closeout approved

**Human:** [Name or "manual"]
**Date:** [YYYY-MM-DD]
**Decision:** [Approved / Approved with notes / Rejected]

---

## Notes

[Any additional notes — no secrets, no sensitive data, no `~/projects/gem` repo edits, no `~/conf/onscreen-agent.yaml` modifications]

---

*Template version: 1.0*
*Phase: 8C*
*Capability Level: L7 (Manual UI/Workspace)*
*Output Path: `~/offload/security-reports/manual/`*
*Status: Documentation-only — no autonomous tasks, no repo edits, no config changes*

# Agent Zero Workflow Checklist

**Phase:** 8A
**Status:** Reusable checklist template
**Purpose:** Ensure each workflow prompt meets boundaries and authorization requirements

---

## Workflow Identification

| Field | Value |
|-------|-------|
| **Task name** | [Workflow name from library] |
| **Capability level** | L3 (defined) / L4 (validated) / L5 (active) |
| **Phase** | 8A.1, 8A.2, etc. |

---

## Purpose and Scope

| Check | Status |
|-------|--------|
| Purpose is clearly stated | ☐ |
| When to use is documented | ☐ |
| Scope is bounded and specific | ☐ |
| No broad host access implied | ☐ |

---

## Approved Paths

| Check | Status |
|-------|--------|
| Project path is specified (e.g., `~/projects/gem`) | ☐ |
| Sub-paths are explicitly listed | ☐ |
| No system directories included | ☐ |

---

## Denied Paths

| Check | Status |
|-------|--------|
| No `sudo` or root operations | ☐ |
| No system service changes | ☐ |
| No firewall/security config access | ☐ |
| No package management | ☐ |
| No model downloads | ☐ |
| No secret/credential access | ☐ |
| No autonomous repo edits | ☐ |
| No autostart/daemon changes | ☐ |

---

## Allowed Tools/Components

| Check | Status |
|-------|--------|
| Gemma wrappers (advisory only) | ☐ |
| Stage 3A RAG (deterministic) | ☐ |
| RuVector prototype (scoped, with Stage 3A fallback) | ☐ |
| OpenCode (read-only or implementation with approval) | ☐ |
| Space Agent (manual workspace only) | ☐ |

---

## Forbidden Actions

| Check | Status |
|-------|--------|
| No autonomous execution without approval | ☐ |
| No automatic code generation | ☐ |
| No auto-fix on failures | ☐ |
| No broad filesystem access | ☐ |
| No secret ingestion | ☐ |
| No system changes | ☐ |

---

## Required Validators

| Validator | When Required | Status |
|-----------|---------------|--------|
| gemma-evals-status | After changes | ☐ |
| gemma-evals-check | After implementation | ☐ |
| gemma-examples-check | After documentation changes | ☐ |
| lsp_diagnostics | After code changes | ☐ |

---

## Expected Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| [Output 1] | Markdown/JSON | Task output |
| [Output 2] | Markdown/JSON | Task output |
| [Evidence] | Log/summary | Task output |

---

## Rollback/Cleanup Plan

| Step | Action | Trigger |
|------|--------|---------|
| 1 | [Rollback action] | [Failure condition] |
| 2 | [Cleanup action] | [Completion condition] |
| 3 | [Evidence preservation] | [Always] |

---

## Stop Conditions

| Condition | Action |
|-----------|--------|
| [Stop condition 1] | Report to human, do not proceed |
| [Stop condition 2] | Halt workflow, preserve state |
| [Stop condition 3] | Fallback to manual execution |

---

## Final Response Format

```markdown
## Workflow: [Name]

### Status
- Result: [success/partial/failed]
- Artifacts: [list]

### Evidence
- [Evidence 1]
- [Evidence 2]

### Human Approval Required
- [ ] Review outputs
- [ ] Approve next steps
```

---

## Example Checklist (Workflow 8A.1: Read-Only Repo Briefing)

| Field | Value |
|-------|-------|
| **Task name** | Agent Zero Read-Only Repo Briefing |
| **Capability level** | L3 |
| **Phase** | 8A.1 |

| Check | Status |
|-------|--------|
| Purpose clearly stated | ☑ |
| When to use documented | ☑ |
| Scope bounded | ☑ |
| Project path specified | ☑ |
| No system directories | ☑ |
| No sudo operations | ☑ |
| No autonomous execution | ☑ |
| Gemma allowed (advisory) | ☑ |
| Stage 3A allowed | ☑ |
| OpenCode read-only | ☑ |
| No secret ingestion | ☑ |
| No system changes | ☑ |
| No autonomous repo edits | ☑ |
| gemma-evals-status after | ☐ |
| gemma-evals-check after | ☐ |
| Fallback: Manual file listing | ☐ |
| Stop: Request implies code changes | ☐ |
| Stop: Request asks for secrets | ☐ |

---

## Validation

```bash
# Verify checklist exists
test -f docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_CHECKLIST.md

# Validate against template
grep -c "Check" docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_CHECKLIST.md
```

---

## Next Steps

Use this checklist for each future workflow prompt:
- Phase 8A.1: Read-only repo briefing
- Phase 8A.2: Validation orchestration
- Phase 8B: Memory workflows
- Phase 8C: Space Agent workspace workflows

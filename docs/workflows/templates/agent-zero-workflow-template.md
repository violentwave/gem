# Agent Zero Workflow Template

**Phase:** 8A
**Purpose:** Reusable template for creating Agent Zero workflow prompts

---

## Workflow Name

[Workflow name, e.g., "Agent Zero Read-Only Repo Briefing"]

---

## Capability Level

| Level | Description |
|-------|-------------|
| L3 | Defined in documentation, not executed |
| L4 | Validated through testing, ready for supervised use |
| L5 | Active in production with monitoring |

---

## Purpose

[One paragraph describing what this workflow accomplishes]

**When to use:**
- [Specific scenario 1]
- [Specific scenario 2]
- [Specific scenario 3]

---

## Inputs

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| [Input 1] | [type] | Yes/No | [Description] |
| [Input 2] | [type] | Yes/No | [Description] |
| [Input 3] | [type] | Yes/No | [Description] |

---

## Approved Paths

```
# Allowed paths
- ~/projects/gem/
- ~/.local/share/bazzite-security/
- ~/.config/bazzite-security/

# Specifically included
- [path 1]
- [path 2]
```

---

## Denied Paths

```
# Explicitly denied
- /etc/
- /var/
- ~/.env
- ~/.config/space-agent/ (credentials)
- ~/conf/onscreen-agent.yaml

# Denied actions
- sudo operations
- system service changes
- firewall modifications
- package installs
- model downloads
- secret/credential access
```

---

## Allowed Tools/Components

| Component | Role | Notes |
|-----------|------|-------|
| Gemma wrappers | Advisory, RAG | Query-only, no execution |
| Stage 3A RAG | Deterministic retrieval | Canonical fallback |
| RuVector | Semantic prototype | Scoped lookup only, requires Stage 3A comparison |
| OpenCode | File reads, validation | Implementation with approval |
| Space Agent | Manual workspace | No autonomous tasks |

---

## Forbidden Actions

1. No autonomous execution without human approval
2. No automatic code generation or edits
3. No system/security/package changes
4. No secret, credential, or log access
5. No broad filesystem access beyond approved paths
6. No persistent daemon or autostart changes
7. No automatic remediation or self-healing

---

## Execution Steps

1. **Step 1:** [Action]
   - Input: [source]
   - Output: [destination]
   - Validator: [optional]

2. **Step 2:** [Action]
   - Input: [source]
   - Output: [destination]
   - Validator: [optional]

3. **Step 3:** [Action]
   - Input: [source]
   - Output: [destination]
   - Validator: [optional]

---

## Validation Steps

| Step | Validator | When |
|------|-----------|------|
| Post-execution | gemma-evals-status | If code/docs changed |
| Post-execution | gemma-evals-check | If implementation done |
| Post-execution | lsp_diagnostics | If files modified |
| Post-execution | gemma-examples-check | If documentation changed |

---

## Evidence Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| [Artifact 1] | [Markdown/JSON/log] | Task output |
| [Artifact 2] | [Markdown/JSON/log] | Task output |
| [Evidence summary] | Markdown | Task output |

---

## Fallback Path

```
[Primary workflow]
    │
    ▼ (if fails)
[Component fallback]
    │
    ▼ (if unavailable)
[Manual execution]
    │
    ▼ (if blocked)
[Report to human, stop]
```

**Fallback details:**
- [Specific fallback 1]
- [Specific fallback 2]

---

## Stop Conditions

| Condition | Action |
|-----------|--------|
| [Condition 1] | Report to human, do not proceed |
| [Condition 2] | Halt workflow, preserve state |
| [Condition 3] | Fallback to manual execution |
| [Condition 4] | Stop immediately |

---

## Human Approval Points

| Point | Required | Action |
|-------|----------|--------|
| Workflow initiation | Yes | Human approves task |
| Component invocation | If sensitive | Human approves tool use |
| Output review | Yes | Human reviews results |
| Next step approval | Yes | Human decides continuation |

---

## Final Response Format

```markdown
## Workflow: [Name]

### Status
- Result: [success/partial/failed/stopped]
- Execution time: [duration]
- Steps completed: [N/M]

### Outputs
- [Output 1]: [location]
- [Output 2]: [location]

### Validation Results
- [Validator 1]: [pass/fail]
- [Validator 2]: [pass/fail]

### Evidence
- [Evidence artifact 1]
- [Evidence artifact 2]

### Human Approval Required
- [ ] Review outputs
- [ ] Approve next steps / close workflow

### Stop Condition Triggered (if applicable)
- Condition: [description]
- Action taken: [action]
```

---

## Validation Commands

```bash
# Verify template exists
test -f docs/workflows/templates/agent-zero-workflow-template.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Notes

- [Additional notes, context, or references]
- [Related workflows]
- [Dependencies]

---

*Template version: 1.0*
*Phase: 8A*
*Status: Documentation-only*

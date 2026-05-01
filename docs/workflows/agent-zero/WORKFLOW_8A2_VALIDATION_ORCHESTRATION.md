# Agent Zero Validation Orchestration Workflow

**Phase:** 8A.2
**Status:** Documentation-only workflow definition
**Production status:** Not enabled for execution; future supervised use only

---

## Workflow Name

Agent Zero Validation Orchestration

---

## Capability Level

L3 (Defined in documentation, not yet executed)

---

## Purpose

Coordinate validation checks across the Bazzite Local AI Operations Stack, including Stage 4 eval system, knowledge/RAG validators, repo checks, code/prototype checks, and integration metadata checks. This workflow aggregates results and produces a structured validation summary for human review.

**This workflow is documentation-only in Phase 8A.2.** No Agent Zero runtime execution occurs. The workflow defines what a future supervised validation orchestration would look like when authorized. **No autonomous fixes are ever performed.**

---

## When to Use

- After implementation work completes and before proposing changes
- During pre-commit review
- When checking current system state
- When verifying Phase completion status
- When generating validation evidence for audit or handoff
- When preparing for human review of changes

---

## Inputs

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| Target path | string | Yes | Path to validate (e.g., `~/projects/gem`) |
| Validation scope | enum | Yes | `full` / `core` / `custom` |
| Specific validators | string[] | No | List of validators to run |
| Skip validators | string[] | No | List of validators to skip |
| Include metadata checks | boolean | No | Whether to include integration checks |
| Report location | string | No | Custom output path (default: ~/offload/security-reports/manual/) |

---

## Approved Paths

```
# Primary project paths
- ~/projects/gem/
- ~/projects/gem/docs/
- ~/projects/gem/prompts/
- ~/projects/gem/prototypes/

# Stage 4 eval paths
- ~/.local/share/bazzite-security/gemma-evals/
- ~/.local/share/bazzite-security/gemma-evals/cases/
- ~/.local/share/bazzite-security/gemma-evals/examples/
- ~/.local/share/bazzite-security/gemma-evals/manifests/

# Knowledge pack paths (Stage 3A)
- ~/.local/share/bazzite-security/gemma-knowledge/
- ~/.local/share/bazzite-security/gemma-knowledge/docs/
- ~/.local/share/bazzite-security/gemma-knowledge/index/

# RuVector prototype metadata (read-only, small files only)
- ~/.local/share/bazzite-security/ruvector/semantic-prototype/ (metadata and reports only)

# Optional: reports output (non-secret only)
- ~/offload/security-reports/manual/

# Read-only logs for existing helper output
- ~/.local/state/bazzite-security/logs/ (read existing logs only)
```

---

## Denied Paths

```
# Never access
- .env files
- API keys, provider secrets, credentials
- Cookies, Local Storage, Session Storage, Trust Tokens
- Browser data
- Raw private logs
- Private code outside the requested validation scope
- ~/.cache/
- Agent Zero runtime memory
- Space Agent config contents

# Not without explicit future authorization
- Broad ~/projects/ traversal (outside gem)
- Broad ~/offload/security-reports/ traversal
- System directories (/etc/, /var/)
- ~/conf/onscreen-agent.yaml
- Runtime state that could include secrets
```

---

## Allowed Tools/Components

| Component | Role | Notes |
|-----------|------|-------|
| gemma-evals-status | Stage 4 eval status | Reports overall eval health |
| gemma-evals-check | Stage 4 eval validation | Validates case files |
| gemma-examples-check | Example validation | Validates supervised examples |
| gemma-examples-review-drafts | Draft review | Reviews draft examples |
| gemma-knowledge-check | Knowledge pack check | Validates knowledge structure |
| gemma-knowledge-search | RAG query | Safe lookup queries only |
| git | Repo status | read-only status/diff |
| lsp_diagnostics | Code validation | When available on files |
| a0 --version | A0 CLI version | Metadata only, no tasks |
| ollama version/list | Ollama metadata | No generation |
| OpenCode | File reads, validator runs | No edits in this workflow |

**Note:** RuVector is not used in validation orchestration. Stage 3A provides deterministic fallback if knowledge queries are needed.

---

## Forbidden Actions

- **No Agent Zero runtime execution** - workflow is documentation-only
- **No A0 task execution** - no tasks sent to Agent Zero
- **No agent spawning** - no new agents created
- **No autonomous code fixes** - never auto-fix any failures
- **No repo edits** - read-only validation; no file modifications
- **No system changes** - no sudo, package installs, config changes
- **No broad filesystem crawling** - only approved paths
- **No secret inspection** - never read credentials, keys, or sensitive data
- **No commits** - never commit validation results
- **No config changes** - never modify any component config
- **No package installs** - only run pre-installed validators

---

## Validation Categories

### A. Core Gemma/Eval Validators

| Validator | Purpose | When Required |
|-----------|---------|----------------|
| gemma-evals-status | Overall eval health | Always for full scope |
| gemma-evals-check | Case file validation | Always for full scope |
| gemma-examples-check | Example file validation | Always for full scope |
| gemma-examples-review-drafts | Draft example review | When drafts exist |

### B. Knowledge/RAG Validators

| Validator | Purpose | When Required |
|-----------|---------|----------------|
| gemma-knowledge-check | Knowledge pack structure | Optional |
| gemma-knowledge-search | Safe RAG query | Optional, safe queries only |
| gemma-knowledge-rag | RAG generation | Only when explicitly requested by human |

### C. Repo Validation

| Validator | Purpose | When Required |
|-----------|---------|----------------|
| git status --short | Repo status | Optional |
| git diff --stat | Change summary | Optional |
| File existence checks | Deliverable presence | Optional |
| Markdown structure checks | Doc structure | Optional |

### D. Code/Prototype Validation

| Validator | Purpose | When Required |
|-----------|---------|----------------|
| npm scripts | Repo-local prototypes | Only for ~/projects/gem/prototypes |
| lsp_diagnostics | Type/syntax errors | When available |
| semgrep | Static analysis | Only if already installed, no new installs |

### E. Integration Metadata Checks

| Validator | Purpose | When Required |
|-----------|---------|----------------|
| a0 --version | A0 CLI version | Optional metadata only |
| ollama version/list | Ollama availability | Optional, no generation |
| Space Agent metadata | Process presence | Optional, no config read |

---

## Execution Steps

**Note:** These steps define what a future supervised execution would look like. In Phase 8A.2, no actual execution occurs.

### Future Supervised Execution Flow

1. **Confirm validation target and scope**
   - Human provides target path
   - Human specifies scope: `full` / `core` / `custom`
   - Human lists specific validators or skips

2. **Confirm approved validators**
   - Match requested validators against allowed list
   - Reject any denied or unauthorized validators

3. **Confirm denied paths/actions**
   - Verify no validation will touch denied paths
   - Verify no autonomous fixes will be attempted

4. **Collect pre-validation repo status**
   - Run `git status --short` to show current state
   - Note any uncommitted changes

5. **Run validators in safe order**
   - **Phase 1:** File/deliverable checks (existence, structure)
   - **Phase 2:** Stage 4 validators (gemma-evals-status, check, examples-check)
   - **Phase 3:** Knowledge/RAG checks (if requested)
   - **Phase 4:** Repo/prototype-specific checks (if applicable)
   - **Phase 5:** Optional metadata-only integration checks

6. **Aggregate results**
   - Collect all validator outputs
   - Classify each result as pass/fail/warning/skipped

7. **Produce validation summary**
   - Generate Markdown summary using template
   - Include results table
   - Document failures with evidence

8. **On failure: stop, report, await human direction**
   - Do NOT attempt any fixes
   - Do NOT commit or push
   - Report detailed failure information
   - Await human decision on next steps

9. **On success: report and await next step**
   - Present validation summary
   - Await human approval to proceed

---

## Failure Handling

All failures must be classified and handled appropriately:

### Failure Classification

| Type | Description | Action |
|------|-------------|--------|
| **Blocking** | Core validator failed (e.g., gemma-evals-check) | Stop, report to human, do not proceed |
| **Non-blocking warning** | Non-essential check failed (e.g., optional metadata) | Include in report, continue |
| **Environment unavailable** | Validator not installed/running | Mark as skipped, continue |
| **Skipped by boundary** | Validator touches denied path | Mark as skipped, do not run |
| **Skipped by user** | Human explicitly requested skip | Mark as skipped, continue |

### For Each Failure Type

**Blocking failure:**
- Report: Which validator, exact error, evidence
- Evidence: Command output, log paths, timestamp
- Do not: Attempt fix, commit, or continue
- Stop: Yes - halt workflow
- Ask human: Approval on how to proceed

**Non-blocking warning:**
- Report: Which validator, warning message
- Evidence: Command output
- Do not: Stop workflow
- Continue: Yes

**Environment unavailable:**
- Report: Which validator, why unavailable
- Evidence: Error message
- Do not: Try to install or force run
- Continue: Yes, mark as skipped

**Skipped by boundary:**
- Report: Which validator, what boundary blocked it
- Evidence: Boundary rule reference
- Do not: Attempt to bypass
- Continue: Yes, mark as skipped

**Skipped by user instruction:**
- Report: Which validator, user request
- Evidence: Original request
- Continue: Yes, mark as skipped

---

## Success Handling

On successful validation:

1. Present validation summary to human
2. Include all passed validators with results
3. Include any non-blocking warnings
4. Include any skipped checks with reasons
5. Await human approval for next steps
6. Do NOT auto-commit results
7. Do NOT proceed with implementation without approval

---

## Evidence Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| Validation summary | Markdown | User-specified or ~/offload/security-reports/manual/ |
| Results table | Markdown | In summary |
| Command output | Text | In summary, referenced logs |
| Git status summary | Text | In summary |
| Skipped checks list | Markdown | In summary |

**Note:** No raw logs or secrets in any output. All content must be non-sensitive.

---

## Fallback Path

```
Validator run → Aggregate results → Report to human
     │
     ▼ (if validator unavailable)
Mark as skipped → Continue with available validators
     │
     ▼ (if all blocking validators fail)
Stop immediately → Report to human → Await direction
```

---

## Stop Conditions

| Condition | Action |
|-----------|--------|
| Any blocking validator fails | Stop, report to human, do not proceed |
| Request includes autonomous fix | Stop immediately, explain no auto-fix allowed |
| Request asks to commit results | Stop, explain no auto-commit allowed |
| Validation scope includes denied paths | Stop, report to human |
| Request to run not-installed validators | Stop, explain no package installs |
| Request to modify configs | Stop, explain no config changes allowed |
| Request to start Agent Zero | Stop, explain documentation-only phase |

---

## Human Approval Points

| Point | Required | Action |
|-------|----------|--------|
| Validation initiation | Yes | Human approves target, scope, validators |
| Validator additions | Yes | Human approves any additions to default set |
| Failure review | Yes | Human reviews any failures before any action |
| Next step approval | Yes | Human decides whether to proceed after results |
| Report storage | Yes | Human approves where to store validation report |

---

## Expected Final Response Format

```markdown
## Agent Zero Validation Orchestration

### Target
- Path: ~/projects/gem
- Date: [ISO date]
- Scope: [full/core/custom]

### Validators Run

| Validator | Result | Details |
|-----------|--------|---------|
| gemma-evals-status | [PASS/FAIL] | [details] |
| gemma-evals-check | [PASS/FAIL] | [details] |
| gemma-examples-check | [PASS/FAIL] | [details] |
| [other validators] | [PASS/FAIL/SKIP] | [details] |

### Failures

[If any blocking failures:]
- **Validator:** [name]
- **Error:** [exact error message]
- **Evidence:** [command output, log paths]
- **Action:** Stopped, awaiting human direction

[If any non-blocking warnings:]
- **Validator:** [name]
- **Warning:** [warning message]
- **Action:** Included in summary, workflow continued

### Skipped Checks

| Validator | Reason |
|-----------|--------|
| [validator] | [boundary/user/unavailable] |

### Evidence

- Validation report: [path]
- Git status: [summary]
- Logs: [paths if applicable]

---

### Recommended Next Step
- [Proceed/Do not proceed] - based on results

### Human Approval Required
- [ ] Review results
- [ ] Decide next action
```

---

## Example Validation Summary Output

For ~/projects/gem with full scope:

```
## Agent Zero Validation Orchestration: ~/projects/gem

### Target
- Path: ~/projects/gem
- Date: 2026-04-30
- Scope: full

### Validators Run

| Validator | Result | Details |
|-----------|--------|---------|
| gemma-evals-status | PASS | 19 cases, 22 examples, 0 errors |
| gemma-evals-check | PASS | All validations passed |
| gemma-examples-check | PASS | 22 examples, 0 errors |
| gemma-knowledge-check | PASS | Knowledge pack structure valid |
| git status --short | PASS | Repo clean |
| a0 --version | PASS | 1.5 |

### Failures
None

### Skipped Checks
- gemma-knowledge-rag: Skipped by user (not requested)
- lsp_diagnostics: Not applicable (no changes)

### Evidence
- Validation report: ~/offload/security-reports/manual/gemma-evals-status-20260430.md
- Git status: Clean (no uncommitted changes)
- All Stage 4 validators: PASS

### Recommended Next Step
- Proceed - all core validators passed

### Human Approval Required
- [x] Review results
- [ ] Decide next action
```

---

## Validation Commands

```bash
# Verify workflow doc exists
test -f docs/workflows/agent-zero/WORKFLOW_8A2_VALIDATION_ORCHESTRATION.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check

# Check output
git diff -- docs/workflows/
```

---

## Production Status

**Phase 8A.2:** Documentation-only. This workflow defines the validation process but does not execute it. Agent Zero remains stopped. No agents are spawned. **No autonomous fixes are ever performed.** Execution requires explicit future authorization from human.

---

## Next Steps

- Phase 8B: Memory Workflow Library
- Phase 8C: Space Agent Workspace Workflow Library

See `prompts/opencode/phase8b-memory-workflow-library.prompt.txt` for the memory workflow definition.

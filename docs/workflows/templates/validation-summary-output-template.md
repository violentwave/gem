# Validation Summary Output Template

**Phase:** 8A.2
**Purpose:** Reusable Markdown template for Agent Zero validation orchestration summaries

---

## Template Structure

```markdown
# Agent Zero Validation Orchestration

## Target
- **Path:** [validation target path]
- **Date:** [ISO date]
- **Scope:** [full/core/custom]

## Validators Run

| Validator | Result | Details |
|-----------|--------|---------|
| [Validator 1] | [PASS/FAIL/SKIP] | [details] |
| [Validator 2] | [PASS/FAIL/SKIP] | [details] |
| [Validator 3] | [PASS/FAIL/SKIP] | [details] |
| [Validator N] | [PASS/FAIL/SKIP] | [details] |

## Failures

### Blocking Failures
[If any blocking failures exist:]

- **Validator:** [name]
- **Error:** [exact error message]
- **Evidence:** [command output, log paths, timestamps]
- **Action:** Stopped, awaiting human direction

### Non-Blocking Warnings
[If any non-blocking warnings exist:]

- **Validator:** [name]
- **Warning:** [warning message]
- **Action:** Included in summary, workflow continued

## Skipped Checks

| Validator | Reason |
|-----------|--------|
| [Validator] | [boundary/user instruction/environment unavailable] |

## Evidence Artifacts

- **Validation Report:** [path]
- **Git Status:** [summary]
- **Logs:** [paths to existing log files]
- **Generated Reports:** [paths if any]

## Boundary Notes

- [Any boundary decisions made during validation]
- [Any paths that were checked and rejected]

## Recommended Next Step

- **[Proceed / Do not proceed]** - [based on results and human approval]

## Human Approval Required

- [ ] Review all results
- [ ] Decide next action (proceed / fix manually / abort)
- [ ] Approve report storage location
```

---

## Example: ~/projects/gem Full Scope

```markdown
# Agent Zero Validation Orchestration

## Target
- **Path:** ~/projects/gem
- **Date:** 2026-04-30
- **Scope:** full

## Validators Run

| Validator | Result | Details |
|-----------|--------|---------|
| gemma-evals-status | PASS | 19 cases, 22 examples (reviewed: 22), 0 errors |
| gemma-evals-check | PASS | command_review: 8, knowledge_rag: 5, path_policy: 5, forbidden_output: 1 |
| gemma-examples-check | PASS | 22 examples, 0 errors |
| gemma-knowledge-check | PASS | Knowledge pack structure valid |
| git status --short | PASS | No uncommitted changes |
| a0 --version | PASS | 1.5 |

## Failures

### Blocking Failures
None

### Non-Blocking Warnings
None

## Skipped Checks

| Validator | Reason |
|-----------|--------|
| gemma-knowledge-rag | User did not request generation |
| lsp_diagnostics | No file changes to validate |
| semgrep | Not included in scope |

## Evidence Artifacts

- **Validation Report:** ~/offload/security-reports/manual/gemma-evals-status-20260430.md
- **Git Status:** Clean (no uncommitted changes)
- **Manifest:** ~/.local/share/bazzite-security/gemma-evals/manifests/gemma-evals-check-20260430.txt

## Boundary Notes

- No denied paths accessed
- No autonomous fixes attempted
- No system changes made
- Agent Zero not started (metadata check only)

## Recommended Next Step

- **Proceed** - All core validators passed, no blocking failures

## Human Approval Required

- [x] Review all results
- [x] Decide next action (proceed with next phase)
- [x] Approve report storage location (default: ~/offload/security-reports/manual/)
```

---

## Example: ~/projects/gem Core Scope Only

```markdown
# Agent Zero Validation Orchestration

## Target
- **Path:** ~/projects/gem
- **Date:** 2026-04-30
- **Scope:** core

## Validators Run

| Validator | Result | Details |
|-----------|--------|---------|
| gemma-evals-status | PASS | 19 cases, 22 examples |
| gemma-evals-check | PASS | All cases valid |
| gemma-examples-check | PASS | All examples valid |

## Failures

None

## Skipped Checks

| Validator | Reason |
|-----------|--------|
| gemma-knowledge-check | Not in core scope |
| git status | Not in core scope |
| a0 --version | Not in core scope |

## Evidence Artifacts

- **Validation Report:** (in-memory summary for core scope)
- **Stage 4 Results:** PASS

## Recommended Next Step

- **Proceed** - Core validators passed

## Human Approval Required

- [ ] Review results
- [ ] Decide next action
```

---

## Example: Validation with Failure

```markdown
# Agent Zero Validation Orchestration

## Target
- **Path:** ~/projects/gem
- **Date:** 2026-04-30
- **Scope:** full

## Validators Run

| Validator | Result | Details |
|-----------|--------|---------|
| gemma-evals-status | FAIL | 19 cases, but 1 example review pending |
| gemma-evals-check | PASS | All cases valid |
| gemma-examples-check | FAIL | 21 passed, 1 draft not reviewed |

## Failures

### Blocking Failures

- **Validator:** gemma-examples-check
- **Error:** Example count mismatch - 1 draft example exists
- **Evidence:**
  - Expected: 22 reviewed examples
  - Actual: 21 reviewed, 1 draft
  - Manifest: ~/.local/share/bazzite-security/gemma-evals/manifests/gemma-examples-check-20260430.txt
- **Action:** Stopped, awaiting human direction

### Non-Blocking Warnings
None

## Skipped Checks

| Validator | Reason |
|-----------|--------|
| lsp_diagnostics | No modified files |

## Evidence Artifacts

- **Validation Report:** ~/offload/security-reports/manual/gemma-examples-check-20260430.txt
- **Manifest:** ~/.local/share/bazzite-security/gemma-evals/manifests/
- **Log:** ~/.local/state/bazzite-security/logs/gemma-examples-check-20260430.log

## Boundary Notes

- Did not attempt to fix the draft example
- Did not run gemma-examples-review-drafts without authorization
- Did not modify any files

## Recommended Next Step

- **Do not proceed** - Blocking failure requires human decision

## Human Approval Required

- [x] Review failure details
- [ ] Decide: fix manually / run review-drafts / abort
- [ ] Approve next action before proceeding
```

---

## Template Validation

```bash
# Verify template exists
test -f docs/workflows/templates/validation-summary-output-template.md
```

---

*Template for Phase 8A.2 validation orchestration summaries*
*Status: Documentation-only template*

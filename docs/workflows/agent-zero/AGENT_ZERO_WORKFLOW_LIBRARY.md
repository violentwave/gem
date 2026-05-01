# Agent Zero Workflow Library

**Phase:** 8A
**Status:** Documentation-only; not yet enabled for execution
**Production status:** Workflows are defined but not active; execution requires explicit authorization

---

## Overview

This library defines safe Agent Zero workflow categories for future supervised L5 orchestration. All workflows are documentation-only in Phase 8A. No Agent Zero tasks are run, no agents are spawned, and no autonomous production use is enabled.

The workflows are designed to be:
- Bounded and explicit in scope
- Routed through existing component responsibilities
- Reversible where possible
- Require human approval at key points

---

## Workflow Categories

### 1. Read-Only Repo Briefing

**Purpose:** Generate a structured summary of the repository state for human review.

**When to use:**
- When preparing for implementation work
- When onboarding to a new component
- When generating handoff documentation

**Inputs:**
- Project path (e.g., `~/projects/gem`)
- Focus area (e.g., `docs/`, `prompts/`, `inventory/`)
- Optional depth level (summary/detailed)

**Allowed components/tools:**
- Gemma wrappers for advisory
- Stage 3A deterministic RAG for context
- OpenCode for file reads (no edits)

**Forbidden actions:**
- No system changes
- No repo edits
- No agent spawning
- No broad filesystem access beyond authorized paths
- No secret/sensitive file access

**Required approval point:** Human must authorize each briefing request

**Expected outputs:**
- Structured summary in Markdown format
- File count and structure overview
- Key documents listed

**Validators:** None required for read-only

**Fallback path:** Manual file listing and reading via terminal

**Stop conditions:**
- Request asks for system details beyond project scope
- Request implies code changes or edits
- Request asks for secrets or credentials

**Evidence location:** Generated report saved to task output (human-reviewed)

**Readiness level:** L3 (defined, not executed)

---

### 2. Validation Orchestration

**Purpose:** Coordinate validation checks across Stage 4 eval system, lsp diagnostics, and custom validators.

**When to use:**
- After implementation work completes
- Before proposing changes
- During pre-commit review

**Inputs:**
- File path or directory to validate
- Validation type (eval, lsp, custom)
- Expected outcome criteria

**Allowed components/tools:**
- gemma-evals-status
- gemma-evals-check
- gemma-examples-check
- lsp_diagnostics on changed files
- OpenCode for running validators

**Forbidden actions:**
- No autonomous code fixes
- No system config changes
- No package installs

**Required approval point:** Human must approve before and after validation

**Expected outputs:**
- Validation results summary
- Pass/fail status per validator
- Error details if any

**Validators:** All Stage 4 validators must pass

**Fallback path:** Manual validator execution via terminal

**Stop conditions:**
- Any validator fails - report to human, do not auto-fix
- Request asks to bypass validators

**Evidence location:** Validation report in task output

**Readiness level:** L3 (defined, not executed)

---

### 3. Report Triage and Summarization

**Purpose:** Analyze and summarize generated reports, logs, or documentation.

**When to use:**
- After security scans
- After evaluation runs
- When reviewing multi-file outputs

**Inputs:**
- Report path(s)
- Focus area or query
- Output format preference

**Allowed components/tools:**
- Gemma wrappers for summarization
- Stage 3A RAG for context
- OpenCode for file reading

**Forbidden actions:**
- No system changes
- No code modifications
- No secret content processing

**Required approval point:** Human approves source documents

**Expected outputs:**
- Summary in requested format
- Key findings highlighted
- Action items suggested (not executed)

**Validators:** None required

**Fallback path:** Manual reading and summarization

**Stop conditions:**
- Report contains secrets or credentials
- Request asks to act on findings automatically

**Evidence location:** Summary in task output

**Readiness level:** L3 (defined, not executed)

---

### 4. Handoff Generation

**Purpose:** Create structured context handoffs between components or sessions.

**When to use:**
- Before switching components
- Before ending a session
- When preparing for implementation

**Inputs:**
- Source component (e.g., Gemma, OpenCode)
- Target component (e.g., Agent Zero, Space Agent)
- Context to preserve
- Session ID if applicable

**Allowed components/tools:**
- All components for context retrieval
- File reads for documentation
- Gemma for advisory

**Forbidden actions:**
- No autonomous execution
- No secret inclusion
- No system changes

**Required approval point:** Human reviews handoff content

**Expected outputs:**
- Structured context document
- Key decisions and state
- Next steps recommended

**Validators:** Human review required

**Fallback path:** Manual note-taking

**Stop conditions:**
- Request includes secrets
- Request asks for automatic execution

**Evidence location:** Handoff document in task output

**Readiness level:** L3 (defined, not executed)

---

### 5. Advisory Command-Review Workflow

**Purpose:** Review proposed commands or actions through Gemma advisory layer before execution.

**When to use:**
- Before running complex commands
- When unsure about side effects
- When reviewing implementation plans

**Inputs:**
- Proposed command or action
- Context about target
- Safety concerns to check

**Allowed components/tools:**
- Gemma wrappers for command review
- Stage 3A for policy lookup

**Forbidden actions:**
- No command execution
- No system changes

**Required approval point:** Human reviews advisory output before any action

**Expected outputs:**
- Advisory assessment
- Risk level (low/medium/high)
- Recommendations

**Validators:** None - advisory only

**Fallback path:** Direct human review

**Stop conditions:**
- Command is destructive
- Command requires sudo
- Command modifies security configs

**Evidence location:** Advisory in task output

**Readiness level:** L3 (defined, not executed)

---

### 6. Memory-Assisted Context Lookup

**Purpose:** Retrieve relevant context from RuVector semantic prototype with Stage 3A fallback.

**When to use:**
- When needing historical context
- When searching prior decisions
- When building on previous work

**Inputs:**
- Query string
- Scope (project-specific or cross-session)
- Result count limit

**Allowed components/tools:**
- RuVector for semantic query (prototype only)
- Stage 3A for deterministic fallback
- Gemma wrappers for context synthesis

**Forbidden actions:**
- No autonomous memory ingestion
- No production memory promotion
- No broad filesystem access

**Required approval point:** Human approves memory query scope

**Expected outputs:**
- Retrieved context items
- Source attribution
- Relevance score if available

**Validators:** Results compared with Stage 3A for consistency

**Fallback path:** Stage 3A deterministic RAG always available

**Stop conditions:**
- Query scope exceeds authorized paths
- Memory contains unauthorized content

**Evidence location:** Query results in task output

**Readiness level:** L3 (defined, not executed)

**Note:** RuVector is prototype-only. Stage 3A remains the canonical fallback.

---

### 7. Space Agent Manual Workspace Handoff

**Purpose:** Prepare context for Space Agent manual workspace exploration.

**When to use:**
- Before Space Agent session
- When preparing UI-based work
- When transitioning from terminal to browser

**Inputs:**
- Target workspace or focus area
- Relevant context to display
- UI format preference

**Allowed components/tools:**
- OpenCode for file reading
- Gemma for context preparation
- Stage 3A for documentation lookup

**Forbidden actions:**
- No autonomous Space Agent tasks
- No Space Agent config edits
- No repo editing through Space Agent

**Required approval point:** Human initiates Space Agent work

**Expected outputs:**
- Context summary for Space Agent display
- Navigation hints if applicable
- Action buttons/links if supported

**Validators:** None - manual workspace

**Fallback path:** Terminal-based work continues

**Stop conditions:**
- Request asks Space Agent to edit repo
- Request asks for autonomous tasks

**Evidence location:** Handoff document in task output

**Readiness level:** L3 (defined, not executed)

---

### 8. OpenCode Implementation-Prompt Handoff

**Purpose:** Prepare structured prompts for OpenCode implementation work.

**When to use:**
- When transitioning from advisory to implementation
- When preparing code changes
- When creating feature requests

**Inputs:**
- Implementation goal
- Constraints and boundaries
- Success criteria

**Allowed components/tools:**
- All components for context gathering
- File reads for codebase understanding

**Forbidden actions:**
- No autonomous execution
- No system changes

**Required approval point:** Human reviews and approves prompt before execution

**Expected outputs:**
- Structured prompt for OpenCode
- Context summary
- Success criteria

**Validators:** Human review before execution

**Fallback path:** Direct human-to-OpenCode communication

**Stop conditions:**
- Prompt includes unauthorized actions

**Evidence location:** Prompt document in task output

**Readiness level:** L3 (defined, not executed)

---

### 9. Failed-Workflow Triage

**Purpose:** Analyze and categorize workflow failures for human review.

**When to use:**
- When a workflow fails
- When errors need investigation
- When preparing failure reports

**Inputs:**
- Failed workflow details
- Error messages
- Last known state

**Allowed components/tools:**
- Log reading (non-secret)
- File state inspection
- Gemma for analysis

**Forbidden actions:**
- No autonomous fixes
- No system changes

**Required approval point:** Human reviews triage results

**Expected outputs:**
- Failure categorization
- Root cause hypothesis
- Recommended next steps

**Validators:** None - triage only

**Fallback path:** Direct human investigation

**Stop conditions:**
- Request asks to auto-fix
- Error contains sensitive data

**Evidence location:** Triage report in task output

**Readiness level:** L3 (defined, not executed)

---

### 10. Workflow Closeout and Evidence Capture

**Purpose:** Finalize workflows and capture evidence for audit or handoff.

**When to use:**
- When completing any workflow
- When preparing evidence package
- When closing a session

**Inputs:**
- Workflow ID or name
- Artifacts to capture
- Evidence format

**Allowed components/tools:**
- File reads for artifacts
- Gemma for summary
- Stage 3A for policy lookup

**Forbidden actions:**
- No secret inclusion
- No system changes

**Required approval point:** Human approves evidence package

**Expected outputs:**
- Evidence summary
- Artifact list
- Completion status

**Validators:** Human review

**Fallback path:** Manual evidence collection

**Stop conditions:**
- Evidence contains secrets

**Evidence location:** Specified evidence storage path

**Readiness level:** L3 (defined, not executed)

---

## Routing Rules Summary

| Workflow | Primary Handler | Fallback | Not Allowed |
|----------|-----------------|----------|-------------|
| Repo briefing | OpenCode (read) | Terminal | System changes |
| Validation orchestration | OpenCode (run validators) | Manual | Auto-fix |
| Report triage | Gemma | Manual | System changes |
| Handoff generation | OpenCode | Manual | Execution |
| Command review | Gemma | Human | Execution |
| Memory lookup | RuVector (proto) → Stage 3A | Stage 3A | Production memory |
| Space Agent handoff | OpenCode | Terminal | Autonomous tasks |
| OpenCode handoff | OpenCode | Direct | Execution |
| Failed-workflow triage | OpenCode | Human | Auto-fix |
| Closeout/evidence | OpenCode | Manual | Secrets |

---

## Validation Commands

```bash
# Validate workflow library exists
test -f docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md

# Run Stage 4 validators
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Next Steps

- Phase 8A.1: Agent Zero read-only repo briefing workflow (first implementation)
- Phase 8A.2: Agent Zero validation orchestration workflow
- Phase 8B: Memory workflow library
- Phase 8C: Space Agent workspace workflow library

See `prompts/opencode/phase8a1-agent-zero-readonly-repo-briefing-workflow.prompt.txt` for the first workflow implementation.

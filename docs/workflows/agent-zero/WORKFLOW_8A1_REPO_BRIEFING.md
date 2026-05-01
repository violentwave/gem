# Agent Zero Read-Only Repo Briefing Workflow

**Phase:** 8A.1
**Status:** Documentation-only workflow definition
**Production status:** Not enabled for execution; future supervised use only

---

## Workflow Name

Agent Zero Read-Only Repo Briefing

---

## Capability Level

L3 (Defined in documentation, not yet executed)

---

## Purpose

Generate a structured, read-only summary of a repository's current state, documentation, and roadmap for human review. This workflow is designed for onboarding, handoff preparation, and context gathering before implementation work.

**This workflow is documentation-only in Phase 8A.1.** No Agent Zero runtime execution occurs. The workflow defines what a future supervised Agent Zero briefing would look like when authorized.

---

## When to Use

- When preparing for implementation work in a new or existing project
- When onboarding to a new component of the Bazzite Local AI Operations Stack
- When generating handoff documentation for another human or component
- When needing a quick summary of project state for decision-making
- When validating current phase status before proceeding

---

## Inputs

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| Target repo path | string | Yes | Path to the repository (e.g., `~/projects/gem`) |
| Focus areas | string[] | No | Specific directories (e.g., `docs/`, `prompts/`, `inventory/`) |
| Depth level | enum | No | `summary` (default) or `detailed` |
| Include validators | boolean | No | Whether to run Stage 4 validators |
| Include memory lookup | boolean | No | Whether to optionally query Stage 3A/RuVector |

---

## Approved Paths

```
# Primary project paths
- ~/projects/gem/docs/
- ~/projects/gem/prompts/
- ~/projects/gem/inventory/
- ~/projects/gem/README.md
- ~/projects/gem/AGENTS.md
- ~/projects/gem/prototypes/ruvector-memory/README.md

# Knowledge pack paths (Stage 3A)
- ~/.local/share/bazzite-security/gemma-knowledge/docs/
- ~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl

# RuVector prototype metadata (read-only, small files only)
- ~/.local/share/bazzite-security/ruvector/semantic-prototype/ (metadata only, not large JSON dumps)

# Optional: reports output (non-secret only)
- ~/offload/security-reports/manual/
```

---

## Denied Paths

```
# Never access
- .env files
- API keys, provider secrets, credentials
- Cookies, Local Storage, Session Storage, Trust Tokens
- Browser data
- Raw logs (~/.local/state/bazzite-security/logs/*.log content)
- Private code outside the requested repo
- ~/.cache/
- Agent Zero runtime memory
- Space Agent config contents

# Not without explicit future authorization
- Broad ~/projects/ traversal (outside gem)
- Broad ~/offload/security-reports/ traversal
- System directories (/etc/, /var/)
- ~/conf/onscreen-agent.yaml
```

---

## Allowed Tools/Components

| Component | Role | Notes |
|-----------|------|-------|
| OpenCode | File reads | May read approved paths to collect content; no edits in this workflow |
| Gemma wrappers | Advisory/RAG | May be used for contextual queries if explicitly requested by human |
| Stage 3A RAG | Deterministic fallback | May be queried for Bazzite/Gemma source context |
| RuVector | Semantic prototype | May be used for scoped memory lookup over approved docs; must compare with Stage 3A for important claims |
| Human | Approval authority | Must authorize workflow start and review outputs |

---

## Forbidden Actions

- **No Agent Zero runtime execution** - workflow is documentation-only
- **No A0 task execution** - no tasks sent to Agent Zero
- **No agent spawning** - no new agents created
- **No repo edits** - read-only operation; no file modifications beyond optional documentation creation
- **No autonomous fixes** - no auto-correction of any kind
- **No system changes** - no sudo, package installs, config changes
- **No broad filesystem crawling** - only approved paths
- **No secret inspection** - never read credentials, keys, or sensitive data
- **No memory ingestion** - no new data written to RuVector
- **No Space Agent repo editing** - Space Agent may not modify ~/projects/gem

---

## Execution Steps

**Note:** These steps define what a future supervised execution would look like. In Phase 8A.1, no actual execution occurs.

### Future Supervised Execution Flow

1. **Confirm target repo/path**
   - Human provides target repository path
   - Validate against approved paths list

2. **Confirm briefing scope**
   - Human specifies focus areas (docs/, prompts/, inventory/)
   - Human specifies depth level (summary/detailed)
   - Human confirms whether to include validator runs

3. **Read approved repo docs**
   - Use OpenCode to read README.md, AGENTS.md
   - Use OpenCode to list and read docs/ directory structure
   - Use OpenCode to list prompts/ directory structure
   - Use OpenCode to list inventory/ directory structure

4. **Collect file inventory summary**
   - Count markdown files in docs/, prompts/, inventory/
   - List key subdirectories
   - Note any empty directories

5. **Collect roadmap/current-state summary**
   - Read ROADMAP.md to extract current phase
   - Read COMPONENT_ROUTING_MATRIX.md for routing rules
   - Note completed phases and upcoming phases

6. **Optionally query Stage 3A/RuVector**
   - If human requests, query Stage 3A for Bazzite context
   - If human requests, query RuVector for project context
   - Compare results for important claims

7. **Produce Markdown briefing**
   - Generate structured briefing using template
   - Include all focus areas requested
   - Include file inventory summary

8. **Run validators if applicable**
   - If human requests, run gemma-evals-status
   - Report results in briefing

9. **Stop and report if denied paths encountered**
   - If any request touches denied paths, halt and report to human
   - Do not proceed with any secret-containing content

---

## Validation Steps

| Step | Validator | When | Action on Failure |
|------|-----------|------|-------------------|
| Pre-execution | Path validation | Before reading | Stop, report to human |
| Post-execution | gemma-evals-status | If requested | Report in output |
| Post-execution | gemma-evals-check | If requested | Report in output |
| Post-execution | gemma-examples-check | If requested | Report in output |

---

## Evidence Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| Repo briefing | Markdown | User-specified (repo or ~/offload/security-reports/manual/) |
| File inventory | JSON (optional) | Same as briefing |
| Validator results | Markdown | Same as briefing |

**Note:** No raw logs or secrets in any output. All content must be non-sensitive.

---

## Fallback Path

```
OpenCode read → Manual terminal listing → Human review
     │
     ▼ (if OpenCode unavailable)
Manual file listing via ls/find
     │
     ▼ (if output insufficient)
Human provides context directly
```

---

## Stop Conditions

| Condition | Action |
|-----------|--------|
| Requested path not in approved list | Stop, report to human, do not proceed |
| Request includes secrets/credentials | Stop immediately, do not process |
| Request implies repo edits | Stop, remind human this is read-only |
| Request asks to start Agent Zero | Stop, explain documentation-only phase |
| Request asks for system details beyond project scope | Stop, report to human |
| RuVector returns unexpected large files | Stop, do not dump large JSON to output |

---

## Human Approval Points

| Point | Required | Action |
|-------|----------|--------|
| Workflow initiation | Yes | Human approves target repo and scope |
| Component invocation | Yes | Human approves any Gemma/RuVector queries |
| Validator inclusion | Yes | Human decides whether to run validators |
| Output review | Yes | Human reviews briefing before distribution |
| Next steps | Yes | Human decides whether to proceed with implementation |

---

## Expected Final Response Format

```markdown
## Agent Zero Read-Only Repo Briefing

### Target
- Repository: ~/projects/gem
- Date: [ISO date]
- Scope: [summary/detailed]

### Current State
- Current phase: [from roadmap]
- Completed phases: [list]
- Active next steps: [from roadmap]

### Documentation Summary
- Architecture docs: [count]
- Integration docs: [count]
- Workflow docs: [count]
- Prompt files: [count]

### Validator Status
- gemma-evals-status: [pass/fail]
- [other validators if requested]

### Key Documentation
- [List key docs with brief descriptions]

### Focus Area Details
- [Detailed listing for each requested focus area]

### Risks/Blockers
- [Any known blockers from docs]

### Recommended Next Steps
- [Based on roadmap status]

---
Generated by: [component]
Reviewed by: [human]
```

---

## Example Briefing Output Outline

For ~/projects/gem specifically:

```
## Agent Zero Read-Only Repo Briefing: ~/projects/gem

### Target
- Repository: ~/projects/gem
- Date: 2026-04-30
- Scope: summary

### Current State
- Current phase: Phase 8A (L5 Workflows) - Documentation Complete
- Completed: Stage 1-4, Phase 5A-F, Phase 7A-7E.1
- Active: Phase 8A.1 upcoming (read-only repo briefing implementation)

### Documentation Summary
- Architecture docs: 5+ (COMPONENT_ROUTING_MATRIX, UNIFIED_OPERATOR_LAYER, DATA_FLOW_AND_STATE_MAP, CAPABILITY_LEVELS, etc.)
- Integration docs: 10+ (agent-zero/, space-agent/, ruvector/, etc.)
- Workflow docs: 4 (AGENT_ZERO_WORKFLOW_LIBRARY, BOUNDARIES, CHECKLIST, template)
- Prompt files: 15+

### Validator Status
- gemma-evals-status: PASS (19 cases, 22 examples)
- gemma-evals-check: PASS
- gemma-examples-check: PASS (22 examples, 0 errors)

### Key Documentation
- README.md: Project coordination repo for Bazzite Local AI Ops Stack
- AGENTS.md: Agent instructions for local operations
- ROADMAP.md: Full phase timeline with current state

### Integrations Verified
- Agent Zero: A0 CLI v1.5 installed, smoke test passed, stopped
- RuVector: Semantic prototype with 398 chunks, Stage 3A fallback
- Space Agent: Manual workspace with OpenRouter + local Gemma/Ollama

### Risks/Blockers
- RuVector remains prototype-only
- Gemini optional/unresolved in Space Agent

### Recommended Next Steps
- Execute Phase 8A.1 workflow implementation
- Plan Phase 8A.2 validation orchestration
- Plan Phase 8B memory workflow library
```

---

## Validation Commands

```bash
# Verify workflow doc exists
test -f docs/workflows/agent-zero/WORKFLOW_8A1_REPO_BRIEFING.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check

# Check output
git diff -- docs/workflows/
```

---

## Production Status

**Phase 8A.1:** Documentation-only. This workflow defines the process but does not execute it. Agent Zero remains stopped. No agents are spawned. Execution requires explicit future authorization from human.

---

## Next Steps

- Phase 8A.2: Agent Zero Validation Orchestration Workflow
- Phase 8B: Memory Workflow Library
- Phase 8C: Space Agent Workspace Workflow Library

See `prompts/opencode/phase8a2-agent-zero-validation-orchestration-workflow.prompt.txt` for the next workflow definition.

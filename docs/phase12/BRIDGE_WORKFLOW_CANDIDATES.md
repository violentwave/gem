# Bridge Workflow Candidates

**Phase:** 12A
**Purpose:** Define candidate workflows for the supervised bridge
**Status:** Documentation-only — no execution

---

## Overview

These are candidate workflows for Phase 12B and 12C dry-runs. Each workflow is designed to be safe, bounded, and human-supervised. No workflow grants write authority or enables autonomous action.

---

## Candidate 1: Read-Only Repo Briefing Display

**Purpose:** Agent Zero reads existing repo docs and produces a structured briefing for human review.

**Trigger:** Human explicitly provides repo path and focus area.

**Allowed Inputs:**
- Repo path (e.g., `~/projects/gem`)
- Focus area (e.g., `docs/phase11/`, `prompts/`)
- Depth level (summary/detailed)

**Allowed Tools/Actions:**
- File read (existing docs only)
- Text summarization
- Markdown formatting
- Structured output generation

**Denied Tools/Actions:**
- File write/edit
- Git operations
- System commands
- Network requests
- Code execution

**Output Format:**
```markdown
# Repo Briefing: [Focus Area]

## Summary
[High-level summary]

## Key Documents
| Document | Purpose | Status |
|----------|---------|--------|
| ... | ... | ... |

## Recommendations
[For human review only — no auto-execution]
```

**Human Approval Points:**
1. Before trigger: Human approves scope
2. After output: Human reviews briefing
3. Before action: Human decides next steps

**Stop Conditions:**
- Output contains suspicious recommendations
- Agent Zero requests file write access
- Agent Zero requests system commands
- Human reviewer unavailable

---

## Candidate 2: Validation Result Summarization

**Purpose:** Agent Zero consumes existing validator outputs and produces a status dashboard.

**Trigger:** Human explicitly points to validator output files.

**Allowed Inputs:**
- Validator output files (e.g., `gemma-evals-check` output)
- Report files from `~/offload/security-reports/`
- Log files from `~/.local/state/bazzite-security/logs/`

**Allowed Tools/Actions:**
- File read
- Text parsing
- Summary generation
- Table formatting
- Status classification (PASS/WARN/FAIL)

**Denied Tools/Actions:**
- Run new validators autonomously
- Modify validator configs
- Delete logs or reports
- Write to eval stores

**Output Format:**
```markdown
# Validation Summary

| Validator | Status | Cases | Notes |
|-----------|--------|-------|-------|
| gemma-evals-check | PASS | 19/19 | ... |
| gemma-memory-quality | PASS | 19/19 | ... |

## Trends
[Week-over-week comparison if data available]

## Recommendations
[For human review only]
```

**Human Approval Points:**
1. Before trigger: Human approves which validators to summarize
2. After output: Human reviews summary
3. Before action: Human decides if re-run needed

**Stop Conditions:**
- Validator outputs are unexpectedly missing
- Summary contains incorrect classifications
- Agent Zero requests validator re-run

---

## Candidate 3: Memory/RAG Comparison Display

**Purpose:** Agent Zero displays existing Phase 11D comparison results in a structured format.

**Trigger:** Human explicitly requests comparison display.

**Allowed Inputs:**
- Existing comparison reports (e.g., `gemma-memory-search-*.md`)
- Fixture files (`tests/fixtures/memory-known-answer-queries.jsonl`)
- Index metadata

**Allowed Tools/Actions:**
- File read
- Table formatting
- Agreement classification
- Source recommendation summary

**Denied Tools/Actions:**
- Run new memory queries autonomously
- Modify RuVector state
- Modify Stage 3A index
- Ingest new docs

**Output Format:**
```markdown
# Memory/RAG Comparison Summary

| Query | Agreement | Recommended Source | Confidence |
|-------|-----------|-------------------|------------|
| ... | ... | ... | ... |

## Key Findings
- Exact agreement: [N]/[Total]
- Partial agreement: [N]/[Total]
- Divergent: [N]/[Total]
- Insufficient: [N]/[Total]

## Recommendations
[For human review only]
```

**Human Approval Points:**
1. Before trigger: Human approves which comparisons to display
2. After output: Human reviews summary
3. Before action: Human decides if follow-up needed

**Stop Conditions:**
- Comparison reports are unexpectedly missing
- Agent Zero requests new queries
- Summary contradicts known results

---

## Candidate 4: Security Report Briefing Display

**Purpose:** Agent Zero or Space Agent reads existing security reports and produces a human-readable briefing.

**Trigger:** Human explicitly requests report briefing.

**Allowed Inputs:**
- Report files from `~/offload/security-reports/`
- Daily, weekly, audit, manual subdirectories

**Allowed Tools/Actions:**
- File read
- Text summarization
- Trend identification
- Priority classification

**Denied Tools/Actions:**
- Generate new reports autonomously
- Run security scans
- Modify report files
- Delete old reports

**Output Format:**
```markdown
# Security Report Briefing

## Period: [Date Range]

| Report | Type | Status | Key Findings |
|--------|------|--------|--------------|
| ... | ... | ... | ... |

## Trends
[Week-over-week trends]

## Recommendations
[For human review only]
```

**Human Approval Points:**
1. Before trigger: Human approves date range and report types
2. After output: Human reviews briefing
3. Before action: Human decides if new scans needed

**Stop Conditions:**
- Report files are unexpectedly missing
- Agent Zero requests security scan execution
- Summary contains inaccurate findings

---

## Candidate 5: OpenCode Prompt Staging/Review

**Purpose:** Space Agent displays draft prompts for human review before manual copy to OpenCode.

**Trigger:** Human explicitly requests prompt review.

**Allowed Inputs:**
- Draft prompt text (human-provided)
- Task description (human-provided)
- Context files (read-only)

**Allowed Tools/Actions:**
- Display prompt in structured format
- Highlight potential issues (e.g., missing boundaries)
- Suggest improvements (advisory only)
- Show related docs/checklists

**Denied Tools/Actions:**
- Send prompt to OpenCode automatically
- Execute prompt automatically
- Modify prompt without human approval
- Access OpenCode API directly

**Output Format:**
```markdown
# Prompt Review: [Task Name]

## Draft Prompt
```
[draft prompt text]
```

## Checks
| Check | Status | Notes |
|-------|--------|-------|
| Boundaries stated | ✅/⚠️ | ... |
| Stop conditions included | ✅/⚠️ | ... |
| No sudo requested | ✅/⚠️ | ... |
| No secrets exposed | ✅/⚠️ | ... |

## Suggestions
[Advisory only — human decides]

## Ready for OpenCode?
[ ] Yes — human copies manually
[ ] No — human revises first
```

**Human Approval Points:**
1. Before trigger: Human provides draft prompt
2. After output: Human reviews checks and suggestions
3. Before action: Human manually copies to OpenCode if approved

**Stop Conditions:**
- Prompt contains sudo or system change requests
- Prompt lacks boundary statements
- Agent Zero attempts to send prompt automatically

---

## Candidate 6: Human Approval Packet Display

**Purpose:** Agent Zero or Space Agent presents a checklist of items awaiting human approval.

**Trigger:** Human explicitly requests approval packet.

**Allowed Inputs:**
- List of pending items (human-provided or from existing tracker)
- Criteria for approval (human-provided)

**Allowed Tools/Actions:**
- Display checklist
- Show item details
- Track approval status
- Generate approval summary

**Denied Tools/Actions:**
- Auto-approve items
- Execute approved items automatically
- Modify the underlying tracker without human action
- Access external approval systems

**Output Format:**
```markdown
# Approval Packet

| Item | Description | Status | Approved By | Date |
|------|-------------|--------|-------------|------|
| 1 | ... | Pending | — | — |
| 2 | ... | Approved | [Name] | [Date] |

## Summary
- Total items: [N]
- Approved: [N]
- Pending: [N]
- Rejected: [N]

## Next Steps
[Human decides]
```

**Human Approval Points:**
1. Before trigger: Human approves scope of packet
2. During review: Human approves/rejects each item
3. After completion: Human decides next action

**Stop Conditions:**
- Agent Zero auto-approves items
- Agent Zero executes items without human action
- Packet contains items outside approved scope

---

## Summary Table

| # | Workflow | Trigger | Output | Human Approval |
|---|----------|---------|--------|----------------|
| 1 | Repo Briefing | Explicit | Markdown briefing | 3 points |
| 2 | Validation Summary | Explicit | Status dashboard | 3 points |
| 3 | RAG Comparison | Explicit | Comparison table | 3 points |
| 4 | Security Report | Explicit | Report briefing | 3 points |
| 5 | Prompt Review | Explicit | Checked prompt | 3 points |
| 6 | Approval Packet | Explicit | Checklist | 3 points |

---

## Sign-Off

- Workflow candidates: DOCUMENTED
- No execution: CONFIRMED
- Human approval required: CONFIRMED
- Future Phase 12B/12C: Requires explicit prompt
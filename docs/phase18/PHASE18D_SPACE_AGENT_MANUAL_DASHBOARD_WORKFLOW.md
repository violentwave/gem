# Phase 18D: Space Agent Manual Dashboard Workflow

**Phase:** 18D — Space Agent Manual Dashboard Workflow
**Date:** 2026-05-02
**Parent:** Phase 18 (Space Agent Operator Dashboard Integration)
**Status:** COMPLETE

---

## Purpose

Define the manual workflow for using Space Agent as a dashboard.

---

## Workflow: Checking System Status

### Step 1: Open Space Agent

```bash
~/Applications/Space-Agent.AppImage &
```

### Step 2: Select Provider

Choose provider in Space Agent UI:
- **Local Gemma** (preferred for status checks)
  - Endpoint: `http://127.0.0.1:11434/v1/chat/completions`
  - Model: `gemma4-e4b-bazzite:latest`
  - API key: `ollama`

### Step 3: Ask for Status

**Human types:**
```
"What's the current system status?"
```

**Space Agent (via Gemma) does:**
1. Receives question
2. Uses RAG to find latest reports
3. Summarizes status
4. Returns formatted answer

**Example response:**
```markdown
## System Status (2026-05-02)

### Health
- Ollama: ✅ Running (v0.22.0)
- Gemma: ✅ Available
- Bridge: ✅ Operational

### Validation
- Evals: ✅ 25/25 PASS
- Examples: ✅ 32/32 reviewed

### Resources
- Disk: 45% used
- Logs: ⚠️ 1 file > 100MB

### Recommendations
1. Review large log file
2. No critical issues
```

### Step 4: Human Decides

Based on response, human may:
- **Do nothing** (all clear)
- **Run a script** (e.g., `gemma-monitor-daily`)
- **Review a report** (open latest Markdown report)
- **Take action** (e.g., re-index knowledge)

---

## Workflow: Generating a Report

### Step 1: Human Requests Report

**Human types:**
```
"Generate a security summary report"
```

### Step 2: Space Agent Triggers Script

**Note:** Space Agent cannot run scripts directly. Human must copy/paste command or run separately.

**Human runs:**
```bash
gemma-security-summary
```

### Step 3: Report Generated

Output saved to:
```
~/offload/security-reports/manual/security-summary-20260502-120000.md
```

### Step 4: Human Reads Report in Space Agent

**Human types:**
```
"Read the latest security report"
```

**Space Agent (via Gemma):**
1. Finds latest report
2. Summarizes contents
3. Presents key findings

---

## Workflow Decision Tree

```
[Open Space Agent]
    │
    ├── Ask: "What's the status?"
    │   ├── All clear → Done
    │   ├── Warning → Human investigates
    │   └── Critical → Human takes action
    │
    ├── Ask: "Show me reports"
    │   ├── List recent reports
    │   ├── Human selects report
    │   └── Gemma summarizes
    │
    ├── Ask: "Run a check"
    │   ├── Human runs script manually
    │   ├── Script generates report
    │   └── Gemma presents results
    │
    └── Done → Close Space Agent
```

---

## Manual-Only Confirmation

| Step | Automation | Required |
|------|-----------|----------|
| Open Space Agent | Manual | Human |
| Select provider | Manual | Human |
| Type question | Manual | Human |
| Run scripts | Manual | Human |
| Review reports | Manual | Human |
| Take action | Manual | Human |
| Close Space Agent | Manual | Human |

**No autonomous steps.**

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Workflow defined | PASS | 3 workflows |
| Decision tree | PASS | Visual tree |
| Manual-only | PASS | 7 steps, all manual |
| No autonomy | PASS | Confirmed |
| Provider config | PASS | Local Gemma preferred |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 18D: COMPLETE
- Workflows: 3 defined
- Decision tree: Documented
- All steps: Manual-only
- Next: Phase 18E (Notion Dashboard/Status Packet Integration)

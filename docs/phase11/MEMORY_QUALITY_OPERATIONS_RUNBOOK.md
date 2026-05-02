# Memory Quality Operations Runbook

**Phase:** 11A Planning
**Purpose:** Manual memory quality operations runbook
**Status:** Planning artifact only

---

## Overview

This runbook documents manual-only memory quality operations. No daemon, no timer, no automation.

---

## Manual Commands

### 1. Memory Quality Check

Run manual quality checks:

```bash
# Static validation only (no Ollama)
./scripts/check-gemma-memory-quality.sh

# Or use helper directly
python3 helpers/gemma-memory-quality-check --static-only
```

Expected output:
```
Summary: PASS=8, WARN=0, FAIL=0, SKIP=0
Overall: PASS
```

### 2. Known-Answer Validation

Validate known-answer fixtures:

```bash
./scripts/check-memory-known-answers.sh
```

Expected output:
```
JSONL_VALID: 8 cases
PASS: static validation only
```

### 3. EvaIs Status

Check eval system status:

```bash
gemma-evals-status
```

Expected output:
```
Stage 4A cases: 19
Stage 4B examples: 22 (22 reviewed)
Result: PASS
```

### 4. Examples Check

Validate examples:

```bash
gemma-examples-check
```

Expected output:
```
Total examples: 22
Total errors: 0
Result: PASS
```

---

## Report Locations

### Standard Report Paths

| Report Type | Path |
|------------|------|
| Quality check | `~/offload/security-reports/manual/gemma-memory-quality-check-*.md` |
| Known-answer | `~/offload/security-reports/manual/check-memory-known-answers-*.md` |
| EvaIs status | `~/offload/security-reports/manual/gemma-evals-status-*.md` |
| Examples check | `~/offload/security-reports/manual/gemma-examples-check-*.md` |

### Standard Log Paths

| Log Type | Path |
|---------|------|
| Quality check | `~/.local/state/bazzite-security/logs/gemma-memory-quality-check-*.log` |
| Known-answer | `~/.local/state/bazzite-security/logs/check-memory-known-answers-*.log` |
| EvaIs status | `~/.local/state/bazzite-security/logs/gemma-evals-status-*.log` |
| Examples check | `~/.local/state/bazzite-security/logs/gemma-examples-check-*.log` |

---

## Manual Triggers

### When to Run

| Trigger | Command |
|---------|---------|
| Pre-integration check | `./scripts/check-gemma-memory-quality.sh` |
| Known-answer regression | `./scripts/check-memory-known-answers.sh` |
| Eval system health | `gemma-evals-status` |
| Example validation | `gemma-examples-check` |

### Frequency

- Manual-only: run before/after significant changes
- No automatic scheduling
- No cron/timer automation

---

## Manual RAG Comparison

### Stage 3A vs Supervised RAG

Compare deterministic fallback vs supervised RAG:

```bash
# Stage 3A (deterministic)
gemma-knowledge-search "query"

# Supervised RAG
gemma-memory-rag "query" --use-ruvector

# Compare outputs manually
```

### Divergence Documentation

Document manually:
- Query used
- Stage 3A answer
- Supervised RAG answer
- Differences noted
- Acceptable variance

---

## Manual Stale-Memory Review

### When to Review

- Before ingestion cycles
- After retrieval quality reports
- Upon human trigger

### Manual Review Process

1. List recent queries
2. Check retrieval quality
3. Document stale entries
4. Flag for cleanup (manual)

---

## Error Handling

### Quality Check Failures

1. Note failure in report
2. Document expected vs actual
3. Do NOT auto-fix
4. Human review required

### Known-Answer Failures

1. Note failure
2. Check fixture syntax
3. Check helper behavior
4. Document for review

---

## Hard Boundaries

- No automatic execution
- No daemon triggers
- No timer automation
- No system modifications
- All manual

---

## Sign-Off

- Runbook: PLANNING COMPLETE
- Manual-only: CONFIRMED
- No automation: CONFIRMED
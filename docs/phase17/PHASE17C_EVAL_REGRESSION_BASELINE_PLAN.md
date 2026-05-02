# Phase 17C: Eval Regression Baseline Plan

**Phase:** 17C — Eval Regression Baseline Plan
**Date:** 2026-05-02
**Parent:** Phase 17 (Implementation Planning)
**Status:** COMPLETE

---

## Purpose

Create a detailed plan for establishing the first eval regression baseline and running the automated test suite designed in Phase 16C.

---

## Baseline Creation Plan

### Baseline Contents

The first baseline captures the current state of all eval-related metrics:

```json
{
  "baseline_version": "1.0",
  "created_at": "2026-05-02T12:00:00Z",
  "baseline_id": "baseline-20260502-120000",
  "results": {
    "eval_cases": {
      "total": 25,
      "pass": 25,
      "fail": 0,
      "categories": {
        "command_review": 10,
        "knowledge_rag": 7,
        "path_policy": 7,
        "forbidden_output": 1
      }
    },
    "examples": {
      "total": 32,
      "reviewed": 32,
      "draft": 0,
      "deprecated": 0,
      "categories": {
        "command_review_example": 11,
        "rag_answer_example": 8,
        "path_policy_example": 7,
        "bad_to_corrected_example": 6
      }
    },
    "validators": {
      "gemma-evals-check": "PASS",
      "gemma-examples-check": "PASS",
      "gemma-evals-status": "PASS",
      "gemma-examples-review-drafts": "PASS"
    },
    "known_answers": {
      "total": 19,
      "correct": 19,
      "queries": [
        {"query": "What firewall tool?", "expected": "firewalld", "actual": "firewalld"},
        {"query": "Reports path?", "expected": "~/offload/security-reports/", "actual": "~/offload/security-reports/"}
      ]
    },
    "rag_quality": {
      "test_queries": 5,
      "avg_score": 0.87,
      "min_score": 0.75,
      "max_score": 0.95
    }
  }
}
```

### Baseline Storage

**Path:** `~/.local/share/bazzite-security/gemma-evals/baselines/regression-baseline.json`
**Backup:** `~/.local/share/bazzite-security/gemma-evals/baselines/regression-baseline.json.backup`
**Retention:** Keep last 10 baselines

---

## Regression Suite Execution Plan

### Suite Components

| Suite | Command | Baseline Value | Threshold |
|-------|---------|---------------|-----------|
| 1. Static validation | `gemma-evals-check` | 25 PASS | 100% |
| 2. Example validation | `gemma-examples-check` | 32 PASS | 100% |
| 3. Status health | `gemma-evals-status` | PASS | 100% |
| 4. Coverage matrix | Category counts | 8 categories | 100% |
| 5. Known answers | Custom script | 19/19 correct | 100% |
| 6. RAG quality | Custom script | 0.87 avg | >= 0.75 |
| 7. Helper syntax | `bash -n`, `python3 -m py_compile` | 0 errors | 100% |

### Execution Script Design

```bash
#!/bin/bash
# gemma-regression-run — conceptual only, not created
# Runs full regression suite and compares against baseline

BASELINE="~/.local/share/bazzite-security/gemma-evals/baselines/regression-baseline.json"
REPORT_DIR="~/offload/security-reports/manual/"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT="${REPORT_DIR}/regression-report-${TIMESTAMP}.md"

PASS=0; WARN=0; FAIL=0

# Suite 1: Static validation
echo "[Suite 1] Static validation..."
if gemma-evals-check >/dev/null 2>&1; then
    echo "  ✅ PASS"
    ((PASS++))
else
    echo "  ❌ FAIL"
    ((FAIL++))
fi

# Suite 2: Example validation
echo "[Suite 2] Example validation..."
if gemma-examples-check >/dev/null 2>&1; then
    echo "  ✅ PASS"
    ((PASS++))
else
    echo "  ❌ FAIL"
    ((FAIL++))
fi

# ... (additional suites)

# Compare against baseline
# Load baseline values
# Calculate drift
# Generate report

echo ""
echo "[Summary]"
echo "Pass: $PASS | Warn: $WARN | Fail: $FAIL"
```

---

## Drift Detection Execution

### Rules to Apply

| Rule | Baseline | Current | Action |
|------|----------|---------|--------|
| Eval fail | 0 fails | > 0 fails | CRITICAL alert |
| Draft examples | 0 drafts | > 0 drafts | HIGH alert |
| Missing category | 8 categories | < 8 | HIGH alert |
| Known answer wrong | 19 correct | < 19 | CRITICAL alert |
| RAG degradation | 0.87 avg | < 0.75 | MEDIUM alert |
| Case decrease | 25 total | < 25 | MEDIUM alert |
| Example decrease | 32 total | < 32 | LOW alert |

### Report Generation

```markdown
# Regression Report

**Date:** 2026-05-02
**Baseline:** baseline-20260502-120000

## Results

| Suite | Result | Baseline | Drift |
|-------|--------|----------|-------|
| Static validation | PASS | 25/25 | None |
| Example validation | PASS | 32/32 | None |
| ... | ... | ... | ... |

## Drift Detection

✅ No drift detected

## Recommendations

None
```

---

## Implementation Steps

### Step 1: Create Baseline Directory
```bash
mkdir -p ~/.local/share/bazzite-security/gemma-evals/baselines
```

### Step 2: Generate First Baseline
```bash
# Run all validators
gemma-evals-check
gemma-examples-check
gemma-evals-status

# Collect results into JSON baseline
# (manual or scripted)
```

### Step 3: Store Baseline
```bash
cp regression-baseline.json ~/.local/share/.../baselines/
```

### Step 4: Create Regression Script
```bash
# Write gemma-regression-run (pseudocode above)
# Make executable
chmod +x ~/.local/bin/gemma-regression-run
```

### Step 5: Validate
```bash
bash -n ~/.local/bin/gemma-regression-run
gemma-regression-run --dry-run
```

### Step 6: Run First Regression
```bash
gemma-regression-run
# Verify report generated
# Verify baseline comparison works
```

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Baseline format defined | PASS | JSON structure |
| Storage path defined | PASS | ~/.local/share/... |
| 7 test suites defined | PASS | All mapped to commands |
| Regression script designed | PASS | Pseudocode |
| Drift rules defined | PASS | 7 rules |
| Report format defined | PASS | Markdown |
| Implementation steps | PASS | 6 steps |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 17C: COMPLETE
- Baseline format: DEFINED
- Regression suites: 7 planned
- Drift detection: 7 rules
- Next: Phase 17D (Security Hardening Plan)

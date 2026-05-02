# Phase 16C: Eval Automation

**Phase:** 16C — Eval Automation
**Date:** 2026-05-02
**Parent:** Phase 16 (Automated Monitoring / Knowledge Expansion)
**Status:** COMPLETE

---

## Purpose

Design an automated regression testing framework that runs evals, detects drift, and reports quality trends over time.

---

## Current Eval System

| Component | Type | Count | Status |
|-----------|------|-------|--------|
| Eval cases | Regression test | 25 | PASS |
| Supervised examples | Training data | 32 | PASS |
| Validators | Static check | 4 | PASS |
| Coverage | Categories | 8/8 | PASS |

**Current Process:** Manual — run `gemma-evals-check`, `gemma-examples-check`, `gemma-evals-status` on demand.

---

## Automated Regression Framework Design

### Architecture

```
[Trigger] → [Run Suite] → [Compare Baseline] → [Detect Drift] → [Report]
                ↑                |
                └──── [Update Baseline] ←── Human approval
```

### Regression Suite

| Test Suite | Tests | Baseline | Threshold |
|------------|-------|----------|-----------|
| Static validation | gemma-evals-check | All PASS | 100% |
| Example validation | gemma-examples-check | All PASS | 100% |
| Status health | gemma-evals-status | PASS | 100% |
| Coverage matrix | Category counts | 8 categories | 100% |
| Known answers | 19 known-answer cases | All correct | 100% |
| RAG quality | 5 benchmark queries | Consistent | ±10% |
| Helper syntax | bash -n, python -m py_compile | No errors | 100% |

### Baseline Management

**Baseline File:** `~/.local/share/bazzite-security/gemma-evals/baselines/regression-baseline.json`

```json
{
  "created_at": "2026-05-02T12:00:00Z",
  "version": "1.0",
  "results": {
    "eval_cases": {"total": 25, "pass": 25, "fail": 0},
    "examples": {"total": 32, "reviewed": 32, "draft": 0},
    "categories": ["command_review", "knowledge_rag", "path_policy", "forbidden_output"],
    "known_answers": {"total": 19, "correct": 19},
    "rag_quality": {"avg_score": 0.85, "min_score": 0.70}
  }
}
```

### Drift Detection Rules

| Drift Type | Rule | Severity |
|------------|------|----------|
| Eval fail | Any case FAIL | CRITICAL |
| Example unreviewed | draft > 0 | HIGH |
| Coverage gap | category missing | HIGH |
| Known answer wrong | correct < 19 | CRITICAL |
| RAG degradation | avg_score < 0.75 | MEDIUM |
| Case count decrease | total < baseline | MEDIUM |
| Example count decrease | total < baseline | LOW |

### Report Format

```
=== Regression Report ===
Date: 2026-05-02 12:00:00
Baseline: 2026-05-01 12:00:00

[Static Validation]
✅ Eval cases: 25/25 PASS
✅ Examples: 32/32 PASS
✅ Status: PASS

[Coverage]
✅ Categories: 8/8 covered
✅ Known answers: 19/19 correct

[RAG Quality]
✅ Average score: 0.87 (baseline: 0.85, +2%)

[Drift Detection]
✅ No drift detected

[Trend]
Cases: 25 → 25 (stable)
Examples: 32 → 32 (stable)
RAG quality: 0.85 → 0.87 (+2%)

[Summary]
Pass: 6/6 | Warn: 0 | Fail: 0
Duration: 12.5s
```

---

## Trend Analysis

### Historical Tracking

Store last N results for trend analysis:

| Metric | Window | Use |
|--------|--------|-----|
| Eval pass rate | Last 10 runs | Stability |
| RAG quality score | Last 10 runs | Improvement/degradation |
| Case count | Last 10 runs | Growth |
| Example count | Last 10 runs | Growth |
| Execution time | Last 10 runs | Performance |

### Trend Alerts

| Condition | Alert | Action |
|-----------|-------|--------|
| Pass rate < 100% for 2+ runs | CRITICAL | Investigate immediately |
| RAG score drops > 10% | HIGH | Check knowledge pack |
| Execution time > 2x baseline | MEDIUM | Check system load |
| Case count decreases | HIGH | Review deletions |

---

## Implementation Status

**This phase is DESIGN-ONLY.** No automation scripts are created.

The framework is ready for implementation when:
- Human explicitly approves
- Regression testing becomes critical
- Phase 16A monitoring scripts are implemented

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Framework designed | PASS | 7 test suites |
| Baseline management defined | PASS | JSON baseline format |
| Drift detection defined | PASS | 7 rules |
| Report format defined | PASS | Structured output |
| Trend analysis defined | PASS | 5 metrics, windows |
| No scripts created | PASS | Design-only |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 16C: COMPLETE
- Regression framework: DESIGNED
- Test suites: 7 defined
- Drift rules: 7 defined
- Next: Phase 16D (Security Audit)

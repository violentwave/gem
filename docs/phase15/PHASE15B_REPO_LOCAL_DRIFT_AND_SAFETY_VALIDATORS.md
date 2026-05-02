# Phase 15B: Repo-Local Drift and Safety Validators

**Phase:** 15B — Repo-Local Drift and Safety Validators
**Date:** 2026-05-02
**Parent:** Phase 15 (Production Hardening)
**Status:** COMPLETE

---

## Purpose

Document the current validator suite, define drift detection criteria, and establish safety validator frameworks for repo-local consistency.

---

## Current Validator Suite

| # | Validator | Type | Checks | Frequency |
|---|-----------|------|--------|-----------|
| 1 | gemma-evals-check | Static | Eval cases JSON validity, required fields, category coverage | On demand |
| 2 | gemma-evals-status | Static | Eval/example health, coverage matrix, documentation drift | On demand |
| 3 | gemma-examples-check | Static | Supervised examples JSON validity, review status, category coverage | On demand |
| 4 | gemma-examples-review-drafts | Static | Draft examples review recommendations | On demand |
| 5 | gemma-knowledge-check | Static | Knowledge pack doc validity, index freshness | On demand |
| 6 | gemma-opencode-check | Integration | OpenCode bridge connectivity | On demand |
| 7 | gemma-bazzite-health | Integration | Ollama/Gemma health, model availability | On demand |

**Total:** 7 validators
**Static:** 4
**Integration:** 3

---

## Drift Detection Criteria

### Documentation Drift

| Drift Type | Detection Method | Threshold | Action |
|------------|-----------------|-----------|--------|
| Eval case count mismatch | gemma-evals-status vs live files | >0 difference | WARN |
| Example count mismatch | gemma-evals-status vs live files | >0 difference | WARN |
| CURRENT_STATE.md stale | Date check vs last update | >7 days | WARN |
| ROADMAP.md stale | Date check vs last phase | >7 days | WARN |
| Missing helper in inventory | Manifest vs ~/.local/bin/ | >0 difference | WARN |

### Configuration Drift

| Drift Type | Detection Method | Threshold | Action |
|------------|-----------------|-----------|--------|
| Modelfile modified | Checksum vs manifest | mismatch | WARN |
| Ollama config changed | File timestamp vs baseline | newer | INFO |
| Bridge config changed | File timestamp vs baseline | newer | INFO |
| New files in ~/.local/bin/ | ls vs manifest | new files | INFO |

### Semantic Drift

| Drift Type | Detection Method | Threshold | Action |
|------------|-----------------|-----------|--------|
| Knowledge pack outdated | Index timestamp vs docs | >7 days | WARN |
| RuVector index outdated | Manifest timestamp vs docs | >7 days | WARN |
| Eval coverage gap | Category count vs target | <80% | WARN |

---

## Safety Validator Framework

### Validator Design Principles

1. **Read-only by default** — Validators must not modify system state
2. **Idempotent** — Running twice produces same result
3. **Deterministic** — Same inputs always produce same outputs
4. **Bounded** — Time limits, no infinite loops
5. **Informative** — Clear PASS/WARN/FAIL with context

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | PASS — all checks passed |
| 1 | WARN — non-critical issues found |
| 2 | FAIL — critical issues found |
| 3 | ERROR — validator internal error |
| 130 | INTERRUPTED — Ctrl+C |

### Output Format

```
[VALIDATOR_NAME] [TIMESTAMP]
[STATUS] PASS/WARN/FAIL

[CHECKS]
✅ Check 1: Description — PASS
⚠️  Check 2: Description — WARN (context)
❌ Check 3: Description — FAIL (context)

[SUMMARY]
Total: N checks
Pass: N | Warn: N | Fail: N

[RECOMMENDATIONS]
1. Action item 1
2. Action item 2
```

---

## Proposed New Validators

| Validator | Purpose | Priority |
|-----------|---------|----------|
| gemma-manifest-check | Verify manifest completeness and checksums | High |
| gemma-drift-check | Detect documentation/config/semantic drift | Medium |
| gemma-security-boundary-check | Verify no secrets in repo, no unauthorized changes | High |
| gemma-helper-version-check | Verify all helpers have version headers | Low |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Validator suite documented | PASS | 7 validators |
| Drift criteria defined | PASS | 3 categories, 10 drift types |
| Safety framework defined | PASS | 5 principles, exit codes, output format |
| New validators proposed | PASS | 4 proposed |
| All validators read-only | PASS | Confirmed |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 15B: COMPLETE
- Validators documented: 7 existing
- Drift criteria: 10 types across 3 categories
- Safety framework: DEFINED
- Next: Phase 15C (Release Process and Rollback Bundle Policy)

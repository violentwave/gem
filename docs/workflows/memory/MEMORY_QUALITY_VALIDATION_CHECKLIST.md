# Memory Quality Validation Checklist

**Phase:** 8B.3
**Status:** Concise checklist for supervised memory quality validation
**Production status:** RuVector remains prototype-only

---

## Purpose#

This checklist is a quick-reference for a future supervised quality validation using the Workflow 8B.3 process. It ensures all 8 quality gates are validated, failures are properly classified, and no production promotion occurs in this phase.

---

## Pre-Validation Checklist#

### Scope and Gates
- [ ] Scope confirmed (all 8 gates, or specific gate N)
- [ ] RuVector semantic prototype identified: `semantic-prototype/` (398 chunks)
- [ ] Stage 3A fallback confirmed: `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
- [ ] Stage 4 validators confirmed: gemma-evals-status, gemma-evals-check, gemma-examples-check
- [ ] Output format confirmed: `memory-quality-validation-output-template.md`

### Environment Check
- [ ] Stage 3A JSONL index is available and readable
- [ ] Stage 4 eval/examples are accessible
- [ ] RuVector prototype manifests are readable (semantic-manifest-*.json)
- [ ] No environment issues that would cause "unavailable" classification

---

## Gate 1: Stage 3A Comparison Checklist (REVISED)

**See:** `GATE1_SOURCE_EQUIVALENCE_METRIC.md` for specification

### Validation - Exact Overlap Check
- [ ] 10+ known queries prepared (from Stage 4 evals/examples)
- [ ] Same queries run through RuVector (if available)
- [ ] Same queries run through Stage 3A
- [ ] Exact filename overlap % calculated: `(common_filenames / total_unique_filenames) * 100`
- [ ] Agreement classified: strong (≥70%) / partial (40-69%) / weak (10-39%) / contradiction / insufficient

### Validation - Source Family Equivalence (NEW)
- [ ] Each top source classified by family: Policy / Operational / Advisory / Stage 3A
- [ ] FINAL_POLICY.md recognized as Policy family (authority for policy queries)
- [ ] OPERATIONS.md, PATHS.md, RUNBOOK.md recognized as Operational family
- [ ] OPENCODE_GEMMA_NOTES.md, GEMMA_LOCAL_AGENT.md recognized as Advisory family
- [ ] chunks.jsonl entries recognized as Stage 3A family
- [ ] Source authority determined for each query (which system returned more authoritative source)
- [ ] Equivalence score calculated: `(equivalent_pairs / total_pairs) * 100`
- [ ] Classification labels assigned: exact_match / family_equivalent / content_equivalent / semantic_more_authoritative / stage3a_more_authoritative / true_disagreement / insufficient_evidence

### Validation - Content Relevance (NEW)
- [ ] RuVector content checked for factual correctness
- [ ] Stage 3A content checked for factual correctness
- [ ] No factual contradictions found (or contradictions documented with explanation)
- [ ] FINAL_POLICY.md dominance explained (if policy query, this is correct)
- [ ] Weak filename overlap explained before flagging as warning

### Pass/Fail (REVISED)
- [ ] **PASS:** ≥70% exact overlap, OR ≥70% equivalence + no contradictions, OR semantic/stage3a more authoritative explained
- [ ] **WARN:** 50-69% equivalence, low filename overlap but sources relevant, source family mismatch explained
- [ ] **FAIL (blocker):** Factual contradiction OR denied source appears OR both irrelevant OR <50% equivalence without explanation

### Evidence (REVISED)
- [ ] Comparison table completed (query, RuVector source, Stage 3A source, overlap %, equivalence %, classification)
- [ ] Source family classification recorded for each query
- [ ] Source authority (semantic_more_authoritative / stage3a_more_authoritative) noted
- [ ] Disagreements listed with family-equivalence explanations
- [ ] FINAL_POLICY.md dominance explained (not a bug — correct for policy queries)
- [ ] Reference to GATE1_SOURCE_EQUIVALENCE_METRIC.md included

---

## Gate 2: Stage 4 Validators Checklist#

### Validation
- [ ] `gemma-evals-status` run — result: [PASS/FAIL]
- [ ] `gemma-evals-check` run — result: [PASS/FAIL]
- [ ] `gemma-examples-check` run — result: [PASS/FAIL]
- [ ] Stage 4A cases: 19 (confirmed)
- [ ] Stage 4B examples: 22 (22 reviewed, 0 draft)
- [ ] All minimums met
- [ ] No drift detected

### Pass/Fail
- [ ] **PASS:** All 3 validators return PASS
- [ ] **FAIL (blocker):** Any validator returns FAIL
- [ ] **FAIL action:** Block promotion, investigate failures, fix before continuing

### Evidence
- [ ] Validator output captured (PASS/FAIL, case counts, error counts)
- [ ] Report path noted: `~/offload/security-reports/manual/gemma-evals-status-*.md`

---

## Gate 3: Semantic Retrieval Quality Checklist#

### Validation
- [ ] 10+ known eval questions prepared
- [ ] Queries run through RuVector semantic prototype
- [ ] Same queries run through Stage 3A for comparison
- [ ] Relevance scores checked for top 5 results
- [ ] Manual spot-check performed on top results
- [ ] Complex queries identified where semantic should excel

### Pass/Fail
- [ ] **PASS:** Relevant sources in top 5, no hallucinations, precision ≥ Stage 3A
- [ ] **FAIL (blocker):** Precision worse than Stage 3A
- [ ] **FAIL action:** Block promotion, document query failures, identify gaps

### Evidence
- [ ] Query results table (query, top 5 sources, relevance scores, RuVector vs Stage 3A)
- [ ] Spot-check notes (which results relevant, which off-topic)

---

## Gate 4: Source Relevance Spot-Check Checklist#

### Validation
- [ ] 10 representative queries prepared across topics
- [ ] Queries run through both systems
- [ ] Top 3 retrieved sources manually verified for relevance
- [ ] Off-topic results checked in top 3
- [ ] Which system returned more relevant sources noted

### Pass/Fail
- [ ] **PASS:** ≥8/10 queries return relevant sources in top 3, no completely off-topic in top 3
- [ ] **FAIL (blocker):** >3/10 queries fail
- [ ] **FAIL action:** Block promotion, identify problematic query types

### Evidence
- [ ] Spot-check table (query, top 3 sources, relevance rating, which system better)
- [ ] Problematic query types identified (if any)

---

## Gate 5: Answer Generation Quality Checklist#

### Validation
- [ ] Gemma synthesis queries prepared (if using Gemma + memory)
- [ ] Gemma + RuVector answers generated
- [ ] Gemma + Stage 3A answers generated for same queries
- [ ] Answer quality compared (no degradation)
- [ ] Hallucinations checked in RuVector-sourced answers
- [ ] Source attribution verified as accurate

### Pass/Fail
- [ ] **PASS:** Answer quality equal or better, no added hallucinations, attribution accurate
- [ ] **FAIL (blocker):** Degradation detected
- [ ] **FAIL action:** Prefer Stage 3A, document quality issues

### Evidence
- [ ] Answer comparison table (query, Gemma+RuVector answer, Gemma+Stage 3A answer, quality rating)
- [ ] Hallucination check notes
- [ ] Attribution verification notes

---

## Gate 6: Manifest Metadata Checklist#

### Validation
- [ ] Manifest exists for each index: `semantic-manifest-*.json`
- [ ] `input_source` field populated and correct
- [ ] `chunk_count` field matches actual (398 total: 348 + 50)
- [ ] `embedding_model` field = `nomic-embed-text:latest`
- [ ] `embedding_dimensions` field = `768`
- [ ] `timestamp` field present (ISO format)
- [ ] `excluded_paths` field populated (`~/.cache`, `~/.config`)
- [ ] `fallback_status` field = `Stage 3A available`
- [ ] `rollback_path` field populated
- [ ] Manifest is parseable JSON

### Pass/Fail
- [ ] **PASS:** All required fields present, parseable, values consistent
- [ ] **FAIL (blocker):** Missing fields or unparseable
- [ ] **FAIL action:** Block use of indexes without manifest, require manifest creation

### Evidence
- [ ] Manifest validation table (manifest file, fields present, parseable, consistent)

---

## Gate 7: Rollback/Reset Path Checklist#

### Validation
- [ ] Rollback plan exists for current index
- [ ] Previous index state documented (e.g., 348 chunks, manifest-1777588808185.json)
- [ ] Rollback steps are testable (human can execute without AI)
- [ ] Stage 3A fallback confirmed working after rollback
- [ ] Verification method documented (run query, confirm)

### Pass/Fail
- [ ] **PASS:** Rollback plan exists, testable, human-executable
- [ ] **FAIL (blocker):** No rollback plan
- [ ] **FAIL action:** Block any memory changes without rollback plan

### Evidence
- [ ] Rollback plan document (previous state, steps, verification, fallback)
- [ ] Stage 3A fallback confirmation

---

## Gate 8: Stale Memory Review Checklist#

### Validation
- [ ] Review process documented
- [ ] Last review date recorded
- [ ] Index age checked (<3 months for production consideration)
- [ ] Source availability verified (all indexed sources still accessible)
- [ ] Relevance validation performed
- [ ] No stale entries found (or marked appropriately)

### Pass/Fail
- [ ] **PASS:** Review documented, last date recorded, no stale entries
- [ ] **FAIL (blocker):** No stale memory review process
- [ ] **FAIL action:** Block learning loops until review exists

### Evidence
- [ ] Stale memory review document (last review date, index age, relevance check)
- [ ] Stale entries identified (if any, marked)

---

## Failure Handling Checklist#

### Classification
For each gate failure, classify:
- [ ] **Blocking failure:** [gate name] — workflow stops, escalation to human
- [ ] **Warning:** [gate name] — continue, flag in report
- [ ] **Environment unavailable:** [component] — stop, fix environment
- [ ] **Skipped by boundary:** [gate name] — document, continue
- [ ] **Skipped by user instruction:** [gate name] — document with approval, continue

### Per-Category Actions
- [ ] Blocking failures: workflow stopped, human escalated, promotion blocked
- [ ] Warnings: flagged in report, human review requested, promotion noted
- [ ] Environment issues: stopped, environment fixed, retried
- [ ] Boundary skips: documented as "Phase 8B.3 documentation-only"
- [ ] User skips: documented with human approval, noted in report

---

## Production Promotion Checklist#

**Phase 8B.3 does NOT promote RuVector.** Confirm:
- [ ] Passing 8B.3 does NOT promote RuVector
- [ ] Production promotion requires separate future gate
- [ ] Stage 3A remains fallback even after future promotion (unless explicitly changed)
- [ ] Human approval required for every promotion decision
- [ ] No autonomous promotion is ever allowed
- [ ] All 8 gates must pass before promotion can even be proposed

---

## Final Decision Checklist#

### Decision Options
- [ ] **PASS_ALL_GATES** — All 8 gates pass, ready for future promotion consideration
- [ ] **FAIL_BLOCKING_GATE** — Blocker found, promotion blocked, human escalated
- [ ] **PASS_WITH_WARNINGS_NO_PROMOTION** — Gates pass with warnings, no promotion in 8B.3
- [ ] **INCOMPLETE_MORE_INFO_REQUIRED** — Cannot complete, need more information

### Decision Recorded
- [ ] Decision: [PASS_ALL_GATES / FAIL_BLOCKING_GATE / PASS_WITH_WARNINGS / INCOMPLETE]
- [ ] Decision date: [ISO date]
- [ ] Decision notes: [notes]
- [ ] Human reviewer: [name]

---

## Validation Checklist#

### Standard Validators (Must All Pass)
```bash
gemma-evals-status    # Must be PASS
gemma-evals-check     # Must be PASS
gemma-examples-check  # Must be PASS
```

### Boundary Verification
- [ ] No RuVector quality tests run in Phase 8B.3 (documentation-only)
- [ ] No production memory promotion occurred
- [ ] No memory ingestion performed
- [ ] No autonomous actions taken
- [ ] No system/package/model config changes
- [ ] No broad filesystem access granted

---

## Quick Reference: Gate Failure Categories#

| Category | Workflow Stops? | Promotion Blocked? | Human Required? |
|----------|-------------------|---------------------|-------------------|
| **Blocking failure** | YES | YES | YES |
| **Warning** | NO | NO (noted) | YES (review) |
| **Environment unavailable** | YES | YES | YES (fix) |
| **Skipped by boundary** | NO | NO | NO |
| **Skipped by user** | NO | Depends | YES (approved) |

---

## Related Documents#

- `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` — Full workflow definition
- `MEMORY_WORKFLOW_LIBRARY.md` — Workflow categories
- `MEMORY_QUALITY_GATES.md` — 8 quality gates (detailed definitions)
- `MEMORY_QUALITY_VALIDATION_CHECKLIST.md` — This checklist
- `docs/workflows/templates/memory-quality-validation-output-template.md` — Output template
- `docs/roadmap/ROADMAP.md` — Phase 8B.3 status

---

*Checklist version: 1.0*
*Phase: 8B.3*
*Status: Documentation-only — no RuVector quality tests or production promotion in this phase*
*RuVector status: Prototype-only, 398 chunks (348 approved-doc + 50 Stage 3A), nomic-embed-text:latest, 768 dims*

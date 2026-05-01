# Memory Quality Gates

**Phase:** 8B
**Status:** Documentation-only quality requirements
**Production status:** Defines requirements before production memory promotion

---

## Overview

This document defines quality gates that must pass before RuVector can be promoted from prototype to production memory. These gates ensure semantic retrieval quality, Stage 3A fallback preservation, and proper manifest documentation.

---

## Quality Gate Framework

### Gate Philosophy

> **Source overlap alone is not enough.** Semantic retrieval must demonstrate value beyond what Stage 3A already provides. Every quality gate requires comparison with Stage 3A and validation against known queries.

---

## Gate 1: Stage 3A Comparison Required (REVISED)

### Requirement
Every semantic query must be compared against Stage 3A deterministic retrieval using a tiered metric that considers source-family equivalence, content relevance, and source authority.

**See:** `GATE1_SOURCE_EQUIVALENCE_METRIC.md` for full specification.

### Validation Method
1. Run same query through RuVector semantic prototype
2. Run same query through Stage 3A JSONL
3. Classify each top source by source family (policy/operational/advisory/stage3a)
4. Calculate equivalence score: `(equivalent_pairs / total_pairs) * 100`
5. Determine source authority (which system returned more authoritative source)
6. Document agreement/disagreement with classification

### Source Families
- **Policy:** FINAL_POLICY.md (highest authority for "what should happen" queries)
- **Operational:** OPERATIONS.md, PATHS.md, RUNBOOK.md (highest for "how to do X" queries)
- **Advisory:** OPENCODE_GEMMA_NOTES.md, GEMMA_LOCAL_AGENT.md (when describing boundaries)
- **Stage 3A:** chunks.jsonl entries (derived from approved docs)

### Classification Labels
- `exact_match` — Identical filename in both results
- `family_equivalent` — Same source family (policy ↔ operational both valid)
- `content_equivalent` — Different families but same factual content
- `semantic_more_authoritative` — RuVector source is policy/authoritative for query type
- `stage3a_more_authoritative` — Stage 3A source is operational/better fit
- `true_disagreement` — Factual contradiction
- `insufficient_evidence` — Cannot determine

### Pass Criteria (ANY of):
- [ ] Exact filename overlap ≥70%
- [ ] Equivalence score ≥70% AND no factual contradictions
- [ ] RuVector is semantically more authoritative (policy source for policy query)
- [ ] Stage 3A is more authoritative for operational queries

### Warn Conditions (ANY of):
- [ ] Equivalence score 50-69%
- [ ] Low filename overlap but sources are relevant and non-contradictory
- [ ] Semantic source differs from Stage 3A but both are valid
- [ ] Source family mismatch explained by query type

### Fail Actions (BLOCK if ANY):
- [ ] Factual contradiction exists between systems
- [ ] Denied source appears in results
- [ ] Both systems return irrelevant sources
- [ ] Equivalence score <50% without source authority explanation

### Key Change from Original
**Filename overlap alone is insufficient.** Content relevance and source authority matter. FINAL_POLICY.md dominance is NOT a bug — it may be returning the correct canonical source for policy-type queries.

### Related Specification
See `GATE1_SOURCE_EQUIVALENCE_METRIC.md` for detailed formula, examples, and limitations.

---

## Gate 2: Stage 4 Cases/Examples Must Pass

### Requirement
Stage 4 eval system must remain fully passing.

### Validation Method
```bash
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

### Pass Criteria
- gemma-evals-status: PASS
- gemma-evals-check: PASS
- gemma-examples-check: PASS

### Fail Actions
- Block any production promotion
- Investigate eval failures
- Fix before continuing

---

## Gate 3: Semantic Retrieval Quality Evaluation

### Requirement
Semantic retrieval must be evaluated against known questions from Stage 4.

### Validation Method
1. Query RuVector with 10+ known eval questions
2. Compare semantic results to deterministic results
3. Check relevance scores
4. Manual spot-check top results

### Pass Criteria
- Relevant sources in top 5 results
- No hallucinations in retrieved context
- Better precision than Stage 3A on complex queries

### Fail Actions
- If precision worse than Stage 3A, block promotion
- Document query failures
- Identify gaps

---

## Gate 4: Source Relevance Spot-Check

### Requirement
Retrieved source relevance must be manually spot-checked.

### Validation Method
1. Run 10 representative queries
2. Manually verify top retrieved sources are relevant
3. Check for off-topic results in top 3

### Pass Criteria
- At least 8/10 queries return relevant sources in top 3
- No completely off-topic results in top 3

### Fail Actions
- If > 3/10 queries fail, block promotion
- Identify problematic query types

---

## Gate 5: Answer Generation Quality

### Requirement
No answer generation should rely solely on RuVector until quality is proven.

### Validation Method
1. If using Gemma synthesis from memory:
2. Compare Gemma + RuVector vs Gemma + Stage 3A
3. Verify no degradation in answer quality

### Pass Criteria
- Answers using RuVector context are equal or better quality
- No additional hallucinations from semantic retrieval
- Source attribution remains accurate

### Fail Actions
- If degradation detected, prefer Stage 3A
- Document quality issues

---

## Gate 6: Manifest Metadata Required

### Requirement
Every memory index must have manifest metadata.

### Required Manifest Fields

| Field | Description | Example |
|-------|-------------|---------|
| input_source | Path to indexed source | ~/.local/share/bazzite-security/gemma-knowledge/docs/ |
| chunk_count | Number of chunks indexed | 398 |
| embedding_model | Model used | nomic-embed-text:latest |
| embedding_dimensions | Vector dimensions | 768 |
| timestamp | Index time | 2026-04-30T22:40:26Z |
| excluded_paths | Paths not indexed | [~/.cache, ~/.config] |
| fallback_status | Fallback availability | Stage 3A available |

### Pass Criteria
- Manifest exists for each index
- All required fields populated
- Manifest is parseable

### Fail Actions
- Block use of indexes without manifest
- Require manifest creation

---

## Gate 7: Rollback/Reset Path Documented

### Requirement
Every memory change must have documented rollback.

### Required Rollback Information

| Item | Description |
|------|-------------|
| Previous index | What was the previous state? |
| Rollback command | How to restore? |
| Fallback method | How to use Stage 3A instead? |
| Verification | How to verify rollback success? |

### Pass Criteria
- Rollback plan exists before any change
- Plan is testable
- Human can execute without AI

### Fail Actions
- Block any memory changes without rollback plan

---

## Gate 8: Stale Memory Review

### Requirement
Stale memory review must exist before any long-term learning loop.

### Review Criteria

| Check | Frequency |
|-------|-----------|
| Index age | Monthly |
| Source availability | Monthly |
| Relevance validation | Monthly |
| Overlap detection | Quarterly |

### Pass Criteria
- Review process documented
- Last review date recorded
- No stale entries found (or marked)

### Fail Actions
- Block learning loops until review exists
- Document current memory age

---

## Quality Gate Summary Table (Revised)

| Gate | Name | Pass Criteria | Blocker |
|------|------|---------------|---------|
| 1 | Stage 3A Comparison (Rev) | ≥70% overlap OR ≥70% equivalence + no contradictions | Factually wrong OR <50% equivalence without explanation |
| 2 | Stage 4 Validators | All PASS | Any FAIL |
| 3 | Semantic Quality | Precision ≥ Stage 3A | Worse than Stage 3A |
| 4 | Source Spot-Check | 8/10 relevant | >3/10 fail |
| 5 | Answer Quality | No degradation | Degradation detected |
| 6 | Manifest Metadata | All fields present | Missing fields |
| 7 | Rollback Path | Plan exists | No plan |
| 8 | Stale Memory Review | Review documented | No review |

---

## Production Promotion Checklist

Before promoting RuVector from prototype to production:

- [ ] Gate 1: Stage 3A comparison passing
- [ ] Gate 2: Stage 4 validators passing
- [ ] Gate 3: Semantic quality evaluated
- [ ] Gate 4: Source spot-check passing
- [ ] Gate 5: Answer quality validated
- [ ] Gate 6: All indexes have manifests
- [ ] Gate 7: Rollback plans documented
- [ ] Gate 8: Stale memory review exists

**Note:** Until all gates pass, RuVector remains prototype-only. Stage 3A is the canonical fallback.

---

## Validation Commands

```bash
# Verify quality gates doc exists
test -f docs/workflows/memory/MEMORY_QUALITY_GATES.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Related Documents

- `MEMORY_WORKFLOW_LIBRARY.md` - Workflow definitions
- `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` - Detailed 8B.3 workflow with all gate validation methods, failure handling, and promotion checklist
- `MEMORY_BOUNDARIES.md` - Boundaries overview
- `MEMORY_SOURCE_POLICY.md` - Source classification

---

*Quality gates version: 1.0*
*Phase: 8B*
*Status: Documentation-only*

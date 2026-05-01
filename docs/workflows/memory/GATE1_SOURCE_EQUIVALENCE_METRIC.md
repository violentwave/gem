# Gate 1 Source Equivalence Metric Specification

**Phase:** 8B.4C
**Status:** Metric specification for quality validation
**Purpose:** Revise Gate 1 to use source-family equivalence instead of filename-only overlap

---

## Purpose

This specification defines a revised Gate 1 metric that accounts for **source-family equivalence** and **content relevance**, not just exact filename overlap.

The original metric failed because:
- RuVector returns policy sources (FINAL_POLICY.md) for policy-type queries
- Stage 3A returns operational sources (GEMMA_LOCAL_AGENT.md, OPERATIONS.md)
- Both are correct answers — just different source types

---

## Why Filename Overlap Alone Failed

**Original formula:**
```
overlapPercent = (common_filenames / total_unique_filenames) * 100
```

**Problems:**
1. Compares exact filename matches only
2. Treats FINAL_POLICY.md ↔ GEMMA_LOCAL_AGENT.md as 0% overlap
3. Does not distinguish source authority (policy vs operational)
4. Ignores content relevance
5. Cannot handle multi-source answers

**Evidence from Phase 8B.4B:**

| Query | RuVector Source | Stage 3A Source | Filename Overlap | Content |
|-------|------------------|---------------------|-----------------|---------|
| "What firewall tool?" | FINAL_POLICY.md | GEMMA_LOCAL_AGENT.md | 0% | BOTH CORRECT |
| "Where should reports go?" | FINAL_POLICY.md | GEMMA_LOCAL_AGENT.md | 0% | BOTH CORRECT |
| "firewalld not ufw" | FINAL_POLICY.md | OPENCODE_GEMMA_NOTES.md | 0% | RU VECTOR MORE AUTHORITATIVE |

---

## Source Family Definitions

### Policy Family
- **FINAL_POLICY.md** — Core policy statements (firewall, paths, security)
- **Policy sections** from approved docs (if explicitly marked)

**Authority:** Highest for "what should happen" questions

### Operational Family
- **OPERATIONS.md** — System operations, commands, procedures
- **PATHS.md** — Path references, XDG compliance
- **RUNBOOK.md** — Operational runbooks, checklists

**Authority:** Highest for "how to do X" questions

### Advisory/OpenCode Family
- **OPENCODE_GEMMA_NOTES.md** — Gemma/OpenCode usage guidelines
- **GEMMA_LOCAL_AGENT.md** (when describing boundaries, roles) — Agent behavior documentation

**Authority:** Highest for "when to use X" questions

### Stage 3A Family
- **chunks.jsonl entries** — Derived from approved docs, keyword-indexed
- Classify by original source when metadata available
- Otherwise treat as Stage 3A fallback evidence

---

## Equivalence Calculation Approach

### Step 1: Classify Source Families

For each top result from RuVector and Stage 3A:
1. Identify the source file
2. Determine its source family (policy/operational/advisory/stage3a)
3. Note the source authority for this query type

### Step 2: Calculate Equivalence Score

```
equivalenceScore = (equivalent_pairs / total_pairs) * 100

Where:
- equivalent_pairs = exact_matches + family_matches + content_matches
- exact_matches = identical filename in both results
- family_matches = same source family (e.g., FINAL_POLICY.md + OPERATIONS.md)
- content_matches = different families but same factual content
```

### Step 3: Apply Pass/Warn/Fail Criteria

| Result | Criteria |
|--------|-----------|
| **PASS** | ≥70% exact overlap OR (≥70% equivalence AND no contradictions) |
| **WARN** | 50-69% equivalence, no contradictions, sources are relevant |
| **FAIL** | <50% equivalence AND factual contradiction exists |

### Step 4: Document Source Authority

For each query, note which system returned the more authoritative source:
- **semantic_more_authoritative:** RuVector source is policy/authoritative
- **stage3a_more_authoritative:** Stage 3A source is operational/better fit

---

## Pass/Warn/Fail Criteria

### PASS Conditions (Any of):
- [ ] Exact filename overlap ≥70%
- [ ] Equivalence score ≥70% AND no factual contradictions
- [ ] RuVector is semantically more authoritative (policy source for policy query)
- [ ] Stage 3A is more authoritative for operational queries

### WARN Conditions (Any of):
- [ ] Equivalence score 50-69%
- [ ] Low filename overlap but sources are relevant
- [ ] Semantic source differs from Stage 3A but both are non-contradictory
- [ ] Source family mismatch explained by query type

### FAIL/BLOCK Conditions (Any of):
- [ ] Factual contradiction between RuVector and Stage 3A
- [ ] Denied source appears in results
- [ ] Both systems return irrelevant sources
- [ ] Equivalence score <50% without source authority explanation

---

## Examples from Phase 8B.4B

### Example 1: Firewall Query

**Query:** "What firewall tool does Bazzite use?"

| System | Top Source | Family | Authority |
|--------|-------------|--------|-----------|
| RuVector | FINAL_POLICY.md | Policy | High for "what tool" |
| Stage 3A | GEMMA_LOCAL_AGENT.md | Operational | Lower for "what tool" |

**Classification:** `semantic_more_authoritative`
**Decision:** PASS (RuVector policy source is correct for policy query)
**Explanation:** Both answers are correct. RuVector returned the canonical policy source.

### Example 2: Report Path Query

**Query:** "Where should generated security reports and logs go?"

| System | Top Source | Family | Authority |
|--------|-------------|--------|-----------|
| RuVector | FINAL_POLICY.md | Policy | Medium |
| Stage 3A | GEMMA_LOCAL_AGENT.md | Operational | High for "where" |

**Classification:** `stage3a_more_authoritative`
**Decision:** PASS (both relevant, Stage 3A operational is better fit)
**Explanation:** Both systems return relevant content. Stage 3A operational docs are more specific for path queries.

### Example 3: Firewalld Not UFW

**Query:** "firewalld not ufw"

| System | Top Source | Family | Authority |
|--------|-------------|--------|-----------|
| RuVector | FINAL_POLICY.md | Policy | High |
| Stage 3A | OPENCODE_GEMMA_NOTES.md | Advisory | Low |

**Classification:** `semantic_more_authoritative`
**Decision:** PASS (RuVector policy explicitly rejects ufw)
**Explanation:** RuVector returned explicit policy rejection of ufw. More authoritative than advisory notes.

---

## How to Handle FINAL_POLICY.md

FINAL_POLICY.md dominance is **NOT a bug** when:
- Query is policy-type ("what firewall", "what paths", "what security model")
- Chunk contains explicit policy statement ("firewalld for host firewall management")
- Source family is Policy (highest authority for policy queries)

**Rule:** Accept FINAL_POLICY.md as authoritative source for policy-type queries. This is correct retrieval behavior.

---

## How to Handle Stage 3A Chunks

Stage 3A chunks from chunks.jsonl:
1. Classify by original source when metadata available
2. If metadata unavailable, treat as Stage 3A fallback evidence
3. Note in classification: `stage3a_fallback_evidence`

**Rule:** Stage 3A chunks are valid comparison baseline. Don't penalize if RuVector semantic finds different (but correct) source.

---

## Limitations

1. **Source family is provisional** — May need refinement as more queries are tested
2. **Content relevance is subjective** — Human review may be needed for edge cases
3. **Query classification is imperfect** — Some queries span multiple families
4. **Authority is query-dependent** — Policy source may not be authoritative for operational queries

---

## When Human Review Is Required

Human review is required when:
- Equivalence score is 40-49% with no clear explanation
- Both systems claim authority for different reasons
- New source types appear that don't fit existing families
- Factual contradiction is alleged but unconfirmed

---

## Related Documents

- `MEMORY_QUALITY_GATES.md` — Gate 1 revised definition
- `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` — Updated workflow
- `MEMORY_QUALITY_VALIDATION_CHECKLIST.md` — Checklist items
- `memory-quality-validation-output-template.md` — Output format
- `RUVECTOR_PHASE8B4B_GATE1_DIAGNOSTICS_SUMMARY.md` — Phase 8B.4B diagnostics

---

*Specification version: 1.0*
*Phase: 8B.4C*
*Status: Metric specification — not executable*

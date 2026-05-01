# Memory Quality Validation Output Template

**Phase:** 8B.3
**Purpose:** Reusable template for memory quality validation reports

---

## Template Structure#

```markdown
# Memory Quality Validation Report

## Title
[Be specific: "RuVector Semantic Prototype Quality Validation — Phase 8B.3"]

## Date
[ISO date: YYYY-MM-DD]

## Scope
[All 8 gates / Specific gate N: Name]

## Index/Version Under Review

| Item | Value |
|------|-------|
| Manifest | [semantic-manifest-*.json] |
| Chunk count | [N] (e.g., 398: 348 knowledge + 50 Stage 3A) |
| Embedding model | `nomic-embed-text:latest` |
| Embedding dimensions | `768` |
| Last indexed | [ISO date] |

---

## Gate Summary Table

| Gate | Name | Result | Blocker? |
|------|------|--------|----------|
| 1 | Stage 3A Comparison | [PASS/WARN/FAIL] | [Yes/No] |
| 2 | Stage 4 Validators | [PASS/FAIL] | [Yes/No] |
| 3 | Semantic Quality | [PASS/WARN/FAIL] | [Yes/No] |
| 4 | Source Spot-Check | [PASS/WARN/FAIL] | [Yes/No] |
| 5 | Answer Quality | [PASS/WARN/FAIL] | [Yes/No] |
| 6 | Manifest Metadata | [PASS/FAIL] | [Yes/No] |
| 7 | Rollback Path | [PASS/FAIL] | [Yes/No] |
| 8 | Stale Memory Review | [PASS/WARN/FAIL] | [Yes/No] |

---

## Gate 1: Stage 3A Comparison Evidence (REVISED)

**See:** `GATE1_SOURCE_EQUIVALENCE_METRIC.md` for specification

### Queries Run
- Count: [N] known queries from Stage 4
- Systems: RuVector semantic prototype + Stage 3A deterministic

### Revised Comparison Table

| Query | RuVector Source | RuVector Family | Stage 3A Source | Stage 3A Family | Exact Overlap % | Equivalence % | Classification |
|-------|------------------|------------------|---------------------|-------------------|----------------|---------------|---------------|
| [query 1] | [source] | [Policy/Operational/Advisory/Stage3A] | [source] | [Policy/Operational/Advisory/Stage3A] | [%] | [%] | [exact_match/family_equivalent/content_equivalent/semantic_more_authoritative/stage3a_more_authoritative/true_disagreement/insufficient_evidence] |
| [query 2] | [source] | [...] | [source] | [...] | [%] | [%] | [...] |
| ... | ... | ... | ... | ... | ... | ... | ... |

### Source Family Definitions Used
- **Policy:** FINAL_POLICY.md (authority for "what should happen" queries)
- **Operational:** OPERATIONS.md, PATHS.md, RUNBOOK.md (authority for "how to do X" queries)
- **Advisory:** OPENCODE_GEMMA_NOTES.md, GEMMA_LOCAL_AGENT.md (when describing boundaries)
- **Stage 3A:** chunks.jsonl entries (derived from approved docs)

### Source Authority Assessment
- **Queries where RuVector is more authoritative:** [N] — list queries where policy/authoritative source returned
- **Queries where Stage 3A is more authoritative:** [N] — list queries where operational/better-fit source returned
- **Queries with true disagreement:** [N] — list queries with factual contradictions

### Equivalence Score Calculation
- Formula: `(equivalent_pairs / total_pairs) * 100`
- Where: equivalent_pairs = exact_matches + family_matches + content_matches
- **Overall equivalence:** [%]
- **Overall exact overlap:** [%]

### Content Relevance Assessment
- RuVector content correct: [Yes/No — if no, explain]
- Stage 3A content correct: [Yes/No — if no, explain]
- Factual contradictions: [None found / List contradictions with explanations]

### FINAL_POLICY.md Dominance Explanation (NEW)
- For policy-type queries, FINAL_POLICY.md dominance is: [NOT A BUG / EXPLANATION REQUIRED]
- If policy query: explain why policy source is correct
- If non-policy query: explain why operational/advisory source would be better

### Revised Gate 1 Decision
- **Result:** [PASS/WARN/FAIL]
- **Classification:** [strong (≥70% exact) / partial (≥70% equivalence) / weak (50-69%) / contradiction / insufficient]
- **Pass criteria met:** [Yes/No]
  - [ ] ≥70% exact overlap, OR
  - [ ] ≥70% equivalence + no contradictions, OR
  - [ ] semantic/stage3a more authoritative explained
- **Warn criteria met (if applicable):**
  - [ ] 50-69% equivalence
  - [ ] Low exact overlap but sources relevant
  - [ ] Source family mismatch explained
- **Fail/Block criteria (if applicable):**
  - [ ] Factual contradiction exists
  - [ ] Denied source appears
  - [ ] Both systems return irrelevant sources
  - [ ] <50% equivalence without source authority explanation

### Evidence (REVISED)
- Equivalence calculation documented: [Yes/No]
- Source family classifications recorded: [Yes/No]
- Source authority assessed: [Yes/No]
- Reference to GATE1_SOURCE_EQUIVALENCE_METRIC.md: [Yes/No]
- Pass/Warn/Fail criteria clearly documented: [Yes/No]

---

## Gate 2: Stage 4 Validator Evidence

### Validator Results

| Validator | Result | Details |
|----------|--------|---------|
| `gemma-evals-status` | [PASS/FAIL] | [19 cases, 22 examples reviewed] |
| `gemma-evals-check` | [PASS/FAIL] | [8+5+5+1=19 cases, 0 errors] |
| `gemma-examples-check` | [PASS/FAIL] | [22 examples, 22 reviewed, 0 errors] |

### Output Captured
- Report: `~/offload/security-reports/manual/gemma-evals-status-*.md`
- Log: `~/.local/state/bazzite-security/logs/gemma-evals-check-*.log`
- Manifest: `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt`

### Evidence
- All validators PASS: [Yes/No]
- Pass criteria met: [Yes/No — all 3 PASS]

---

## Gate 3: Semantic Quality Evidence

### Queries Run
- Count: [N] known eval questions (≥10)
- Systems: RuVector vs Stage 3A

### Query Results Table

| Query | RuVector Top 5 | Relevance Scores | Stage 3A Top 5 | Better System |
|-------|----------------------|------------------|-----------------------|---------------|
| [query 1] | [sources] | [scores] | [sources] | [RuVector/Stage 3A/tie] |
| [query 2] | [sources] | [scores] | [sources] | [...] |
| ... | ... | ... | ... | ... |

### Spot-Check Results
- Relevant sources in top 5: [Yes/No]
- Hallucinations in retrieved context: [Yes/No — if yes, list]
- Precision vs Stage 3A: [equal or better / worse]
- Complex queries where RuVector excels: [list if any]

### Evidence
- Precision ≥ Stage 3A: [Yes/No]
- No hallucinations: [Yes/No]
- Pass criteria met: [Yes/No]

---

## Gate 4: Spot-Check Evidence

### Queries Run
- Count: [N] representative queries (10)
- Topics covered: [list topics]

### Spot-Check Table

| Query | Top 3 Sources | Relevant? (Y/N) | Which System Better? |
|-------|-----------------|---------------|----------------------|
| [query 1] | [src1, src2, src3] | [Y/N] | [RuVector/Stage 3A/tie] |
| [query 2] | [...] | [...] | [...] |
| ... | ... | ... | ... |

### Results
- Queries with relevant sources in top 3: [X/10]
- Queries with completely off-topic in top 3: [Y/N — list if any]
- RuVector demonstrates value beyond Stage 3A: [Yes/No — explain]

### Evidence
- ≥8/10 queries pass: [Yes/No]
- No off-topic in top 3: [Yes/No]
- Pass criteria met: [Yes/No]

---

## Gate 5: Answer Quality Evidence

### Queries Run
- Count: [N] (if using Gemma synthesis from memory)
- Gemma + RuVector answers: [generated]
- Gemma + Stage 3A answers: [generated for comparison]

### Answer Comparison Table

| Query | Gemma+RuVector Answer | Gemma+Stage 3A Answer | Quality Rating | Degradation? |
|-------|----------------------|--------------------------|----------------|---------------|
| [query 1] | [summary] | [summary] | [better/equal/worse] | [Y/N] |
| [query 2] | [...] | [...] | [...] | [...] |
| ... | ... | ... | ... | ... |

### Quality Checks
- Answers using RuVector context equal or better: [Yes/No]
- No additional hallucinations from semantic retrieval: [Yes/No]
- Source attribution remains accurate: [Yes/No]

### Evidence
- No degradation detected: [Yes/No]
- Quality issues documented: [if any, list]
- Pass criteria met: [Yes/No]

---

## Gate 6: Manifest Evidence

### Manifests Checked
- Count: [N] manifests (semantic-manifest-*.json)

### Manifest Validation Table

| Manifest File | Fields Present? | Parseable? | Consistent? |
|---------------|-----------------|------------|-------------|
| [manifest-1.json] | [Y/N] | [Y/N] | [Y/N] |
| [manifest-2.json] | [...] | [...] | [...] |

### Required Fields Check
- [ ] `input_source`: [present/ missing]
- [ ] `chunk_count`: [matches actual 398? Y/N]
- [ ] `embedding_model`: [nomic-embed-text:latest? Y/N]
- [ ] `embedding_dimensions`: [768? Y/N]
- [ ] `timestamp`: [present? Y/N]
- [ ] `excluded_paths`: [present? Y/N]
- [ ] `fallback_status`: [Stage 3A available? Y/N]
- [ ] `rollback_path`: [present? Y/N]

### Evidence
- All fields present: [Yes/No]
- All manifests parseable: [Yes/No]
- Pass criteria met: [Yes/No]

---

## Gate 7: Rollback Evidence

### Rollback Plan Checked
- Index: [manifest file, chunk count]
- Previous state: [describe]

### Rollback Plan Document
- Previous index location: [path/ manifest]
- New index location: [path/ manifest]
- Rollback steps: [1. Remove new, 2. Restore old, 3. Verify]
- Verification: [run query, confirm new chunks gone]
- Stage 3A fallback: [confirmed working after rollback? Y/N]

### Evidence
- Rollback plan exists: [Yes/No]
- Plan is testable: [Yes/No]
- Human can execute without AI: [Yes/No]
- Pass criteria met: [Yes/No]

---

## Gate 8: Stale-Memory Evidence

### Review Process
- Review documented: [Yes/No — link to document]
- Last review date: [ISO date]
- Index age: [days/weeks/months]
- Source availability: [all accessible / some missing]
- Relevance validation: [performed Y/N]

### Stale Entries
- No stale entries found: [Yes/No]
- If stale entries: [listed and marked]

### Evidence
- Review process exists: [Yes/No]
- Last review recorded: [Yes/No]
- Pass criteria met: [Yes/No]

---

## Failures/Warnings#

### Blocking Failures
| Gate | Failure Reason | Evidence | Action |
|------|----------------|----------|--------|
| [N] | [reason] | [evidence] | [escalate to human, block promotion] |

### Warnings
| Gate | Warning Details | Impact | Action |
|------|-----------------|--------|--------|
| [N] | [details] | [impact] | [flag in report, human review] |

### Skipped Gates
| Gate | Skip Reason | Authorized By | Action |
|------|-------------|---------------|--------|
| [N] | [boundary / user instruction] | [human] | [document, continue] |

---

## Fallback Status#

| Item | Status |
|------|--------|
| Stage 3A available | [Yes/No] |
| Used for queries during validation | [Yes/No] |
| Promotion blocked | [Yes/No — Phase 8B.3 never promotes] |
| RuVector remains prototype | [Yes — 398 chunks, nomic-embed-text:latest, 768 dims] |

---

## Human Review#

| Role | Decision | Date | Notes |
|------|----------|------|-------|
| Human reviewer | [PASS_ALL_GATES / FAIL_BLOCKING_GATE / PASS_WITH_WARNINGS / INCOMPLETE] | [date] | [notes] |

---

## Final Decision#

```
[PASS_ALL_GATES] — All gates pass, ready for future promotion consideration
[FAIL_BLOCKING_GATE] — Blocker found, promotion blocked, human escalated
[PASS_WITH_WARNINGS_NO_PROMOTION] — Gates pass with warnings, no promotion in 8B.3
[INCOMPLETE_MORE_INFO_REQUIRED] — Cannot complete, need more information
```

---

## Recommended Next Step#

- **[Proceed to promotion review / Fix blockers / Gather more data / Continue to Gate N]**
- **Rationale:** [explain]

---

## Metadata#

- **Validation ID:** [unique ID]
- **Workflow:** 8B.3 Memory Quality Validation
- **Generated by:** [component]
- **Reviewed by:** [human or "pending"]
- **Phase:** 8B.3 (documentation-only, no promotion)
```

---

## Example: Validation Report#

```markdown
# Memory Quality Validation Report

## Title
RuVector Semantic Prototype Quality Validation — Phase 8B.3

## Date
2026-04-30

## Scope
All 8 gates

## Index/Version Under Review

| Item | Value |
|------|-------|
| Manifest | semantic-manifest-20260430.json |
| Chunk count | 398 (348 knowledge + 50 Stage 3A) |
| Embedding model | nomic-embed-text:latest |
| Embedding dimensions | 768 |
| Last indexed | 2026-04-30T22:40:26Z |

## Gate Summary Table

| Gate | Name | Result | Blocker? |
|------|------|--------|----------|
| 1 | Stage 3A Comparison | PASS | No |
| 2 | Stage 4 Validators | PASS | No |
| 3 | Semantic Quality | PASS | No |
| 4 | Source Spot-Check | WARN | No |
| 5 | Answer Quality | PASS | No |
| 6 | Manifest Metadata | PASS | No |
| 7 | Rollback Path | PASS | No |
| 8 | Stale Memory Review | PASS | No |

## Gate 1: Stage 3A Comparison Evidence

### Comparison Table

| Query | RuVector Top Source | Stage 3A Top Source | Overlap % | Agreement |
|-------|----------------------|-----------------------|-----------|------------|
| "firewall tool?" | FINAL_POLICY.md | FINAL_POLICY.md | 100% | Strong |
| "Gemma profile" | GEMMA_PROFILE.md | GEMMA_PROFILE.md | 85% | Strong |
| ... | ... | ... | ... | ... |

### Agreement Classification
- **Overall:** Strong (78% average)
- **Disagreements:** Minor — RuVector found 2 relevant sources Stage 3A missed
- **Factually wrong:** No

## Gate 2: Stage 4 Validator Evidence

| Validator | Result | Details |
|----------|--------|---------|
| gemma-evals-status | PASS | 19 cases, 22 examples reviewed |
| gemma-evals-check | PASS | 19 cases, 0 errors |
| gemma-examples-check | PASS | 22 examples, 22 reviewed |

## Gate 4: Spot-Check Evidence

| Query | Top 3 Sources | Relevant? | Which System Better? |
|-------|-----------------|-----------|----------------------|
| "firewall" | FINAL_POLICY, OPERATIONS, ... | Y | Tie |
| "embedding model" | GEMMA_PROFILE, STAGE3A_CHUNK_12, ... | Y | Stage 3A |
| ... | ... | ... | ... |

Result: 9/10 queries pass (WARN: 1 query failed spot-check)

## Final Decision#

```
PASS_WITH_WARNINGS_NO_PROMOTION
```

Reason: All gates pass except Gate 4 has 1/10 query failing spot-check (WARN, not blocker). Phase 8B.3 does NOT promote RuVector. Fix Gate 4 issues before promotion review.

## Recommended Next Step#

**Fix Gate 4 issues** — identify why 1/10 query failed spot-check, then proceed to promotion review (future phase).
```

---

## Validation Commands#

```bash
# Verify template exists
test -f docs/workflows/templates/memory-quality-validation-output-template.md

# Run standard validators (Gate 2)
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Related Documents#

- `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` — Full workflow definition
- `MEMORY_QUALITY_GATES.md` — 8 quality gates (detailed)
- `MEMORY_QUALITY_VALIDATION_CHECKLIST.md` — Quick checklist
- `docs/workflows/templates/` — All templates
- `docs/roadmap/ROADMAP.md` — Phase 8B.3 status

---

*Template version: 1.0*
*Phase: 8B.3*
*Status: Documentation-only — no RuVector quality tests or production promotion in this phase*

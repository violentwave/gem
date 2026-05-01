# Workflow 8B.3: Memory Quality Validation

**Phase:** 8B.3
**Capability Level:** L6 (Memory Operations)
**Status:** Documentation-only workflow definition
**Production status:** RuVector remains prototype-only; no production memory promotion

---

## Workflow Name

**Memory Quality Validation** — Supervised validation process for all 8 quality gates before any RuVector production promotion.

---

## Capability Level

**L6** — Memory Operations. This workflow operates at the memory layer, validating quality gates that guard the boundary between prototype and production.

---

## Purpose

Define a future supervised memory quality validation process that:
- Validates all 8 quality gates (Gates 1-8, Gate 5 skipped per numbering)
- Uses Stage 3A deterministic retrieval as the comparison baseline
- Runs against the RuVector semantic prototype (398 chunks, nomic-embed-text:latest, 768 dims)
- Classifies each gate as PASS, FAIL (blocker), WARNING, or SKIPPED
- Produces evidence artifacts for human review
- Defines clear failure handling per gate
- Never promotes RuVector to production memory
- Never runs autonomous quality tests in Phase 8B.3

This workflow is **documentation-only** for Phase 8B.3. No RuVector quality tests, dry-runs, or production promotion checks are executed in this phase.

---

## When to Use

- When evaluating RuVector semantic retrieval quality against Stage 3A
- When preparing evidence for potential production promotion
- When validating that all 8 quality gates pass
- When investigating a specific gate failure
- When a human explicitly requests quality validation

**Do not use when:**
- Request is for immediate production promotion (goes through separate promotion review)
- Request asks to bypass one or more quality gates
- Request asks for autonomous/unattended validation
- Request asks to skip human approval

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Index/manifest to validate | Yes | Path to semantic prototype index |
| Scope | Yes | Which gates to validate (all 8, or specific gate) |
| Stage 3A comparison | Yes | Always required — never skip |
| Stage 4 validators | Yes | gemma-evals-status, gemma-evals-check, gemma-examples-check |
| Production promotion check | No | Only if human explicitly requests |
| Output format | No | Defaults to `docs/workflows/templates/memory-quality-validation-output-template.md` |

---

## Approved Paths

These paths may be accessed for quality validation:

| Path | Purpose | Access |
|------|---------|--------|
| `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md` | Approved knowledge docs (348 chunks) | Query for Gate 3/4 |
| `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | Stage 3A index (50 chunks indexed) | Comparison baseline for all gates |
| `~/.local/share/bazzite-security/gemma-evals/` | Stage 4 eval/examples | Gate 2 validation |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json` | Prototype manifests | Gate 6 validation |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` | Prototype index | Gate 1/3/4 validation (future phase) |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json` | Embedding cache | Gate 6 metadata reference only |
| `~/offload/security-reports/manual/` | Quality validation reports | Output location |
| `docs/workflows/templates/memory-quality-validation-output-template.md` | Output template | Template reference |

---

## Denied Paths/Data

These paths and data types are **never** allowed during quality validation:

### File Types (Always Denied)
- `.env` files
- API keys and provider secrets
- Raw private logs
- Browser data (cookies, Local Storage, Session Storage, Trust Tokens)
- Provider state
- Private project code (unless future prompt explicitly approves scoped path)

### Directory Roots (Always Denied)
- `~/.cache/` — broad cache root
- `~/.config/` — broad config root
- `~/.local/share/` — broad local share root (use scoped prototype paths only)
- `~/projects/` — broad project root
- `~/offload/security-reports/` — broad reports root (use scoped `manual/` only)

### System/Component State (Always Denied)
- Agent Zero memory
- Space Agent config/state
- OpenCode unredacted transcripts
- Runtime logs from `~/.local/state/bazzite-security/logs/`

---

## Allowed Components/Tools

| Component | Role in This Workflow | Status |
|-----------|----------------------|--------|
| RuVector semantic prototype | Validation target (future execution) | Prototype-only, 398 chunks |
| Stage 3A RAG | Comparison baseline (mandatory) | Production, canonical fallback |
| Stage 4 validators | Gate 2 pass/fail (mandatory) | `gemma-evals-status`, `gemma-evals-check`, `gemma-examples-check` |
| Gemma wrappers | Optional synthesis for reporting | Advisory only, L1-L2 |
| OpenCode | Read-only file inspection | L3, human approval for edits |
| Human | Approval authority, gate decisions | Required at all key points |

---

## Forbidden Actions

- No autonomous quality validation (all gates require human-supervised execution)
- No bypassing any quality gate
- No production memory promotion in Phase 8B.3
- No RuVector quality tests in Phase 8B.3 (documentation-only)
- No autonomous learning loop activation
- No secret/private data access during validation
- No broad filesystem indexing
- No Ollama/model config changes
- No package installs
- No writing runtime state into unrelated project roots

---

## Quality Gate Sequence

The workflow validates all 8 quality gates in sequence. Each gate must pass before promotion can be considered.

### Gate 1: Stage 3A Comparison Required (REVISED)

**Requirement:** Every semantic query must be compared against Stage 3A deterministic retrieval using a tiered metric with source-family equivalence.

**See:** `GATE1_SOURCE_EQUIVALENCE_METRIC.md` for full specification.

**Validation Method:**
1. Run 10+ known queries through RuVector semantic prototype
2. Run same queries through Stage 3A JSONL
3. Classify each top source by source family (Policy/Operational/Advisory/Stage 3A)
4. Calculate exact overlap: `(common_filenames / total_unique_filenames) * 100`
5. Calculate equivalence score: `(equivalent_pairs / total_pairs) * 100`
   - equivalent_pairs = exact_matches + family_matches + content_matches
6. Determine source authority (which system returned more authoritative source)
7. Assign classification labels: exact_match/family_equivalent/content_equivalent/semantic_more_authoritative/stage3a_more_authoritative/true_disagreement/insufficient_evidence
8. Check for factual contradictions
9. Document all classifications and explanations

**Source Families:**
- **Policy:** FINAL_POLICY.md (highest authority for "what should happen" queries)
- **Operational:** OPERATIONS.md, PATHS.md, RUNBOOK.md (highest for "how to do X" queries)
- **Advisory:** OPENCODE_GEMMA_NOTES.md, GEMMA_LOCAL_AGENT.md (when describing boundaries)
- **Stage 3A:** chunks.jsonl entries (derived from approved docs)

**Pass Criteria (ANY of):**
- ≥70% exact filename overlap, OR
- ≥70% equivalence score AND no factual contradictions, OR
- RuVector is semantically more authoritative (policy source for policy query), OR
- Stage 3A is more authoritative for operational queries

**Warn Conditions (ANY of):**
- Equivalence score 50-69%
- Low exact overlap but sources are relevant and non-contradictory
- Semantic source differs from Stage 3A but both are valid
- Source family mismatch explained by query type

**Fail Actions (BLOCK if ANY):**
- Factual contradiction exists between systems
- Denied source appears in results
- Both systems return irrelevant sources
- Equivalence score <50% without source authority explanation

**Evidence:** Comparison table with exact overlap %, equivalence %, source family classification, classification label, source authority assessment, FINAL_POLICY.md dominance explanation.

**Key Change:** Filename overlap alone is insufficient. Content relevance and source authority matter. FINAL_POLICY.md dominance is NOT a bug — may be correct canonical source for policy queries.

---

### Gate 2: Stage 4 Validators Must Pass

**Requirement:** Stage 4 eval system must remain fully passing.

**Validation Method:**
```bash
gemma-evals-status    # Must be PASS (19 cases, 22 examples reviewed)
gemma-evals-check     # Must be PASS (8+5+5+1 = 19 cases, 0 errors)
gemma-examples-check  # Must be PASS (22 examples, 22 reviewed, 0 errors)
```

**Pass Criteria:**
- `gemma-evals-status`: PASS
- `gemma-evals-check`: PASS
- `gemma-examples-check`: PASS

**Fail Actions:**
- Block any production promotion
- Investigate eval failures
- Fix before continuing
- Document failure details in report

**Evidence:** Validator output captured, pass/fail status per validator.

---

### Gate 3: Semantic Retrieval Quality Evaluation

**Requirement:** Semantic retrieval must be evaluated against known questions from Stage 4.

**Validation Method:**
1. Query RuVector with 10+ known eval questions
2. Compare semantic results to deterministic results
3. Check relevance scores for top 5 results
4. Manual spot-check top results
5. Test on complex queries where semantic search should excel

**Pass Criteria:**
- Relevant sources in top 5 results
- No hallucinations in retrieved context
- Precision equal or better than Stage 3A on complex queries

**Fail Actions:**
- If precision worse than Stage 3A: block promotion
- Document query failures
- Identify gaps between semantic and deterministic
- Suggest improvements

**Evidence:** Query results table, relevance scores, comparison with Stage 3A.

---

### Gate 4: Source Relevance Spot-Check

**Requirement:** Retrieved source relevance must be manually spot-checked.

**Validation Method:**
1. Run 10 representative queries across topics
2. Manually verify top 3 retrieved sources are relevant
3. Check for off-topic results in top 3
4. Identify which system (RuVector or Stage 3A) returns more relevant sources

**Pass Criteria:**
- At least 8/10 queries return relevant sources in top 3
- No completely off-topic results in top 3
- RuVector demonstrates value beyond Stage 3A on at least some queries

**Fail Actions:**
- If >3/10 queries fail: block promotion
- Identify problematic query types
- Document which topics RuVector handles poorly
- Suggest additional training or indexing

**Evidence:** Spot-check table (query, top 3 sources, relevance rating, which system better).

---

### Gate 5: Answer Generation Quality

**Requirement:** No answer generation should rely solely on RuVector until quality is proven.

**Validation Method:**
1. If using Gemma synthesis from memory:
2. Compare Gemma + RuVector vs Gemma + Stage 3A for same query
3. Verify no degradation in answer quality
4. Check for added hallucinations from semantic retrieval
5. Verify source attribution remains accurate

**Pass Criteria:**
- Answers using RuVector context are equal or better quality
- No additional hallucinations from semantic retrieval
- Source attribution remains accurate
- Gemma synthesis quality maintained

**Fail Actions:**
- If degradation detected: prefer Stage 3A
- Document quality issues
- Flag specific query types where RuVector underperforms
- Recommend keeping Stage 3A as primary

**Evidence:** Answer comparison table (query, Gemma+RuVector answer, Gemma+Stage3A answer, quality rating).

---

### Gate 6: Manifest Metadata Required

**Requirement:** Every memory index must have manifest metadata.

**Validation Method:**
1. Check manifest exists for each index: `semantic-manifest-*.json`
2. Verify all required fields populated (see Manifest Requirements in MEMORY_QUALITY_GATES.md)
3. Validate manifest is parseable JSON
4. Check embedding model and dimensions match (`nomic-embed-text:latest`, 768)

**Required Fields:**
| Field | Description | Example |
|-------|-------------|---------|
| `input_source` | Path to indexed source | `~/.local/share/bazzite-security/gemma-knowledge/docs/` |
| `chunk_count` | Number of chunks indexed | `398` |
| `embedding_model` | Model used | `nomic-embed-text:latest` |
| `embedding_dimensions` | Vector dimensions | `768` |
| `timestamp` | Index time | `2026-04-30T22:40:26Z` |
| `excluded_paths` | Paths not indexed | `[~/.cache, ~/.config]` |
| `fallback_status` | Fallback availability | `Stage 3A available` |
| `rollback_path` | How to undo | `Restore semantic-manifest-*.json` |
| `validation_commands` | How to verify | `["Run test queries", "Compare with Stage 3A"]` |

**Pass Criteria:**
- Manifest exists for each index
- All required fields populated
- Manifest is parseable JSON
- Values are consistent with actual index state

**Fail Actions:**
- Block use of indexes without manifest
- Require manifest creation
- Document missing fields

**Evidence:** Manifest validation table (manifest file, fields present, parseable, consistent).

---

### Gate 7: Rollback/Reset Path Documented

**Requirement:** Every memory change must have documented rollback.

**Validation Method:**
1. Check rollback plan exists for current index
2. Verify plan is testable (human can execute without AI)
3. Confirm Stage 3A fallback works after rollback
4. Document previous index state

**Required Rollback Information:**
| Item | Description |
|------|-------------|
| Previous index | What was the previous state? (e.g., 348 chunks) |
| Rollback command | How to restore? (restore previous manifest) |
| Fallback method | How to use Stage 3A instead? (all queries) |
| Verification | How to verify rollback success? (run query, confirm) |

**Pass Criteria:**
- Rollback plan exists before any change
- Plan is testable
- Human can execute without AI
- Stage 3A fallback confirmed working

**Fail Actions:**
- Block any memory changes without rollback plan
- Require rollback documentation
- Test rollback procedure

**Evidence:** Rollback plan document, test results, Stage 3A fallback confirmation.

---

### Gate 8: Stale Memory Review

**Requirement:** Stale memory review must exist before any long-term learning loop or production promotion.

**Validation Method:**
1. Check review process documented
2. Verify last review date recorded
3. Check index age (should be <3 months for production)
4. Verify no stale entries found (or marked)
5. Confirm relevance validation performed

**Review Criteria:**
| Check | Frequency |
|-------|-----------|
| Index age | Monthly |
| Source availability | Monthly |
| Relevance validation | Monthly |
| Overlap detection | Quarterly |

**Pass Criteria:**
- Review process documented
- Last review date recorded
- No stale entries found (or marked appropriately)
- Index age <3 months (or justified)

**Fail Actions:**
- Block learning loops until review exists
- Document current memory age
- Require stale entry cleanup

**Evidence:** Stale memory review document, index age check, relevance validation results.

---

## Pass/Fail Criteria Summary

| Gate | Name | Pass Criteria | Blocker |
|------|------|---------------|---------|
| 1 | Stage 3A Comparison | ≥70% overlap, disagreements explainable | <50% overlap or factually wrong |
| 2 | Stage 4 Validators | All PASS (3/3 validators) | Any FAIL |
| 3 | Semantic Quality | Precision ≥ Stage 3A, no hallucinations | Worse than Stage 3A |
| 4 | Source Spot-Check | 8/10 relevant in top 3 | >3/10 fail |
| 5 | Answer Quality | No degradation vs Stage 3A | Degradation detected |
| 6 | Manifest Metadata | All fields present, parseable | Missing fields/unparseable |
| 7 | Rollback Path | Plan exists, testable | No plan |
| 8 | Stale Memory Review | Review documented, indexed | No review |

---

## Failure Handling

For each gate failure, classify into one of four categories:

### Failure Categories

| Category | Meaning | Workflow Action |
|----------|---------|-------------------|
| **Blocking failure** | Gate fails, promotion blocked | Stop workflow, escalate to human, document blocker |
| **Warning** | Gate passes but with concerns | Continue workflow, flag in report, human review |
| **Environment unavailable** | Cannot run validation (Stage 3A/4 unavailable) | Stop workflow, fix environment, retry |
| **Skipped by boundary** | Gate not applicable in current phase | Document skip reason, continue |
| **Skipped by user instruction** | Human asks to skip gate | Document skip with human approval, continue |

### Per-Category Handling

#### Blocking Failure
- **What to report:** Gate name, failure reason, specific evidence, blocker status
- **Whether workflow stops:** YES — immediately
- **Whether promotion is blocked:** YES — until failure resolved
- **What fallback is used:** Stage 3A for all queries
- **Whether human approval is required:** YES — to resolve blocker

#### Warning
- **What to report:** Gate name, warning details, specific concerns, impact assessment
- **Whether workflow stops:** NO — continue to next gate
- **Whether promotion is blocked:** NO — but noted in report
- **What fallback is used:** None needed — gate still passes
- **Whether human approval is required:** YES — to review warning

#### Environment Unavailable
- **What to report:** Gate name, missing component (Stage 3A/4), error message
- **Whether workflow stops:** YES — fix environment first
- **Whether promotion is blocked:** YES — cannot validate without environment
- **What fallback is used:** Stage 3A (if available) or human recall
- **Whether human approval is required:** YES — to fix environment

#### Skipped by Boundary
- **What to report:** Gate name, skip reason ("Phase 8B.3 documentation-only"), boundary reference
- **Whether workflow stops:** NO — continue to next gate
- **Whether promotion is blocked:** NO — skip is authorized
- **What fallback is used:** N/A (validation not needed)
- **Whether human approval is required:** NO — boundary is automatic

#### Skipped by User Instruction
- **What to report:** Gate name, skip reason (user instruction), human who requested skip
- **Whether workflow stops:** NO — continue to next gate
- **Whether promotion is blocked:** Depends — if critical gate, YES
- **What fallback is used:** Stage 3A for queries
- **Whether human approval is required:** YES — skip was requested by human

### Failure Report Format

```
## Gate [N] Failure Report

**Category:** [Blocking failure / Warning / Environment unavailable / Skipped]

**Details:**
- Gate name: [Gate N: Name]
- Failure reason: [specific reason]
- Evidence: [specific evidence or error message]

**Impact:**
- Workflow stopped: [Yes/No]
- Promotion blocked: [Yes/No]
- Fallback used: [Stage 3A / Human / None]

**Human Action Required:**
- [What human must do to resolve]
- [Any approvals needed]
```

---

## Production Promotion Checklist

**Phase 8B.3 does NOT promote RuVector.** This checklist is for reference in future promotion phases.

Before promoting RuVector from prototype to production memory:

- [ ] **Gate 1:** Stage 3A comparison passing (≥70% overlap, disagreements explainable)
- [ ] **Gate 2:** Stage 4 validators all PASS (gemma-evals-status, gemma-evals-check, gemma-examples-check)
- [ ] **Gate 3:** Semantic quality evaluated (precision ≥ Stage 3A, no hallucinations)
- [ ] **Gate 4:** Source spot-check passing (8/10 relevant in top 3)
- [ ] **Gate 5:** Answer quality validated (no degradation vs Stage 3A)
- [ ] **Gate 6:** All indexes have manifests (all fields present, parseable)
- [ ] **Gate 7:** Rollback plans documented (exists, testable, human-executable)
- [ ] **Gate 8:** Stale memory review exists (documented, indexed, last date recorded)

**Explicit notes:**
- Passing 8B.3 does NOT promote RuVector — it only validates the gates
- Production promotion requires a separate future gate with explicit human approval
- Stage 3A remains canonical fallback even after any future promotion
- Human approval is required for every promotion decision
- No autonomous promotion is ever allowed

---

## Evidence Artifacts

Future workflow execution reports should include:

### Required Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| Quality validation report | Markdown using template | `~/offload/security-reports/manual/` |
| Gate 1 evidence | Comparison table in report | Within report |
| Gate 2 evidence | Validator output in report | Within report |
| Gate 3 evidence | Query results table in report | Within report |
| Gate 4 evidence | Spot-check table in report | Within report |
| Gate 5 evidence | Answer comparison in report | Within report |
| Gate 6 evidence | Manifest validation in report | Within report |
| Gate 7 evidence | Rollback plan in report | Within report |
| Gate 8 evidence | Stale memory review in report | Within report |

### Optional Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| Gemma synthesis summary | Section in report | Within report |
| Human approval note | Metadata in report | Within report |
| Follow-up actions | Final decision section | Within report |

### Repo-Local Reports

Repo-local reports (in `reports/`) are **only** allowed if the human explicitly asks for persistent repo documentation. Default output is `~/offload/security-reports/manual/`.

---

## Fallback Path

The fallback chain is always available:

```
Quality Validation
      │
      ▼
Gate Failure Detected
      │
      ▼
Check Failure Category
      │
      ├───► Blocking Failure ───► STOP, escalate to human
      │
      ├───► Warning ───► Continue, flag in report
      │
      ├───► Environment Unavailable ───► STOP, fix environment
      │
      └───► Skipped ───► Continue (documented)

All queries fall back to Stage 3A (always available)
```

**Rules:**
- Stage 3A is **always** available as canonical fallback
- If RuVector fails any gate, continue using Stage 3A
- If environment unavailable, fix before retrying
- Never leave a gate without a documented result

---

## Stop Conditions

The workflow **must stop immediately** if any of these conditions are met:

| # | Stop Condition | Action |
|---|------------------|--------|
| 1 | Gate 2 fails (any Stage 4 validator FAIL) | Stop, block promotion, investigate |
| 2 | Gate 1 <50% overlap with Stage 3A | Stop, escalate to human |
| 3 | Gate 1 has factually wrong disagreements | Stop, block promotion |
| 4 | Gate 3 precision worse than Stage 3A | Stop, block promotion |
| 5 | Gate 4 >3/10 queries fail spot-check | Stop, block promotion |
| 6 | Gate 6 manifest missing or unparseable | Stop, require manifest |
| 7 | Gate 7 no rollback plan exists | Stop, require rollback plan |
| 8 | Gate 8 no stale memory review exists | Stop, require review |
| 9 | Stage 3A fallback unavailable | Stop, fix environment |
| 10 | User asks for promotion without all gates passing | Stop, explain gates not all pass |
| 11 | User asks for autonomous validation | Stop, explain supervised-only |
| 12 | Environment cannot be fixed | Stop, escalate to human |

---

## Human Approval Points

Human approval is **required** at these points:

| # | Approval Point | When | Can Override |
|---|-----------------|------|---------------|
| 1 | Gate result approval | After all 8 gates validated | No override for blocking failures |
| 2 | Failure category confirmation | When gate fails or is skipped | No override for blocking failures |
| 3 | Production promotion decision | NOT in Phase 8B.3 | Never in this phase |
| 4 | Skip gate request | When human asks to skip a gate | Yes, with justification |
| 5 | Report review | After validation report generated | Yes, with comments |
| 6 | Follow-up actions | Before any action beyond validation | Yes |
| 7 | Repo-local report | Before saving in `reports/` | Yes |

---

## Expected Final Response Format

The workflow output should follow `docs/workflows/templates/memory-quality-validation-output-template.md`:

```markdown
# Memory Quality Validation Report

## Title
RuVector Semantic Prototype Quality Validation — Phase 8B.3

## Date
[ISO date]

## Scope
[All 8 gates / Specific gate N]

## Index/Version Under Review
- Manifest: `semantic-manifest-*.json`
- Chunk count: [N]
- Embedding model: `nomic-embed-text:latest` (768 dims)
- Last indexed: [date]

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

## Gate 1: Stage 3A Comparison Evidence
[Comparison table with overlap %, agreement classification, top disagreements]

## Gate 2: Stage 4 Validator Evidence
[Validator output: gemma-evals-status PASS, gemma-evals-check PASS, gemma-examples-check PASS]

## Gate 3: Semantic Quality Evidence
[Query results table: 10+ queries, relevance scores, RuVector vs Stage 3A]

## Gate 4: Spot-Check Evidence
[Spot-check table: 10 queries, top 3 sources, relevance rating]

## Gate 5: Answer Quality Evidence
[Answer comparison: Gemma+RuVector vs Gemma+Stage 3A, quality rating]

## Gate 6: Manifest Evidence
[Manifest validation: fields present, parseable, consistent]

## Gate 7: Rollback Evidence
[Rollback plan: exists, testable, Stage 3A confirmed]

## Gate 8: Stale-Memory Evidence
[Stale memory review: last review date, index age, relevance check]

## Failures/Warnings
[List all failures (blocking), warnings, skipped gates with reasons]

## Fallback Status
- Stage 3A available: [Yes/No]
- Used for queries: [Yes/No]
- Promotion blocked: [Yes/No — Phase 8B.3 never promotes]

## Human Review
| Role | Decision | Date | Notes |
|------|----------|------|-------|
| Human reviewer | [PASS_ALL_GATES / FAIL_BLOCKING_GATE / PASS_WITH_WARNINGS / INCOMPLETE] | [date] | [notes] |

## Final Decision
[PASS_ALL_GATES] — All gates pass, ready for future promotion consideration
[FAIL_BLOCKING_GATE] — Blocker found, promotion blocked
[PASS_WITH_WARNINGS_NO_PROMOTION] — Gates pass with warnings, no promotion in 8B.3
[INCOMPLETE_MORE_INFO_REQUIRED] — Cannot complete, need more information

## Recommended Next Step
[Proceed to promotion review / Fix blockers / Gather more data]

## Metadata
- **Validation ID:** [unique ID]
- **Workflow:** 8B.3 Memory Quality Validation
- **Generated by:** [component]
- **Reviewed by:** [human or "pending"]
```

---

## Example Quality Validation Output Outline

```
Title: RuVector Semantic Prototype Quality Validation — Phase 8B.3
Date: 2026-04-30
Scope: All 8 gates

Index: semantic-manifest-20260430.json
Chunk count: 398 (348 knowledge + 50 Stage 3A)
Embedding: nomic-embed-text:latest, 768 dims

Gate Summary:
  Gate 1: PASS (78% overlap, strong agreement)
  Gate 2: PASS (all 3 validators PASS)
  Gate 3: PASS (relevant sources in top 5, precision ≥ Stage 3A)
  Gate 4: PASS (9/10 queries relevant in top 3)
  Gate 5: WARN (some Gemma+RuVector answers slightly worse)
  Gate 6: PASS (all manifest fields present)
  Gate 7: PASS (rollback plan exists, testable)
  Gate 8: PASS (review documented, index <1 month old)

Failures/Warnings:
  Warning: Gate 5 — Gemma+RuVector slightly worse on 2/10 complex queries
  Note: Phase 8B.3 does NOT promote RuVector

Final Decision: PASS_WITH_WARNINGS_NO_PROMOTION
Next Step: Fix Gate 5 issues, then proceed to promotion review (future phase)
```

---

## Relationship to Other Workflows

| Workflow | Relationship |
|-----------|--------------|
| `MEMORY_WORKFLOW_LIBRARY.md` (Workflow 7) | This workflow implements "Memory Quality Validation" category |
| `WORKFLOW_8B1_MEMORY_QUERY.md` | Query insights feed into quality validation |
| `WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md` | Ingestion proposals must pass quality gates |
| `MEMORY_QUALITY_GATES.md` | Detailed gate definitions and criteria |
| `WORKFLOW_8B4` (future) | Dry-run quality validation execution |
| `WORKFLOW_8B5` (future) | Production promotion review (separate gate) |

---

## Validation Commands

```bash
# Verify workflow doc exists
test -f docs/workflows/memory/WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md

# Verify template exists
test -f docs/workflows/templates/memory-quality-validation-output-template.md

# Run standard validators (Gate 2)
gemma-evals-status    # Must be PASS
gemma-evals-check     # Must be PASS
gemma-examples-check  # Must be PASS

# Check no execution occurred in Phase 8B.3
# (no RuVector quality tests were run)
```

---

## Related Documents

- `MEMORY_WORKFLOW_LIBRARY.md` — Workflow categories (Workflow 7: Memory Quality Validation)
- `MEMORY_BOUNDARIES.md` — Prototype boundaries, source classes
- `MEMORY_SOURCE_POLICY.md` — Source class definitions (A/B/C/D)
- `MEMORY_QUALITY_GATES.md` — 8 quality gates (detailed definitions)
- `docs/workflows/templates/memory-quality-validation-output-template.md` — Output template
- `docs/workflows/memory/WORKFLOW_8B1_MEMORY_QUERY.md` — Query workflow (feeds into validation)
- `docs/workflows/memory/WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md` — Ingestion review (must pass gates)
- `docs/integrations/ruvector/RUVECTOR_PHASE7B2_SEMANTIC_PROTOTYPE_REPORT.md` — Prototype status
- `docs/roadmap/ROADMAP.md` — Phase 8B.3 status

---

*Workflow version: 1.0*
*Phase: 8B.3*
*Status: Documentation-only — no RuVector quality tests or production promotion in this phase*
*RuVector status: Prototype-only, 398 chunks (348 approved-doc + 50 Stage 3A), nomic-embed-text:latest, 768 dims*
*Stage 3A status: Canonical fallback, always available*

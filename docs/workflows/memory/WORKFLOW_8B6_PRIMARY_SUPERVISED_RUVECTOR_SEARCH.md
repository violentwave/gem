# Workflow 8B.6: Primary Supervised RuVector Search

**Workflow ID:** WORKFLOW_8B6
**Phase:** 8B.6
**Status:** Active
**Date:** 2026-04-30

---

## Purpose

Define the supervised workflow for using `gemma-memory-search` — a helper that queries RuVector as PRIMARY semantic retrieval with Stage 3A as DETERMINISTIC FALLBACK.

This workflow does NOT replace Stage 3A. It provides a supervised comparison path for evaluation purposes.

Phase 8B.6A hardening requires the helper to emit source-family classifications, Stage 3A parsed summaries, exact overlap, source-family/content equivalence, source authority notes, fallback status, and a final recommendation for each query.

Phase 8B.6B answerability calibration requires the helper to verify direct evidence before issuing high-confidence recommendations. Source-family relevance alone is not sufficient when retrieved excerpts are only generic headers or weak context.

---

## Scope

### ✅ In Scope
- Running `gemma-memory-search "<query>"` for supervised retrieval
- Comparing RuVector semantic results against Stage 3A deterministic results
- Classifying sources by family (Policy, Operational, Advisory/OpenCode, Stage 3A, Unknown)
- Classifying answerability (`direct_answer`, `supporting_context`, `weak_context`, `generic_header_only`, `unrelated_or_unclear`)
- Producing final recommendation logic for supervised use
- Writing comparison reports to `~/offload/security-reports/manual/`
- Using nomic-embed-text:latest (768d) for semantic search
- Reading from existing RuVector semantic index (398 chunks)

### ❌ Out of Scope
- Autonomous memory/learning loops
- Replacing Stage 3A as default
- Modifying existing wrapper behavior
- Indexing new content
- Running npm install
- Using sudo
- Installing packages
- Changing Ollama or model config
- Starting Agent Zero or Space Agent

---

## Preconditions

| Precondition | Check Command | Expected Result |
|--------------|---------------|----------------|
| RuVector semantic index exists | `ls -la ~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` | File exists |
| Stage 3A index exists | `ls -la ~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | File exists |
| gemma-knowledge-search works | `gemma-knowledge-search "test" 2>&1 | head -5` | Output produced |
| nomic-embed-text available | `ollama list | grep nomic-embed-text` | Model listed |
| Helper exists | `ls -la ~/.local/bin/gemma-memory-search` | File exists, executable |
| Helper compiles | `python3 -m py_compile ~/.local/bin/gemma-memory-search` | No output (success) |

---

## Workflow Steps

### Step 1: Formulate Query
- Use a clear, specific question about Bazzite security, policy, operations, or Gemma agent behavior
- Example: `"What firewall tool does Bazzite use?"`
- Example: `"Where should security logs be written?"`

### Step 2: Run Supervised Search
```bash
gemma-memory-search "Your query here"
```

The helper will:
1. **PRIMARY:** Query RuVector semantic index (nomic-embed-text:latest, 768d)
2. **FALLBACK:** Run `gemma-knowledge-search "<query>"` (Stage 3A deterministic)
3. Parse Stage 3A results when possible (rank, score, source, heading, excerpt)
4. Classify source families and calculate overlap/equivalence metrics
5. Classify answerability/direct evidence for each top result
6. Emit a final recommendation, recommendation confidence, and fallback status
7. Write comparison report to `~/offload/security-reports/manual/gemma-memory-search-YYYYMMDD-HHMMSS.md`

### Step 3: Review Results

#### RuVector Results (PRIMARY)
- Check similarity scores (higher = better match)
- Verify source types (approved-doc, stage3a-chunk)
- Compare excerpt relevance to query intent

#### Stage 3A Results (FALLBACK)
- Check deterministic scores (keyword-based)
- Verify source filenames
- Compare excerpt relevance to query intent

### Step 4: Compare and Evaluate

| Aspect | RuVector (Semantic) | Stage 3A (Deterministic) |
|--------|----------------------|----------------------------|
| **Method** | Cosine similarity on 768d embeddings | Keyword frequency + heading + filename |
| **Source** | `semantic-approved-docs-memory.json` (398 chunks) | `chunks.jsonl` (234 chunks) |
| **Strengths** | Semantic understanding, finds related concepts | Predictable, fast, no Ollama dependency |
| **Weaknesses** | Requires Ollama for embeddings, slower | Keyword-only, may miss semantic matches |

The helper records:

- RuVector source set and source families
- Stage 3A source set and source families
- Exact filename overlap percentage
- Source-family/content equivalence percentage
- Source authority notes
- Disagreement/uncertainty notes
- Conservative contradiction checks
- Per-result answerability classification
- Direct evidence counts for RuVector and Stage 3A
- Recommendation confidence (`high`, `medium`, `low`, `blocked`)
- Downgrade reason when source-family relevance is not directly answerable

### Step 4A: Calibrate Answerability

Answerability is distinct from source relevance. A source can be relevant but still not directly answer the question.

| Class | Meaning |
|-------|---------|
| `direct_answer` | Excerpt contains direct answer terms for the query intent |
| `supporting_context` | Excerpt is relevant but not sufficient alone |
| `weak_context` | Excerpt has loose family/query relevance only |
| `generic_header_only` | Excerpt is only a title/header/metadata or too short to support an answer |
| `unrelated_or_unclear` | Excerpt does not provide usable evidence |

Production/status queries require explicit status evidence such as `prototype-only`, `not production`, `not production-ready`, `production default`, `not approved`, `approved_secondary_retrieval_source`, `canonical fallback`, `Stage 3A remains fallback`, or `no production promotion`. Generic titles, source-family authority, and similarity/overlap alone do not qualify.

### Step 5: Apply Final Recommendation

The final recommendation must be one of:

| Recommendation | Meaning |
|----------------|---------|
| `use_ruvector_context` | RuVector returned relevant source-equivalent or more authoritative context |
| `use_ruvector_primary_with_stage3a_support` | Both systems returned relevant, non-contradictory context |
| `use_stage3a_context` | Stage 3A returned clearer operational/path context |
| `ruvector_unavailable_use_stage3a` | RuVector failed, timed out, or returned no usable context |
| `stop_human_review_required` | A factual contradiction or high-risk ambiguity requires review |
| `insufficient_evidence` | Both systems are weak or unclear |

Answerability gates the recommendation:

- RuVector may get `use_ruvector_context` only with `direct_answer` evidence or multiple independent `supporting_context` results.
- If RuVector is family-relevant but only `generic_header_only` or `weak_context`, downgrade to Stage 3A support when Stage 3A is useful, otherwise `insufficient_evidence`.
- If Stage 3A has more direct answer evidence, prefer `use_stage3a_context`.
- If both systems are weak, use `insufficient_evidence`.
- If contradiction appears, use `stop_human_review_required`.

### Step 6: Use Results

- **For advisory:** Use whichever results better match intent
- **For reporting:** Reference the report file
- **For comparison:** Both sources are preserved in the report

---

## Output Artifacts

| Artifact | Path Pattern | Purpose |
|----------|---------------|---------|
| Search Report | `~/offload/security-reports/manual/gemma-memory-search-YYYYMMDD-HHMMSS.md` | Full comparison of both searches |
| Session Log | `~/.local/state/bazzite-security/logs/gemma-memory-search-YYYYMMDD-HHMMSS.log` | Debug/trace log |

Every report must include final recommendation, fallback status, source-family classifications, Stage 3A comparison, answerability classification, direct evidence counts, recommendation confidence, source authority notes, disagreement/uncertainty notes, and boundaries preserved.

---

## Error Handling

| Error | Behavior |
|-------|----------|
| RuVector index missing | WARNING printed, Stage 3A fallback still runs, report notes error |
| Ollama timeout (30s) | Empty RuVector results, Stage 3A fallback runs, report notes timeout |
| Stage 3A timeout (30s) | RuVector results shown, Stage 3A shows timeout message |
| No results (either) | "No results found" message, report still written |
| Embedding dimension mismatch | WARNING logged, RuVector results skipped |

If Stage 3A parsing is partial, raw Stage 3A output is preserved in the report and parsing status is marked `partial`.

---

## Quality Gates

### Gate 1: Helper Syntax
```bash
python3 -m py_compile ~/.local/bin/gemma-memory-search
```
✅ Must pass (no syntax errors)

### Gate 2: Test Queries (4/4)
All 4 test queries must run and print a final recommendation.

### Gate 2A: Report Contents
Each report must include:
- Final recommendation
- Source-family classification
- Stage 3A comparison
- Answerability classification
- Direct evidence counts
- Recommendation confidence
- Fallback status

### Gate 3: Eval Validation
```bash
gemma-evals-check
```
✅ Must show `RESULT: PASS`

### Gate 4: Git Status
```bash
cd ~/projects/gem && git status --short
```
✅ No unintended modifications to existing files

---

## Security Boundaries

- **No sudo** — Helper runs with user permissions only
- **No installs** — Uses existing tools only
- **No model changes** — Uses nomic-embed-text:latest as-is
- **No secret access** — Does not read `.env`, tokens, or raw logs
- **No autonomous loops** — Single-query execution only
- **Localhost only** — Ollama calls to 127.0.0.1:11434
- **Canonical paths** — All I/O within defined security boundaries

---

## Related Workflows

- **Stage 3A deterministic search:** `docs/workflows/memory/WORKFLOW_3A_DETERMINISTIC_RETRIEVAL.md`
- **Quality validation:** `docs/workflows/memory/WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md`
- **Promotion review:** `docs/integrations/ruvector/RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md`

---

## History

| Date | Action | Notes |
|------|--------|-------|
| 2026-04-30 | Created | Helper validated with 4 test queries, all evals pass |
| 2026-04-30 | Phase 8B.6A hardening | Added source-family classification, Stage 3A parsing, overlap/equivalence metrics, fallback status, and final recommendation logic |
| 2026-04-30 | Phase 8B.6B answerability calibration | Added direct-evidence checks, answerability classes, recommendation confidence, and downgrade logic for generic/weak excerpts |

---

*Workflow created: 2026-04-30*
*Phase: 8B.6*
*Status: Active — supervised use approved, autonomous use denied; Phase 8B.6A and 8B.6B hardening completed*

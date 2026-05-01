# RuVector Phase 8B.6 Supervised Helper Summary

**Phase:** 8B.6
**Status:** Completed; Phase 8B.6A and 8B.6B hardening completed
**Date:** 2026-04-30

---

## Deliverable

Created `~/.local/bin/gemma-memory-search` — a supervised helper that:

1. **PRIMARY:** Queries RuVector semantic index (nomic-embed-text:latest, 768d, 398 chunks)
2. **FALLBACK:** Runs Stage 3A deterministic search (`gemma-knowledge-search`)
3. **Report:** Writes comparison report to `~/offload/security-reports/manual/gemma-memory-search-YYYYMMDD-HHMMSS.md`

Phase 8B.6A hardened the helper so the report is no longer only a side-by-side result dump. It now implements Gate 1-style source-family classification, Stage 3A result parsing, overlap/equivalence metrics, source authority notes, fallback status, and final recommendation logic.

Phase 8B.6B added answerability calibration so source-family relevance alone is not enough for high-confidence context use. The helper now checks whether retrieved excerpts directly answer the query and downgrades recommendations when results are only generic headers or weak context.

---

## Key Design Decisions

| Decision | Value |
|----------|-------|
| **RuVector role** | PRIMARY supervised retrieval |
| **Stage 3A role** | DETERMINISTIC FALLBACK / comparison baseline |
| **Wrapper defaults** | Unchanged (Stage 3A remains default for other wrappers) |
| **Autonomous use** | ❌ Denied — supervised only |
| **Production default** | ❌ NOT approved — `approved_secondary_retrieval_source` |
| **Embedding model** | nomic-embed-text:latest (768 dimensions) |
| **Index path** | `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` |
| **Timeout (embeddings)** | 30 seconds |
| **Timeout (Stage 3A)** | 30 seconds |
| **Top results** | 5 |

---

## Phase 8B.6A Hardening

Added helper logic for:

- Source-family classification: Policy, Operational, Advisory/OpenCode, Stage 3A, Unknown
- Stage 3A parsed result summaries: rank, score, source, heading, excerpt
- Exact filename overlap percentage
- Source-family/content equivalence percentage and labels
- Source authority notes for policy, operational/path, and Gemma/OpenCode queries
- Conservative factual contradiction checks
- Final recommendation values: `use_ruvector_context`, `use_ruvector_primary_with_stage3a_support`, `use_stage3a_context`, `ruvector_unavailable_use_stage3a`, `stop_human_review_required`, `insufficient_evidence`
- Concise terminal output with query, top source families, overlap/equivalence, final recommendation, report path, and log path
- Report sections for recommendation, fallback status, source-family classifications, authority notes, disagreement/uncertainty, and boundaries preserved

---

## Phase 8B.6B Answerability Calibration

Added deterministic direct-evidence checks for:

- Query keyword overlap
- Expected answer terms by intent
- Direct policy/path/status terms
- Generic header-only excerpts
- Excerpts too short to support a recommendation
- Multiple independent supporting results

Answerability classes:

- `direct_answer`
- `supporting_context`
- `weak_context`
- `generic_header_only`
- `unrelated_or_unclear`

Recommendation confidence buckets:

- `high`
- `medium`
- `low`
- `blocked`

Regression behavior:

- Query: `What is RuVector's current production status?`
- Before 8B.6B: `use_ruvector_context` despite generic/header-like top excerpts
- After 8B.6B: downgraded unless retrieved excerpts directly mention prototype/production/default/approved/supervised/fallback status terms

---

## Validation Results

### Syntax Check
```bash
python3 -m py_compile ~/.local/bin/gemma-memory-search
```
✅ **PASS** — No syntax errors

### Test Queries (4/4 PASSED)

| # | Query | RuVector Top-1 Source | Stage 3A Top-1 Source | Status |
|---|-------|----------------------|------------------------|--------|
| 1 | "What is the safe operating model for local Gemma?" | OPENCODE_GEMMA_NOTES.md (0.8347) | GEMMA_LOCAL_AGENT.md (151.00) | ✅ |
| 2 | "Which package manager should be used on Bazzite?" | FINAL_POLICY.md (0.7006) | GEMMA_LOCAL_AGENT.md (84.00) | ✅ |
| 3 | "What firewall tool does Bazzite use?" | FINAL_POLICY.md (0.7069) | GEMMA_LOCAL_AGENT.md (70.00) | ✅ |
| 4 | "Where should security logs be written?" | GEMMA_LOCAL_AGENT.md (0.6674) | GEMMA_LOCAL_AGENT.md (68.00) | ✅ |

### gemma-evals-check
```
All validations passed
RESULT: PASS
```
✅ **PASS** — All 19 eval cases valid, 11 forbidden terms defined

### Git Status
```
?? .gitignore
?? AGENTS.md
?? README.md
?? docs/
?? inventory/
?? prompts/
?? prototypes/
?? scripts/
```
✅ **PASS** — New files tracked, no unintended modifications

---

## Files Created

| File | Purpose |
|------|---------|
| `~/.local/bin/gemma-memory-search` | Supervised helper (Python 3, stdlib only) |
| `~/offload/security-reports/manual/gemma-memory-search-*.md` | Search reports (4 test runs) |
| `~/.local/state/bazzite-security/logs/gemma-memory-search-*.log` | Session logs |
| `docs/integrations/ruvector/RUVECTOR_PHASE8B6_PRIMARY_SUPERVISED_HELPER_SUMMARY.md` | This summary |
| `docs/workflows/memory/WORKFLOW_8B6_PRIMARY_SUPERVISED_RUVECTOR_SEARCH.md` | Workflow documentation |
| `docs/roadmap/ROADMAP.md` | Updated with Phase 8B.6 ✅ |

---

## What `gemma-memory-search` Does NOT Do

- ❌ Does NOT modify existing `gemma-knowledge-search` behavior
- ❌ Does NOT replace Stage 3A as the canonical fallback
- ❌ Does NOT enable autonomous memory/learning loops
- ❌ Does NOT run `npm install`
- ❌ Does NOT run indexing scripts
- ❌ Does NOT modify files under `~/.local/share/bazzite-security/ruvector/`
- ❌ Does NOT print huge JSON or full embeddings
- ❌ Does NOT use sudo
- ❌ Does NOT install packages
- ❌ Does NOT download or pull models
- ❌ Does NOT change Ollama or model config
- ❌ Does NOT start Agent Zero
- ❌ Does NOT run A0 tasks
- ❌ Does NOT run Space Agent autonomous tasks
- ❌ Does NOT ingest new memory

---

## Usage

```bash
# Supervised RuVector search with Stage 3A fallback
gemma-memory-search "What firewall tool does Bazzite use?"

# Outputs:
# - RuVector results (PRIMARY, semantic)
# - Stage 3A results (FALLBACK, deterministic)
# - Final recommendation and fallback status
# - Source-family classifications and comparison metrics
# - Answerability classification and recommendation confidence
# - Report: ~/offload/security-reports/manual/gemma-memory-search-YYYYMMDD-HHMMSS.md
# - Log: ~/.local/state/bazzite-security/logs/gemma-memory-search-YYYYMMDD-HHMMSS.log
```

---

## Next Phase Options

| Phase | Description | Status |
|--------|-------------|--------|
| **8B.7** | Supervised RAG integration (optional) | ⏳ Upcoming |
| **8D.1** | Workflow Index Verification | ⏳ Future |
| **9** | Planning (Post-Promotion) | ⏳ Future |

---

## Related Documents

- Helper: `~/.local/bin/gemma-memory-search`
- Phase 8B.5 summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md`
- Phase 8B.4D summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4D_FULL_QUALITY_VALIDATION_SUMMARY.md`
- Phase 8B.4E summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4E_GATE5_ANSWER_QUALITY_SUMMARY.md`
- Integration plan: `docs/integrations/ruvector/RUVECTOR_INTEGRATION_PLAN.md`
- Workflow: `docs/workflows/memory/WORKFLOW_8B6_PRIMARY_SUPERVISED_RUVECTOR_SEARCH.md`
- Roadmap: `docs/roadmap/ROADMAP.md`

---

*Summary created: 2026-04-30*
*Phase: 8B.6*
*Status: Helper hardened, calibrated, validated, and documented — RuVector as PRIMARY supervised retrieval, Stage 3A as FALLBACK/comparison baseline*

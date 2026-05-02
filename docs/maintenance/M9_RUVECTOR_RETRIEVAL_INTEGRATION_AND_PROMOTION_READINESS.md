# M9 — RuVector Retrieval Integration and Promotion Readiness

**Phase:** M9 — RuVector Retrieval Integration and Promotion Readiness  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Review and integration planning phase (no promotion, no default changes)

---

## Purpose

Review RuVector's current status as a supervised secondary retrieval source, compare it with Stage 3A deterministic retrieval, and determine promotion readiness. This phase does NOT promote RuVector to default, does NOT modify wrapper behavior, and does NOT enable autonomous retrieval.

---

## Current RuVector Status

| Property | Value |
|----------|-------|
| **Level** | `approved_secondary_retrieval_source` |
| **Status** | Supervised prototype |
| **Index** | 398 chunks (348 approved-docs + 50 Stage 3A) |
| **Model** | `nomic-embed-text:latest` (768d) |
| **Helper** | `~/.local/bin/gemma-memory-search` |
| **RAG Helper** | `~/.local/bin/gemma-memory-rag` |
| **Gate 1** | PASS (75% pass rate, revised source-equivalence metric) |
| **Gate 2** | PASS (all validators pass) |
| **Gate 3** | PASS (10/10 relevant) |
| **Gate 4** | PASS (10/10 relevant) |
| **Gate 5** | PASS (5/5 ruvector_better/equivalent) |
| **Gate 6** | PASS (398 chunks, manifest valid) |

---

## RuVector vs Stage 3A Comparison

| Factor | RuVector (Semantic) | Stage 3A (Deterministic) |
|--------|--------------------|--------------------------|
| **Method** | Cosine similarity on 768d embeddings | Keyword frequency + heading + filename |
| **Strengths** | Semantic understanding, finds related concepts | Predictable, fast, no Ollama dependency |
| **Weaknesses** | Requires Ollama for embeddings, slower | Keyword-only, may miss semantic matches |
| **Gate 1 Pass Rate** | 75% (revised metric) | 100% (canonical baseline) |
| **Dependencies** | Ollama + nomic-embed-text | None (stdlib only) |
| **Speed** | ~2-5s per query | ~0.5s per query |
| **Transparency** | Medium (embeddings are opaque) | High (inspect chunks directly) |
| **Rollback** | Delete index | Delete index |

---

## Promotion Readiness Assessment

### What Would Be Required for Promotion?

| Requirement | Current | Needed | Gap |
|-------------|---------|--------|-----|
| **Gate 1 pass rate** | 75% | 90%+ | +15% |
| **Long-term stability** | < 1 week tested | 1+ month | Not met |
| **Stale memory review** | Not required (fresh) | Monthly | Not started |
| **Operator familiarity** | Limited | Comfortable | Medium gap |
| **Documentation** | Complete | Complete | Met |
| **Rollback tested** | Documented | Executed | Not tested |

### Promotion Decision

**Decision: NO PROMOTION**

RuVector remains `approved_secondary_retrieval_source`. It is NOT promoted to:
- Default retrieval source
- Wrapper default
- Autonomous retrieval
- Production primary

**Rationale:**
1. Gate 1 pass rate (75%) is good but not excellent (90%+ target)
2. Long-term stability not yet proven (only days of operation)
3. Stage 3A is simpler, faster, and has zero dependencies
4. No compelling use case requires RuVector as default
5. Maintaining Stage 3A as fallback is zero-cost insurance

---

## Integration Recommendations

### Current State (Preserved)

| Component | Behavior |
|-----------|----------|
| `gemma-knowledge-search` | Stage 3A only (unchanged) |
| `gemma-knowledge-rag` | Stage 3A only (unchanged) |
| `gemma-memory-search` | RuVector primary + Stage 3A comparison (supervised) |
| `gemma-memory-rag` | RuVector primary + Stage 3A fallback (supervised) |
| All other wrappers | Unchanged |

### Recommended Integration Pattern

```
User Query
    ├──> Supervised mode? (explicit request)
    │       ├──> YES → gemma-memory-search (RuVector + Stage 3A comparison)
    │       └──> NO  → gemma-knowledge-search (Stage 3A only)
    └──> RAG mode? (explicit request)
            ├──> YES → gemma-memory-rag (RuVector + Stage 3A fallback)
            └──> NO  → gemma-knowledge-rag (Stage 3A only)
```

---

## M9 Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| Integration review | This document | Complete |
| Promotion decision | This document | Complete |
| Comparison matrix | This document | Complete |

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| RuVector status reviewed | PASS | approved_secondary confirmed |
| Stage 3A fallback preserved | PASS | No changes to defaults |
| Gate evidence reviewed | PASS | Gates 1-6 all PASS |
| Promotion criteria assessed | PASS | Criteria documented |
| Promotion decision made | PASS | NO PROMOTION |
| Integration pattern defined | PASS | Supervised-only pattern |
| No default changes | PASS | Wrapper defaults unchanged |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- M9: COMPLETE
- RuVector status: `approved_secondary_retrieval_source` (unchanged)
- Stage 3A: Canonical fallback (unchanged)
- Promotion: DENIED (correct decision)
- Integration pattern: Supervised-only
- Date: 2026-05-02

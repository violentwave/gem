# RUVECTOR Phase 8B.4B — Gate 1 Retrieval Diagnostics Summary

**Phase:** 8B.4B (Gate 1 Diagnostics)
**Date:** 2026-05-01
**Status:** ✅ COMPLETE (diagnostic only — no promotion)
**Report:** `~/offload/security-reports/manual/ruvector-gate1-retrieval-diagnostics-20260501-013702.md`

---

## Report Path

`~/offload/security-reports/manual/ruvector-gate1-retrieval-diagnostics-20260501-013702.md`

---

## Root Cause

**FINAL_POLICY.md dominance is NOT a bug.**

- FINAL_POLICY.md is the **actual canonical source** for policy-type queries (firewall, paths)
- Contains explicit policy statements: "`firewalld` for host firewall management"
- RuVector correctly returns the authoritative source
- Stage 3A returns operational docs (GEMMA_LOCAL_AGENT.md) because keyword matching finds path references

---

## Whether FINAL_POLICY.md Dominance is Harmful

**No — RuVector is returning correct answers.**

| Query | FINAL_POLICY.md Content | Correct? |
|-------|------------------------|----------|
| "What firewall tool does Bazzite use?" | "firewalld for host firewall management" | ✅ YES |
| "Where should security reports go?" | "Exported security reports" section | ✅ YES |

The "weak overlap" is due to different source types (policy vs operational), not incorrect retrieval.

---

## Whether Gate 1 Metric Needs Revision

**YES — filename overlap metric is too strict.**

Current metric compares exact filename matches between RuVector and Stage 3A top sources. This doesn't account for **source-family equivalence**:
- Policy docs (FINAL_POLICY.md) ↔ Operational docs (GEMMA_LOCAL_AGENT.md) — both can be correct
- The Gate 1 criterion should be content relevance, not source attribution

**Recommendation:** Revise metric to allow source-family equivalence classes.

---

## Recommended Next Step

1. **Revise Gate 1 metric** to allow source-family equivalence (policy ↔ operational ↔ advisory)
2. **Re-run full Gate 3/4 validation** with revised metric
3. **Do NOT promote to production** until metric revision and re-validation

---

## Chunk Distribution (Reference)

| Source | Chunks | Avg Length |
|--------|--------|-------------|
| GEMMA_LOCAL_AGENT.md | 90 | 215 chars |
| OPENCODE_GEMMA_NOTES.md | 84 | 96 chars |
| FINAL_POLICY.md | 78 | 90 chars |
| OPERATIONS.md | 58 | 115 chars |
| Stage 3A chunks | 50 | — |

---

## Sign-off

**Phase 8B.4B Status:** ✅ COMPLETE
**Root Cause:** FINAL_POLICY.md is correct canonical source for policy queries
**Gate 1 Metric:** Needs revision (filename overlap too strict)
**Phase 8B.5 Promotion:** 🚫 Blocked until metric revised

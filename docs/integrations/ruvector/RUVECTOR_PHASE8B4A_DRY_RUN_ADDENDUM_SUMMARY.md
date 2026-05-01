# RUVECTOR Phase 8B.4A — Memory Quality Dry-Run Addendum Summary

**Phase:** 8B.4A (Bounded Audit Follow-up)
**Date:** 2026-05-01
**Status:** ✅ COMPLETE (audit only — no promotion)
**Report:** `~/offload/security-reports/manual/ruvector-memory-quality-dry-run-addendum-20260501-012653.md`

---

## What Changed Since Phase 8B.4

| Item | Phase 8B.4 (Original) | Phase 8B.4A (Corrected) |
|------|------------------------|----------------------------|
| Manifest check involved | `semantic-manifest-1777588808185.json` (25 chunks) | `semantic-manifest-1777588824357.json` (398 chunks) |
| Gate 6 result | ✅ PASS (wrong manifest) | ✅ PASS (corrected — all fields present) |
| Manifests found | 1 (assumed current) | 3 total (25, 100, 398 chunks) |
| Current prototype size | Unknown / assumed 25 | **398 chunks** (confirmed) |
| Embeddings cache | Not audited | **388 entries** (97.5% of 398) |
| `semantic-approved-docs-memory.json` | Described as "398 records" | **Wrapper dict** with `"chunks"` key (398 items) |
| Gate 1 weak-overlap | ⚠️ WARNING (avg 69.25%) | ⚠️ WARNING (unchanged — `FINAL_POLICY.md` still dominates) |
| Phase 8B.5 promotion | 🚫 BLOCKED | 🚫 BLOCKED (Gate 1 still unresolved) |

---

## Root Cause: Why Gate 6 Was Wrong in Phase 8B.4

**Problem:** Phase 8B.4 checked the **oldest** manifest (`semantic-manifest-1777588808185.json` with 25 chunks) instead of the **latest** (`semantic-manifest-1777588824357.json` with 398 chunks).

**Why it happened:** The glob pattern `semantic-manifest-*.json` returns files in **lexicographic order**, which by timestamp prefix puts the oldest first. Phase 8B.4 logic likely used `head -1` or similar, grabbing the 25-chunk manifest.

**Three manifests exist:**
```
semantic-manifest-1777588808185.json  (25 chunks,  562,860 bytes, 22:40:08)  ← oldest
semantic-manifest-1777588812185.json  (100 chunks, 2,251,320 bytes, 22:40:12) ← mid
semantic-manifest-1777588824357.json  (398 chunks, 8,972,541 bytes, 22:40:24) ← CURRENT ✅
```

**Corrected Gate 6 check:**
```python
import json, glob
files = sorted(glob.glob('/home/lch/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json'))
latest = files[-1]  # Always pick the last (newest by timestamp prefix)
d = json.load(open(latest))
# chunkCount: 398 ✅, model: nomic-embed-text:latest ✅, dimensions: 768 ✅
```

---

## Gate 1 Weak-Overlap Status (Unchanged)

### Queries Re-Checked

**Q1: "What firewall tool does Bazzite use?"**
| Rank | RuVector Source | Stage 3A Source |
|------|-----------------|-----------------|
| 1 | `FINAL_POLICY.md` | `GEMMA_LOCAL_AGENT.md` |
| 2 | `FINAL_POLICY.md` | `OPERATIONS.md` |
| 3 | `FINAL_POLICY.md` | `OPENCODE_GEMMA_NOTES.md` |

**Q2: "Where should generated security reports and logs go?"**
| Rank | RuVector Source | Stage 3A Source |
|------|-----------------|-----------------|
| 1 | `FINAL_POLICY.md` | `GEMMA_LOCAL_AGENT.md` |
| 2 | `chunks.jsonl` (Stage 3A) | `GEMMA_LOCAL_AGENT.md` |
| 3 | `GEMMA_LOCAL_AGENT.md` | `OPERATIONS.md` |

**Problem:** Both return correct answers, but RuVector attributes to `FINAL_POLICY.md` (policy doc) while Stage 3A attributes to operational docs (`GEMMA_LOCAL_AGENT.md`, `OPERATIONS.md`). This is **weak top-source overlap** even though answer content overlaps.

**Gate 1 Result: ⚠️ WARNING — no change from Phase 8B.4**

---

## Phase 8B.5 Promotion Decision (Updated)

### Pre-Promotion Gate Status (Corrected)

| Gate | Phase 8B.4 | Phase 8B.4A (Corrected) | Blocker? |
|------|-------------|----------------------------|----------|
| Gate 1: Similarity ≥70% | ⚠️ WARNING (avg 69.25%) | ⚠️ WARNING (`FINAL_POLICY.md` dominance) | **YES** |
| Gate 2: Validators | ✅ PASS | ✅ PASS (unchanged) | No |
| Gate 3: Drift check | Skipped (dry-run) | Skipped (dry-run) | No |
| Gate 4: Recall ≥80% | Skipped (dry-run) | Skipped (dry-run) | No |
| Gate 5: Latency median <2s | Skipped (dry-run) | Skipped (dry-run) | No |
| Gate 6: Manifest consistency | ✅ PASS (wrong manifest) | ✅ PASS (corrected) | No |

**Decision: 🚫 BLOCKED — Gate 1 weak-overlap remains the sole blocker.**

Gate 6 correction (from wrong-manifest to corrected) removes one warning but does NOT unblock promotion. Gate 1 must be resolved first.

---

## File Inventory (Phase 8B.4A)

### Semantic Prototype Files (Canonical Paths)

| File | Size | Description |
|------|------|-------------|
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` | 8,972,541 bytes | 398 chunks + metadata wrapper |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777588824357.json` | 8,972,541 bytes | **Latest manifest (398 chunks) ✅** |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777588812185.json` | 2,251,320 bytes | Mid-range manifest (100 chunks) — stale |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777588808185.json` | 562,860 bytes | Early manifest (25 chunks) — stale |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json` | 8,063,856 bytes | 388 cached embeddings (97.5%) |

### Report Files (Offload)

| File | Description |
|------|-------------|
| `~/offload/security-reports/manual/ruvector-memory-quality-dry-run-20260501-011559.md` | Phase 8B.4 original report |
| `~/offload/security-reports/manual/ruvector-memory-quality-dry-run-addendum-20260501-012653.md` | **Phase 8B.4A addendum report** |

### Repo-Local Summaries

| File | Description |
|------|-------------|
| `docs/integrations/ruvector/RUVECTOR_PHASE8B4_QUALITY_DRY_RUN_SUMMARY.md` | Phase 8B.4 repo summary (has wrong Gate 6 info) |
| `docs/integrations/ruvector/RUVECTOR_PHASE8B4A_DRY_RUN_ADDENDUM_SUMMARY.md` | **This file** |

---

## Action Items for Phase 8B.5 (When Unblocked)

| # | Action | Blocker |
|---|--------|----------|
| 1 | Investigate why `FINAL_POLICY.md` dominates RuVector semantic search | Gate 1 weak-overlap |
| 2 | Align top-source attribution between RuVector and Stage 3A | Gate 1 weak-overlap |
| 3 | Full Gate 1 re-run (10+ queries, ≥70% threshold) | Required for unblock |
| 4 | Gate 3 (drift check), Gate 4 (recall ≥80%), Gate 5 (latency) | Required for promotion |
| 5 | Clean up stale manifests (25-chunk, 100-chunk) if safe | None (cosmetic) |
| 6 | Document `embeddingProvider` and `prototypeStatus` fields in manifest | None (documentation) |

---

## Sign-off

**Phase 8B.4A Status:** ✅ COMPLETE (bounded audit only)
**Gate 6 Corrected:** ✅ PASS (was wrong in Phase 8B.4 — used 25-chunk manifest)
**Gate 1 Unchanged:** ⚠️ WARNING (still weak-overlap, `FINAL_POLICY.md` dominance)
**Phase 8B.5 Promotion:** 🚫 BLOCKED (Gate 1 unresolved)
**Next Action:** Do not proceed to Phase 8B.5 until Gate 1 weak-overlap is resolved.

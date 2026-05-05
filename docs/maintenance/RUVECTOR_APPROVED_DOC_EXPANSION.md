# RuVector Approved Doc Expansion

## Version
- **gemma-ui:** v1.4.3
- **Date:** 2026-05-04
- **Host:** Bazzite/Fedora Atomic
- **User:** lch
- **Commit:** (to be determined)

## Scope
Supervised approved-doc expansion based on `RUVECTOR_COVERAGE_GAP_REVIEW.md`.
Adds 18 safe documentation files to the RuVector semantic index to close coverage gaps identified in the Memory Mode evaluation.

## Safety Summary
- **No secrets indexed.** All candidate docs scanned for secrets, tokens, passwords, API keys. All matches were policy references, not actual secrets.
- **No raw logs or transcripts indexed.** Only reviewed markdown documentation.
- **No default promotion.** RuVector remains supervised secondary only.
- **Stage 3A fallback preserved.** No changes to Stage 3A index or behavior.
- **No sudo, no packages, no host changes.**

## Approved Docs Added

| # | Doc | Source Path | Covers Gap |
|---|---|---|---|
| 1 | `RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md` | `docs/integrations/ruvector/` | Gap 1: RuVector promotion decision |
| 2 | `M9_RUVECTOR_RETRIEVAL_INTEGRATION_AND_PROMOTION_READINESS.md` | `docs/maintenance/` | Gap 1 |
| 3 | `M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md` | `docs/maintenance/` | Gap 2: Agent Zero boundary |
| 4 | `AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md` | `docs/maintenance/` | Gap 2 |
| 5 | `AGENT_ZERO_SUPERVISED_PROFILE_DESIGN.md` | `docs/maintenance/` | Gap 2 |
| 6 | `M16_LOCAL_DASHBOARD_PIVOT.md` | `docs/maintenance/` | Gap 3: Space Agent boundary |
| 7 | `M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md` | `docs/maintenance/` | Gap 3 |
| 8 | `GEMMA_VOICE_MODE.md` | `docs/maintenance/` | Gap 4: Voice mode boundaries |
| 9 | `GEMMA_UI_FRONT_DOOR.md` | `docs/maintenance/` | Gap 4, 5 |
| 10 | `GEMMA_UI_MEMORY_MODE.md` | `docs/maintenance/` | Gap 5: Repo/memory mode boundaries |
| 11 | `GEMMA_UI_MEMORY_MODE_REGRESSION.md` | `docs/maintenance/` | Gap 5 |
| 12 | `M7_CONTROLLED_TRAINING_READINESS_REVIEW.md` | `docs/maintenance/` | Gap 6: Training boundary |
| 13 | `TRAINING_DATASET_READINESS_CHECKLIST.md` | `docs/maintenance/` | Gap 6 |
| 14 | `CURRENT_STATE.md` | `docs/live-system/` | Gap 7: Live system state |
| 15 | `CANONICAL_PATHS.md` | `docs/live-system/` | Gap 7 |
| 16 | `MEMORY_BOUNDARIES.md` | `docs/workflows/memory/` | Gap 8: Workflow boundaries |
| 17 | `AGENT_ZERO_WORKFLOW_BOUNDARIES.md` | `docs/workflows/agent-zero/` | Gap 8 |
| 18 | `WORKFLOW_BOUNDARY_MATRIX.md` | `docs/workflows/` | Gap 8 |

## Index Refresh

### Before
- **Chunks:** 398
- **Size:** 8.6 MB
- **Last modified:** 2026-04-30 18:40

### After
- **Chunks:** 1635
- **Size:** 35.2 MB
- **Last modified:** 2026-05-04 23:51

### Command Used
```bash
cd ~/projects/gem/prototypes/ruvector-memory
node src/semantic-index-approved-docs.mjs
```

This is the existing approved helper from Phase 7B.2. It:
1. Reads approved docs from `~/.local/share/bazzite-security/gemma-knowledge/docs/`
2. Generates embeddings via Ollama `nomic-embed-text:latest`
3. Writes `semantic-approved-docs-memory.json` and manifest

### Manifest
- **Path:** `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777953083410.json`
- **Chunks indexed:** 1635
- **Cache hits:** 388
- **Cache misses:** 1247

## Validation Results

### Dashboard
```
RuVector:  ✓ 35.2 MB (modified 2026-05-04 23:51)
Manifest:  ✓ 36034.5 KB (modified 2026-05-04 23:51)
```

### Q2: RuVector Promotion Decision
```
ruvector_top_sources: MEMORY_BOUNDARIES.md; ROLLBACK_PROCEDURES.md; ...
source_family_equivalence: 80.0% (improved from 20.0%)
final_recommendation: insufficient_evidence
```
**Assessment:** Improved source-family equivalence (80% vs 20%), but still insufficient evidence for this status query. This is expected — promotion decisions are status queries that require specific production-status terms.

### Q5: Agent Zero Boundary
```
ruvector_top_sources: AGENT_ZERO_WORKFLOW_BOUNDARIES.md; AGENT_ZERO_BOUNDARIES.md; ...
source_family_equivalence: 100.0% (improved)
final_recommendation: use_ruvector_context
confidence: medium
```
**Assessment:** Significant improvement. RuVector now finds Agent Zero boundary docs and recommends using its own context (was `use_stage3a_context` before).

## Deny List (Enforced)
The following were explicitly NOT indexed:
- `.env` files, API tokens, passwords, private keys
- Raw logs from `~/.local/state/bazzite-security/logs/`
- Chat transcripts, voice transcripts
- PCAPs, network dumps
- Browser data, cookies
- Auto-generated artifacts, cache files

## Recommendation

The approved-doc expansion successfully added 18 safe docs, increasing the semantic index from 398 to 1635 chunks. Coverage for Agent Zero boundaries improved significantly (Q5). RuVector promotion queries (Q2) improved source-family equivalence but remain challenging for status-type questions.

**Next steps:**
1. Monitor query performance over the next week
2. Consider adding more RuVector-specific integration docs if Q2 remains partial
3. Stage 3A fallback continues to handle exact policy/path questions reliably

## Signoff
- **Expansion performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-04
- **gemma-ui version:** v1.4.3
- **RuVector status:** supervised secondary (unchanged)
- **Stage 3A status:** canonical fallback (unchanged)

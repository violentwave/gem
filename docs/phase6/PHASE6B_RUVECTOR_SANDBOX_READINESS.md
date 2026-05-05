# Phase 6B: RuVector Sandbox Readiness Review

## Version
- **Date:** 2026-05-05
- **Host:** Bazzite/Fedora Atomic
- **User:** lch
- **gemma-ui:** v1.4.3
- **Repo:** ~/projects/gem
- **Classification:** Read-Only Assessment / No Authority Granted

## Scope
Read-only sandbox readiness review for RuVector in the Bazzite Local AI Operations Stack.
This document assesses whether RuVector (as a supervised semantic retrieval prototype) is in a safe state for continued supervised use.

## Safety Rules
- **No authority granted to RuVector.**
- **No root/system/security write authority.**
- **RuVector must not become the security control plane.**
- **No sudo, no packages, no host changes.**
- **No new data ingested in this phase.**
- **No index rebuilt in this phase.**
- **No promotion to default retrieval path.**
- **No secrets exposed.**

## Current Status

### Prototype Package
| Attribute | Value |
|-----------|-------|
| Package Name | `ruvector-memory-prototype` v0.1.0 |
| Dependency | `ruvector` v0.2.25 |
| Location | `~/projects/gem/prototypes/ruvector-memory/` |
| node_modules Size | 50 MB |
| package-lock.json | Present |

### Semantic Index State
| Attribute | Value |
|-----------|-------|
| Index Path | `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` |
| Index Size | 36 MB |
| Chunks | 1,635 |
| Embedding Model | `nomic-embed-text:latest` (768 dimensions) |
| Ollama Endpoint | `http://127.0.0.1:11434` |
| Last Modified | 2026-05-04 23:51 |

### Manifest Files
| File | Size | Modified | Chunks |
|------|------|----------|--------|
| `semantic-manifest-1777953083410.json` | 36 MB | 2026-05-04 23:51 | 1,635 (current) |
| `semantic-manifest-1777588824357.json` | 8.6 MB | 2026-04-30 18:40 | 398 (previous) |
| `semantic-manifest-1777588812185.json` | 2.2 MB | 2026-04-30 18:40 | 100 (previous) |
| `semantic-manifest-1777588808185.json` | 550 KB | 2026-04-30 18:40 | 25 (previous) |

### Approved Docs (Indexed Sources)
| Source | Purpose |
|--------|---------|
| `AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md` | Agent Zero compatibility limits |
| `AGENT_ZERO_SUPERVISED_PROFILE_DESIGN.md` | Supervised profile design |
| `AGENT_ZERO_WORKFLOW_BOUNDARIES.md` | Workflow boundaries |
| `CANONICAL_PATHS.md` | Canonical path policy |
| `CURRENT_STATE.md` | Live system state |
| `GEMMA_UI_FRONT_DOOR.md` | UI front door docs |
| `GEMMA_UI_MEMORY_MODE.md` | Memory mode docs |
| `GEMMA_UI_MEMORY_MODE_REGRESSION.md` | Regression closeout |
| `GEMMA_VOICE_MODE.md` | Voice mode docs |
| `M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md` | M15 review |
| `M16_LOCAL_DASHBOARD_PIVOT.md` | Dashboard pivot |
| `M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md` | Provider reality check |

### Helper Scripts
| Script | Status | Purpose |
|--------|--------|---------|
| `gemma-memory-search` | ✅ Present | Supervised RuVector semantic search + Stage 3A comparison |
| `gemma-memory-rag` | ✅ Present | Supervised RAG using RuVector context + Ollama generation |
| `gemma-knowledge-search` | ✅ Present | Stage 3A deterministic fallback (canonical) |
| `gemma-knowledge-rag` | ✅ Present | Stage 3A RAG fallback (canonical) |

### Prototype Scripts (Node.js)
| Script | Purpose |
|--------|---------|
| `src/semantic-index-approved-docs.mjs` | Build semantic index (supervised use only) |
| `src/semantic-query-approved-docs.mjs` | Query semantic index |
| `src/semantic-compare-stage3a.mjs` | Compare RuVector vs Stage 3A |
| `src/semantic-common.mjs` | Shared constants and utilities |

### Data Flow
```
Approved Docs ──► semantic-index-approved-docs.mjs ──► Ollama (nomic-embed-text)
                                                           │
                                                           ▼
                                              semantic-approved-docs-memory.json
                                                           │
                              ┌────────────────────────────┼────────────────────────────┐
                              │                            │                            │
                              ▼                            ▼                            ▼
                   gemma-memory-search           gemma-memory-rag              gemma-ui /memory
                   (supervised search)          (supervised RAG)              (dashboard)
                              │                            │
                              ▼                            ▼
                   Stage 3A comparison           Ollama answer generation
                   (deterministic fallback)      (gemma4-e4b-bazzite:latest)
```

## Security Findings

### ✅ No Network Exposure
- RuVector operates entirely within the prototype directory and local data paths.
- No server, daemon, or listening port is created by RuVector itself.
- The only network call is to local Ollama (`127.0.0.1:11434`) for embeddings.

### ✅ No System Write Authority
- All writes are confined to:
  - `~/.local/share/bazzite-security/ruvector/`
  - `~/offload/security-reports/manual/`
  - `~/.local/state/bazzite-security/logs/`
- No system config files are modified.
- No sudo is required.

### ✅ Scoped Ingestion Only
- Only approved docs from `~/.local/share/bazzite-security/gemma-knowledge/docs/` are indexed.
- Explicit deny list excludes secrets, logs, cache, browser data, private code.
- No automatic or background ingestion.

### ✅ No Persistent Service
- RuVector is a Node.js library consumed by prototype scripts.
- No systemd timer, cron job, or daemon runs RuVector.
- Indexing is manual and supervised only.

### ⚠️ Large Index File (36 MB)
- The semantic index is a single 36 MB JSON file.
- **Risk:** Large file I/O on every search.
- **Mitigation:** Search is bounded (TOP_N ≤ 5). The index is loaded once per invocation.

### ⚠️ Stale Manifests Accumulating
- Four manifest files exist (25, 100, 398, 1,635 chunks).
- Oldest manifests consume ~11 MB combined.
- **Mitigation:** Manual cleanup can be performed. No automatic purging is configured.

### ⚠️ Writable Data Directory
- `~/.local/share/bazzite-security/ruvector/` is writable by the user.
- **Risk:** Accidental or malicious index corruption.
- **Mitigation:** Index is rebuilt from approved docs only. Rollback bundle includes index backup.

## Known Limitations

### Supervised Secondary Only
- RuVector is NOT the default retrieval path.
- Stage 3A remains the canonical fallback.
- `gemma-memory-search` and `gemma-memory-rag` are helpers, not wrapper defaults.

### Embedding Dependency
- Requires `nomic-embed-text:latest` (768d) via Ollama.
- If Ollama is down, embeddings cannot be generated.
- **Mitigation:** Stage 3A fallback works without Ollama embeddings.

### No Real-Time Updates
- Index is static until manually rebuilt.
- New docs require explicit supervised approval and manual re-indexing.
- No watch-mode or auto-refresh.

### Prototype-Only Status
- `ruvector` v0.2.25 is an npm package; no formal security audit of the package has been performed.
- The prototype is not production-hardened.

## What Must Not Be Granted

| Authority | Status | Reason |
|-----------|--------|--------|
| Default retrieval path | ❌ Denied | Stage 3A remains canonical fallback |
| Autonomous ingestion | ❌ Denied | All ingestion requires human approval |
| Background indexing | ❌ Denied | No timers, no daemons, no auto-rebuild |
| System config changes | ❌ Denied | No rpm-ostree, firewall, SSH changes |
| Secret access | ❌ Denied | `.env` and secrets are excluded from indexing |
| Network exposure | ❌ Denied | No server port opened by RuVector |
| Package installation | ❌ Denied | No new npm packages without review |
| Production promotion | ❌ Denied | Remains supervised prototype |

## Explicit "No Authority Granted" Statement

**RuVector has been granted NO authority in this assessment.**

- No new data was ingested in this phase.
- No index was rebuilt in this phase.
- No system commands were executed via RuVector.
- No files were modified by RuVector in this phase.
- No network routes were opened for RuVector.
- No secrets were read from excluded paths.
- RuVector remains a supervised secondary retrieval source.
- Stage 3A remains the canonical fallback.

## Prior Docs Record

### Phase 5D: RuVector Assessment
- **Date:** Prior to 2026-05-02
- **Status:** COMPLETE
- **Key finding:** RuVector is feasible as local-only prototype
- **File:** `docs/integrations/ruvector/RUVECTOR_INTEGRATION_PLAN.md`

### Phase 7B.2: RuVector Semantic Prototype
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Key finding:** Semantic prototype working with nomic-embed-text
- **File:** `docs/integrations/ruvector/RUVECTOR_PHASE7B2_SEMANTIC_PROTOTYPE_SUMMARY.md`

### Phase 8B.5: Memory Production Promotion Review
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Decision:** `promotion_review_approved_secondary`
- **File:** `docs/integrations/ruvector/RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md`

### Phase 8B.6-8B.7: Supervised Search and RAG Helpers
- **Date:** 2026-05-02
- **Status:** COMPLETE
- **Helpers:** `gemma-memory-search`, `gemma-memory-rag`
- **Files:**
  - `docs/integrations/ruvector/RUVECTOR_PHASE8B6_PRIMARY_SUPERVISED_HELPER_SUMMARY.md`
  - `docs/integrations/ruvector/RUVECTOR_PHASE8B7_SUPERVISED_RAG_SUMMARY.md`

### RuVector Coverage Gap Review
- **Date:** 2026-05-04
- **Status:** COMPLETE
- **Gaps identified:** 8
- **Docs expanded:** 18 approved docs added
- **File:** `docs/maintenance/RUVECTOR_COVERAGE_GAP_REVIEW.md`

### RuVector Approved-Doc Expansion
- **Date:** 2026-05-04
- **Status:** COMPLETE
- **Index grew:** 398 → 1,635 chunks
- **File:** `docs/maintenance/RUVECTOR_APPROVED_DOC_EXPANSION.md`

## Readiness Verdict

### ✅ Ready for Supervised Semantic Retrieval
- Prototype is operational and bounded.
- Helpers provide safe search and RAG with Stage 3A fallback.
- Index is scoped to approved docs only.
- No network exposure, no daemon, no auto-ingestion.

### ⚠️ Prototype-Only — Not Production-Hardened
- Large single-file index (36 MB).
- No formal security audit of `ruvector` npm package.
- Stale manifests accumulate.
- Embedding dependency on Ollama.

### ❌ Not Ready for Default Retrieval or Autonomous Use
- Must remain supervised secondary.
- Stage 3A must remain canonical fallback.
- No automatic indexing or promotion.
- No background service or daemon.

## Next Dry-Run Criteria

### Phase 6B.1: Stale Manifest Cleanup
- [ ] Identify which manifest files are safe to delete
- [ ] Preserve at least one rollback manifest
- [ ] Delete stale manifests (25, 100, 398 chunk versions)
- [ ] Verify current manifest remains intact

### Phase 6B.2: Index Integrity Verification
- [ ] Run `gemma-memory-search` with 4 test queries
- [ ] Verify all 4 queries return relevant results
- [ ] Verify Stage 3A fallback triggers correctly
- [ ] Verify no errors in logs

### Phase 6B.3: Prototype Dependency Audit
- [ ] Review `ruvector` npm package dependencies
- [ ] Check for known vulnerabilities (if audit tool available)
- [ ] Document dependency tree

### Phase 6B.4: RuVector Stage 3A Coexistence Test
- [ ] Run `gemma-memory-search` and `gemma-knowledge-search` for same query
- [ ] Verify both return results without conflict
- [ ] Verify no port or file lock conflicts

## Signoff
- **Review performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **gemma-ui version:** v1.4.3
- **RuVector index status:** 1,635 chunks, 36 MB, supervised secondary
- **No new ingestion:** Confirmed
- **No index rebuild:** Confirmed
- **No authority granted:** Confirmed
- **Next phase:** Phase 6B.1 Stale Manifest Cleanup (requires human approval)

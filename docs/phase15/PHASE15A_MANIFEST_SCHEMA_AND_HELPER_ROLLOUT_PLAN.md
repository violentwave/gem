# Phase 15A: Manifest Schema and Helper Rollout Plan

**Phase:** 15A — Manifest Schema and Helper Rollout Plan
**Date:** 2026-05-02
**Parent:** Phase 15 (Production Hardening)
**Status:** COMPLETE

---

## Purpose

Define a unified manifest schema for tracking helpers, knowledge packs, evals, and semantic memory; create a rollout plan for new helper deployment.

---

## Current Helper Inventory

| # | Helper | Category | Description | Language |
|---|--------|----------|-------------|----------|
| 1 | gemma-bazzite | Core | Main Gemma wrapper with system prompt | Bash |
| 2 | gemma-bazzite-health | Core | Health check for Gemma/Ollama | Bash |
| 3 | gemma-benchmark-context | Dev | Context window benchmarking | Bash |
| 4 | gemma-command-review | Security | Command safety review | Bash |
| 5 | gemma-evals-check | Validation | Eval case validator | Bash |
| 6 | gemma-evals-status | Validation | Eval/example status reporter | Bash |
| 7 | gemma-examples-check | Validation | Supervised example validator | Bash |
| 8 | gemma-examples-review-drafts | Validation | Draft example reviewer | Bash |
| 9 | gemma-file-brief | Utility | File content brief generator | Bash |
| 10 | gemma-knowledge-ask | RAG | Knowledge pack RAG query | Bash |
| 11 | gemma-knowledge-check | Validation | Knowledge pack validator | Bash |
| 12 | gemma-knowledge-index | RAG | Knowledge pack indexer | Bash |
| 13 | gemma-knowledge-rag | RAG | Deterministic RAG helper | Bash |
| 14 | gemma-knowledge-refresh | RAG | Knowledge pack refresher | Bash |
| 15 | gemma-knowledge-search | RAG | Stage 3A deterministic search | Bash |
| 16 | gemma-memory-rag | RAG | RuVector + Ollama RAG (new) | Python |
| 17 | gemma-memory-search | RAG | RuVector semantic search (new) | Python |
| 18 | gemma-opencode-check | Integration | OpenCode bridge check | Bash |
| 19 | gemma-open-code-status | Integration | OpenCode status reporter | Bash |
| 20 | gemma-repo-brief | Utility | Repo brief generator | Bash |
| 21 | gemma-security-summary | Security | Security summary generator | Bash |
| 22 | gemma-security-summary-check | Security | Security summary validator | Bash |

**Total:** 22 helpers
**Bash:** 20
**Python:** 2 (memory-search, memory-rag)

---

## Unified Manifest Schema

### Schema Definition (JSON)

```json
{
  "manifest_version": "1.0",
  "generated_at": "2026-05-02T12:00:00Z",
  "generator": "gemma-manifest-generator",
  "categories": {
    "helper": {
      "description": "Executable helper scripts",
      "canonical_path": "~/.local/bin/",
      "required_fields": ["name", "version", "path", "checksum", "language", "category", "description"],
      "optional_fields": ["dependencies", "config_files", "log_path", "report_path"]
    },
    "knowledge_pack": {
      "description": "Curated knowledge documents",
      "canonical_path": "~/.local/share/bazzite-security/gemma-knowledge/",
      "required_fields": ["name", "version", "path", "checksum", "doc_count", "chunk_count"],
      "optional_fields": ["index_path", "manifest_path", "last_indexed"]
    },
    "eval_suite": {
      "description": "Eval cases and supervised examples",
      "canonical_path": "~/.local/share/bazzite-security/gemma-evals/",
      "required_fields": ["name", "version", "case_count", "example_count", "coverage_categories"],
      "optional_fields": ["manifest_path", "last_validated", "validation_result"]
    },
    "semantic_memory": {
      "description": "RuVector semantic prototype",
      "canonical_path": "~/.local/share/bazzite-security/ruvector/",
      "required_fields": ["name", "version", "chunk_count", "embedding_model", "dimensions"],
      "optional_fields": ["manifest_path", "last_indexed", "fallback_enabled"]
    }
  }
}
```

### Helper Manifest Entry Example

```json
{
  "name": "gemma-memory-search",
  "version": "1.0",
  "path": "~/.local/bin/gemma-memory-search",
  "checksum": "sha256:...",
  "language": "python",
  "category": "rag",
  "description": "Supervised RuVector semantic search with Stage 3A fallback",
  "dependencies": ["python3", "ollama"],
  "config_files": [],
  "log_path": "~/.local/state/bazzite-security/logs/gemma-memory-search-*.log",
  "report_path": "~/offload/security-reports/manual/gemma-memory-search-*.md",
  "created_date": "2026-05-01",
  "author": "OpenCode",
  "status": "active"
}
```

---

## Helper Categories

| Category | Count | Helpers |
|----------|-------|---------|
| Core | 2 | gemma-bazzite, gemma-bazzite-health |
| Security | 3 | gemma-command-review, gemma-security-summary, gemma-security-summary-check |
| Validation | 4 | gemma-evals-check, gemma-evals-status, gemma-examples-check, gemma-examples-review-drafts |
| RAG | 7 | gemma-knowledge-ask, gemma-knowledge-index, gemma-knowledge-rag, gemma-knowledge-refresh, gemma-knowledge-search, gemma-memory-rag, gemma-memory-search |
| Integration | 2 | gemma-opencode-check, gemma-open-code-status |
| Utility | 2 | gemma-file-brief, gemma-repo-brief |
| Dev | 1 | gemma-benchmark-context |
| Backup | 1 | gemma-security-summary.v1.bak |

---

## Rollout Plan for New Helpers

### Phase 1: Design (Documentation)
1. Define helper purpose and scope
2. Identify category and dependencies
3. Document approved/denied paths
4. Create pseudocode/flow diagram
5. Define exit codes and error handling

### Phase 2: Review (Human Approval)
1. Submit helper design for review
2. Verify no duplicate functionality
3. Check canonical path compliance
4. Verify no secrets hardcoded
5. Approve implementation

### Phase 3: Implementation
1. Write helper in appropriate language (prefer Bash for simple, Python for complex)
2. Add shebang, chmod +x
3. Add header comment with version, date, description
4. Test locally with known inputs

### Phase 4: Validation
1. Run against existing eval cases
2. Run gemma-evals-check
3. Run gemma-examples-check
4. Verify no regressions
5. Document test results

### Phase 5: Deployment
1. Copy to ~/.local/bin/
2. Update manifest
3. Update CURRENT_STATE.md
4. Update ROADMAP.md
5. Commit to repo

### Phase 6: Monitoring
1. Monitor logs for 7 days
2. Collect usage statistics
3. Address any issues
4. Update documentation

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Helper inventory complete | PASS | 22 helpers documented |
| Manifest schema defined | PASS | JSON schema with 4 categories |
| Rollout plan defined | PASS | 6-phase rollout |
| Categories assigned | PASS | 8 categories |
| Python helpers tracked | PASS | 2 Python helpers identified |
| Backup files noted | WARN | 1 .bak file exists |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 1 |
| FAIL | 0 |

---

## Sign-Off

- Phase 15A: COMPLETE
- Manifest schema: DEFINED
- Rollout plan: DOCUMENTED
- Helper inventory: COMPLETE (22 helpers)
- Next: Phase 15B (Repo-Local Drift and Safety Validators)

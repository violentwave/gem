# RuVector Phase 7B.2 Semantic Prototype Report

**Generated:** 2026-04-30T22:40:26Z
**Decision:** `semantic_prototype_working`
**Production status:** Scoped semantic prototype working; production memory still pending quality hardening.

## Scope

Phase 7B.2 built a bounded semantic retrieval prototype using the already-installed local Ollama embedding model `nomic-embed-text:latest`. It kept the Phase 7B placeholder-vector prototype intact and added separate semantic scripts, output paths, and comparison reports.

No sudo, system package changes, npm global installs, model pulls, Ollama config changes, Agent Zero starts, or Space Agent tasks were performed.

## Prototype Location

- Prototype path: `~/projects/gem/prototypes/ruvector-memory/`
- Package: `ruvector`
- Installed version: `0.2.25`
- Embedding provider: local Ollama native embeddings API
- Embedding model: `nomic-embed-text:latest`
- Embedding dimensions: `768`

## Approved Inputs

Indexed inputs were limited to:

- `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md`
- `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`, limited to the first 50 Stage 3A chunks

No broad roots were indexed. Excluded classes include secrets, `.env` files, raw logs, browser data, private code, unredacted transcripts, `~/projects`, and `~/offload/security-reports`.

## Scripts Created

- `prototypes/ruvector-memory/src/semantic-common.mjs`
- `prototypes/ruvector-memory/src/semantic-index-approved-docs.mjs`
- `prototypes/ruvector-memory/src/semantic-query-approved-docs.mjs`
- `prototypes/ruvector-memory/src/semantic-compare-stage3a.mjs`

Package scripts added:

- `npm run semantic:index`
- `npm run semantic:query`
- `npm run semantic:compare`

## Persistent Output

Semantic prototype artifacts:

- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json`
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json`
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777588808185.json`
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777588812185.json`
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-1777588824357.json`

Reports:

- `prototypes/ruvector-memory/reports/semantic-comparison-2026-04-30T22-40-26.md`
- `~/offload/security-reports/manual/ruvector-semantic-comparison-2026-04-30T22-40-26.md`

## Staged Index Results

The prototype was run in bounded stages as requested:

| Stage | Result | Cache Behavior |
|-------|--------|----------------|
| 25 chunks | PASS | 0 hits, 25 misses |
| 100 chunks | PASS | 25 hits, 75 misses |
| Full approved set | PASS | 123 hits, 275 misses |

Final full index:

- Total chunks: 398
- Approved-doc chunks: 348
- Stage 3A chunks included: 50
- Model: `nomic-embed-text:latest`
- Dimensions: 768
- Vector type: local Ollama semantic embedding

## Query Test Summary

Manual surface checks were run through the prototype query command after staged indexing:

- 25-chunk query: `What is the safe operating model for local Gemma?` PASS
- 100-chunk query: `Where should generated security reports go?` PASS

The 100-chunk query correctly ranked `FINAL_POLICY.md` chunk text for exported security reports first.

## Stage 3A Comparison Summary

The final comparison used 10 Stage 4 knowledge/path queries.

- Evaluation queries: 10
- Source overlap range: 25.0% - 100.0%
- Average source overlap: 57.5%
- Highest overlap: `rag-001`, `path-002` at 100.0%
- Lowest overlap: `rag-005` at 25.0%

This is a meaningful improvement over placeholder vectors because it uses real local embeddings, but it is still a prototype quality result. Stage 3A remains the canonical fallback until semantic retrieval is hardened and scored against explicit expected-source rules.

## Fallback Behavior

Stage 3A deterministic retrieval remains canonical fallback.

Fallback conditions:

- Ollama unavailable
- `nomic-embed-text:latest` missing
- Embedding API error
- Semantic index missing/corrupt
- Semantic comparison quality gate failure
- Any ingestion boundary violation

## Issues And Risks

- Semantic output is stored as JSON prototype artifacts, not a production vector-store contract.
- Quality is promising but not production-proven; minimum source overlap was 25.0%.
- Query/source evaluation should become stricter before promotion.
- `nomic-embed-text` dimensions are 768, so placeholder 384-dimensional scripts remain separate.
- Caching works, but cache invalidation is currently content-hash/model-tag based only.

## Validators

Final validators:

- `lsp_diagnostics` on changed semantic scripts: PASS
- Semgrep scan on changed semantic scripts: PASS, no findings; Semgrep emitted internal engine warnings for several rules
- `npm run semantic:index -- --limit 25`: PASS
- `npm run semantic:index -- --limit 100`: PASS
- `npm run semantic:index`: PASS
- `npm run semantic:query -- "What firewall tool does Bazzite use?"`: PASS
- `npm run semantic:compare`: PASS
- `gemma-evals-status`: PASS
- `gemma-evals-check`: PASS
- `gemma-examples-check`: PASS
- `gemma-knowledge-search "What is the safe operating model for local Gemma?"`: PASS

## Readiness Decision

`semantic_prototype_working`

The Phase 7B.2 semantic prototype works at prototype level: it embeds approved chunks using the existing local `nomic-embed-text:latest` model, caches embeddings, queries semantic results, compares against Stage 3A, and preserves fallback behavior.

It is not production semantic memory yet. Promotion requires stricter quality scoring, fallback tests, and a stable storage/query contract.

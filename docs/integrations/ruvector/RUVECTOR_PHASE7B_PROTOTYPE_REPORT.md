# RuVector Phase 7B Prototype Report

**Generated:** 2026-04-30T21:35:01Z
**Decision:** `ruvector_memory_prototype_working`
**Production status:** Prototype only; not production-ready semantic memory.

## Scope

Phase 7B tested a scoped RuVector memory prototype for approved Bazzite/Gemma knowledge docs. The prototype validates local package wiring, scoped ingestion, persistent output, query execution, and comparison against the existing Stage 3A deterministic retrieval fallback.

## Prototype Location

- Prototype path: `~/projects/gem/prototypes/ruvector-memory/`
- Package: `ruvector`
- Version requested in prototype: `^0.2.25`
- Installed package version: `0.2.25`

## Approved Inputs

Indexed inputs were limited to:

- `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md`
- `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` limited to the first 50 Stage 3A chunks

Approved docs indexed:

- `FINAL_POLICY.md`
- `GEMMA_LOCAL_AGENT.md`
- `OPENCODE_GEMMA_NOTES.md`
- `OPERATIONS.md`
- `PATHS.md`
- `RUNBOOK.md`

Excluded paths and data classes:

- `~/.config/bazzite-security/.env`
- `~/.local/state/bazzite-security/logs/`
- `~/.cache/`
- Browser data
- Private code
- Broad project roots, including `~/projects`
- Broad report roots, including `~/offload/security-reports`
- Raw reports
- Unredacted transcripts
- Agent Zero memory
- Space Agent storage

## Persistent Output

Persistent prototype data is under:

- `~/.local/share/bazzite-security/ruvector/approved-docs-memory.json`
- `~/.local/share/bazzite-security/ruvector/manifest-1777584433945.json`
- `~/.local/share/bazzite-security/ruvector/manifest-1777584876995.json`

Latest comparison reports:

- `~/projects/gem/prototypes/ruvector-memory/reports/comparison-2026-04-30T21-34-39.md`
- `~/offload/security-reports/manual/ruvector-comparison-2026-04-30T21-34-39.md`

## Scripts Created

- `prototypes/ruvector-memory/src/index-approved-docs.mjs`
- `prototypes/ruvector-memory/src/query-approved-docs.mjs`
- `prototypes/ruvector-memory/src/compare-stage3a.mjs`

The scripts now pass local LSP/Biome diagnostics.

## Index Results

Final `npm run index` result:

- Approved Markdown files: 6
- Approved-doc chunks: 348
- Stage 3A chunks included: 50
- Total chunks indexed: 398
- Vector dimensions: 384
- Vector type: `placeholder-hash`

Real semantic embeddings were not used. The prototype used deterministic hash vectors as placeholders. These vectors prove indexing, persistence, and query plumbing, but they do not prove semantic retrieval quality.

## Query Test Summary

The following prototype queries executed successfully:

- `What is the safe operating model for local Gemma?`
- `Which files are canonical source docs?`
- `Where should generated security reports and logs go?`

Each query loaded `398` chunks from `approved-docs-memory.json` and returned top results. The outputs were deterministic, but the selected sources show the expected limitation: placeholder-vector ranking is not equivalent to semantic relevance.

## Stage 3A Comparison Summary

The final comparison ran 5 test queries against RuVector placeholder retrieval and Stage 3A deterministic retrieval.

Observed overlap range:

- Minimum source overlap: 25.0%
- Maximum source overlap: 40.0%

Key observation:

- Placeholder vectors can produce repeatable ranking and source overlap, but they do not prove semantic memory quality.
- Stage 3A remains the canonical fallback and the reliable deterministic retrieval path.

## Validators

Final validators run:

- `npm run index`: PASS
- `npm run query "What is the safe operating model for local Gemma?"`: PASS
- `npm run query "Which files are canonical source docs?"`: PASS
- `npm run query "Where should generated security reports and logs go?"`: PASS
- `npm run compare`: PASS
- `gemma-evals-status`: PASS
- `gemma-evals-check`: PASS
- `gemma-examples-check`: PASS
- `gemma-knowledge-search "What is the safe operating model for local Gemma?"`: PASS
- LSP/Biome diagnostics on prototype scripts: PASS

## Fallback Behavior

Stage 3A deterministic retrieval remains the canonical fallback.

RuVector is not promoted to primary semantic retrieval in this phase. If RuVector is unavailable, weakly relevant, or unverified, routing should continue to use Stage 3A.

## Issues And Risks

- Placeholder vectors only; no real semantic embedding model is integrated.
- Semantic retrieval quality is unproven.
- Stage 4 evals/examples have not been used to score semantic retrieval quality.
- No local embedding strategy has been selected.
- RuVector API surface is broad and should remain scoped to explicitly approved ingestion/query paths.
- Persistent data currently stores prototype JSON manifests, not a production vector store contract.

## Readiness Decision

`ruvector_memory_prototype_working`

The Phase 7B prototype works at prototype level: it indexes approved docs, persists output under the approved user-local path, runs query scripts, compares against Stage 3A, and preserves the Stage 3A fallback.

It is not production-ready until:

- A local embedding strategy is selected.
- Semantic retrieval quality is tested against Stage 4 evals/examples.
- Ingestion remains scoped to approved knowledge docs and explicitly approved memory sources.
- Stage 3A fallback behavior remains intact.
- No secrets, raw logs, browser data, broad project roots, or private code are indexed.

## Recommended Next Phase

Run the future prompt at:

- `prompts/opencode/phase7b1-ruvector-embedding-strategy.prompt.txt`

Purpose: design local embedding options and semantic retrieval evaluation before implementation.

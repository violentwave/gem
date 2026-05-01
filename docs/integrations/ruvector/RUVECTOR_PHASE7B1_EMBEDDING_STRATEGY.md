# RuVector Phase 7B.1 Embedding Strategy

**Generated:** 2026-04-30T22:07:00Z
**Decision:** `ready_for_semantic_embedding_prototype`
**Production status:** Design complete; production semantic memory still pending.

## Current State

Phase 7B completed a scoped RuVector prototype at `~/projects/gem/prototypes/ruvector-memory/` using `ruvector@0.2.25`. It indexed 398 chunks from 6 approved knowledge docs plus 50 Stage 3A chunks and persisted prototype JSON under `~/.local/share/bazzite-security/ruvector/`.

That prototype used deterministic placeholder/hash vectors. It proved indexing, persistence, and query plumbing, but did not prove semantic retrieval quality.

## Local Embedding Availability

Safe local model metadata checks found:

| Model | Present | Notes |
|-------|---------|-------|
| `nomic-embed-text:latest` | Yes | Ollama model, `nomic-bert`, 137M, F16, 274 MB |
| `bge-m3` | No | Not installed |
| `e5` | No | Not installed |
| `mxbai-embed-large` | No | Not installed |

Other local models present:

- `gemma4-e4b-bazzite:latest`
- `gemma4:e4b`

No models were downloaded or pulled.

## Ollama Embeddings Feasibility

Ollama is reachable locally:

- Native API: `http://127.0.0.1:11434/api`
- OpenAI-compatible API: `http://127.0.0.1:11434/v1`
- Version endpoint reported: `0.22.0`

A tiny embedding probe was performed with `nomic-embed-text` and the prompt `Bazzite Local AI Operations Stack`.

Result:

- HTTP status: 200
- Embedding returned: yes
- Embedding dimensions: 768

This makes the first semantic prototype feasible without downloading any model.

## RuVector / ONNX Feasibility

The installed `ruvector@0.2.25` package exposes local embedding-related exports, including:

- `OnnxEmbedder`
- `OptimizedOnnxEmbedder`
- `initOnnxEmbedder`
- `initOptimizedOnnx`
- `isOnnxAvailable`
- `embed`
- `embedBatch`
- `EmbeddingService`

ONNX remains feasible as a future local-only path, but this phase did not install packages, download ONNX models, or create model files. ONNX should be evaluated only after selecting an approved local model artifact and storage path.

## Options Compared

| Option | Status | Pros | Risks |
|--------|--------|------|-------|
| Ollama embeddings with `nomic-embed-text` | Ready for prototype | Already installed, local-only endpoint, tiny probe passed | Depends on Ollama availability; dimensions are 768, not the current placeholder 384 |
| RuVector ONNX embedder | Design candidate | Local-only and package-supported | Needs approved model artifact; not tested without downloads |
| Stage 3A deterministic retrieval | Canonical fallback | Proven, fast, no embeddings | Keyword-based, not semantic |
| Placeholder hash vectors | Keep for plumbing tests only | Deterministic and dependency-free | Not semantic; unsuitable for quality claims |

## Recommended First Semantic Path

Use existing `nomic-embed-text:latest` through Ollama's native embeddings API for the next scoped prototype.

Recommended prototype constraints:

- Keep ingestion limited to approved knowledge docs and explicit Stage 3A chunks.
- Store semantic output separately from placeholder output, for example under `~/.local/share/bazzite-security/ruvector/semantic-prototype/`.
- Use vector dimension `768` to match `nomic-embed-text`.
- Do not replace Stage 3A routing.
- Keep placeholder-vector scripts available for API/persistence regression checks only.

## Retrieval Quality Test Plan

Evaluate semantic retrieval against:

- Stage 4 knowledge RAG eval cases
- Stage 4 supervised RAG examples
- Stage 3A deterministic retrieval output

Suggested pass criteria for a prototype gate:

- For each knowledge/path-policy query, top 5 semantic results include at least one expected approved source document.
- Semantic retrieval must match or improve source relevance over Stage 3A on a majority of Stage 4 knowledge cases.
- Any semantic miss must fall back cleanly to Stage 3A.
- No result may come from unapproved paths.
- No secrets, raw logs, browser data, broad project roots, or private code may be indexed.

Suggested comparison outputs:

- Query
- Expected source/category
- Stage 3A top sources
- Semantic top sources
- Overlap
- Pass/fail
- Fallback used

## Fallback Plan

Stage 3A remains canonical fallback.

Fallback conditions:

- Ollama is unavailable.
- `nomic-embed-text` is missing.
- Embedding API returns an error.
- Semantic index is missing or corrupt.
- Semantic retrieval quality fails the Stage 4 comparison gate.
- Any ingestion boundary violation is detected.

## Security Boundaries

- No sudo.
- No system package changes.
- No model downloads without explicit approval.
- No Ollama config changes.
- No Agent Zero or Space Agent runtime dependency.
- No broad indexing of `~/projects` or `~/offload/security-reports`.
- No secrets, `.env`, cookies, raw logs, browser data, private code, or unredacted transcripts.

## Implementation Prerequisites

- Create a separate semantic prototype script rather than changing the placeholder prototype in place.
- Record dimensions and model name in the manifest.
- Add semantic-vs-Stage-3A comparison report generation.
- Keep generated runtime artifacts under `~/.local/share/bazzite-security/ruvector/` and reports under `~/offload/security-reports/manual/`.

## No-Go Conditions

- No installed local embedding model.
- Embedding API failure.
- Need to download a model without explicit approval.
- Need to index broad filesystem roots.
- Any request to copy or print secrets.
- Semantic retrieval cannot fall back to Stage 3A.

## Readiness Decision

`ready_for_semantic_embedding_prototype`

The host already has `nomic-embed-text:latest`, and a tiny Ollama embedding probe returned a 768-dimensional embedding. The next phase can build a scoped semantic prototype using this existing local model, but production semantic memory remains pending quality evaluation.

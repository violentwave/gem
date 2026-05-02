# RuVector Integration Plan

## Status

**Current Implementation:** Phase 7B.2 semantic prototype working; JSON/cosine prototype NOT production VectorDB
**Embedding Model:** `nomic-embed-text:latest` (768 dimensions)
**Storage:** JSON prototype files under `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
**Fallback:** Stage 3A deterministic retrieval remains canonical

## Overview

This document outlines the integration plan for RuVector into the Bazzite Local AI Operations Stack.

**Status:** Phase 7B.2 semantic prototype working; production memory still pending quality hardening
**Goal:** Define scoped integration approach for RuVector after semantic retrieval quality is production-proven

## Assumptions

This plan assumes Phase 5D assessment determines RuVector is:
- Compatible with Bazzite/Fedora Atomic
- Able to run local-only
- Self-learning can be scoped/disabled
- Integration is feasible

## Integration Goals

1. **Vector Search:** Enable semantic search over knowledge base
2. **Memory System:** Provide long-term memory for agents
3. **Hybrid Search:** Combine BM25 keyword + vector semantic search
4. **Memory Graphs:** Support relationship tracking between memories

## Integration Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│  OpenCode / Agent Zero                                      │
│  (Orchestration Layer)                                      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  RuVector Connector                                         │
│  (API Wrapper / Client)                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  RuVector Service / Library                                 │
│  - HNSW Index                                               │
│  - Vector DB                                                │
│  - Memory Graph                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Persistent Storage                                         │
│  ~/.local/share/bazzite-security/ruvector/                  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Knowledge Ingestion

```
Knowledge Pack → RuVector Connector → Index → Storage
     ↓
  Embeddings (local model)
```

### Query Flow

```
User Query → RuVector Connector → Hybrid Search → Results
     ↓                              ↓
  Embedding                  BM25 + Vector
```

### Memory Flow

```
Agent Interaction → RuVector Connector → Memory Graph → Storage
     ↓
  Relationship Tracking
```

## Configuration

### Data Paths

```yaml
ruvector:
  data_dir: ~/.local/share/bazzite-security/ruvector/
  index_dir: ~/.local/share/bazzite-security/ruvector/index/
  config_file: ~/.config/bazzite-security/ruvector/config.yaml
  log_dir: ~/.local/state/bazzite-security/logs/ruvector/
```

### Service Configuration

```yaml
server:
  host: 127.0.0.1
  port: 7632  # Arbitrary, check availability

indexing:
  embedding_model: local  # Use local embeddings
  vector_dimension: 384   # Match model output
  hnsw:
    m: 16
    ef_construction: 200
    ef_search: 50

memory:
  enable_graph: true
  max_nodes: 100000
  max_edges: 500000

learning:
  mode: manual  # manual, scoped, or disabled
  auto_learn: false
```

## Security Model

### Data Isolation
- RuVector data isolated in user-local path
- No system-wide access
- No external network communication

### Access Control
- User-only permissions on data directory
- No sudo required
- Localhost-only service binding

### Learning Control
- Manual learning mode by default
- Scoped to authorized data only
- No automatic ingestion of arbitrary files

## Implementation Phases

### Phase 7B: Scoped Memory Prototype ✅

**Result:** `ruvector_memory_prototype_working`

**Completed:**
- Installed `ruvector` v0.2.25 in the repo-local prototype only
- Indexed 6 approved knowledge docs plus 50 Stage 3A chunks
- Persisted prototype output to `~/.local/share/bazzite-security/ruvector/`
- Compared placeholder-vector retrieval against Stage 3A
- Confirmed Stage 3A remains the canonical fallback

**Limitations:**
- Uses deterministic placeholder vectors, not semantic embeddings
- Semantic retrieval quality is unproven
- Not production memory yet

### Phase 7B.1: Local Embedding Strategy ✅

**Result:** `ready_for_semantic_embedding_prototype`

**Completed:**
1. Confirmed existing local embedding model: `nomic-embed-text:latest`
2. Verified tiny Ollama embedding call returns a 768-dimensional vector
3. Confirmed RuVector exposes ONNX embedding APIs for later evaluation
4. Kept no-download and Stage 3A fallback constraints intact

**Deliverables:**
- `docs/integrations/ruvector/RUVECTOR_PHASE7B1_EMBEDDING_STRATEGY.md`
- Next prompt: `prompts/opencode/phase7b2-ruvector-semantic-prototype.prompt.txt`

### Phase 7B.2: Semantic Retrieval Prototype ✅

**Result:** `semantic_prototype_working`

**Completed:**
1. Built separate semantic scripts using `nomic-embed-text:latest`
2. Stored semantic artifacts under `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
3. Indexed 398 approved chunks with 768-dimensional local embeddings
4. Compared semantic retrieval against Stage 3A on 10 Stage 4 knowledge/path queries
5. Kept Stage 3A as fallback

**Current limitation:**
- Semantic prototype works, but production memory remains pending stricter retrieval-quality gates.

### Phase 8B: Operational Workflows

**Tasks:**
1. Define memory workflows
2. Create memory templates
3. Document memory hygiene
4. Test long-term memory

**Deliverables:**
- Memory workflow library
- Memory management guide

## Fallback Strategy

If RuVector integration fails:
1. Continue with Stage 3A deterministic retrieval
2. Evaluate simpler alternatives:
   - SQLite FTS5
   - Simple vector similarity
   - External embedding service (if acceptable)
3. Defer semantic search

## Validation

```bash
# Check RuVector integration
curl http://localhost:7632/health 2>/dev/null || echo "Not running"
ls -la ~/.local/share/bazzite-security/ruvector/

# Test search
# (Test command TBD after implementation)
```

## References

- Phase 5D Assessment: `docs/integrations/ruvector/RUVECTOR_ASSESSMENT_PLAN.md`
- Phase 7B Prototype: `docs/integrations/ruvector/RUVECTOR_PHASE7B_PROTOTYPE_REPORT.md`
- Phase 7B.1 Strategy: `docs/integrations/ruvector/RUVECTOR_PHASE7B1_EMBEDDING_STRATEGY.md`
- Phase 7B.2 Semantic Prototype: `docs/integrations/ruvector/RUVECTOR_PHASE7B2_SEMANTIC_PROTOTYPE_REPORT.md`
- Phase 8B.3 Quality Workflow: `docs/workflows/memory/WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md`
- Phase 8B.3 Quality Gates: `docs/workflows/memory/MEMORY_QUALITY_GATES.md`
- Phase 8B.3 Quality Checklist: `docs/workflows/memory/MEMORY_QUALITY_VALIDATION_CHECKLIST.md`
- Phase 11C-RV Audit: `docs/integrations/ruvector/RUVECTOR_OFFICIAL_DOCS_ALIGNMENT_AUDIT.md`
- Roadmap: `docs/roadmap/ROADMAP.md`

## Future Considerations

### AgenticDB Learning APIs

AgenticDB-style learning/session APIs are **future-review only**, not currently enabled:

- Reflexion memory
- Causal memory graphs
- Skill libraries
- Learning sessions

**Future controlled learning** may be considered only after explicit graduation gates:
1. Successful task completion evidence
2. Human-reviewed success/failure classification
3. Sanitized curated examples (no secrets, raw logs, browser data, private code)
4. Eval/checker coverage
5. Privacy/secret review
6. Rollback plan
7. Comparison against Stage 3A baseline
8. Explicit human approval
9. Bounded implementation prompt

This is NOT autonomous self-training. This is "graduated controlled learning loop."
- Phase 8B.3 Quality Checklist: `docs/workflows/memory/MEMORY_QUALITY_VALIDATION_CHECKLIST.md`
- Roadmap: `docs/roadmap/ROADMAP.md`

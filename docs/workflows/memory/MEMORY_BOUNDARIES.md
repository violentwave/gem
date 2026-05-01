# Memory Workflow Boundaries

**Phase:** 8B
**Status:** Documentation-only boundaries document
**Production status:** RuVector remains prototype-only

---

## Overview

This document defines what memory workflows may do, what they may not do, and how they relate to the existing component responsibilities. All boundaries preserve human control and maintain prototype status for RuVector.

---

## RuVector Status

### Prototype-Only

RuVector is **not production memory**. The semantic prototype:
- Has indexed 398 chunks (348 approved-doc, 50 Stage 3A)
- Uses embedding model: `nomic-embed-text:latest`
- Has embedding dimensions: 768
- Stores data in: `~/.local/share/bazzite-security/ruvector/semantic-prototype/`

**Production promotion requires:**
- Stage 3A comparison passing
- Stage 4 cases/examples remaining passing
- Semantic retrieval quality validated
- Quality gates documented
- Human explicit approval

---

## Stage 3A Fallback

Stage 3A deterministic RAG is the **canonical fallback** for all memory operations:

```
Query Request
      │
      ▼
┌─────────────────┐
│  RuVector      │ ───► Semantic retrieval (if available)
│  Prototype     │
└─────────────────┘
      │
      ▼ (always fallback)
┌─────────────────┐
│  Stage 3A      │ ───► Deterministic keyword search
│  JSONL RAG      │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│  Results        │
└─────────────────┘
```

**Rule:** RuVector enhances but never replaces Stage 3A. When in doubt, use Stage 3A.

---

## What Memory Workflows May Do

### When Authorized by Human

1. **Query semantic prototype**
   - Search indexed approved docs
   - Return semantic matches
   - Compare with Stage 3A

2. **Compare with Stage 3A**
   - Run parallel semantic and deterministic queries
   - Document agreement/disagreement
   - Validate quality

3. **Propose ingestion**
   - Document new source
   - Specify source class
   - Plan chunk count
   - Create rollback plan

4. **Review ingestion**
   - Validate source class
   - Check denied data exclusion
   - Verify manifest
   - Approve/deny

5. **Capture evidence**
   - Log query results
   - Store comparison reports
   - Document validation

---

## What Memory Workflows May Not Do

### Prohibited Actions

1. **No autonomous memory ingestion**
   - No automatic indexing
   - No scheduled ingestion
   - No bulk imports without approval

2. **No broad filesystem indexing**
   - Cannot index `~/projects` broadly
   - Cannot index `~/offload/security-reports` broadly
   - Cannot index `~/.cache`, `~/.config`, `~/.local/share` broadly

3. **No secrets/private data**
   - No .env files
   - No API keys/secrets
   - No raw private logs
   - No browser data
   - No cookies, Local Storage, Session Storage, Trust Tokens
   - No provider state
   - No private project code unless explicitly approved

4. **No production memory promotion**
   - Cannot change prototype status
   - Cannot remove Stage 3A fallback
   - Cannot enable autonomous learning loop

5. **No system changes**
   - No Ollama config changes
   - No model config changes
   - No package installs

---

## Source Classes

### Approved Now
- `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md`
- `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
- Stage 4 eval/example metadata summaries (non-secret)
- Repo-local architecture docs under `~/projects/gem/docs/` when explicitly scoped

### Prototype Metadata Only
- `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json`
- Small summaries of semantic query reports

### Denied
- .env files
- API keys/secrets
- Raw private logs
- Browser data
- Cookies/Local Storage/Session Storage/Trust Tokens
- Provider state
- `~/.cache`
- Broad `~/.config`
- Broad `~/.local/share`
- Broad `~/projects`
- Broad `~/offload/security-reports`
- Agent Zero memory
- Space Agent config/state

### Future Approval Required
- Specific project docs (outside gem)
- Sanitized OpenCode summaries
- Human-curated lessons learned
- Approved workflow closeout reports
- Sanitized issue/bug examples
- Memory graph relationship data

---

## Ingestion Rules

### Pre-Ingestion Requirements

1. **Source classification**
   - Identify source class
   - Verify against approved list

2. **Denied data check**
   - Scan for excluded file types
   - Verify no secrets

3. **Manifest creation**
   - Input source
   - Chunk count
   - Embedding model
   - Embedding dimensions
   - Timestamp
   - Excluded paths
   - Fallback status

4. **Rollback plan**
   - How to undo
   - How to restore fallback

5. **Human approval**
   - Required before any ingestion
   - Document approval

### Post-Ingestion Validation

1. **Query test**
   - Run test queries
   - Verify retrieval works

2. **Stage 3A comparison**
   - Compare semantic vs deterministic
   - Document agreement

3. **Quality gate check**
   - Verify against Stage 4 cases
   - Verify against Stage 4 examples

---

## Component Relationships

### RuVector vs Stage 3A

| Aspect | RuVector | Stage 3A |
|--------|----------|----------|
| Role | Semantic prototype | Canonical fallback |
| Status | Not production | Production |
| Query type | Semantic similarity | Keyword match |
| Fallback | None - use Stage 3A | N/A |

### RuVector vs Gemma

| Aspect | RuVector | Gemma |
|--------|----------|-------|
| Role | Memory lookup | Synthesis |
| Output | Retrieved context | Summarized answer |
| Use | Context building | Advisory |

### RuVector vs Human

| Aspect | Role |
|--------|------|
| Approval | Human required for all ingestion |
| Decision | Human decides production promotion |
| Quality | Human validates quality gates |

---

## Hard Boundaries Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                    Memory Hard Boundaries                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   NEVER:                                                         │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │ • Autonomous memory ingestion                          │  │
│   │ • Broad filesystem indexing                            │  │
│   │ • Production memory promotion                          │  │
│   │ • Secret/private data access                           │  │
│   │ • Learning loop activation                             │  │
│   │ • Ollama/model config changes                          │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                  │
│   ALWAYS:                                                       │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │ • Stage 3A fallback available                          │  │
│   │ • Human approval for ingestion                         │  │
│   │ • Manifest metadata for indexes                        │  │
│   │ • Quality comparison with Stage 3A                    │  │
│   │ • Stage 4 validators passing                           │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Validation Commands

```bash
# Verify boundaries doc exists
test -f docs/workflows/memory/MEMORY_BOUNDARIES.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Production Status

**Phase 8B:** Documentation-only. RuVector remains prototype-only. Stage 3A remains fallback. No production memory promotion until future explicit quality gate passes.

---

## Related Documents

- `MEMORY_WORKFLOW_LIBRARY.md` - Workflow categories
- `MEMORY_SOURCE_POLICY.md` - Source class definitions
- `MEMORY_QUALITY_GATES.md` - Production quality requirements
- `docs/integrations/ruvector/RUVECTOR_PHASE7B2_SEMANTIC_PROTOTYPE_REPORT.md` - Prototype status

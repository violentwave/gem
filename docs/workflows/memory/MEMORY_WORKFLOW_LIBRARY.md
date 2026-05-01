# Memory Workflow Library

**Phase:** 8B
**Status:** Documentation-only workflow definitions
**Production status:** RuVector remains prototype-only; no production memory promotion

---

## Overview

This library defines L6 memory workflow categories for the Bazzite Local AI Operations Stack. All workflows use the RuVector semantic prototype with Stage 3A deterministic fallback. **No production memory promotion occurs in Phase 8B.**

The workflows are designed to be:
- Bounded and explicit in scope
- Routed through existing component responsibilities
- Require human approval at all key points
- Compared against Stage 3A for quality validation

---

## Workflow Categories

### 1. Semantic Context Lookup

**Purpose:** Query the RuVector semantic prototype for context retrieval, with mandatory Stage 3A comparison.

**Workflow doc:** `WORKFLOW_8B1_MEMORY_QUERY.md` — Full workflow definition with Stage 3A comparison logic, quality labels, and stop conditions.

**When to use:**
- When needing contextual information from approved knowledge sources
- When preparing for advisory or implementation work
- When building context for a briefing or report

**Inputs:**
- Query string
- Scope (approved docs only)
- Include Stage 3A comparison (required)
- Include Gemma synthesis (optional, requires explicit request)

**Approved paths:**
- `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md`
- `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
- RuVector prototype metadata

**Denied paths:**
- Secrets, .env, API keys
- Raw logs, browser data
- Private code
- Broad filesystem roots

**Allowed components:**
- RuVector semantic prototype
- Stage 3A RAG (mandatory fallback)
- Gemma wrappers (optional synthesis)

**Forbidden actions:**
- No autonomous memory ingestion
- No broad filesystem indexing
- No production memory promotion

**Execution steps:**
1. Receive query
2. Run RuVector semantic query
3. Run Stage 3A keyword query
4. Compare results
5. Optionally request Gemma synthesis
6. Report to human

**Validation:** Compare semantic vs deterministic results

**Evidence:** Query results in task output

**Fallback:** Stage 3A always available

**Stop conditions:**
- Query touches denied paths
- RuVector unavailable - use Stage 3A only

**Human approval:** Query scope, synthesis request

**Readiness level:** L3 (defined)

---

### 2. Memory Query with Stage 3A Comparison

**Purpose:** Explicit comparison between RuVector semantic retrieval and Stage 3A deterministic retrieval to validate quality.

**When to use:**
- When validating RuVector quality
- When building confidence in semantic retrieval
- When preparing evidence for memory decisions

**Inputs:**
- Query string
- Comparison scope
- Quality criteria

**Allowed components:**
- RuVector semantic prototype
- Stage 3A deterministic RAG

**Execution:**
1. Run parallel queries
2. Compare result sets
3. Document agreement/disagreement
4. Report quality assessment

**Validation:** Manual review of comparison

**Stop conditions:** Results fundamentally disagree - escalate to human

**Readiness level:** L3 (defined)

---

### 3. Gemma Synthesis from Retrieved Context

**Purpose:** Use Gemma wrappers to synthesize context from retrieved memory results.

**When to use:**
- When retrieved context needs summarization
- When preparing advisory from memory
- When building handoff context

**Inputs:**
- Retrieved context (from RuVector/Stage 3A)
- Synthesis request
- Output format

**Allowed components:**
- Gemma wrappers
- Retrieved context only

**Forbidden:** No new memory creation

**Execution:**
1. Present retrieved context to Gemma
2. Request synthesis
3. Report to human

**Human approval:** Required for synthesis request

**Readiness level:** L3 (defined)

---

### 4. Scoped Memory Ingestion Proposal

**Purpose:** Propose a new source for memory indexing with full documentation.

**When to use:**
- When identifying new approved source
- When preparing memory expansion
- Before any actual ingestion

**Inputs:**
- Proposed source path
- Source class
- Purpose
- Expected files
- Expected chunk count

**Documentation required:**
- Source path
- Source class (approved/pending/future)
- Purpose
- Expected files
- Expected chunk count
- Storage path
- Manifest path
- Rollback plan

**Human approval:** Required before any ingestion

**Readiness level:** L3 (defined)

---

### 5. Scoped Memory Ingestion Review

**Purpose:** Review and approve/deny proposed memory ingestion.

**When to use:**
- When reviewing ingestion proposal
- When validating source class
- When checking denied data

**Review criteria:**
- Source class approved?
- Denied data excluded?
- Files match expectation?
- Chunk count reasonable?
- Manifest complete?
- Rollback plan exists?

**Human approval:** Required for approval

**Decision:** Approve / Deny / Request more info

**Readiness level:** L3 (defined)

---

### 6. Memory Refresh/Reindex Planning

**Purpose:** Plan memory refresh when source docs change.

**When to use:**
- When knowledge pack updates
- When new approved docs added
- When reindex needed after changes

**Inputs:**
- Changed sources
- Affected scope
- Reindex plan

**Planning:**
- Identify changed files
- Plan reindex order
- Document rollback
- Set validation criteria

**Human approval:** Required for execution

**Readiness level:** L3 (defined)

---

### 7. Memory Quality Validation

**Purpose:** Validate memory retrieval quality against Stage 4 cases and examples.

**Workflow doc:** `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` — Full workflow with all 8 quality gates (Gate 1-8, Gate 5 skipped in numbering), failure handling (5 categories), and production promotion checklist.

**When to use:**
- When checking semantic retrieval accuracy
- When preparing for production consideration
- When validating against known queries

**Validation against:**
- Stage 4 eval cases (19 cases)
- Stage 4 examples (22 examples)
- Known Bazzite queries

**Metrics:**
- Semantic vs deterministic agreement
- Relevant source retrieval
- Answer coherence

**Human approval:** Required for quality assessment

**Readiness level:** L3 (defined)

---

### 8. Memory Fallback / Degraded Mode

**Purpose:** Document fallback behavior when RuVector unavailable.

**When to use:**
- When RuVector service fails
- When prototype unavailable
- When semantic index corrupted

**Fallback behavior:**
- Stage 3A only
- Deterministic RAG
- Report degraded mode

**Validation:** Manual test of Stage 3A

**Stop conditions:** None - fallback is automatic

**Human notification:** Required when degraded

**Readiness level:** L3 (defined)

---

### 9. Memory Evidence Capture and Closeout

**Purpose:** Capture evidence from memory operations for audit or handoff.

**When to use:**
- When completing memory workflow
- When preparing evidence package
- When closing session

**Evidence:**
- Query logs
- Comparison results
- Synthesis outputs
- Validation results

**Storage:** ~/offload/security-reports/manual/

**Human approval:** Required for storage

**Readiness level:** L3 (defined)

---

### 10. Memory Hygiene / Stale-Memory Review

**Purpose:** Review and clean stale or outdated memory entries.

**When to use:**
- Periodic hygiene check
- Before any learning loop
- When memory seems outdated

**Review criteria:**
- Old index dates
- Source docs still exist
- Relevance still valid
- Overlapping entries

**Actions:**
- Mark stale
- Document removal plan
- Plan reindex if needed

**Human approval:** Required for any removal

**Readiness level:** L3 (defined)

---

## Routing Rules Summary

| Workflow | Primary Handler | Fallback | Not Allowed |
|----------|----------------|----------|-------------|
| Semantic lookup | RuVector (proto) | Stage 3A | Production memory |
| Stage 3A comparison | Stage 3A | None | None |
| Gemma synthesis | Gemma | Human | Memory creation |
| Ingestion proposal | Human | None | Autonomous ingestion |
| Ingestion review | Human | None | Auto-approval |
| Reindex planning | OpenCode | Manual | Auto-reindex |
| Quality validation | Stage 4 | None | Auto-promotion |
| Fallback mode | Stage 3A | None | RuVector-only |
| Evidence capture | OpenCode | Manual | Secret inclusion |
| Hygiene review | Human | None | Auto-removal |

---

## Validation Commands

```bash
# Verify memory workflow library exists
test -f docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Production Status

**Phase 8B:** Documentation-only. RuVector remains prototype-only. Stage 3A is the canonical fallback. No production memory promotion. All ingestion requires human approval.

---

## Next Steps

- Phase 8B.1: Memory query workflow implementation
- Phase 8B.2: Memory ingestion review workflow
- Phase 8B.3: Memory quality gates validation
- Phase 8C: Space Agent workspace workflow library

See `prompts/opencode/phase8b1-memory-query-workflow.prompt.txt` for the first memory workflow implementation.

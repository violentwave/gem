# RAG Answer Comparison Plan

**Phase:** 11A Planning
**Purpose:** Plan manual RAG answer comparison between Stage 3A and supervised RAG
**Status:** Planning artifact only

---

## Purpose

Compare deterministic fallback (Stage 3A) vs supervised RuVector RAG answers to document divergences and define acceptable variance.

---

## Comparison Scope

### Stage 3A (Deterministic Fallback)
- JSONL chunk index
- Keyword-based search
- No embeddings
- Canonical fallback

### Supervised RAG (RuVector)
- Semantic embeddings
- nomic-embed-text:latest
- 768 dimensions
- Supervised/prototype/secondary status

---

## Manual Comparison Process

### Step 1: Select Test Queries

Select queries covering:
- Path policy questions
- Firewalld questions
- Knowledge pack questions
- RuVector status questions
- Stage 3A fallback questions

Example queries:
```
What paths are approved for Gemma knowledge docs?
What is the firewalld status?
How does Stage 3A retrieval work?
What is the RuVector status?
```

### Step 2: Run Stage 3A

```bash
gemma-knowledge-search "query"
```

Capture output for comparison.

### Step 3: Run Supervised RAG

```bash
gemma-memory-rag "query" --use-ruvector
```

Capture output for comparison.

### Step 4: Document Divergences

Manually compare:
- Query used
- Stage 3A answer
- Supervised RAG answer
- Key differences
- Relevance score comparison

---

## Documentation Format

### Divergence Entry

| Field | Description |
|-------|-------------|
| query | Test query |
| stage3a_answer | Stage 3A output |
| supervised_rag_answer | Supervised RAG output |
| divergence_type | exact/partial/none |
| acceptable_variance | yes/no |
| notes | Comparison notes |

---

## Acceptable Variance

### Exact Match
- Both return same answer
- Acceptable: YES

### Partial Match
- Both return relevant answer
- Different wording/phrasing
- Acceptable: YES (if relevant)

### No Match
- Returns different information
- Needs manual review
- Acceptable: NO (requires review)

---

## Manual Triggers

### When to Compare

- Before ingestion cycles
- After retrieval quality issues
- Upon human trigger only
- No automatic comparison

### Frequency

- Manual-only
- No daemon/timer automation
- Human-initiated

---

## Hard Boundaries

- No automatic execution
- No automatic divergence detection
- No auto-flagging
- All manual comparison process
- No system modifications

---

## Future Work

### Possible Expansions (Future Phases)

- Add more test queries
- Define stricter variance thresholds
- Document edge cases
- Expand comparison categories

This is planning-only. Real implementation requires explicit future prompt.

---

## Sign-Off

- Plan: PLANNING COMPLETE
- Comparison: MANUAL-ONLY
- No automation: CONFIRMED
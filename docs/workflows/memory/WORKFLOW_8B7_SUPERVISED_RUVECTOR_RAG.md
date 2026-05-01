# Workflow 8B.7: Supervised RuVector RAG Integration

**Workflow ID:** WORKFLOW_8B7
**Phase:** 8B.7
**Status:** Active
**Date:** 2026-04-30

---

## Purpose

Define the supervised workflow for using `gemma-memory-rag` — a helper that generates answers using `gemma4-e4b-bazzite:latest` based on context retrieved primarily from RuVector and falling back to Stage 3A.

---

## Scope & When to Use

### ✅ When to Use
- Running `gemma-memory-rag "<question>"` to get supervised AI advice.
- Testing context quality bounds using the RAG model.
- Safe, supervised question-answering sessions on local policies and operations.

### ❌ When NOT to Use
- Autonomous agent loops.
- Overwriting Stage 3A behavior.
- Direct system implementation tasks (e.g. installing packages or mutating firewall rules).

---

## Approved & Denied Paths

- **Approved:** reading `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json`, writing to `~/offload/security-reports/manual/`, writing to `~/.local/state/bazzite-security/logs/`.
- **Denied:** writing to project roots, accessing secrets, running autonomous tasks.

---

## Execution Flow

### 1. Retrieval
- Runs `gemma-memory-search` with the given question.
- Extracts `final_recommendation`, `confidence`, and excerpt contexts.

### 2. Retrieval-to-Generation Handoff
- If RuVector provides `direct_answer` or multiple `supporting_context` items (`use_ruvector_context`), RuVector excerpts are used.
- If RuVector is weak or generic, and Stage 3A is strong, Stage 3A excerpts are used as fallback.
- If both are weak (`insufficient_evidence`), context is provided but often answers "MISSING EVIDENCE."
- If `stop_human_review_required`, generation is aborted, and a report is written.

### 3. Answer Generation
- Context and question are formatted into a bounded prompt.
- Passed to local Ollama API (`http://127.0.0.1:11434/api/chat`).
- Returns concise answer.

### 4. Reporting
- Always writes a report to `~/offload/security-reports/manual/gemma-memory-rag-YYYYMMDD-HHMMSS.md`.

---

## Fallback & Timeout Behavior

- **Fallback:** Stage 3A deterministic retrieval.
- **Timeout:** 180s default. If Ollama or search times out, report records the timeout status.
- **Missing Evidence:** If context is inadequate, outputs "MISSING EVIDENCE."

---

## Examples

```bash
gemma-memory-rag "What firewall tool does Bazzite use?"
gemma-memory-rag "Where should generated reports and logs go?"
```

---

## Human Approval Points

- Any production promotion to default wrapper requires manual Phase 8B.5/Phase 9 review.
- Any modification of `gemma-knowledge-rag` to use this logic requires human approval.

---

## Boundaries Preserved

- No memory ingestion.
- No indexing.
- No default wrappers changed.
- No autonomous memory learning enabled.

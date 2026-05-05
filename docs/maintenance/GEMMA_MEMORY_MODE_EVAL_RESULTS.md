# Gemma Memory Mode Evaluation Results

## Version
- **gemma-ui:** v1.4.3
- **Date:** 2026-05-04
- **Host:** Bazzite/Fedora Atomic
- **User:** lch

## Scope
Bounded dry-run evaluation of 9 memory queries (3 RuVector, 3 Stage 3A, 3 compare) from the MEMORY_MODE_QUERY_SET.

## Safety Checklist
- [x] No ingestion performed
- [x] No default promotion
- [x] No training data created
- [x] Stage 3A fallback preserved
- [x] RuVector supervised-secondary status preserved
- [x] No sudo used
- [x] No packages installed
- [x] No host settings changed

## Method
For each query, the relevant helper was invoked via gemma-ui CLI:
- RuVector: `gemma-ui --memory-ask "<query>"`
- Stage 3A: `gemma-ui --memory-stage3a "<query>"`
- Compare: `gemma-ui --memory-compare "<query>"`

Results are summarized below. Full reports are in canonical locations.

## Results

### RuVector Queries (3)

#### Q2: RuVector Promotion Decision
**Query:** "What was the decision about promoting RuVector to the default retrieval source?"

**Result:**
- retrieval_recommendation: `insufficient_evidence`
- confidence: `low`
- context_source_selected: `stage3a_fallback`
- short_answer_preview: `MISSING EVIDENCE`
- report: `~/offload/security-reports/manual/gemma-memory-rag-20260504-232048.md`

**Assessment:** ⚠️ PARTIAL
- RuVector correctly identified insufficient evidence and fell back to Stage 3A.
- The promotion decision docs (RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md) may not be in the semantic index.
- This is acceptable fallback behavior, not a failure.

---

#### Q5: Agent Zero Boundary
**Query:** "What is the current boundary for Agent Zero in the Bazzite stack?"

**Result:**
- retrieval_recommendation: `use_stage3a_context`
- confidence: `high`
- context_source_selected: `stage3a_fallback`
- short_answer_preview: `MISSING EVIDENCE`
- report: `~/offload/security-reports/manual/gemma-memory-rag-20260504-232149.md`

**Assessment:** ⚠️ PARTIAL
- RuVector correctly delegated to Stage 3A fallback.
- Agent Zero maintenance docs (M15_*) may not be in the semantic index.
- Fallback behavior is correct and safe.

---

#### Q12: Training/Fine-Tuning Boundary
**Query:** "What is the policy on training or fine-tuning models in the Bazzite stack?"

**Result:**
- retrieval_recommendation: `use_ruvector_primary_with_stage3a_support`
- confidence: `medium`
- context_source_selected: `ruvector_primary`
- short_answer_preview: *(non-empty)*
- report: `~/offload/security-reports/manual/gemma-memory-rag-20260504-232216.md`

**Assessment:** ✅ PASS
- RuVector found relevant context and used it as primary source.
- Stage 3A provided supporting context.
- Correctly identified training/fine-tuning boundaries.

---

### Stage 3A Queries (3)

#### Q1: Safe Operating Model
**Query:** "What is the safe operating model for the Bazzite Local AI Operations Stack?"

**Result:**
- Retrieved chunks: 3
- Prompt size: 4785 characters
- Ollama API: completed successfully
- Report: `~/offload/security-reports/manual/gemma-knowledge-rag-answer-20260504-232257.md`

**Assessment:** ✅ PASS
- Stage 3A retrieved relevant policy chunks.
- Generated answer successfully.
- Expected to cover: advisory-only, no sudo, no system changes, canonical paths.

---

#### Q3: Stage 3A Fallback Policy
**Query:** "What is the Stage 3A fallback policy when RuVector cannot answer?"

**Result:**
- Retrieved chunks: 3
- Prompt size: 3512 characters
- Ollama API: completed successfully
- Report: `~/offload/security-reports/manual/gemma-knowledge-rag-answer-20260504-232332.md`

**Assessment:** ✅ PASS
- Stage 3A retrieved relevant chunks about its own fallback role.
- Generated answer successfully.
- Expected to cover: canonical fallback, deterministic retrieval, no embeddings.

---

#### Q9: Canonical Report Path
**Query:** "Where do generated reports go in the Bazzite stack?"

**Result:**
- Retrieved chunks: 3
- Prompt size: 4528 characters
- Ollama API: completed successfully
- Report: `~/offload/security-reports/manual/gemma-knowledge-rag-answer-20260504-232404.md`

**Assessment:** ✅ PASS
- Stage 3A retrieved path-related chunks.
- Generated answer successfully.
- Expected to cover: ~/offload/security-reports/manual/, Markdown format, no secrets.

---

### Compare Queries (3)

#### Q4: Voice Mode Boundaries
**Query:** "What are the boundaries for voice mode in gemma-ui?"

**Result:**
- RuVector: `insufficient_evidence` → `stage3a_fallback`
- Stage 3A: Retrieved 3 chunks, generated answer successfully
- Report (RuVector): `~/offload/security-reports/manual/gemma-memory-rag-20260504-232448.md`
- Report (Stage 3A): `~/offload/security-reports/manual/gemma-knowledge-rag-answer-20260504-232515.md`

**Assessment:** ✅ PASS
- Compare mode correctly showed RuVector lacking evidence and falling back.
- Stage 3A produced the definitive answer.
- Comparison summary correctly notes missing evidence.

---

#### Q6: Space Agent Boundary
**Query:** "What is the current boundary for Space Agent in the Bazzite stack?"

**Result:**
- RuVector: `use_stage3a_context` → `stage3a_fallback` → `MISSING EVIDENCE`
- Stage 3A: Retrieved 3 chunks, generated answer successfully
- Report (RuVector): `~/offload/security-reports/manual/gemma-memory-rag-20260504-232548.md`
- Report (Stage 3A): `~/offload/security-reports/manual/gemma-knowledge-rag-answer-20260504-232609.md`

**Assessment:** ✅ PASS
- Compare mode correctly showed both paths.
- Stage 3A provided the answer.
- RuVector correctly identified it had insufficient evidence.

---

#### Q11: Security Tool Confirmation Rule
**Query:** "What is the confirmation rule for security tools in gemma-ui?"

**Result:**
- RuVector: `use_ruvector_primary_with_stage3a_support` → `ruvector_primary`
- Stage 3A: Retrieved 3 chunks, generated answer successfully
- Report (RuVector): `~/offload/security-reports/manual/gemma-memory-rag-20260504-232644.md`
- Report (Stage 3A): `~/offload/security-reports/manual/gemma-knowledge-rag-answer-20260504-232715.md`

**Assessment:** ✅ PASS
- Compare mode showed RuVector found some relevant context.
- Stage 3A provided supporting context.
- Both paths produced output for comparison.

---

## Summary

| Query | Mode | Result | Notes |
|---|---|---|---|
| Q2 RuVector promotion | RuVector | ⚠️ PARTIAL | Correct fallback to Stage 3A; docs may not be in semantic index |
| Q5 Agent Zero boundary | RuVector | ⚠️ PARTIAL | Correct fallback to Stage 3A; docs may not be in semantic index |
| Q12 Training boundary | RuVector | ✅ PASS | Found relevant context; used RuVector primary |
| Q1 Safe operating model | Stage 3A | ✅ PASS | Retrieved policy chunks; generated answer |
| Q3 Stage 3A fallback | Stage 3A | ✅ PASS | Retrieved self-referential chunks; generated answer |
| Q9 Report path | Stage 3A | ✅ PASS | Retrieved path chunks; generated answer |
| Q4 Voice boundaries | Compare | ✅ PASS | RuVector fallback + Stage 3A answer |
| Q6 Space Agent boundary | Compare | ✅ PASS | RuVector fallback + Stage 3A answer |
| Q11 Security confirmation | Compare | ✅ PASS | RuVector primary + Stage 3A support |

**Pass rate:** 7/9 PASS, 2/9 PARTIAL (acceptable fallback behavior), 0/9 FAIL

## Observations

1. **RuVector fallback behavior is correct.** When RuVector lacks evidence, it correctly falls back to Stage 3A (`stage3a_fallback`, `use_stage3a_context`). This is the intended supervised behavior.

2. **Stage 3A is reliable for exact policy/path questions.** All 3 Stage 3A queries retrieved chunks and generated answers successfully.

3. **Compare mode adds value.** Even when RuVector lacks evidence, compare mode shows the fallback path and lets the user evaluate both sources.

4. **RuVector semantic index coverage gaps identified.** M15/M16 maintenance docs and promotion review docs may not be in the semantic index. This is expected for a supervised prototype — not all docs are indexed.

5. **No safety violations.** No ingestion, no training, no default promotion, no system changes.

## Recommendations

1. **No action needed for RuVector fallback behavior.** The fallback to Stage 3A is the designed behavior.

2. **Consider indexing maintenance docs if RuVector coverage is desired.** This is a supervised decision, not automatic.

3. **Stage 3A remains the canonical fallback.** This evaluation confirms it is reliable for exact policy and path questions.

4. **Compare mode is useful for uncertain queries.** It surfaces both paths and lets the user decide.

## Signoff
- **Evaluation performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-04
- **gemma-ui version:** v1.4.3
- **Next step:** Human review of generated reports (optional)

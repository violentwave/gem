# Phase 13A: Curated Learning Examples Intake Plan

**Phase:** 13A — Curated Learning Examples Intake Planning
**Date:** 2026-05-02
**Parent:** Phase 12M (Final Readiness Closeout)
**Status:** COMPLETE

---

## Purpose

Plan the intake, review, and integration workflow for expanding the curated supervised example set (Stage 4B) and eval case set (Stage 4A) to cover new capabilities added since Phase 4.

---

## Current Baseline

### Stage 4A: Eval Cases
- **Total:** 19 cases
- **command_review:** 8 cases
- **knowledge_rag:** 5 cases
- **path_policy:** 5 cases
- **forbidden_output:** 1 case
- **Validator:** `gemma-evals-check` — PASS

### Stage 4B: Supervised Examples
- **Total:** 22 examples (100% reviewed)
- **command_review_example:** 8 examples
- **rag_answer_example:** 5 examples
- **bad_to_corrected_example:** 4 examples
- **path_policy_example:** 5 examples
- **Validator:** `gemma-examples-check` — PASS

### Coverage Matrix
- 8/8 categories covered
- 0 draft examples
- 0 validation errors

---

## Identified Gaps

New capabilities added since Stage 4 that lack example/eval coverage:

| Capability | Example Gap | Eval Gap |
|------------|-------------|----------|
| RuVector semantic search | No `gemma-memory-search` examples | No related command_review cases |
| gemma-memory-rag helper | No RAG helper examples | No related cases |
| Agent Zero boundaries | No Agent Zero example coverage | No related cases |
| Space Agent boundaries | No Space Agent example coverage | No related cases |
| Notion sync boundaries | No Notion sync example coverage | No related cases |
| OpenCode bridge usage | No bridge usage examples | No related cases |
| Canonical cache path | No cache path examples | No cache path cases |

---

## Intake Workflow

### Step 1: Gap Identification
- Review CURRENT_STATE.md for new capabilities
- Check recent phase closeout docs for recurring patterns
- Identify command types, RAG topics, path questions, and bad outputs

### Step 2: Example Design
- Create **synthetic** examples (preferred source)
- Ensure `status: reviewed` on creation
- Follow existing JSONL schema
- Include `must_include` and `must_not_include` arrays

### Step 3: Eval Case Design
- Mirror new examples with eval cases
- Ensure eval cases have `must_include` and `must_not_include`
- Follow existing JSONL schema

### Step 4: Validation
- Run `gemma-examples-check`
- Run `gemma-evals-check`
- Run `gemma-evals-status`
- Fix any validation errors

### Step 5: Review
- Verify no secrets in new entries
- Verify no forbidden platform assumptions
- Verify canonical paths are correct
- Verify examples align with current Bazzite policy

### Step 6: Integration
- Append to live JSONL files (`~/.local/share/bazzite-security/gemma-evals/`)
- Do NOT delete or modify existing reviewed entries
- Deprecate outdated entries if needed (rare)

---

## Example Quality Criteria

Every new example must meet:

1. **Synthetic or sanitized** — No real logs, secrets, or private data
2. **Bazzite-specific** — References firewalld, rpm-ostree, Flatpak, canonical paths
3. **Boundary-aware** — Reinforces safety boundaries
4. **Actionable** — `must_include` and `must_not_include` are specific and testable
5. **Consistent** — Follows existing schema and naming conventions

## Eval Case Quality Criteria

Every new eval case must meet:

1. **Specific input** — Clear command/question
2. **Specific expectations** — Explicit `must_include` and `must_not_include`
3. **No overlap** — Not redundant with existing cases
4. **Coverage value** — Fills a real gap

---

## Approval Workflow

No human approval required for **synthetic** examples that:
- Follow existing schema
- Contain no secrets
- Reinforce known boundaries
- Use canonical paths

Human approval **recommended** for:
- `human_corrected` source examples
- Examples derived from real wrapper output
- Examples that modify existing `reviewed` entries

---

## Storage Policy

- **Live data:** `~/.local/share/bazzite-security/gemma-evals/examples/` and `cases/`
- **Repo docs:** `docs/phase13/` (planning, closeout)
- **Reports:** `~/offload/security-reports/manual/`
- **No runtime state in repo**

---

## Rollback Plan

If new examples cause validator failures:
1. Identify failing entries
2. Move to deprecated status (do not delete)
3. Fix issues
4. Re-run validators
5. Document fix in commit message

---

## Sign-Off

- Phase 13A: COMPLETE
- Gap analysis: DONE
- Intake workflow: DEFINED
- Next: Phase 13B (Example Expansion)

# Memory Ingestion Review Checklist

**Phase:** 8B.2
**Status:** Concise checklist for supervised memory ingestion review
**Production status:** RuVector remains prototype-only

---

## Purpose

This checklist is a quick-reference for a future supervised memory ingestion review using the Workflow 8B.2 process. It ensures every proposed source is properly classified, checked for denied data, and approved by a human before any ingestion.

---

## Pre-Review Checklist

### Proposal Received
- [ ] Proposed source path recorded
- [ ] Source class identified (or marked "unknown" for workflow to classify)
- [ ] Purpose/justification recorded
- [ ] Proposed by [human/agent] recorded
- [ ] Date proposed recorded
- [ ] Proposal ID assigned

### Scope Confirmation
- [ ] Source is not a broad root scan (`~/projects/`, `~/offload/security-reports/`, etc.)
- [ ] Source is scoped to specific files or directories
- [ ] If private code: explicit human approval for scoped path obtained

---

## Source Classification Checklist

### Class Identification
- [ ] Source classified as Class A, B, C, or D
- [ ] Classification rules applied from `MEMORY_SOURCE_POLICY.md`

### Class A — Approved Now
- [ ] Source matches approved pattern
- [ ] Path is within `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md` OR
- [ ] Path is `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` OR
- [ ] Path is Stage 4 eval/example metadata OR
- [ ] Path is `~/projects/gem/docs/` (explicitly scoped)
- [ ] Source can proceed to denied-data check

### Class B — Prototype Metadata Only
- [ ] Source is `semantic-manifest-*.json` OR `embeddings.json`
- [ ] Source is metadata only — no user content
- [ ] No ingestion needed — already present
- [ ] Note: "Metadata only — no ingestion required"

### Class C — Future Approval Required
- [ ] Source is NOT in Class A or B
- [ ] Source requires explicit human approval
- [ ] Flagged for human approval
- [ ] Proposal includes justification for Class C classification
- [ ] Human approval captured (or defaulted to DENY if no response)

### Class D — Denied
- [ ] Source matches denied pattern (`.env`, secrets, logs, browser data, etc.)
- [ ] Source is a broad directory root
- [ ] **Immediate action:** Reject, stop review, report to human
- [ ] **No override possible** — not even by human

---

## Denied-Data Check Checklist

### File Name Scan
- [ ] No `.env*` files present
- [ ] No `*secret*` files present
- [ ] No `*key*` files present
- [ ] No `*token*` files present
- [ ] No `*password*` files present
- [ ] No `*credential*` files present

### Content Scan
- [ ] No `api_key`, `api_secret`, `password`, `token`, `secret` in content
- [ ] No provider terms: `openai`, `anthropic`, `gemini`, `google`, `openrouter`
- [ ] No auth terms: `bearer`, `authorization`, `x-api-key`

### Browser/State Data
- [ ] No cookies
- [ ] No Local Storage
- [ ] No Session Storage
- [ ] No Trust Tokens
- [ ] No provider state files

### Raw Logs
- [ ] No `*.log` files (unless explicitly sanitized and approved)
- [ ] No system logs
- [ ] No application logs
- [ ] No runtime logs

### Binary/Blobs
- [ ] No executables
- [ ] No images (unless explicitly approved as documentation)
- [ ] No compressed archives
- [ ] No database files

### File Size Check
- [ ] No files > 1MB (requires special approval)
- [ ] No files with > 10,000 words (too many chunks)

### Broad Directory Roots
- [ ] Not scanning `~/projects/` broadly
- [ ] Not scanning `~/offload/security-reports/` broadly
- [ ] Not scanning `~/.cache/` broadly
- [ ] Not scanning `~/.config/` broadly
- [ ] Not scanning `~/.local/share/` broadly

### Private Code
- [ ] No private project code without explicit scoped approval
- [ ] No proprietary/unauthorized code

### Agent/System State
- [ ] No Agent Zero memory files
- [ ] No Space Agent config/state
- [ ] No OpenCode unredacted transcripts
- [ ] No runtime state files

### Denied-Data Check Result
- [ ] **PASSED:** No denied data found — proceed
- [ ] **FAILED:** Denied data found — STOP, reject, report to human
- [ ] Result recorded in review report

---

## Manifest Planning Checklist

### Required Fields
- [ ] `input_source` — path to indexed source
- [ ] `source_class` — A, B, or C (not D)
- [ ] `approved_by` — human who approved
- [ ] `timestamp` — ingestion time (ISO format)
- [ ] `file_count` — number of files indexed
- [ ] `chunk_count` — number of chunks indexed
- [ ] `excluded_paths` — paths not indexed
- [ ] `embedding_model` — `nomic-embed-text:latest`
- [ ] `embedding_dimensions` — `768`
- [ ] `storage_path` — prototype directory
- [ ] `fallback_status` — `Stage 3A available`
- [ ] `rollback_path` — how to undo
- [ ] `validation_commands` — how to verify

### Manifest File
- [ ] Manifest filename: `semantic-manifest-[timestamp].json`
- [ ] Manifest is valid JSON
- [ ] Manifest stored in `~/.local/share/bazzite-security/ruvector/semantic-prototype/`

---

## Rollback Planning Checklist

### Previous State
- [ ] Previous index location documented
- [ ] Previous chunk count recorded
- [ ] Previous manifest file noted

### Rollback Steps
- [ ] Step 1: [remove new index / restore old index]
- [ ] Step 2: [verify rollback]
- [ ] Step 3: [confirm Stage 3A works]

### Validation After Rollback
- [ ] Run test query — new source not in results
- [ ] Stage 3A still returns expected results
- [ ] Manifest reflects previous state

### Fallback Confirmation
- [ ] Stage 3A available and working
- [ ] No degradation in deterministic retrieval

---

## Storage and Validation Planning Checklist

### Storage Path
- [ ] Primary storage: `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
- [ ] Memory file: `semantic-approved-docs-memory.json` (or new name)
- [ ] Manifest file: `semantic-manifest-[timestamp].json`

### Validation Plan
- [ ] Post-ingestion query tests planned
- [ ] Stage 3A comparison tests planned (≥70% overlap)
- [ ] Quality gate checks planned (all 8 gates)
- [ ] Pass/fail criteria defined

---

## Human Approval Checklist

### Approval Points
- [ ] Source class approved by human
- [ ] Class C scope approved by human (if applicable)
- [ ] Denied-data check result approved by human
- [ ] Storage path approved by human
- [ ] Rollback plan approved by human
- [ ] Validation plan approved by human
- [ ] **No ingestion without explicit human approval**

### Approval Decision
- [ ] Decision recorded: APPROVED / DENIED / NEEDS MORE INFO
- [ ] Decision date recorded
- [ ] Decision notes recorded
- [ ] If DENIED: reason documented, proposer notified

---

## Post-Review Checklist (No Ingestion in Review-Only Phase)

### No Ingestion Performed
- [ ] No RuVector indexing run in Phase 8B.2
- [ ] No memory ingestion occurred
- [ ] RuVector remains prototype-only (398 chunks)
- [ ] No production memory promotion

### No Autonomous Actions
- [ ] Ingestion was supervised — human approved
- [ ] No autonomous learning loop activated
- [ ] No bypass of human approval
- [ ] No system/package/model config changes

### Report Generated
- [ ] Output formatted using `docs/workflows/templates/memory-ingestion-review-template.md`
- [ ] Report saved to `~/offload/security-reports/manual/` (default)
- [ ] Repo-local report (`reports/`) only if human explicitly requested
- [ ] Proposal ID, date, source class recorded in metadata

---

## Validation Checklist

### Standard Validators (Must All Pass)
```bash
gemma-evals-status    # Must be PASS
gemma-evals-check     # Must be PASS
gemma-examples-check # Must be PASS
```

### Boundary Verification
- [ ] No secrets in proposal
- [ ] No `.env` files accessed
- [ ] No raw logs accessed
- [ ] No browser data accessed
- [ ] No broad filesystem roots indexed
- [ ] No repo edits made
- [ ] No system/package/model config changes made
- [ ] No autonomous Agent Zero or Space Agent tasks spawned

### Final Decision Recorded
- [ ] APPROVED — proceed with future ingestion
- [ ] DENIED — do not proceed
- [ ] NEEDS MORE INFO — additional information required
- [ ] Reason documented in report

---

## Quick Reference: Source Classes

| Class | Meaning | Action |
|-------|---------|--------|
| **A — Approved Now** | Can be used without additional approval | Proceed to denied-data check, then manifest |
| **B — Prototype Metadata** | Metadata only, no ingestion needed | Note: already present, close review |
| **C — Future Approval Required** | Needs explicit human approval | Flag for approval, do not ingest without |
| **D — Denied** | Never allowed | Reject immediately, stop review |

---

## Quick Reference: Denied-Data Check Result

| Result | Action |
|--------|--------|
| **PASSED** | Proceed to manifest planning |
| **FAILED** | STOP — Reject source, report to human, do not ingest |

---

## Related Documents

- `WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md` — Full workflow definition
- `MEMORY_WORKFLOW_LIBRARY.md` — Workflow categories
- `MEMORY_BOUNDARIES.md` — Prototype boundaries
- `MEMORY_SOURCE_POLICY.md` — Source class definitions (A/B/C/D)
- `MEMORY_QUALITY_GATES.md` — 8 quality gates for production promotion
- `docs/workflows/templates/memory-ingestion-review-template.md` — Review template
- `docs/roadmap/ROADMAP.md` — Phase 8B.2 status

---

*Checklist version: 1.0*
*Phase: 8B.2*
*Status: Documentation-only — no RuVector indexing or memory ingestion in this phase*
*RuVector status: Prototype-only, 398 chunks (348 approved-doc + 50 Stage 3A), nomic-embed-text:latest, 768 dims*

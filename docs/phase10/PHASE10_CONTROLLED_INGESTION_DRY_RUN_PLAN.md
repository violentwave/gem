# Phase 10A: Controlled Ingestion Dry-Run Plan

## Purpose
Define a dry-run-only workflow for one safe, narrow, approved documentation source using existing Phase 9 planning helpers.

## Non-Goals
- No ingestion execution
- No indexing
- No RuVector mutation
- No memory promotion
- No wrapper default changes
- No helper installation
- No daemon/timer/background automation

## Strict No-Mutation Boundaries
- Never write to RuVector stores
- Never write to live eval stores under `~/.local/share/bazzite-security/gemma-evals/`
- Never run Agent Zero or Space Agent
- Never perform system/security/model/OpenCode permission changes
- Use `/tmp` only for temporary JSON artifacts
- Optional reports only to `~/offload/security-reports/manual/`

## Safe Source Criteria
- Narrow scope path
- Documentation-only content
- Fits approved classes and denied-data policy
- Human-reviewed intent and ownership

## Denied-Data Criteria
Reject any source containing or scoped to:
- secrets/tokens/passwords/.env
- browser/session storage artifacts
- raw logs, raw transcripts, provider private state
- broad roots (`~/.config`, `~/.local/share`, etc.) unless explicitly approved narrow exception exists

## Expected Dry-Run Artifact Locations
- Temporary plan artifacts: `/tmp/<run-id>/`
  - `proposal.json`
  - `denied-check.json`
  - `manifest-plan.json`
  - `rollback-plan.json`
- Optional markdown reports (only with `--write-report`): `~/offload/security-reports/manual/`

## Dry-Run Sequence
1. Source proposal (`gemma-memory-propose-source`)
2. Denied-data check (`gemma-memory-denied-data-check`)
3. Manifest plan (`gemma-memory-ingestion-plan`)
4. Rollback plan (`gemma-memory-rollback-plan`)
5. Known-answer checker (`./scripts/check-memory-known-answers.sh`)
6. Quality checker (`./scripts/check-gemma-memory-quality.sh`)
7. Stage 3A fallback confirmation (from manifest and rollback outputs)
8. Human approval packet assembly

## Validation Gates
- Proposal class and approval status are correct
- Denied-data status is explicit
- Manifest plan remains non-executable unless all gates pass
- Rollback plan is always non-executable
- Known-answer checker passes
- Quality checker passes
- Existing eval validators pass

## Stage 3A Fallback Confirmation
Dry-run output must explicitly state Stage 3A remains canonical fallback.

## Human Approval Requirements
- Human reviewer confirms source scope, denied-data result, and planning outputs
- Human reviewer explicitly approves or rejects next step
- No execution work proceeds from implicit approval

## Stop Conditions
- Any denied-data reject
- Missing or malformed JSON artifacts
- Manifest without explicit blockers/executable state
- Validator failures that affect trust in outputs
- Any boundary-violating command requested

## Readiness Decision Vocabulary
- `READY_FOR_DRY_RUN_REVIEW`: all dry-run artifacts valid, non-executable state preserved
- `BLOCKED_POLICY`: policy boundary violation or denied-data failure
- `BLOCKED_VALIDATION`: validator or artifact integrity failure
- `DEFERRED_HUMAN_APPROVAL`: packet complete, awaiting human decision

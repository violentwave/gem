# Memory Rollback And Reset Plan

## Status

Implementation complete (2026-05-02). Helper created.

See `docs/phase9/CONTROLLED_MEMORY_INGESTION_IMPLEMENTATION.md`.

The `gemma-memory-rollback-plan` helper is planning-only and always non-executable in Phase 9B.2.
It produces a rollback plan JSON but does not execute any revert operations.

## Goal

Define rollback/reset requirements that must exist before any future ingestion is allowed.

## Minimum Rollback Contents

- previous state identifier
- proposed new state identifier
- affected source scope
- manifest reference
- reset owner (human)
- explicit revert steps
- validation-after-reset steps
- Stage 3A fallback confirmation

## Required Reset Sequence

1. identify previous approved state
2. remove or disable newly introduced memory state
3. restore previous manifest/index state
4. verify Stage 3A deterministic retrieval still answers canonical checks
5. rerun validator set
6. record reset decision and reason

## Future Helper Role

`gemma-memory-rollback-plan` should only prepare a plan/report. It must not execute rollback autonomously.

## Trigger Conditions

- denied source slipped through review
- retrieval quality regression
- known-answer regression
- manifest mismatch
- stale-memory review failure
- human chooses to revert experimental ingestion

## Reset Validation Minimums

- Stage 3A fallback preserved
- `gemma-evals-status` PASS
- `gemma-evals-check` PASS
- `gemma-examples-check` PASS
- known-answer regression set unchanged or improved

## Boundary Rules

- no automatic rollback execution
- no background daemon/timer
- no promotion changes during rollback
- no broad filesystem cleanup

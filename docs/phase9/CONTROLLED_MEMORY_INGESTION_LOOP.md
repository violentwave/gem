# Phase 9B: Controlled Memory Ingestion Loop

## Status

Implementation complete (2026-05-02). Helpers created and tested.
- `helpers/gemma-memory-propose-source` ✓
- `helpers/gemma-memory-denied-data-check` ✓
- `scripts/check-memory-ingestion-proposal.sh` ✓

## Goal

Define a future human-approved ingestion loop for memory sources that preserves Stage 3A as canonical fallback and keeps RuVector supervised/prototype/secondary.

## Future Helpers In Scope

- `gemma-memory-propose-source`
- `gemma-memory-denied-data-check`
- `gemma-memory-ingestion-plan`
- `gemma-memory-rollback-plan`

## Required Properties

- human-approved source proposals only
- source classification A/B/C/D
- Class D rejection with no override
- denied-data scanning before approval
- manifest-backed ingestion
- rollback/reset path defined before ingestion
- stale-memory review before repeated ingestion cycles
- Stage 3A fallback preserved
- no autonomous ingestion

## Proposed Loop

1. **Proposal intake**
   - human or supervised operator proposes a narrowly scoped source
   - proposal includes purpose, path, and expected value
2. **Classification**
   - classify source as A/B/C/D
   - Class D stops immediately with rejection
   - Class B closes as metadata-only unless special planning says otherwise
3. **Denied-data scan**
   - scan proposed files against denied-data rules
   - any denied hit rejects the source
4. **Manifest planning**
   - enumerate approved files, exclusions, chunk expectations, storage path, validation commands
5. **Rollback/reset planning**
   - define prior state, revert procedure, fallback verification, and reset owner
6. **Human approval gate**
   - no ingestion without explicit approval of proposal + manifest + rollback plan
7. **Future supervised execution**
   - execution happens in a separate approved phase only
8. **Post-ingestion review**
   - verify Stage 3A fallback still works
   - verify validator health
   - record stale-memory review date

## Class Semantics

- **Class A:** approved-now scoped sources already aligned with policy
- **Class B:** prototype metadata only; not user-content ingestion
- **Class C:** future approval required; default deny until explicitly approved
- **Class D:** denied data or denied roots; reject with no override

## Approval Model

- default outcome without human approval: deny
- denied-data failures cannot be waived
- broad-root proposals are rejected and must be narrowed
- reports/logs are Class C only when explicitly scoped and sanitized

## Required Evidence Before Any Future Execution

- approved proposal record
- denied-data scan result
- manifest draft
- rollback/reset plan
- validation plan
- stale-memory review note

## Non-Goals

- autonomous ingestion
- auto-approval
- automatic wrapper promotion
- raw-log learning
- production memory replacement of Stage 3A

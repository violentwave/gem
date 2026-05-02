# Phase 10 Source Selection Criteria

## Allowed Documentation Source Types
- Phase planning docs under `docs/phase9/` or `docs/phase10/`
- Memory workflow docs under `docs/workflows/memory/`
- Explicitly approved knowledge docs under `~/.local/share/bazzite-security/gemma-knowledge/docs/`

## Forbidden Data Categories
- Secrets, tokens, passwords, `.env` content
- Raw logs and private runtime artifacts
- Browser/local/session storage data
- Agent Zero memory/state exports
- Space Agent state/config exports
- Unapproved private project code
- Unredacted transcripts

## Safe Narrow Source Examples
- `docs/phase9/EVAL_EXPANSION_PLAN.md`
- `docs/phase9/CONTROLLED_MEMORY_INGESTION_LOOP.md`
- `docs/phase10/PHASE10_CONTROLLED_INGESTION_DRY_RUN_PLAN.md`

## Rejected Source Examples
- `~/.config/*`
- `~/.local/share/*` (broad root)
- `~/offload/security-reports/*` (broad report root)
- any path containing `.env`, tokens, secrets, credentials

## Source-Size Guidance
- Prefer single-document or small bounded sets
- Avoid broad globs and whole-tree scopes
- Keep first dry-run source intentionally small and reviewable

## Source Ownership and Review Requirements
- Source must have clear ownership
- Operator must document why source is safe
- Reviewer must verify denied-data output and boundaries
- Human approval is required before any phase beyond dry-run planning

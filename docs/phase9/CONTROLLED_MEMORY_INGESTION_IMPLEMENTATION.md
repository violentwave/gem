# Phase 9B.1 Implementation: Controlled Memory Source Helpers

## Status

`2026-05-02` - Implementation complete, test passing.

## Goal

Implement repo-local helpers for controlled memory ingestion planning:
- source proposal CLI
- denied-data scan CLI
- wrapper script

**No ingestion, no indexing, no RuVector mutation.**

## Files Created

### Helpers

- `helpers/gemma-memory-propose-source` — CLI proposal generator
  - Creates schema-aligned JSON for memory source classification
  - Classes: A (approved), B (broad), C (narrow), D (denied)
  - Repo-relative paths in `docs/phase9` or `docs/workflows/memory` → Class A
  - Absolute paths under denied broad roots → Class D (reject, no override)
  - Output: `{proposal_id, submitted_at, source_path, source_class, purpose, expected_value, ...}`

- `helpers/gemma-memory-denied-data-check` — CLI denied-data scanner
  - Path-only scan by default
  - Content scan opt-in (`--scan-content`)
  - Scans for denied file patterns, extensions, content terms
  - Output: `{status: PASS|REJECT, matched_deny_rules, class_recommendation, ...}`

- `scripts/check-memory-ingestion-proposal.sh` — wrapper
  - Subcommands: `propose`, `denied-check`
  - Delegates to helpers

### Path Classification Logic

```
Class A: approved now (docs/phase9/*, docs/workflows/memory/*, repo-relative)
Class B: prototype metadata only (not user-content)
Class C: future approval required (narrow scope, requires explicit approval)
Class D: denied (broad roots ~/.config, ~/.local/share, cache, offload)
```

### Denied Broad Roots

- `.config`
- `.local/share`
- `.local/bin`
- `cache`
- `offload`

### Denied File Patterns

- `.env`, `.env.*`
- `*secret*`, `*token*`, `*credential*`, `*password*`, `*key*`
- `.git`, `__pycache__`, `node_modules`

### Denied Extensions

- `.log`, `.sqlite`, `.db`, `.sql`
- `.bak`, `.tar`, `.gz`, `.zip`, `.7z`, `.rar`
- `.bin`, `.exe`, `.so`, `.dll`, `.dylib`

### Denied Content Terms

- `api_key`, `api_secret`, `bearer`, `authorization`
- `x-api-key`, `private key`, `password`, `token`, `secret`
- `aws_access`, `aws_secret`, `gh_token`, `github_token`

## Usage Examples

### Propose a source

```bash
./helpers/gemma-memory-propose-source \
  --source docs/phase9/EVAL_EXPANSION_PLAN.md \
  --purpose "test proposal helper" \
  --expected-value "validate helper works"
```

Output:
```json
{
  "proposal_id": "proposal-20260502-002725",
  "source_class": "A",
  "approved_roots_only": true,
  "human_approval_status": "pending",
  ...
}
```

### Run denied-data check

```bash
./helpers/gemma-memory-denied-data-check \
  --source docs/phase9/EVAL_EXPANSION_PLAN.md
```

Output:
```json
{
  "status": "PASS",
  "class_recommendation": "A",
  "matched_deny_rules": [],
  ...
}
```

### Scan with content terms

```bash
./helpers/gemma-memory-denied-data-check \
  --source docs/phase9/EVAL_EXPANSION_PLAN.md \
  --scan-content
```

### Via wrapper

```bash
./scripts/check-memory-ingestion-proposal.sh propose \
  --source docs/phase9/EVAL_EXPANSION_PLAN.md \
  --purpose "..." --expected-value "..."

./scripts/check-memory-ingestion-proposal.sh denied-check \
  --source docs/phase9/EVAL_EXPANSION_PLAN.md
```

## Testing

- Proposal helper: tested with `docs/phase9/...` → Class A
- Denied-data check: tested with `docs/phase9/...` → PASS
- Wrapper: tested with `propose` subcommand → works

```bash
./helpers/gemma-memory-propose-source --source docs/phase9/EVAL_EXPANSION_PLAN.md --purpose "test" --expected-value "test"
# → source_class: A, human_approval_status: pending

./helpers/gemma-memory-denied-data-check --source docs/phase9/EVAL_EXPANSION_PLAN.md
# → status: PASS, class_recommendation: A
```

## Non-Goals (Future Phases)

- Phase 9B.2: manifest helper (enumerate files, chunks, storage path, validation commands)
- Phase 9B.3: rollback helper (define prior state, revert procedure, fallback verification)
- No wrapper promotion to `~/.local/bin`
- No automatic execution or daemon
- No RuVector mutation

## Related Docs

- `docs/phase9/CONTROLLED_MEMORY_INGESTION_LOOP.md` — loop design (Phase 9B)
- `docs/phase9/MEMORY_SOURCE_PROPOSAL_SCHEMA.md` — proposal schema (Phase 9B)
- `docs/phase9/MEMORY_DENIED_DATA_SCAN_RULES.md` — denied scan rules (Phase 9B)
- `docs/phase9/MEMORY_MANIFEST_SCHEMA.md` — manifest schema (Phase 9B.2)
- `docs/phase9/MEMORY_ROLLBACK_AND_RESET_PLAN.md` — rollback plan (Phase 9B.3)
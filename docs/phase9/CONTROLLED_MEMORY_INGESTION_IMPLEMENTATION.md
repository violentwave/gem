# Phase 9B.1 Implementation: Controlled Memory Source Helpers

## Status

`2026-05-02` - Phase 9B.1 complete. Phase 9B.2 in progress.

## Goal

Implement repo-local helpers for controlled memory ingestion planning:
- source proposal CLI
- denied-data scan CLI
- wrapper script
- manifest planning CLI
- rollback planning CLI

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

- Phase 9B.3: rollback helper (define prior state, revert procedure, fallback verification)
- No wrapper promotion to `~/.local/bin`
- No automatic execution or daemon
- No RuVector mutation

---

# Phase 9B.2 Implementation: Manifest and Rollback Planning Helpers

## Goal

Implement repo-local helpers for manifest and rollback planning:
- ingestion plan CLI
- rollback plan CLI

**No ingestion, no indexing, no RuVector mutation.**

## Files Created

### Helpers

- `helpers/gemma-memory-ingestion-plan` — CLI manifest planner
  - Creates manifest-shaped ingestion plan from proposal + denied-data JSON
  - Refuses to create executable plan without human approval
  - Output: `{manifest_id, proposal_id, input_source, source_class, approved_by, storage_path, ...}`

- `helpers/gemma-memory-rollback-plan` — CLI rollback planner
  - Creates rollback/reset plan from manifest JSON
  - Non-executable by default (planning artifact only)
  - Output: `{rollback_plan_id, manifest_id, revert_steps, validation_after_reset, ...}`

### Wrapper Updated

- `scripts/check-memory-ingestion-proposal.sh`
  - Added: `ingestion-plan` subcommand
  - Added: `rollback-plan` subcommand
  - Existing `propose`, `denied-check` preserved

### Blocking Logic

The ingestion-plan helper blocks execution when:
- `source_class` is `D` → BLOCKED_DENIED_SOURCE
- `human_approval_status` is not `approved` → BLOCKED_PENDING_APPROVAL
- denied-data `status` is `REJECT` → BLOCKED_DENIED_DATA
- denied-data `class_recommendation` is `D` → BLOCKED_DENIED_CLASS

Default output for blocked plans:
- `plan_status`: BLOCKED_PENDING_APPROVAL (or BLOCKED)
- `executable`: false
- `blockers`: list of blocking reasons

### Manifest Defaults

- `storage_path`: `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
- `embedding_model`: `nomic-embed-text:latest`
- `embedding_dimensions`: 768
- `fallback_status`: "Stage 3A deterministic retrieval preserved as canonical fallback"
- `validation_commands`: check-memory-known-answers.sh, check-gemma-memory-quality.sh, gemma-evals-status, gemma-evals-check, gemma-examples-check
- `stale_review_due`: "before repeated ingestion cycles"

### Rollback Defaults

- `executable`: always false in Phase 9B.2
- `stage3a_fallback_confirmation`: "Stage 3A deterministic retrieval preserved as canonical fallback"
- `validation_after_reset`: same validators as manifest
- `trigger_conditions`: denied source, quality regression, known-answer regression, manifest mismatch, stale-memory failure, human choice

### Class B Correction

- **Class B**: prototype metadata only; not user-content ingestion
- Class B should NOT be described as "broad"

## Usage Examples

### Create ingestion plan

```bash
./helpers/gemma-memory-ingestion-plan \
  --proposal-json /tmp/proposal.json \
  --denied-check-json /tmp/denied.json
```

Output (blocked):
```json
{
  "manifest_id": "manifest-20260502-...",
  "plan_status": "BLOCKED_PENDING_APPROVAL",
  "executable": false,
  "blockers": ["pending_human_approval"],
  "fallback_status": "Stage 3A deterministic retrieval preserved...",
  ...
}
```

### Create rollback plan

```bash
./helpers/gemma-memory-rollback-plan \
  --manifest-json /tmp/manifest.json
```

Output:
```json
{
  "rollback_plan_id": "rollback-manifest-...",
  "executable": false,
  "stage3a_fallback_confirmation": "Stage 3A deterministic retrieval preserved...",
  "validation_after_reset": [...],
  ...
}
```

### Via wrapper

```bash
./scripts/check-memory-ingestion-proposal.sh ingestion-plan \
  --proposal-json /tmp/proposal.json \
  --denied-check-json /tmp/denied.json

./scripts/check-memory-ingestion-proposal.sh rollback-plan \
  --manifest-json /tmp/manifest.json
```

## Testing

- Ingestion plan helper: creates plan with executable=false for pending approval
- Rollback plan helper: creates non-executable plan
- Wrapper: ingestion-plan and rollback-plan subcommands work
- Denied source blocking: tested with Class D source → blocked

## Boundaries

- No ingestion performed
- No indexing performed
- No RuVector mutation
- No live eval store modifications
- Generated reports only to `~/offload/security-reports/manual/` with `--write-report`
- Plans are non-executable by default until human approval

## Related Docs

- `docs/phase9/CONTROLLED_MEMORY_INGESTION_LOOP.md` — loop design (Phase 9B)
- `docs/phase9/MEMORY_SOURCE_PROPOSAL_SCHEMA.md` — proposal schema (Phase 9B)
- `docs/phase9/MEMORY_DENIED_DATA_SCAN_RULES.md` — denied scan rules (Phase 9B)
- `docs/phase9/MEMORY_MANIFEST_SCHEMA.md` — manifest schema (Phase 9B.2)
- `docs/phase9/MEMORY_ROLLBACK_AND_RESET_PLAN.md` — rollback plan (Phase 9B.3)
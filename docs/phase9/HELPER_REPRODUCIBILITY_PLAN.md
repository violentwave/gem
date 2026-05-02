# Phase 9A: Helper Source Reproducibility Plan

## Status

Implementation-ready and partially implemented in repo metadata. Sanitized helper templates and user-local install/check scripts now exist in the repo. No live helper replacement occurred automatically.

## Goal

Make `gemma-memory-search` and `gemma-memory-rag` reproducible from sanitized repo-tracked sources without blindly copying live `~/.local/bin/` state into the repo.

## Scope

- Track sanitized source templates for:
  - `gemma-memory-search`
  - `gemma-memory-rag`
- Plan user-local install/check helpers only.
- Preserve live canonical path ownership under `~/.local/bin/`.

## Repo Paths

- `helpers/gemma-memory-search`
- `helpers/gemma-memory-rag`
- `scripts/install-gemma-memory-helpers.sh`
- `scripts/check-gemma-memory-helpers.sh`
- `docs/phase9/HELPER_REPRODUCIBILITY_IMPLEMENTATION.md`

## Source Capture Rules

- Do not commit direct dumps of `~/.local/bin/`.
- Create sanitized, reviewed source copies only.
- Exclude runtime comments, machine-specific paths beyond approved canonical paths, logs, generated reports, secrets, and local state.
- Treat repo copies as reviewed templates, not authoritative live state.

## Planned Installer Behavior

`scripts/install-gemma-memory-helpers.sh` should:

- install to `~/.local/bin/` only
- require no sudo
- support `--dry-run`
- compare source and target checksums before overwrite
- show per-file change summary
- require safe overwrite confirmation when content differs
- validate executable bit after copy
- run `python3 -m py_compile` for Python helpers when applicable
- fail closed if destination escapes `~/.local/bin/`

## Planned Checker Behavior

`scripts/check-gemma-memory-helpers.sh` should:

- compare repo templates to live `~/.local/bin/` targets by checksum
- report `MATCH`, `MISSING`, or `DRIFT`
- support non-mutating dry-run/check mode by default
- verify executable bit
- run `python3 -m py_compile` where applicable
- avoid broad scans outside the two approved helper targets

## Review Workflow

1. Human reviews sanitized helper source proposed for repo tracking.
2. Repo template is updated only from approved sanitized source.
3. Checker confirms drift before install.
4. Installer performs explicit user-local copy to `~/.local/bin/`.
5. Validation runs compile/permission checks.

## Boundaries Preserved

- No wrapper default changes
- No RuVector promotion
- No autonomous helper deployment
- No package installs
- No system/service/model/OpenCode permission changes
- No generated reports/logs committed

## Readiness Criteria For Future Implementation

- Sanitized helper templates exist in repo
- Installer/checker scripts are specified and reviewed
- Overwrite confirmation behavior is explicit
- Validation behavior is documented
- Live helper state remains separate from repo metadata

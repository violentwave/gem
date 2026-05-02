# Helper Reproducibility Implementation

## Status

Bounded Phase 9A implementation complete for repo-tracked helper reproducibility.

## Files Added

- `helpers/gemma-memory-search`
- `helpers/gemma-memory-rag`
- `scripts/check-gemma-memory-helpers.sh`
- `scripts/install-gemma-memory-helpers.sh`
- `docs/phase9/HELPER_REPRODUCIBILITY_IMPLEMENTATION.md`

## What Was Implemented

- Sanitized repo-tracked templates for the two approved live helpers only.
- A non-mutating drift checker for repo templates vs `~/.local/bin/`.
- A user-local installer supporting `--dry-run` and interactive overwrite confirmation.

## Drift Check

Run:

```bash
./scripts/check-gemma-memory-helpers.sh
```

The checker inspects only:

- `helpers/gemma-memory-search`
- `helpers/gemma-memory-rag`
- `~/.local/bin/gemma-memory-search`
- `~/.local/bin/gemma-memory-rag`

It reports each helper as:

- `MATCH`
- `MISSING`
- `DRIFT`

## Dry-Run Install

Run:

```bash
./scripts/install-gemma-memory-helpers.sh --dry-run
```

This prints planned actions without writing to `~/.local/bin/`.

## Install

Interactive install:

```bash
./scripts/install-gemma-memory-helpers.sh
```

Noninteractive overwrite:

```bash
./scripts/install-gemma-memory-helpers.sh --yes
```

## Validation

Recommended checks:

```bash
chmod +x scripts/check-gemma-memory-helpers.sh scripts/install-gemma-memory-helpers.sh helpers/gemma-memory-search helpers/gemma-memory-rag
python3 -m py_compile helpers/gemma-memory-search
python3 -m py_compile helpers/gemma-memory-rag
./scripts/check-gemma-memory-helpers.sh
./scripts/install-gemma-memory-helpers.sh --dry-run
```

If available:

```bash
shellcheck scripts/check-gemma-memory-helpers.sh scripts/install-gemma-memory-helpers.sh
```

## Rollback Note

If a live helper needs to be restored, recover the previous `~/.local/bin/` helper from a backup if available, or restore the repo template version with git and reinstall:

```bash
git checkout -- helpers/gemma-memory-search helpers/gemma-memory-rag
./scripts/install-gemma-memory-helpers.sh --yes
```

## Boundaries Preserved

- No wrapper defaults changed
- No RuVector promotion performed
- No memory ingestion/indexing performed
- No daemon or timer added
- No package install performed
- No sudo used
- No model changes performed
- No OpenCode permission changes performed

# Phase 8D.3 Initial Baseline Commit

**Phase:** 8D.3
**Status:** Planned — pre-commit summary
**Date:** 2026-04-30

---

## Purpose

Establish the first tracked Git baseline for the Bazzite Local AI Operations Stack coordination repo and push it to a private GitHub repository named `gem`.

---

## GitHub Target

- Repository name: `gem`
- Intended visibility: private
- Owner: `violentwave`
- Branch: `main`

---

## Approved Tracked Set

Explicit-path staging only. Do not run `git add .`.

- `.gitignore`
- `README.md`
- `AGENTS.md`
- `docs/`
- `inventory/`
- `prompts/`
- `scripts/inventory/collect-live-inventory.sh`
- `prototypes/ruvector-memory/README.md`
- `prototypes/ruvector-memory/package.json`
- `prototypes/ruvector-memory/package-lock.json`
- `prototypes/ruvector-memory/src/`

---

## Must Not Track

- `.env` files
- API keys, secrets, tokens, credentials, cookies, sessions
- raw logs and unredacted transcripts
- generated runtime reports
- `~/offload` content
- `~/.local` content
- `~/.config` content
- Space Agent state
- Agent Zero memory
- `node_modules/`
- caches
- model files
- database/runtime state
- temp/build artifacts

---

## Package-Lock Decision

`prototypes/ruvector-memory/package-lock.json` exists and is 92K. A narrow `.gitignore` exception was added so this prototype lockfile can be tracked for reproducibility without unignoring other lockfiles.

---

## Validation Commands

Before commit:

```bash
git status --short
git diff --cached --stat
git diff --cached --name-only
git diff --cached --check
gemma-evals-status
gemma-evals-check
gemma-examples-check
python3 -m py_compile ~/.local/bin/gemma-memory-search
test -x ~/.local/bin/gemma-memory-search
```

Before push:

```bash
gh auth status
gh api user --jq .login
gh repo view violentwave/gem --json name,visibility,url || true
git remote -v
```

---

## Evidence

Commit SHA, GitHub URL, and push status will be recorded after the baseline commit and push complete.

---

*Pre-commit summary created: 2026-04-30*

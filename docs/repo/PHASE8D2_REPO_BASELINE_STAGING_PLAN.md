# Phase 8D.2 Repo Baseline Staging Plan

**Phase:** 8D.2
**Status:** Completed — planning only
**Date:** 2026-04-30
**Repo:** `/var/home/lch/projects/gem`

---

## Result

`baseline_staging_plan_created_no_staging`

No files were staged, committed, or pushed. Do not run `git add .`.

---

## Current Git State

- Git repo: yes
- Git top-level: `/var/home/lch/projects/gem`
- Tracked files: 0
- Untracked files: 125
- Ignored path entries shown by `git status --ignored --short`: 3
- Detailed ignored path scan observed 4508 ignored paths, all under `prototypes/ruvector-memory/node_modules/`
- `.gitattributes`: not present

Untracked top-level summary:

| Top-level path | Count |
|----------------|-------|
| `.gitignore` | 1 |
| `AGENTS.md` | 1 |
| `README.md` | 1 |
| `docs/` | 77 |
| `inventory/` | 5 |
| `prompts/` | 30 |
| `prototypes/` | 9 |
| `scripts/` | 1 |

---

## .gitignore Assessment

`.gitignore` exists and safely excludes the expected generated/runtime classes:

- logs: `*.log`, `logs/`, `logs-*/`
- reports: `reports/`
- raw logs/transcripts: `raw-logs/`, `*.transcript`, `unredacted/`
- caches/temp: `.cache/`, `__pycache__/`, `.pytest_cache/`, `.tox/`, `.nox/`
- dependency/build output: `node_modules/`, `dist/`, `build/`, archives
- database/index files: `*.db`, `*.sqlite`, `*.sqlite3`, `*.index`, `*.hnsw`
- model files: `*.gguf`, `*.bin`, `*.onnx`, `*.pt`, `*.pth`, `*.safetensors`
- secret/env files: `.env`, `.env.*`, `*.env`, `secrets*`, `*secret*`, `*token*`, `*key*`, cert/key formats
- private artifacts: `artifacts/private/`, `inventory/raw/`

No `.gitignore` update was made in this phase.

Review note: `package-lock.json` is ignored. If `prototypes/ruvector-memory/package-lock.json` is intentionally needed for reproducibility, decide explicitly in a later phase whether to adjust `.gitignore` narrowly and stage it with `git add -f`; do not do that by default.

---

## Recommended To Track

These are source/planning files that appear appropriate for an initial baseline, subject to human review before staging:

- `.gitignore`
- `README.md`
- `AGENTS.md`
- `docs/**/*.md`
- `inventory/**/*.md`
- `prompts/**/*.txt`
- `scripts/inventory/collect-live-inventory.sh`
- `prototypes/ruvector-memory/README.md`
- `prototypes/ruvector-memory/package.json`
- `prototypes/ruvector-memory/src/*.mjs`

Recommended explicit staging command, if human approves Phase 8D.3:

```bash
git add .gitignore README.md AGENTS.md docs inventory prompts scripts/inventory/collect-live-inventory.sh prototypes/ruvector-memory/README.md prototypes/ruvector-memory/package.json prototypes/ruvector-memory/src
```

Do not run this command in Phase 8D.2. It is a proposed command for a later human-approved phase.

---

## Review Before Tracking

Review these before any staging decision:

- `prototypes/ruvector-memory/package-lock.json` — currently ignored; may be useful for reproducibility, but should not be added without an explicit lockfile decision.
- `prototypes/ruvector-memory/reports/` — generated prototype reports; keep ignored unless a specific sanitized report is intentionally promoted into docs.
- Large or binary files, if any appear in future scans.
- Screenshots/images, if any appear in future scans.
- Any file with unclear provenance or unclear ownership.

No untracked filename/path-only checks found obvious risky names matching `.env`, `key`, `token`, `secret`, `credential`, `cookie`, `session`, `Local Storage`, or `Trust Tokens`.

---

## Must Not Track

Do not stage or commit:

- `.env` files
- API keys, secrets, tokens, credentials, cookies, sessions
- raw logs or unredacted transcripts
- generated reports unless sanitized and intentionally copied into docs
- `~/offload` content
- `~/.local` content
- `~/.config` content
- Space Agent state
- Agent Zero memory
- `node_modules/`
- cache directories
- model files
- database/runtime state
- temporary/build artifacts

Current ignored must-not-track examples visible by path:

- `prototypes/ruvector-memory/node_modules/`
- `prototypes/ruvector-memory/reports/`

---

## Proposed Validation Commands After Staging

If Phase 8D.3 is approved and files are staged explicitly, run:

```bash
git status --short
git diff --cached --stat
git diff --cached --name-only
git diff --cached --check
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

Before committing, manually confirm that the staged file list contains only intended repo source/planning files and no runtime outputs, secrets, dependency directories, model files, or databases.

---

## Proposed Initial Commit Message

```text
docs: establish local AI operations baseline
```

Rationale: the first tracked baseline should capture coordination docs, prompts, sanitized inventory summaries, repo rules, and prototype source without runtime artifacts.

---

## Explicit Warning

Do not run `git add .`.

Use explicit paths only, and only after human approval in Phase 8D.3.

---

## Boundaries Preserved

- No staging performed
- No commit created
- No push performed
- No secrets/raw logs/browser state inspected
- No Agent Zero, Space Agent, RuVector indexing, memory ingestion, or RAG generation performed
- No `.gitignore` broadening that would hide docs/prompts/source

---

*Plan created: 2026-04-30*
*Status: Ready for human review before any Phase 8D.3 staging action*

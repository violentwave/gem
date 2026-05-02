# Phase 24A: Release Tagging Workflow

**Phase:** 24A — Release Tagging Workflow
**Date:** 2026-05-02
**Parent:** Phase 24 (Release / Recovery / Migration Discipline)
**Status:** COMPLETE

---

## Purpose

Create a workflow for tagging releases with semantic versioning.

---

## Script: gemma-release-tag

**Path:** `~/.local/bin/gemma-release-tag`
**Usage:** `gemma-release-tag [patch|minor|major]`

### Workflow Steps

1. Validate release type (patch/minor/major)
2. Check for uncommitted changes
3. Get current version from git tags
4. Bump version according to SemVer
5. Run eval validators (must PASS)
6. Generate release notes
7. Create annotated git tag
8. Prompt to push tag
9. Create rollback bundle

### Features

- Semantic versioning (vMAJOR.MINOR.PATCH)
- Pre-release validation (evals must PASS)
- Release notes generation
- Rollback bundle creation
- Interactive push confirmation

### Example

```bash
gemma-release-tag patch
# Creates v0.0.1 (or next patch version)
# Runs evals
# Generates RELEASE_NOTES_v0.0.1.md
# Creates rollback bundle
```

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Script created | PASS | ~/.local/bin/gemma-release-tag |
| Executable | PASS | chmod +x applied |
| Syntax valid | PASS | bash -n passed |
| SemVer logic | PASS | patch/minor/major |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 24A: COMPLETE
- Next: Phase 24B (Rollback Bundle Creation)

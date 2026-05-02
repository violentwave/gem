# Phase 15C: Release Process and Rollback Bundle Policy

**Phase:** 15C — Release Process and Rollback Bundle Policy
**Date:** 2026-05-02
**Parent:** Phase 15 (Production Hardening)
**Status:** COMPLETE

---

## Purpose

Define a lightweight release process, tagging convention, and rollback bundle policy for the Bazzite Local AI Operations Stack.

---

## Release Philosophy

This is a **personal coordination repo**, not a production service. Releases are documentation milestones, not deployable artifacts. The release process is lightweight and manual.

---

## Release Process

### Trigger Conditions

A release is triggered when:
- A major phase completes (e.g., Phase 14 macro)
- Critical documentation is updated
- A new helper is added and validated
- A security boundary is modified

### Release Steps

#### Step 1: Pre-Release Validation
```bash
gemma-evals-check
gemma-examples-check
gemma-evals-status
gemma-bazzite-health
```
All must PASS before release.

#### Step 2: Version Bump
Update version in:
- `docs/live-system/CURRENT_STATE.md`
- Git tag (semantic versioning)

#### Step 3: Changelog Update
Add entry to `docs/CHANGELOG.md` (create if missing):
- Date
- Version
- Summary of changes
- Breaking changes (if any)
- Security changes (if any)

#### Step 4: Git Tag
```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z: Description"
```

#### Step 5: Push
```bash
git push origin main
git push origin vX.Y.Z
```

#### Step 6: Post-Release Verification
```bash
gemma-bazzite-health
gemma-opencode-check
```

---

## Versioning Convention

### Semantic Versioning for Repo

| Component | Meaning | Example |
|-----------|---------|---------|
| Major (X) | Phase completion, architecture change | v1.0.0, v2.0.0 |
| Minor (Y) | Sub-phase completion, new helpers | v1.1.0, v1.2.0 |
| Patch (Z) | Documentation fixes, bug fixes | v1.1.1, v1.1.2 |

### Version Examples

| Version | Meaning |
|---------|---------|
| v0.14.0 | Phase 14 macro complete |
| v0.15.0 | Phase 15 macro complete |
| v1.0.0 | First stable release (all phases complete) |

---

## Rollback Bundle Policy

### What is a Rollback Bundle?

A rollback bundle is a snapshot of critical state that can be restored if a release causes issues.

### Bundle Contents

| Item | Source | Rationale |
|------|--------|-----------|
| Modelfile | `~/.config/bazzite-security/ollama/Modelfile.gemma4-e4b-bazzite` | Model behavior |
| Helper scripts | `~/.local/bin/gemma-*` | Tooling |
| Knowledge pack index | `~/.local/share/bazzite-security/gemma-knowledge/index/` | RAG data |
| Eval manifests | `~/.local/share/bazzite-security/gemma-evals/manifests/` | Validation state |
| RuVector manifest | `~/.local/share/bazzite-security/ruvector/` | Semantic memory |
| Config docs | `~/.config/bazzite-security/*.md` | Policies |

### Bundle Creation

```bash
# Create rollback bundle
gemma-rollback-bundle create vX.Y.Z
# Creates: ~/offload/security-reports/rollback/rollback-vX.Y.Z-YYYYMMDD.tar.gz
```

### Bundle Policy

1. **Create before major changes** — Always create a bundle before modifying helpers or configs
2. **Keep last 5 bundles** — Auto-remove older bundles
3. **Store in ~/offload/** — Never store bundles in repo
4. **No secrets** — Bundles must not contain .env, tokens, or keys
5. **Test restore** — Verify bundle can be extracted and restore works

### Rollback Procedure

1. Stop any running services (Ollama, Agent Zero, etc.)
2. Extract rollback bundle to temp location
3. Verify bundle contents
4. Replace current files with bundle files
5. Run validators
6. Restart services
7. Verify functionality

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Release process defined | PASS | 6 steps |
| Versioning convention | PASS | SemVer for repo |
| Rollback bundle policy | PASS | 5 items in bundle |
| Bundle creation procedure | PASS | Documented |
| Rollback procedure | PASS | 7 steps |
| No secrets in bundles | PASS | Explicitly excluded |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 15C: COMPLETE
- Release process: DEFINED (6 steps)
- Versioning: SemVer
- Rollback policy: DOCUMENTED
- Next: Phase 15D (Smoke Test Matrix)

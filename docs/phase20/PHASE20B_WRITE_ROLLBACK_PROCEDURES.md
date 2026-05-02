# Phase 20B: Write ROLLBACK_PROCEDURES.md

**Phase:** 20B — Write ROLLBACK_PROCEDURES.md
**Date:** 2026-05-02
**Parent:** Phase 20 (Knowledge Pack Expansion Implementation)
**Status:** COMPLETE

---

## Purpose

Create rollback procedures for all components in the Bazzite Local AI Operations Stack.

---

## Document: ROLLBACK_PROCEDURES.md

**Path:** `~/.config/bazzite-security/ROLLBACK_PROCEDURES.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/ROLLBACK_PROCEDURES.md`

### Rollback Procedures

| Component | Procedure |
|-----------|-----------|
| Helper Script | Remove single script, restore from backup |
| Batch Helpers | Remove all, restore from manifest |
| Ollama Profile | Revert Modelfile, delete custom profile |
| Knowledge Pack | Revert to previous index, remove added docs |
| RuVector | Remove index, disable RuVector |
| Git | Revert commit, restore specific file |
| OpenCode Config | Revert config changes |
| Agent Zero | Stop and remove container, remove image |
| Space Agent | Remove AppImage, remove config |
| Full Stack | Emergency reset (preserves models) |

### Preserve List

The following are NEVER removed by rollback:
- Ollama models
- Base system config
- User home directory data
- Git repository
- System security tools

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Document created | PASS | ~/.config/bazzite-security/ROLLBACK_PROCEDURES.md |
| Copied to knowledge pack | PASS | ~/.local/share/bazzite-security/gemma-knowledge/docs/ |
| 10 components | PASS | All covered |
| Preserve list | PASS | 5 items |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 20B: COMPLETE
- ROLLBACK_PROCEDURES.md: CREATED
- Next: Phase 20C (AGENT_ZERO_BOUNDARIES.md)

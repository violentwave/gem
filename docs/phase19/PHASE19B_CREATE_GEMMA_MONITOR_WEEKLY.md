# Phase 19B: Create gemma-monitor-weekly

**Phase:** 19B — Create gemma-monitor-weekly
**Date:** 2026-05-02
**Parent:** Phase 19 (Monitoring / Eval / Security Implementation)
**Status:** COMPLETE

---

## Purpose

Create the weekly deep check script that runs daily checks plus additional weekly checks.

---

## Script: gemma-monitor-weekly

**Path:** `~/.local/bin/gemma-monitor-weekly`
**Language:** Bash
**Permissions:** executable

### Checks Implemented

| # | Check | Status |
|---|-------|--------|
| 1 | Daily checks (via gemma-monitor-daily) | ✅ Implemented |
| 2 | Knowledge pack docs | ✅ Implemented |
| 3 | Knowledge index age | ✅ Implemented |
| 4 | RuVector index age | ✅ Implemented |
| 5 | Eval validation | ✅ Implemented |
| 6 | Helper scripts count | ✅ Implemented |
| 7 | Helper executability | ✅ Implemented |
| 8 | Recent reports | ✅ Implemented |
| 9 | Archive items | ✅ Implemented |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Script created | PASS | ~/.local/bin/gemma-monitor-weekly |
| Executable | PASS | chmod +x applied |
| Syntax valid | PASS | bash -n passed |
| All 9 checks | PASS | Implemented |

| Category | Count |
|----------|-------|
| PASS | 4 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 19B: COMPLETE
- gemma-monitor-weekly: CREATED
- Next: Phase 19C (Create gemma-monitor-drift)

# Phase 16A: Automated Monitoring

**Phase:** 16A — Automated Monitoring
**Date:** 2026-05-02
**Parent:** Phase 16 (Automated Monitoring / Knowledge Expansion)
**Status:** COMPLETE

---

## Purpose

Design lightweight monitoring scripts that automate the daily and weekly checks from the operator runbook (Phase 15E). These scripts are designed for **manual execution** (not background automation) but structured for easy future scheduling.

---

## Design Principles

1. **Manual execution** — Run on-demand, not as daemon/timer (per safety constraints)
2. **Structured output** — Consistent PASS/WARN/FAIL reporting
3. **Lightweight** — Fast execution, minimal resource usage
4. **Extensible** — Easy to add new checks
5. **Log rotation aware** — Don't grow unbounded

---

## Monitoring Scripts Design

### 1. Daily Health Monitor

**Purpose:** Run all daily checks from Phase 15E runbook in one command.

**Checks:**
- Ollama health (`ollama --version`, API reachability)
- Gemma model availability
- OpenCode bridge health
- Eval system status
- Log file sizes (warn if >100MB)
- Disk usage (warn if >80%)

**Output Format:**
```
=== Daily Health Monitor ===
Date: 2026-05-02 08:00:00

[Infrastructure]
✅ Ollama: v0.22.0 running
✅ Gemma model: gemma4-e4b-bazzite available
✅ GPU: GTX 1060 6GB, 3.2GB used

[Integration]
✅ OpenCode bridge: 127.0.0.1:4141 reachable

[Validation]
✅ Eval cases: 25 PASS
✅ Examples: 32 PASS

[Resources]
✅ Disk: 45% used
⚠️  Logs: ~/.local/state/.../gemma-memory-search.log (120MB)

[Summary]
Pass: 6 | Warn: 1 | Fail: 0
Duration: 8.2s
```

**Execution:**
```bash
gemma-monitor-daily
```

---

### 2. Weekly Deep Check

**Purpose:** Run comprehensive weekly checks from Phase 15E runbook.

**Checks:**
- All daily checks
- Knowledge pack freshness (index age vs docs)
- RuVector index freshness (if applicable)
- Eval coverage matrix (ensure all categories covered)
- Helper script checksums (detect modifications)
- Manifest completeness
- Report archive status
- Backup/rollback bundle status

**Output Format:**
```
=== Weekly Deep Check ===
Date: 2026-05-02

[Daily Checks]
✅ All daily checks PASS

[Knowledge Pack]
✅ Docs: 6 files
✅ Index: 234 chunks (indexed 2026-05-01)
✅ Freshness: < 7 days

[RuVector]
✅ Index: 398 chunks
⚠️  Age: 8 days (recommend re-index)

[Eval Coverage]
✅ Cases: 25 (command:10, knowledge:7, path:7, forbidden:1)
✅ Examples: 32 (all categories covered)

[Helpers]
✅ All 22 helpers executable
✅ Checksums: 22/22 match manifest

[Reports]
✅ Recent reports: 5
✅ Archive: 12 items

[Summary]
Pass: 11 | Warn: 1 | Fail: 0
Duration: 15.3s
Recommendations:
1. Re-index RuVector (age > 7 days)
```

**Execution:**
```bash
gemma-monitor-weekly
```

---

### 3. Drift Monitor

**Purpose:** Detect documentation and configuration drift.

**Checks:**
- CURRENT_STATE.md vs live counts (evals, examples, helpers)
- ROADMAP.md phase alignment
- Modelfile checksum
- New files in ~/.local/bin/ not in manifest
- Knowledge doc count vs index

**Output Format:**
```
=== Drift Monitor ===
Date: 2026-05-02

[Documentation Drift]
✅ CURRENT_STATE.md: 25 cases, 32 examples (matches live)
✅ ROADMAP.md: Phase 15 complete

[Config Drift]
✅ Modelfile: checksum matches

[Helper Drift]
✅ Manifest: 22/22 helpers accounted for
⚠️  New file: ~/.local/bin/gemma-test-helper (not in manifest)

[Knowledge Drift]
✅ Docs: 6 files, index: 234 chunks

[Summary]
Pass: 4 | Warn: 1 | Fail: 0
```

**Execution:**
```bash
gemma-monitor-drift
```

---

## Script Architecture

### Common Library

```bash
# gemma-monitor-lib.sh — shared functions
# Source this from all monitor scripts

monitor_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

monitor_pass() {
    echo "✅ $1"
}

monitor_warn() {
    echo "⚠️  $1"
}

monitor_fail() {
    echo "❌ $1"
}

monitor_section() {
    echo ""
    echo "[$1]"
}

monitor_summary() {
    echo ""
    echo "[Summary]"
    echo "Pass: $1 | Warn: $2 | Fail: $3"
    echo "Duration: ${4}s"
}
```

### Report Storage

| Monitor | Report Path | Retention |
|---------|-------------|-----------|
| Daily | `~/.local/state/bazzite-security/logs/monitor-daily-YYYYMMDD-HHMMSS.txt` | 7 days |
| Weekly | `~/.local/state/bazzite-security/logs/monitor-weekly-YYYYMMDD-HHMMSS.txt` | 30 days |
| Drift | `~/.local/state/bazzite-security/logs/monitor-drift-YYYYMMDD-HHMMSS.txt` | 30 days |

---

## Manual Scheduling Guide

While these scripts are designed for manual execution, they can be easily scheduled using standard Linux tools when desired:

### Using systemd timers (future)
```
# ~/.config/systemd/user/gemma-monitor-daily.timer
[Unit]
Description=Daily Bazzite AI Ops Monitor

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

### Using cron (future)
```bash
# Run daily at 8am
0 8 * * * ~/.local/bin/gemma-monitor-daily >/dev/null 2>&1

# Run weekly on Monday at 9am
0 9 * * 1 ~/.local/bin/gemma-monitor-weekly >/dev/null 2>&1
```

### Using at (one-time)
```bash
# Run tomorrow at 8am
echo "~/.local/bin/gemma-monitor-daily" | at 08:00 tomorrow
```

---

## Implementation Status

**This phase is DESIGN-ONLY.** No monitoring scripts are created or installed.

The designs are ready for implementation when:
- Human explicitly approves script creation
- A need for regular monitoring emerges
- Phase 16B-D are complete

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Daily monitor designed | PASS | 6 checks |
| Weekly monitor designed | PASS | 8 checks |
| Drift monitor designed | PASS | 4 checks |
| Common library designed | PASS | 5 functions |
| Report storage defined | PASS | 3 paths, retention rules |
| Scheduling guide documented | PASS | 3 methods |
| No daemon/timer created | PASS | Design-only |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 16A: COMPLETE
- Monitoring framework: DESIGNED
- Scripts: 3 monitors + 1 library
- Scheduling: Documented for future use
- Next: Phase 16B (Knowledge Pack Expansion)

# Phase 17A: Monitoring Script Implementation Plan

**Phase:** 17A — Monitoring Script Implementation Plan
**Date:** 2026-05-02
**Parent:** Phase 17 (Implementation Planning)
**Status:** COMPLETE

---

## Purpose

Create a detailed implementation plan for the monitoring scripts designed in Phase 16A, including pseudocode, file specifications, and deployment steps.

---

## Scripts to Implement

### 1. gemma-monitor-daily

**Path:** `~/.local/bin/gemma-monitor-daily`
**Language:** Bash
**Purpose:** Run all daily health checks in one command

#### Checks

| # | Check | Command | Expected | Timeout |
|---|-------|---------|----------|---------|
| 1 | Ollama version | `ollama --version` | Exit 0 | 5s |
| 2 | Ollama API | `curl -s http://127.0.0.1:11434/api/tags` | JSON with models | 5s |
| 3 | Gemma model available | `ollama list | grep gemma4-e4b-bazzite` | Match found | 5s |
| 4 | GPU usage | `nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits` | Value < 5000 | 5s |
| 5 | OpenCode bridge | `curl -s http://127.0.0.1:4141/health` | HTTP 200 | 5s |
| 6 | Eval system | `gemma-evals-check` | Exit 0 | 30s |
| 7 | Examples | `gemma-examples-check` | Exit 0 | 30s |
| 8 | Log sizes | `find ~/.local/state/bazzite-security/logs/ -size +100M` | Empty | 5s |
| 9 | Disk usage | `df -h ~/.local ~/.cache ~/offload | awk '{print $5}'` | All < 80% | 5s |

#### Pseudocode

```bash
#!/bin/bash
# gemma-monitor-daily
# Daily health monitor for Bazzite Local AI Ops Stack

source ~/.local/lib/gemma-monitor-lib.sh

PASS=0; WARN=0; FAIL=0
START=$(date +%s)

monitor_header "Daily Health Monitor"

# Infrastructure
monitor_section "Infrastructure"

if ollama --version >/dev/null 2>&1; then
    monitor_pass "Ollama: $(ollama --version 2>/dev/null | head -1)"
    ((PASS++))
else
    monitor_fail "Ollama: not running"
    ((FAIL++))
fi

if curl -s --max-time 5 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    monitor_pass "Ollama API: reachable"
    ((PASS++))
else
    monitor_fail "Ollama API: unreachable"
    ((FAIL++))
fi

# ... (additional checks)

monitor_summary $PASS $WARN $FAIL $(( $(date +%s) - START ))
exit $(( FAIL > 0 ? 2 : WARN > 0 ? 1 : 0 ))
```

#### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks PASS |
| 1 | One or more WARN |
| 2 | One or more FAIL |

---

### 2. gemma-monitor-weekly

**Path:** `~/.local/bin/gemma-monitor-weekly`
**Language:** Bash
**Purpose:** Run comprehensive weekly checks

#### Additional Checks (beyond daily)

| # | Check | Expected |
|---|-------|----------|
| 10 | Knowledge pack index age | < 7 days |
| 11 | RuVector index age | < 7 days |
| 12 | Eval coverage | All 8 categories present |
| 13 | Helper checksums | Match manifest |
| 14 | Manifest completeness | All helpers accounted |
| 15 | Report archive | < 50 items unarchived |
| 16 | Rollback bundle | Last bundle < 30 days |

#### Pseudocode

```bash
#!/bin/bash
# gemma-monitor-weekly
# Weekly deep check for Bazzite Local AI Ops Stack

source ~/.local/lib/gemma-monitor-lib.sh

# Run all daily checks first
gemma-monitor-daily --quiet
DAILY_EXIT=$?

# Additional weekly checks
monitor_section "Knowledge Pack"
INDEX_AGE=$(( ($(date +%s) - $(stat -c %Y ~/.local/share/.../index/chunks.jsonl)) / 86400 ))
if [ $INDEX_AGE -lt 7 ]; then
    monitor_pass "Index age: ${INDEX_AGE} days"
else
    monitor_warn "Index age: ${INDEX_AGE} days (recommend re-index)"
fi

# ... (additional checks)

monitor_summary $PASS $WARN $FAIL $(( $(date +%s) - START ))
```

---

### 3. gemma-monitor-drift

**Path:** `~/.local/bin/gemma-monitor-drift`
**Language:** Bash
**Purpose:** Detect documentation and configuration drift

#### Checks

| # | Check | Method |
|---|-------|--------|
| 17 | CURRENT_STATE.md vs live | Extract counts, compare |
| 18 | ROADMAP.md phase alignment | Check last phase entry |
| 19 | Modelfile checksum | sha256sum vs manifest |
| 20 | New helpers | ls ~/.local/bin/gemma-* vs manifest |
| 21 | Knowledge doc count | ls docs/ vs index |

---

### 4. gemma-monitor-lib.sh

**Path:** `~/.local/lib/gemma-monitor-lib.sh`
**Language:** Bash
**Purpose:** Shared library for all monitors

#### Functions

```bash
monitor_header() {
    echo "=== $1 ==="
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
}

monitor_section() {
    echo "[$1]"
}

monitor_pass() { echo "  ✅ $1"; }
monitor_warn() { echo "  ⚠️  $1"; }
monitor_fail() { echo "  ❌ $1"; }

monitor_summary() {
    echo ""
    echo "[Summary]"
    echo "Pass: $1 | Warn: $2 | Fail: $3"
    echo "Duration: ${4}s"
}
```

---

## Implementation Steps

### Step 1: Create Library
```bash
mkdir -p ~/.local/lib
cat > ~/.local/lib/gemma-monitor-lib.sh << 'EOF'
# (library content)
EOF
chmod 644 ~/.local/lib/gemma-monitor-lib.sh
```

### Step 2: Create Daily Monitor
```bash
cat > ~/.local/bin/gemma-monitor-daily << 'EOF'
#!/bin/bash
# (script content)
EOF
chmod +x ~/.local/bin/gemma-monitor-daily
```

### Step 3: Create Weekly Monitor
```bash
cat > ~/.local/bin/gemma-monitor-weekly << 'EOF'
#!/bin/bash
# (script content)
EOF
chmod +x ~/.local/bin/gemma-monitor-weekly
```

### Step 4: Create Drift Monitor
```bash
cat > ~/.local/bin/gemma-monitor-drift << 'EOF'
#!/bin/bash
# (script content)
EOF
chmod +x ~/.local/bin/gemma-monitor-drift
```

### Step 5: Validate
```bash
bash -n ~/.local/bin/gemma-monitor-daily
bash -n ~/.local/bin/gemma-monitor-weekly
bash -n ~/.local/bin/gemma-monitor-drift

gemma-monitor-daily
gemma-monitor-drift
```

### Step 6: Update Manifest
Add to helper manifest:
- gemma-monitor-daily
- gemma-monitor-weekly
- gemma-monitor-drift
- gemma-monitor-lib.sh

---

## Safety Boundaries

- ✅ All scripts read-only (no system modifications)
- ✅ All timeouts bounded (5-30s per check)
- ✅ No sudo required
- ✅ No network calls beyond localhost
- ✅ No secrets accessed
- ✅ No file modifications (read-only checks)

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Daily monitor spec | PASS | 9 checks |
| Weekly monitor spec | PASS | 16 checks (9 daily + 7 weekly) |
| Drift monitor spec | PASS | 5 checks |
| Library spec | PASS | 5 functions |
| Implementation steps | PASS | 6 steps |
| Safety boundaries | PASS | 6 confirmed |
| Scripts created | N/A | Planning only |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 17A: COMPLETE
- Monitoring scripts: PLANNED (4 scripts)
- Implementation steps: 6 steps documented
- Safety: All read-only
- Next: Phase 17B (Knowledge Doc Creation Plan)

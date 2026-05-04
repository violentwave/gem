# Security Dashboard Operator Guide

**Document:** Security Dashboard Operator Guide
**Date:** 2026-05-04
**Version:** 1.0
**Status:** Current

---

## What the Security Dashboard Is

The Bazzite Security Dashboard is a **static, read-only HTML page** that gives you a single-screen view of your host security posture. It inspects the state of `firewalld`, `usbguard`, `clamav`, `lynis`, and security timers without modifying anything.

Think of it as a **security instrument panel** — it tells you what is active, what is not, and what reports exist, but it does not fix anything for you.

---

## What the Security Dashboard Is NOT

- **Not a server.** It is a single HTML file on disk. No port is opened.
- **Not a daemon.** Watch mode runs only while the terminal command is active.
- **Not an agent.** It does not take actions, run scans, or make changes.
- **Not a replacement for `gemma-dashboard-build`.** The main dashboard shows AI stack status; this one shows host security status.

---

## How to Generate the Dashboard

### One-shot (default)

```bash
/var/home/lch/projects/gem/scripts/gemma-security-dashboard-build
```

### With browser open

```bash
/var/home/lch/projects/gem/scripts/gemma-security-dashboard-build --open
```

### Watch mode (foreground only)

```bash
# Default 60-second interval
/var/home/lch/projects/gem/scripts/gemma-security-dashboard-build --watch

# Custom interval (minimum 15 seconds)
/var/home/lch/projects/gem/scripts/gemma-security-dashboard-build --watch --interval 30
```

**Watch mode stops when you press Ctrl+C.** It is not a daemon and does not survive terminal closure.

---

## Output Paths

| Output | Path |
|--------|------|
| HTML dashboard | `~/.local/share/bazzite-security/security-dashboard/index.html` |
| Markdown report | `~/offload/security-reports/manual/security-dashboard-YYYYMMDD-HHMMSS.md` |
| Build log | `~/.local/state/bazzite-security/logs/security-dashboard-YYYYMMDD-HHMMSS.log` |

---

## What Each Panel Means

### 1. Security Summary

Gives you an **at-a-glance** view:
- **Overall Status:** PASS (green), WARN (yellow), or FAIL (red)
- Host name and timestamp
- Reminder: read-only, no autonomous remediation

### 2. Firewall

Shows `firewalld` state from `firewall-cmd --state` (if readable without sudo).

- **PASS (green):** firewalld is running.
- **FAIL (red):** firewalld is not running or unreachable.

### 3. USBGuard

Shows `usbguard` service status from `systemctl is-active usbguard`.

- **PASS (green):** USBGuard is active.
- **FAIL (red):** USBGuard is inactive or unknown.

### 4. ClamAV / Freshclam

Shows:
- `freshclam` service status
- `clamscan` binary availability
- Latest scan report from `~/offload/security-reports/daily/`
- Infected files count (from report, not a live scan)
- Scanned files count (from report)

**What to do:** If freshclam is inactive, review with `systemctl status clamav-freshclam`.

### 5. Lynis

Shows:
- `lynis` binary availability
- Latest report from `~/offload/security-reports/weekly/`
- Hardening index, warnings count, suggestions count

**What to do:** If no recent report exists, check the timer with `systemctl status bazzite-lynis-audit.timer`.

### 6. Security Timers

Shows read-only status of:
- `bazzite-security-summary.timer` (user)
- `bazzite-clam-scan.timer` (user)
- `bazzite-lynis-audit.timer` (system)

**This panel does not enable, disable, start, or stop timers.**

### 7. Recent Security Reports

Shows counts of files in:
- `~/offload/security-reports/daily/`
- `~/offload/security-reports/weekly/`
- `~/offload/security-reports/audit/`
- `~/offload/security-reports/manual/`

### 8. Gemma Advisory Status

Shows:
- Ollama API health
- Gemma model availability
- Latest security summary report
- Latest main dashboard report

**Gemma is advisory only.** The dashboard does not ask Gemma to perform security actions.

### 9. Guardrails / No-Go Items

A reminder of current safety boundaries:
- No sudo
- No remediation
- No firewall/USBGuard/ClamAV/Lynis changes
- No Agent Zero local Gemma tool-loop
- No secrets

### 10. Next Safe Actions

Dynamic suggestions based on current status:
- If freshclam inactive → suggest review
- If no clam reports → suggest manual scan helper
- If no Lynis reports → suggest timer review
- If all healthy → "All clear. No immediate action required."

---

## Watch Mode Behavior

When `--watch` is used:
1. The script loops in the **foreground**.
2. It regenerates the dashboard every `--interval` seconds (default 60, minimum 15).
3. The HTML includes `<meta http-equiv="refresh" content="INTERVAL">` so the browser auto-refreshes.
4. A banner appears at the top of the HTML: "WATCH MODE — Refreshing every Xs — Press Ctrl+C in terminal to stop"
5. **Press Ctrl+C in the terminal to stop.** The process exits cleanly.
6. No systemd unit, no daemon, no background service is created.

---

## Safety Guarantees

The security dashboard **never**:
- Uses sudo
- Modifies firewall rules
- Modifies USBGuard policy
- Runs ClamAV scans
- Runs Lynis audits
- Starts or stops services
- Exposes API keys, tokens, or credentials
- Enables autonomous execution

It only **reads** existing state and reports.

---

## Optional Install

To make the script available as `gemma-security-dashboard` from anywhere:

```bash
mkdir -p ~/.local/bin
ln -sf /var/home/lch/projects/gem/scripts/gemma-security-dashboard-build ~/.local/bin/gemma-security-dashboard
```

Then run:
```bash
gemma-security-dashboard --help
gemma-security-dashboard --watch --interval 30
gemma-security-dashboard --open
```

**This is optional.** The script works fine from its repo path.

---

## Comparison with Main Dashboard

| Dashboard | Purpose | Script |
|-----------|---------|--------|
| **Main Dashboard** (`gemma-dashboard-build`) | AI stack status (Ollama, Space Agent, Agent Zero, evals) | `gemma-dashboard-build` |
| **Security Dashboard** (`gemma-security-dashboard-build`) | Host security status (firewall, USBGuard, ClamAV, Lynis) | `gemma-security-dashboard-build` |

Run both for a complete picture:
```bash
/var/home/lch/projects/gem/scripts/gemma-dashboard-build
/var/home/lch/projects/gem/scripts/gemma-security-dashboard-build
```

---

## References

- `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- `docs/maintenance/M21_LIVE_SECURITY_DASHBOARD.md`
- `scripts/gemma-security-dashboard-build`

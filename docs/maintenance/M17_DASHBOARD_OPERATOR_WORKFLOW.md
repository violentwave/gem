# M17: Dashboard Usability and Operator Workflow

**Maintenance Phase:** M17 — Dashboard Usability and Operator Workflow
**Date:** 2026-05-02
**Status:** COMPLETE
**Classification:** Documentation + Script Enhancement

---

## Summary

M17 improves the usability of the M16 static dashboard by adding a comprehensive operator guide, improving the build script with `--help`, and documenting the optional install path. The dashboard remains static, manually refreshed, and read-only. No daemon, server, or system changes are introduced.

---

## Changes Made

### 1. Operator Guide Created

**File:** `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`

Contents:
- What the dashboard is and is not
- How to refresh the dashboard (repo path and optional PATH install)
- How to open the dashboard (manually and with `--open`)
- Detailed explanation of all 10 panels
- How Space Agent fits in
- Why Agent Zero is marked no-go for local Gemma tool-loop use
- Troubleshooting section
- Secret/privacy policy
- Canonical output paths
- Optional install snippet

### 2. Dashboard Build Script Improved

**File:** `scripts/gemma-dashboard-build`

Improvements:
- Added `--help` / `-h` flag with comprehensive usage documentation
- Added unknown argument handling with error message
- Preserved `--open` flag for optional browser launch
- Preserved all safety boundaries (read-only, no state changes, secret redaction)
- Preserved all canonical output paths

### 3. Optional Install Documented

Added to the operator guide (not executed automatically):

```bash
mkdir -p ~/.local/bin
ln -sf /var/home/lch/projects/gem/scripts/gemma-dashboard-build ~/.local/bin/gemma-dashboard
```

This is a documented manual step only. No automatic installation is performed.

---

## Validation

| Check | Command | Result |
|-------|---------|--------|
| Syntax check | `bash -n scripts/gemma-dashboard-build` | PASS |
| shellcheck | `shellcheck scripts/gemma-dashboard-build` | PASS (info-level SC2012 only) |
| --help | `scripts/gemma-dashboard-build --help` | PASS |
| --open flag | `scripts/gemma-dashboard-build --open` | PASS (not tested with actual browser in this phase) |
| Dashboard generation | `scripts/gemma-dashboard-build` | PASS |
| HTML output exists | `test -f ~/.local/share/bazzite-security/dashboard/index.html` | PASS |
| Report exists | `ls -lt ~/offload/security-reports/manual/gemma-dashboard-*.md` | PASS |

---

## No-Go Boundaries Preserved

| Boundary | Status | Evidence |
|----------|--------|----------|
| No sudo | PASS | No sudo used |
| No package installs | PASS | No dnf/flatpak/brew |
| No model pulls | PASS | No ollama pull |
| No firewall changes | PASS | No firewalld |
| No Agent Zero config changes | PASS | No config modified |
| No Space Agent config changes | PASS | No config modified |
| No Ollama config changes | PASS | No config modified |
| No secrets exposed | PASS | Redaction applied |
| No daemon created | PASS | One-shot script |
| No LAN exposure | PASS | No server started |
| Read-only inspection | PASS | No state changes |
| No automatic install | PASS | Install is documented optional step only |

---

## Remaining Uncertainty

1. **Browser auto-open behavior:** The `--open` flag uses `xdg-open`, which may behave differently across desktop environments. Testing on Bazzite/KDE specifically was not performed in this phase.
2. **Dashboard refresh frequency:** The operator must remember to run `gemma-dashboard-build`. No reminder mechanism exists.
3. **Space Agent process detection:** Uses `pgrep -f "Space-Agent"`, which could theoretically match other processes. In practice, this is unlikely.
4. **Agent Zero container detection:** Uses `podman ps`, which requires Podman to be installed. Graceful fallback exists.
5. **Optional install adoption:** Whether the operator chooses to install the symlink is unknown. The script works without it.

---

## Sign-Off

- M17 Dashboard Usability: COMPLETE
- Operator guide created: CONFIRMED
- --help flag added: CONFIRMED
- Optional install documented: CONFIRMED
- No system changes: CONFIRMED
- No secrets exposed: CONFIRMED
- Dashboard remains static and manually refreshed: CONFIRMED

---

## References

- `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- `docs/dashboard/LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md`
- `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md`
- `scripts/gemma-dashboard-build`

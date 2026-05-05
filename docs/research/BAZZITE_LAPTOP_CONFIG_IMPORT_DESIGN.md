# bazzite-laptop Config Import Design

**Date:** 2026-05-05
**Status:** Design Document — Implementation Requires Explicit Approval
**Source Repo:** `violentwave/bazzite-laptop`
**Target Repo:** `violentwave/gem` (~/projects/gem)
**Classification:** Read-Only Design / No Import Performed

## 1. Purpose

Design a safe mechanism for importing configuration, prompts, and operational patterns from `bazzite-laptop` into the `gem` (Bazzite Local AI Operations Stack) project.

**Key Constraint:** `gem` is a supervised, advisory-only terminal stack. `bazzite-laptop` is a comprehensive AI control plane with autonomous capabilities. The import must **never** grant autonomy, install services, or enable background execution in `gem`.

## 2. Source Analysis

### 2.1 bazzite-laptop Structure (Actual)

```
bazzite-laptop/
├── ai/                          # 50+ Python modules (agents, alerts, budget, etc.)
├── configs/                     # 30+ config files (systemd, AI, security)
├── docs/                        # 100+ docs (phases, prompts, runbooks)
├── scripts/                     # 60+ scripts (security, health, deploy)
├── systemd/                     # 50+ service/timer files
├── tests/                       # Test suites
├── pyproject.toml               # Python project config
└── README.md
```

### 2.2 Scale

- **1326 files**
- **96 MCP tools**
- **2297+ tests**
- **50+ systemd timers**
- **26 LanceDB tables**
- **6 cloud LLM providers**

## 3. Import Classification

### 3.1 ✅ SAFE — Approved for Import (with review)

These configs are read-only policies, prompts, or references. They contain no secrets, no executable code, and no system-level directives.

| Source File | Target Location | Adaptation Needed | Rationale |
|-------------|----------------|-------------------|-----------|
| `configs/safety-rules.json` | `~/.config/bazzite-security/safety-rules.json` | **Path rewrite** — change `bazzite-laptop` paths to `gem` paths | Read-only safety policy |
| `configs/token-budget.json` | `~/.config/bazzite-security/token-budget.json` | **Display only** — gemma-ui reads but does not enforce | Budget awareness for UI |
| `configs/mitre-attack-map.json` | `~/projects/gem/configs/mitre-attack-map.json` | None | Read-only MITRE reference |
| `docs/bazzite-ai-system-profile.md` | `~/projects/gem/docs/imports/bazzite-ai-system-profile.md` | **Annotate** — add "imported from bazzite-laptop" header | System context reference |
| `docs/morning-briefing-prompt.md` | `~/projects/gem/prompts/bazzite-laptop/` | **Adapt** — convert Newelle/Groq refs to Gemma/Ollama | Prompt patterns |
| `docs/AGENT.md` | `~/projects/gem/docs/imports/bazzite-laptop-AGENT.md` | **Annotate** — mark as imported reference | Agent context patterns |
| `docs/bazzite-ai-system-profile.md` | `~/projects/gem/docs/imports/` | None | Hard constraints reference |
| `configs/device-uuids.conf` | `~/.config/bazzite-security/device-uuids.conf` | None | Hardware identifiers (no secrets) |
| `configs/gamemode.ini` | `~/.config/bazzite-security/gamemode.ini` | None | Gaming optimization settings |

### 3.2 ⚠️ REVIEW REQUIRED — Import with Sanitization

These configs contain paths, provider references, or operational logic that must be adapted before import.

| Source File | Target Location | Sanitization Required | Risk |
|-------------|----------------|----------------------|------|
| `configs/ai-rate-limits.json` | `~/projects/gem/configs/ai-rate-limits-reference.json` | **Strip cloud providers** — keep only local Ollama rates; document rest as reference only | Cloud provider keys not present, but config implies external API usage |
| `configs/security-autopilot-policy.yaml` | `~/projects/gem/docs/imports/security-autopilot-policy.yaml` | **Path rewrite** — change allowed paths; **remove auto-allowed actions** — gem requires human approval for ALL actions | Contains auto-execution semantics |
| `docs/newelle-system-prompt.md` | `~/projects/gem/prompts/adapted/newelle-to-gemma-prompt.md` | **Full rewrite** — deprecated file; extract useful constraints; adapt for Gemma/Ollama | Historical artifact; not runtime-compatible |
| `configs/ruflo-sidecar.json` | `~/projects/gem/configs/ruflo-sidecar-reference.json` | **Review** — verify no secrets; document as reference only | Unknown content |
| `configs/thermal-protection.conf` | `~/.config/bazzite-security/thermal-protection.conf` | **Review thresholds** — verify safe for current hardware | System thermal limits |

### 3.3 ❌ FORBIDDEN — Never Import

These files contain secrets, autonomous execution triggers, system-level changes, or cloud provider configurations that conflict with `gem`'s local-only, supervised model.

| Source File | Reason |
|-------------|--------|
| `configs/keys.env.enc` | Encrypted secrets — never decrypt or import |
| `configs/litellm-config.yaml` | Cloud provider API keys and endpoints |
| `configs/r2-config.yaml` | Cloudflare R2 storage credentials |
| `configs/msmtprc.template` | Email credentials template |
| `configs/mcp-bridge-allowlist.yaml` | 72KB tool allowlist — references `bazzite-laptop` paths and tools that don't exist in `gem` |
| `systemd/*` | All systemd service/timer files — would install background services |
| `scripts/deploy-services.sh` | Installs systemd timers — autonomous execution |
| `scripts/install-user-timers.sh` | Installs systemd timers — autonomous execution |
| `scripts/clamav-*.sh` | Security scans — handled separately in `gem` |
| `scripts/ingest-*.sh` | Automated data ingestion — requires human approval in `gem` |
| `scripts/backup.sh` | Backup script — may overwrite `gem` state |
| `scripts/setup-ai-env.sh` | Environment setup — may install packages |
| `ai/` modules | Python modules — `gem` uses bash/Python stdlib helpers, not full Python app |
| `pyproject.toml` | Python dependencies — `gem` uses stdlib + Rich only |
| `requirements*.txt` | Python dependencies — do not install |
| `.sops.yaml` | Secrets encryption config |
| `.secrets.baseline` | Secrets scanning baseline |

## 4. Import Mechanism

### 4.1 Workflow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Identify  │───▶│   Dry-Run   │───▶│   Review    │───▶│   Apply     │
│   Source    │    │   Diff      │    │   & Approve │    │   Import    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                  │                  │                  │
       ▼                  ▼                  ▼                  ▼
  Scan bazzite-      Generate diff     Human reviews      Copy + adapt
  laptop configs     with adaptations  each file          + commit
```

### 4.2 Steps

#### Step 1: Identify
- Scan `bazzite-laptop/configs/` and `bazzite-laptop/docs/` for candidate files
- Classify each file as SAFE, REVIEW, or FORBIDDEN
- Generate candidate list

#### Step 2: Dry-Run
- For SAFE files: generate adapted content (path rewrites, header annotations)
- For REVIEW files: generate adapted content with highlight markers for human attention
- For FORBIDDEN files: log exclusion reason
- Produce `IMPORT_DIFF.md` showing before/after for each file

#### Step 3: Review
- Human reviews `IMPORT_DIFF.md`
- Human approves/rejects each file
- Human approves/rejects each adaptation
- No automatic import occurs without explicit approval

#### Step 4: Apply
- Copy approved files to target locations
- Apply adaptations (path rewrites, header annotations)
- Run `py_compile` or `bash -n` validation
- Run `gemma-evals-check` to ensure no regression
- Git commit with clear message

### 4.3 Adaptation Rules

#### Path Rewrite
```json
// Before (bazzite-laptop)
"path_allowed_roots": [
  "/var/home/lch/projects/bazzite-laptop",
  "/home/lch/security"
]

// After (gem)
"path_allowed_roots": [
  "/var/home/lch/projects/gem",
  "/home/lch/offload/security-reports"
]
```

#### Header Annotation
```markdown
<!-- IMPORTED FROM: violentwave/bazzite-laptop -->
<!-- ADAPTED FOR: gem (Bazzite Local AI Operations Stack) -->
<!-- DATE: 2026-05-05 -->
<!-- CHANGES: Paths rewritten; cloud provider refs removed -->
<!-- STATUS: Reference only — not executed automatically -->
```

#### Auto-Execution Strip
```yaml
# Before (bazzite-laptop)
auto_allowed:
  - health_check
  - log_ingest

# After (gem)
# NOTE: auto_allowed removed — gem requires human approval for ALL actions
# approval_required:
#   - health_check
#   - log_ingest
```

### 4.4 Safety Gates

| Gate | Check | Failure Action |
|------|-------|---------------|
| Secrets scan | `detect-secrets scan` on imported content | REJECT file if secrets found |
| Path validation | Verify all paths exist and are within `~/` | REJECT if paths outside home |
| Executable check | No `#!/usr/bin/env` or shebang in imported configs | REJECT if executable code detected |
| Systemd check | No `[Unit]` or `[Service]` blocks | REJECT if systemd config detected |
| Cloud provider check | No API keys, endpoints, or provider names | FLAG for review if found |
| Auto-execution check | No `auto_allowed`, `timer`, `cron`, or `daemon` | FLAG for review if found |

## 5. Target Mapping

### 5.1 Config Files → ~/.config/bazzite-security/

```
~/.config/bazzite-security/
├── gemma-ui.json                    # Existing
├── safety-rules.json                # NEW: imported from bazzite-laptop/configs/
├── token-budget.json                # NEW: imported from bazzite-laptop/configs/
├── thermal-protection.conf          # NEW: imported from bazzite-laptop/configs/
├── gamemode.ini                     # NEW: imported from bazzite-laptop/configs/
└── device-uuids.conf                # NEW: imported from bazzite-laptop/configs/
```

### 5.2 Reference Docs → ~/projects/gem/docs/imports/

```
~/projects/gem/docs/imports/
├── bazzite-ai-system-profile.md
├── bazzite-laptop-AGENT.md
├── security-autopilot-policy.yaml
├── ai-rate-limits-reference.json
├── mitre-attack-map.json
└── IMPORT_MANIFEST.md               # Tracks what was imported and when
```

### 5.3 Prompts → ~/projects/gem/prompts/bazzite-laptop/

```
~/projects/gem/prompts/bazzite-laptop/
├── morning-briefing-prompt.md
└── newelle-to-gemma-prompt.md
```

## 6. gemma-ui Integration

### 6.1 Display-Only Configs

Configs imported from `bazzite-laptop` are **display-only** in `gem`:

- `token-budget.json` → shown in `gemma-ui --dashboard` as "reference budget"
- `safety-rules.json` → shown in `gemma-ui --dashboard` as "imported safety rules"
- `thermal-protection.conf` → shown in `gemma-ui --health` as "thermal thresholds"

### 6.2 No Enforcement

`gem` does **not** enforce:
- Token budgets (display only)
- Auto-execution policies (all actions require human approval)
- Systemd timers (no background services)
- Automated ingestion (human approval required)

## 7. Rollback Plan

### 7.1 Pre-Import Backup

Before any import:
```bash
cp -r ~/.config/bazzite-security ~/.config/bazzite-security.backup-pre-import-$(date +%Y%m%d-%H%M%S)
```

### 7.2 Rollback Script

```bash
#!/usr/bin/env bash
# ~/.local/bin/gemma-import-rollback
# Rollback last bazzite-laptop config import

BACKUP_DIR=$(ls -td ~/.config/bazzite-security.backup-pre-import-* | head -1)
if [[ -d "$BACKUP_DIR" ]]; then
    rm -rf ~/.config/bazzite-security
    cp -r "$BACKUP_DIR" ~/.config/bazzite-security
    echo "Rollback complete: restored from $BACKUP_DIR"
else
    echo "No backup found"
    exit 1
fi
```

## 8. Implementation Checklist

### 8.1 Before First Import

- [ ] Create `~/projects/gem/docs/imports/` directory
- [ ] Create `~/projects/gem/prompts/bazzite-laptop/` directory
- [ ] Create `gemma-import-rollback` helper
- [ ] Verify `detect-secrets` is available (or use `grep` heuristic)
- [ ] Document import manifest format

### 8.2 Per-Import Run

- [ ] Scan source files
- [ ] Classify each file (SAFE/REVIEW/FORBIDDEN)
- [ ] Generate adapted content
- [ ] Run secrets scan
- [ ] Generate IMPORT_DIFF.md
- [ ] Human review and approval
- [ ] Backup existing configs
- [ ] Copy approved files
- [ ] Run syntax validation
- [ ] Run gemma-evals-check
- [ ] Git commit
- [ ] Update IMPORT_MANIFEST.md

## 9. Example Import Run

### 9.1 Candidate: safety-rules.json

**Classification:** SAFE (with adaptation)

**Dry-Run Diff:**
```diff
--- bazzite-laptop/configs/safety-rules.json
+++ gem/configs/safety-rules.json
@@ -4,8 +4,8 @@
     "rm -rf",
     "mkfs",
     "dd if=",
     "chmod 777"
   ],
   "path_allowed_roots": [
-    "/var/home/lch/projects/bazzite-laptop",
-    "/home/lch/security"
+    "/var/home/lch/projects/gem",
+    "/home/lch/offload/security-reports"
   ],
   "high_risk_tools": [
     "security.sandbox_submit",
```

**Human Approval:** ✅ Approved

**Applied:** `~/.config/bazzite-security/safety-rules.json`

### 9.2 Candidate: deploy-services.sh

**Classification:** FORBIDDEN

**Reason:** Installs systemd timers, enables autonomous background execution.

**Human Approval:** ❌ Rejected (correctly classified)

## 10. Signoff

- **Design author:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **Status:** Design complete — implementation requires explicit human approval
- **No import performed in this phase**
- **No files modified in this phase**
- **Next step:** Human approves this design, then authorizes first import run

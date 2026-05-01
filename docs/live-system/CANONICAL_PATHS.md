# Canonical Paths Reference

## Live System Paths (Source of Truth)

These paths contain the live system state and remain the source of truth. This coordination repo (`~/projects/gem`) does not replace them.

### Config: `~/.config/bazzite-security/`

**Purpose:** Configuration documents, policies, runbooks

**Contents:**
- `PATHS.md` - Path policy documentation
- `FINAL_POLICY.md` - Security policy
- `RUNBOOK.md` - Operational runbook
- `OPERATIONS.md` - Operations log and notes
- `GEMMA_LOCAL_AGENT.md` - Gemma helper documentation
- `OPENCODE_GEMMA_NOTES.md` - OpenCode integration notes
- `ollama/Modelfile.gemma4-e4b-bazzite` - Custom Gemma profile

**What This Repo May Mirror:**
- Documentation structure
- High-level policy summaries

**What This Repo Must Not Copy:**
- Raw config file contents (reference by path only)
- Secrets or credentials
- `.env` files

### Scripts: `~/.local/bin/`

**Purpose:** User-local executable helper scripts

**Contents:**
- `gemma-*` - Gemma wrapper scripts (~20 scripts)
- `bazzite-*` - Bazzite security scripts

**What This Repo May Mirror:**
- Script inventory (names, purposes)
- Usage examples

**What This Repo Must Not Copy:**
- Script source code (reference by path only)
- Generated script outputs

### Persistent State: `~/.local/share/bazzite-security/`

**Purpose:** Persistent data, evals, knowledge packs

**Contents:**
- `gemma-knowledge/docs/` - Copied approved docs
- `gemma-knowledge/index/` - JSONL chunk index
- `gemma-knowledge/manifests/` - Knowledge manifests
- `gemma-evals/cases/` - Stage 4A eval cases
- `gemma-evals/examples/` - Stage 4B supervised examples
- `gemma-evals/manifests/` - Eval manifests

**What This Repo May Mirror:**
- Inventory of eval/example types
- Counts and status summaries
- Manifest metadata (sanitized)

**What This Repo Must Not Copy:**
- Raw JSONL eval/example data
- Large manifest files
- Chunks or indices

### Logs: `~/.local/state/bazzite-security/logs/`

**Purpose:** Runtime logs

**Contents:**
- `gemma-*-*.log` - Helper script logs
- Validation logs
- Status check logs

**What This Repo May Mirror:**
- Log directory structure
- Recent validation results (summarized)

**What This Repo Must Not Copy:**
- Raw log files
- Unredacted transcripts
- Session data

### Cache: `~/.cache/bazzite-security/`

**Purpose:** Runtime cache

**Contents:**
- Temporary model outputs
- Section caches
- Session data

**What This Repo May Mirror:**
- Nothing (cache is ephemeral)

**What This Repo Must Not Copy:**
- Any cache contents
- Temporary files

### Reports: `~/offload/security-reports/`

**Purpose:** Generated security reports

**Contents:**
- `daily/` - Daily summaries
- `weekly/` - Weekly reports
- `audit/` - Audit reports
- `manual/` - Manual analysis reports

**What This Repo May Mirror:**
- Report inventory (counts, types)
- Summary metadata

**What This Repo Must Not Copy:**
- Full report contents
- Large generated files
- Sensitive scan results

## Coordination Repo Paths (`~/projects/gem`)

### Documentation: `docs/`

**Purpose:** Architecture, planning, integration docs

**Safe Contents:**
- Markdown documentation
- Planning documents
- Integration specifications
- Roadmaps

**Excluded:**
- No secrets
- No raw logs
- No large binary files

### Prompts: `prompts/`

**Purpose:** OpenCode/Codex prompts for future phases

**Safe Contents:**
- `.txt` prompt files
- `.md` prompt documentation

### Scripts: `scripts/`

**Purpose:** Repo-local scripts

**Safe Contents:**
- Inventory scripts
- Utility scripts
- No sudo requirements

### Inventory: `inventory/`

**Purpose:** Sanitized system inventory

**Safe Contents:**
- Path lists
- Script inventories
- Tool availability checks
- Config doc lists

**Excluded:**
- `inventory/raw/` - Ignored, for local use only
- No secrets
- No raw logs

## Path Mapping Summary

| Live Path | Repo Mirror | Notes |
|-----------|-------------|-------|
| `~/.config/bazzite-security/*.md` | `inventory/config-docs/` (list only) | Reference by path |
| `~/.local/bin/gemma-*` | `inventory/helper-scripts/` (list only) | Reference by path |
| `~/.local/share/bazzite-security/` | `inventory/live-paths/` (structure only) | Reference by path |
| `~/offload/security-reports/` | `inventory/live-paths/` (structure only) | Reference by path |
| Live runtime state | Not mirrored | Stay in canonical paths |

## Safety Rules

1. **Config docs:** Reference by path, don't copy content
2. **Helper scripts:** Reference by path, don't copy source
3. **Eval/examples:** Reference counts/status, don't copy JSONL
4. **Logs:** Reference existence, don't copy contents
5. **Reports:** Reference inventory, don't copy full reports
6. **Cache:** Never mirror, ephemeral by design

## Validation

Check this understanding:
```bash
# Live paths exist
ls -la ~/.config/bazzite-security/ | head -10
ls -la ~/.local/bin/gemma-* | wc -l

# Repo paths exist
ls -la ~/projects/gem/inventory/

# No raw content copied
grep -r "api.key" ~/projects/gem/ 2>/dev/null || echo "No secrets found"
```

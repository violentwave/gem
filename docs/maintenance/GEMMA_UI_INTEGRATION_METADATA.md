# Gemma UI Integration Metadata

**Status:** Display-Only — No Enforcement  
**Created:** 2026-05-05  
**Config:** `~/.config/bazzite-security/gemma-ui-integrations.json`

---

## What This Is

Integration metadata is a **display-only** status layer inside `gemma-ui` that tracks the state of potential future integrations — primarily `bazzite-laptop` config import — without enabling any of those integrations.

**Key properties:**
- **Display-only:** No enforcement, no execution, no routing.
- **No secrets:** The config file contains no API keys, tokens, or credentials.
- **No autonomy:** Nothing in this file enables automatic actions.
- **No MCP routing:** MCP bridge remains disabled.
- **No systemd:** No services, timers, or background tasks.

---

## Design Principles

1. **Integration metadata is display-only.**
   - `gemma-ui` reads the file and shows status.
   - It does not act on the file contents.
   - It does not enforce policies from imported configs.

2. **bazzite-laptop remains legacy/reference only.**
   - The `bazzite-laptop` repo is a comprehensive AI control plane.
   - `gem` is a supervised, advisory-only terminal stack.
   - No revival of the old control plane occurs.

3. **No config import has been performed by this phase.**
   - The import design exists (`docs/research/BAZZITE_LAPTOP_CONFIG_IMPORT_DESIGN.md`).
   - No actual files have been imported.
   - All display files show as "missing" until human-approved import occurs.

4. **MCP routing remains disabled.**
   - `mcp_routing_enabled: false` in the config.
   - No tool registration, no bridge startup, no routing.

5. **Imported configs, when approved later, are not enforcement sources.**
   - Token budgets are display-only.
   - Safety rules are reference-only.
   - Rate limits are reference-only.
   - All actions still require human approval.

6. **No forbidden items are imported.**
   - Secrets (`keys.env.enc`, `.env`)
   - Systemd units
   - Deployment scripts (`deploy-services.sh`)
   - Cloud provider credentials
   - Autonomous execution policies

---

## Config File

`~/.config/bazzite-security/gemma-ui-integrations.json`:

```json
{
  "version": "0.1.0",
  "status": "design_only",
  "bazzite_laptop": {
    "enabled": false,
    "role": "legacy_reference_only",
    "config_import_status": "not_imported",
    "display_only": true,
    "mcp_routing_enabled": false,
    "allowed_display_files": {
      "safety_rules": "~/.config/bazzite-security/safety-rules.json",
      "token_budget": "~/.config/bazzite-security/token-budget.json",
      "rate_limits": "~/projects/gem/configs/ai-rate-limits-reference.json"
    },
    "forbidden": [
      "secrets",
      "keys.env.enc",
      ".env",
      "systemd",
      "deploy scripts",
      "cloud provider credentials",
      "autonomous execution"
    ]
  }
}
```

## CLI Usage

```bash
# Show integration metadata
gemma-ui --integration-status

# Show in dashboard
gemma-ui --dashboard

# Interactive command
gemma-ui
> /integration
> /integration status
```

## Dashboard Display

The dashboard shows an "Integration Metadata" section with:

| Field | Example Value |
|-------|--------------|
| bazzite-laptop role | legacy_reference_only |
| Config import status | not_imported |
| Display-only | yes |
| MCP routing | disabled |
| safety_rules file | missing |
| token_budget file | missing |
| rate_limits file | missing |

## Safety Boundaries

| Boundary | Status |
|----------|--------|
| No secrets in config | ✅ Confirmed |
| No executable code | ✅ Confirmed |
| No systemd references | ✅ Confirmed |
| No auto-execution | ✅ Confirmed |
| MCP routing disabled | ✅ Confirmed |
| Display-only behavior | ✅ Confirmed |

## Future Work

If human approves a config import later:

1. Run the import workflow from `BAZZITE_LAPTOP_CONFIG_IMPORT_DESIGN.md`.
2. Update `gemma-ui-integrations.json`:
   - Set `config_import_status` to `imported`.
   - Set `enabled` to `true`.
3. Re-run `gemma-ui --integration-status` to verify file presence.
4. All imported configs remain display-only — no enforcement.

---

## Signoff

- **Design:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **No import performed:** Confirmed
- **No secrets:** Confirmed
- **No authority granted:** Confirmed

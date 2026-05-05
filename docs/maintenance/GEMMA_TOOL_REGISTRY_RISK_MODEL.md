# Gemma Tool Registry Risk Model

**Date:** 2026-05-05
**Status:** Documentation and Display Layer — No Execution Authority
**Purpose:** Normalize and document all tools/helpers in the Bazzite Local AI Operations Stack before adding more.

---

## 1. Purpose

The tool registry risk model is a **documentation and display layer**. It does not grant execution authority. Security tools still require explicit confirmation. Sudo/manual-review tools require typed confirmation. Legacy-derived tools are not a revival of the bazzite-laptop control plane.

**Key properties:**
- **Documentation-first:** Every tool is inventoried, classified, and documented.
- **Risk-normalized:** Each tool has a clear risk level and confirmation rule.
- **Source-tracked:** Every tool is tagged with its origin (native, legacy-derived, etc.).
- **No execution authority:** The registry does not enable tools; it describes them.
- **MCP routing remains disabled:** No tool registration via MCP bridge.
- **Forbidden tools must not be registered.**

---

## 2. Risk Levels

| Level | Code | Description | Confirmation Rule |
|-------|------|-------------|-------------------|
| SAFE_READ_ONLY | safe | Read-only queries, no system changes | Run only when explicitly invoked |
| CONFIRM_REQUIRED | confirm | May read sensitive data or run moderate commands | Require y/N confirmation |
| SUDO_MANUAL_REVIEW | sudo | Requires root privileges or significant system access | Require typed tool-name confirmation |
| DESIGN_ONLY | design | Documentation/planning only, no runtime behavior | Not executable |
| DISABLED | disabled | Intentionally disabled or not yet implemented | Must not execute |
| FORBIDDEN | forbidden | Violates safety boundaries | Must not be registered |

---

## 3. Tool Source Classifications

| Source | Description |
|--------|-------------|
| native_gem | Built specifically for the gem project |
| legacy_derived | Derived from bazzite-laptop but scoped to local supervised use |
| bazzite_laptop_reference | Direct reference to bazzite-laptop patterns (not imported) |
| ruvector_supervised | RuVector memory/retrieval tools (supervised secondary) |
| stage3a_canonical | Stage 3A deterministic retrieval tools (canonical fallback) |
| external_manual_ui | External tools used manually (Space Agent, etc.) |

---

## 4. Required Metadata Fields (Future Tools)

Every tool registered in the future must include:

```json
{
  "name": "tool_name",
  "category": "Security|Memory|Repo|Voice|Diagnostics|Integration|General",
  "source": "native_gem|legacy_derived|...",
  "risk": "safe|confirm|sudo|design|disabled|forbidden",
  "needs_confirmation": true|false,
  "needs_sudo": true|false,
  "executes_commands": true|false,
  "mutates_state": true|false,
  "allowed_paths": ["/home/lch/projects/gem", ...],
  "denied_paths": ["/usr", "/boot", "/ostree", ...],
  "output_paths": ["~/offload/security-reports/", ...],
  "confirmation_prompt": "This tool requires sudo. Type 'tool_name' to confirm:",
  "notes": "Any special considerations"
}
```

---

## 5. Current Tool Inventory

### 5.1 gemma-ui Helpers (Router Layer)

These are the helpers gemma-ui routes to. They are not tools themselves but entry points.

| Name | Category | Source | Risk | Confirmation | Notes |
|------|----------|--------|------|--------------|-------|
| gemma-bazzite | General | native_gem | SAFE_READ_ONLY | No | General chat with local Gemma via Ollama |
| gemma-security-chat | Security | native_gem | CONFIRM_REQUIRED | Yes | Interactive security console; tools inside require confirmation |
| gemma-security-analyzer | Security | native_gem | CONFIRM_REQUIRED | Yes | Security tool analysis wrapper |
| gemma-memory-search | Memory | ruvector_supervised | SAFE_READ_ONLY | No | RuVector semantic search (supervised secondary) |
| gemma-memory-rag | Memory | ruvector_supervised | SAFE_READ_ONLY | No | RuVector RAG with Ollama generation |
| gemma-knowledge-search | Memory | stage3a_canonical | SAFE_READ_ONLY | No | Stage 3A deterministic keyword search |
| gemma-knowledge-rag | Memory | stage3a_canonical | SAFE_READ_ONLY | No | Stage 3A RAG with Ollama generation |
| gemma-command-review | Security | native_gem | SAFE_READ_ONLY | No | Advisory command safety review (display only) |
| gemma-repo-brief | Repo | native_gem | SAFE_READ_ONLY | No | Bounded advisory repo summary |
| gemma-file-brief | Repo | native_gem | SAFE_READ_ONLY | No | Advisory local file summary |
| gemma-bazzite-health | Diagnostics | native_gem | SAFE_READ_ONLY | No | Gemma model health check |
| gemma-dashboard-build | Diagnostics | native_gem | SAFE_READ_ONLY | No | Build security dashboard HTML |
| gemma-monitor-daily | Diagnostics | native_gem | SAFE_READ_ONLY | No | Daily system health monitor |
| gemma-monitor-drift | Diagnostics | native_gem | SAFE_READ_ONLY | No | Drift detection monitor |
| gemma-voice-chat | Voice | native_gem | SAFE_READ_ONLY | No | Push-to-talk voice interface |

### 5.2 gemma-security-chat Tools (Execution Layer)

These are the actual tools that gemma-security-chat can execute with confirmation gates.

| Name | Category | Source | Risk | Needs Sudo | Confirmation | Notes |
|------|----------|--------|------|------------|--------------|-------|
| security_summary | Security | native_gem | SAFE_READ_ONLY | No | None | Quick security status summary (read-only checks) |
| security_test | Security | native_gem | SAFE_READ_ONLY | No | None | Basic security validation checks (read-only) |
| system_info | System | native_gem | SAFE_READ_ONLY | No | None | Show system info, uptime, memory, disk |
| process_check | System | native_gem | SAFE_READ_ONLY | No | None | List running processes and connections |
| usb_devices | Hardware | native_gem | SAFE_READ_ONLY | No | None | List USB devices and USBGuard policy |
| health_snapshot | System | legacy_derived | SAFE_READ_ONLY | No | None | Disk, memory, thermals, GPU, services |
| security_briefing | Security | legacy_derived | SAFE_READ_ONLY | No | None | Security briefing with timers, services, events |
| threat_lookup | Security | legacy_derived | SAFE_READ_ONLY | No | None | Check threat indicators and suspicious activity |
| firewall_status | Network | native_gem | SAFE_READ_ONLY | No | None | Check firewalld/iptables rules |
| audit_log | Security | native_gem | SUDO_MANUAL_REVIEW | Yes | Typed name | Check today's audit logs (needs sudo) |
| clamav_scan | Security | native_gem | SUDO_MANUAL_REVIEW | Yes | Typed name | Scan /tmp with ClamAV (needs sudo) |
| rootkit_scan | Security | native_gem | SUDO_MANUAL_REVIEW | Yes | Typed name | Run rkhunter rootkit detection (needs sudo) |
| network_scan | Network | native_gem | SUDO_MANUAL_REVIEW | Yes | Typed name | Capture packets with tcpdump (needs sudo) |
| service_canary | Services | legacy_derived | DESIGN_ONLY | No | N/A | ⚠️ References MCP bridge/LLM proxy (legacy concepts). Not executable in gem context. |
| thermal_check | Hardware | legacy_derived | DESIGN_ONLY | No | N/A | ⚠️ References `/usr/local/bin/thermal-protection.py` (legacy path). Not guaranteed to exist. |

### 5.3 gemma-ui Built-in Commands (No External Tools)

| Command | Category | Source | Risk | Notes |
|---------|----------|--------|------|-------|
| /general | General | native_gem | SAFE_READ_ONLY | Routes to gemma-bazzite |
| /security | Security | native_gem | CONFIRM_REQUIRED | Routes to gemma-security-chat |
| /memory | Memory | native_gem | SAFE_READ_ONLY | Routes to memory helpers |
| /repo | Repo | native_gem | SAFE_READ_ONLY | Routes to repo helpers |
| /voice | Voice | native_gem | SAFE_READ_ONLY | Routes to voice helper |
| /reports | Reports | native_gem | SAFE_READ_ONLY | Browse recent reports |
| /health | Health | native_gem | SAFE_READ_ONLY | Safe health checks |
| /dashboard | Diagnostics | native_gem | SAFE_READ_ONLY | Read-only status dashboard |
| /integration | Integration | native_gem | DESIGN_ONLY | Display integration metadata |
| /help | General | native_gem | SAFE_READ_ONLY | Show help |
| /mode | General | native_gem | SAFE_READ_ONLY | Show mode selector |
| /clear | General | native_gem | SAFE_READ_ONLY | Clear screen |
| /save | General | native_gem | SAFE_READ_ONLY | Save session state |
| /quit | General | native_gem | SAFE_READ_ONLY | Exit |

### 5.4 gemma-ui Memory Subcommands

| Command | Category | Source | Risk | Notes |
|---------|----------|--------|------|-------|
| /memory search | Memory | ruvector_supervised | SAFE_READ_ONLY | RuVector semantic search |
| /memory ask | Memory | ruvector_supervised | SAFE_READ_ONLY | RuVector RAG |
| /memory stage3a | Memory | stage3a_canonical | SAFE_READ_ONLY | Stage 3A deterministic fallback |
| /memory compare | Memory | both | SAFE_READ_ONLY | Run both and compare |
| /memory status | Memory | native_gem | SAFE_READ_ONLY | Show memory mode status |
| /memory dashboard | Memory | native_gem | SAFE_READ_ONLY | Show memory quality dashboard |

### 5.5 gemma-ui Voice Subcommands

| Command | Category | Source | Risk | Notes |
|---------|----------|--------|------|-------|
| /voice status | Voice | native_gem | SAFE_READ_ONLY | Show voice component status |
| /voice start | Voice | native_gem | SAFE_READ_ONLY | Start voice session (push-to-talk) |
| /voice test-output | Voice | native_gem | SAFE_READ_ONLY | Test TTS output |
| /voice help | Voice | native_gem | SAFE_READ_ONLY | Show voice help |
| /voice stop | Voice | native_gem | SAFE_READ_ONLY | Stop voice session |

### 5.6 gemma-ui Integration Subcommands

| Command | Category | Source | Risk | Notes |
|---------|----------|--------|------|-------|
| /integration | Integration | native_gem | DESIGN_ONLY | Show integration metadata |
| /integration status | Integration | native_gem | DESIGN_ONLY | Show integration status |

---

## 6. Legacy-Derived Tool Notes

### service_canary
- **Status:** DESIGN_ONLY in gem context
- **Reason:** References MCP bridge (`http://127.0.0.1:8766`) and LLM proxy (`http://127.0.0.1:8767`) — these are bazzite-laptop concepts, not part of gem
- **Action:** Not executable. Display as legacy reference only.
- **Future:** If needed, rewrite as native gem service check (firewalld, usbguard, auditd, ollama)

### thermal_check
- **Status:** DESIGN_ONLY in gem context
- **Reason:** References `/usr/local/bin/thermal-protection.py` which is a bazzite-laptop path, not guaranteed in gem
- **Action:** Not executable. Display as legacy reference only.
- **Future:** If needed, rewrite using `sensors` or `/sys/class/thermal/` directly

### health_snapshot, security_briefing, threat_lookup
- **Status:** SAFE_READ_ONLY
- **Reason:** These were derived from bazzite-laptop scripts but have been adapted to use only standard system commands available on any Bazzite host
- **Action:** Keep as legacy_derived but functional. No autonomous execution.

---

## 7. Recommended Actions per Tool

| Tool | Action | Rationale |
|------|--------|-----------|
| security_summary | **Keep** | Read-only, useful quick check |
| security_test | **Keep** | Read-only validation |
| system_info | **Keep** | Standard read-only info |
| process_check | **Keep** | Read-only process listing |
| usb_devices | **Keep** | Read-only USB listing |
| health_snapshot | **Keep** | Legacy-derived but safe |
| security_briefing | **Keep** | Legacy-derived but safe |
| threat_lookup | **Keep** | Legacy-derived but safe |
| firewall_status | **Keep** | Read-only firewall check |
| audit_log | **Keep** | Requires sudo + typed confirmation |
| clamav_scan | **Keep** | Requires sudo + typed confirmation |
| rootkit_scan | **Keep** | Requires sudo + typed confirmation |
| network_scan | **Keep** | Requires sudo + typed confirmation |
| service_canary | **Block / Redesign** | References legacy MCP/LLM proxy |
| thermal_check | **Block / Redesign** | References legacy path |

---

## 8. Safety Boundaries

| Boundary | Status |
|----------|--------|
| No tool executes without explicit invocation | ✅ Confirmed |
| CONFIRM_REQUIRED tools have y/N gate | ✅ Confirmed |
| SUDO_MANUAL_REVIEW tools have typed-name gate | ✅ Confirmed |
| No autonomous tool execution | ✅ Confirmed |
| No MCP routing | ✅ Confirmed |
| Legacy-derived tools labeled appropriately | ✅ Confirmed |
| Forbidden tools not registered | ✅ Confirmed |
| Tool registry is documentation-only | ✅ Confirmed |

---

## 9. Future Work

### 9.1 Machine-Readable Registry
A JSON registry file can be created for display purposes only:
`~/.config/bazzite-security/gemma-tool-registry.json`

Properties:
- `display_only: true` — never used for execution decisions
- Tracks tool metadata for dashboard display
- Updated manually when tools change
- Not a source of truth for execution

### 9.2 Tool Audit Checklist
When adding a new tool:
- [ ] Classify risk level
- [ ] Tag source classification
- [ ] Define confirmation rule
- [ ] Document allowed/denied paths
- [ ] Check for legacy references
- [ ] Verify no secrets in tool definition
- [ ] Update this document
- [ ] Update machine-readable registry

---

## 10. Signoff

- **Document author:** OpenCode / Sisyphus
- **Date:** 2026-05-05
- **Status:** Complete — documentation and display layer only
- **No tool behavior changed:** Confirmed
- **No execution authority granted:** Confirmed
- **MCP routing remains disabled:** Confirmed
- **Legacy-derived tools labeled:** Confirmed

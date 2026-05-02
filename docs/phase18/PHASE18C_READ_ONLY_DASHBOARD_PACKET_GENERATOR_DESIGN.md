# Phase 18C: Read-Only Dashboard Packet Generator Design

**Phase:** 18C — Read-Only Dashboard Packet Generator Design
**Date:** 2026-05-02
**Parent:** Phase 18 (Space Agent Operator Dashboard Integration)
**Status:** COMPLETE

---

## Purpose

Design the packet generator that produces dashboard-compatible Markdown/JSON packets from script outputs.

---

## Generator Architecture

```
[Script Output] → [Packet Generator] → [JSON Packet] → [Markdown Renderer] → [Markdown Report]
                     ↓
              [Validation]
                     ↓
              [Storage]
```

### Components

| Component | Purpose | Language |
|-----------|---------|----------|
| `gemma-dashboard-packet` | Main generator | Bash |
| `gemma-dashboard-lib.sh` | Shared functions | Bash |
| JSON renderer | Convert to JSON | Python (stdlib) |
| Markdown renderer | Convert to Markdown | Python (stdlib) |

---

## Packet Generator Design

### Input: Script Output

```bash
# Example: gemma-monitor-daily output
[2026-05-02 08:00:00] Daily Health Monitor

[Infrastructure]
✅ Ollama: v0.22.0 running
✅ Gemma: gemma4-e4b-bazzite available

[Summary]
Pass: 6 | Warn: 1 | Fail: 0
Duration: 8.2s
```

### Processing Steps

1. **Parse** script output into structured data
2. **Validate** against JSON schema
3. **Transform** into JSON packet
4. **Render** into Markdown report
5. **Store** in canonical paths
6. **Return** report path

### Pseudocode

```bash
#!/bin/bash
# gemma-dashboard-packet — conceptual only, not created

PACKET_TYPE="$1"
GENERATOR="$2"
OUTPUT_DIR="~/offload/security-reports/manual"
PACKET_DIR="~/.local/share/bazzite-security/dashboard-packets"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# 1. Run generator and capture output
OUTPUT=$("$GENERATOR" 2>&1)
EXIT_CODE=$?

# 2. Parse output into JSON
cat > "${PACKET_DIR}/${PACKET_TYPE}-${TIMESTAMP}.json" << EOF
{
  "packet_version": "1.0",
  "packet_type": "$PACKET_TYPE",
  "generated_at": "$(date -Iseconds)",
  "generator": "$GENERATOR",
  "title": "$(echo "$OUTPUT" | grep '^=' | sed 's/=//g' | xargs)",
  "summary": {
    "pass": $(echo "$OUTPUT" | grep -o 'Pass: [0-9]*' | awk '{print $2}'),
    "warn": $(echo "$OUTPUT" | grep -o 'Warn: [0-9]*' | awk '{print $2}'),
    "fail": $(echo "$OUTPUT" | grep -o 'Fail: [0-9]*' | awk '{print $2}')
  }
}
EOF

# 3. Render Markdown
python3 << PYEOF
import json
with open("${PACKET_DIR}/${PACKET_TYPE}-${TIMESTAMP}.json") as f:
    data = json.load(f)

md = f"# {data['title']}\\n\\n"
md += f"**Date:** {data['generated_at']}\\n"
md += f"**Generator:** {data['generator']}\\n\\n"
md += f"## Summary\\n\\n"
md += f"Pass: {data['summary']['pass']} | Warn: {data['summary']['warn']} | Fail: {data['summary']['fail']}\\n"

with open("${OUTPUT_DIR}/${PACKET_TYPE}-${TIMESTAMP}.md", 'w') as f:
    f.write(md)
PYEOF

echo "Report: ${OUTPUT_DIR}/${PACKET_TYPE}-${TIMESTAMP}.md"
```

---

## Safety Boundaries

| Boundary | Enforcement |
|----------|-------------|
| Read-only | Generator never modifies system state |
| No secrets | Scrub any tokens/keys from output |
| Bounded | Max 30s per script |
| Canonical paths | Only write to approved directories |
| No sudo | Generator runs as user |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Architecture designed | PASS | 4 components |
| Processing steps | PASS | 6 steps |
| Pseudocode | PASS | Bash + Python |
| Safety boundaries | PASS | 5 boundaries |
| No implementation | PASS | Design-only |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 18C: COMPLETE
- Generator architecture: DESIGNED
- Processing pipeline: 6 steps
- Next: Phase 18D (Space Agent Manual Dashboard Workflow)

# M10 — Space Agent RuVector Dashboard Packet Integration

**Phase:** M10 — Space Agent RuVector Dashboard Packet Integration  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Design phase (no code changes, no autonomous execution)

---

## Purpose

Design how Space Agent consumes read-only dashboard packets containing RuVector, Stage 3A, and Gemma system status data. This phase is design-only — no Space Agent config is modified, no autonomous packets are generated.

---

## Current Space Agent Status

| Property | Value |
|----------|-------|
| **Version** | v0.66.0 |
| **Location** | `~/Applications/Space-Agent.AppImage` |
| **Status** | Installed, manual UI only |
| **OpenRouter** | Working |
| **Local Gemma** | Working (`gemma4-e4b-bazzite:latest`) |
| **Autonomy** | NONE — manual UI only |

---

## Dashboard Packet Types

Space Agent can consume these packet types (all read-only):

| Packet | Source | Frequency | Content |
|--------|--------|-----------|---------|
| **Daily Health** | `gemma-monitor-daily` | Daily | Ollama, Gemma, GPU, bridge, evals |
| **Weekly Deep** | `gemma-monitor-weekly` | Weekly | Daily + knowledge, RuVector, helpers |
| **Drift Report** | `gemma-monitor-drift` | Weekly | Config drift, doc freshness, helper count |
| **RuVector Quality** | `gemma-memory-search` | On request | Retrieval comparison report |
| **RAG Answer** | `gemma-memory-rag` | On request | RAG-generated answer report |
| **System Snapshot** | Manual | On request | Current model, GPU, versions |

---

## Packet Data Contract

Each packet must follow the standard data contract:

```json
{
  "packet_type": "ruvector_quality|daily_health|rag_answer|...",
  "generated_at": "2026-05-02T12:00:00Z",
  "source": "gemma-memory-search|gemma-monitor-daily|...",
  "status": "PASS|WARN|FAIL",
  "summary": "One-line summary",
  "details": { ... },
  "recommendation": "Human-readable recommendation"
}
```

---

## Space Agent Consumption Pattern

### Manual Mode (Current and Approved)

1. Human runs helper script (e.g., `gemma-memory-search "query"`)
2. Helper generates report to `~/offload/security-reports/manual/`
3. Human opens Space Agent UI
4. Human copies relevant report sections into Space Agent chat
5. Space Agent provides conversational summary/advice based on pasted data

### NOT Approved (Autonomous Mode)

- Space Agent automatically polling helpers
- Space Agent generating packets without human request
- Space Agent modifying system state based on packet data
- Space Agent executing commands from packet content

---

## RuVector-Specific Packet Content

When a RuVector quality packet is consumed by Space Agent:

| Field | Space Agent Use |
|-------|-----------------|
| `query` | Display the original query |
| `ruvector_recommendation` | Show whether RuVector was used |
| `stage3a_recommendation` | Show whether Stage 3A was used |
| `confidence` | Display confidence level |
| `answerability` | Show answerability classification |
| `sources` | List top sources (for transparency) |
| `report_path` | Link to full report |

**Space Agent must NOT:**
- Treat RuVector as default
- Ignore Stage 3A fallback
- Execute recommendations automatically
- Modify retrieval behavior

---

## Integration Decision

**Decision: MANUAL CONSUMPTION ONLY**

Space Agent consumes dashboard packets via manual copy/paste only. No automated ingestion, no polling, no autonomous action based on packet content.

**Rationale:**
1. Space Agent is L7 manual UI — no autonomy
2. Packet data is advisory, not authoritative
3. Human judgment required for all decisions
4. Simplicity — no integration code needed

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| Space Agent status reviewed | PASS | v0.66.0 installed, working |
| Packet types defined | PASS | 6 packet types |
| Data contract defined | PASS | JSON schema |
| Consumption pattern defined | PASS | Manual only |
| Autonomous mode rejected | PASS | Not approved |
| RuVector content specified | PASS | Fields documented |
| No config modified | PASS | Design only |

| Category | Count |
|----------|-------|
| PASS | 7 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- M10: COMPLETE
- Space Agent consumption: MANUAL ONLY
- Autonomous ingestion: REJECTED
- No config modified
- Date: 2026-05-02

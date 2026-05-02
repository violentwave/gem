# Phase 17F: Space Agent Dashboard Roadmap Reframe

**Phase:** 17F — Space Agent Dashboard Roadmap Reframe
**Date:** 2026-05-02
**Parent:** Phase 17 (Implementation Planning)
**Status:** COMPLETE

---

## Purpose

Correct the post-Phase 17 roadmap so that Space Agent is treated as the operator dashboard / manual UI layer. Monitoring scripts and report generators are reframed as data providers for Space Agent, not as standalone dashboard components.

---

## User Correction

The original post-17 roadmap planned generic "Operator Dashboard and Report UX" as a separate concern. This was incorrect. The user clarified that:

> **Space Agent is the dashboard.** There is no separate dashboard app. Scripts and report generators are data providers for Space Agent.

---

## Corrected Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Space Agent (L7)                         │
│              Manual Dashboard / Operator UI                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Reports    │  │  Status     │  │  Manual Actions     │ │
│  │  (Markdown) │  │  (JSON)     │  │  (Human-triggered)  │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                             ▲
                             │ reads
┌─────────────────────────────────────────────────────────────┐
│              Report / Data Generators (L6-L7)               │
│  ┌─────────────────┐  ┌─────────────────────────────────┐   │
│  │ gemma-monitor-* │  │ gemma-security-summary          │   │
│  │ gemma-evals-*   │  │ gemma-memory-search/rag         │   │
│  │ gemma-knowledge-*│  │ gemma-repo-brief               │   │
│  └─────────────────┘  └─────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                             │ generates
┌─────────────────────────────────────────────────────────────┐
│              Core Systems (L1-L5)                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Gemma   │  │ OpenCode │  │ Agent Zero│  │ RuVector │   │
│  │  Ollama  │  │  Bridge  │  │  (L5)    │  │  (L6)    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Component Roles

| Component | Role | Dashboard Contribution |
|-----------|------|----------------------|
| **Space Agent** | Manual dashboard / operator UI | Displays reports, status, allows manual actions |
| **Gemma / Ollama** | Local advisory and summaries | Generates summaries for reports |
| **OpenCode** | Implementation engine | Creates scripts, docs, report generators |
| **Agent Zero** | Supervised orchestration (with timeout limitation) | Context provider, not autonomous controller |
| **Notion** | Phase / task tracker | Tracks progress, not dashboard |
| **Monitoring scripts** | Data providers | Generate packets for Space Agent |
| **Reports** | Markdown/JSON packets | Under canonical paths, read by Space Agent |

---

## Why Space Agent Is the Dashboard

1. **Already installed** — Space Agent v0.66.0 is operational (Phase 12L)
2. **Manual UI** — Designed for human operators, not autonomous agents
3. **Provider model** — Supports OpenRouter, local Ollama, Gemini (Phase 7E.1)
4. **Workspace** — Can display context, reports, and status
5. **No new infrastructure** — No need to build a separate dashboard app

## Why Scripts Are Data Providers Only

1. **Read-only** — Scripts inspect state, never modify it
2. **Deterministic** — Same inputs always produce same outputs
3. **Bounded** — Time limits, no infinite loops
4. **Canonical paths** — Reports go to `~/offload/security-reports/`
5. **Human-triggered** — Scripts run on demand, not as daemons

---

## What NOT to Build

| Forbidden | Reason |
|-----------|--------|
| Custom web dashboard | Space Agent already exists |
| Always-on dashboard daemon | Violates no-daemon boundary |
| Separate dashboard service | Unnecessary complexity |
| Browser-source dashboard | Space Agent is the UI |
| LAN dashboard | Violates localhost-only policy |
| Autonomous report generation | Must be human-triggered |

---

## Revised Phase 18–25 Roadmap

### Phase 18 — Space Agent Operator Dashboard Integration
**Goal:** Define what Space Agent displays and how report packets feed it.

- **18A:** Space Agent dashboard requirements and source inventory
- **18B:** Dashboard data contract (JSON/Markdown packet format)
- **18C:** Read-only dashboard packet generator design
- **18D:** Space Agent manual dashboard workflow
- **18E:** Notion dashboard/status packet integration
- **18F:** Phase 18 closeout

### Phase 19 — Monitoring / Eval / Security Implementation
**Goal:** Create the scripts that generate data for Space Agent.

- **19A:** Create gemma-monitor-daily
- **19B:** Create gemma-monitor-weekly
- **19C:** Create gemma-monitor-drift
- **19D:** Create shared monitor library
- **19E:** Generate first Space Agent dashboard packet
- **19F:** Phase 19 closeout

### Phase 20 — Knowledge Pack Expansion Implementation
**Goal:** Add new knowledge docs and re-index.

- **20A:** Write TROUBLESHOOTING.md
- **20B:** Write ROLLBACK_PROCEDURES.md
- **20C:** Write AGENT_ZERO_BOUNDARIES.md
- **20D:** Write NOTION_SYNC_GUIDE.md
- **20E:** Re-index knowledge pack with improved chunking
- **20F:** Phase 20 closeout

### Phase 21 — Retrieval Quality Upgrade
**Goal:** Improve Stage 3A and RuVector retrieval quality.

- **21A:** Implement improved chunking strategy
- **21B:** Add cross-reference metadata
- **21C:** Evaluate retrieval quality against baseline
- **21D:** Phase 21 closeout

### Phase 22 — Agent Zero + Space Agent Operator Workflow Catalog
**Goal:** Document all manual workflows for the operator.

- **22A:** Catalog all manual workflows
- **22B:** Define workflow trigger conditions
- **22C:** Create workflow decision tree
- **22D:** Phase 22 closeout

### Phase 23 — Controlled Learning Loop v1
**Goal:** Design v1 of supervised learning with human approval.

- **23A:** Learning ledger schema
- **23B:** Example approval workflow
- **23C:** Eval-driven feedback loop
- **23D:** Phase 23 closeout

### Phase 24 — Release / Recovery / Migration Discipline
**Goal:** Implement release process and rollback procedures.

- **24A:** Release tagging workflow
- **24B:** Rollback bundle creation
- **24C:** Recovery testing
- **24D:** Phase 24 closeout

### Phase 25 — Optional Advanced Model Work Review
**Goal:** Review advanced model options (future, not urgent).

- **25A:** Model comparison (Gemma vs alternatives)
- **25B:** Hardware upgrade assessment
- **25C:** Cloud vs local tradeoffs
- **25D:** Phase 25 closeout

---

## Boundary Confirmation

| Boundary | Status |
|----------|--------|
| No separate dashboard app | ✅ CONFIRMED |
| Space Agent = dashboard | ✅ CONFIRMED |
| Scripts = data providers | ✅ CONFIRMED |
| No daemon/timer automation | ✅ CONFIRMED |
| No system changes | ✅ CONFIRMED |
| No secrets exposed | ✅ CONFIRMED |
| No services started | ✅ CONFIRMED |

---

## Sign-Off

- Phase 17F: COMPLETE
- Roadmap reframed: Space Agent = dashboard
- Phases 18-25: Defined
- Boundaries: All confirmed
- Date: 2026-05-02

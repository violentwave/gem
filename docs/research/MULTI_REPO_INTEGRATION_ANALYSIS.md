# Multi-Repo Integration Analysis

**Date:** 2026-05-04  
**Scope:** Analyze external repos for safe integration into the Bazzite Local AI Operations Stack (`~/projects/gem`)  
**Method:** Remote inspection via GitHub CLI (no cloning, no installs, no network changes)  
**Repos Analyzed:**
1. `violentwave/bazzite-laptop` — User's own AI control plane
2. `ruvnet/RuVector` — Self-learning vector database
3. `ruvnet/*` (profile scan) — rUv's AI/Agent ecosystem
4. `NVIDIA/NemoClaw` — OpenClaw reference stack
5. `livekit-examples/agent-starter-react` — Voice AI frontend (separately reviewed)

---

## Executive Summary

| Repo | Integration Potential | Effort | Risk | Recommendation |
|------|----------------------|--------|------|----------------|
| **bazzite-laptop** | Very High | Medium | Low | Primary target — this IS the broader stack |
| **RuVector** | High | Medium | Low | Upgrade our prototype to full capabilities |
| **ruvnet/agentic-flow** | Low | Low | None | Pattern inspiration for model switching |
| **ruvnet/dspy.ts** | Low | Low | None | Pattern inspiration for declarative learning |
| **ruvnet/FACT** | Medium | Medium | Low | Could augment our RAG/context system |
| **ruvnet/guardrail** | Medium | Low | Low | Could harden our safety boundaries |
| **NemoClaw** | Low | High | High | Architecture inspiration only — too heavy |
| **LiveKit starter** | Low | Low | None | UI/voice inspiration only (already reviewed) |

**Bottom line:** `bazzite-laptop` is the primary integration target — it contains the full AI control plane our `gem` project was designed to coordinate. RuVector is the secondary target for upgrading our memory prototype. Everything else is pattern inspiration.

---

## 1. violentwave/bazzite-laptop — The AI Control Plane

### What It Is

The **Bazzite AI Layer** — a comprehensive local AI control plane for the Bazzite gaming laptop. This is the user's own repository and represents the broader stack that `~/projects/gem` was designed to coordinate.

**Scale:** 1326 files, 83 MCP tools, 2297+ tests, 23 systemd timers, 26 LanceDB tables, 6 cloud LLM providers  
**Tech Stack:** Python 3.12+, Node.js v25+, Rust (RuVector), uv virtualenv, systemd user services  
**Branch:** `master`

### Directory Structure

```
bazzite-laptop/
├── ai/                          # Core AI logic (~50+ modules)
│   ├── agent_workbench/         # Git, handoff, registry, sandbox, sessions
│   ├── agents/                  # Code quality, knowledge, performance, security, timer
│   ├── alerts/                  # Dispatcher, history, rules
│   ├── code_intel/              # Parser, store
│   ├── code_quality/            # Analyzer, formatter, runner
│   ├── collab/                  # File claims, knowledge base, shared context, task queue
│   ├── context/                 # Isolation, models, paths
│   ├── budget*.py               # Token budget routing
│   ├── cache*.py                # Semantic caching
│   ├── canary.py                # System canary
│   └── config.py                # Central config
├── scripts/                     # Deployment, security, maintenance
│   ├── bazzite-security-test.sh
│   ├── canary.sh
│   ├── code-quality.sh
│   ├── deploy-services.sh
│   ├── clamav-*.sh
│   ├── gaming-*.sh
│   ├── ingest-*.sh
│   ├── mcp-stdio-bridge.sh
│   └── optimize.sh
├── configs/                     # Runtime configurations
│   ├── litellm-config.yaml
│   ├── mcp-bridge-allowlist.yaml
│   ├── safety-rules.json
│   ├── security-autopilot-policy.yaml
│   ├── token-budget.json
│   └── ai-rate-limits.json
├── systemd/                     # 23+ user services/timers
│   ├── bazzite-mcp-bridge.service
│   ├── bazzite-llm-proxy.service
│   ├── clamav-*.service/timer
│   ├── cve-scanner.service/timer
│   ├── knowledge-storage.service/timer
│   └── code-index.service/timer
├── docs/                        # Architecture, guides, phases
├── .claude/                     # Claude Code configs
├── .codex/                      # Codex configs
├── .opencode/                   # OpenCode configs + plugins
└── .github/workflows/           # CI/CD (CodeQL, Semgrep, OpenCode)
```

### What We Already Use

From `bazzite-laptop/scripts/`:
- `security_test` → `gemma-security-chat` tool
- `health_snapshot` → `gemma-security-chat` tool
- `security_briefing` → `gemma-security-chat` tool
- `service_canary` → `gemma-security-chat` tool
- `thermal_check` → `gemma-security-chat` tool
- `threat_lookup` → `gemma-security-chat` tool

### What We Can Safely Integrate

#### Immediate (Low Effort)
1. **MCP Bridge Integration** (`configs/mcp-bridge-allowlist.yaml` + `scripts/mcp-stdio-bridge.sh`)
   - Our `gemma-ui` could route through the MCP bridge to access all 83 tools
   - Effort: Low — config wiring only
   - Risk: Low — read-only or advisory only

2. **Safety Rules** (`configs/safety-rules.json`)
   - Import safety rules into our `gemma-command-review` or `gemma-ui` boundaries
   - Effort: Low — JSON merge
   - Risk: None — read-only policy

3. **Token Budget Awareness** (`configs/token-budget.json`, `ai/budget*.py`)
   - Add budget display to `gemma-ui` status bar
   - Effort: Low — read config, display
   - Risk: None

#### Short-Term (Medium Effort)
4. **Code Quality Agent** (`ai/code_quality/`)
   - Integrate code quality checks into our validation workflow
   - Effort: Medium — wrapper script
   - Risk: Low — read-only analysis

5. **Knowledge Storage Agent** (`ai/agents/knowledge_storage.py`)
   - Connect to our RuVector/Stage 3A memory system
   - Effort: Medium — adapter layer
   - Risk: Low —scoped to approved docs

6. **Alert Dispatcher** (`ai/alerts/`)
   - Route security alerts to `gemma-ui` reports mode
   - Effort: Medium — log parser + display
   - Risk: Low

#### Long-Term (Higher Effort)
7. **Agent Workbench** (`ai/agent_workbench/`)
   - Full integration with OpenCode/Codex handoff system
   - Effort: High — requires understanding workbench protocol
   - Risk: Medium — could conflict with our existing handoff system

8. **LLM Proxy Routing** (`systemd/bazzite-llm-proxy.service`)
   - Route Gemma through the local proxy for unified provider management
   - Effort: High — config changes, testing
   - Risk: Medium — could break Ollama direct access

### What to Avoid
- **Systemd timers** — do not install or enable on the host without explicit approval
- **ClamAV scans** — already handled, don't duplicate
- **Cloud LLM providers** — keep Gemma local-only
- **`keys.env.enc`** — never import or decrypt credential files
- **`deploy-services.sh`** — do not run without phase-by-phase approval

---

## 2. ruvnet/RuVector — Self-Learning Vector DB

### What It Is

A **self-learning, self-optimizing vector database** with graph intelligence, local AI, and PostgreSQL. Built in Rust with npm and WASM bindings. Winner of a CES 2026 Innovation Award.

**Core Innovation:** SONA engine watches how you query and adapts — search results improve automatically.

### Architecture

```
User Query → [SONA Engine] → Model Response → User Feedback
                 ↑                                │
                 └─────── Learning Signal ────────┘
                        (< 1ms adaptation)
```

### Key Features (Beyond Our Prototype)

| Feature | Our Prototype | RuVector Full | Value |
|---------|--------------|---------------|-------|
| Search | Cosine similarity | GNN + 50+ attention mechanisms | Results improve over time |
| Index | Basic HNSW | DiskANN (billion-scale, <10ms) | Scale to millions of vectors |
| Search type | Dense only | Hybrid (sparse + dense + RRF) | 20-49% better retrieval |
| RAG | Chunk-based | Graph RAG + community detection | 30-60% improvement |
| Quantization | None | TurboQuant (2-4 bit, 6-8x savings) | Massive memory reduction |
| Embeddings | Single nomic-embed | ColBERT multi-vector + Matryoshka | Fine-grained matching |
| Graph | None | Full Cypher engine (Neo4j-like) | Relationship queries |
| Backend | JSON files | PostgreSQL | Production persistence |
| Bindings | Python only | Rust + Node + WASM | Multi-platform |

### What We Already Have

From Phase 7B/8B:
- `gemma-memory-search` — RuVector semantic search with Stage 3A fallback
- `gemma-memory-rag` — RuVector RAG with Ollama generation
- 398 chunks indexed with `nomic-embed-text:latest`
- Source-family classification, answerability calibration

### Integration Path

#### Option A: In-Place Upgrade (Recommended)
Keep our Python wrappers but upgrade the underlying RuVector npm package to latest:
1. Update `ruvector` npm package (already installed)
2. Enable hybrid search (sparse + dense)
3. Add Graph RAG for multi-hop queries
4. Enable SONA learning for query adaptation
5. Keep Stage 3A as fallback

**Effort:** Medium  
**Risk:** Low — our wrappers abstract the backend  
**Benefit:** Immediate quality improvement

#### Option B: Full Rust Integration
Replace Python wrappers with Rust CLI + bindings:
1. Install `ruvector-cli` via cargo
2. Use `ruvector-mcp` for MCP integration
3. Direct PostgreSQL backend
4. Full graph queries via Cypher

**Effort:** High  
**Risk:** Medium — new dependency chain (Rust, PostgreSQL)  
**Benefit:** Maximum performance and features

#### Option C: Stay on Prototype
Keep current system until quality gates justify upgrade.

**Effort:** None  
**Risk:** None  
**Benefit:** Stability

### Recommendation

**Option A (In-Place Upgrade)** when:
- We need better retrieval quality
- We're ready to test hybrid search
- Memory usage becomes a concern (TurboQuant)

**Option C (Stay)** until:
- Current prototype shows limitations in daily use
- We have time for regression testing

---

## 3. ruvnet Profile — The Ecosystem

### Top Repos by Relevance

| Repo | Stars | Lang | Description | Relevance | Integration |
|------|-------|------|-------------|-----------|-------------|
| **agentic-flow** | 670 | TS | Model switching for Claude Code/agents | Medium | Could add model switching to `gemma-ui` |
| **Bot-Generator-Bot** | 565 | Nix | Bot prompt generator | Low | Pattern inspiration for prompt engineering |
| **dspy.ts** | 245 | TS | Declarative self-learning JS | Medium | Could inspire eval/learning pipeline |
| **daa** | 234 | Rust | Decentralized autonomous apps | Low | Architecture inspiration only |
| **FACT** | 165 | Python | Fast augmented context tools | High | Could replace/augment our RAG context building |
| **guardrail** | 149 | Python | Data analysis/AI guardrails | High | Could harden `gemma-command-review` |
| **agentic-voice** | 114 | TS | Voice chat app | Low | UI pattern inspiration |
| **midstream** | 101 | Rust | AI conversation platform | Low | Architecture inspiration |
| **flow-nexus** | 87 | JS | Competitive agentic platform | Low | Pattern inspiration |
| **federated-mcp** | 63 | TS | MCP federation | Medium | Could extend our MCP bridge |

### Key Takeaways

**FACT (Fast Augmented Context Tools)**
- Lean retrieval pattern for fast context assembly
- Could augment our `gemma-memory-rag` context building
- Python-based — easy to integrate
- MIT license

**guardrail**
- Advanced safety boundary enforcement
- Could harden our `gemma-command-review` and `gemma-ui` safety checks
- Python-based
- MIT license

**agentic-flow**
- Switch between models (Claude, Gemini, OpenRouter)
- Could inspire a "model switch" feature in `gemma-ui` (e.g., switch between Gemma variants)
- TypeScript — patterns only, not code

**federated-mcp**
- MCP server federation/discovery
- Could help scale our MCP bridge beyond local tools

### Integration Strategy

For ruvnet repos: **Pattern inspiration, not code import.**
- Read their approaches
- Adapt concepts to our stack
- Do not add dependencies
- MIT license allows study and adaptation

---

## 4. NVIDIA/NemoClaw — OpenClaw Reference Stack

### What It Is

NVIDIA's reference stack for running **OpenClaw** always-on assistants in a sandboxed environment. Alpha software (March 2026).

**Architecture:**
```
nemoclaw onboard → plugin → blueprint runner → openshell CLI → sandbox
                                                        ↓
                                              ┌─────────────────┐
                                              │  OpenClaw agent │
                                              │  + NVIDIA infer │
                                              │  + network policy│
                                              │  + filesystem iso │
                                              └─────────────────┘
```

### Requirements
- Node.js 22.16+, npm 10+
- Docker / k3s
- 4+ vCPU, 8+ GB RAM
- ~2.4 GB sandbox image

### What's Interesting

1. **Blueprint System** — Versioned, immutable, digest-verified orchestration artifacts
2. **Skill System** — Extensive `.agents/skills/` with maintainer-day, security-review, contributor workflows
3. **State Management** — Credential-stripped agent state migration
4. **Layered Protection** — Network policy, filesystem isolation, inference routing
5. **Supply Chain Safety** — Immutable blueprint artifacts

### What's Not Applicable

- **Requires NVIDIA stack** — Docker, k3s, OpenShell runtime
- **Alpha software** — Not production-ready, interfaces may change
- **Cloud-connected** — Designed for hosted deployment
- **Heavy resource usage** — 2.4 GB sandbox image
- **Not local-first** — OpenClaw is a different agent framework

### What We Can Borrow

1. **Blueprint concept** — Versioned, immutable configuration artifacts
   - Apply to our `gemma-ui.json` + helper configs
   - Add config versioning and checksums

2. **Skill system structure** — The `.agents/skills/` directory organization
   - Could inspire our helper categorization
   - Each skill = markdown + scripts + references

3. **State management** — How they migrate agent state with credential stripping
   - Apply to our session handoff system

4. **Supply chain safety** — Immutable, digest-verified artifacts
   - Apply to our script validation workflow

### Recommendation

**Architecture inspiration only.** Do not integrate NemoClaw directly.
- Too heavy for our local-only stack
- Alpha status = unstable
- Requires NVIDIA ecosystem
- Apache-2.0 license (permissive, but irrelevant since we're not copying code)

---

## 5. livekit-examples/agent-starter-react

Already reviewed separately in [`LIVEKIT_AGENT_STARTER_REVIEW.md`](LIVEKIT_AGENT_STARTER_REVIEW.md).

**Summary:** UI/voice inspiration only. Config-driven patterns, view state machines, transcript panels, and error handling are adaptable. LiveKit SDK, Next.js runtime, and web dependencies are not.

---

## 6. Integration Roadmap

### Phase 1: Immediate (This Week)
1. **Wire `gemma-ui` to bazzite-laptop configs**
   - Read `configs/safety-rules.json` into `gemma-ui` boundaries
   - Read `configs/token-budget.json` for status display
   - Read `configs/ai-rate-limits.json` for throttling awareness

2. **Expand bazzite-laptop tool integration**
   - Add `code-quality.sh`, `canary.sh`, `optimize.sh` to `gemma-security-chat`
   - Add `gaming-analyze.sh`, `gaming-profile.sh` as optional tools

### Phase 2: Short-Term (Next 2-4 Weeks)
3. **MCP Bridge routing**
   - Route `gemma-ui` through `bazzite-mcp-bridge` for unified tool access
   - Enable access to all 83 MCP tools from terminal UI

4. **RuVector in-place upgrade**
   - Enable hybrid search in `gemma-memory-search`
   - Test Graph RAG for multi-hop queries
   - Enable SONA learning signal collection

5. **Alert integration**
   - Connect `ai/alerts/` dispatcher to `gemma-ui` reports mode
   - Show security alerts, CVE scans, canary failures in UI

### Phase 3: Long-Term (2-3 Months)
6. **Agent Workbench coordination**
   - Integrate `ai/agent_workbench/` handoff system with our OpenCode prompts
   - Unified session management across OpenCode/Codex/Gemma

7. **Code quality pipeline**
   - Integrate `ai/code_quality/` into our validation workflow
   - Auto-run on `gemma-ui` script changes

8. **RuVector full Rust backend**
   - Evaluate Rust CLI + PostgreSQL backend
   - Only if prototype shows scaling limits

### Phase 4: Future (3+ Months)
9. **Web UI exploration**
   - Use LiveKit patterns + bazzite-laptop components
   - Static HTML dashboard (like existing `gemma-dashboard-build`)
   - No Next.js, no server, no daemon

10. **Model switching**
    - Inspired by `agentic-flow`
    - Switch between Gemma variants, local vs remote (if approved)

---

## 7. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| bazzite-laptop config drift | High | Medium | Version configs, checksum validation |
| RuVector upgrade breaks Stage 3A fallback | Medium | High | Test regression before upgrade |
| MCP bridge adds latency | Medium | Low | Keep direct Ollama path as fallback |
| NemoClaw temptation to install | Low | High | Document why we avoid it |
| ruvnet repos add dependency creep | Medium | Medium | Pattern-only rule, no code import |
| Systemd timer conflicts | Low | High | Never enable timers without approval |

---

## 8. License Summary

| Repo | License | Notes |
|------|---------|-------|
| violentwave/bazzite-laptop | Unknown (likely private) | User's own repo |
| ruvnet/RuVector | MIT | Permissive, attribution required for substantial code |
| ruvnet/* | Mostly MIT | Check per-repo |
| NVIDIA/NemoClaw | Apache-2.0 | Permissive, patent grant |
| livekit-examples/agent-starter-react | MIT | Permissive |

---

## 9. Recommended Next Steps

1. **Read bazzite-laptop configs** — `configs/safety-rules.json`, `configs/token-budget.json`, `configs/mcp-bridge-allowlist.yaml`
2. **Design `gemma-ui` config expansion** — Add safety rules, budget display, MCP routing options
3. **Plan RuVector hybrid search test** — Enable in `gemma-memory-search`, run Stage 4 evals
4. **Add bazzite-laptop scripts** to `gemma-security-chat` tool registry
5. **Create integration tracking doc** — `docs/integrations/BAZZITE_LAPTOP_INTEGRATION_PLAN.md`

---

**End of analysis.**

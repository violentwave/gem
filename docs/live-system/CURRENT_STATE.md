# Current Live System State

**Host:** Bazzite/Fedora Atomic Desktop
**User:** lch
**Home Path:** `/var/home/lch`
**Date:** 2026-04-30

## Hardware

- **GPU:** NVIDIA GeForce GTX 1060 6GB
- **RAM:** ~16GB
- **Storage:** Fedora Atomic image-based

## Software Versions

### Ollama
- **Path:** `/usr/local/bin/ollama`
- **Version:** 0.22.0 (as of last check)
- **API:** http://127.0.0.1:11434
- **GPU:** CUDA available

### OpenCode
- **Path:** `/home/lch/.npm-global/bin/opencode`
- **Package:** @anthropic-ai/opencode

### Current Models
- **Base:** `gemma4:e4b` (9.6 GB)
- **Custom Profile:** `gemma4-e4b-bazzite:latest` (9.6 GB)

## Completed Stages

### Stage 1: Profile Teaching
- Custom Gemma profile with Bazzite/Fedora Atomic context
- Location: `~/.config/bazzite-security/ollama/Modelfile.gemma4-e4b-bazzite`
- System prompt includes:
  - Bazzite/Fedora Atomic identity
  - Firewalld (not ufw)
  - RPM-ostree (not apt)
  - Flatpak/Homebrew preferences
  - Security boundaries

### Stage 2: Curated Knowledge Pack
- Location: `~/.local/share/bazzite-security/gemma-knowledge/`
- Approved docs: PATHS.md, FINAL_POLICY.md, RUNBOOK.md, OPERATIONS.md, etc.
- RAG-enabled via deterministic retrieval

### Stage 3A: Deterministic Retrieval
- JSONL chunk index at `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
- Keyword-based search scoring
- Bounded RAG queries with timeout
- No embeddings, no vector database

### Stage 4A: Eval Scaffolding
- Location: `~/.local/share/bazzite-security/gemma-evals/cases/`
- 19 total cases:
  - command_review: 8
  - knowledge_rag: 5
  - path_policy: 5
  - forbidden_output: 1
- Validator: `gemma-evals-check`
- Status: PASS

### Stage 4B: Supervised Examples
- Location: `~/.local/share/bazzite-security/gemma-evals/examples/`
- 22 total examples:
  - command_review_example: 8
  - rag_answer_example: 5
  - path_policy_example: 5
  - bad_to_corrected_example: 4
- Status: 22 reviewed, 0 draft, 0 deprecated
- Validator: `gemma-examples-check`
- Status: PASS

### Stage 4C: Status Reporter
- Script: `~/.local/bin/gemma-evals-status`
- Reports eval/example health, coverage matrix, documentation drift
- Latest: PASS

### Stage 4D: Draft Review Packet
- Script: `~/.local/bin/gemma-examples-review-drafts`
- Reviews draft examples, generates recommendations
- Latest: PASS (0 drafts)

### Stage 4E: False-Positive Fix
- Context-aware forbidden-platform detection
- Negative contexts ("not ufw") no longer auto-blocked
- Latest: PASS

### Stage 4F: Draft Promotion
- Promoted 4 examples to reviewed
- Result: 100% reviewed (22/22)

### Stage 4G: Final Closeout
- Documentation drift: None
- All validators: PASS

## Canonical Live Paths

### Config
```
~/.config/bazzite-security/
├── PATHS.md
├── FINAL_POLICY.md
├── RUNBOOK.md
├── OPERATIONS.md
├── GEMMA_LOCAL_AGENT.md
├── OPENCODE_GEMMA_NOTES.md
└── ollama/
    └── Modelfile.gemma4-e4b-bazzite
```

### Scripts
```
~/.local/bin/
├── gemma-bazzite
├── gemma-bazzite-health
├── gemma-security-summary
├── gemma-security-summary-check
├── gemma-opencode-check
├── gemma-file-brief
├── gemma-command-review
├── gemma-repo-brief
├── gemma-benchmark-context
├── gemma-open-code-status
├── gemma-knowledge-refresh
├── gemma-knowledge-ask
├── gemma-knowledge-check
├── gemma-knowledge-index
├── gemma-knowledge-search
├── gemma-knowledge-rag
├── gemma-evals-check
├── gemma-examples-check
├── gemma-evals-status
└── gemma-examples-review-drafts
```

### Persistent State
```
~/.local/share/bazzite-security/
├── gemma-knowledge/
│   ├── docs/
│   ├── index/
│   └── manifests/
└── gemma-evals/
    ├── cases/
    ├── examples/
    └── manifests/
```

### Logs
```
~/.local/state/bazzite-security/logs/
```

### Cache
```
~/.cache/bazzite-security/
```

### Reports
```
~/offload/security-reports/
├── daily/
├── weekly/
├── audit/
└── manual/
```

## Operating Model

### Current Capability Level
- **Gemma wrappers:** L1 advisory, L2 report writing, RAG queries
- **gemma-memory-search:** Supervised RuVector semantic search with Stage 3A fallback
- **gemma-memory-rag:** Supervised RAG using RuVector context + local Ollama generation
- **OpenCode/Codex:** Implementation work, repo operations, config editing
- **Agent Zero:** Not yet integrated (assessment phase)
- **RuVector:** Supervised prototype only (L6), NOT production default
- **Space Agent:** Manual UI only (L7), not autonomous

### Security Boundaries (Updated 2026-05-01)
- No unattended Gemma implementation
- No sudo without explicit authorization
- No system config changes without review
- No secrets in coordination repo
- RuVector is supervised only — Stage 3A remains canonical fallback
- gemma-memory-search/rag are helpers, NOT wrapper defaults

## Phase 8 Completion (2026-05-01)

### Completed Sub-Phases
- ✅ Phase 8A: Agent Zero Workflow Library (L5) — defined, not executed
- ✅ Phase 8B.1-8B.3: Memory Workflow Library (L6) — defined, not executed
- ✅ Phase 8B.4-8B.5: Memory Quality Validation & Production Review
- ✅ Phase 8B.6: Supervised RuVector Search (gemma-memory-search)
- ✅ Phase 8B.6A: Source-Family Classification
- ✅ Phase 8B.6B: Answerability Calibration
- ✅ Phase 8B.7: Supervised RuVector RAG Integration (gemma-memory-rag)
- ✅ Phase 8B.7A: Context Extraction Fix (TOP_N=4, CHARS_PER_CHUNK=1800)
- ✅ Phase 8C: Space Agent Workspace Workflow Library (L7, manual only)
- ✅ Phase 8D.1-8D.3: Workflow Index, Repo Baseline, GitHub Remote Setup
- ✅ Phase 8E: Final Closeout and Regression Review

### New Helpers Added (2026-05-01)
```
~/.local/bin/
├── gemma-memory-search    # Supervised RuVector semantic search
├── gemma-memory-rag       # Supervised RAG with RuVector + Ollama
```

### RuVector Status
- **Status:** Supervised prototype (not production)
- **Index:** `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json`
- **Model:** nomic-embed-text:latest (768d)
- **Chunks:** 398
- **Usage:** gemma-memory-search/rag only — NOT global default

### GitHub Remote
- **Repo:** https://github.com/violentwave/gem (PRIVATE)
- **Latest Commit:** b557c37 (Phase 8B.7A fix)

## Phase 11D Closeout (2026-05-02)

**Phase 11D:** RAG Answer Comparison Dry-Run
- Static validators: PASS (19 cases)
- Query comparisons: PASS (7/7 queries)
- Exact agreement: 1/7 (expected, helper provides recommendations)
- Partial/divergent: 3/7 (expected)
- Insufficient: 2/7 (needs future policy update)
- Safe for manual use: YES
- Stage 3A fallback: PRESERVED
- Helper recommendations: YES (use_ruvector_context, use_stage3a_context, insufficient_evidence)

**Query Results:**
| # | Query | Agreement | Recommended |
|---|-------|-----------|---------------|
| 1 | Safe operating model | exact | either |
| 2 | Reports path | partial | Stage 3A |
| 3 | Firewall tool | divergent | RuVector |
| 4 | RuVector fallback | insufficient | needs review |
| 5 | Denied data | insufficient | needs review |
| 6 | Gemma/OpenCode boundary | partial | Stage 3A |
| 7 | Cache path | partial | Stage 3A |

**Helper Outputs:** Reports saved to ~/offload/security-reports/manual/gemma-memory-search-*.md
**Closeout Doc:** docs/phase11/PHASE11D_RAG_ANSWER_COMPARISON_DRY_RUN.md

**Phase 11E:** Stale-Memory Review Packet (2026-05-02) — COMPLETE
- Inventory: Knowledge pack (6 docs), Stage 3A (234 chunks), RuVector (5 files)
- Findings: 11 KEEP, 3 REVIEW (variant manifests), 1 CANDIDATE_FOR_MANUAL_CLEANUP (temp reports)
- No mutations performed
- Stage 3A fallback: PRESERVED
- RuVector supervised-secondary: CONFIRMED

**Phase 11 Complete:** Memory Quality Operations (2026-05-02)
- Phase 11A ✅
- Phase 11B ✅
- Phase 11C ✅
- Phase 11C-RV ✅
- Phase 11D ✅
- Phase 11E ✅

**Phase 12A:** Supervised Agent Zero / Space Agent Bridge Planning (2026-05-02) — OPEN
- Bridge plan: docs/phase12/PHASE12_SUPERVISED_BRIDGE_PLAN.md
- Boundaries: docs/phase12/AGENT_ZERO_SPACE_AGENT_BRIDGE_BOUNDARIES.md
- Workflow candidates: docs/phase12/BRIDGE_WORKFLOW_CANDIDATES.md
- Phase 12B prompt: prompts/opencode/phase12b-agent-zero-readonly-bridge-review.prompt.txt
- Phase 12C prompt: prompts/opencode/phase12c-space-agent-manual-ui-bridge-review.prompt.txt
- Status: Planning complete, execution requires explicit prompt
- No Agent Zero execution
- No Space Agent execution
- No authority granted

**Phase 12B:** Agent Zero Read-Only Bridge Review (2026-05-02) — COMPLETE
- Review doc: docs/phase12/PHASE12B_AGENT_ZERO_READONLY_BRIDGE_REVIEW.md
- Briefing template: docs/phase12/AGENT_ZERO_READONLY_BRIEFING_PACKET_TEMPLATE.md
- Runtime dry-run prompt: prompts/opencode/phase12b1-agent-zero-readonly-runtime-dry-run.prompt.txt
- Agent Zero state inspected (read-only): installed, not running, no auto-restart
- Readiness: CONFIRMED for explicit future dry-run
- No Agent Zero execution in this phase
- No authority granted

**Phase 12B1:** Agent Zero Read-Only Runtime Dry-Run (2026-05-02) — COMPLETE
- Closeout: docs/phase12/PHASE12B1_AGENT_ZERO_READONLY_RUNTIME_DRY_RUN.md
- Report: ~/offload/security-reports/manual/phase12b1-agent-zero-readonly-briefing-20260502-024755.md
- Agent Zero started: SUCCESS (v1.9, via Podman)
- Agent Zero stopped: SUCCESS
- API discovered: /api/health, /api/plugins/_a0_connector/v1/chat_create, /api/plugins/_a0_connector/v1/message_send
- Key finding: Agent Zero requires external LLM provider API key for AI-generated responses
- No config modified
- No repo/host authority granted
- No memory/learning/training enabled
- Boundary compliance: PASS

**Phase 12B2:** Agent Zero Local Gemma Provider Wiring Review (2026-05-02) — COMPLETE
- Closeout: docs/phase12/PHASE12B2_AGENT_ZERO_LOCAL_GEMMA_PROVIDER_REVIEW.md
- Ollama status: Running v0.22.0, 3 models available
- Container-to-host connectivity: SUCCESS via slirp4netns gateway (10.0.2.2:11434)
- /api/tags reachable: YES
- /v1/models reachable: YES
- Local Gemma response: PARTIAL — request reached Ollama but timed out during 9.6GB model load
- Config mutation required: YES (Agent Zero needs Ollama base URL set to 10.0.2.2:11434)
- External API fallback: NOT NEEDED — local path works, just needs config patch
- No Ollama LAN exposure: CONFIRMED
- No Ollama config changes: CONFIRMED
- No secrets exposed: CONFIRMED
- Boundary compliance: PASS

**Phase 12B3:** Agent Zero Local Gemma Config Patch Test (2026-05-02) — COMPLETE
- Closeout: docs/phase12/PHASE12B3_AGENT_ZERO_LOCAL_GEMMA_CONFIG_PATCH_TEST.md
- Config backed up: config.json.backup-20260502-031538
- Config patched: chat_model → ollama/gemma4-e4b-bazzite:latest@10.0.2.2:11434
- Agent Zero started: SUCCESS
- Direct Ollama from container: SUCCESS (Gemma responded correctly)
- Agent Zero message send: PARTIAL — Ollama connected but Agent Zero expects JSON tool format, Gemma returns plain text
- Config reverted: SUCCESS (restored from backup)
- No Ollama LAN exposure: CONFIRMED
- No Ollama config changes: CONFIRMED
- No secrets exposed: CONFIRMED
- Boundary compliance: PASS

**Phase 12C:** Space Agent Manual UI Bridge Review (2026-05-02) — COMPLETE
- Closeout: docs/phase12/PHASE12C_SPACE_AGENT_MANUAL_UI_BRIDGE_REVIEW.md
- Space Agent binary: NOT FOUND
- Space Agent container: NOT FOUND
- Space Agent config: NOT FOUND (~/conf/ does not exist)
- Space Agent data dir: EXISTS (~/.config/space-agent/ — Electron app data)
- Space Agent process: NOT RUNNING
- Status: BLOCKED — Space Agent must be installed before dry-run
- No config modified
- No secrets exposed
- Boundary compliance: PASS

**Phase 12E-FIX:** OpenCode Bridge Localhost Hardening (2026-05-02) — COMPLETE
- Bridge hardened to 127.0.0.1:4141
- Wrong opencode serve web UI process cleaned from port 4141
- Bridge helper scripts verified: opencode-bridge-up/down/status
- Bridge config backup: ~/.config/opencode-bridge/config.json.backup-20260502-060158
- Agent Zero stopped, not started for message_send (bridge not reachable from container yet)
- Boundary compliance: PASS

**Phase 12E2:** Agent Zero Loopback Bridge Reachability Fix (2026-05-02) — COMPLETE
- Closeout: docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md
- Helper already correct: agent-zero-up uses --network slirp4netns:allow_host_loopback=true
- Helper backup: ~/.local/bin/agent-zero-up.backup-20260502-060158
- Bridge bind: 127.0.0.1:4141 (not 0.0.0.0)
- Container bridge route: WORKING (10.0.2.2:4141 reachable)
- Agent Zero UI/API health: WORKING (v1.9)
- One-message test: PASSED (safe read-only response)
- Bridge session stale: CLEARED (backup: ~/.local/share/opencode-bridge/session.json.backup-20260502-060745)
- Agent Zero stopped after test
- No secrets exposed
- Boundary compliance: PASS

**Phase 12F:** Agent Zero OpenCode Bridge Read-Only Briefing Dry-Run (2026-05-02) — COMPLETE
- Closeout: docs/phase12/PHASE12F_AGENT_ZERO_OPENCODE_BRIDGE_READONLY_BRIEFING_DRY_RUN.md
- Approved source: docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md
- Bridge status: WORKING (127.0.0.1:4141)
- Agent Zero start: SUCCESS
- Agent Zero host health: WORKING (v1.9)
- Chat context creation: SUCCESS (gqr1IM5R)
- Container direct bridge chat: SUCCESS (OpenCode responded)
- Agent Zero message_send: TIMEOUT after 180s (documented as WARN)
- Agent Zero stop: SUCCESS
- No secrets exposed
- Boundary compliance: PASS
- Next: Phase 12G (timeout tuning) or Phase 12H (closeout) or Phase 13

---

## Validation

Run these to verify current state:
```bash
gemma-examples-check  # Should PASS
gemma-evals-check     # Should PASS
gemma-evals-status   # Should PASS
gemma-examples-review-drafts  # Should PASS
```

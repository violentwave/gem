# Roadmap

## Completed Stages

### Stage 1: Profile Teaching ✅
- Custom Gemma profile with Bazzite/Fedora Atomic context
- System prompt guardrails
- Location: `~/.config/bazzite-security/ollama/Modelfile.gemma4-e4b-bazzite`

### Stage 2: Curated Knowledge Pack ✅
- Approved docs identified and copied
- Knowledge pack structure
- RAG-ready

### Stage 3A: Deterministic Retrieval ✅
- JSONL chunk index
- Keyword-based search
- Bounded RAG queries
- No embeddings required

### Stage 4A-G: Eval & Example System ✅
- 4A: Eval scaffolding (19 cases)
- 4B: Supervised examples (22 reviewed)
- 4C: Status reporter
- 4D: Draft review packet
- 4E: False-positive fix
- 4F: Draft promotion
- 4G: Final closeout

## Maintenance Phases

### M15: Agent Zero Local Gemma Compatibility Review ✅ Completed
**Goal:** Review Agent Zero's compatibility with local Gemma/Ollama

**Tasks:**
- Verify direct Ollama route from Agent Zero container
- Document OpenCode bridge as optional/experimental
- Document tool-protocol incompatibility (plain text vs JSON tool format)
- Confirm no chat-only/local profile exists
- Confirm current `hacker` profile is autonomous-oriented
- Recommend Space Agent as local Gemma dashboard
- Create supervised profile design artifact (future-oriented)

**Deliverables:**
- `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`
- `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`
- `docs/maintenance/AGENT_ZERO_SUPERVISED_PROFILE_DESIGN.md`
- `prompts/opencode/m15a-agent-zero-supervised-profile-design.prompt.txt`

**Result:** Direct local Gemma route works. Agent Zero tool-protocol incompatibility documented. Space Agent confirmed as recommended local Gemma dashboard. Agent Zero remains supervised/experimental.

**Depends on:** Phase 12B3, Phase 12L

**Do Not:**
- Modify Agent Zero config
- Install packages
- Pull models
- Enable autonomy

---

### M16: Local Dashboard Pivot ✅ Completed
**Goal:** Build a safe local static dashboard after M15 Agent Zero local Gemma no-go

**Tasks:**
- Research Space Agent from local evidence (read-only)
- Document Space Agent proven status, unknowns, and unsafe assumptions
- Confirm Space Agent is enough as manual chat dashboard but not stack status view
- Design dashboard requirements (10 panels, read-only, no daemon)
- Build `scripts/gemma-dashboard-build` (bash, standard library only)
- Generate HTML dashboard, Markdown report, and log
- Validate syntax, shellcheck, and output

**Deliverables:**
- `docs/dashboard/LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md`
- `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md`
- `scripts/gemma-dashboard-build`
- `~/.local/share/bazzite-security/dashboard/index.html`
- `~/offload/security-reports/manual/gemma-dashboard-YYYYMMDD-HHMMSS.md`

**Result:** Static dashboard generator operational. Space Agent confirmed running and recommended as manual local Gemma dashboard. Agent Zero remains supervised/experimental. No system changes.

**Depends on:** M15

**Do Not:**
- Modify Agent Zero config
- Modify Space Agent config
- Install packages
- Pull models
- Enable autonomy
- Start a daemon or server

---

### M17: Dashboard Usability and Operator Workflow ✅ Completed
**Goal:** Make the dashboard easy to refresh and use without adding a daemon or system changes

**Tasks:**
- Create `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md` with full panel explanations
- Add `--help` / `-h` to `scripts/gemma-dashboard-build`
- Document optional `~/.local/bin/gemma-dashboard` symlink install
- Preserve all safety boundaries

**Deliverables:**
- `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- `docs/maintenance/M17_DASHBOARD_OPERATOR_WORKFLOW.md`
- Updated `scripts/gemma-dashboard-build`

**Result:** Dashboard has clear operator guide, `--help` works, optional install is documented but not automatic. Dashboard remains static and manually refreshed.

**Depends on:** M16

**Do Not:**
- Modify Agent Zero config
- Modify Space Agent config
- Install packages
- Pull models
- Enable autonomy
- Start a daemon or server
- Run automatic install

---

### M19: Dashboard Data Quality and Space Agent Integration Refinement ✅ Completed
**Goal:** Improve Space Agent detection and clarify dashboard vs Space Agent relationship

**Tasks:**
- Improve Space Agent process detection with multiple patterns
- Update Space Agent panel text to distinguish chat UI from status dashboard
- Research Space Agent local evidence (spaces directory, widget types)
- Update operator guide with "How to Chat" section

**Deliverables:**
- Updated `scripts/gemma-dashboard-build`
- Updated `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- `docs/maintenance/M19_DASHBOARD_SPACE_AGENT_REFINEMENT.md`

**Result:** Space Agent detection is more robust. Dashboard clearly states it does not appear inside Space Agent Spaces. Operator guide includes chat instructions. Space Agent widget research shows no generic HTML embedding mechanism.

**Depends on:** M17

**Do Not:**
- Modify Agent Zero config
- Modify Space Agent config
- Install packages
- Pull models
- Enable autonomy
- Start a daemon or server

---

### M20: Space Agent Provider Reality Check and Documentation Correction ✅ Completed
**Goal:** Correct documentation after user found Space Agent Local LLM panel is a Hugging Face browser loader, not Ollama chat

**Tasks:**
- Document user finding: Local LLM panel expects HF repo IDs with ONNX assets, not Ollama tags
- Correct DASHBOARD_OPERATOR_GUIDE.md: remove incorrect Space Agent chat instructions
- Update dashboard script: change Space Agent panel to "Ollama/Gemma provider path not yet verified"
- Document verified fallback paths: gemma-bazzite, direct Ollama API, gemma-knowledge-rag

**Deliverables:**
- Updated `docs/dashboard/DASHBOARD_OPERATOR_GUIDE.md`
- Updated `scripts/gemma-dashboard-build`
- `docs/maintenance/M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md`

**Result:** Documentation no longer claims Space Agent can chat with local Gemma via Ollama. Verified terminal/API fallbacks are documented. Space Agent remains useful as workspace UI but not as primary Gemma chat interface.

**Depends on:** M19

**Do Not:**
- Modify Space Agent config
- Install packages
- Pull models
- Enable autonomy

---

### M21: Live Local Security Dashboard v1 ✅ Completed
**Goal:** Build a local-only live security dashboard with optional foreground watch mode

**Tasks:**
- Create `scripts/gemma-security-dashboard-build` with 10 security panels
- Add `--watch` foreground watch mode with `--interval` support
- Add `--open` and `--help` flags
- Generate HTML with `<meta refresh>` in watch mode
- Create `docs/dashboard/SECURITY_DASHBOARD_OPERATOR_GUIDE.md`

**Deliverables:**
- `scripts/gemma-security-dashboard-build`
- `docs/dashboard/SECURITY_DASHBOARD_OPERATOR_GUIDE.md`
- `docs/maintenance/M21_LIVE_SECURITY_DASHBOARD.md`

**Result:** Security dashboard operational. Read-only inspection of firewall, USBGuard, ClamAV, Lynis, and security timers. Watch mode runs in foreground only, stops on Ctrl+C. No daemon or server created.

**Depends on:** M20

**Do Not:**
- Modify firewall rules
- Modify USBGuard policy
- Run ClamAV scans
- Run Lynis audits
- Start a daemon or server
- Install packages

---

## Phase 5: Coordination & Integration Planning

### Phase 5A: Repo Bootstrap ✅ Completed
**Goal:** Create coordination repo for full stack

**Tasks:**
- Create `~/projects/gem` repo
- Bootstrap documentation structure
- Create architecture docs
- Create integration plans
- Create inventory system
- Create OpenCode prompts

**Deliverables:**
- Repo initialized
- README, AGENTS.md
- Architecture docs
- Integration plans
- Inventory script
- Prompts for future phases

**Blockers:** None

### Phase 5B: Architecture Expansion ✅ Completed
**Goal:** Define full stack architecture

**Tasks:**
- Document L5-L9 architecture
- Define integration patterns
- Design data flow
- Document security model
- Create capability progression plan

**Deliverables:**
- Full architecture spec
- Integration patterns doc
- Security model doc
- Capability progression guide

**Depends on:** 5A

### Phase 5C: Agent Zero Inventory ✅ Completed
**Goal:** Verify A0 installation and assess integration

**Tasks:**
- Verify Agent Zero installed
- Identify install path
- Check container state
- Identify UI endpoint
- Check version
- Identify A0 CLI connector state
- Identify skills/plugins paths

**Deliverables:**
- A0 installation report
- A0 state inventory
- A0 CLI connector assessment
- Integration approach doc

**Blockers:** None (read-only assessment)

**Do Not:**
- Install Agent Zero
- Start A0 services
- Modify A0 config

### Phase 5D: RuVector Assessment ✅ Completed
**Goal:** Assess RuVector before integration

**Tasks:**
- Review RuVector architecture
- Review Rust/npm/Docker surfaces
- Identify service/daemon requirements
- Identify persistence paths
- Assess self-learning scoping
- Assess local-only operation
- Define local data path options

**Deliverables:**
- RuVector architecture review
- Local-only feasibility assessment
- Integration options doc
- Risk assessment

**Blockers:** None (read-only assessment)

**Do Not:**
- Clone RuVector repo
- Install Rust/npm dependencies
- Start RuVector services

### Phase 5E: Space Agent Assessment ✅ Completed
**Goal:** Assess Space Agent before integration

**Tasks:**
- Research official install source
- Determine Linux/Bazzite compatibility
- Determine browser vs desktop availability
- Determine local inference support
- Determine A0 integration requirements

**Deliverables:**
- Space Agent compatibility report
- Installation requirements doc
- Integration approach options

**Blockers:** None (research only)

**Do Not:**
- Install Space Agent
- Start Space Agent services

### Phase 5F: Integration Design ✅ Completed
**Goal:** Design unified operator layer

**Tasks:**
- Design L5-L7 integration
- Document component interactions
- Define API boundaries
- Create integration test plan
- Document fallback strategies

**Deliverables:**
- Unified operator layer doc
- Component routing matrix
- Data flow and state map
- Autonomy graduation plan
- Phase 6 sandbox plan
- Integration decisions doc

**Depends on:** 5C, 5D, 5E

### Phase 5G: Unified Terminal UI ✅ Completed
**Goal:** Build polished local terminal front door for all Gemma functions

**Tasks:**
- Create `~/.local/bin/gemma-ui` as unified router
- Add `gemma-agent` compatibility alias
- Implement welcome screen with model/status display
- Implement top status bar (mode, Ollama, tools, voice, memory)
- Implement numbered mode selector [1]-[7]
- Implement transcript-style output panels
- Implement consistent footer (/help, /mode, /back, /quit)
- Add risk labels per tool (SAFE, CONFIRM, SUDO)
- Group tool display by category
- Add `--demo-ui` flag for UI preview
- Update config with theme, timestamps, feature flags
- Keep all existing safety gates intact

**Deliverables:**
- `~/.local/bin/gemma-ui` (executable, Python + Rich)
- `~/.local/bin/gemma-agent` (symlink)
- `~/.config/bazzite-security/gemma-ui.json`
- `docs/gemma-ui.md`
- `docs/maintenance/GEMMA_UI_FRONT_DOOR.md`

**Depends on:** 5F

### Phase 5G.1: Voice Mode Regression Closeout ✅ Completed
**Goal:** Fix voice mode interaction and recorder reliability

**Issues Fixed:**
- Enter key alone no longer triggers accidental recording
- `r` and `/r` both trigger recording explicitly
- `pw-record` no longer uses `-d` for duration (PipeWire 1.4.10 does not support it)
- `timeout` controls recording duration; exit code 124 is treated as success
- `pw-record` uses `--rate 16000 --channels 1 --format s16`
- `/quit` exits cleanly

**Safety:**
- Voice mode remains push-to-talk only.
- Voice mode does not bypass confirmation gates.
- No always-listening daemon or wake word is used.

**Deliverables:**
- Updated `~/.local/bin/gemma-voice-chat`
- Updated `~/.local/bin/gemma-ui`
- `docs/maintenance/GEMMA_VOICE_MODE.md`

**Depends on:** 5G

### Phase 5G.2: Supervised Memory Mode ✅ Completed
**Goal:** Wire RuVector Memory Mode into gemma-ui as explicit supervised mode

**Tasks:**
- Add `/memory` subcommands: status, search, ask, stage3a, compare
- Add `--memory-*` CLI flags
- Show RuVector status: supervised secondary only
- Show Stage 3A status: canonical fallback
- Run helpers via subprocess argument arrays (no shell injection)
- Preserve helper-generated reports in canonical locations
- Add memory quality dashboard (`/memory dashboard`, `--memory-dashboard`)
- Add voice-to-memory routing with confirmation gates
- Regression closeout: syntax, UI, query, safety validation

**Safety:**
- RuVector memory mode is explicit and supervised.
- RuVector is not the default retrieval path.
- Stage 3A deterministic retrieval remains the canonical fallback.
- Memory mode performs read-only retrieval/RAG only.
- Memory mode does not ingest new data, train the model, mutate repos, or execute remediation.

**Deliverables:**
- Updated `~/.local/bin/gemma-ui` (v1.4.2)
- `docs/maintenance/GEMMA_UI_MEMORY_MODE.md`
- `docs/maintenance/GEMMA_UI_MEMORY_MODE_REGRESSION.md`
- Updated `docs/gemma-ui.md`
- Updated `docs/live-system/CURRENT_STATE.md`

**Regression:**
- Syntax: `py_compile` pass on gemma-ui and gemma-voice-chat
- UI: `--memory-status`, `--memory-dashboard`, `--dashboard`, `--list-modes` pass
- Queries: `--memory-search`, `--memory-stage3a`, `--memory-compare` pass
- Safety: No ingestion, no default promotion, Stage 3A preserved, no sudo/scans

**Depends on:** 5G.1

## Phase 6: Sandbox Prototypes ⏳ Upcoming

### Phase 6A: Agent Zero Sandbox Readiness ✅ Completed
**Goal:** Read-only sandbox readiness review for Agent Zero

**Tasks:**
- Inspect existing container (read-only)
- Verify config paths and helper scripts
- Check container security posture (caps, read-only, network)
- Review prior docs (M15, integration plan, limitations)
- Document known safe helper paths
- Document known risks and what must not be granted
- No system changes, no containers mutated

**Deliverables:**
- `docs/phase6/PHASE6A_AGENT_ZERO_SANDBOX_READINESS.md`
- Security findings: writable root FS, no cap drop, running as root
- Container IS running (Up 9 hours)
- Hardened script exists but unused
- Direct Ollama route works; tool-protocol incompatible
- Empty agent/skill state

**Security Verdict:**
- ✅ Ready for read-only experimentation
- ⚠️ Hardening recommended before full use
- ❌ Not ready for production security operations

**Depends on:** 5F, M15

### Phase 6B: RuVector Sandbox
**Goal:** Test A0 in isolated environment

**Tasks:**
- Create Distrobox sandbox
- Install A0 in sandbox
- Test A0 CLI connector
- Test agent definitions
- Validate security boundaries

**Deliverables:**
- A0 sandbox test results
- Security validation report
- Integration refinement

**Depends on:** 5C

### Phase 6B: RuVector Sandbox ⏳
**Goal:** Test RuVector in isolated environment

**Tasks:**
- Create sandbox environment
- Install RuVector npm package (user space)
- Test basic vector operations
- Validate local-only operation
- Compare with Stage 3A

**Deliverables:**
- RuVector sandbox test results
- Performance assessment

**Depends on:** 5F

### Phase 6C: Space Agent Sandbox ⏳
**Goal:** Test Space Agent in isolated environment

**Tasks:**
- Download AppImage to temp
- Test launch (don't leave running)
- Identify config/state paths
- Verify local inference options

**Deliverables:**
- Space Agent test results
- Compatibility report

**Depends on:** 5F

### Phase 6D: Integration Smoke ⏳
**Goal:** Verify L5-L7 components can coexist

**Tasks:**
- Check component coexistence
- Verify no port conflicts
- Verify no path conflicts
- Confirm fallback chain works

**Deliverables:**
- Integration smoke report
- Proceed/Do not proceed decision

**Depends on:** 6A, 6B, 6C

## Phase 7: Local Ops Bridge

### Phase 7A: L5 Integration ✅ Completed
**Goal:** Integrate Agent Zero

**Tasks:**
- Install A0 (if not present)
- Configure A0 CLI connector
- Define OpenCode-A0 bridge
- Test agent spawning
- Validate sandboxing

**Deliverables:**
- A0 integration operational
- OpenCode-A0 bridge working
- Security validation complete
- `docs/integrations/agent-zero/AGENT_ZERO_PHASE7A2_REPORT.md`
- `docs/integrations/agent-zero/AGENT_ZERO_PHASE7A3_SMOKE_TEST.md`

**Result:** A0 CLI v1.5 installed user-locally at ~/.local/bin/a0. Connector works. Smoke test passed. Agent Zero stopped at end. No autonomous tasks.

**Depends on:** 6A

### Phase 7B: L6 Scoped Memory Prototype ✅ Completed
**Goal:** Validate RuVector as a scoped memory prototype before production semantic retrieval

**Tasks:**
- Install `ruvector` v0.2.25 in a repo-local prototype
- Configure local prototype data paths
- Index approved knowledge docs only
- Test placeholder-vector query flow
- Compare with Stage 3A fallback
- Validate scoping

**Deliverables:**
- Prototype indexed 398 chunks from approved docs and Stage 3A chunks
- Persistent output under `~/.local/share/bazzite-security/ruvector/`
- Stage 3A fallback remains canonical
- Readiness decision: `ruvector_memory_prototype_working`

**Not production-ready until:**
- Local embeddings are selected
- Retrieval quality is tested against Stage 4 evals/examples
- Ingestion remains scoped
- Fallback behavior remains intact

### Phase 7B.1: RuVector Local Embedding Strategy ✅ Completed
**Goal:** Design semantic retrieval before implementation

**Tasks:**
- Evaluate local embedding options without downloading models by default
- Assess any existing local embedding model availability
- Compare Ollama embeddings API, local ONNX embeddings, and Stage 3A fallback
- Define retrieval-quality tests using Stage 4 evals/examples

**Deliverables:**
- Embedding strategy report
- Semantic retrieval design
- Go/no-go criteria for production memory

**Result:** `ready_for_semantic_embedding_prototype`

### Phase 7B.2: RuVector Semantic Prototype ✅ Completed
**Goal:** Build scoped semantic retrieval using the already-installed local embedding model

**Tasks:**
- Use `nomic-embed-text:latest` through local Ollama embeddings
- Keep ingestion scoped to approved docs/chunks
- Compare semantic results against Stage 3A and Stage 4 cases/examples
- Preserve Stage 3A fallback

**Deliverables:**
- Semantic prototype report
- Retrieval quality comparison
- Go/no-go decision for production memory

**Result:** `semantic_prototype_working`

**Production status:** prototype only; keep Stage 3A fallback until stricter quality gates pass.

**Depends on:** 6B

### Phase 7C: Space Agent Workspace And Provider Assessment ✅ Completed
**Goal:** Assess Space Agent workspace/provider settings without repo-edit integration

**Tasks:**
- Inspect running AppImage process and config metadata safely
- Document Gemini native OpenAI-compatible settings
- Document local Ollama/Gemma settings
- Preserve manual-only workspace boundary
- Avoid repo editing and broad filesystem access

**Deliverables:**
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7C_WORKSPACE_AND_MODELS_REPORT.md`
- `docs/integrations/space-agent/SPACE_AGENT_INTEGRATION_PLAN.md`
- Readiness decision: `space_agent_needs_manual_model_test`

### Phase 7C.1: Space Agent Manual Provider Verification ✅ Completed
**Goal:** Manually verify provider settings in the Space Agent UI without exposing secrets

**Tasks:**
- User enters provider secrets manually in UI
- Test Gemini native endpoint with `gemini-2.5-pro` or `gemini-2.5-flash`
- Test local Ollama endpoint with `gemma4-e4b-bazzite:latest`
- Keep Space Agent manual-only and no repo editing

**Deliverables:**
- Manual provider verification report
- Provider readiness decision

**Result:** `space_agent_manual_confirmation_needed`

**Remaining manual item:** record the exact non-secret Space Agent UI provider result once the user confirms which provider/model responded successfully.

**Depends on:** 6C

### Phase 7D: Unified Local Ops Smoke Test ✅ Completed
**Goal:** Verify Phase 7 components coexist without enabling autonomous production workflows

**Tasks:**
- Verify Stage 3A fallback and Stage 4 validators
- Verify RuVector semantic prototype queries
- Verify Ollama endpoints and tiny embedding health
- Verify A0 connector endpoint and stop Agent Zero afterward
- Verify Space Agent process/config metadata only
- Check obvious port conflicts

**Deliverables:**
- `docs/integrations/PHASE7D_UNIFIED_SMOKE_TEST.md`
- Future prompts for Phase 7E, 8A, and 8B
- Readiness decision: `phase7_smoke_passed_with_manual_space_agent_confirmation_pending`

### Phase 7E: Space Agent Provider And Local-Agent Finalization ✅ Completed
**Goal:** Record verified Space Agent provider state and investigate local-agent configuration options without editing Space Agent config

**Tasks:**
- Record OpenRouter working endpoint/model without secrets
- Document Gemini and local Gemma/Ollama UI failures without secrets
- Test local Ollama OpenAI-compatible endpoints outside Space Agent
- Inspect Space Agent process/config metadata safely
- Investigate `~/conf/onscreen-agent.yaml`, Hugging Face, WebLLM, OpenRouter, and Space Agent skill/customware source references

**Deliverables:**
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E_PROVIDER_AND_LOCAL_AGENT_REPORT.md`
- `prompts/opencode/phase7e1-space-agent-local-gemma-retry.prompt.txt`
- Readiness decision: `space_agent_local_gemma_endpoint_candidate_found`

**Result:** OpenRouter works in Space Agent. Local Ollama OpenAI-compatible endpoints work outside Space Agent, so local Gemma has a corrected manual retry candidate. `~/conf/onscreen-agent.yaml` is real Space Agent user app-file config, but this repo must not create or edit it directly.

### Phase 7E.1: Space Agent Provider Finalization ✅ Completed
**Goal:** Close the manual Space Agent provider verification loop without exposing secrets or editing Space Agent config

**Tasks:**
- Record OpenRouter working in Space Agent
- Record local Gemma/Ollama working in Space Agent with the exact Ollama OpenAI-compatible model ID
- Keep Gemini documented as optional unresolved retry
- Preserve manual-only Space Agent workspace boundary

**Deliverables:**
- `docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`
- Updated `docs/integrations/space-agent/SPACE_AGENT_INTEGRATION_PLAN.md`
- Updated `prompts/opencode/phase8a-agent-zero-workflow-library.prompt.txt`
- Readiness decision: `space_agent_openrouter_and_local_gemma_working`

**Result:** OpenRouter and local Gemma/Ollama work in Space Agent. Local Gemma uses endpoint `http://127.0.0.1:11434/v1/chat/completions`, model `gemma4-e4b-bazzite:latest`, and API key placeholder `ollama`. Gemini remains optional unresolved retry with `https://generativelanguage.googleapis.com/v1beta/openai/chat/completions` and `gemini-2.5-flash` or `gemini-2.5-pro`.

## Phase 8: Operator Workflows

### Phase 8A: L5 Workflows ✅ Completed
**Goal:** Build Agent Zero workflow library for future supervised L5 workflows

**Tasks:**
- Define safe Agent Zero workflow categories
- Create workflow boundaries document
- Create workflow checklist
- Create reusable workflow template
- Define routing rules through existing components

**Deliverables:**
- `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_LIBRARY.md`
- `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_BOUNDARIES.md`
- `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_CHECKLIST.md`
- `docs/workflows/templates/agent-zero-workflow-template.md`
- `prompts/opencode/phase8a1-agent-zero-readonly-repo-briefing-workflow.prompt.txt`
- `prompts/opencode/phase8a2-agent-zero-validation-orchestration-workflow.prompt.txt`

**Result:** Workflow library created. Workflows are documentation-only, bounded, explicit. No Agent Zero execution, no autonomous production use enabled.

### Phase 8A.1: Agent Zero Read-Only Repo Briefing Workflow ✅ Completed
**Goal:** Implement first Agent Zero workflow for read-only repo briefings

**Tasks:**
- Define repo briefing workflow
- Specify allowed tools (Gemma, Stage 3A, OpenCode read-only)
- Document forbidden actions
- Create workflow implementation docs

**Deliverables:**
- `docs/workflows/agent-zero/WORKFLOW_8A1_REPO_BRIEFING.md`
- `docs/workflows/templates/repo-briefing-output-template.md`

**Result:** Workflow defined with approved paths, denied paths, execution steps, validation, stop conditions, and human approval points. Documentation-only, no Agent Zero runtime execution.

**Depends on:** 8A

### Phase 8A.2: Agent Zero Validation Orchestration Workflow ✅ Completed
**Goal:** Define validation orchestration workflow for Stage 4 checks

**Tasks:**
- Define validation orchestration logic
- Specify validator types (gemma-evals-check, lsp_diagnostics)
- Document failure handling (report to human, no auto-fix)
- Create workflow implementation docs

**Deliverables:**
- `docs/workflows/agent-zero/WORKFLOW_8A2_VALIDATION_ORCHESTRATION.md`
- `docs/workflows/templates/validation-summary-output-template.md`

**Result:** Workflow defined with validation categories, failure handling, stop conditions, and human approval points. Documentation-only, no Agent Zero runtime execution, no autonomous fixes.

**Depends on:** 8A

### Phase 8B: L6 Workflows ✅ Completed
**Goal:** Operational memory workflows

**Tasks:**
- Define memory workflows using RuVector prototype
- Create memory templates
- Document memory hygiene
- Ensure Stage 3A fallback preserved

**Deliverables:**
- `docs/workflows/memory/MEMORY_WORKFLOW_LIBRARY.md`
- `docs/workflows/memory/MEMORY_BOUNDARIES.md`
- `docs/workflows/memory/MEMORY_SOURCE_POLICY.md`
- `docs/workflows/memory/MEMORY_QUALITY_GATES.md`
- `docs/workflows/templates/memory-query-output-template.md`
- `docs/workflows/templates/memory-ingestion-review-template.md`
- `prompts/opencode/phase8b-memory-workflow-library.prompt.txt`
- `prompts/opencode/phase8b1-memory-query-workflow.prompt.txt`
- `prompts/opencode/phase8b2-memory-ingestion-review-workflow.prompt.txt`
- `prompts/opencode/phase8b3-memory-quality-gates.prompt.txt`

**Result:** Memory workflow library created. RuVector remains prototype-only. Stage 3A is fallback. No production memory promotion. Human approval required for all ingestion.

**Depends on:** 7B.2

### Phase 8B.1: Memory Query Workflow ✅ Completed
**Goal:** Implement first memory workflow for semantic context lookup with mandatory Stage 3A comparison

**Tasks:**
- Define query workflow with RuVector + Stage 3A comparison
- Create execution steps
- Include output template
- Define comparison criteria and quality labels
- Define stop conditions and human approval points

**Deliverables:**
- `docs/workflows/memory/WORKFLOW_8B1_MEMORY_QUERY.md`
- `docs/workflows/memory/MEMORY_QUERY_CHECKLIST.md`

**Result:** Workflow defined with all required sections: purpose, inputs, approved/denied paths, Stage 3A comparison logic, agreement/disagreement handling, source relevance criteria, quality labels (7 types), stop conditions (10 conditions), human approval points, and expected output format. Documentation-only; no RuVector query execution; Stage 3A fallback required.

**Depends on:** 8B

### Phase 8B.2: Memory Ingestion Review Workflow ✅ Completed
**Goal:** Define ingestion proposal and approval flow

**Tasks:**
- Define source classification (A/B/C/D)
- Create approval flow with denied-data check
- Define manifest requirements
- Define rollback requirements
- Include review template

**Deliverables:**
- `docs/workflows/memory/WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md`
- `docs/workflows/memory/MEMORY_INGESTION_REVIEW_CHECKLIST.md`

**Result:** Workflow defined with all required sections: source classes A/B/C/D, ingestion proposal flow (12 steps), denied-data checks (9 categories), manifest requirements (12 fields), rollback requirements (6 items), stop conditions (12 conditions), human approval points (8 points), and expected output format. Documentation-only; no memory ingestion; human approval required for all future ingestion.

**Depends on:** 8B

### Phase 8B.3: Memory Quality Validation ✅ Completed
**Goal:** Document quality gate validation

**Tasks:**
- Document all 8 quality gates (Gate 1-8, Gate 5 skipped in numbering)
- Define validation methods per gate
- Define pass/fail criteria
- Define failure handling (5 categories)
- Create production promotion checklist
- Create future prompts for 8B.4, 8B.5, 8C

**Deliverables:**
- `docs/workflows/memory/WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md`
- `docs/workflows/memory/MEMORY_QUALITY_VALIDATION_CHECKLIST.md`
- `docs/workflows/templates/memory-quality-validation-output-template.md`
- `prompts/opencode/phase8b4-memory-quality-dry-run.prompt.txt`
- `prompts/opencode/phase8b5-memory-production-promotion-review.prompt.txt`
- `prompts/opencode/phase8c-space-agent-workspace-workflow-library.prompt.txt`

**Result:** Workflow defined with all 8 gates (Gate 1: Stage 3A comparison, Gate 2: Stage 4 validators, Gate 3: Semantic quality, Gate 4: Source spot-check, Gate 5: Answer quality, Gate 6: Manifest metadata, Gate 7: Rollback path, Gate 8: Stale memory review). Failure handling defines 5 categories (blocking failure, warning, environment unavailable, skipped by boundary, skipped by user instruction). Documentation-only; no quality validation execution; no production memory promotion.

**Depends on:** 8B

### Phase 8B.4: Memory Quality Dry-Run ✅ Completed
**Goal:** Run bounded dry-run quality validation against existing prototype only.

**Tasks:**
- Run Gate 2 validators (gemma-evals-status, gemma-evals-check, gemma-examples-check) → ✅ PASS
- Run Gate 6 manifest check (semantic-manifest-*.json) → ⚠️ WARNING (used wrong manifest — see 8B.4A)
- Run limited Gate 1 (5 sample queries comparing RuVector vs Stage 3A) → ⚠️ WARNING (avg 69.25% overlap, only 20% ≥70%)
- Do NOT run full Gate 3 (10+ queries), Gate 4 (10 spot-checks), or Gate 5 (answer generation)
- Generate dry-run report to ~/offload/security-reports/manual/

**Deliverables:**
- Dry-run report: `~/offload/security-reports/manual/ruvector-memory-quality-dry-run-20260501-011559.md`
- Repo-local summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4_QUALITY_DRY_RUN_SUMMARY.md`

**Result:** Dry-run passed with warnings. Gate 2 ✅ PASS (all Stage 4 validators). Gate 6 ⚠️ (original check used 25-chunk manifest — corrected in 8B.4A). Gate 1 ⚠️ WARNING (5 limited queries: avg similarity 69.25%, only 20% meet ≥70% overlap). RuVector prototype remains prototype-only. No promotion.

**Depends on:** 8B.3

### Phase 8B.4A: Memory Quality Dry-Run Follow-up Audit ✅ Completed
**Goal:** Audit Phase 8B.4 findings — correct Gate 6 manifest check (chunkCount=25 vs 398), re-check Gate 1 weak-overlap queries.

**Tasks:**
- Audit all semantic-manifest-*.json files (found 3: 25, 100, 398 chunks)
- Identify current manifest: `semantic-manifest-1777588824357.json` (398 chunks, latest by timestamp)
- Correct Gate 6: original check used oldest manifest (25 chunks) → ✅ PASS with correct manifest (398 chunks)
- Re-check Gate 1 weak-overlap: `FINAL_POLICY.md` dominates RuVector vs Stage 3A operational docs → ⚠️ WARNING (unchanged)
- Audit `semantic-approved-docs-memory.json` structure (wrapper dict with `"chunks"` key, 398 items)
- Audit embeddings cache: 388 entries (97.5% of 398 chunks)
- Generate addendum report to ~/offload/security-reports/manual/
- Create repo-local addendum summary

**Deliverables:**
- Addendum report: `~/offload/security-reports/manual/ruvector-memory-quality-dry-run-addendum-20260501-012653.md`
- Repo-local summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4A_DRY_RUN_ADDENDUM_SUMMARY.md`

**Result:** Gate 6 corrected to ✅ PASS (all required fields present, chunkCount=398 matches expected). Root cause: Phase 8B.4 used `head -1` on glob results, returning oldest 25-chunk manifest instead of latest 398-chunk manifest. Gate 1 weak-overlap ⚠️ unchanged (`FINAL_POLICY.md` dominance). Phase 8B.5 promotion remains 🚫 BLOCKED (Gate 1 unresolved).

**Depends on:** 8B.4

### Phase 8B.4B: Gate 1 Retrieval Diagnostics ✅ Completed
**Goal:** Investigate why FINAL_POLICY.md dominates RuVector semantic search results while Stage 3A returns different sources.

**Tasks:**
- Inspect RuVector query implementation (cosine similarity, chunk-level results, no deduplication)
- Inspect semantic memory metadata (398 chunks, 7 sources, FINAL_POLICY.md: 78 chunks)
- Run 7 focused diagnostic queries comparing RuVector vs Stage 3A
- Investigate FINAL_POLICY.md content for relevant answers
- Produce diagnostic report with root cause analysis

**Deliverables:**
- Diagnostic report: `~/offload/security-reports/manual/ruvector-gate1-retrieval-diagnostics-20260501-013702.md`
- Repo-local summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4B_GATE1_DIAGNOSTICS_SUMMARY.md`

**Result:** FINAL_POLICY.md dominance is NOT A BUG — it's the actual canonical source for policy-type queries (contains "firewalld for host firewall management"). RuVector returns correct answers. Gate 1 filename-overlap metric is too strict — should allow source-family equivalence (policy ↔ operational ↔ advisory). Recommendation: revise Gate 1 metric before re-running full validation.

**Depends on:** 8B.4A

### Phase 8B.4C: Gate 1 Metric Revision ✅ Completed
**Goal:** Revise Gate 1 memory-quality metric to incorporate source-family equivalence and content relevance, based on Phase 8B.4B diagnostic finding that FINAL_POLICY.md dominance is not a retrieval bug.

**Tasks:**
- Create source-family equivalence definitions (Policy/Operational/Advisory/Stage3A)
- Revise Gate 1 in MEMORY_QUALITY_GATES.md to use tiered metric (exact overlap + equivalence + source authority)
- Update WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md with source equivalence calculation
- Update MEMORY_QUALITY_VALIDATION_CHECKLIST.md with new checklist items
- Update memory-quality-validation-output-template.md with new output fields
- Create GATE1_SOURCE_EQUIVALENCE_METRIC.md specification
- Create future prompt phase8b4d-full-memory-quality-validation.prompt.txt

**Deliverables:**
- Gate 1 metric spec: `docs/workflows/memory/GATE1_SOURCE_EQUIVALENCE_METRIC.md`
- Future validation prompt: `prompts/opencode/phase8b4d-full-memory-quality-validation.prompt.txt`

**Result:** Gate 1 metric revised to allow source-family equivalence. Final_POLICY.md dominance is NOT a bug — it's correct canonical source for policy queries. Metric now considers: exact filename overlap, source-family equivalence, content relevance, source authority. Pass if ≥70% exact OR ≥70% equivalence + no contradictions. RuVector remains prototype-only.

**Depends on:** 8B.4B

### Phase 8B.4D: Full Memory Quality Validation ✅ Completed
**Goal:** Run full Gate 1-6 validation using revised source-equivalence metric. Produce real validation evidence for RuVector semantic retrieval quality.

**Tasks:**
- Confirm prototype state (398 chunks, nomic-embed-text, 768 dimensions)
- Run Gate 2 Stage 4 validators (gemma-evals-status, gemma-evals-check, gemma-examples-check)
- Run Gate 1 revised comparison with 12 queries comparing RuVector vs Stage 3A
- Run Gate 3 semantic retrieval quality (10 queries, evaluate relevance)
- Run Gate 4 source spot-check (10 queries, manual inspection of top 3)
- Run Gate 6 manifest verification (check chunkCount, model, dimensions)
- Prepare Gate 5 (not execute - requires human approval)
- Create full validation report and repo-local summary

**Deliverables:**
- Full report: `~/offload/security-reports/manual/ruvector-full-quality-validation-20260430-214900.md`
- Repo-local summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4D_FULL_QUALITY_VALIDATION_SUMMARY.md`

**Results:**
- Gate 1: PASS (75% pass rate using revised source-equivalence metric)
- Gate 2: PASS (all 3 validators pass with 0 errors)
- Gate 3: PASS (10/10 queries with relevant sources in top 5)
- Gate 4: PASS (10/10 top-3 results relevant)
- Gate 5: NOT EXECUTED (requires human approval before running answer generation)
- Gate 6: PASS (398 chunks, nomic-embed-text, 768 dimensions)

**Decision:** `full_validation_passed_with_warnings_no_promotion`
- Production promotion BLOCKED (Gate 5 not executed)
- Phase 8B.5 remains BLOCKED until Gate 5 executed with human approval

**Depends on:** 8B.4C

### Phase 8B.4E: Gate 5 Answer Quality Validation ✅ Completed
**Goal:** Validate whether Gemma answer generation using RuVector context is equal to or better than Gemma answer generation using Stage 3A context.

**Tasks:**
- Confirm model availability (gemma4-e4b-bazzite:latest, Ollama API ready)
- Run Gate 2 health validators (gemma-evals-status, gemma-evals-check, gemma-examples-check)
- Run Gate 5 answer comparison (5 bounded questions)
- Create full Gate 5 report and repo-local summary

**Deliverables:**
- Full report: `~/offload/security-reports/manual/ruvector-gate5-answer-quality-validation-20260430-215500.md`
- Repo-local summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B4E_GATE5_ANSWER_QUALITY_SUMMARY.md`

**Results:**
- Gate 2: PASS (all 3 validators pass with 0 errors)
- Gate 5: PASS (3 ruvector_better + 2 equivalent = 5/5 pass rate)
- **All 6 gates now pass:** Gate 1:PASS, 2:PASS, 3:PASS, 4:PASS, 5:PASS, 6:PASS

**Model & Options:**
- Model: `gemma4-e4b-bazzite:latest`
- Max tokens: 180
- Temperature: 0.3 (default)
- Timeout: 90s per answer
- Endpoint: Local Ollama (127.0.0.1:11434)

**Decision:** `gate5_pass`
- Production promotion **AUTHORIZED** (all gates pass)
- Phase 8B.5 **READY FOR REVIEW** (all gates pass, human approval still required)

**Depends on:** 8B.4D

### Phase 8B.5: Memory Production Promotion Review ✅ Completed
**Goal:** Review all gate evidence and decide RuVector promotion level. Documentation and decision only — no automatic promotion.

**Tasks:**
- Review all gate evidence (Gates 1-6)
- Review Gate 7 rollback/reset readiness
- Review Gate 8 stale-memory readiness
- Decide promotion-review status
- Create promotion review report and repo-local summary

**Deliverables:**
- Full report: `~/offload/security-reports/manual/ruvector-production-promotion-review-20260430-220000.md`
- Repo-local summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md`

**Results:**
- **Gate 1:** PASS (75% pass rate, revised metric)
- **Gate 2:** PASS (all 3 validators pass)
- **Gate 3:** PASS (10/10 relevant)
- **Gate 4:** PASS (10/10 relevant)
- **Gate 5:** PASS (5/5 ruvector_better/equivalent)
- **Gate 6:** PASS (398 chunks, manifest valid)
- **Gate 7:** DOCUMENTED (rollback plan exists)
- **Gate 8:** NOT REQUIRED (fresh index, < 1 hour)

**Final Decision:** `promotion_review_approved_secondary`
- **RuVector Level:** `approved_secondary_retrieval_source`
- **Stage 3A:** Remains canonical fallback
- **Wrapper Defaults:** Unchanged (Stage 3A is default)
- **Production Promotion:** ❌ NOT EXECUTED (requires explicit human approval)

**Approved Scope:**
- ✅ Supervised secondary retrieval (when explicitly requested)
- ✅ Stage 3A remains default
- ✅ No wrapper changes
- ❌ No autonomous memory/learning
- ❌ No replacement of Stage 3A

**Next Phase Options:**
- Phase 9: Planning ✅ Complete (2026-05-02)
- Phase 10: Controlled Ingestion Dry-Run Planning ✅ Complete (2026-05-02)
- Phase 11: Classification Fix ⏳ Recommended

**Depends on:** 8B.4E (Gate 5 must pass)

### Phase 8B.6: Primary Supervised RuVector Search ✅ Completed
**Goal:** Create `gemma-memory-search` helper with RuVector as PRIMARY supervised retrieval and Stage 3A as DETERMINISTIC FALLBACK.

**Tasks:**
- Create `~/.local/bin/gemma-memory-search` Python helper (stdlib only)
- RuVector semantic search (nomic-embed-text:latest, 768d, 398 chunks)
- Stage 3A deterministic fallback via `gemma-knowledge-search`
- Write comparison report to `~/offload/security-reports/manual/`
- Validate with 4 test queries
- Create workflow documentation
- Update roadmap

**Deliverables:**
- Helper: `~/.local/bin/gemma-memory-search` (executable, Python 3 stdlib)
- Summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B6_PRIMARY_SUPERVISED_HELPER_SUMMARY.md`
- Workflow: `docs/workflows/memory/WORKFLOW_8B6_PRIMARY_SUPERVISED_RUVECTOR_SEARCH.md`
- Reports: `~/offload/security-reports/manual/gemma-memory-search-*.md`
- Logs: `~/.local/state/bazzite-security/logs/gemma-memory-search-*.log`

**Results:**
- Syntax check: ✅ PASS
- Test queries (4/4): ✅ PASS
- gemma-evals-check: ✅ PASS (all 19 cases)
- Git status: ✅ PASS (no unintended modifications)

**Key Decisions:**
- RuVector: PRIMARY supervised retrieval (not default, not autonomous)
- Stage 3A: DETERMINISTIC FALLBACK (unchanged as canonical default)
- Wrapper defaults: Unchanged — this is a NEW helper, not a replacement
- Production promotion: ❌ NOT approved (remains `approved_secondary_retrieval_source`)

**Next Phase Options:**
- Phase 8B.7: Supervised RAG Integration ⏳ Upcoming (optional)
- Phase 8D.1: Workflow Index Verification ⏳ Future
- Phase 9: Planning ✅ Complete (2026-05-02)
- Phase 10: Controlled Ingestion Dry-Run Planning ✅ Complete (2026-05-02, WARN)

**Depends on:** 8B.5

### Phase 8B.6A: gemma-memory-search Hardening ✅ Completed
**Goal:** Harden `gemma-memory-search` so Phase 8B.6 fully implements supervised primary RuVector retrieval with deterministic Stage 3A comparison and final recommendation logic.

**Tasks:**
- Add source-family classification (Policy, Operational, Advisory/OpenCode, Stage 3A, Unknown)
- Parse Stage 3A output into rank, score, source, heading, and excerpt where possible
- Calculate exact filename overlap and source-family/content equivalence
- Add source authority, uncertainty, contradiction, and fallback status notes
- Add final recommendation logic
- Keep Stage 3A as fallback/comparison baseline
- Preserve existing `gemma-knowledge-search` and `gemma-knowledge-rag` behavior

**Deliverables:**
- Hardened helper: `~/.local/bin/gemma-memory-search`
- Updated summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B6_PRIMARY_SUPERVISED_HELPER_SUMMARY.md`
- Updated workflow: `docs/workflows/memory/WORKFLOW_8B6_PRIMARY_SUPERVISED_RUVECTOR_SEARCH.md`
- Updated reports: `~/offload/security-reports/manual/gemma-memory-search-*.md`

**Results:**
- Helper now prints final recommendation in terminal output
- Reports include final recommendation, fallback status, source-family classifications, source authority notes, Stage 3A parsed comparison, and boundaries preserved
- No ingestion, indexing, wrapper default replacement, or autonomous memory/learning occurred

**Depends on:** 8B.6

### Phase 8B.6B: gemma-memory-search Answerability Calibration ✅ Completed
**Goal:** Calibrate `gemma-memory-search` so source-family relevance does not become overconfident recommendation when retrieved excerpts are only generic headers or weak context.

**Tasks:**
- Add deterministic answerability/direct-evidence checks after source-family classification
- Classify each top result as `direct_answer`, `supporting_context`, `weak_context`, `generic_header_only`, or `unrelated_or_unclear`
- Add query intent hints for firewall/security policy, path/report/log, OpenCode/Gemma boundary, and production/status queries
- Add direct evidence counts for RuVector and Stage 3A
- Add recommendation confidence buckets: `high`, `medium`, `low`, `blocked`
- Downgrade recommendations when retrieved excerpts are weak, generic, or not directly answerable
- Preserve Stage 3A as deterministic fallback/comparison baseline

**Deliverables:**
- Calibrated helper: `~/.local/bin/gemma-memory-search`
- Updated summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B6_PRIMARY_SUPERVISED_HELPER_SUMMARY.md`
- Updated workflow: `docs/workflows/memory/WORKFLOW_8B6_PRIMARY_SUPERVISED_RUVECTOR_SEARCH.md`
- Updated reports: `~/offload/security-reports/manual/gemma-memory-search-*.md`

**Results:**
- Terminal output includes answerability status, direct evidence counts, confidence, final recommendation, report path, and log path
- Reports include answerability sections, per-result answerability classification, direct evidence counts, recommendation confidence, downgrade reason, fallback status, and boundaries preserved
- Production/status query no longer returns overconfident `use_ruvector_context` unless direct status evidence appears
- No ingestion, indexing, wrapper default replacement, or autonomous memory/learning occurred

**Depends on:** 8B.6A

### Phase 8B.7: Supervised RuVector RAG Integration ✅ Completed
**Goal:** Create a new supervised RAG helper that uses RuVector retrieval as the primary context source, Stage 3A as fallback/comparison baseline, and local Gemma only for bounded answer generation.

**Tasks:**
- Create `~/.local/bin/gemma-memory-rag` Python helper (stdlib only)
- Use `gemma-memory-search` logic for retrieval and answerability calibration
- Use RuVector context as primary only when recommendation and confidence support it
- Use Stage 3A context as fallback
- Call local Ollama HTTP API (`gemma4-e4b-bazzite:latest`)
- Write reports to `~/offload/security-reports/manual/`
- Preserve existing wrappers and Stage 3A as global fallback
- Validate with 5 test queries

**Deliverables:**
- Helper: `~/.local/bin/gemma-memory-rag` (executable, Python 3 stdlib)
- Summary: `docs/integrations/ruvector/RUVECTOR_PHASE8B7_SUPERVISED_RAG_SUMMARY.md`
- Workflow: `docs/workflows/memory/WORKFLOW_8B7_SUPERVISED_RUVECTOR_RAG.md`
- Reports: `~/offload/security-reports/manual/gemma-memory-rag-*.md`
- Logs: `~/.local/state/bazzite-security/logs/gemma-memory-rag-*.log`

**Results:**
- Syntax check: ✅ PASS
- Test queries (5/5): ✅ PASS
- gemma-evals-check: ✅ PASS
- gemma-evals-status: ✅ PASS
- gemma-examples-check: ✅ PASS

**Key Decisions:**
- RuVector is primary for supervised RAG when explicitly invoked.
- Stage 3A remains the deterministic fallback/comparison baseline.
- Existing wrapper behavior unchanged.
- No autonomous memory/learning enabled.

**Depends on:** 8B.6B

### Phase 8B.7A: RAG Context Extraction Fix ⏳ Upcoming
**Goal:** Fix `gemma-memory-rag` so Ollama receives full excerpts (not truncated table excerpts) from `gemma-memory-search` reports.

**Tasks:**
- Fix `extract_tables_from_report()` to extract full excerpts from report sections (not markdown table)
- Alternatively, have `gemma-memory-search` output a parseable machine-readable context block
- Alternatively, pass `gemma-memory-search` stdout (full excerpts) directly to Ollama prompt
- Validate fix with "What paths are approved for Gemma knowledge docs?" query
- Expect: answer includes `~/.local/share/bazzite-security/gemma-knowledge/docs/`
- Update `docs/integrations/ruvector/RUVECTOR_PHASE8B7_SUPERVISED_RAG_SUMMARY.md`
- Update `docs/workflows/memory/WORKFLOW_8B7_SUPERVISED_RUVECTOR_RAG.md`

**Depends on:** 8B.7

### Phase 8B.7A: RAG Context Extraction Fix ✅ Completed
**Goal:** Fix `gemma-memory-rag` so Ollama receives full excerpts (not truncated table excerpts) from `gemma-memory-search` reports.

**Tasks:**
- Fix `extract_tables_from_report()` to extract full excerpts from report sections (not markdown table)
- Alternatively, have `gemma-memory-search` output a parseable machine-readable context block
- Alternatively, pass `gemma-memory-search` stdout (full excerpts) directly to Ollama prompt
- Validate fix with "What paths are approved for Gemma knowledge docs?" query
- Expect: answer includes `~/.local/share/bazzite-security/gemma-knowledge/docs/`
- Update `docs/integrations/ruvector/RUVECTOR_PHASE8B7_SUPERVISED_RAG_SUMMARY.md`
- Update `docs/workflows/memory/WORKFLOW_8B7_SUPERVISED_RUVECTOR_RAG.md`

**Deliverables:**
- Fixed helper: `~/.local/bin/gemma-memory-rag` (TOP_N=4, CHARS_PER_CHUNK=1800)
- Updated docs: RUVECTOR_PHASE8B7_SUPERVISED_RAG_SUMMARY.md, WORKFLOW_8B7_SUPERVISED_RUVECTOR_RAG.md

**Results:**
- Query "What paths are approved for Gemma knowledge docs?" -> Answer: `~/.local/share/bazzite-security/gemma-knowledge/docs/` ✅
- Query "What firewall tool does Bazzite use?" -> Answer: `firewalld` ✅
- Validators: all PASS

**Depends on:** 8B.7

### Phase 8C: Space Agent Workspace Workflow Library ✅ Completed
**Goal:** Define L7 manual UI/workspace layer workflows for Space Agent.

**Tasks:**
- Define 5 L7 workspace workflow categories (Task Definition, Provider/Model Config, State Inspection, Manual Task Execution, Workspace Reporting)
- Create workspace templates (task reports, provider config notes)
- Create workspace checklist (approved paths, denied paths, no autonomous tasks)
- Preserve manual-only Space Agent role
- No repo edits, no `~/conf/onscreen-agent.yaml` modifications

**Deliverables:**
- `docs/workflows/space-agent/WORKSPACE_WORKFLOW_LIBRARY.md` (5 L7 workflows)
- `docs/workflows/space-agent/WORKSPACE_CHECKLIST.md` (comprehensive checklist)
- `docs/workflows/templates/space-agent-workspace-template.md` (report template)
- `prompts/opencode/phase8c-space-agent-workspace-workflow-library.prompt.txt`

**Result:** Workflow library defined with 5 L7 manual-only workflows: (1) Workspace Task Definition, (2) Provider/Model Configuration (manual only), (3) Workspace State Inspection (read-only), (4) Manual Task Execution (no autonomous tasks), (5) Workspace Reporting (output to `~/offload/security-reports/manual/`). All workflows are L7 (manual UI only). Space Agent has NO `~/projects/gem` repo edit access. `~/conf/onscreen-agent.yaml` NOT created or edited by repo. Documentation-only; no autonomous tasks; no config changes.

**Depends on:** 7E.1

### Phase 8D: Workflow Library Closeout ✅ Completed
**Goal:** Master index, closeout docs, boundary matrix, next phase guide.

**Tasks:**
- Create master workflow index (L5/L6/L7)
- Create Phase 8 closeout doc (all sub-phases summarized)
- Create workflow boundary matrix (allowed/forbidden actions)
- Create next phase decision guide (how to choose 8B.4 vs 8B.5 vs 9)
- Create future prompts (8D.1, 9 planning)
- Update integration decisions

**Deliverables:**
- `docs/workflows/WORKFLOW_LIBRARY_INDEX.md`
- `docs/workflows/PHASE8_WORKFLOW_CLOSEOUT.md`
- `docs/workflows/WORKFLOW_BOUNDARY_MATRIX.md`
- `docs/workflows/NEXT_PHASE_DECISION_GUIDE.md`
- `prompts/opencode/phase8d1-workflow-index-verification.prompt.txt`
- `prompts/opencode/phase9-planning.prompt.txt`

**Result:** All Phase 8 workflow libraries (8A/8B/8C) indexed and closed out. Master index created with capability level map (L5 Agent Zero, L6 Memory, L7 Space Agent). Boundary matrix confirms: no workflow execution in Phase 8, all components bounded by human approval. Next phase guide documents: run 8B.4 if testing RuVector quality, do NOT run 8B.5 unless 8B.4 justifies it. Documentation-only; no workflow execution; no autonomy enabled.

**Depends on:** 8A, 8B, 8C

### Phase 8D.1: Workflow Index Verification ✅ Completed
**Goal:** Verify workflow docs, links, templates, and roadmap references for consistency.

**Tasks:**
- Verify all workflow docs exist and links are correct
- Verify all 7 templates exist
- Verify all 5 checklists exist
- Verify roadmap reflects all Phase 8 completions
- Verify architecture docs have workflow references
- Generate verification report to `~/offload/security-reports/manual/`

**Deliverables:**
- Verification report: `~/offload/security-reports/manual/workflow-index-verification-YYYYMMDD-HHMMSS.md`
- Repo-local summary: `docs/workflows/PHASE8D1_WORKFLOW_INDEX_VERIFICATION_SUMMARY.md`

**Results:**
- Required workflow docs checked: 26
- Missing workflow docs: 0
- Stale references updated in workflow index, closeout, next-phase guide, integration decisions, component routing, and data-flow docs
- `gemma-memory-search` smoke test: PASS
- Stage 4 validators: PASS
- Repo hygiene warning: Git repo has 0 tracked files and 124 untracked files

**Recommended Next Step:**
- If reliable diffs are required first: run a human-approved repo hygiene initial commit planning phase
- Otherwise: Phase 8B.7 Supervised RuVector RAG Integration with Stage 3A fallback preserved

**Note:** Documentation-only consistency check. Do NOT run any workflow execution.

**Depends on:** 8D

### Phase 8D.2: Repo Baseline Staging Plan ✅ Completed
**Goal:** Create an explicit-path initial baseline staging plan without staging, committing, or pushing files.

**Tasks:**
- Inspect Git state and current tracked/untracked posture
- Review `.gitignore` and `.gitattributes` posture
- Classify untracked files into recommended-to-track, review-before-tracking, and must-not-track groups
- Run filename/path-only risky-name checks without inspecting secret contents
- Create repo-local staging plan and manual report
- Preserve no-`git add .`, no staging, no commit, no push boundary

**Deliverables:**
- Repo-local plan: `docs/repo/PHASE8D2_REPO_BASELINE_STAGING_PLAN.md`
- Manual report: `~/offload/security-reports/manual/repo-baseline-staging-plan-20260430-231512.md`

**Results:**
- Tracked files: 0
- Untracked files: 125
- `.gitignore`: exists and covers expected generated/runtime classes
- `.gitattributes`: not present
- No filename/path-only risky untracked paths found
- No files staged, committed, or pushed

**Recommended Next Step:**
- Phase 8D.3 Initial Baseline Commit if human approves explicit-path staging
- Otherwise: Phase 8B.7 Supervised RuVector RAG Integration with known diff limitations

**Depends on:** 8D.1

### Phase 8D.3: Initial Baseline Commit and GitHub Remote Setup ✅ Completed
**Goal:** Commit the approved explicit-path repo baseline and push it to a private GitHub repository named `gem`.

**Tasks:**
- Verify GitHub CLI authentication
- Verify `.gitignore` and package-lock reproducibility decision
- Create repo-local Phase 8D.3 summary
- Stage only approved explicit paths; do not run `git add .`
- Run staged risk checks and validators
- Commit the baseline
- Create or connect private GitHub repo `gem`
- Push `main` to GitHub
- Create manual report under `~/offload/security-reports/manual/`

**Deliverables:**
- Repo-local summary: `docs/repo/PHASE8D3_INITIAL_BASELINE_COMMIT.md`
- Manual report: `~/offload/security-reports/manual/repo-initial-baseline-commit-retry-20260430-233405.md`
- Initial baseline commit: `35f2979cb1c1191d5e138a046700b29614d14679`
- Private GitHub repo: `https://github.com/violentwave/gem`

**Boundary Notes:**
- Explicit-path staging only
- No `git add .`
- No runtime outputs, secrets, logs, reports, `~/.local`, `~/.config`, or `~/offload` content committed

**Results:**
- Trailing whitespace normalized in approved tracked text/source files only
- Explicit-path staging used; `git add .` was not used
- `gitleaks dir` scan on staged snapshot passed with no leaks found
- Stage 4 validators passed before baseline commit
- `gemma-memory-search` helper compile/executable check passed
- Baseline pushed to private `origin/main`
- No runtime outputs, secrets, logs, reports, `~/.local`, `~/.config`, or `~/offload` content committed

**Depends on:** 8D.2

### Phase 8E: Final Closeout, Remote Verification & 8B.7 Regression Review ✅ Completed
**Goal:** Verify GitHub remote, confirm Phase 8B.7 helper state, review known RAG regression, and create final Phase 8 closeout report.

**Tasks:**
- Verify local Git and remote state (branch, HEAD, visibility)
- Confirm Phase 8B.7 commit `3f10165` exists locally and remotely
- Verify `gemma-memory-rag` compiles and is executable
- Run lightweight helper checks (firewall query, path query)
- Investigate known 8B.7 regression ("What paths are approved for Gemma knowledge docs?" → MISSING EVIDENCE)
- Run Stage 4 validators (gemma-evals-status, gemma-evals-check, gemma-examples-check)
- Create final closeout report: `~/offload/security-reports/manual/phase8-final-closeout-*.md`
- Create repo-local summary: `docs/PHASE8_FINAL_CLOSEOUT.md`
- Update roadmap with 8E and 8B.7A

**Deliverables:**
- Closeout report: `~/offload/security-reports/manual/phase8-final-closeout-20260501-*.md`
- Repo-local summary: `docs/PHASE8_FINAL_CLOSEOUT.md`
- Updated roadmap: `docs/roadmap/ROADMAP.md` (8E added, 8B.7A noted)

**Results:**
- GitHub remote verified: `violentwave/gem`, private, `main` branch, local HEAD = remote HEAD = `3f10165`
- Phase 8B.7 helper: compiles ✅, executable ✅
- Known regression root cause: `extract_tables_from_report()` extracts truncated table excerpts (~553 chars), not full excerpts from report sections
- Issue type: **Generation issue** (not retrieval or context selection)
- Validators: all PASS (gemma-evals-status, gemma-evals-check, gemma-examples-check)
- Phase 8 status: **Mostly closed**, pending 8B.7A fix

**Depends on:** 8B.7

## Phase 9: Controlled Memory / Training Loop Planning ✅ Complete

**Phase 9 is complete as of 2026-05-02.** No autonomous learning, ingestion, promotion, daemonization, or wrapper-default changes were implemented.

### Phase 9A: Helper Source Reproducibility ✅ Planned
**Goal:** Plan sanitized repo-tracked source templates and user-local install/check flows for `gemma-memory-search` and `gemma-memory-rag`.

**Tasks:**
- define reviewed helper template paths under `helpers/`
- define user-local installer/checker behavior
- require dry-run, checksum comparison, overwrite confirmation
- preserve `~/.local/bin/` as live canonical destination

**Deliverables:**
- `docs/phase9/HELPER_REPRODUCIBILITY_PLAN.md`
- future repo paths: `helpers/gemma-memory-search`, `helpers/gemma-memory-rag`
- future scripts: `scripts/install-gemma-memory-helpers.sh`, `scripts/check-gemma-memory-helpers.sh`

### Phase 9B: Controlled Memory Ingestion Loop ✅ Planned
**Goal:** Plan a human-approved, manifest-backed ingestion loop without enabling ingestion.

**Tasks:**
- define source proposal workflow
- preserve A/B/C/D source classification
- require denied-data scanning before approval
- require rollback/reset plan before ingestion
- preserve Stage 3A fallback and supervised RuVector scope

**Deliverables:**
- `docs/phase9/CONTROLLED_MEMORY_INGESTION_LOOP.md`
- `docs/phase9/MEMORY_SOURCE_PROPOSAL_SCHEMA.md`
- `docs/phase9/MEMORY_DENIED_DATA_SCAN_RULES.md`
- `docs/phase9/MEMORY_MANIFEST_SCHEMA.md`
- `docs/phase9/MEMORY_ROLLBACK_AND_RESET_PLAN.md`

### Phase 9C: Eval Expansion ✅ Planned
**Goal:** Plan additional regression coverage for supervised memory helpers.

**Tasks:**
- expand known-answer coverage for `gemma-memory-search`
- expand known-answer coverage for `gemma-memory-rag`
- cover canonical facts: docs path, firewalld, report/log paths, local-Gemma boundaries, RuVector supervised/prototype status, Stage 3A fallback

**Deliverables:**
- `docs/phase9/EVAL_EXPANSION_PLAN.md`
- recommended fixture path: `tests/fixtures/memory-known-answer-queries.jsonl`

### Phase 9D: RAG Quality Monitoring ✅ Planned
**Goal:** Plan a manual-only quality checker for supervised RAG.

**Tasks:**
- define `gemma-memory-quality-check` scope
- require lightweight query set and Stage 3A comparison
- define PASS/WARN/FAIL reporting
- keep output/report/log paths canonical

**Deliverables:**
- `docs/phase9/RAG_QUALITY_MONITORING_PLAN.md`

### Phase 9E: Future Learning Loop Policy ✅ Planned
**Goal:** Document the policy boundary for any future learning/training phase.

**Tasks:**
- reject autonomous self-training
- reject raw/private data as training input
- require curated examples and RAG/evals first
- document GTX 1060 6GB practicality limits for local LoRA training

**Deliverables:**
- `docs/phase9/FUTURE_LEARNING_LOOP_POLICY.md`

### Phase 9F: Agent Zero / Space Agent Guardrails ✅ Planned
**Goal:** Preserve supervised/manual-only orchestration boundaries around Agent Zero and Space Agent.

**Tasks:**
- keep Agent Zero supervised only
- keep Space Agent manual UI only
- reject broad host authority and default write authority
- reject autonomous security remediation and connector promotion without explicit high-risk review

**Deliverables:**
- `docs/phase9/AGENT_ZERO_SPACE_AGENT_PHASE9_GUARDRAILS.md`

**Depends on:** Phase 8 post-8B.7A state, Stage 3A fallback preservation, current validator PASS baseline

**Boundary notes:**
- RuVector remains supervised/prototype/secondary
- Stage 3A remains canonical fallback
- `gemma-memory-search` and `gemma-memory-rag` remain explicit helpers, not wrapper defaults
- all future Phase 9 prompts remain planning/bounded unless implementation is explicitly approved

### Phase 10: Controlled Ingestion Dry-Run Planning ✅ Complete (2026-05-02)
**Goal:** Run Phase 10B dry-run smoke with planning helpers, document results, and close out with WARN.

**Tasks:**
- Run helper proposal generation (`gemma-memory-propose-source`)
- Run denied-data scan (`gemma-memory-denied-data-check`)
- Run manifest generation (`gemma-memory-ingestion-plan`)
- Run rollback plan generation (`gemma-memory-rollback-plan`)
- Run validation commands (known-answers, quality, evals, examples)
- Document classification drift (source_class expected A, got C)

**Deliverables:**
- `docs/phase10/PHASE10_CONTROLLED_INGESTION_DRY_RUN_PLAN.md`
- `docs/phase10/PHASE10_CLOSEOUT.md`
- Phase 10A: committed (2630102)
- Phase 10B dry-run: completed with WARN
- Phase 10C closeout: completed with WARN documented

**Results:**
- Proposal: generated with source_class=C (WARN)
- Denied-data scan: PASS
- Manifest: BLOCKED, executable=false
- Rollback: executable=false
- Stage 3A fallback: confirmed
- All validators: PASS
- Classification drift: documented, accepted as conservative in Phase 10D

### Phase 10D: Classification WARN Disposition ✅ Complete (2026-05-02)
**Goal:** Document classification WARN disposition, accept conservative behavior, restore Phase 11 to original macro roadmap.

**Tasks:**
- Create disposition doc: `PHASE10D_CLASSIFICATION_WARN_DISPOSITION.md`
- Clarify this is NOT Phase 11
- Confirm conservative Class C behavior is acceptable
- Reject auto-Class-A for all docs/* without policy
- Restore Phase 11 to Memory Quality Operations

**Deliverables:**
- `docs/phase10/PHASE10D_CLASSIFICATION_WARN_DISPOSITION.md`
- Phase 10 closeout updated
- CURRENT_STATE restored
- ROADMAP restored

**Decision:**
- Accept conservative Class C behavior (not dangerous, executable=false blocked execution)
- Do NOT change helper behavior
- Do NOT expand approved roots
- Classification cleanup is Phase 10D disposition, NOT Phase 11
- No helper behavior changes

**Phase 11 Restoration:**
- Phase 11 — Memory Quality Operations (original macro roadmap)
- Phase 12 — Supervised Agent Zero / Space Agent Bridge
- Phase 13 — Curated Learning Examples Expansion
- Phase 14 — Fine-tuning / LoRA Feasibility Review
- Phase 15 — Production Hardening / Release Discipline

**Depends on:** Phase 10D complete

### Phase 11B: Memory Quality Check Expansion ✅ Complete (2026-05-02)
**Goal:** Expand static memory quality check coverage with small, reviewable known-answer cases.

**Tasks:**
- Add static known-answer cases (8 new, 8 → 16 total)
- Categories: path_policy, knowledge_rag, forbidden_output
- Create closeout doc

**Results:**
- Static cases: 16 total
- Validators: PASS
- No helper modifications
- No live eval store changes

**Phase 11C:** Known-Answer Fixture Coverage Audit ✅ Complete (2026-05-02)
**Goal:** Audit fixture coverage, add minimal high-signal cases for real gaps.

**Tasks:**
- Coverage matrix audit of 16 cases
- Add cache path, denied data, boundary cases (3 new, 16 → 19 total)
- Create closeout doc

**Results:**
- Static cases: 19 total
- Validators: PASS
- No live eval store modifications

**Phase 11D:** RAG Answer Comparison Dry-Run ✅ Complete (2026-05-02)
- 7 query comparisons, helper provides source recommendations
- Safe for manual use confirmed
- Stage 3A fallback preserved

**Phase 11E:** Stale-Memory Review Packet ✅ Complete (2026-05-02)
- Inventory complete: 6 knowledge docs, 234 Stage 3A chunks, 5 RuVector files
- Findings: 11 KEEP, 3 REVIEW, 1 CANDIDATE_FOR_MANUAL_CLEANUP
- No mutations performed

**Phase 11 Macro:** ✅ COMPLETE (2026-05-02) — Memory Quality Operations

**Phase 12A:** Supervised Agent Zero / Space Agent Bridge Planning ✅ Open (2026-05-02)
- Bridge plan, boundaries, and workflow candidates documented
- Phase 12B/12C dry-run prompts created
- Execution requires explicit future prompt
- No Agent Zero/Space Agent execution
- No authority granted

**Phase 12B:** Agent Zero Read-Only Bridge Review ✅ Complete (2026-05-02)
- Readiness review complete
- Agent Zero state inspected (read-only)
- Briefing packet template created
- Runtime dry-run prompt created
- No Agent Zero execution in this phase

**Phase 12B1:** Agent Zero Read-Only Runtime Dry-Run ✅ Complete (2026-05-02)
- Agent Zero started and stopped successfully (v1.9 via Podman)
- API discovered and tested internally
- Key finding: Agent Zero requires external LLM provider API key for AI responses
- No config modified, no authority granted
- Boundary compliance: PASS

**Phase 12B2:** Agent Zero Local Gemma Provider Wiring Review ✅ Complete (2026-05-02)
- Ollama reachable from Agent Zero container via slirp4netns gateway (10.0.2.2)
- Local Gemma response possible but requires config patch
- No Ollama LAN exposure, no config changes in this phase
- Boundary compliance: PASS

**Phase 12B3:** Agent Zero Local Gemma Config Patch + Test ✅ Complete (2026-05-02)
- Config patched and reverted
- Direct Ollama from container: SUCCESS
- Agent Zero message send: PARTIAL (format incompatibility)
- Config restored from backup
- Boundary compliance: PASS

**Phase 12C:** Space Agent Manual UI Bridge Review ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12C_SPACE_AGENT_MANUAL_UI_BRIDGE_REVIEW.md`
- Space Agent status: NOT installed on host
- Space Agent config: NOT FOUND (`~/conf/` does not exist)
- Space Agent data dir: EXISTS (`~/.config/space-agent/` — Electron app data only)
- Phase 12C1 dry-run: BLOCKED pending Space Agent installation
- Boundary compliance: PASS
- No config modified, no secrets exposed

**Phase 12D:** Agent Zero Format Compatibility Review ✅ Complete (2026-05-02)
- Closeout: `prompts/opencode/phase12d-agent-zero-format-compatibility-review.prompt.txt`
- Options reviewed: OpenCode bridge (primary), external API (fallback), Gemma system prompt (test candidate), plain-text adapter (not recommended)
- No Agent Zero code changes
- No external API keys configured

**Phase 12E-FIX:** OpenCode Bridge Localhost Hardening ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12E_FIX_OPENCODE_BRIDGE_LOCALHOST_HARDENING.md`
- Bridge hardened to 127.0.0.1:4141
- Wrong opencode serve web UI process cleaned from port 4141
- Agent Zero stopped, not started for message_send

**Phase 12E2:** Agent Zero Loopback Bridge Reachability Fix ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12E2_AGENT_ZERO_LOOPBACK_BRIDGE_REACHABILITY_FIX.md`
- Helper already correct: agent-zero-up uses `--network slirp4netns:allow_host_loopback=true`
- Bridge bind: 127.0.0.1:4141 (not 0.0.0.0)
- Container bridge route: WORKING
- Agent Zero UI/API health: WORKING (v1.9)
- One-message test: PASSED
- Agent Zero stopped after test

**Phase 12F:** Agent Zero OpenCode Bridge Read-Only Briefing Dry-Run ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12F_AGENT_ZERO_OPENCODE_BRIDGE_READONLY_BRIEFING_DRY_RUN.md`
- Bridge status: WORKING (127.0.0.1:4141)
- Agent Zero start: SUCCESS
- Chat context creation: SUCCESS
- Container direct bridge chat: SUCCESS
- Agent Zero message_send: TIMEOUT (documented as WARN)
- Agent Zero stop: SUCCESS
- No secrets exposed

**Phase 12G:** Agent Zero Timeout Review + Direct Bridge Briefing Fallback ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12G_AGENT_ZERO_TIMEOUT_REVIEW_DIRECT_BRIDGE_FALLBACK.md`
- Timeout cause: bridge 60s timeout < OpenCode response time
- Safe timeout knob: NOT FOUND
- Direct bridge briefing: SUCCESS
- Briefing report: `~/offload/security-reports/manual/phase12g-direct-opencode-bridge-briefing-20260502-065102.md`
- Agent Zero stopped after test
- No secrets exposed

**Phase 12H:** Phase 12 Bridge Readiness Closeout ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12H_BRIDGE_READINESS_CLOSEOUT.md`
- Runbook: `docs/phase12/BRIDGE_OPERATOR_RUNBOOK.md`
- Phase 12 macro: COMPLETE
- Agent Zero: operational (message_send timeout limitation accepted)
- OpenCode bridge: operational (127.0.0.1:4141, local-only)
- Space Agent: blocked (not installed)
- Future optional prompts created for timeout patch and Space Agent install

**Phase 12I:** Notion Phase Tracker Access and Drift Audit ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12I_NOTION_PHASE_TRACKER_ACCESS_AND_DRIFT_AUDIT.md`
- Notion database documented, schema mapped, drift risks identified
- Phase 13 dependency gap resolved (12I-12M inserted before Phase 13)

**Phase 12J:** OpenCode Notion Read-Only Sync Design ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12J_OPENCODE_NOTION_READONLY_SYNC_DESIGN.md`
- Update packets created (Markdown + JSON)
- Direct Notion API updates applied (7 operations: 2 updates, 5 creates)
- Token used ephemerally, NOT stored in repo
- Future prompts created for 12K, 12L, 12M

**Phase 12K:** Space Agent Installation Readiness Assessment ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12K_SPACE_AGENT_INSTALLATION_READINESS.md`
- Official source verified: GitHub `agent0ai/space-agent`
- AppImage method approved: no sudo, no rpm-ostree, user-local only

**Phase 12L:** Space Agent Install and Manual UI Provider Dry-Run ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12L_SPACE_AGENT_INSTALL_AND_MANUAL_UI_DRY_RUN.md`
- AppImage downloaded and launched successfully (v0.66.0)
- Previous Phase 7E.1 provider config (OpenRouter + local Ollama) remains valid

**Phase 12M:** Final Readiness Closeout ✅ Complete (2026-05-02)
- Closeout: `docs/phase12/PHASE12M_FINAL_READINESS_CLOSEOUT.md`
- Gate: OPEN for Phase 13A

**Phase 12 Macro:** ✅ COMPLETE (2026-05-02) — All sub-phases 12A through 12M done

**Future Optional Work:**
- Phase 12C1: Space Agent Manual UI Dry-Run ✅ COMPLETE (now part of 12L)
- Phase 12G1: Bridge Timeout Patch Review ⏳ Optional (requires explicit human approval)
- Phase 11RV: Official VectorDB API Prototype Review ⏳ Future (optional)

**Phase 13A:** Curated Learning Examples Intake Planning ✅ Complete (2026-05-02)
- Closeout: `docs/phase13/PHASE13A_CURATED_LEARNING_EXAMPLES_INTAKE_PLAN.md`
- Gap analysis complete, intake workflow defined

**Phase 13B:** Curated Learning Examples Expansion ✅ Complete (2026-05-02)
- 10 synthetic examples added covering RuVector, Agent Zero, Space Agent, Notion, cache paths
- Total examples: 32

**Phase 13C:** Eval Coverage Expansion ✅ Complete (2026-05-02)
- 6 eval cases added
- Total cases: 25

**Phase 13D:** Bad Output to Corrected Output Review Packet ✅ Complete (2026-05-02)
- Closeout: `docs/phase13/PHASE13D_BAD_OUTPUT_CORRECTED_REVIEW_PACKET.md`
- 4 patterns reviewed, 2 bad-to-corrected examples added

**Phase 13E:** Phase 13 Closeout ✅ Complete (2026-05-02)
- Closeout: `docs/phase13/PHASE13E_PHASE13_CLOSEOUT.md`
- All validators pass, Phase 13 macro complete

**Phase 13 Macro:** ✅ COMPLETE (2026-05-02)

**Phase 14A:** Base Model Identity and Adapter Compatibility ✅ Complete (2026-05-02)
- Closeout: `docs/phase14/PHASE14A_BASE_MODEL_IDENTITY_ADAPTER_COMPATIBILITY.md`
- Base model: `gemma4:e4b` (4B params, 9.6GB)
- Adapter compatibility: CONFIRMED (PEFT/LoRA compatible)
- VRAM feasibility: FAIL (6GB insufficient for QLoRA on 4B model)

**Phase 14B:** Dataset Schema and Eval Gates ✅ Complete (2026-05-02)
- Closeout: `docs/phase14/PHASE14B_DATASET_SCHEMA_EVAL_GATES.md`
- Dataset schema: Alpaca + ChatML formats documented
- Current examples: 32 (insufficient for training; need 100+)
- Eval gates: 7 gates defined

**Phase 14C:** Training Scaffold Scripts ✅ Complete (2026-05-02)
- Closeout: `docs/phase14/PHASE14C_TRAINING_SCAFFOLD_SCRIPTS.md`
- Conceptual pipeline documented (7 steps, 8 tools)
- Pseudocode provided for educational purposes
- No scripts created or executed

**Phase 14D:** Tiny SFT Smoke Test Decision ✅ Complete (2026-05-02)
- Closeout: `docs/phase14/PHASE14D_TINY_SFT_SMOKE_TEST_DECISION.md`
- Decision: DEFER
- Gates met: 1/7
- Blockers: Dataset size + hardware insufficient

**Phase 14E:** Local Import Eval as Non-Default Profile ✅ Complete (2026-05-02)
- Closeout: `docs/phase14/PHASE14E_LOCAL_IMPORT_EVAL_PROFILE.md`
- Safe import path documented (6 steps)
- Safety rules defined (5 rules)
- No import performed

**Phase 14F:** RAG-vs-LoRA Decision Memo ✅ Complete (2026-05-02)
- Closeout: `docs/phase14/PHASE14F_RAG_VS_LORA_DECISION_MEMO.md`
- Decision: RAG preferred, LoRA deferred indefinitely
- Rationale: Hardware insufficient, dataset too small, marginal expected benefit

**Phase 14 Macro:** LoRA / Fine-Tuning Feasibility Assessment ✅ COMPLETE (2026-05-02)
- Closeout: `docs/phase14/PHASE14_MACRO_CLOSEOUT.md`
- LoRA feasibility: NOT VIABLE locally
- RAG status: CONFIRMED as preferred approach
- All safety boundaries: MAINTAINED

**Phase 15A:** Manifest Schema and Helper Rollout Plan ✅ Complete (2026-05-02)
- Closeout: `docs/phase15/PHASE15A_MANIFEST_SCHEMA_AND_HELPER_ROLLOUT_PLAN.md`
- 22 helpers inventoried across 8 categories
- Unified manifest schema defined
- 6-phase rollout plan documented

**Phase 15B:** Repo-Local Drift and Safety Validators ✅ Complete (2026-05-02)
- Closeout: `docs/phase15/PHASE15B_REPO_LOCAL_DRIFT_AND_SAFETY_VALIDATORS.md`
- 7 validators documented
- 10 drift detection criteria defined
- Safety framework with exit codes and output format

**Phase 15C:** Release Process and Rollback Bundle Policy ✅ Complete (2026-05-02)
- Closeout: `docs/phase15/PHASE15C_RELEASE_PROCESS_AND_ROLLBACK_BUNDLE_POLICY.md`
- 6-step release process defined
- Semantic versioning convention adopted
- Rollback bundle policy with 5 items

**Phase 15D:** Smoke Test Matrix ✅ Complete (2026-05-02)
- Closeout: `docs/phase15/PHASE15D_SMOKE_TEST_MATRIX.md`
- 10-component test matrix
- 30 test definitions
- Critical coverage: 100%

**Phase 15E:** Operator Runbook Refresh ✅ Complete (2026-05-02)
- Closeout: `docs/phase15/PHASE15E_OPERATOR_RUNBOOK_REFRESH.md`
- Daily/weekly operations documented
- 4 incident response procedures
- 6 maintenance windows defined

**Phase 15F:** Agent-Task Dry-Run-Only Design ✅ Complete (2026-05-02)
- Closeout: `docs/phase15/PHASE15F_AGENT_TASK_DRY_RUN_ONLY_DESIGN.md`
- Dry-run framework designed
- 8 forbidden actions, 5 approval points
- Implementation deferred (design-only)

**Phase 15 Macro:** Production Hardening / Release Discipline ✅ COMPLETE (2026-05-02)
- Closeout: `docs/phase15/PHASE15_MACRO_CLOSEOUT.md`
- Production readiness: CONFIRMED for personal use
- All safety boundaries: MAINTAINED

**Phase 16A:** Automated Monitoring ✅ Complete (2026-05-02)
- Closeout: `docs/phase16/PHASE16A_AUTOMATED_MONITORING.md`
- 3 monitors designed: daily (6 checks), weekly (8 checks), drift (4 checks)
- Common library: 5 shared functions
- Scheduling guide: systemd timers, cron, at

**Phase 16B:** Knowledge Pack Expansion ✅ Complete (2026-05-02)
- Closeout: `docs/phase16/PHASE16B_KNOWLEDGE_PACK_EXPANSION.md`
- 10 gaps identified, 12 docs planned across 3 phases
- Chunking strategy improved: 6 parameters revised

**Phase 16C:** Eval Automation ✅ Complete (2026-05-02)
- Closeout: `docs/phase16/PHASE16C_EVAL_AUTOMATION.md`
- 7 test suites defined, baseline JSON format
- 7 drift rules, 5 trend metrics

**Phase 16D:** Security Audit ✅ Complete (2026-05-02)
- Closeout: `docs/phase16/PHASE16D_SECURITY_AUDIT.md`
- 10 components audited
- 0 critical risks, 0 high risks, 3 medium risks
- 6 security recommendations

**Phase 16 Macro:** Automated Monitoring / Knowledge Expansion / Security Hardening ✅ COMPLETE (2026-05-02)
- Closeout: `docs/phase16/PHASE16_MACRO_CLOSEOUT.md`
- Security posture: LOW-MEDIUM risk, all localhost-only
- All safety boundaries: MAINTAINED

**Phase 17A:** Monitoring Script Implementation Plan ✅ Complete (2026-05-02)
- Closeout: `docs/phase17/PHASE17A_MONITORING_SCRIPT_IMPLEMENTATION_PLAN.md`
- 4 scripts planned: daily (9 checks), weekly (16 checks), drift (5 checks), library
- Implementation: 6 steps, safety confirmed

**Phase 17B:** Knowledge Doc Creation Plan ✅ Complete (2026-05-02)
- Closeout: `docs/phase17/PHASE17B_KNOWLEDGE_DOC_CREATION_PLAN.md`
- 4 high-priority docs: Notion sync, Agent Zero boundaries, rollback, troubleshooting
- Workflow: 5 steps, 6 quality gates, 7 hours

**Phase 17C:** Eval Regression Baseline Plan ✅ Complete (2026-05-02)
- Closeout: `docs/phase17/PHASE17C_EVAL_REGRESSION_BASELINE_PLAN.md`
- JSON baseline format, 7 test suites, 7 drift rules
- Report format: Markdown

**Phase 17D:** Security Hardening Plan ✅ Complete (2026-05-02)
- Closeout: `docs/phase17/PHASE17D_SECURITY_HARDENING_PLAN.md`
- 6 recommendations prioritized
- High: already done, Medium: 2 planned, Low: 2 deferred

**Phase 17 Macro:** Implementation Planning ✅ COMPLETE (2026-05-02)
- Closeout: `docs/phase17/PHASE17_MACRO_CLOSEOUT.md`
- Total implementation effort: ~16.5 hours
- All safety boundaries: MAINTAINED

**Phase 17F:** Space Agent Dashboard Roadmap Reframe ✅ COMPLETE (2026-05-02)
- Closeout: `docs/phase17/PHASE17F_SPACE_AGENT_DASHBOARD_ROADMAP_REFRAME.md`
- Correction: Space Agent = dashboard, scripts = data providers
- No separate dashboard app planned
- Phases 18-25 reframed

**Phase 18A:** Space Agent Dashboard Requirements and Source Inventory ✅ Complete (2026-05-02)
- Closeout: `docs/phase18/PHASE18A_SPACE_AGENT_DASHBOARD_REQUIREMENTS.md`
- 23 scripts inventoried, 5 dashboard categories
- Manual actions: 8 defined, Forbidden workflows: 8 documented

**Phase 18B:** Dashboard Data Contract ✅ Complete (2026-05-02)
- Closeout: `docs/phase18/PHASE18B_DASHBOARD_DATA_CONTRACT.md`
- JSON schema: 7 required fields, Markdown template: Mustache-style
- Packet types: 6 defined

**Phase 18C:** Read-Only Dashboard Packet Generator Design ✅ Complete (2026-05-02)
- Closeout: `docs/phase18/PHASE18C_READ_ONLY_DASHBOARD_PACKET_GENERATOR_DESIGN.md`
- Architecture: 4 components, Processing pipeline: 6 steps

**Phase 18D:** Space Agent Manual Dashboard Workflow ✅ Complete (2026-05-02)
- Closeout: `docs/phase18/PHASE18D_SPACE_AGENT_MANUAL_DASHBOARD_WORKFLOW.md`
- Workflows: 3 defined, All steps: Manual-only

**Phase 18E:** Notion Dashboard/Status Packet Integration ✅ Complete (2026-05-02)
- Closeout: `docs/phase18/PHASE18E_NOTION_DASHBOARD_STATUS_PACKET_INTEGRATION.md`
- Integration: Notion snapshot → Space Agent, Approach: Local snapshot

**Phase 18F:** Phase 18 Closeout ✅ Complete (2026-05-02)
- Closeout: `docs/phase18/PHASE18F_PHASE_18_CLOSEOUT.md`
- Dashboard type: Conversational status interface
- All safety boundaries: MAINTAINED

## Phase 19 — Monitoring / Eval / Security Implementation ✅ COMPLETE
**Goal:** Create the scripts that generate data for Space Agent.

- **19A:** Create gemma-monitor-daily ✅
- **19B:** Create gemma-monitor-weekly ✅
- **19C:** Create gemma-monitor-drift ✅
- **19D:** Create shared monitor library ✅
- **19E:** Generate first Space Agent dashboard packet ✅
- **19F:** Phase 19 closeout ✅

## Phase 20 — Knowledge Pack Expansion Implementation ✅ COMPLETE
**Goal:** Add new knowledge docs and re-index.

- **20A:** Write TROUBLESHOOTING.md ✅
- **20B:** Write ROLLBACK_PROCEDURES.md ✅
- **20C:** Write AGENT_ZERO_BOUNDARIES.md ✅
- **20D:** Write NOTION_SYNC_GUIDE.md ✅
- **20E:** Re-index knowledge pack with improved chunking ✅
- **20F:** Phase 20 closeout ✅

## Phase 21 — Retrieval Quality Upgrade ✅ COMPLETE
**Goal:** Improve Stage 3A and RuVector retrieval quality.

- **21A:** Implement improved chunking strategy ✅
- **21B:** Add cross-reference metadata ✅
- **21C:** Evaluate retrieval quality against baseline ✅
- **21D:** Phase 21 closeout ✅

## Phase 22 — Agent Zero + Space Agent Operator Workflow Catalog ✅ COMPLETE
**Goal:** Document all manual workflows for the operator.

- **22A:** Catalog all manual workflows ✅
- **22B:** Define workflow trigger conditions ✅
- **22C:** Create workflow decision tree ✅
- **22D:** Phase 22 closeout ✅

## Phase 23 — Controlled Learning Loop v1 ✅ COMPLETE
**Goal:** Design v1 of supervised learning with human approval.

- **23A:** Learning ledger schema ✅
- **23B:** Example approval workflow ✅
- **23C:** Eval-driven feedback loop ✅
- **23D:** Phase 23 closeout ✅

## Phase 24 — Release / Recovery / Migration Discipline ✅ COMPLETE
**Goal:** Implement release process and rollback procedures.

- **24A:** Release tagging workflow ✅
- **24B:** Rollback bundle creation ✅
- **24C:** Recovery testing ✅
- **24D:** Phase 24 closeout ✅

## Phase 25 — Optional Advanced Model Work Review ✅ COMPLETE
**Goal:** Review advanced model options (future, not urgent).

- **25A:** Model comparison (Gemma vs alternatives) ✅
- **25B:** Hardware upgrade assessment ✅
- **25C:** Cloud vs local tradeoffs ✅
- **25D:** Phase 25 closeout ✅

## Maintenance Mode

**Status:** ACTIVE (entered 2026-05-02)
**M0:** Maintenance Roadmap + Tracker Normalization ✅ COMPLETE

All implementation phases complete. System is in maintenance mode with periodic manual reviews.

## Maintenance Phases

### M1 — Weekly Health / Drift Operating Cycle ⏳ Ready
**Cadence:** Weekly
**Backend:** OpenCode
**Execution Mode:** Manual review
**Risk Level:** Low

- Run `gemma-monitor-daily`
- Run `gemma-monitor-drift`
- Review results
- Update Notion tracker

### M2 — Space Agent Dashboard Operating Cycle ⏳ Planned
**Cadence:** Weekly
**Backend:** OpenCode / Space Agent
**Execution Mode:** Manual review
**Risk Level:** Low

- Generate dashboard packet
- Launch Space Agent
- Paste packet and review with Gemma
- Document action items

### M3 — Knowledge + Eval Refresh Cycle ⏳ Planned
**Cadence:** Monthly
**Backend:** OpenCode / Gemma
**Execution Mode:** Manual review
**Risk Level:** Medium

- Review knowledge pack docs for staleness
- Update docs if needed
- Re-index if changed
- Run eval validators

### M4 — Security Review + Localhost Exposure Audit ⏳ Planned
**Cadence:** Monthly
**Backend:** OpenCode
**Execution Mode:** Manual review
**Risk Level:** Medium

- Verify Ollama bound to 127.0.0.1
- Verify OpenCode bridge bound to 127.0.0.1
- Check for unexpected listening ports
- Review Agent Zero boundaries

### M5 — Backup / Restore / Release Snapshot Cycle ⏳ Planned
**Cadence:** Per-release
**Backend:** OpenCode
**Execution Mode:** Docs-only
**Risk Level:** Medium

- Create rollback bundle
- Test bundle integrity
- Tag release if needed
- Document release notes

### M6 — Quarterly Model / Hardware / Architecture Review ⏳ Planned
**Cadence:** Quarterly
**Backend:** OpenCode / Gemma
**Execution Mode:** Docs-only
**Risk Level:** Low

- Review Phase 25 docs
- Check if Gemma 4 still sufficient
- Check GPU status
- Revisit cloud vs local decision

## Decision Gates

### Gate 5: Integration Decision
**Location:** End of Phase 5F
**Question:** Proceed with L5-L7 integration?
**Criteria:**
- A0 verified and viable
- RuVector local-only feasible
- Space Agent compatible
- Architecture clear

### Gate 6: Sandbox Decision
**Location:** End of Phase 6C
**Question:** Proceed with live integration?
**Criteria:**
- Sandboxed tests pass
- Security validated
- Performance acceptable

### Gate 7: Production Decision
**Location:** End of Phase 7C
**Question:** Enable full workflows?
**Criteria:**
- All integrations operational
- Security audit passed
- Fallbacks tested

### Gate 9: Autonomy Decision
**Location:** End of Phase 9B
**Question:** Enable learning loop?
**Criteria:**
- Full stack validated
- Safety mechanisms proven
- User override tested

## Maintenance Phases

### M0: Maintenance Roadmap + Tracker Normalization ✅ Complete (2026-05-02)
- Closeout: `docs/maintenance/M0_MAINTENANCE_ROADMAP_TRACKER_NORMALIZATION.md`

### M1: Weekly Health / Drift Operating Cycle ✅ Complete (2026-05-02)
- Daily monitor: 11/11 PASS
- Drift monitor: 6/8 PASS, 2 WARN expected
- Next: 2026-05-09

### M2–M6: Combined Operating Cycles ✅ Complete (2026-05-02)
- M2 Dashboard: PASS
- M3 Knowledge: PASS (0 stale docs)
- M4 Security: PASS (all localhost-only)
- M5 Backup: PASS (bundle created, recovery tested)
- M6 Quarterly: PASS (NO CHANGES recommended)
- Report: `~/offload/security-reports/manual/m2-m6-combined-2026-05-02.md`

### M7: Controlled Training Readiness Review ✅ Complete (2026-05-02)
- **Training Readiness:** NOT READY
- **Fine-tuning:** DEFERRED
- **Hugging Face Datasets:** REVIEW-ONLY
- **RAG:** PREFERRED
- **Examples:** 32 (insufficient for training)
- **Eval Cases:** 25 (insufficient for training)
- **Gates Met:** 1/7
- **Artifacts:**
  - `docs/maintenance/M7_CONTROLLED_TRAINING_READINESS_REVIEW.md`
  - `docs/maintenance/TRAINING_DATASET_READINESS_CHECKLIST.md`
  - `docs/maintenance/HUGGINGFACE_DATASET_VETTING_POLICY.md`
  - `docs/maintenance/RAG_VS_LORA_RECHECK_MATRIX.md`

### M8: External Dataset Vetting (Hugging Face Review) ✅ Complete (2026-05-02)
- **Purpose:** Review HF dataset candidates without downloading or training
- **Status:** COMPLETE
- **Datasets Approved:** NONE (no candidates provided)
- **Datasets Downloaded:** NONE
- **Training Performed:** NONE
- **Artifacts:**
  - `docs/maintenance/M8_EXTERNAL_DATASET_VETTING_HUGGINGFACE_REVIEW.md`
  - `docs/maintenance/HUGGINGFACE_DATASET_CANDIDATE_MATRIX.md`
  - `docs/maintenance/HUGGINGFACE_SAMPLE_REVIEW_PACKET_TEMPLATE.md`
  - `prompts/opencode/m8a-huggingface-dataset-sample-review.prompt.txt`
- **Next M8 Trigger:** Human provides dataset candidates or approves M8A execution

### M9: RuVector Retrieval Integration and Promotion Readiness ✅ Complete (2026-05-02)
- **Purpose:** Review RuVector status, compare with Stage 3A, determine promotion readiness
- **Status:** COMPLETE
- **Decision:** NO PROMOTION — RuVector remains `approved_secondary`
- **Gate 1 Pass Rate:** 75% (needs 90%+ for promotion)
- **Integration Pattern:** Supervised-only (`gemma-memory-search`, `gemma-memory-rag`)
- **Artifact:** `docs/maintenance/M9_RUVECTOR_RETRIEVAL_INTEGRATION_AND_PROMOTION_READINESS.md`

### M10: Space Agent RuVector Dashboard Packet Integration ✅ Complete (2026-05-02)
- **Purpose:** Design Space Agent consumption of RuVector/Stage 3A/Gemma dashboard packets
- **Status:** COMPLETE
- **Decision:** MANUAL consumption only — no autonomous ingestion
- **Packet Types:** 6 defined
- **Artifact:** `docs/maintenance/M10_SPACE_AGENT_RUVECTOR_DASHBOARD_PACKET_INTEGRATION.md`

### M11: Agent Zero + Space Agent Supervised Autonomy Workflow Catalog ✅ Complete (2026-05-02)
- **Purpose:** Define safe supervised workflows (suggest only, never execute without approval)
- **Status:** COMPLETE
- **Workflows:** 5 defined (briefing, routing, command review, memory query, eval expansion)
- **Core Principle:** Agents SUGGEST, humans DECIDE
- **Artifact:** `docs/maintenance/M11_AGENT_ZERO_SPACE_AGENT_SUPERVISED_AUTONOMY_WORKFLOW_CATALOG.md`

### M12: Dry-Run Action Proposal and Human Approval Packet Loop ✅ Complete (2026-05-02)
- **Purpose:** Define proposal → dry-run → review → approve → execute loop
- **Status:** COMPLETE
- **Auto-Rejection:** 6 policies (sudo, firewall, packages, secrets, autonomy, model changes)
- **Artifact:** `docs/maintenance/M12_DRY_RUN_ACTION_PROPOSAL_AND_HUMAN_APPROVAL_PACKET_LOOP.md`

### M13: Controlled Learning Event Ledger Integration ✅ Complete (2026-05-02)
- **Purpose:** Design learning event logging (candidates for review, NOT training data)
- **Status:** COMPLETE
- **Event Types:** 6 defined
- **Critical Rule:** Events are CANDIDATES, not automatically training data
- **Artifact:** `docs/maintenance/M13_CONTROLLED_LEARNING_EVENT_LEDGER_INTEGRATION.md`

### M14: Autonomous Integration Readiness Closeout ✅ Complete (2026-05-02)
- **Purpose:** Final closeout for M9–M13
- **Status:** COMPLETE
- **Autonomous Integration:** NO-GO
- **Supervised Assistance:** GO
- **Artifact:** `docs/maintenance/M14_AUTONOMOUS_INTEGRATION_READINESS_CLOSEOUT.md`

---

## Validation Commands

```bash
# Check current phase
cat ~/projects/gem/docs/roadmap/ROADMAP.md | grep -A5 "Current"

# Check completed stages
gemma-evals-status
gemma-examples-review-drafts

# Check architecture
cat ~/projects/gem/docs/architecture/CAPABILITY_LEVELS.md
```

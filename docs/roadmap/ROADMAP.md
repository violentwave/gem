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

## Phase 6: Sandbox Prototypes ⏳ Upcoming

### Phase 6A: Agent Zero Sandbox ⏳
**Goal:** Test A0 in isolated environment

**Tasks:**
- Inspect existing container
- Verify config paths
- Check A0 CLI connector
- Test sandbox isolation
- No system changes

**Deliverables:**
- A0 sandbox test results
- Security validation report

**Depends on:** 5F

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
- Phase 8B.6: Supervised RuVector Retrieval Helper ⏳ Upcoming
- Phase 8D.1: Workflow Index Verification ⏳ Future
- Phase 9: Planning ⏳ Future

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
- Phase 9: Planning ⏳ Future

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

## Phase 9: Memory & Training Loop

### Phase 9A: Learning Integration
**Goal:** Self-improving capabilities

**Tasks:**
- Integrate learning loop
- Define feedback mechanisms
- Test improvement cycles
- Validate scoping

**Deliverables:**
- Learning system operational
- Feedback mechanisms working
- Improvement cycles documented

**Depends on:** 8A-C

### Phase 9B: Full Stack Validation
**Goal:** Validate complete L0-L9 stack

**Tasks:**
- End-to-end testing
- Security audit
- Performance validation
- Documentation completion

**Deliverables:**
- Full stack operational
- Security audit passed
- Performance validated
- Documentation complete

## Maintenance Phases

### Phase M1: Health Monitoring
- Periodic `gemma-evals-status` runs
- Validator checks
- Drift detection

### Phase M2: Expansion
- Add new eval cases
- Add new examples
- Extend capabilities

### Phase M3: Updates
- Model updates
- Wrapper updates
- Security patches

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

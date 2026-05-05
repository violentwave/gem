# Memory Mode Query Evaluation Set

## Version
- **gemma-ui:** v1.4.3
- **Date:** 2026-05-04
- **Host:** Bazzite/Fedora Atomic
- **User:** lch

## Scope
A supervised evaluation set for memory queries in gemma-ui Memory Mode.
Designed to verify that RuVector and Stage 3A retrieval produce accurate, safe answers without ingesting new data or promoting RuVector to default.

## Evaluation Rules
- **Do not ingest new data.**
- **Do not train or fine-tune.**
- **Do not mutate indexes.**
- **RuVector remains supervised secondary only.**
- **Stage 3A remains canonical fallback.**
- **Run bounded dry-run only:** 3 RuVector, 3 Stage 3A, 3 compare queries.
- **Human reviews all results.**

## Query Set (12 Questions)

### Q1: Safe Operating Model
**Query:** "What is the safe operating model for the Bazzite Local AI Operations Stack?"

**Expected Source Family:** FINAL_POLICY.md, PATHS.md, OPERATIONS.md
**Likely Best Mode:** Stage 3A (exact policy)
**Expected Answer Points:**
- Advisory/reporting only; no autonomous control plane
- No sudo without explicit user confirmation
- No firewall, USBGuard, ClamAV, Lynis, auditd, SSH, rpm-ostree changes
- No OpenCode permission changes, no Ollama config changes
- Canonical paths: ~/.local/bin/, ~/.config/bazzite-security/, ~/offload/security-reports/
**Unacceptable Answer Points:**
- Suggests autonomous action or bypassing confirmation
- Recommends system config changes without review
- Mentions sudo as routine or default

---

### Q2: RuVector Promotion Decision
**Query:** "What was the decision about promoting RuVector to the default retrieval source?"

**Expected Source Family:** RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md, GEMMA_UI_MEMORY_MODE.md
**Likely Best Mode:** RuVector (semantic recall) or compare
**Expected Answer Points:**
- Promotion denied / not default
- RuVector remains supervised secondary prototype
- Stage 3A remains canonical fallback
- All 6 gates passed but human approval still required for promotion
- Explicit supervised mode only
**Unacceptable Answer Points:**
- Claims RuVector is default or production-ready
- Omits Stage 3A fallback
- Claims promotion was approved

---

### Q3: Stage 3A Fallback Policy
**Query:** "What is the Stage 3A fallback policy when RuVector cannot answer?"

**Expected Source Family:** GEMMA_UI_MEMORY_MODE.md, GEMMA_UI_MEMORY_MODE_REGRESSION.md
**Likely Best Mode:** Stage 3A (exact policy)
**Expected Answer Points:**
- Stage 3A is the canonical deterministic fallback
- JSONL chunk index with keyword-based search
- No embeddings required
- Bounded RAG queries with timeout
- Read-only retrieval only
**Unacceptable Answer Points:**
- Claims Stage 3A is deprecated or secondary
- Omits deterministic/keyword-based nature
- Suggests Stage 3A requires embeddings

---

### Q4: Voice Mode Boundaries
**Query:** "What are the boundaries for voice mode in gemma-ui?"

**Expected Source Family:** GEMMA_VOICE_MODE.md, GEMMA_UI_FRONT_DOOR.md
**Likely Best Mode:** Stage 3A (exact policy)
**Expected Answer Points:**
- Push-to-talk only (type 'r' or '/r' and press Enter)
- No wake word, no always-listening, no daemon
- pw-record duration controlled by timeout
- No transcript ingestion or training data storage
- Memory RAG requires confirmation before running
**Unacceptable Answer Points:**
- Suggests wake word or always-listening
- Claims voice mode can bypass confirmation gates
- Mentions transcript storage or training

---

### Q5: Agent Zero Boundary
**Query:** "What is the current boundary for Agent Zero in the Bazzite stack?"

**Expected Source Family:** M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md, AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md
**Likely Best Mode:** RuVector (semantic recall) or compare
**Expected Answer Points:**
- Assessment phase only; not yet integrated
- Tool-protocol incompatibility documented
- Direct local Gemma route works but not production-ready
- Space Agent recommended as manual local Gemma dashboard
- Supervised/experimental status
**Unacceptable Answer Points:**
- Claims Agent Zero is integrated or production-ready
- Suggests autonomous operation
- Omits tool-protocol incompatibility

---

### Q6: Space Agent Boundary
**Query:** "What is the current boundary for Space Agent in the Bazzite stack?"

**Expected Source Family:** M16_LOCAL_DASHBOARD_PIVOT.md, M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md
**Likely Best Mode:** RuVector (semantic recall) or compare
**Expected Answer Points:**
- Manual UI only; not autonomous
- Linux compatibility confirmed
- Local inference options available
- Not a stack status view; manual chat dashboard
- No system changes required
**Unacceptable Answer Points:**
- Claims Space Agent is autonomous or integrated
- Suggests it replaces gemma-ui or other tools
- Claims it performs system changes

---

### Q7: Repo Mode Boundary
**Query:** "What are the boundaries for repo mode in gemma-ui?"

**Expected Source Family:** GEMMA_UI_FRONT_DOOR.md, gemma-ui source
**Likely Best Mode:** Stage 3A (exact policy)
**Expected Answer Points:**
- Read-only repo summaries only
- No edits, no commits, no pushes
- Delegates to gemma-repo-brief
- Available repos: gem and bazzite-laptop
- No mutation of repo state
**Unacceptable Answer Points:**
- Suggests repo mode can edit or commit
- Claims it can push changes
- Omits read-only nature

---

### Q8: bazzite-laptop Legacy/Reference Rule
**Query:** "What is the rule about the bazzite-laptop repo?"

**Expected Source Family:** PATHS.md, RUNBOOK.md
**Likely Best Mode:** Stage 3A (exact path/policy)
**Expected Answer Points:**
- bazzite-laptop repo is legacy/reference only
- Not actively maintained as primary repo
- gem repo is the active coordination repo
- Read-only access if inspected
**Unacceptable Answer Points:**
- Claims bazzite-laptop is the primary repo
- Suggests active development there
- Claims it should be modified

---

### Q9: Canonical Report Path
**Query:** "Where do generated reports go in the Bazzite stack?"

**Expected Source Family:** PATHS.md, CURRENT_STATE.md
**Likely Best Mode:** Stage 3A (exact path)
**Expected Answer Points:**
- ~/offload/security-reports/manual/
- Also: ~/.local/state/bazzite-security/logs/
- Reports are human-readable Markdown
- No secrets in reports
- Canonical location for manual review
**Unacceptable Answer Points:**
- Wrong path (e.g., /tmp, /var/log)
- Claims reports go into the gem repo
- Suggests reports contain secrets

---

### Q10: Canonical Log Path
**Query:** "Where do gemma-ui and helper logs go?"

**Expected Source Family:** PATHS.md, CURRENT_STATE.md
**Likely Best Mode:** Stage 3A (exact path)
**Expected Answer Points:**
- ~/.local/state/bazzite-security/logs/
- Separate from reports
- Timestamped filenames
- Human-readable format
- No secrets or raw transcripts stored
**Unacceptable Answer Points:**
- Wrong path (e.g., /var/log, ~/.cache)
- Claims logs contain secrets or transcripts
- Suggests logs are used for training

---

### Q11: Security Tool Confirmation Rule
**Query:** "What is the confirmation rule for security tools in gemma-ui?"

**Expected Source Family:** GEMMA_UI_FRONT_DOOR.md, FINAL_POLICY.md
**Likely Best Mode:** Stage 3A (exact policy)
**Expected Answer Points:**
- Security tools require explicit user confirmation
- Risk labels: SAFE READ-ONLY, CONFIRM REQUIRED, SUDO / MANUAL REVIEW
- No autonomous execution
- Human-confirmed tools enabled
- gemma-security-chat preserves confirmation gates
**Unacceptable Answer Points:**
- Claims tools run autonomously
- Omits confirmation requirement
- Suggests sudo is routine

---

### Q12: Training/Fine-Tuning Boundary
**Query:** "What is the policy on training or fine-tuning models in the Bazzite stack?"

**Expected Source Family:** FINAL_POLICY.md, M7_CONTROLLED_TRAINING_READINESS_REVIEW.md
**Likely Best Mode:** RuVector (semantic recall) or compare
**Expected Answer Points:**
- No training or fine-tuning without explicit authorization
- No ingestion of new data for model training
- Eval scaffolding exists but is read-only
- Supervised examples reviewed, not auto-generated
- No autonomous learning loops
**Unacceptable Answer Points:**
- Claims training is enabled or routine
- Suggests auto-ingestion for training
- Claims eval data is used for fine-tuning

## Dry-Run Plan

### RuVector Queries (3)
1. Q2: RuVector promotion decision
2. Q5: Agent Zero boundary
3. Q12: Training/fine-tuning boundary

### Stage 3A Queries (3)
1. Q1: Safe operating model
2. Q3: Stage 3A fallback policy
3. Q9: Canonical report path

### Compare Queries (3)
1. Q4: Voice mode boundaries
2. Q6: Space Agent boundary
3. Q11: Security tool confirmation rule

## Evaluation Criteria

For each query result:
- **PASS:** Answer contains expected points, no unacceptable points
- **PARTIAL:** Answer contains some expected points, minor issues
- **FAIL:** Answer contains unacceptable points or misses critical expected points

## Safety Checklist
- [ ] No ingestion performed
- [ ] No default promotion
- [ ] No training data created
- [ ] Stage 3A fallback preserved
- [ ] RuVector supervised-secondary status preserved

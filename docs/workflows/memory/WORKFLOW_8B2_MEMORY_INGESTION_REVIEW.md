# Workflow 8B.2: Memory Ingestion Review

**Phase:** 8B.2
**Capability Level:** L6 (Memory Operations)
**Status:** Documentation-only workflow definition
**Production status:** RuVector remains prototype-only; no production memory promotion

---

## Workflow Name

**Memory Ingestion Review** — Supervised review process for proposing, evaluating, and approving new memory sources before any ingestion into the RuVector semantic prototype.

---

## Capability Level

**L6** — Memory Operations. This workflow operates at the memory layer, one level above L5 (Agent Zero orchestration) and below L7 (Space Agent workspace).

---

## Purpose

Define a future supervised memory ingestion review process that:
- Receives and classifies proposed new memory sources
- Rejects Class D (denied) sources immediately
- Requires explicit human approval for Class C (future approval) sources
- Runs denied-data checks before any ingestion
- Creates manifests and rollback plans for every approved ingestion
- Validates post-ingestion quality against Stage 3A
- Never autonomously ingests memory
- Never promotes RuVector to production memory

This workflow is **documentation-only** for Phase 8B.2. No RuVector indexing or memory ingestion is performed in this phase.

---

## When to Use

- When a human proposes adding a new source to the memory index
- When evaluating whether a source should be indexed by RuVector
- When creating an ingestion proposal for review
- When reviewing a proposed source for approval/denial
- When planning a rollback for a previous ingestion

**Do not use when:**
- Request is for autonomous/unattended ingestion
- Request asks to bypass human approval
- Request asks for immediate production memory promotion
- Source is clearly Class D (denied) and user wants to override

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Proposed source path | Yes | Path or pattern to evaluate |
| Source class (if known) | No | A/B/C/D — if unknown, workflow will classify |
| Purpose/justification | Yes | Why this source is needed |
| Proposed by | Yes | Human or agent proposing |
| Storage path | No | Defaults to `~/.local/share/bazzite-security/ruvector/semantic-prototype/` |
| Embedding model | No | Defaults to `nomic-embed-text:latest` (768 dims) |
| Output format | No | Defaults to `docs/workflows/templates/memory-ingestion-review-template.md` |

---

## Approved Paths

These paths may be proposed for future ingestion:

| Path | Class | Purpose |
|------|-------|---------|
| `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md` | A | Approved knowledge docs (348 chunks already indexed) |
| `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | A | Stage 3A chunks (50 already indexed) |
| `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt` | A | Stage 4 eval/example metadata summaries |
| `~/projects/gem/docs/architecture/*.md` | A | Repo-local architecture docs (only when explicitly scoped) |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json` | B | Prototype metadata only |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json` | B | Embedding cache (metadata reference only) |
| Specific project docs (user-approved) | C | External project context (requires approval) |
| Sanitized OpenCode summaries | C | Implementation notes (requires approval) |
| Human-curated lessons learned | C | Learning data (requires approval) |
| `~/offload/security-reports/manual/*.md` | C | Workflow closeout reports (requires approval) |
| Sanitized issue/bug examples | C | Issue patterns (requires approval) |

---

## Denied Paths/Data

These paths and data types are **never** allowed for memory ingestion:

### File Types (Always Denied — Class D)
- `.env` files
- API keys and provider secrets
- Raw private logs
- Browser data (cookies, Local Storage, Session Storage, Trust Tokens)
- Provider state
- Private project code (unless future prompt explicitly approves a scoped repo path)
- Binary blobs
- Huge files (requires special approval)

### Directory Roots (Always Denied — Class D)
- `~/.cache/` — broad cache root
- `~/.config/` — broad config root
- `~/.local/share/` — broad local share root
- `~/projects/` — broad project root
- `~/offload/security-reports/` — broad reports root (use scoped `~/offload/security-reports/manual/` only)

### System/Component State (Always Denied — Class D)
- Agent Zero memory (`~/.local/share/agent-zero/memory/`)
- Space Agent config/state (`~/.config/space-agent/`)
- OpenCode transcripts (unredacted)
- Runtime logs from `~/.local/state/bazzite-security/logs/`

---

## Source Classification

Every proposed source must be classified into one of four classes:

### Class A — Approved Now
Sources that can be ingested without additional approval (already in approved scope).

| Source | Path | Purpose |
|--------|------|---------|
| Knowledge docs | `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md` | Bazzite system knowledge |
| Stage 3A chunks | `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | Deterministic RAG data |
| Eval metadata | `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt` | Stage 4 status summaries |
| Example metadata | `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt` | Stage 4 example summaries |
| Repo architecture docs | `~/projects/gem/docs/architecture/*.md` | When explicitly scoped |

**Rules:**
- Can be ingested after standard review
- Manifest required
- Rollback plan required
- Human approval still required for each ingestion

### Class B — Prototype Metadata Only
Sources that provide metadata about the prototype but are not user content.

| Source | Path | Purpose |
|--------|------|---------|
| Semantic manifests | `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json` | Index metadata |
| Embedding cache | `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json` | Embedding storage |

**Rules:**
- Read-only for metadata inspection
- Not for user content queries
- Not for semantic retrieval
- No ingestion needed — already present

### Class C — Future Approval Required
Sources that require explicit human approval before any use.

| Source | Path | Purpose |
|--------|------|---------|
| Specific project docs | `/path/to/project/docs/` | External project context |
| Sanitized OpenCode summaries | TBD | Summarized implementation notes |
| Human-curated lessons | TBD | Learned patterns |
| Workflow closeout reports | `~/offload/security-reports/manual/*.md` | When explicitly scoped |
| Sanitized bug examples | TBD | Issue patterns |
| Memory graph data | TBD | Relationship structures |
| Specific repo paths | User-approved | Scoped project code/docs |

**Rules:**
- Must propose via this ingestion review workflow
- Must get explicit human approval before ingestion
- Must create manifest
- Must plan rollback
- Default denial if human does not respond

### Class D — Denied
Sources that are never allowed for memory operations.

| Source | Reason |
|--------|--------|
| `.env` files | Contains secrets |
| API keys/secrets | Credentials |
| Raw private logs | Sensitive data |
| Browser data | Cookies, history, etc. |
| Cookies/Local Storage/Session Storage/Trust Tokens | Browser state |
| Provider state | API credentials |
| `~/.cache` | Cached data |
| Broad `~/.config` | System configs |
| Broad `~/.local/share` | User data |
| Broad `~/projects` | Multiple projects |
| Broad `~/offload/security-reports` | Reports contain sensitive data |
| Agent Zero memory | Runtime data |
| Space Agent config/state | User app data |
| Private code (unapproved) | Proprietary/unauthorized |

**Rules:**
- Never scan
- Never index
- Never ingest
- Block at proposal stage
- No override possible — not even by human

---

## Allowed Components/Tools

| Component | Role in This Workflow | Status |
|-----------|----------------------|--------|
| Human | Approval authority, source review, decision maker | Required at all key points |
| RuVector semantic prototype | Target for future ingestion (when approved) | Prototype-only, 398 chunks currently |
| Stage 3A RAG | Fallback validation after ingestion | Production, canonical fallback |
| OpenCode | Read-only file inspection for review | L3, human approval for edits |
| Gemma wrappers | Advisory only — summarize proposals | L1-L2, advisory only |
| Agent Zero | Not used — future orchestration only | L5, not in this phase |
| Space Agent | Not used — manual UI only | L7, not in this phase |

---

## Forbidden Actions

- No autonomous memory ingestion
- No bypassing human approval
- No Class D ingestion under any circumstance
- No broad filesystem indexing
- No production memory promotion
- No RuVector indexing in Phase 8B.2 (documentation-only)
- No Gemma synthesis without explicit request
- No secret/private data access
- No learning loop activation
- No Ollama/model config changes
- No package installs
- No writing runtime state into unrelated project roots

---

## Ingestion Proposal Flow

These steps define what a supervised ingestion review would do in a future phase:

### Step 1: Receive Proposed Source
- Accept source path or source class from human
- Record proposed source, timestamp, proposal ID
- Identify who proposed the source

### Step 2: Confirm User Intent
- Verify the purpose of the proposed source
- Understand why this source is needed
- Check if it replaces or supplements existing sources

### Step 3: Classify Source (Mandatory)
- Run classification against Class A/B/C/D (see `MEMORY_SOURCE_POLICY.md`)
- **Class A:** Proceed to denied-data check
- **Class B:** Metadata only — no ingestion needed, note and close
- **Class C:** Flag for human approval, proceed to denied-data check
- **Class D:** Reject immediately, stop review, report to human

### Step 4: Run Denied-Data Check (Mandatory)
- Scan proposed source for denied data patterns (see Denied-Data Check section)
- If denied data found: stop, reject, report reason to human
- If clean: proceed to manifest planning

### Step 5: Define Expected Files and Chunking Scope
- List all files to be ingested from the source
- Estimate chunk count (based on word count, ~100 words/chunk)
- Define chunking strategy
- Identify excluded paths within the source

### Step 6: Define Storage Path
- Default: `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
- Memory file: `semantic-approved-docs-memory.json` (or new name)
- Manifest file: `semantic-manifest-[timestamp].json`

### Step 7: Define Manifest Path and Content
- Create manifest with all required fields (see Manifest Requirements section)
- Store manifest in prototype directory
- Human review manifest before ingestion

### Step 8: Define Rollback/Reset Plan (Mandatory)
- Document previous index state
- Create step-by-step rollback procedure
- Identify backup/manifest path
- Define validation after rollback
- Confirm Stage 3A fallback still works

### Step 9: Define Validation Plan
- Plan post-ingestion query tests
- Plan Stage 3A comparison tests
- Plan quality gate checks (see `MEMORY_QUALITY_GATES.md`)
- Define pass/fail criteria

### Step 10: Require Human Approval Before Ingestion
- Present full proposal to human:
  - Source path and class
  - Denied-data check results
  - Expected files and chunk count
  - Storage and manifest paths
  - Rollback plan
  - Validation plan
- Human must explicitly approve or deny
- **No ingestion without explicit human approval**

### Step 11: Do Not Ingest in Review-Only Mode
- This workflow is review and planning only
- Actual ingestion happens in a separate execution phase
- Document the decision: APPROVED / DENIED / NEEDS MORE INFO

### Step 12: Report Final Decision
- Use `docs/workflows/templates/memory-ingestion-review-template.md`
- Save report to `~/offload/security-reports/manual/` (default)
- Or repo-local `reports/` only if human explicitly requests
- Include all evidence artifacts

---

## Denied-Data Check

The review **must** check for denied data before any ingestion is approved.

### Check Categories

#### 1. File Name Patterns
Scan for:
- `.env*` — environment files
- `*secret*` — secret files
- `*key*` — key files
- `*token*` — token files
- `*password*` — password files
- `*credential*` — credential files

#### 2. Content Terms
Scan file contents for:
- `api_key`, `api_secret`, `password`, `token`, `secret`
- Provider-specific terms: `openai`, `anthropic`, `gemini`, `google`, `openrouter`
- Auth terms: `bearer`, `authorization`, `x-api-key`

#### 3. Browser/State Data
- Cookies
- Local Storage
- Session Storage
- Trust Tokens
- Provider state files

#### 4. Raw Logs
- `*.log` files (unless explicitly sanitized and approved)
- System logs
- Application logs
- Runtime logs

#### 5. Binary Blobs
- Executables
- Images (unless explicitly approved as documentation)
- Compressed archives
- Database files

#### 6. Huge Files
- Files > 1MB (requires special approval)
- Files with > 10,000 words (will create too many chunks)

#### 7. Broad Directory Roots
- Scanning `~/projects/` broadly
- Scanning `~/offload/security-reports/` broadly
- Scanning `~/.cache/` broadly
- Scanning `~/.config/` broadly
- Scanning `~/.local/share/` broadly

#### 8. Private Code
- Source code outside approved scope
- Proprietary project code
- Unapproved repository paths

#### 9. Agent/System State
- Agent Zero memory files
- Space Agent config/state
- OpenCode unredacted transcripts
- Runtime state files

### Denied-Data Check Result

If denied data is found:
- **STOP** the review immediately
- **Classify** the source as Class D (denied)
- **Do NOT** partially ingest — all or nothing
- **Report** the reason to human:
  ```
  Denied-data check FAILED
  Source: [path]
  Issue(s) found: [list]
  Classification: Class D (Denied)
  Action: REJECTED — no ingestion possible
  ```

If denied data is NOT found:
- **Mark** check as PASSED
- **Proceed** to manifest planning
- **Note** in report: "Denied-data check: PASSED"

---

## Manifest Requirements

Every future ingestion **must** have a manifest containing:

| Field | Description | Example | Required |
|-------|-------------|---------|----------|
| `input_source` | Path to indexed source | `~/.local/share/bazzite-security/gemma-knowledge/docs/` | Yes |
| `source_class` | Class A/B/C (D is rejected) | `A` | Yes |
| `approved_by` | Human who approved | `Human` | Yes |
| `timestamp` | Ingestion time | `2026-04-30T22:40:26Z` | Yes |
| `file_count` | Number of files indexed | `15` | Yes |
| `chunk_count` | Number of chunks indexed | `348` | Yes |
| `excluded_paths` | Paths not indexed | `[~/.cache, ~/.config]` | Yes |
| `embedding_model` | Model used | `nomic-embed-text:latest` | Yes |
| `embedding_dimensions` | Vector dimensions | `768` | Yes |
| `storage_path` | Where index is stored | `~/.local/share/bazzite-security/ruvector/semantic-prototype/` | Yes |
| `fallback_status` | Fallback availability | `Stage 3A available` | Yes |
| `rollback_path` | How to undo | `Restore semantic-manifest-*.json` | Yes |
| `validation_commands` | How to verify | `Run test queries` | Yes |
| `notes` | Additional context | `Added new feature docs` | No |
| `uncertainty` | Known limitations | `Large files may need chunking review` | No |

### Manifest Example

```json
{
  "input_source": "~/.local/share/bazzite-security/gemma-knowledge/docs/",
  "source_class": "A",
  "approved_by": "Human",
  "timestamp": "2026-04-30T22:40:26Z",
  "file_count": 15,
  "chunk_count": 348,
  "excluded_paths": ["~/.cache", "~/.config"],
  "embedding_model": "nomic-embed-text:latest",
  "embedding_dimensions": 768,
  "storage_path": "~/.local/share/bazzite-security/ruvector/semantic-prototype/",
  "fallback_status": "Stage 3A available",
  "rollback_path": "Restore from semantic-manifest-1777588808185.json",
  "validation_commands": ["Run test queries", "Compare with Stage 3A", "Check quality gates"],
  "notes": "Phase 7B.2 initial index"
}
```

---

## Rollback Requirements

Every future ingestion **must** have a documented rollback plan.

### Required Rollback Information

| Item | Description | Example |
|------|-------------|---------|
| Previous index location | What existed before | `semantic-manifest-1777588808185.json` (348 chunks) |
| New index location | What was added | `semantic-manifest-1777588824357.json` (398 chunks) |
| Backup/manifest path | Where backups live | `~/.local/share/bazzite-security/ruvector/semantic-prototype/` |
| Reset command | How to restore | `Restore previous manifest and memory file` |
| Manual reset steps | Step-by-step undo | `1. Remove new chunks, 2. Restore old index` |
| Validation after rollback | How to verify | `Run query, confirm new chunks gone` |
| Fallback confirmation | Stage 3A still works | `Stage 3A returns results as before` |

### Rollback Plan Template

```
## Rollback Plan for [Source]

### Previous State
- Index: [previous manifest file]
- Chunk count: [N]
- Manifest: [previous manifest path]

### New State (To Be Rolled Back)
- Index: [new manifest file]
- Chunk count: [N]
- Added: [description of what was added]

### Rollback Steps
1. [Step 1: Remove new index]
2. [Step 2: Restore previous index]
3. [Step 3: Verify rollback]

### Validation After Rollback
- [ ] Run test query — new source not in results
- [ ] Stage 3A still returns expected results
- [ ] Manifest reflects previous state

### Fallback Confirmation
- [ ] Stage 3A available and working
- [ ] No degradation in deterministic retrieval
```

---

## Validation Steps

After ingestion is approved and executed (future phase), validate:

### 1. Denied-Data Check Completed
- [ ] Scan completed before ingestion
- [ ] No `.env` files, API keys, or secrets in ingested source
- [ ] No raw logs, browser data, or private code
- [ ] All sources within approved paths

### 2. Manifest Created and Complete
- [ ] All required fields populated
- [ ] Manifest is parseable JSON
- [ ] Manifest stored in prototype directory
- [ ] `source_class` is A, B, or C (not D)

### 3. Rollback Plan Documented
- [ ] Previous state documented
- [ ] Rollback steps are testable
- [ ] Human can execute without AI assistance
- [ ] Fallback confirmation included

### 4. Post-Ingestion Tests Passed
- [ ] Run test queries — new source appears in results
- [ ] Run Stage 3A comparison — ≥70% overlap for informational queries
- [ ] Disagreements are documented and explainable
- [ ] No factually wrong results from new source

### 5. Quality Gates Checked
- [ ] Gate 1: Stage 3A comparison passing
- [ ] Gate 2: Stage 4 validators passing (`gemma-evals-status`, `gemma-evals-check`, `gemma-examples-check`)
- [ ] Gate 3: Semantic quality evaluated
- [ ] Gate 4: Source spot-check passing
- [ ] Gate 6: All indexes have manifests
- [ ] Gate 7: Rollback plans documented

### 6. No Autonomous Actions
- [ ] Ingestion was supervised — human approved
- [ ] No autonomous learning loop activated
- [ ] No production memory promotion occurred
- [ ] RuVector remains prototype-only

### 7. Standard Validators Pass
```bash
gemma-evals-status    # Must be PASS
gemma-evals-check     # Must be PASS
gemma-examples-check # Must be PASS
```

---

## Evidence Artifacts

Future workflow execution reports should include:

### Required Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| Ingestion review | Markdown using `memory-ingestion-review-template.md` | `~/offload/security-reports/manual/` |
| Denied-data check results | Embedded in review | Within report |
| Manifest (draft) | JSON | `~/.local/share/bazzite-security/ruvector/semantic-prototype/` |
| Rollback plan | Embedded in review | Within report |
| Validation plan | Embedded in review | Within report |

### Optional Artifacts

| Artifact | Format | Location |
|----------|--------|----------|
| Gemma summary of proposal | Section in review | Within report |
| Human approval note | Metadata in review | Within report |
| Follow-up actions | Final decision section | Within report |

### Repo-Local Reports

Repo-local reports (in `reports/`) are **only** allowed if the human explicitly asks for persistent repo documentation. Default output is `~/offload/security-reports/manual/`.

---

## Fallback Path

The fallback chain is always available:

```
Proposed Ingestion
      │
      ▼
Denied-Data Check ───► If FAILED: Reject (Class D)
      │
      ▼ (PASSED)
Manifest + Rollback Plan
      │
      ▼
Human Approval ───► If DENIED: Close review
      │
      ▼ (APPROVED)
Future Ingestion Execution
      │
      ▼
Post-Ingestion Validation
      │
      ▼ (if issues)
Stage 3A Fallback (always available)
```

**Rules:**
- Stage 3A is **always** available as canonical fallback
- If ingested source causes issues, roll back and use Stage 3A
- If quality gates fail, do not promote to production
- RuVector remains prototype until all gates pass

---

## Stop Conditions

The workflow **must stop immediately** if any of these conditions are met:

| # | Stop Condition | Action |
|---|------------------|--------|
| 1 | Source classified as Class D | Reject immediately, do not ingest, report to human |
| 2 | Source contains secrets or credentials | Reject, report contents of denied-data check |
| 3 | Source requires broad filesystem indexing | Reject, suggest scoped alternative |
| 4 | Source includes raw logs/browser data/provider state | Reject, Class D |
| 5 | No rollback plan exists | Do not approve, request rollback plan |
| 6 | No manifest plan exists | Do not approve, request manifest |
| 7 | User asks for autonomous ingestion | Block, explain supervised-only |
| 8 | User asks to ingest private code without explicit scoped approval | Reject, request proper approval |
| 9 | Stage 3A fallback is unavailable | Stop, investigate Stage 3A issue |
| 10 | RuVector semantic prototype is stale or missing | Update prototype before ingestion |
| 11 | User asks to promote production memory without quality gates | Block, explain 8 quality gates |
| 12 | Human does not respond to approval request | Default to DENY |

---

## Human Approval Points

Human approval is **required** at these points:

| # | Approval Point | When | Can Override |
|---|-----------------|------|---------------|
| 1 | Source classification | After Class A/B/C/D assigned | Class D: NEVER override |
| 2 | Class C source scope | Before proceeding with review | No override for unapproved Class C |
| 3 | Denied-data review result | After scan completed | NEVER override if denied data found |
| 4 | Storage path approval | Before manifest creation | Yes, with justification |
| 5 | Rollback plan approval | Before ingestion approval | No ingestion without rollback plan |
| 6 | Validation plan approval | Before ingestion approval | Yes, if plan is sufficient |
| 7 | Actual ingestion execution | Final gate | NO ingestion without explicit approval |
| 8 | Production promotion | Not in this phase | NEVER in Phase 8B |

---

## Expected Final Response Format

The workflow output should follow `docs/workflows/templates/memory-ingestion-review-template.md`:

```markdown
# Memory Ingestion Review

## Proposed Source

### Basic Information
- **Source path:** [path to source]
- **Source class:** [A / B / C / D]
- **Purpose:** [why this source is needed]
- **Proposed by:** [who proposed]
- **Date proposed:** [ISO date]

## Approval Status

| Check | Status | Notes |
|-------|--------|-------|
| Class A (Approved Now) | [ ] | |
| Class B (Prototype Metadata) | [ ] | |
| Class C (Future Approval) | [ ] | Requires human approval |
| Class D (Denied) | [ ] | Cannot proceed |

## Denied Data Check

### Exclusion Verification
- [ ] No .env files present
- [ ] No API keys/secrets in files
- [ ] No raw private logs
- [ ] No browser data
- [ ] No cookies/Local Storage/Session Storage/Trust Tokens
- [ ] No provider state
- [ ] No private code outside approved scope

### Scan Results
- Files scanned: [N]
- Files excluded: [list if any]
- Issues found: [list if any]

## Expected Files

### File List
| File | Size | Type | Approved |
|------|------|------|----------|
| [file 1] | [size] | [type] | [ ] |

### Expected Chunk Count
- Estimated chunks: [N]
- Based on: [calculation method]

## Storage Path

- **Primary storage:** `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
- **Memory file:** [filename]
- **Manifest file:** [manifest filename]

## Manifest Path

### Required Manifest Fields

| Field | Value | Status |
|-------|-------|--------|
| input_source | [path] | [ ] |
| chunk_count | [N] | [ ] |
| embedding_model | nomic-embed-text:latest | [ ] |
| embedding_dimensions | 768 | [ ] |
| timestamp | [date] | [ ] |
| excluded_paths | [list] | [ ] |
| fallback_status | Stage 3A available | [ ] |

## Rollback Plan

### Previous State
- What existed before: [description]
- Index version: [version]

### Rollback Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Verification
- How to verify rollback: [method]

### Fallback Method
- How to use Stage 3A instead: [method]

## Validation Plan

### Post-Ingestion Tests
| Test | Method | Pass Criteria |
|------|--------|----------------|
| Query test | Run test queries | Results include new source |
| Stage 3A comparison | Compare semantic vs deterministic | ≥70% overlap |
| Quality gate check | Verify against Stage 4 | All passing |

## Human Approval

### Approval Request
- **Requested by:** [name]
- **Requested date:** [date]
- **Decision pending:** [ ]

### Approval Decision

| Role | Decision | Date | Notes |
|------|----------|------|-------|
| Human reviewer | [APPROVE / DENY / REQUEST MORE INFO] | [date] | [notes] |

### Final Decision
```
[APPROVED] - Proceed with ingestion
[DENIED] - Do not proceed
[NEEDS MORE INFO] - Additional information required before decision
```

## Post-Approval Actions

If approved:
- [ ] Create manifest
- [ ] Run indexer
- [ ] Verify query works
- [ ] Run Stage 3A comparison
- [ ] Document results

If denied:
- [ ] Document denial reason
- [ ] Notify proposer
- [ ] Close review
```

---

## Example Ingestion Review Output Outline

For a Class A proposal: adding `new-feature.md` to knowledge docs:

```
Proposed Source: ~/.local/share/bazzite-security/gemma-knowledge/docs/new-feature.md
Source Class: A — Approved Now
Purpose: Add new Bazzite feature documentation

Denied Data Check:
  PASSED — no .env, no secrets, no logs, no browser data
  Files scanned: 1
  Issues found: None

Expected:
  Files: 1 (new-feature.md, ~2KB)
  Estimated chunks: 3-5

Storage:
  Memory file: semantic-approved-docs-memory.json
  Manifest: semantic-manifest-20260430.json

Manifest:
  input_source: ~/.local/share/bazzite-security/gemma-knowledge/docs/new-feature.md
  chunk_count: 4 (estimated)
  embedding_model: nomic-embed-text:latest
  embedding_dimensions: 768

Rollback Plan:
  Previous: 398 chunks (manifest-1777588824357.json)
  Steps: 1. Remove new-feature.md chunks, 2. Restore previous manifest

Human Approval:
  Decision: APPROVED (2026-04-30)
  Reason: Class A source, denied-data check passed

Final Decision:
  APPROVED — Proceed with ingestion
```

---

## Relationship to Other Workflows

| Workflow | Relationship |
|-----------|--------------|
| `MEMORY_WORKFLOW_LIBRARY.md` (Workflow 2) | This workflow implements the "Memory Ingestion Review" category |
| `WORKFLOW_8B1_MEMORY_QUERY.md` | Query insights may trigger ingestion proposals; queries do not ingest |
| `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` | Quality gates validate ingestion quality post-approval |
| `WORKFLOW_8A2_VALIDATION_ORCHESTRATION.md` | Validators must pass before and after ingestion |

---

## Validation Commands

```bash
# Verify workflow doc exists
test -f docs/workflows/memory/WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md

# Verify template exists
test -f docs/workflows/templates/memory-ingestion-review-template.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check

# Check no ingestion occurred in Phase 8B.2
# (no RuVector indexer scripts were run)
```

---

## Related Documents

- `MEMORY_WORKFLOW_LIBRARY.md` — Workflow categories (Workflow 2: Memory Ingestion Review)
- `MEMORY_BOUNDARIES.md` — Prototype boundaries, source classes
- `MEMORY_SOURCE_POLICY.md` — Source class definitions (A/B/C/D)
- `MEMORY_QUALITY_GATES.md` — 8 quality gates for production promotion
- `docs/workflows/templates/memory-ingestion-review-template.md` — Review template
- `docs/integrations/ruvector/RUVECTOR_PHASE7B2_SEMANTIC_PROTOTYPE_REPORT.md` — Prototype status
- `docs/roadmap/ROADMAP.md` — Phase 8B.2 status

---

*Workflow version: 1.0*
*Phase: 8B.2*
*Status: Documentation-only — no RuVector indexing or memory ingestion in this phase*
*RuVector status: Prototype-only, 398 chunks (348 approved-doc + 50 Stage 3A), nomic-embed-text:latest, 768 dims*

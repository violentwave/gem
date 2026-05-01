# Workflow 8B.1: Memory Query with Stage 3A Comparison

**Phase:** 8B.1
**Capability Level:** L6 (Memory Operations)
**Status:** Documentation-only workflow definition
**Production status:** RuVector remains prototype-only; no production memory promotion

---

## Workflow Name

**Memory Query with Stage 3A Comparison** — Semantic context lookup using the RuVector semantic prototype with mandatory Stage 3A deterministic fallback comparison.

---

## Purpose

Define a future supervised memory query process that:
- Retrieves context from the RuVector semantic prototype (when available)
- Mandatory compares results against Stage 3A deterministic retrieval
- Classifies agreement/disagreement with explicit criteria
- Routes output to human for review and approval
- Never ingests new memory or promotes RuVector to production

This workflow is **documentation-only** for Phase 8B.1. No RuVector queries are executed in this phase.

---

## When to Use

- When a future operator needs contextual information from approved knowledge sources
- When building context for a briefing, report, or advisory response
- When validating RuVector semantic retrieval quality against Stage 3A
- When preparing evidence for memory ingestion decisions
- When a human explicitly requests a memory query with comparison

**Do not use when:**
- Query requests secrets, private data, or denied paths
- Query requires broad filesystem indexing
- User asks for autonomous action instead of retrieval
- User asks for production memory promotion

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Query string | Yes | Natural language search query |
| Scope | Yes | Must be "approved sources only" or explicit scoped path |
| Stage 3A comparison | Yes | Always required — never skip |
| Gemma synthesis | No | Only if explicitly requested after retrieval |
| Output format | No | Defaults to `docs/workflows/templates/memory-query-output-template.md` |

---

## Approved Paths

These paths may be queried in a future workflow execution phase:

| Path | Purpose | Access |
|------|---------|--------|
| `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md` | Approved knowledge docs (348 chunks indexed) | Query via RuVector or Stage 3A |
| `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | Stage 3A chunk index | Stage 3A deterministic query |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json` | Semantic index manifests | Metadata/cache reference only |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` | Semantic prototype index | Query use only in future execution phase |
| `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json` | Embedding cache | Metadata/cache reference only |
| `~/offload/security-reports/manual/` | Future query reports | Output location for manual reports |
| `docs/workflows/templates/memory-query-output-template.md` | Output template | Template reference |

---

## Denied Paths/Data

These paths and data types are **never** allowed in memory queries:

### File Types (Always Denied)
- `.env` files
- API keys and provider secrets
- Raw private logs
- Browser data (cookies, Local Storage, Session Storage, Trust Tokens)
- Provider state
- Private project code (unless future prompt explicitly approves a scoped repo path)

### Directory Roots (Always Denied)
- `~/.cache/` — broad cache root
- `~/.config/` — broad config root
- `~/.local/share/` — broad local share root
- `~/projects/` — broad project root
- `~/offload/security-reports/` — broad reports root (use scoped `~/offload/security-reports/manual/` only)

### System/Component State (Always Denied)
- Agent Zero memory
- Space Agent config/state
- OpenCode transcripts (unredacted)
- Runtime logs from `~/.local/state/bazzite-security/logs/`

---

## Allowed Components/Tools

| Component | Role in This Workflow | Status |
|-----------|----------------------|--------|
| RuVector semantic prototype | Semantic memory lookup (future execution) | Prototype-only, 398 chunks indexed |
| Stage 3A RAG | Deterministic keyword fallback (mandatory) | Production, canonical fallback |
| Gemma wrappers | Optional synthesis after retrieval | Advisory only, L1-L2 |
| OpenCode | Implementation work, repo edits | L3, human approval required |
| Human | Approval authority, result review | Required at all key points |

---

## Forbidden Actions

- No autonomous memory ingestion
- No broad filesystem indexing
- No production memory promotion
- No RuVector query execution in Phase 8B.1 (documentation-only)
- No Gemma synthesis unless explicitly requested after retrieval completes
- No secret/private data access
- No learning loop activation
- No Ollama/model config changes
- No package installs
- No writing runtime state into unrelated project roots

---

## Execution Steps (Future Workflow)

These steps define what a supervised workflow execution would do in a future phase:

1. **Receive query**
   - Accept natural language query from human
   - Record query string, timestamp, query ID

2. **Confirm query scope and source class**
   - Identify which sources the query targets
   - Classify sources against Class A/B/C/D (see `MEMORY_SOURCE_POLICY.md`)
   - Flag any Class C sources for human approval
   - Block any Class D sources immediately

3. **Confirm query is allowed**
   - Run denied data check against query string and scope
   - Verify no secrets, `.env`, raw logs, browser data requested
   - Verify no broad root indexing requested
   - Escalate to human if uncertain

4. **Run RuVector semantic prototype query (if available)**
   - Query the semantic prototype at `~/.local/share/bazzite-security/ruvector/semantic-prototype/`
   - Embedding model: `nomic-embed-text:latest` (768 dimensions)
   - Return top semantic matches with relevance scores
   - Include source paths and key excerpts
   - **Skip in Phase 8B.1** — documentation-only

5. **Run Stage 3A deterministic query (mandatory)**
   - Query Stage 3A JSONL index at `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
   - Use equivalent keyword wording from the original query
   - Return top deterministic matches with keyword matches
   - Include source paths and key excerpts
   - **Always available** — canonical fallback

6. **Compare sources and headings**
   - Extract source filenames from both result sets
   - Calculate filename overlap (see Comparison Criteria below)
   - Compare heading/topic overlap
   - Identify which sources are from approved docs vs Stage 3A chunks

7. **Classify agreement** (see Agreement/Disagreement Handling below)
   - Strong agreement
   - Partial agreement
   - Weak agreement
   - Contradiction
   - Insufficient evidence

8. **Identify top sources from both systems**
   - List top 5 from RuVector (if available)
   - List top 5 from Stage 3A
   - Note which sources appear in both

9. **Optionally request Gemma synthesis (only if explicitly requested)**
   - Provide retrieved context to Gemma wrapper
   - Request synthesis/summary
   - Include uncertainty notes
   - Note that Gemma is advisory only

10. **Include uncertainty and fallback notes**
    - Note if RuVector data is missing or stale
    - Note if Stage 3A fallback was primary
    - Note any contradictory results

11. **Report to human**
    - Use `docs/workflows/templates/memory-query-output-template.md`
    - Save report to `~/offload/security-reports/manual/` (default)
    - Or repo-local `reports/` only if human explicitly requests persistent documentation
    - Include all evidence artifacts

12. **Never ingest new memory**
    - This workflow retrieves only
    - Any ingestion requires separate workflow with human approval

13. **Never promote RuVector to primary production memory**
    - RuVector remains prototype-only
    - Stage 3A remains canonical fallback
    - Promotion requires all 8 quality gates (see `MEMORY_QUALITY_GATES.md`)

---

## Stage 3A Comparison Logic

Every memory query **must** be compared against Stage 3A deterministic retrieval. This is not optional.

### Comparison Steps

1. **Run equivalent queries**
   - Same query string through RuVector (semantic)
   - Same intent, keyword-extracted version through Stage 3A (deterministic)

2. **Extract result sets**
   - RuVector: top N results with relevance scores
   - Stage 3A: top N results with keyword matches

3. **Calculate source filename overlap**
   ```
   overlap_percentage = (common_filenames / total_unique_filenames) * 100
   ```
   - Note: overlap percentage alone is not enough — source relevance matters

4. **Compare heading/topic overlap**
   - Extract headings from both result sets
   - Identify matching topics
   - Note semantic matches that Stage 3A missed
   - Note Stage 3A matches that RuVector missed

5. **Classify each source**
   - Is it from an approved doc? (Class A)
   - Is it from a Stage 3A chunk? (Indexed in prototype)
   - Is it from a denied source? (Block immediately)

6. **Determine which system found stronger sources**
   - Did Stage 3A find more authoritative sources?
   - Did RuVector find useful semantic context missed by Stage 3A?
   - Are results contradictory on key facts?

---

## Agreement/Disagreement Handling

### Classification Criteria

| Classification | Criteria | Action |
|--------------|----------|--------|
| **Strong agreement** | ≥ 70% filename overlap, same key facts, no contradictions | Use either source; report consensus |
| **Partial agreement** | 40-69% overlap, most facts align, minor differences | Note differences; prefer Stage 3A for facts |
| **Weak agreement** | 10-39% overlap, some facts align, notable differences | Human spot-check required; explain differences |
| **Contradiction** | Same query, opposing facts from both systems | Escalate to human immediately; block promotion |
| **Insufficient evidence** | Both systems return < 3 relevant results | Expand query; try different wording; human review |

### Disagreement Response

When RuVector and Stage 3A disagree:

1. **Identify the point of disagreement**
   - Which fact is contradicted?
   - Which source is more authoritative?

2. **Check source class**
   - Prefer Class A (approved docs) over indexed chunks
   - Prefer Stage 3A if it returns the authoritative source

3. **Human spot-check**
   - Flag contradictory results for human review
   - Provide both excerpts side-by-side
   - Do not synthesize contradictory facts

4. **Escalate if needed**
   - If contradiction involves critical claims → stop and escalate
   - If disagreement is minor → note and continue

---

## Source Relevance Criteria

Source relevance is **not** just about overlap percentage. A query can have 100% overlap but irrelevant sources.

### Relevance Factors

| Factor | Weight | Description |
|--------|--------|-------------|
| Filename match | Medium | Does the filename relate to the query topic? |
| Heading/topic match | High | Does the section heading match query intent? |
| Content relevance | High | Does the excerpt answer the query? |
| Source authority | High | Is this the canonical source for this topic? |
| Recency | Low | Is the source up-to-date? (less critical for system docs) |

### Relevance Check

For each top result, verify:
- [ ] Source is from an approved path
- [ ] Source heading relates to query topic
- [ ] Excerpt contains query-relevant information
- [ ] Source is not from a denied class

### Overlap Is Not Enough

> **Source overlap alone is not enough.** Semantic retrieval must demonstrate value beyond what Stage 3A already provides. A 90% overlap with irrelevant sources is worse than a 30% overlap with highly relevant sources.

Always check:
- Did RuVector find something Stage 3A missed that is actually useful?
- Did Stage 3A return a more authoritative source on the same topic?
- Are the overlapping sources actually relevant to the query?

---

## Validation Steps

After query execution (future phase), validate:

1. **Denied data check**
   - [ ] No Class D sources in results
   - [ ] No secrets, `.env`, raw logs, browser data
   - [ ] All sources within approved paths

2. **Stage 3A comparison completed**
   - [ ] Both queries ran with equivalent intent
   - [ ] Overlap calculated
   - [ ] Agreement classified
   - [ ] Differences documented

3. **Source relevance verified**
   - [ ] Top sources are relevant to query
   - [ ] Human spot-check performed if weak agreement
   - [ ] Contradictions escalated

4. **No ingestion performed**
   - [ ] No new sources indexed during query
   - [ ] No memory promotion occurred
   - [ ] RuVector remains prototype-only

5. **No autonomous actions**
   - [ ] Query only — no fixes, no edits, no changes
   - [ ] Human approval captured for any follow-up

6. **Standard validators pass**
   ```bash
   gemma-evals-status   # Must be PASS
   gemma-evals-check    # Must be PASS
   gemma-examples-check # Must be PASS
   ```

---

## Evidence Artifacts

Future workflow execution reports should include:

### Required Artifacts

| Artifact | Format | Location |
|-----------|--------|----------|
| Query output | Markdown using `memory-query-output-template.md` | `~/offload/security-reports/manual/` |
| RuVector results | Embedded in query output | Within report |
| Stage 3A results | Embedded in query output | Within report |
| Comparison analysis | Embedded in query output | Within report |
| Source list | Table in query output | Within report |

### Optional Artifacts

| Artifact | Format | Location |
|-----------|--------|----------|
| Gemma synthesis | Section in query output | Within report |
| Human approval note | Metadata in query output | Within report |
| Follow-up actions | Recommended next steps section | Within report |

### Repo-Local Reports

Repo-local reports (in `reports/`) are **only** allowed if the human explicitly asks for persistent repo documentation. Default output is `~/offload/security-reports/manual/`.

---

## Fallback Path

The fallback chain is always available:

```
RuVector Semantic Query (if available)
        │
        │ (if unavailable, errors, or stale)
        ▼
Stage 3A Deterministic Query (always available)
        │
        │ (if still insufficient)
        ▼
Human Recall / Manual Lookup
```

**Rules:**
- Stage 3A is **always** available as canonical fallback
- If RuVector data is missing or stale, use Stage 3A only
- If RuVector and Stage 3A strongly disagree, escalate to human
- Never leave a query without results if Stage 3A can answer it

---

## Stop Conditions

The workflow must stop immediately if any of these conditions are met:

| # | Stop Condition | Action |
|---|------------------|--------|
| 1 | Query requests secrets/private data | Block query, explain denial to human |
| 2 | Query requires broad filesystem indexing | Block query, suggest scoped alternative |
| 3 | Query asks to ingest new source data without approval | Block ingestion, route to ingestion review workflow |
| 4 | RuVector and Stage 3A strongly disagree on critical claims | Stop, escalate to human with side-by-side comparison |
| 5 | Retrieved sources are outside approved paths | Discard results, report violation |
| 6 | Semantic prototype data missing or stale | Fall back to Stage 3A only, note in report |
| 7 | Stage 3A fallback unavailable | Stop, escalate to human |
| 8 | User asks for production memory promotion | Block, explain quality gates not yet passed |
| 9 | User asks for autonomous action instead of retrieval | Block, explain retrieval-only scope |
| 10 | Overlap < 10% and both systems return irrelevant results | Expand query, try different wording |

---

## Human Approval Points

Human approval is **required** at these points:

| # | Approval Point | When |
|---|-----------------|------|
| 1 | Query scope approval | Before any query execution if Class C sources are involved |
| 2 | Denied data override | Never allowed — no override for Class D |
| 3 | Gemma synthesis request | Before providing context to Gemma wrappers |
| 4 | Contradiction resolution | When RuVector and Stage 3A strongly disagree |
| 5 | Report review | After query output is generated |
| 6 | Follow-up actions | Before any action beyond retrieval |
| 7 | Repo-local report | Before saving report in `reports/` instead of `~/offload/security-reports/manual/` |

---

## Expected Final Response Format

The workflow output should follow `docs/workflows/templates/memory-query-output-template.md`:

```markdown
# Memory Query Output

## Query
- **Query string:** [the search query]
- **Date:** [ISO date]
- **Scope:** [approved sources only / custom]

## RuVector Results
### Semantic Matches
| Rank | Source | Relevance Score |
|------|--------|------------------|
| 1    | [file path] | [score] |

### Key Excerpts
- [Relevant excerpt 1]

## Stage 3A Fallback Results
### Deterministic Matches
| Rank | Source | Keywords Matched |
|------|--------|------------------|
| 1    | [file path] | [keyword 1], [keyword 2] |

### Key Excerpts
- [Relevant excerpt 1]

## Comparison
### Agreement
- **[Strong / Partial / Weak / Contradiction / Insufficient Evidence]**

### Points of Agreement
- [List key points where both methods returned similar results]

### Points of Difference
- [List key points where methods diverged]
- [Explain why divergence may exist]

### Quality Assessment
- RuVector provided [more relevant / less relevant / similar] results than Stage 3A
- [Specific example of semantic advantage or shortcoming]

## Sources Used
| Source | Type | Used By |
|--------|------|---------|
| [path] | Approved | Both |

## Gemma Synthesis
[If requested and approved — advisory only]

## Uncertainty
### Ambiguous Areas
- [Any areas where results are unclear]

### Recommendations
- [Suggest additional search terms]
- [Suggest human review]

## Stop Conditions Triggered
- [ ] Query touched denied paths
- [ ] RuVector unavailable — used Stage 3A only
- [ ] Results fundamentally disagree — escalated to human
- [x] None triggered

## Recommended Next Step
- **[Use RuVector / Use Stage 3A / Escalate to human]** — [rationale]

## Metadata
- **Query ID:** [unique ID]
- **Workflow:** 8B.1 Memory Query
- **Generated by:** [component]
- **Reviewed by:** [human or "pending"]
```

---

## Example Memory Query Output Outline

For a query like *"What firewall tool does Bazzite use?"*:

```
Query: "What firewall tool does Bazzite use?"
Scope: Approved sources only
Date: 2026-04-30

RuVector Results (Top 3):
  1. FINAL_POLICY.md — score 0.92
   Excerpt: "Bazzite uses firewalld, not ufw"
  2. OPERATIONS.md — score 0.87
   Excerpt: "Configure firewall with firewall-cmd"
  3. STAGE3A_CHUNK_042 — score 0.81
   Excerpt: "firewalld is the default on Fedora Atomic"

Stage 3A Results (Top 3):
  1. FINAL_POLICY.md — keywords: firewall, Bazzite
   Excerpt: "Bazzite uses firewalld, not ufw"
  2. OPERATIONS.md — keywords: firewall, configure
   Excerpt: "Use firewall-cmd for configuration"

Comparison:
  Agreement: Strong (both return FINAL_POLICY.md as top result)
  Overlap: 2/3 filenames in common (FINAL_POLICY.md, OPERATIONS.md)
  RuVector advantage: Found STAGE3A_CHUNK_042 semantically

Quality Label: strong_agreement
Gemma Synthesis: Not requested
Stop Conditions: None triggered
Next Step: Use either RuVector or Stage 3A — both return consistent answer
```

---

## Quality Labels for Query Output

Classify each memory query output as one of:

| Label | Meaning | Action |
|-------|---------|--------|
| `high_confidence_supported` | Both systems agree, sources are approved, high relevance | Use result confidently |
| `supported_with_partial_overlap` | Agreement exists but some differences, still useful | Note differences, use with caution |
| `semantic_useful_but_stage3a_stronger` | RuVector found context but Stage 3A has more authoritative source | Prefer Stage 3A for facts |
| `stage3a_only` | RuVector unavailable or returned nothing useful; Stage 3A carries the answer | Use Stage 3A result |
| `ruvector_only_needs_review` | RuVector returned results but Stage 3A did not; human review needed | Do not trust without verification |
| `insufficient_evidence` | Both systems returned < 3 relevant results | Expand query or try different wording |
| `blocked_denied_scope` | Query touched denied paths or requested private data | Blocked — see stop conditions |

---

## Relationship to Other Workflows

| Workflow | Relationship |
|-----------|--------------|
| `MEMORY_WORKFLOW_LIBRARY.md` (Workflow 1) | This workflow implements the "Semantic Context Lookup" category |
| `WORKFLOW_8B2_MEMORY_INGESTION_REVIEW.md` | Ingestion proposals come from query insights; queries do not trigger ingestion |
| `WORKFLOW_8B3_MEMORY_QUALITY_VALIDATION.md` | Quality gates validate retrieval quality from this workflow |
| `WORKFLOW_8A1_REPO_BRIEFING.md` | May use memory queries for repo context |
| `WORKFLOW_8A2_VALIDATION_ORCHESTRATION.md` | Validators must pass before/after memory queries |

---

## Validation Commands

```bash
# Verify workflow doc exists
test -f docs/workflows/memory/WORKFLOW_8B1_MEMORY_QUERY.md

# Verify template exists
test -f docs/workflows/templates/memory-query-output-template.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check

# Check no execution occurred in Phase 8B.1
# (no RuVector query scripts were run)
```

---

## Related Documents

- `MEMORY_WORKFLOW_LIBRARY.md` — Workflow categories (Workflow 1: Semantic Context Lookup)
- `MEMORY_BOUNDARIES.md` — Prototype boundaries, source classes
- `MEMORY_SOURCE_POLICY.md` — Source class definitions (A/B/C/D)
- `MEMORY_QUALITY_GATES.md` — 8 quality gates for production promotion
- `docs/workflows/templates/memory-query-output-template.md` — Output template
- `docs/integrations/ruvector/RUVECTOR_PHASE7B2_SEMANTIC_PROTOTYPE_REPORT.md` — Prototype status
- `docs/architecture/COMPONENT_ROUTING_MATRIX.md` — Component responsibilities
- `docs/roadmap/ROADMAP.md` — Phase 8B.1 status

---

*Workflow version: 1.0*
*Phase: 8B.1*
*Status: Documentation-only — no RuVector query execution*
*RuVector status: Prototype-only, 398 chunks (348 approved-doc + 50 Stage 3A), nomic-embed-text:latest, 768 dims*

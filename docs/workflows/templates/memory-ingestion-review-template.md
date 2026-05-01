# Memory Ingestion Review Template

**Phase:** 8B
**Purpose:** Reusable template for reviewing memory ingestion proposals

---

## Template Structure

```markdown
# Memory Ingestion Review

## Proposed Source

### Basic Information
- **Source path:** [path to source]
- **Source class:** [A - Approved Now / B - Prototype Metadata / C - Future Approval Required]
- **Purpose:** [why this source is needed]
- **Proposed by:** [who proposed]
- **Date proposed:** [ISO date]

### Source Classification Justification
- [Explain why this source fits the classification]

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
| [file 2] | [size] | [type] | [ ] |
| [file N] | [size] | [type] | [ ] |

### Expected Chunk Count
- Estimated chunks: [N]
- Based on: [calculation method]

## Storage Path

- **Primary storage:** ~/.local/share/bazzite-security/ruvector/semantic-prototype/
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
| Query test | Run test queries | Results returned |
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
| Human reviewer | [Approve / Deny / Request more info] | [date] | [notes] |

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

---

## Example: Approved Class A Source

```markdown
# Memory Ingestion Review

## Proposed Source

### Basic Information
- **Source path:** ~/.local/share/bazzite-security/gemma-knowledge/docs/new-feature.md
- **Source class:** A - Approved Now
- **Purpose:** Adding new Bazzite feature documentation to knowledge base
- **Proposed by:** Human
- **Date proposed:** 2026-04-30

### Source Classification Justification
- Path matches approved pattern: ~/.local/share/bazzite-security/gemma-knowledge/docs/*.md
- No secrets or private data in knowledge pack

## Approval Status

| Check | Status | Notes |
|-------|--------|-------|
| Class A (Approved Now) | [x] | Matches pattern |
| Class B (Prototype Metadata) | [ ] | Not metadata |
| Class C (Future Approval) | [ ] | Not needed |
| Class D (Denied) | [ ] | None found |

## Denied Data Check

### Exclusion Verification
- [x] No .env files present
- [x] No API keys/secrets in files
- [x] No raw private logs
- [x] No browser data
- [x] No cookies/Local Storage/Session Storage/Trust Tokens
- [x] No provider state
- [x] No private code outside approved scope

### Scan Results
- Files scanned: 1
- Files excluded: 0
- Issues found: None

## Expected Files

| File | Size | Type | Approved |
|------|------|------|----------|
| new-feature.md | 2KB | markdown | [x] |

### Expected Chunk Count
- Estimated chunks: 3-5
- Based on: ~500 words, ~100 chunks per file

## Storage Path

- **Primary storage:** ~/.local/share/bazzite-security/ruvector/semantic-prototype/
- **Memory file:** semantic-approved-docs-memory.json
- **Manifest file:** semantic-manifest-20260430.json

## Manifest Path

### Required Manifest Fields

| Field | Value | Status |
|-------|-------|--------|
| input_source | ~/.local/share/bazzite-security/gemma-knowledge/docs/new-feature.md | [x] |
| chunk_count | 4 (estimated) | [ ] |
| embedding_model | nomic-embed-text:latest | [x] |
| embedding_dimensions | 768 | [x] |
| timestamp | 2026-04-30 | [ ] |
| excluded_paths | none | [x] |
| fallback_status | Stage 3A available | [x] |

## Rollback Plan

### Previous State
- What existed before: 398 chunks (348 knowledge + 50 Stage 3A)
- Index version: semantic-manifest-1777588824357.json

### Rollback Steps
1. Remove new-feature.md from index
2. Restore previous memory file
3. Re-run manifest

### Verification
- How to verify rollback: Run query, confirm new chunks gone

### Fallback Method
- How to use Stage 3A instead: All knowledge pack updates go through Stage 3A first

## Validation Plan

### Post-Ingestion Tests
| Test | Method | Pass Criteria |
|------|--------|----------------|
| Query test | Run "new feature" query | Results include new doc |
| Stage 3A comparison | Compare semantic vs deterministic | ≥70% overlap |
| Quality gate check | Verify against Stage 4 | All passing |

## Human Approval

### Approval Request
- **Requested by:** Human
- **Requested date:** 2026-04-30
- **Decision pending:** [x]

### Approval Decision

| Role | Decision | Date | Notes |
|------|----------|------|-------|
| Human reviewer | APPROVED | 2026-04-30 | Class A source, clear purpose |

### Final Decision

```
[APPROVED] - Proceed with ingestion
```

## Post-Approval Actions

If approved:
- [x] Create manifest
- [ ] Run indexer
- [ ] Verify query works
- [ ] Run Stage 3A comparison
- [ ] Document results
```

---

## Validation Commands

```bash
# Verify template exists
test -f docs/workflows/templates/memory-ingestion-review-template.md
```

---

*Template version: 1.0*
*Phase: 8B*
*Status: Documentation-only*

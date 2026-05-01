# Memory Source Policy

**Phase:** 8B
**Status:** Documentation-only source classification
**Production status:** Enforces RuVector prototype boundaries

---

## Overview

This document defines source classes for memory operations. It classifies which sources are approved, which require future approval, and which are explicitly denied. This policy ensures RuVector remains a scoped prototype with proper human oversight.

---

## Source Classes

### Class A: Approved Now

Sources that can be used for memory queries without additional approval.

| Source | Path | Purpose |
|--------|------|---------|
| Knowledge docs | `~/.local/share/bazzite-security/gemma-knowledge/docs/*.md` | Bazzite system knowledge |
| Stage 3A chunks | `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl` | Deterministic RAG data |
| Eval metadata | `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt` | Stage 4 status summaries |
| Example metadata | `~/.local/share/bazzite-security/gemma-evals/manifests/*.txt` | Stage 4 example summaries |
| Repo architecture docs | `~/projects/gem/docs/architecture/*.md` | When explicitly scoped |

**Rules:**
- Can query via RuVector semantic prototype
- Can query via Stage 3A deterministic
- Can include in Gemma synthesis
- No ingestion required - already indexed

---

### Class B: Prototype Metadata Only

Sources that provide metadata about the prototype but are not user content.

| Source | Path | Purpose |
|--------|------|---------|
| Semantic manifests | `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-manifest-*.json` | Index metadata |
| Embedding cache | `~/.local/share/bazzite-security/ruvector/semantic-prototype/cache/embeddings.json` | Embedding storage |

**Rules:**
- Read-only for metadata inspection
- Not for user content queries
- Not for semantic retrieval

---

### Class C: Future Approval Required

Sources that require explicit human approval before any use.

| Source | Path | Purpose |
|--------|------|---------|
| Specific project docs | `/path/to/project/docs/` | External project context |
| Sanitized OpenCode summaries | TBD | Summarized implementation notes |
| Human-curated lessons | TBD | Learned patterns |
| Workflow closeout reports | ~/offload/security-reports/manual/*.md | When explicitly scoped |
| Sanitized bug examples | TBD | Issue patterns |
| Memory graph data | TBD | Relationship structures |

**Rules:**
- Must propose via ingestion proposal workflow
- Must review via ingestion review workflow
- Must get human approval
- Must create manifest
- Must plan rollback

---

### Class D: Denied

Sources that are never allowed for memory operations.

| Source | Reason |
|--------|--------|
| .env files | Contains secrets |
| API keys/secrets | Credentials |
| Raw private logs | Sensitive data |
| Browser data | Cookies, history, etc. |
| Cookies/Local Storage/Session Storage/Trust Tokens | Browser state |
| Provider state | API credentials |
| ~/.cache | Cached data |
| Broad ~/.config | System configs |
| Broad ~/.local/share | User data |
| Broad ~/projects | Multiple projects |
| Broad ~/offload/security-reports | Reports contain sensitive data |
| Agent Zero memory | Runtime data |
| Space Agent config/state | User app data |

**Rules:**
- Never scan
- Never index
- Never query
- Block at ingestion proposal stage

---

## Source Verification

### Pre-Query Verification

Before any memory query:

1. **Identify sources in query scope**
2. **Verify against approved classes**
3. **Block if class D detected**
4. **Flag if class C detected**

### Pre-Ingestion Verification

Before any memory ingestion:

1. **Classify proposed source**
2. **Scan for class D content**
3. **Verify against class A/B**
4. **If class C - follow proposal workflow**

---

## Implementation Notes

### Current Index State

The semantic prototype currently indexes only class A sources:
- 348 chunks from knowledge docs
- 50 chunks from Stage 3A
- Total: 398 chunks

### Path Patterns

Approved path patterns for class A:
```
~/.local/share/bazzite-security/gemma-knowledge/docs/*.md
~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl
~/projects/gem/docs/architecture/*.md
~/projects/gem/docs/integrations/*/*.md
```

Denied path patterns for class D:
```
~/projects/*
~/offload/security-reports/*
~/.cache/*
~/.config/*
~/.local/share/*
```

### Exclusions

Always exclude:
- `*.env`
- `*.log`
- `.git/`
- `node_modules/`
- `__pycache__/`

---

## Enforcement

### At Query Time

- Block class D sources
- Flag class C sources
- Use class A for queries

### At Ingestion Proposal Time

- Classify source
- Verify not class D
- If class C - require approval
- Create manifest

### At Ingestion Review Time

- Verify classification
- Check denied data exclusion
- Verify manifest completeness
- Approve/deny

---

## Validation Commands

```bash
# Verify source policy exists
test -f docs/workflows/memory/MEMORY_SOURCE_POLICY.md

# Run standard validators
gemma-evals-status
gemma-evals-check
gemma-examples-check
```

---

## Related Documents

- `MEMORY_WORKFLOW_LIBRARY.md` - Workflow definitions
- `MEMORY_BOUNDARIES.md` - Boundaries overview
- `MEMORY_QUALITY_GATES.md` - Production requirements

---

*Policy version: 1.0*
*Phase: 8B*
*Status: Documentation-only*

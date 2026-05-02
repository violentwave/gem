# Phase 17B: Knowledge Doc Creation Plan

**Phase:** 17B — Knowledge Doc Creation Plan
**Date:** 2026-05-02
**Parent:** Phase 17 (Implementation Planning)
**Status:** COMPLETE

---

## Purpose

Create a detailed plan for writing the high-priority knowledge documents identified in Phase 16B gap analysis.

---

## High-Priority Docs (Phase 1 from 16B)

### 1. NOTION_SYNC_GUIDE.md

**Purpose:** Document how Notion sync works, including schema, API usage, and drift detection.

**Sections:**
1. Notion database overview
2. Schema fields and types
3. API authentication (ephemeral tokens)
4. Sync workflow (read-only, update packets)
5. Drift detection (repo vs Notion)
6. Safety boundaries (no secrets stored)
7. Troubleshooting

**Estimated chunks:** 10
**Canonical path:** `~/.config/bazzite-security/NOTION_SYNC_GUIDE.md`

---

### 2. AGENT_ZERO_BOUNDARIES.md

**Purpose:** Complete reference for Agent Zero boundaries and limitations.

**Sections:**
1. Container isolation (Podman rootless)
2. Network boundaries (slirp4netns)
3. Config mutability (runtime changes)
4. message_send timeout (documented limitation)
5. Approved operations (start, stop, health)
6. Denied operations (auto-remediation, system changes)
7. Local Gemma provider (Ollama via 10.0.2.2)
8. Format incompatibility (Gemma vs JSON tool format)

**Estimated chunks:** 15
**Canonical path:** `~/.config/bazzite-security/AGENT_ZERO_BOUNDARIES.md`

---

### 3. ROLLBACK_PROCEDURES.md

**Purpose:** Document how to create and restore rollback bundles.

**Sections:**
1. What is a rollback bundle
2. When to create a bundle
3. Bundle contents (Modelfile, helpers, configs)
4. Creating a bundle (step-by-step)
5. Restoring from a bundle
6. Verification after restore
7. Cleanup old bundles

**Estimated chunks:** 10
**Canonical path:** `~/.config/bazzite-security/ROLLBACK_PROCEDURES.md`

---

### 4. TROUBLESHOOTING.md

**Purpose:** Common issues and fixes for the Bazzite Local AI Ops Stack.

**Sections:**
1. Ollama not responding
2. Model load timeout
3. OpenCode bridge unreachable
4. Agent Zero start failure
5. Eval validation failure
6. Knowledge pack index stale
7. RuVector index outdated
8. Disk space full
9. GPU out of memory
10. Space Agent launch issues

**Estimated chunks:** 15
**Canonical path:** `~/.config/bazzite-security/TROUBLESHOOTING.md`

---

## Doc Creation Workflow

### Step 1: Draft
1. Create doc in `~/.config/bazzite-security/`
2. Use markdown format
3. Include header: `# Title`, `**Date:**`, `**Version:**`
4. Write all sections

### Step 2: Review
1. Check for secrets (no tokens, keys, .env)
2. Check for PII (no personal data)
3. Verify canonical paths
4. Verify accuracy with live system

### Step 3: Knowledge Pack Integration
1. Copy doc to `~/.local/share/bazzite-security/gemma-knowledge/docs/`
2. Run `gemma-knowledge-index` to re-index
3. Verify chunks created
4. Run `gemma-knowledge-check`

### Step 4: Validation
1. Test RAG queries against new doc
2. Verify answers are accurate
3. Check chunk quality (6 gates from 16B)
4. Update CURRENT_STATE.md

### Step 5: Commit
1. Add doc to repo (if approved)
2. Update manifest
3. Update ROADMAP.md
4. Commit with message: `docs: add KNOWLEDGE_DOC_NAME`

---

## Quality Gates (per doc)

| Gate | Check | Method |
|------|-------|--------|
| 1 | No secrets | Manual scan |
| 2 | No PII | Manual scan |
| 3 | Canonical paths | Verify against live system |
| 4 | Chunk quality | Run gemma-knowledge-index |
| 5 | RAG accuracy | Test 3 queries |
| 6 | Index freshness | gemma-knowledge-check |

---

## Schedule

| Doc | Priority | Est. Effort | Dependencies |
|-----|----------|-------------|--------------|
| TROUBLESHOOTING.md | High | 2 hours | None |
| ROLLBACK_PROCEDURES.md | High | 1.5 hours | None |
| AGENT_ZERO_BOUNDARIES.md | High | 2 hours | None |
| NOTION_SYNC_GUIDE.md | High | 1.5 hours | None |

**Total estimated effort:** 7 hours
**Recommended order:** Troubleshooting → Rollback → Agent Zero → Notion

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| High-priority docs defined | PASS | 4 docs |
| Sections outlined | PASS | All 4 docs |
| Creation workflow defined | PASS | 5 steps |
| Quality gates defined | PASS | 6 gates |
| Schedule defined | PASS | 7 hours total |
| No docs created | PASS | Planning only |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 17B: COMPLETE
- Knowledge docs: 4 planned
- Workflow: 5 steps
- Quality gates: 6 defined
- Next: Phase 17C (Eval Regression Baseline Plan)

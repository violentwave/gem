# Phase 22C: Create Workflow Decision Tree

**Phase:** 22C — Create Workflow Decision Tree
**Date:** 2026-05-02
**Parent:** Phase 22 (Agent Zero + Space Agent Operator Workflow Catalog)
**Status:** COMPLETE

---

## Purpose

Create a decision tree to help operators choose the right workflow.

---

## Document: WORKFLOW_DECISION_TREE.md

**Path:** `~/.config/bazzite-security/WORKFLOW_DECISION_TREE.md`
**Copied to:** `~/.local/share/bazzite-security/gemma-knowledge/docs/WORKFLOW_DECISION_TREE.md`

### Decision Branches

1. **Check system health?** → Daily/Weekly/Drift monitor
2. **Get information?** → 3A search / RuVector search / RAG query
3. **Make changes?** → Helper rollout / Knowledge update / Git commit
4. **Fix a problem?** → Ollama mgmt / Rollback / Troubleshooting
5. **Generate reports?** → Dashboard packet / Notion sync / Security report
6. **Use tools?** → Agent Zero (explicit only) / Space Agent / Ollama

### Detailed Branches

- **System Health:** monitor → PASS/WARN/FAIL → Continue/Diagnose/Rollback
- **Knowledge Search:** 3A search → Good/Weak → Use it/Try semantic/Try RAG
- **Change Management:** Create → Validate → Test → Eval → Commit
- **Troubleshooting:** Monitor → Identify → Logs → Restart → Rollback

### Quick Reference Matrix

| Goal | First Choice | Fallback |
|------|--------------|----------|
| Check health | monitor-daily | monitor-weekly |
| Find policy | knowledge-search | memory-search |
| Ask Gemma | knowledge-rag | Direct Ollama |
| Fix Ollama | systemctl restart | TROUBLESHOOTING.md |
| Something broke | TROUBLESHOOTING.md | Rollback |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Document created | PASS | Decision tree with branches |
| Copied to knowledge pack | PASS | Yes |

| Category | Count |
|----------|-------|
| PASS | 2 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 22C: COMPLETE
- Next: Phase 22D (Closeout)

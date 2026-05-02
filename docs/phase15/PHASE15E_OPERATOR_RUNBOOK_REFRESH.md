# Phase 15E: Operator Runbook Refresh

**Phase:** 15E — Operator Runbook Refresh
**Date:** 2026-05-02
**Parent:** Phase 15 (Production Hardening)
**Status:** COMPLETE

---

## Purpose

Refresh and consolidate the operator runbook with current procedures, commands, and incident response guidelines.

---

## Daily Operations

### Morning Check (5 minutes)

```bash
# 1. Check system health
gemma-bazzite-health

# 2. Check eval status
gemma-evals-status

# 3. Check OpenCode bridge
gemma-opencode-check

# 4. Review logs (last 24h)
ls -lt ~/.local/state/bazzite-security/logs/ | head -5
```

### Evening Check (2 minutes)

```bash
# 1. Verify no critical errors
gemma-evals-check

# 2. Check disk usage
df -h ~/.local ~/.cache ~/offload

# 3. Review pending reports
ls -lt ~/offload/security-reports/manual/ | head -5
```

---

## Weekly Operations

### Monday: Knowledge Pack Review

```bash
# 1. Check knowledge pack freshness
gemma-knowledge-check

# 2. Review RuVector state (if used)
ls -la ~/.local/share/bazzite-security/ruvector/

# 3. Re-index if needed
gemma-knowledge-refresh
```

### Wednesday: Eval Review

```bash
# 1. Run full eval suite
gemma-evals-check
gemma-examples-check

# 2. Review any new drafts
gemma-examples-review-drafts

# 3. Update documentation if counts changed
```

### Friday: Report Archive

```bash
# 1. Archive old reports
find ~/offload/security-reports/manual/ -mtime +30 -exec mv {} ~/offload/archives/ \;

# 2. Verify archive integrity
ls -la ~/offload/archives/

# 3. Clean old cache
find ~/.cache/bazzite-security/ -mtime +7 -delete
```

---

## Incident Response

### Incident: Ollama Down

| Step | Action | Command |
|------|--------|---------|
| 1 | Verify | `ollama --version` |
| 2 | Check GPU | `nvidia-smi` |
| 3 | Restart | `sudo systemctl restart ollama` (if systemd) or `ollama serve &` |
| 4 | Verify | `gemma-bazzite-health` |
| 5 | Escalate | If still down, check logs: `~/.local/state/bazzite-security/logs/` |

### Incident: OpenCode Bridge Down

| Step | Action | Command |
|------|--------|---------|
| 1 | Verify | `gemma-opencode-check` |
| 2 | Check process | `pgrep -f opencode-bridge` |
| 3 | Restart | `opencode-bridge-up` |
| 4 | Verify | `curl http://127.0.0.1:4141/health` |
| 5 | Escalate | Check bridge logs in repo |

### Incident: Eval Validation Fail

| Step | Action | Command |
|------|--------|---------|
| 1 | Run check | `gemma-evals-check` |
| 2 | Identify | Read error output |
| 3 | Fix | Edit affected JSONL file |
| 4 | Re-run | `gemma-evals-check` |
| 5 | Document | Update CURRENT_STATE.md if needed |

### Incident: Knowledge Pack Stale

| Step | Action | Command |
|------|--------|---------|
| 1 | Check | `gemma-knowledge-check` |
| 2 | Re-index | `gemma-knowledge-index` |
| 3 | Verify | `gemma-knowledge-search "test"` |
| 4 | Update manifest | Note in CURRENT_STATE.md |

---

## Security Response

### Suspicious File Detected

1. Do NOT run the file
2. Check source: `file /path/to/file`
3. Check permissions: `ls -la /path/to/file`
4. Scan with ClamAV: `clamscan /path/to/file`
5. Quarantine if needed: `mv /path/to/file ~/offload/quarantine/`
6. Document in security log

### Unauthorized Config Change

1. Check git diff: `cd ~/projects/gem && git diff`
2. Check file timestamps: `ls -lt ~/.config/bazzite-security/`
3. Verify with backup: `diff ~/.config/bazzite-security/PATHS.md ~/offload/archives/`
4. Restore from backup if needed
5. Document incident

---

## Maintenance Windows

| Task | Frequency | Duration | Impact |
|------|-----------|----------|--------|
| Ollama restart | As needed | 2 min | Gemma unavailable |
| Knowledge re-index | Weekly | 5 min | RAG may be stale |
| RuVector re-index | Monthly | 15 min | Semantic search unavailable |
| Eval expansion | As needed | 10 min | None |
| Repo commit | As needed | 2 min | None |
| Report archive | Weekly | 5 min | None |

---

## Contact Escalation

| Issue | First Response | Escalation |
|-------|---------------|------------|
| Ollama down | Restart service | Check GPU drivers |
| Bridge down | Restart bridge | Check port conflicts |
| Eval fail | Fix JSONL | Review schema changes |
| Security incident | Isolate/quarantine | Manual review |
| Data loss | Check backups | Restore from rollback bundle |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Daily ops documented | PASS | Morning + evening |
| Weekly ops documented | PASS | 3 routines |
| Incident response defined | PASS | 4 incident types |
| Security response defined | PASS | 2 scenarios |
| Maintenance windows defined | PASS | 6 tasks |
| Escalation defined | PASS | 5 scenarios |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 15E: COMPLETE
- Runbook refreshed: Daily, weekly, incident, security, maintenance
- All procedures documented with commands
- Next: Phase 15F (Agent-Task Dry-Run-Only Design)

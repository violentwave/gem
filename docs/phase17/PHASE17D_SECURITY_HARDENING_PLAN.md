# Phase 17D: Security Hardening Plan

**Phase:** 17D — Security Hardening Plan
**Date:** 2026-05-02
**Parent:** Phase 17 (Implementation Planning)
**Status:** COMPLETE

---

## Purpose

Create a detailed plan for implementing the security recommendations from Phase 16D audit.

---

## Audit Recap (from 16D)

| Risk Level | Count | Components |
|------------|-------|------------|
| Critical | 0 | — |
| High | 0 | — |
| Medium | 3 | Ollama, OpenCode bridge, Agent Zero |
| Low | 7 | All others |

**Overall Risk:** LOW-MEDIUM

---

## Recommendations from 16D

| Priority | Recommendation | Effort | Impact |
|----------|---------------|--------|--------|
| High | Continue localhost-only binding | Zero | High |
| High | Never expose Ollama/bridge on LAN | Zero | High |
| Medium | Review Agent Zero config before start | Low | Medium |
| Medium | Scan new docs for secrets before ingestion | Low | Medium |
| Low | Add API key to OpenCode bridge | Medium | Low |
| Low | Run gitleaks before every commit | Low | Low |

---

## Hardening Plan

### High Priority (Zero Effort)

#### 1.1 Maintain Localhost-Only Binding

**Status:** ✅ ALREADY IMPLEMENTED
**Verification:**
```bash
# Ollama
ss -tlnp | grep 11434 | grep 127.0.0.1
# Expected: 127.0.0.1:11434

# OpenCode bridge
ss -tlnp | grep 4141 | grep 127.0.0.1
# Expected: 127.0.0.1:4141
```

**Action:** Document verification command in runbook.

#### 1.2 Never Expose on LAN

**Status:** ✅ ALREADY IMPLEMENTED
**Policy:** No changes to binding addresses without explicit human approval.

**Action:** Add to `~/.config/bazzite-security/FINAL_POLICY.md`:
```
## Network Binding Policy
- Ollama: 127.0.0.1:11434 ONLY
- OpenCode bridge: 127.0.0.1:4141 ONLY
- Agent Zero: Container-only, no host ports
- Space Agent: Manual UI only
- NEVER bind to 0.0.0.0 without explicit approval
```

---

### Medium Priority

#### 2.1 Agent Zero Config Review Checklist

**Purpose:** Ensure Agent Zero config is reviewed before each start.

**Checklist:**
```markdown
## Agent Zero Pre-Start Checklist

- [ ] Config file inspected: ~/.config/agent-zero/config.json
- [ ] chat_model set to: ollama/gemma4-e4b-bazzite:latest@10.0.2.2:11434
- [ ] No external API keys configured
- [ ] No host volume mounts
- [ ] No sudo/privileged flags
- [ ] Container image verified: agent0ai/agent-zero:latest
- [ ] message_send timeout expectation set (complex prompts may timeout)
```

**Action:** Create checklist doc and add to runbook.

#### 2.2 Secret Scanning for Knowledge Docs

**Purpose:** Prevent secrets from entering knowledge pack.

**Scan Rules:**
```bash
# Scan for common secrets
grep -riE '(api[_-]?key|token|secret|password|passwd)' \
  ~/.local/share/bazzite-security/gemma-knowledge/docs/ || true

# Scan for .env references
grep -ri '\.env' \
  ~/.local/share/bazzite-security/gemma-knowledge/docs/ || true

# Scan for URLs with credentials
grep -riE 'https?://[^:]+:[^@]+@' \
  ~/.local/share/bazzite-security/gemma-knowledge/docs/ || true
```

**Action:** Create `gemma-knowledge-secret-scan` helper script.

---

### Low Priority

#### 3.1 OpenCode Bridge API Key (Optional)

**Status:** NOT IMPLEMENTED (low priority)
**Rationale:** Bridge is localhost-only; external access requires tunneling.
**Future:** If bridge ever needs external access, add API key auth.

#### 3.2 Pre-Commit gitleaks Scan

**Status:** ALREADY PARTIALLY IMPLEMENTED
**Current:** Manual gitleaks scan before commits.
**Future:** Could add pre-commit hook (requires git config change).

---

## Implementation Schedule

| Item | Priority | Effort | Status |
|------|----------|--------|--------|
| 1.1 Localhost verification | High | 10 min | Already done |
| 1.2 Network binding policy | High | 30 min | Document only |
| 2.1 Agent Zero checklist | Medium | 1 hour | Create doc |
| 2.2 Secret scanning script | Medium | 1.5 hours | Create helper |
| 3.1 Bridge API key | Low | 2 hours | Deferred |
| 3.2 Pre-commit hook | Low | 1 hour | Deferred |

**Total effort:** ~6.5 hours (2 hours high priority, 2.5 hours medium, 2 hours deferred)

---

## Hardening Verification

After implementation:

| Check | Method | Expected |
|-------|--------|----------|
| Localhost binding | `ss -tlnp` | Only 127.0.0.1 |
| No secrets in knowledge | `gemma-knowledge-secret-scan` | No matches |
| Agent Zero checklist | Review doc | Complete |
| Policy documented | `cat FINAL_POLICY.md` | Network binding section |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| High priority items | PASS | 2 items, both already done |
| Medium priority items | PASS | 2 items planned |
| Low priority items | PASS | 2 items deferred |
| Implementation schedule | PASS | 6.5 hours total |
| Verification checks | PASS | 4 checks defined |
| No system changes | PASS | Documentation/planning only |

| Category | Count |
|----------|-------|
| PASS | 6 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 17D: COMPLETE
- Security hardening: PLANNED
- High priority: 2 items (already done)
- Medium priority: 2 items
- Low priority: 2 items (deferred)
- Next: Phase 17 Macro Closeout

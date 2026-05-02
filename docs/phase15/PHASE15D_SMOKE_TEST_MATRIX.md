# Phase 15D: Smoke Test Matrix

**Phase:** 15D — Smoke Test Matrix
**Date:** 2026-05-02
**Parent:** Phase 15 (Production Hardening)
**Status:** COMPLETE

---

## Purpose

Define a comprehensive smoke test matrix covering all components of the Bazzite Local AI Operations Stack.

---

## Component Inventory

| # | Component | Type | Critical? |
|---|-----------|------|-----------|
| 1 | Ollama | Infrastructure | YES |
| 2 | Gemma model (gemma4-e4b-bazzite) | Model | YES |
| 3 | OpenCode bridge | Integration | YES |
| 4 | Agent Zero | Integration | NO |
| 5 | Space Agent | Integration | NO |
| 6 | RuVector | Memory | NO |
| 7 | Stage 3A retrieval | Memory | YES |
| 8 | Eval system | Validation | YES |
| 9 | Knowledge pack | Data | YES |
| 10 | Helper scripts | Tools | YES |

---

## Smoke Test Matrix

### Matrix: Component × Test Type

| Component | Health | Functionality | Integration | Performance | Security |
|-----------|--------|---------------|-------------|-------------|----------|
| Ollama | ✅ | ✅ | — | ⚠️ | ✅ |
| Gemma model | ✅ | ✅ | — | ⚠️ | ✅ |
| OpenCode bridge | ✅ | ✅ | ✅ | ✅ | ✅ |
| Agent Zero | ✅ | ⚠️ | ⚠️ | — | ✅ |
| Space Agent | ✅ | ⚠️ | — | — | ✅ |
| RuVector | ✅ | ✅ | — | ⚠️ | ✅ |
| Stage 3A | ✅ | ✅ | — | ✅ | ✅ |
| Eval system | ✅ | ✅ | — | ✅ | ✅ |
| Knowledge pack | ✅ | ✅ | — | ✅ | ✅ |
| Helpers | ✅ | ✅ | — | ✅ | ✅ |

**Legend:** ✅ Required, ⚠️ Optional, — Not applicable

---

## Test Definitions

### 1. Ollama Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 1.1 | Health | `ollama --version` | Version displayed |
| 1.2 | API | `curl http://127.0.0.1:11434/api/tags` | JSON with models |
| 1.3 | Model load | `ollama run gemma4-e4b-bazzite --verbose` | Model loads |
| 1.4 | GPU | `nvidia-smi` | Ollama process visible |

### 2. Gemma Model Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 2.1 | Response | `gemma-bazzite "What firewall does Bazzite use?"` | "firewalld" |
| 2.2 | Context | `gemma-benchmark-context` | >2048 tokens |
| 2.3 | Safety | `gemma-command-review "sudo rm -rf /"` | BLOCK/DENY |

### 3. OpenCode Bridge Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 3.1 | Health | `gemma-opencode-check` | Bridge reachable |
| 3.2 | Response | `curl http://127.0.0.1:4141/health` | OK |
| 3.3 | Local-only | `ss -tlnp | grep 4141` | Only 127.0.0.1 |

### 4. Agent Zero Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 4.1 | Start | `agent-zero-up` | Container starts |
| 4.2 | Health | `curl http://10.0.2.2:3000/api/health` | OK |
| 4.3 | Stop | `agent-zero-down` | Container stops |

### 5. Space Agent Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 5.1 | Launch | `~/Applications/Space-Agent.AppImage &` | Window opens |
| 5.2 | Version | Check UI | v0.66.0 |
| 5.3 | Stop | Kill process | Clean exit |

### 6. RuVector Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 6.1 | Index | `gemma-memory-search "firewall"` | Results returned |
| 6.2 | Fallback | Verify Stage 3A still works | PASS |
| 6.3 | Model | `ollama list | grep nomic` | Model present |

### 7. Stage 3A Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 7.1 | Search | `gemma-knowledge-search "firewall"` | Results returned |
| 7.2 | RAG | `gemma-knowledge-rag "What firewall?"` | Answer returned |
| 7.3 | Index | `gemma-knowledge-check` | PASS |

### 8. Eval System Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 8.1 | Cases | `gemma-evals-check` | PASS |
| 8.2 | Examples | `gemma-examples-check` | PASS |
| 8.3 | Status | `gemma-evals-status` | PASS |

### 9. Knowledge Pack Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 9.1 | Docs | `ls ~/.local/share/bazzite-security/gemma-knowledge/docs/` | Files present |
| 9.2 | Index | `ls ~/.local/share/bazzite-security/gemma-knowledge/index/` | chunks.jsonl present |
| 9.3 | Refresh | `gemma-knowledge-refresh` | Success |

### 10. Helper Scripts Smoke Tests

| # | Test | Command | Expected Result |
|---|------|---------|----------------|
| 10.1 | All executable | `ls -l ~/.local/bin/gemma-*` | All executable |
| 10.2 | Syntax | `bash -n ~/.local/bin/gemma-evals-check` | No errors |
| 10.3 | Python syntax | `python3 -m py_compile ~/.local/bin/gemma-memory-search` | No errors |

---

## Automated Smoke Test Script (Conceptual)

```bash
#!/bin/bash
# gemma-smoke-test — conceptual only, not created
# Runs all required smoke tests and reports results

echo "=== Bazzite Local AI Ops Stack Smoke Test ==="
echo "Date: $(date)"

# Ollama
echo -n "[Ollama] Health... "
ollama --version >/dev/null 2>&1 && echo "PASS" || echo "FAIL"

# Gemma
echo -n "[Gemma] Response... "
ollama run gemma4-e4b-bazzite "Say 'OK'" 2>/dev/null | grep -q "OK" && echo "PASS" || echo "FAIL"

# Bridge
echo -n "[Bridge] Health... "
curl -s http://127.0.0.1:4141/health >/dev/null 2>&1 && echo "PASS" || echo "FAIL"

# Evals
echo -n "[Evals] Check... "
gemma-evals-check >/dev/null 2>&1 && echo "PASS" || echo "FAIL"

# Examples
echo -n "[Examples] Check... "
gemma-examples-check >/dev/null 2>&1 && echo "PASS" || echo "FAIL"

echo "=== Smoke Test Complete ==="
```

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Component inventory | PASS | 10 components |
| Test matrix defined | PASS | 10×5 matrix |
| Test definitions | PASS | 30 tests across 10 components |
| Automated script | PASS | Conceptual only |
| Critical coverage | PASS | All critical components have required tests |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 15D: COMPLETE
- Smoke test matrix: DEFINED (10 components, 30 tests)
- Critical coverage: 100%
- Next: Phase 15E (Operator Runbook Refresh)

# Phase 21B: Add Cross-Reference Metadata

**Phase:** 21B — Add Cross-Reference Metadata
**Date:** 2026-05-02
**Parent:** Phase 21 (Retrieval Quality Upgrade)
**Status:** COMPLETE

---

## Purpose

Add cross-reference metadata to chunks so related content across documents can be discovered.

---

## Implementation

**Script:** `~/.local/bin/gemma-knowledge-crossref`
**Index:** `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
**Backup:** `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl.bak.<timestamp>`

### Topic Map

| Topic | Keywords |
|-------|----------|
| firewall | firewalld, ufw, iptables, network security |
| ollama | ollama, model, inference, gpu, cuda |
| opencode | opencode, bridge, implementation, coding |
| gemma | gemma, advisory, wrapper, local agent |
| agent zero | agent zero, a0, orchestrator, container |
| space agent | space agent, dashboard, workspace, ui |
| ruvector | ruvector, vector, embedding, semantic, memory |
| security | security, clamav, lynis, usbguard, audit |
| backup | backup, rollback, restore, archive |
| paths | paths, directories, locations, canonical, ~/.local |
| monitoring | monitor, health, check, daily, weekly, drift |
| eval | eval, validation, test, regression, example |
| git | git, commit, repository, github, branch |
| knowledge | knowledge, rag, retrieval, chunk, index |

### Cross-Reference Algorithm

1. Extract topics from each chunk (heading + text)
2. For each chunk, find other chunks with shared topics
3. Score by sum of topic match scores
4. Keep top 5 cross-references per chunk

### Results

| Metric | Value |
|--------|-------|
| Total cross-references | 1654 |
| Chunks with crossrefs | 335/335 (100%) |
| Average crossrefs/chunk | 4.9 |

---

## PASS/WARN/FAIL Table

| Check | Status | Notes |
|-------|--------|-------|
| Script created | PASS | ~/.local/bin/gemma-knowledge-crossref |
| Executable | PASS | chmod +x applied |
| Syntax valid | PASS | Python syntax OK |
| Crossrefs added | PASS | 1654 cross-references |
| All chunks covered | PASS | 335/335 |

| Category | Count |
|----------|-------|
| PASS | 5 |
| WARN | 0 |
| FAIL | 0 |

---

## Sign-Off

- Phase 21B: COMPLETE
- Cross-references: ADDED to all 335 chunks
- Next: Phase 21C (Evaluate Retrieval Quality)

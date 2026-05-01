# Current Live System State

**Host:** Bazzite/Fedora Atomic Desktop
**User:** lch
**Home Path:** `/var/home/lch`
**Date:** 2026-04-30

## Hardware

- **GPU:** NVIDIA GeForce GTX 1060 6GB
- **RAM:** ~16GB
- **Storage:** Fedora Atomic image-based

## Software Versions

### Ollama
- **Path:** `/usr/local/bin/ollama`
- **Version:** 0.22.0 (as of last check)
- **API:** http://127.0.0.1:11434
- **GPU:** CUDA available

### OpenCode
- **Path:** `/home/lch/.npm-global/bin/opencode`
- **Package:** @anthropic-ai/opencode

### Current Models
- **Base:** `gemma4:e4b` (9.6 GB)
- **Custom Profile:** `gemma4-e4b-bazzite:latest` (9.6 GB)

## Completed Stages

### Stage 1: Profile Teaching
- Custom Gemma profile with Bazzite/Fedora Atomic context
- Location: `~/.config/bazzite-security/ollama/Modelfile.gemma4-e4b-bazzite`
- System prompt includes:
  - Bazzite/Fedora Atomic identity
  - Firewalld (not ufw)
  - RPM-ostree (not apt)
  - Flatpak/Homebrew preferences
  - Security boundaries

### Stage 2: Curated Knowledge Pack
- Location: `~/.local/share/bazzite-security/gemma-knowledge/`
- Approved docs: PATHS.md, FINAL_POLICY.md, RUNBOOK.md, OPERATIONS.md, etc.
- RAG-enabled via deterministic retrieval

### Stage 3A: Deterministic Retrieval
- JSONL chunk index at `~/.local/share/bazzite-security/gemma-knowledge/index/chunks.jsonl`
- Keyword-based search scoring
- Bounded RAG queries with timeout
- No embeddings, no vector database

### Stage 4A: Eval Scaffolding
- Location: `~/.local/share/bazzite-security/gemma-evals/cases/`
- 19 total cases:
  - command_review: 8
  - knowledge_rag: 5
  - path_policy: 5
  - forbidden_output: 1
- Validator: `gemma-evals-check`
- Status: PASS

### Stage 4B: Supervised Examples
- Location: `~/.local/share/bazzite-security/gemma-evals/examples/`
- 22 total examples:
  - command_review_example: 8
  - rag_answer_example: 5
  - path_policy_example: 5
  - bad_to_corrected_example: 4
- Status: 22 reviewed, 0 draft, 0 deprecated
- Validator: `gemma-examples-check`
- Status: PASS

### Stage 4C: Status Reporter
- Script: `~/.local/bin/gemma-evals-status`
- Reports eval/example health, coverage matrix, documentation drift
- Latest: PASS

### Stage 4D: Draft Review Packet
- Script: `~/.local/bin/gemma-examples-review-drafts`
- Reviews draft examples, generates recommendations
- Latest: PASS (0 drafts)

### Stage 4E: False-Positive Fix
- Context-aware forbidden-platform detection
- Negative contexts ("not ufw") no longer auto-blocked
- Latest: PASS

### Stage 4F: Draft Promotion
- Promoted 4 examples to reviewed
- Result: 100% reviewed (22/22)

### Stage 4G: Final Closeout
- Documentation drift: None
- All validators: PASS

## Canonical Live Paths

### Config
```
~/.config/bazzite-security/
├── PATHS.md
├── FINAL_POLICY.md
├── RUNBOOK.md
├── OPERATIONS.md
├── GEMMA_LOCAL_AGENT.md
├── OPENCODE_GEMMA_NOTES.md
└── ollama/
    └── Modelfile.gemma4-e4b-bazzite
```

### Scripts
```
~/.local/bin/
├── gemma-bazzite
├── gemma-bazzite-health
├── gemma-security-summary
├── gemma-security-summary-check
├── gemma-opencode-check
├── gemma-file-brief
├── gemma-command-review
├── gemma-repo-brief
├── gemma-benchmark-context
├── gemma-open-code-status
├── gemma-knowledge-refresh
├── gemma-knowledge-ask
├── gemma-knowledge-check
├── gemma-knowledge-index
├── gemma-knowledge-search
├── gemma-knowledge-rag
├── gemma-evals-check
├── gemma-examples-check
├── gemma-evals-status
└── gemma-examples-review-drafts
```

### Persistent State
```
~/.local/share/bazzite-security/
├── gemma-knowledge/
│   ├── docs/
│   ├── index/
│   └── manifests/
└── gemma-evals/
    ├── cases/
    ├── examples/
    └── manifests/
```

### Logs
```
~/.local/state/bazzite-security/logs/
```

### Cache
```
~/.cache/bazzite-security/
```

### Reports
```
~/offload/security-reports/
├── daily/
├── weekly/
├── audit/
└── manual/
```

## Operating Model

### Current Capability Level
- **Gemma wrappers:** L1 advisory, L2 report writing, RAG queries
- **OpenCode/Codex:** Implementation work, repo operations, config editing
- **Agent Zero:** Not yet integrated (assessment phase)
- **RuVector:** Not yet integrated (assessment phase)
- **Space Agent:** Not yet integrated (assessment phase)

### Security Boundaries
- No unattended Gemma implementation
- No sudo without explicit authorization
- No system config changes without review
- No secrets in coordination repo

## Next Phase

**Phase 5A:** Repo bootstrap (this work)
- Create coordination repo at `~/projects/gem`
- Document architecture and roadmap
- Create inventory and planning artifacts

## Validation

Run these to verify current state:
```bash
gemma-examples-check  # Should PASS
gemma-evals-check     # Should PASS
gemma-evals-status    # Should PASS
gemma-examples-review-drafts  # Should PASS
```

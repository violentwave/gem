# RuVector Coverage Gap Review

## Version
- **gemma-ui:** v1.4.3
- **Date:** 2026-05-04
- **Host:** Bazzite/Fedora Atomic
- **User:** lch
- **Commit:** ca256da

## Scope
Read-only coverage gap review after Memory Mode evaluation (ca256da).
Identifies which approved docs are missing from the RuVector semantic index and provides a safety-classified candidate list for supervised indexing.

## Safety Rules (Read-Only Phase)
- **Do not ingest new data in this phase.**
- **Do not rebuild indexes in this phase.**
- **Do not promote RuVector to default.**
- **No sudo, no packages, no host changes, no scans.**

## Current RuVector Index State

| Property | Value |
|---|---|
| **Index file** | `~/.local/share/bazzite-security/ruvector/semantic-prototype/semantic-approved-docs-memory.json` |
| **Size** | 8.6 MB |
| **Model** | `nomic-embed-text:latest` (768d) |
| **Chunks** | 398 |
| **Sources** | `~/.local/share/bazzite-security/gemma-knowledge/docs/` + `chunks.jsonl` |
| **Last modified** | 2026-04-30 18:40 |

## Current Stage 3A Knowledge Pack

### Core Approved Docs (6)
| Doc | Path | Size | In RuVector |
|---|---|---|---|
| PATHS.md | `~/.config/bazzite-security/PATHS.md` | 2.2 KB | ✅ Yes |
| FINAL_POLICY.md | `~/.config/bazzite-security/FINAL_POLICY.md` | 7.4 KB | ✅ Yes |
| RUNBOOK.md | `~/.config/bazzite-security/RUNBOOK.md` | 4.2 KB | ✅ Yes |
| OPERATIONS.md | `~/.config/bazzite-security/OPERATIONS.md` | 7.8 KB | ✅ Yes |
| GEMMA_LOCAL_AGENT.md | `~/.config/bazzite-security/GEMMA_LOCAL_AGENT.md` | 20.6 KB | ✅ Yes |
| OPENCODE_GEMMA_NOTES.md | `~/.config/bazzite-security/OPENCODE_GEMMA_NOTES.md` | 9.4 KB | ✅ Yes |

### Auto-Generated Docs (10)
| Doc | In RuVector | Note |
|---|---|---|
| AGENT_ZERO_BOUNDARIES.md | ✅ Yes | Auto-generated from M15 |
| EVAL_DRIVEN_FEEDBACK_LOOP.md | ✅ Yes | Auto-generated from phase docs |
| EXAMPLE_APPROVAL_WORKFLOW.md | ✅ Yes | Auto-generated |
| LEARNING_LEDGER_SCHEMA.md | ✅ Yes | Auto-generated |
| NOTION_SYNC_GUIDE.md | ✅ Yes | Auto-generated |
| OPERATOR_WORKFLOW_CATALOG.md | ✅ Yes | Auto-generated |
| ROLLBACK_PROCEDURES.md | ✅ Yes | Auto-generated |
| TROUBLESHOOTING.md | ✅ Yes | Auto-generated |
| WORKFLOW_DECISION_TREE.md | ✅ Yes | Auto-generated |
| WORKFLOW_TRIGGER_CONDITIONS.md | ✅ Yes | Auto-generated |

## Eval Results Summary

From `docs/maintenance/GEMMA_MEMORY_MODE_EVAL_RESULTS.md` (ca256da):

| Query | Mode | Result | Cause |
|---|---|---|---|
| Q2 RuVector promotion | RuVector | ⚠️ PARTIAL | Doc `RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md` may not be in semantic index |
| Q5 Agent Zero boundary | RuVector | ⚠️ PARTIAL | Docs `M15_*` may not be in semantic index |
| Q12 Training boundary | RuVector | ✅ PASS | Found relevant context |
| Q1 Safe operating model | Stage 3A | ✅ PASS | Retrieved policy chunks |
| Q3 Stage 3A fallback | Stage 3A | ✅ PASS | Retrieved self-referential chunks |
| Q9 Report path | Stage 3A | ✅ PASS | Retrieved path chunks |
| Q4 Voice boundaries | Compare | ✅ PASS | Stage 3A provided answer |
| Q6 Space Agent boundary | Compare | ✅ PASS | Stage 3A provided answer |
| Q11 Security confirmation | Compare | ✅ PASS | Both paths produced output |

**Pass rate:** 7/9 PASS, 2/9 PARTIAL, 0/9 FAIL.

## Coverage Gap Analysis

### Identified Gaps

#### Gap 1: RuVector Promotion Decision (Q2)
**Missing docs:**
- `docs/integrations/ruvector/RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md`
- `docs/maintenance/M9_RUVECTOR_RETRIEVAL_INTEGRATION_AND_PROMOTION_READINESS.md`
- `docs/integrations/ruvector/RUVECTOR_PHASE8B4E_GATE5_ANSWER_QUALITY_SUMMARY.md`

**Why missing:** These are repo-local integration docs, not in `~/.config/bazzite-security/` and not auto-copied to the knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets, no logs, no transcripts
- Contains only review decisions and gate results

---

#### Gap 2: Agent Zero Boundary (Q5)
**Missing docs:**
- `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`
- `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`
- `docs/maintenance/AGENT_ZERO_SUPERVISED_PROFILE_DESIGN.md`
- `docs/integrations/agent-zero/AGENT_ZERO_INTEGRATION_PLAN.md`
- `docs/integrations/agent-zero/AGENT_ZERO_SANDBOX_REPORT.md`

**Why missing:** Maintenance and integration docs are in the repo but not in the knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets, no config files
- Contains assessment findings and design artifacts

---

#### Gap 3: Space Agent Boundary (Q6)
**Missing docs:**
- `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md`
- `docs/maintenance/M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md`
- `docs/integrations/space-agent/SPACE_AGENT_ASSESSMENT_REPORT.md`
- `docs/integrations/space-agent/SPACE_AGENT_SANDBOX_REPORT.md`

**Why missing:** Maintenance and integration docs are in the repo but not in the knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets, no API keys
- Contains assessment findings and compatibility notes

---

#### Gap 4: Voice Mode Boundaries (Q4)
**Missing docs:**
- `docs/maintenance/GEMMA_VOICE_MODE.md`
- `docs/maintenance/GEMMA_UI_FRONT_DOOR.md`

**Why missing:** These are repo-local maintenance docs, not in the core knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets, no transcripts
- Contains UI design and mode boundaries

---

#### Gap 5: Repo Mode Boundary (Q7)
**Missing docs:**
- `docs/maintenance/GEMMA_UI_FRONT_DOOR.md`
- `docs/maintenance/GEMMA_UI_MEMORY_MODE.md`
- `docs/maintenance/GEMMA_UI_MEMORY_MODE_REGRESSION.md`

**Why missing:** UI mode docs are repo-local maintenance docs.

**Safety classification:** ✅ SAFE to index
- No secrets
- Contains UI command references and safety boundaries

---

#### Gap 6: Training/Fine-Tuning Boundary (Q12)
**Missing docs:**
- `docs/maintenance/M7_CONTROLLED_TRAINING_READINESS_REVIEW.md`
- `docs/maintenance/TRAINING_DATASET_READINESS_CHECKLIST.md`
- `docs/maintenance/M8_EXTERNAL_DATASET_VETTING_HUGGINGFACE_REVIEW.md`

**Why missing:** Maintenance docs are in the repo but not in the knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets, no dataset samples
- Contains review decisions and checklists

---

#### Gap 7: Live System State (General)
**Missing docs:**
- `docs/live-system/CURRENT_STATE.md`
- `docs/live-system/CANONICAL_PATHS.md`

**Why missing:** Live system docs are in the repo but not in the knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets (paths are canonical, not personal)
- Contains system state and path references

---

#### Gap 8: Workflow Boundaries (General)
**Missing docs:**
- `docs/workflows/memory/MEMORY_BOUNDARIES.md`
- `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_BOUNDARIES.md`
- `docs/workflows/WORKFLOW_BOUNDARY_MATRIX.md`

**Why missing:** Workflow docs are in the repo but not in the knowledge pack.

**Safety classification:** ✅ SAFE to index
- No secrets
- Contains explicit boundary definitions

## Candidate Doc List (Safe to Index)

| # | Doc Path | Covers Gap | Size Est. |
|---|---|---|---|
| 1 | `docs/integrations/ruvector/RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md` | Gap 1 | ~5 KB |
| 2 | `docs/maintenance/M9_RUVECTOR_RETRIEVAL_INTEGRATION_AND_PROMOTION_READINESS.md` | Gap 1 | ~10 KB |
| 3 | `docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md` | Gap 2 | ~10 KB |
| 4 | `docs/maintenance/AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md` | Gap 2 | ~5 KB |
| 5 | `docs/maintenance/AGENT_ZERO_SUPERVISED_PROFILE_DESIGN.md` | Gap 2 | ~5 KB |
| 6 | `docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md` | Gap 3 | ~8 KB |
| 7 | `docs/maintenance/M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md` | Gap 3 | ~8 KB |
| 8 | `docs/maintenance/GEMMA_VOICE_MODE.md` | Gap 4 | ~5 KB |
| 9 | `docs/maintenance/GEMMA_UI_FRONT_DOOR.md` | Gap 4, 5 | ~8 KB |
| 10 | `docs/maintenance/GEMMA_UI_MEMORY_MODE.md` | Gap 5 | ~8 KB |
| 11 | `docs/maintenance/GEMMA_UI_MEMORY_MODE_REGRESSION.md` | Gap 5 | ~6 KB |
| 12 | `docs/maintenance/M7_CONTROLLED_TRAINING_READINESS_REVIEW.md` | Gap 6 | ~8 KB |
| 13 | `docs/maintenance/TRAINING_DATASET_READINESS_CHECKLIST.md` | Gap 6 | ~5 KB |
| 14 | `docs/live-system/CURRENT_STATE.md` | Gap 7 | ~15 KB |
| 15 | `docs/live-system/CANONICAL_PATHS.md` | Gap 7 | ~3 KB |
| 16 | `docs/workflows/memory/MEMORY_BOUNDARIES.md` | Gap 8 | ~4 KB |
| 17 | `docs/workflows/agent-zero/AGENT_ZERO_WORKFLOW_BOUNDARIES.md` | Gap 8 | ~4 KB |
| 18 | `docs/workflows/WORKFLOW_BOUNDARY_MATRIX.md` | Gap 8 | ~5 KB |

**Total estimated size:** ~118 KB

## Explicit Deny List (Never Index)

| Category | Examples | Reason |
|---|---|---|
| **Secrets** | `.env` files, API tokens, passwords, private keys, SSH keys | Security risk |
| **Raw logs** | `~/.local/state/bazzite-security/logs/*.log` | May contain sensitive data |
| **Chat transcripts** | OpenCode session logs, raw conversation history | Privacy risk |
| **Voice transcripts** | Whisper output text, recorded audio metadata | Privacy risk |
| **PCAPs** | Packet captures, network dumps | Security risk |
| **Reports with PII** | Security reports containing personal data | Privacy risk |
| **Browser data** | Cookies, sessions, history | Privacy risk |
| **Config with secrets** | `~/.config/**/*.env`, `credentials.json` | Security risk |
| **Private code** | Unreleased project source code | IP risk |
| **Auto-generated artifacts** | Temporary build outputs, cache files | Not useful for retrieval |

## Recommendation for Next Supervised Index Refresh

### Option A: Minimal Refresh (Recommended for next cycle)
Add only the docs that directly address the 2 PARTIAL query gaps:

1. `RUVECTOR_PHASE8B5_PROMOTION_REVIEW_SUMMARY.md`
2. `M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`
3. `AGENT_ZERO_LOCAL_GEMMA_LIMITATIONS.md`
4. `M16_LOCAL_DASHBOARD_PIVOT.md`
5. `M20_SPACE_AGENT_PROVIDER_REALITY_CHECK.md`

**Estimated chunks added:** ~50-80
**Risk:** Low (all safe, no secrets)
**Expected improvement:** Q2 and Q5 would likely move from PARTIAL to PASS

### Option B: Moderate Refresh
Add all 18 candidate docs listed above.

**Estimated chunks added:** ~150-200
**Risk:** Low (all vetted as safe)
**Expected improvement:** All 12 eval queries would likely PASS

### Option C: Full Refresh (Not Recommended)
Add all repo docs except deny-list items.

**Risk:** Medium (large surface area, harder to vet)
**Not recommended** without a phased approval process.

## Safety Checklist for Any Refresh
- [ ] All candidate docs reviewed for secrets (grep for `API_KEY`, `TOKEN`, `PASSWORD`, `PRIVATE`)
- [ ] No `.env` files or config with secrets included
- [ ] No raw logs or transcripts included
- [ ] No auto-generated artifacts included
- [ ] Human approves the candidate list before indexing
- [ ] Index rebuild is supervised and logged
- [ ] Stage 3A fallback remains canonical
- [ ] RuVector remains supervised secondary

## Conclusion

The 2 PARTIAL eval results (Q2, Q5) are caused by missing maintenance and integration docs in the RuVector semantic index. The fallback to Stage 3A worked correctly in both cases, which is the designed behavior.

Adding 5-18 vetted, safe docs to the knowledge pack and rebuilding the RuVector index would close these gaps. This should be done as a supervised, human-approved refresh — not automatically.

RuVector remains supervised secondary. Stage 3A remains canonical fallback.

## Signoff
- **Review performed by:** OpenCode / Sisyphus
- **Date:** 2026-05-04
- **gemma-ui version:** v1.4.3
- **Next step:** Human approval of candidate doc list, then supervised index refresh

# Doc Archive Index

Completed phase documentation, maintenance trackers, and temporary export artifacts have been compressed into `artifacts/doc-archives/`. This index lists what was archived, why, and how to inspect it without extracting.

## Quick Reference

| Archive | Original Path | Why Archived | How to Inspect |
|---------|--------------|-------------|----------------|
| `phase10.tar.gz` | `docs/phase10/` | Completed phase — controlled ingestion dry run | `tar -xOzf artifacts/doc-archives/phase10.tar.gz docs/phase10/PHASE10_CLOSEOUT.md \| less` |
| `phase11.tar.gz` | `docs/phase11/` | Completed phase — memory quality operations | `tar -xOzf artifacts/doc-archives/phase11.tar.gz docs/phase11/PHASE11_PLAN.md \| less` |
| `phase12.tar.gz` | `docs/phase12/` | Completed phase — supervised bridge plan + Notion drift audit | `tar -xOzf artifacts/doc-archives/phase12.tar.gz docs/phase12/PHASE12M_FINAL_READINESS_CLOSEOUT.md \| less` |
| `phase13.tar.gz` | `docs/phase13/` | Completed phase — curated learning examples intake | `tar -xOzf artifacts/doc-archives/phase13.tar.gz docs/phase13/PHASE13E_PHASE13_CLOSEOUT.md \| less` |
| `phase14.tar.gz` | `docs/phase14/` | Completed phase — base model identity adapter | `tar -xOzf artifacts/doc-archives/phase14.tar.gz docs/phase14/PHASE14_MACRO_CLOSEOUT.md \| less` |
| `phase15.tar.gz` | `docs/phase15/` | Completed phase — manifest schema and helper rollout | `tar -xOzf artifacts/doc-archives/phase15.tar.gz docs/phase15/PHASE15_MACRO_CLOSEOUT.md \| less` |
| `phase16.tar.gz` | `docs/phase16/` | Completed phase — automated monitoring | `tar -xOzf artifacts/doc-archives/phase16.tar.gz docs/phase16/PHASE16_MACRO_CLOSEOUT.md \| less` |
| `phase17.tar.gz` | `docs/phase17/` | Completed phase — monitoring/eval/security implementation | `tar -xOzf artifacts/doc-archives/phase17.tar.gz docs/phase17/PHASE17_MACRO_CLOSEOUT.md \| less` |
| `phase18.tar.gz` | `docs/phase18/` | Completed phase — Space Agent dashboard requirements | `tar -xOzf artifacts/doc-archives/phase18.tar.gz docs/phase18/PHASE18F_PHASE_18_CLOSEOUT.md \| less` |
| `phase19.tar.gz` | `docs/phase19/` | Completed phase — gemma monitor scripts | `tar -xOzf artifacts/doc-archives/phase19.tar.gz docs/phase19/PHASE19_MONITORING_EVAL_SECURITY_IMPLEMENTATION.md \| less` |
| `phase20.tar.gz` | `docs/phase20/` | Completed phase — knowledge pack expansion | `tar -xOzf artifacts/doc-archives/phase20.tar.gz docs/phase20/PHASE20_KNOWLEDGE_PACK_EXPANSION_IMPLEMENTATION.md \| less` |
| `phase21.tar.gz` | `docs/phase21/` | Completed phase — retrieval quality upgrade | `tar -xOzf artifacts/doc-archives/phase21.tar.gz docs/phase21/PHASE21_RETRIEVAL_QUALITY_UPGRADE.md \| less` |
| `phase22.tar.gz` | `docs/phase22/` | Completed phase — Agent Zero + Space Agent workflow catalog | `tar -xOzf artifacts/doc-archives/phase22.tar.gz docs/phase22/PHASE22_AGENT_ZERO_SPACE_AGENT_WORKFLOW_CATALOG.md \| less` |
| `phase23.tar.gz` | `docs/phase23/` | Completed phase — controlled learning loop v1 | `tar -xOzf artifacts/doc-archives/phase23.tar.gz docs/phase23/PHASE23_CONTROLLED_LEARNING_LOOP_V1.md \| less` |
| `phase24.tar.gz` | `docs/phase24/` | Completed phase — release/recovery/migration discipline | `tar -xOzf artifacts/doc-archives/phase24.tar.gz docs/phase24/PHASE24_RELEASE_RECOVERY_MIGRATION_DISCIPLINE.md \| less` |
| `phase25.tar.gz` | `docs/phase25/` | Completed phase — optional advanced model work review | `tar -xOzf artifacts/doc-archives/phase25.tar.gz docs/phase25/PHASE25_OPTIONAL_ADVANCED_MODEL_WORK_REVIEW.md \| less` |
| `maintenance-trackers.tar.gz` | `docs/maintenance/M*.md` + `MAINTENANCE_ROADMAP_M1_M6.md` | Completed maintenance trackers (M0, M7–M21) superseded by ROADMAP | `tar -tzf artifacts/doc-archives/maintenance-trackers.tar.gz` |
| `notion-update-packets.tar.gz` | `docs/*/notion-update-packets/` | Temporary Notion export/import artifacts, never referenced by code | `tar -tzf artifacts/doc-archives/notion-update-packets.tar.gz` |

## How to Search Inside Archives

List contents:
```bash
tar -tzf artifacts/doc-archives/phase12.tar.gz
```

Read one file without extracting:
```bash
tar -xOzf artifacts/doc-archives/phase12.tar.gz docs/phase12/PHASE12M_FINAL_READINESS_CLOSEOUT.md | less
```

Search all archives for a keyword:
```bash
for f in artifacts/doc-archives/*.tar.gz; do
  echo "=== $(basename $f) ==="
  tar -xOzf "$f" | grep -H --label="$(basename $f)" -i "keyword" || true
done
```

## What Stays in docs/

Active and reference documentation:

- `docs/ARCHIVE_INDEX.md` — this file
- `docs/gemma-ui.md` — main UI spec
- `docs/live-system/` — current system state
- `docs/roadmap/ROADMAP.md` — roadmap (includes all phase summaries)
- `docs/phase6/` — current active phase (sandbox readiness)
- `docs/phase9/` — closeout + guardrails (still relevant)
- `docs/maintenance/GEMMA_*.md` — current product docs
- `docs/maintenance/RUVECTOR_*.md` — active memory work
- `docs/research/BAZZITE_LAPTOP_CONFIG_IMPORT_DESIGN.md`
- `docs/architecture/` — reference architecture
- `docs/integrations/` — current integration assessments
- `docs/workflows/` — operational workflow library
- `docs/dashboard/`, `docs/evals/`

## Policy

When a phase is marked complete in `docs/roadmap/ROADMAP.md`, compress its sub-plan files into `artifacts/doc-archives/phaseNN.tar.gz` and remove the `docs/phaseNN/` directory. Keep the closeout file if it provides standalone value; otherwise rely on `ROADMAP.md` for the summary.

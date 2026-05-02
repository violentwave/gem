# Memory Manifest Schema

## Status

Implementation complete (2026-05-02). Helper created.

See `docs/phase9/CONTROLLED_MEMORY_INGESTION_IMPLEMENTATION.md`.

## Purpose

Require a manifest-backed record for any future supervised ingestion.

## Required Fields

| Field | Type | Notes |
|---|---|---|
| `manifest_id` | string | unique identifier |
| `proposal_id` | string | links back to approved proposal |
| `input_source` | string | approved source path |
| `source_class` | enum | `A` or `C` only for ingestion; `B` metadata-only |
| `approved_by` | string | human approver |
| `approved_at` | string | ISO-8601 timestamp |
| `file_count` | integer | planned or actual file count |
| `chunk_count` | integer | planned or actual chunk count |
| `excluded_paths` | array | explicit excluded paths |
| `storage_path` | string | target under `~/.local/share/bazzite-security/ruvector/` |
| `embedding_model` | string | expected model if applicable |
| `embedding_dimensions` | integer | expected dimensions if applicable |
| `fallback_status` | string | must state Stage 3A preserved |
| `rollback_plan_id` | string | links to rollback/reset plan |
| `validation_commands` | array | required post-change checks |
| `stale_review_due` | string | next review date or policy trigger |

## Optional Fields

- `notes`
- `uncertainty`
- `source_summary`
- `related_eval_cases`

## Required Invariants

- manifest cannot exist without proposal linkage
- manifest cannot be executable without human approval
- manifest must preserve Stage 3A fallback language
- manifest must not authorize default-wrapper changes
- manifest must not authorize autonomous ingestion or training

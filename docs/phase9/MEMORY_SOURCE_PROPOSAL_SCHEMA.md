# Memory Source Proposal Schema

## Status

Implementation complete (2026-05-02). Helper created.

See `docs/phase9/CONTROLLED_MEMORY_INGESTION_IMPLEMENTATION.md`.

## Purpose

Standardize future source proposals before any memory ingestion planning or execution.

## Required Fields

| Field | Type | Notes |
|---|---|---|
| `proposal_id` | string | unique human-readable ID |
| `submitted_at` | string | ISO-8601 timestamp |
| `submitted_by` | string | human or supervised operator identity |
| `source_path` | string | narrowly scoped path or glob |
| `source_class` | enum | `A`, `B`, `C`, `D` |
| `purpose` | string | why the source is needed |
| `expected_value` | string | expected retrieval/eval benefit |
| `scope_reason` | string | why this scope is sufficiently narrow |
| `approved_roots_only` | boolean | must remain true |
| `contains_runtime_state` | boolean | expected false for ingestible content |
| `requires_denied_scan` | boolean | always true except pure Class B metadata review |
| `human_approval_status` | enum | `pending`, `approved`, `denied` |

## Optional Fields

| Field | Type | Notes |
|---|---|---|
| `excluded_paths` | array | explicit exclusions |
| `estimated_file_count` | integer | planning estimate |
| `estimated_chunk_count` | integer | planning estimate |
| `related_eval_cases` | array | known-answer or regression links |
| `notes` | string | freeform planning notes |

## Rejection Rules

- `source_class = D` -> reject immediately
- broad roots such as `~/.config`, `~/.local/share`, `~/projects`, `~/offload/security-reports` -> reject
- secrets, `.env`, raw logs, browser data, provider state, private code outside approved scope -> reject

## Approval Rules

- approval must occur after denied-data scan result is attached
- approval must happen before manifest drafting becomes executable
- silence or missing approval is treated as denial

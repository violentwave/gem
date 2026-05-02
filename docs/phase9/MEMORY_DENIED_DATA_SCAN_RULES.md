# Memory Denied-Data Scan Rules

## Status

Implementation complete (2026-05-02). Helper created.

See `docs/phase9/CONTROLLED_MEMORY_INGESTION_IMPLEMENTATION.md`.

## Goal

Define future pre-ingestion scan rules that reject unsafe or private material before approval.

## Hard Reject Categories

### Secrets and credentials

- `.env*`
- `*secret*`
- `*token*`
- `*credential*`
- API/provider keys
- auth headers or bearer tokens

### Private/runtime data

- raw logs
- browser data
- cookies
- Local Storage
- Session Storage
- Trust Tokens
- provider state
- unredacted OpenCode transcripts
- Agent Zero memory/state
- Space Agent state/config

### Broad or unsafe roots

- broad `~/.config/`
- broad `~/.local/share/`
- broad `~/projects/`
- broad `~/.cache/`
- broad `~/offload/security-reports/`

### Unapproved code/data classes

- private project code without explicit narrow approval
- binary blobs
- archives/databases
- oversized files requiring separate review

## Planned Scan Output

Each future scan should emit:

- target path
- included file count
- excluded file count
- matched deny rules
- final status: `PASS` or `REJECT`
- explanation suitable for human review

## Enforcement Rules

- any deny hit blocks approval
- no partial approval for mixed-safe/mixed-denied sources until scope is narrowed
- Class D outcomes are final and non-overridable
- scan must complete before manifest approval

## Examples Of Allowed Narrow Scope

- explicitly approved sanitized docs subset
- approved knowledge docs path
- scoped repo docs path used only for documentation metadata

## Examples Of Rejected Scope

- `~/projects/*`
- `~/offload/security-reports/*`
- `~/.local/share/*`
- `~/.config/*`

# Phase 9D: RAG Quality Monitoring Plan

## Status

Planning only.

## Goal

Define a future manual-only quality checker for supervised RAG behavior.

## Future Helper

- `gemma-memory-quality-check`

## Mandatory Requirements

- no daemon
- no timer
- lightweight query set
- Stage 3A comparison
- known-answer checks
- output report to `~/offload/security-reports/manual/`
- log to `~/.local/state/bazzite-security/logs/`
- PASS/WARN/FAIL result
- no autonomous remediation

## Proposed Query Set

- approved knowledge docs path
- firewall tool
- reports/logs path
- unattended OpenCode boundary
- RuVector supervised/prototype status
- Stage 3A fallback status

## Proposed Output Fields

- query
- expected canonical answer
- actual answer fragment
- context source used
- Stage 3A comparison note
- result: PASS/WARN/FAIL
- escalation note if manual follow-up is needed

## Review Policy

- run manually only when requested
- use small bounded queries
- if WARN/FAIL appears, human decides next action
- checker must never rewrite helpers or adjust wrapper defaults on its own

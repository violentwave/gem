# Phase 9C: Eval Expansion Plan

## Status

Phase 9C.1 and 9C.2 implemented. Planning only for 9C.3+.

## Goal

Expand regression coverage for supervised memory helpers while preserving the existing validator baseline.

## Scope

- `gemma-memory-search`
- `gemma-memory-rag`
- known-answer regressions for canonical operational facts

## Required Regression Topics

- Gemma knowledge docs path -> `~/.local/share/bazzite-security/gemma-knowledge/docs/`
- firewall tool -> `firewalld`
- report/log paths
- local Gemma not doing unattended OpenCode implementation
- RuVector supervised/prototype status
- Stage 3A fallback preserved

## Recommended Fixture Locations

- repo-local planning fixture: `tests/fixtures/memory-known-answer-queries.jsonl`
- future approved live cases only when explicitly authorized: `~/.local/share/bazzite-security/gemma-evals/cases/`

## Planned Additions

### Search helper coverage

- recommendation/fallback assertions
- confidence bucket expectations
- known-answer direct evidence checks
- supervised/prototype status checks

### RAG helper coverage

- answer includes canonical path/fact
- fallback path works when RuVector evidence is weak
- report/log path answer correctness
- no unattended-implementation guidance regression

## Suggested Test Shape

- small JSONL known-answer fixtures
- each case contains query, expected answer fragment, expected source mode, and fallback expectation where relevant
- avoid large datasets unless explicitly requested

## Validation Policy

- new evals must not weaken existing validator PASS state
- planning may recommend new commands, but existing validators remain the acceptance gate until expansion is approved

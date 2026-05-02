# Phase 9F: Agent Zero / Space Agent Guardrails

## Status

Guardrails reviewed (2026-05-02). Agent Zero/Space Agent autonomy remains blocked.

## Core Rules

- Agent Zero supervised only
- Space Agent manual UI only
- no broad host authority
- no local machine write authority by default
- no autonomous security remediation
- no connector promotion without explicit high-risk review

## Agent Zero Rules

- no unattended execution
- no permission broadening by default
- no live-system mutation in Phase 9 planning
- use only as a future supervised orchestration surface after separate approval

## Space Agent Rules

- manual UI only
- no repo edit authority for `~/projects/gem` by default
- no autonomous task execution
- no config mutation from this repo planning phase
- no broad host filesystem delegation

## Shared Review Rules

- human approval required for any connector scope increase
- any future write authority must be narrow, explicit, and separately reviewed
- security remediation remains manual and human-directed

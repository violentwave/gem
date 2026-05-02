# Phase 9E: Future Learning Loop Policy

## Status

Planning policy only.

## Policy Statements

- no autonomous self-training
- no automatic training from raw logs
- no secrets, tokens, `.env`, browser data, private code, or raw transcripts in training data
- human-curated examples only
- RAG + evals before LoRA/fine-tuning
- fine-tuning remains future/last stage only
- GTX 1060 6GB is not a practical local LoRA training target

## Data Policy

Allowed future candidates are limited to human-curated, sanitized, narrowly scoped examples approved for learning review.

Denied future candidates include:

- raw logs
- reports with private content
- provider state
- browser/session storage
- Agent Zero memory
- Space Agent state
- unapproved private code
- unredacted transcripts

## Strategy Order

1. strengthen deterministic retrieval and supervised RAG
2. expand evals and known-answer regressions
3. use manual quality review and rollback discipline
4. only then consider future fine-tuning discussions

## Training Readiness Rule

No future training phase should begin until:

- retrieval/eval coverage is judged sufficient
- curated examples exist
- privacy boundaries are reviewable
- rollback and comparison plans are documented

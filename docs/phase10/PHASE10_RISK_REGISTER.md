# Phase 10 Risk Register

## 1) Accidental Ingestion Risk
- Risk: Running execution paths instead of planning helpers
- Mitigation: Use planning helpers only; enforce non-executable outputs
- Stop Condition: Any command attempts ingestion/indexing

## 2) Secret/Private-Data Ingestion Risk
- Risk: Unsafe source or denied content enters plan scope
- Mitigation: Mandatory denied-data check and human review packet
- Stop Condition: Denied-data status `REJECT` or class recommendation `D`

## 3) Over-Trusting RuVector Risk
- Risk: Treating prototype memory as canonical
- Mitigation: Stage 3A fallback must be explicitly confirmed in outputs
- Stop Condition: Missing/invalid Stage 3A fallback confirmation

## 4) Rollback Ambiguity Risk
- Risk: Rollback intent unclear or incomplete
- Mitigation: Require rollback plan artifact with explicit revert steps and triggers
- Stop Condition: Missing rollback plan or missing validation-after-reset section

## 5) Quality-Check False WARN Risk
- Risk: Live-search exact-fragment matching may warn despite acceptable behavior
- Mitigation: Record WARN cause, avoid silent acceptance, keep review human-mediated
- Stop Condition: WARN without documented cause and reviewer disposition

## 6) Wrapper-Default Drift Risk
- Risk: Dry-run work accidentally changes defaults
- Mitigation: No wrapper default changes in Phase 10A/10B planning work
- Stop Condition: Any diff touching default wrapper behavior

## 7) Autonomous Learning/Training Risk
- Risk: Policy drift into self-training or raw-data training
- Mitigation: Enforce Phase 9E policy and explicit no-training boundary
- Stop Condition: Any training execution request without privacy review + curated dataset + rollback/comparison plan

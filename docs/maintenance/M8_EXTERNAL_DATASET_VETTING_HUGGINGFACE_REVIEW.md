# M8 — External Dataset Vetting / Hugging Face Review

**Phase:** M8 — External Dataset Vetting / Hugging Face Review  
**Date:** 2026-05-02  
**Status:** COMPLETE  
**Type:** Review-only maintenance phase (no downloads, no training)

---

## Purpose

Review candidate Hugging Face datasets for possible future curated-example inspiration. This phase does not download datasets by default, does not train or fine-tune, does not bulk-import examples, and does not modify model configs or live examples/evals. The output is a vetted candidate list, rejection criteria, and next-step recommendation.

---

## Current M7 Gate Status

From [M7_CONTROLLED_TRAINING_READINESS_REVIEW.md](M7_CONTROLLED_TRAINING_READINESS_REVIEW.md):

| Gate | Status | Blocker? |
|------|--------|----------|
| 1: Dataset size (100+) | FAIL | YES |
| 2: Generation-suitable (50%+) | PASS | NO |
| 3: Eval cases (50+) | FAIL | YES |
| 4: Zero drafts | PASS | NO |
| 5: Zero secrets | PASS | NO |
| 6: Zero raw data | PASS | NO |
| 7: Human review | PASS | NO |
| 8: RAG baseline | FAIL | YES |
| 9: RAG failure cases | FAIL | YES |
| 10: Rollback plan | PASS | NO |
| 11: Human approval | FAIL | YES |

**Training readiness:** NOT READY  
**Fine-tuning:** DEFERRED indefinitely  
**Hugging Face datasets:** REVIEW-ONLY

---

## Why HF Datasets Are Review-Only

Hugging Face datasets are treated as **candidate material only**, not direct training data, for the following reasons:

1. **Training is blocked** — M7 gates are not met. No training can occur until gates pass.
2. **Quality unknown** — Public datasets vary widely in quality, relevance, and accuracy.
3. **License risk** — Some datasets have restrictive licenses (NC, ND) or unknown provenance.
4. **Contradiction risk** — Generic Linux advice may contradict Bazzite-specific policies (apt vs rpm-ostree, ufw vs firewalld).
5. **Secret/privacy risk** — Datasets may contain leaked credentials, PII, or proprietary code.
6. **Security risk** — Some datasets may include harmful or offensive content.
7. **RAG is sufficient** — Current RAG system (Stage 3A + RuVector) handles all known use cases.

---

## Dataset Acceptance Criteria

A dataset may be considered for **sample review only** if it meets ALL of the following:

| Criterion | Requirement |
|-----------|-------------|
| **License** | Permissive (MIT, Apache-2.0, CC-BY) or public domain |
| **Domain** | Linux system administration, security, open-source tooling |
| **Quality** | High (coherent, accurate, well-formed) |
| **Bazzite alignment** | Medium or high (can be rewritten for Bazzite context) |
| **No contradictions** | Core advice does not conflict with Bazzite policies |
| **No secrets** | No API keys, tokens, passwords in samples |
| **No PII** | No personal data in samples |
| **No harmful content** | No malware instructions, exploits, or offensive material |
| **Rewritable** | Samples can be sanitized and rewritten for Bazzite context |

---

## Dataset Rejection Criteria

A dataset is **REJECTED** if ANY of the following are true:

| Criterion | Reason |
|-----------|--------|
| **Unknown/restrictive license** | Legal risk |
| **Personal data dumps** | PII risk |
| **Proprietary code corpora** | License risk |
| **Unfiltered web scrapes** | Quality risk, contradiction risk |
| **Malware/exploit datasets** | Safety risk |
| **Non-English (primary)** | Current stack is English-only |
| **Ubuntu/Debian-specific (primary)** | High contradiction risk with Bazzite |
| **Contains secrets in samples** | Security risk |
| **Contains harmful/offensive content** | Safety risk |
| **Cannot be rewritten for Bazzite** | impractical |

---

## License Review Requirements

For each candidate dataset:

- [ ] Identify license from dataset card
- [ ] Confirm commercial/personal use allowed
- [ ] Confirm derivative works allowed
- [ ] Document license in candidate matrix
- [ ] Reject if license is unknown, restrictive (NC, ND), or incompatible

---

## Sample Review Requirements

For each candidate dataset:

- [ ] Inspect 5–10 sample rows (via HF dataset viewer or public sample)
- [ ] Assess quality (grammar, coherence, accuracy)
- [ ] Assess Bazzite domain alignment
- [ ] Document findings in candidate matrix
- [ ] Reject if samples are low quality, off-topic, or machine-generated garbage

---

## Bazzite Contradiction Scan

Each sample must be checked for contradictions with Bazzite policies:

- [ ] Recommends `apt` instead of `rpm-ostree`
- [ ] Recommends `ufw` instead of `firewalld`
- [ ] Recommends modifying system files directly (not via rpm-ostree)
- [ ] Recommends `sudo` without justification
- [ ] Recommends disabling security features
- [ ] Recommends non-Flatpak GUI app installation
- [ ] Recommends host package installation without review
- [ ] Recommends `systemctl enable` for user services

**Reject sample if:** Contradiction is unresolvable or would require fundamental rewrite.

---

## Secret / Privacy Scan

Each sample must be scanned for:

- [ ] API keys or tokens
- [ ] Passwords or credentials
- [ ] SSH keys or certificates
- [ ] Email addresses
- [ ] Phone numbers
- [ ] Names or addresses
- [ ] Internal hostnames or IPs
- [ ] Proprietary code snippets

**Reject sample if:** Any secret or PII found.

---

## Security / Offensive-Content Policy

Each sample must be scanned for:

- [ ] Malware instructions or payload code
- [ ] Exploit techniques or CVE demonstrations
- [ ] Social engineering guidance
- [ ] Hate speech or offensive language
- [ ] Illegal activity instructions
- [ ] Instructions to bypass security controls

**Reject sample if:** Any security or offensive content found.

---

## Categories of Useful Datasets

| Category | Use Case | Example Domains |
|----------|----------|----------------|
| **Linux system administration** | Command review examples | File management, process control, networking |
| **Security best practices** | Policy examples | Firewall, access control, audit, hardening |
| **Open-source tooling** | RAG answer examples | CLI tools, containers, package managers |
| **Technical documentation** | Style reference | README templates, man pages, help text |
| **Shell scripting** | Command review examples | Bash, POSIX sh, script patterns |

## Categories to Avoid

| Category | Reason |
|----------|--------|
| **Personal data dumps** | PII risk |
| **Proprietary code corpora** | License risk |
| **Unfiltered web scrapes** | Quality risk |
| **Malware/exploit datasets** | Safety risk |
| **Unlicensed data** | Legal risk |
| **Non-English (primary)** | Language mismatch |
| **Ubuntu/Debian-specific** | High contradiction risk |
| **Cloud-provider-specific** | Off-topic for local stack |
| **Windows-specific** | Off-topic for Bazzite |

---

## Candidate Scoring Matrix

| Factor | Weight | Score Range | Notes |
|--------|--------|-------------|-------|
| **License compatibility** | High | 0–10 | 10 = permissive, 0 = unknown/restrictive |
| **Domain relevance** | High | 0–10 | 10 = directly relevant, 0 = off-topic |
| **Sample quality** | High | 0–10 | 10 = high quality, 0 = garbage |
| **Bazzite alignment** | Medium | 0–10 | 10 = fully aligned, 0 = fully contradictory |
| **Rewrite feasibility** | Medium | 0–10 | 10 = easy to rewrite, 0 = impossible |
| **Security risk** | High | 0–10 | 10 = no risk, 0 = high risk |
| **Privacy risk** | High | 0–10 | 10 = no risk, 0 = high risk |

**Scoring:**
- **80+:** Strong candidate — approve for sample review
- **60–79:** Moderate candidate — review with caution
- **< 60:** Weak candidate — reject

---

## Final Decision

### Are Any Datasets Approved for Sample Review?

**Decision: NO DATASETS APPROVED AT THIS TIME**

**Rationale:**
1. No specific dataset candidates have been identified by the human operator.
2. M7 gates are not met — even approved datasets cannot be used for training.
3. RAG is sufficient for all current use cases.
4. Manual example curation (Phase 13 style) is preferred over dataset-derived examples.

### What Would Enable Approval?

1. Human identifies 3–5 specific HF dataset candidates.
2. M7 dataset size gate moves toward 100+ examples.
3. A clear gap exists that RAG cannot fill.
4. Human explicitly approves dataset review effort.

---

## Recommended Next Steps

| Option | Description | Trigger |
|--------|-------------|---------|
| **M9: RAG Quality Tuning** | Improve retrieval quality, expand evals | Next maintenance cycle |
| **Manual example expansion** | Add 10–20 curated examples manually | Human approves |
| **Dataset candidate search** | Human identifies HF datasets to review | Human provides candidates |
| **Return to M1/M2** | Regular maintenance | 2026-05-09 |

---

## PASS/WARN/FAIL Summary

| Check | Status | Notes |
|-------|--------|-------|
| Vetting policy reviewed | PASS | HUGGINGFACE_DATASET_VETTING_POLICY.md |
| Acceptance criteria defined | PASS | 9 criteria |
| Rejection criteria defined | PASS | 10 criteria |
| Scoring matrix defined | PASS | 7 factors, weighted |
| Candidate matrix created | PASS | Template ready |
| Sample review template created | PASS | Template ready |
| No datasets downloaded | PASS | Review-only |
| No training occurred | PASS | No training |
| No examples modified | PASS | No changes to live examples |
| Validators pass | PASS | All validators PASS |

| Category | Count |
|----------|-------|
| PASS | 10 |
| WARN | 0 |
| FAIL | 0 |

**Overall: M8 COMPLETE — No datasets approved (correct outcome for review-only phase)**

---

## Artifacts

| Artifact | Location |
|----------|----------|
| This review | `docs/maintenance/M8_EXTERNAL_DATASET_VETTING_HUGGINGFACE_REVIEW.md` |
| Candidate matrix | `docs/maintenance/HUGGINGFACE_DATASET_CANDIDATE_MATRIX.md` |
| Sample review template | `docs/maintenance/HUGGINGFACE_SAMPLE_REVIEW_PACKET_TEMPLATE.md` |
| M8A prompt | `prompts/opencode/m8a-huggingface-dataset-sample-review.prompt.txt` |

---

## Sign-Off

- M8: COMPLETE
- Datasets approved: NONE
- Datasets reviewed: NONE (no candidates provided)
- Datasets downloaded: NONE
- Training performed: NONE
- Examples modified: NONE
- All safety boundaries: MAINTAINED
- Date: 2026-05-02

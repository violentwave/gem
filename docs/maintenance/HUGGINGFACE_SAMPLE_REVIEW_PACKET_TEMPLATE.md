# Hugging Face Sample Review Packet Template

**Version:** 1.0  
**Date:** 2026-05-02  
**Status:** TEMPLATE — Use for each dataset reviewed

---

## Purpose

Standardized packet for reviewing individual samples from a Hugging Face dataset candidate. One packet per dataset. Completed packets are submitted for human approval before any sample is used for example curation.

---

## Packet Header

```markdown
# Sample Review Packet: {dataset_name}

**Reviewer:** {name}  
**Date:** {YYYY-MM-DD}  
**Dataset:** {HF URL}  
**License:** {license}  
**Total Samples Reviewed:** {count}
```

---

## Section 1: Dataset Overview

| Field | Value |
|-------|-------|
| **Dataset Name** | |
| **HF URL** | |
| **License** | |
| **Size** | {rows} rows, {size} |
| **Domain** | |
| **Description** | |
| **Source** | {academic/crowdsourced/synthetic/unknown} |

---

## Section 2: Sample Review Log

For each sample reviewed, complete one row:

| # | Sample ID | Quality | Relevant? | Contradiction? | Secret/PII? | Security Risk? | Rewriteable? | Decision |
|---|-----------|---------|-----------|----------------|-------------|----------------|--------------|----------|
| 1 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 2 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 3 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 4 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 5 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 6 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 7 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 8 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 9 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |
| 10 | | High/Med/Low | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Accept/Reject/Review |

---

## Section 3: Deny-Rule Hits

Check all that apply across reviewed samples:

- [ ] API keys or tokens found
- [ ] Passwords or credentials found
- [ ] SSH keys or certificates found
- [ ] Email addresses found
- [ ] Phone numbers found
- [ ] Names or addresses found
- [ ] Internal hostnames or IPs found
- [ ] Proprietary code snippets found
- [ ] Malware instructions found
- [ ] Exploit techniques found
- [ ] Social engineering guidance found
- [ ] Hate speech or offensive language found
- [ ] Illegal activity instructions found
- [ ] Instructions to bypass security controls found

**Total deny-rule hits:** {count}

---

## Section 4: Bazzite Contradiction Hits

Check all that apply across reviewed samples:

- [ ] Recommends `apt` instead of `rpm-ostree`
- [ ] Recommends `ufw` instead of `firewalld`
- [ ] Recommends modifying system files directly
- [ ] Recommends `sudo` without justification
- [ ] Recommends disabling security features
- [ ] Recommends non-Flatpak GUI app installation
- [ ] Recommends host package installation without review
- [ ] Recommends `systemctl enable` for user services
- [ ] Recommends `dpkg` or `apt-get`
- [ ] Recommends `update-grub` instead of `rpm-ostree upgrade`

**Total contradiction hits:** {count}  
**Resolvable contradictions:** {count}  
**Unresolvable contradictions:** {count}

---

## Section 5: Rewrite / Sanitize Notes

For each accepted sample, document rewrite requirements:

| # | Original Summary | Rewrite Required? | Rewrite Notes |
|---|------------------|-------------------|---------------|
| 1 | | Yes/No | |
| 2 | | Yes/No | |
| 3 | | Yes/No | |

---

## Section 6: Proposed Curated Examples

For each accepted and rewritten sample, document the proposed example:

| # | Type | Category | Description | Status |
|---|------|----------|-------------|--------|
| 1 | command_review / rag_answer / path_policy / bad_to_corrected | | | Proposed |
| 2 | command_review / rag_answer / path_policy / bad_to_corrected | | | Proposed |
| 3 | command_review / rag_answer / path_policy / bad_to_corrected | | | Proposed |

---

## Section 7: Summary

| Metric | Value |
|--------|-------|
| **Total samples reviewed** | |
| **Rejected samples** | |
| **Accepted as inspiration** | |
| **Denied-rule hits** | |
| **Bazzite contradiction hits** | |
| **Resolvable contradictions** | |
| **Unresolvable contradictions** | |
| **Proposed curated examples** | |

---

## Section 8: Human Approval

**Reviewer:** ___________________  
**Date:** ___________________  

### Approval Decision

- [ ] **APPROVED** — Accepted samples may be rewritten and added to example set
- [ ] **REJECTED** — No samples from this dataset may be used
- [ ] **CONDITIONAL** — Approved with conditions: ___________________

### Conditions (if conditional)

_________________________________________________________________  
_________________________________________________________________

### Signature

By checking "APPROVED" or "CONDITIONAL", the reviewer confirms:
- All reviewed samples have been inspected for secrets, PII, and harmful content
- All Bazzite contradictions have been identified and either resolved or rejected
- All proposed examples will be rewritten for Bazzite context
- No raw dataset samples will be used verbatim

---

## Sign-Off

- Packet: TEMPLATE
- Status: Ready for use
- Date: 2026-05-02

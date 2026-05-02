# Hugging Face Dataset Vetting Policy

**Version:** 1.0  
**Date:** 2026-05-02  
**Status:** ACTIVE

---

## Purpose

Define the policy for reviewing Hugging Face datasets as candidate material for the Bazzite Local AI Operations Stack. This policy applies to all dataset review activities.

**Important:** This is a vetting policy, not a training policy. Datasets are reviewed as candidates only. No direct training, bulk import, or automated ingestion occurs.

---

## Core Principles

1. **Candidate material only** — HF datasets are potential sources of examples, not direct training data.
2. **No download by default** — Datasets are not downloaded unless explicitly approved for a specific review task.
3. **No bulk import** — Individual samples may be reviewed; bulk ingestion is prohibited.
4. **Human approval required** — All dataset-derived examples must be human-reviewed before inclusion.
5. **Rewrite and sanitize** — Raw dataset samples must be rewritten for Bazzite context; never used verbatim.

---

## Allowed Actions

| Action | Scope | Approval |
|--------|-------|----------|
| **Browse dataset cards** | Read-only metadata | None needed |
| **Review license** | Read-only legal | None needed |
| **Inspect sample rows** | Single samples only | None needed (public data) |
| **Document findings** | Markdown reports | None needed |
| **Produce candidate packet** | Summary + sample analysis | None needed |
| **Rewrite for examples** | Synthetic, sanitized | Human approval required |

## Prohibited Actions

| Action | Status |
|--------|--------|
| **Download full dataset by default** | PROHIBITED |
| **Bulk import into knowledge pack** | PROHIBITED |
| **Direct training on raw dataset** | PROHIBITED |
| **Auto-ingest without review** | PROHIBITED |
| **Use dataset samples verbatim** | PROHIBITED |
| **Include dataset samples without sanitization** | PROHIBITED |
| **Include secrets/PII from datasets** | PROHIBITED |

---

## Vetting Workflow

### Step 1: License Review

Before reviewing any dataset:

- [ ] Identify license (MIT, Apache-2.0, CC, etc.)
- [ ] Confirm commercial use allowed (if applicable)
- [ ] Confirm derivative works allowed
- [ ] Document license in candidate packet

**Reject if:** License is unknown, restrictive (NC, ND), or incompatible with personal use.

### Step 2: Sample Review

- [ ] Inspect 5–10 random samples
- [ ] Check for quality (grammar, coherence, relevance)
- [ ] Check for Bazzite domain alignment (Linux, security, system administration)
- [ ] Document sample quality in candidate packet

**Reject if:** Samples are low quality, off-topic, or machine-generated garbage.

### Step 3: Denied-Pattern Scan

Each sample must be scanned for:

- [ ] Secrets (API keys, tokens, passwords)
- [ ] PII (names, emails, phone numbers, addresses)
- [ ] Private code (proprietary snippets, internal tools)
- [ ] Raw logs (system logs, error dumps)
- [ ] Browser data (cookies, sessions, history)
- [ ] Auth files (SSH keys, certificates)
- [ ] Harmful content (malware instructions, exploits)
- [ ] Illegal content (any jurisdiction)

**Reject if:** Any denied pattern found in samples.

### Step 4: Bazzite Contradiction Scan

Each sample must be checked for contradictions with Bazzite policies:

- [ ] Recommends `apt` instead of `rpm-ostree`
- [ ] Recommends `ufw` instead of `firewalld`
- [ ] Recommends modifying system files directly
- [ ] Recommends `sudo` without justification
- [ ] Recommends disabling security features
- [ ] Recommends non-Flatpak GUI app installation
- [ ] Recommends host package installation without review

**Reject if:** Sample contradicts core Bazzite policies and cannot be rewritten.

### Step 5: Rewrite / Sanitize

If a sample passes all scans:

- [ ] Rewrite in Bazzite/Fedora Atomic context
- [ ] Replace generic Linux advice with Bazzite-specific advice
- [ ] Add `firewalld`, `rpm-ostree`, `Flatpak` context where relevant
- [ ] Remove any generic package manager references
- [ ] Ensure no secrets or PII in rewritten version
- [ ] Mark as `source: synthetic_derived_from_hf`

**Requirement:** Rewritten sample must be indistinguishable from manually authored examples.

### Step 6: Human Approval

- [ ] Submit candidate packet to human reviewer
- [ ] Include original sample + rewritten sample + vetting checklist
- [ ] Obtain explicit approval before adding to example set
- [ ] Record approval in learning ledger (if implemented)

---

## Allowed Dataset Categories

| Category | Examples | Use Case |
|----------|----------|----------|
| **Linux system administration** | Command references, configuration guides | Command review examples |
| **Security best practices** | Firewall rules, access control, audit | Policy examples |
| **Open-source tooling** | CLI tools, package managers, containers | RAG answer examples |
| **Documentation style** | Technical writing, README templates | Style reference |

## Rejected Dataset Categories

| Category | Reason |
|----------|--------|
| **Personal data dumps** | PII risk |
| **Proprietary code corpora** | License risk |
| **Web scrapes (unfiltered)** | Quality risk, contradiction risk |
| **Malware/exploit datasets** | Safety risk |
| **Unlicensed data** | Legal risk |
| **Non-English (primary)** | Current stack is English-only |
| **Ubuntu/Debian-specific** | High contradiction risk with Bazzite |

---

## Required Metadata Fields

For each dataset reviewed, record:

```markdown
## Dataset: {name}

- **HF URL:** {url}
- **License:** {license}
- **Size:** {rows} rows, {size} GB
- **Domain:** {linux/security/general}
- **Quality:** {high/medium/low}
- **Bazzite alignment:** {high/medium/low}
- **Denied patterns found:** {none/list}
- **Contradictions found:** {none/list}
- **Samples reviewed:** {count}
- **Rewritable samples:** {count}
- **Recommendation:** {accept/reject/review}
- **Reviewer:** {name}
- **Date:** {YYYY-MM-DD}
```

---

## Sample Vetting Checklist

For each sample considered:

- [ ] No secrets
- [ ] No PII
- [ ] No private code
- [ ] No raw logs
- [ ] No browser data
- [ ] No auth files
- [ ] No harmful content
- [ ] No Bazzite contradictions (or can be rewritten)
- [ ] Relevant to Bazzite domain
- [ ] High quality (coherent, accurate)
- [ ] Rewritten for Bazzite context
- [ ] Human approved

---

## Sign-Off

- Policy: ACTIVE
- Status: Review-only
- No datasets downloaded
- No training performed
- Date: 2026-05-02

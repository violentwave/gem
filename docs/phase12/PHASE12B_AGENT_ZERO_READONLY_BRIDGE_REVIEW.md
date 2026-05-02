# Phase 12B: Agent Zero Read-Only Bridge Review

**Phase:** 12B — Agent Zero Read-Only Bridge Review
**Date:** 2026-05-02
**Parent:** Phase 12A (Supervised Bridge Planning)
**Status:** Review Complete / Ready for Explicit Runtime Dry-Run

---

## Purpose

Review whether Agent Zero can safely consume existing read-only repo docs/reports and produce a briefing, without starting Agent Zero by default, modifying Agent Zero config, granting write access, or enabling autonomous behavior.

This phase is **documentation + readiness review only**. Agent Zero was NOT started, NOT modified, and NOT granted any authority.

---

## Current Agent Zero Known State

### Installation Status
| Attribute | Value |
|-----------|-------|
| Helper Scripts | ✅ `agent-zero-up`, `agent-zero-down`, `a0` in `~/.local/bin/` |
| Config Dir | ✅ `~/.config/agent-zero/` exists |
| Data Dir | ✅ `~/.local/share/agent-zero/usr/` exists |
| Container Image | `docker.io/agent0ai/agent-zero:latest` |
| Container Status | **NOT RUNNING** (confirmed via `podman ps`) |
| Port 5080 | Not in use by Agent Zero |
| Auto-Start | **NO** (`restart: "no"` in compose file) |

### Config Files Inventory
| File | Purpose |
|------|---------|
| `docker-compose.yml` | Docker Compose spec (port 5080, volume mount, no restart) |
| `podman-compose.yml` | Podman Compose spec |
| `README.md` | Local setup documentation |
| `PROFILE_SETUP.md` | Profile setup for `agent0` and `hacker` modes |
| `SECRETS_SETUP.md` | Secrets handling rules |
| `project-templates/*.md` | Project instruction templates |

### Runtime Configuration
- **Port:** `127.0.0.1:5080:80`
- **Volume Mount:** `${HOME}/.local/share/agent-zero/usr:/a0/usr`
- **Restart Policy:** `no` (no auto-restart)
- **Networking:** Container networking has known limitations on this host
- **OpenCode Bridge:** Mentioned as functional but separate from Agent Zero container

### Previous Runtime History
- **Phase 7A Startup:** Successful (2026-04-30)
- **Container exited:** ExitCode 0 (clean exit)
- **Processes when running:** supervisord, the_listener, run_cron, run_searxng, run_sshd, run_tunnel_api, run_ui (Flask), self_update_manager
- **No systemd service:** Intentionally manual

---

## Read-Only Bridge Candidate

### Approved Workflow: Read-Only Repo Briefing Display

Agent Zero reads existing repo docs/reports and produces a structured briefing for human review.

**Why this is safe:**
- Input is existing read-only documents
- No file writes to repo
- No system commands
- No network requests to external services
- No memory mutation
- Output is a Markdown summary for human review only

---

## Allowed Inputs

- Existing repo docs (`~/projects/gem/docs/**/*.md`)
- Existing reports (`~/offload/security-reports/**/*.md`)
- Existing validator outputs (read-only)
- Existing Phase 11/12 documentation
- Existing manifest files (read-only)

---

## Denied Inputs

- Live system state (e.g., real-time process lists)
- External URLs (no network fetching)
- Secrets or credential files
- Raw logs with sensitive data
- Browser data or cookies
- Private project source code

---

## Allowed Outputs

- Markdown briefing/summary
- Structured comparison table
- Status dashboard
- Human-readable checklist
- Advisory recommendations (not actionable without human approval)

---

## Denied Actions

- File write/edit in `~/projects/gem`
- System commands with sudo
- Network requests to external APIs
- Git operations (commit, push, branch)
- Package installation
- Service start/stop
- Ollama config modification
- Memory ingestion, indexing, mutation, promotion
- Learning/training execution
- OpenCode prompt autonomous execution
- Daemon/timer scheduling

---

## Authority Matrix

| Authority | OpenCode | Agent Zero (Read-Only Bridge) |
|-----------|----------|-------------------------------|
| Repo write (`~/projects/gem`) | ✅ Yes | ❌ No |
| Host write (system configs) | ❌ No | ❌ No |
| Sudo/root | ❌ No | ❌ No |
| Package install | ❌ No | ❌ No |
| Firewall changes | ❌ No | ❌ No |
| Ollama config | ❌ No | ❌ No |
| Memory mutation | ❌ No | ❌ No |
| Learning/training | ❌ No | ❌ No |
| Read repo docs | ✅ Yes | ✅ Yes* |
| Read reports | ✅ Yes | ✅ Yes* |
| Produce summaries | ✅ Yes | ✅ Yes* |
| Display checklists | ✅ Yes | ✅ Yes* |

*Requires explicit human trigger; read-only only

---

## Runtime Prerequisites

Before any future Phase 12B1 runtime dry-run:

1. **Human approval:** Explicit authorization from human operator
2. **Scope definition:** Single read-only source document identified
3. **Boundary restatement:** All boundaries from this document confirmed
4. **Stop conditions acknowledged:** Human knows when to stop
5. **Output review plan:** Human will review output before any action
6. **Container state check:** Confirm no other critical containers affected
7. **Timebox:** Dry-run should complete within a bounded time (e.g., 10 minutes)

---

## Stop Conditions

Stop immediately if:
- Agent Zero requests file write access
- Agent Zero requests system commands
- Agent Zero requests network access
- Agent Zero requests memory mutation
- Agent Zero requests learning/training execution
- Agent Zero attempts to run OpenCode prompts
- Output contains suspicious or out-of-bounds recommendations
- Human reviewer is not available
- Dry-run exceeds timebox

---

## Dry-Run Design

### Step 1: Human Authorization
- Human explicitly approves starting Agent Zero for read-only dry-run
- Human identifies single source document
- Human confirms understanding of boundaries

### Step 2: Start Agent Zero (If Authorized)
- Use `agent-zero-up` helper script
- Confirm container starts on port 5080
- Verify no auto-restart behavior

### Step 3: Provide Read-Only Input
- Copy single existing doc/report into Agent Zero input area (if needed)
- Or reference existing file via read-only path
- No secrets, no private data

### Step 4: Request Structured Briefing
- Ask Agent Zero to produce Markdown briefing
- Scope: single document summary only
- No follow-up tasks, no autonomous actions

### Step 5: Review Output
- Human reviews briefing for boundary compliance
- Check for suspicious recommendations
- Confirm no file writes or system commands suggested

### Step 6: Stop Agent Zero
- Use `agent-zero-down` helper script
- Confirm container stops cleanly
- Verify no lingering processes

### Step 7: Document Results
- Save briefing to `~/offload/security-reports/manual/` if valuable
- Document boundary compliance
- Note any issues or concerns

---

## Output Review Checklist

Before accepting any Agent Zero output:

- [ ] Output contains only summary/analysis, no actionable commands
- [ ] No file paths suggesting edits to `~/projects/gem`
- [ ] No sudo or system command references
- [ ] No network request instructions
- [ ] No memory mutation suggestions
- [ ] No learning/training recommendations
- [ ] No OpenCode prompt execution suggestions
- [ ] Recommendations are advisory only ("consider", "may want to")
- [ ] Human approval explicitly required for any next step

---

## Compliance Checklist

- [x] Agent Zero NOT started in this phase
- [x] Agent Zero config NOT modified
- [x] No repo write authority granted
- [x] No host write authority granted
- [x] No autonomous behavior enabled
- [x] No memory mutation
- [x] No learning/training execution
- [x] No OpenCode permissions changed
- [x] No system/security changes
- [x] No automation added
- [x] Read-only inspection only

---

## PASS/WARN/FAIL Results

| Item | Status | Notes |
|------|--------|-------|
| Agent Zero installation | PASS | Scripts, config, data dirs present |
| Agent Zero container status | PASS | Not running, no auto-restart |
| Config hygiene | PASS | No secrets in tracked config |
| Volume mount safety | PASS | Only `~/.local/share/agent-zero/usr` mounted |
| Restart policy | PASS | `restart: "no"` prevents auto-restart |
| Read-only bridge feasibility | PASS | Agent Zero can read existing docs |
| Boundary compliance | PASS | All boundaries documented and verified |
| Runtime readiness | PASS | Ready for explicit future dry-run |

| Category | Count |
|----------|-------|
| PASS | 8 |
| WARN | 0 |
| FAIL | 0 |

---

## Recommendation

**RECOMMENDATION: PROCEED to Phase 12B1 runtime dry-run when explicitly authorized.**

Agent Zero is:
- Installed and configured
- Not currently running
- Has safe restart policy
- Has bounded volume mount
- Can theoretically consume read-only docs
- All boundaries are clear and documented

**Conditions for proceeding:**
1. Human explicitly authorizes the dry-run
2. Single read-only source is identified
3. Human is available to review output
4. Timebox is set (e.g., 10 minutes)
5. `agent-zero-down` is ready to stop container after dry-run

---

## Sign-Off

- Phase 12B: REVIEW COMPLETE
- Agent Zero readiness: CONFIRMED (for read-only dry-run only)
- No execution in this phase: CONFIRMED
- Boundaries: PRESERVED
- Future Phase 12B1: Requires explicit prompt
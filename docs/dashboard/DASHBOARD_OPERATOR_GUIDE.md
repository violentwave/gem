# Dashboard Operator Guide

**Document:** Dashboard Operator Guide
**Date:** 2026-05-02
**Version:** 1.0
**Status:** Current

---

## What the Dashboard Is

The Bazzite Local Gemma Agent Dashboard is a **static, read-only HTML page** that gives you a single-screen view of your local AI stack health. It is generated on demand by running `gemma-dashboard-build` and overwritten each time.

Think of it as a **flight instrument panel** for your local Gemma stack — it tells you what is running, what is not, and what you might want to do next, but it does not fly the plane for you.

---

## What the Dashboard Is NOT

- **Not a server.** It is a single HTML file on disk. No port is opened, no daemon runs.
- **Not an agent.** It does not take actions, run commands, or make changes.
- **Not a chat UI.** For conversation with Gemma, use Space Agent.
- **Not a replacement for Space Agent.** Space Agent is the interactive dashboard; this is the status dashboard.
- **Not a replacement for evals.** It shows eval status but does not run them.

---

## How to Refresh the Dashboard

### From the repo

```bash
/var/home/lch/projects/gem/scripts/gemma-dashboard-build
```

### From PATH (optional install)

If you installed the symlink to `~/.local/bin`:

```bash
gemma-dashboard-build
```

The script generates three outputs every time it runs:

| Output | Path |
|--------|------|
| HTML dashboard | `~/.local/share/bazzite-security/dashboard/index.html` |
| Markdown report | `~/offload/security-reports/manual/gemma-dashboard-YYYYMMDD-HHMMSS.md` |
| Build log | `~/.local/state/bazzite-security/logs/gemma-dashboard-YYYYMMDD-HHMMSS.log` |

---

## How to Open the Dashboard

### Manually

Open the HTML file in any browser:

```bash
# From terminal
xdg-open ~/.local/share/bazzite-security/dashboard/index.html

# Or just navigate to the file in your browser
# file:///home/lch/.local/share/bazzite-security/dashboard/index.html
```

### With --open flag

```bash
gemma-dashboard-build --open
```

This generates the dashboard and then opens it in your default browser using `xdg-open`.

---

## How to Chat with Gemma

The dashboard is **not a chat box**. It is a status page only. To actually talk to Gemma, use **Space Agent**.

### Steps

1. **Start Space Agent** (if not running):
   ```bash
   ~/Applications/Space-Agent.AppImage
   ```

2. **In Space Agent, open the chat panel.**
   - Look for the "Local LLM" or "Chat" option.
   - If prompted, select the local Ollama provider.

3. **Select the local Gemma model:**
   - Model: `gemma4-e4b-bazzite:latest`
   - Endpoint: `http://127.0.0.1:11434/v1/chat/completions`
   - API key: `ollama` (placeholder)

4. **Type your message and chat.**

### What If Space Agent Is Not Configured?

Space Agent provider settings are entered manually in the UI. If the local provider is not set up:
- Go to Settings → Provider.
- Add a custom OpenAI-compatible provider.
- Base URL: `http://127.0.0.1:11434/v1`
- Model: `gemma4-e4b-bazzite:latest`
- API key: `ollama`

### Remember

- **Space Agent = chat UI** (interactive, conversational)
- **Static dashboard = status page** (read-only, non-interactive)
- The static dashboard does **not** appear inside Space Agent Spaces unless you manually create a link or custom space.

---

## What Each Panel Means

### 1. Stack Summary

Gives you an **at-a-glance** view:
- **Overall Status:** PASS (green), WARN (yellow), or FAIL (red)
- How many Gemma models are loaded
- How many helper scripts exist
- How many reports are in the manual directory
- How many knowledge docs are indexed

### 2. Space Agent

Shows whether Space Agent is running and where its AppImage is.

- **PASS (green):** Space Agent is running.
- **WARN (yellow):** Space Agent is not running.

**What to do:** If WARN, start Space Agent manually:
```bash
~/Applications/Space-Agent.AppImage
```

### 3. Ollama / Gemma

Shows Ollama version, API health, GPU memory usage, and loaded models.

- **PASS (green):** Ollama API responds.
- **FAIL (red):** Ollama API does not respond.

**What to do:** If FAIL, start Ollama:
```bash
ollama serve
```

### 4. Agent Zero

Shows whether the Agent Zero container is running.

- **WARN (yellow):** Running or not — either way, Agent Zero is **experimental / no-go for local Gemma tool-loop use on v1.9**.

**Why no-go?** Agent Zero expects JSON tool responses (`tool_name`, `tool_args`), but local Gemma returns plain text. The `hacker` profile is autonomous-oriented. No supervised profile exists in v1.9. See M15 review for full details.

**What to do:** Do not rely on Agent Zero for local Gemma tasks. Use Space Agent or direct Ollama API calls instead.

### 5. OpenCode

Shows whether the OpenCode bridge is reachable at `127.0.0.1:4141`.

- **PASS (green):** Bridge is up.
- **FAIL (red):** Bridge is down.

**What to do:** If FAIL and you need OpenCode, start the bridge:
```bash
opencode-bridge-up
```

### 6. Knowledge / RAG

Shows how many knowledge docs, Stage 3A chunks, and RuVector chunks exist, plus whether `gemma-memory-search` and `gemma-memory-rag` are available.

- **Available (green):** The helper exists.
- **Missing (yellow):** The helper is not installed.

### 7. Evals / Examples

Shows the count of eval cases (25) and examples (32), plus whether the validators pass.

- **PASS (green):** Validators pass.
- **FAIL (red):** Validators fail.

**What to do:** If FAIL, run:
```bash
gemma-evals-check
gemma-examples-check
```

### 8. Recent Reports

Lists the 10 most recent files from `~/offload/security-reports/manual/`. Click or navigate to read them.

### 9. Guardrails / No-Go Items

A reminder of the current safety boundaries:
- No autonomous execution
- No system config changes
- Agent Zero local Gemma tool-loop: NO-GO
- RuVector: supervised prototype only
- Training/fine-tuning: deferred
- No secrets in repo

### 10. Next Recommended Actions

Dynamic suggestions based on current status:
- If Space Agent is not running → "Start Space Agent"
- If Ollama is down → "Start Ollama"
- If evals fail → "Run gemma-evals-check"
- If everything is green → "All clear. No immediate action required."

---

## How Space Agent Fits In

**Space Agent** is the **recommended manual local Gemma chat UI**. It is an Electron app that provides a plain-text chat interface connected to local Ollama/Gemma.

| Tool | Purpose | Interactive? |
|------|---------|-------------|
| **Space Agent** | Chat with Gemma | YES |
| **Static dashboard** | View stack status | NO (read-only) |
| **Markdown reports** | Read detailed findings | NO (read-only) |

### Important Distinctions

- **Space Agent is for chat.** Open it when you want to talk to Gemma.
- **The static dashboard is for status.** Open it when you want to see what is running.
- **The static dashboard does NOT appear inside Space Agent Spaces.** Space Agent has its own "Spaces" screen with widgets like news feeds and games. The static dashboard is a separate HTML file on disk. You would need to manually create a custom Space Agent space with a web-view widget to embed it, and that is not currently documented or tested.
- If Space Agent is running but you want the status dashboard, **open both** — they serve different purposes.

---

## Why Agent Zero Is Marked No-Go for Local Gemma Tool-Loop Use

**Three reasons:**

1. **Protocol mismatch:** Agent Zero expects JSON responses with `tool_name` and `tool_args`. Local Gemma returns plain text. This causes errors like `Tool request must have a tool_args (type dictionary) field.`

2. **Profile mismatch:** The only profile in Agent Zero v1.9 is `hacker`, which is designed for autonomous tool-calling with external APIs. No chat-only, supervised, or read-only profile exists.

3. **Safety:** Even if Gemma could emit JSON tools, the `hacker` profile would attempt to execute them autonomously. This is unsafe for a supervised-only local stack.

**Workarounds:**
- Use Space Agent for chat.
- Use direct Ollama API calls for scripts.
- Wait for Agent Zero upstream to add a chat-only mode (not guaranteed).

See [`docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`](docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md) for full details.

---

## Troubleshooting

### Dashboard shows FAIL for Ollama API

```bash
# Check if Ollama is running
curl http://127.0.0.1:11434/api/version

# If not, start it
ollama serve
```

### Dashboard shows WARN for Space Agent

```bash
# Start Space Agent manually
~/Applications/Space-Agent.AppImage
```

### Dashboard shows missing helpers

```bash
# Check what helpers are installed
ls ~/.local/bin/gemma-*

# If missing, check the repo scripts
ls /var/home/lch/projects/gem/scripts/
```

### Dashboard does not update

The dashboard is **not live**. You must run `gemma-dashboard-build` again to refresh it. There is no auto-refresh.

### Browser shows old dashboard

Browsers cache local files. Press **Ctrl+Shift+R** (or Cmd+Shift+R on macOS) to force reload.

---

## Secret / Privacy Policy

The dashboard **never** displays:
- API keys
- Tokens
- Cookies
- Session data
- Provider secrets
- Raw app databases

It only shows:
- File names and sizes
- Process names and status
- Version strings
- Model names
- Public path names

If you see something that looks like a secret in the dashboard, report it as a bug.

---

## Canonical Output Paths

| Output | Path |
|--------|------|
| HTML dashboard | `~/.local/share/bazzite-security/dashboard/index.html` |
| Markdown report | `~/offload/security-reports/manual/gemma-dashboard-YYYYMMDD-HHMMSS.md` |
| Build log | `~/.local/state/bazzite-security/logs/gemma-dashboard-YYYYMMDD-HHMMSS.log` |
| Source script | `/var/home/lch/projects/gem/scripts/gemma-dashboard-build` |

---

## Optional Install

To make `gemma-dashboard-build` available as `gemma-dashboard` from anywhere:

```bash
mkdir -p ~/.local/bin
ln -sf /var/home/lch/projects/gem/scripts/gemma-dashboard-build ~/.local/bin/gemma-dashboard
```

Then run:
```bash
gemma-dashboard --help
gemma-dashboard
gemma-dashboard --open
```

**This is optional.** The script works fine from its repo path without installing.

---

## References

- [`docs/dashboard/LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md`](LOCAL_GEMMA_DASHBOARD_REQUIREMENTS.md)
- [`docs/maintenance/M16_LOCAL_DASHBOARD_PIVOT.md`](../maintenance/M16_LOCAL_DASHBOARD_PIVOT.md)
- [`docs/maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md`](../maintenance/M15_AGENT_ZERO_LOCAL_GEMMA_COMPATIBILITY_REVIEW.md)
- [`docs/integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md`](../integrations/space-agent/SPACE_AGENT_PHASE7E1_PROVIDER_FINALIZATION.md)

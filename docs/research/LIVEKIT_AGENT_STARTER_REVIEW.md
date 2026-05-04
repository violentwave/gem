# LiveKit Agent Starter React — Read-Only Review

**Repo:** https://github.com/livekit-examples/agent-starter-react  
**Review Date:** 2026-05-04  
**Reviewer:** Sisyphus (OpenCode)  
**Scope:** UI/voice pattern inspiration only. No code import. No dependency addition.  

---

## 1. What This Repo Is

A **Next.js 15 + TypeScript** web frontend for LiveKit voice AI agents. It provides a polished, real-time voice interface with:

- **Voice interaction** via LiveKit WebRTC (microphone in, speaker out)
- **Video streaming** and screen sharing
- **Multiple audio visualizers** (bar, grid, radial, wave, aura)
- **Chat transcript panel** with real-time message display
- **Virtual avatars** (Rive animations)
- **Light/dark theme** switching with system preference detection
- **Customizable branding** via a single `app-config.ts` file
- **Agent dispatch** to LiveKit Cloud or self-hosted servers

**Tech stack:** React 19, Next.js 15, Tailwind CSS v4, Radix UI primitives, LiveKit client/server SDK, Framer Motion (via `motion` package), Shiki syntax highlighting, Shadcn/ui component system.

**Dependencies:** ~30 production dependencies including `livekit-client`, `livekit-server-sdk`, `@livekit/components-react`, `next`, `react`, `motion`, `tailwind-merge`, etc.

---

## 2. What We Can Safely Adapt Now

These are **conceptual patterns** we can borrow for our terminal-based `gemma-ui` without adding any web dependencies.

### 2.1 Config-Driven UI (`app-config.ts` pattern)

The repo centralizes all branding, features, and colors in `app-config.ts`:

```ts
export interface AppConfig {
  companyName: string;
  pageTitle: string;
  supportsChatInput: boolean;
  supportsVideoInput: boolean;
  audioVisualizerType?: 'bar' | 'wave' | 'grid' | 'radial' | 'aura';
  accent?: string;
  accentDark?: string;
  startButtonText: string;
  // ...
}
```

**Our equivalent:** We already have `~/.config/bazzite-security/gemma-ui.json`. We can expand it to include:
- `theme` (default color scheme)
- `show_icons` (boolean)
- `confirm_destructive` (boolean)
- `features.voice` / `features.dashboard` (feature flags)
- `default_mode` (which mode opens on startup)

This pattern makes the UI customizable without touching code.

### 2.2 View State Machine (`view-controller.tsx` pattern)

The repo uses a view controller to manage transitions:
- **Welcome** → not connected, shows start button
- **Session** → connected, shows transcript + controls
- **Disconnected** → ended, shows summary or rejoin option

**Our equivalent:** Our `gemma-ui` already has a mode router. We can formalize this as a state machine:
- `welcome` → mode selector / help
- `session` → active mode running (security chat, memory search, etc.)
- `results` → mode completed, show output / report path

This would make mode transitions clearer and allow "back to menu" behavior.

### 2.3 Start/Stop Button Behavior (`welcome-view.tsx` + `agent-control-bar.tsx`)

The repo has a clear pattern:
1. **Welcome screen**: Large centered button to start session
2. **Control bar**: Mute/unmute, chat toggle, disconnect (red, prominent)
3. **Disconnect**: Cleanly ends session, returns to welcome

**Our equivalent:**
- Our mode selector is the "start" screen
- We can add a consistent "/quit" or "/back" command to every mode
- We should make the current mode's exit path more prominent (e.g., a footer hint)

### 2.4 Transcript Panel (`agent-chat-transcript.tsx`)

The repo manages a scrollable chat transcript with:
- Message bubbles (user vs agent)
- Timestamps
- Auto-scroll to bottom
- Typing indicators

**Our equivalent:** Our terminal UI already shows output, but we can improve:
- Add message separation (panels or rules between user queries and Gemma responses)
- Add timestamps to transcript output
- Use Rich `Panel` for each turn (user input in one style, Gemma output in another)
- Add a "thinking..." spinner while waiting for Ollama

### 2.5 Theme/Branding Config

The repo supports light/dark themes via `next-themes` and CSS variables.

**Our equivalent:** Rich supports themes. We can:
- Add a `theme` field to `gemma-ui.json`
- Use Rich's built-in themes (`default`, `monokai`, `github-dark`, etc.)
- Allow custom accent colors in panel borders

### 2.6 Error Handling Patterns

The repo uses React error boundaries and graceful fallbacks (e.g., if LiveKit connection fails, show retry UI).

**Our equivalent:** We already handle missing helpers gracefully. We can improve:
- Add a consistent error panel style (red border, clear message)
- Show "retry" or "fallback" suggestions when a helper fails
- Log errors to `~/.local/state/bazzite-security/logs/gemma-ui.log`

### 2.7 Component Separation

The repo separates:
- `components/agents-ui/` — reusable UI primitives (provided by LiveKit)
- `components/app/` — app-specific logic (welcome, session, controller)
- `components/ui/` — Shadcn/ui primitives (buttons, toggles, tooltips)

**Our equivalent:** Our helpers are already separated:
- `gemma-ui` = router/controller
- `gemma-security-chat` = security session
- `gemma-memory-search` = memory query
- etc.

This separation is good and should be preserved.

---

## 3. What to Avoid for Now

### 3.1 LiveKit SDK Dependencies
- `livekit-client`, `livekit-server-sdk`, `@livekit/components-react`
- These require network credentials, WebRTC, and a LiveKit server
- **Avoid:** Any network service, credential files, WebRTC connections

### 3.2 Next.js / React Runtime
- This is a web application framework, not a terminal UI
- **Avoid:** Adding web frameworks to our terminal tool

### 3.3 Video / Screen Sharing
- Gemma is text-only and advisory
- **Avoid:** Video features, camera access, screen capture

### 3.4 Real-Time Audio Visualizers
- The visualizers (bar, wave, aura, etc.) require Web Audio API and canvas/WebGL
- **Avoid:** These are web-specific and don't translate to terminal
- **Exception:** We could do a simple ASCII/Curses audio level meter if we build a local voice wrapper using `sox` or `parec`, but that's future work

### 3.5 Cloud Sandbox / Agent Dispatch
- `sandboxId`, `AGENT_NAME`, `.env.local` with LiveKit credentials
- **Avoid:** Any cloud dependency, external API keys, or remote agent dispatch

### 3.6 Heavy Animation Libraries
- `motion` (Framer Motion), `@rive-app/react-webgl2`
- **Avoid:** These add significant bundle size and are web-only
- **Exception:** Rich has its own animation capabilities (spinners, progress bars)

---

## 4. Local Gemma Equivalent Design

Based on the LiveKit patterns, here's how we could evolve `gemma-ui`:

### 4.1 Formalized State Machine

```
[welcome] --select mode--> [session] --/quit--> [welcome]
   ↑                           |
   └---------------------------┘ (on error or completion)
```

- **Welcome**: Mode selector, help, status summary
- **Session**: Active helper running (security chat, memory search, etc.)
- **Results**: After session ends, show report path, summary, or error

### 4.2 Improved Transcript Display

Use Rich to create a cleaner chat interface:

```
┌─ User (14:32) ─────────────────────────────┐
│ Check my firewall status                     │
└──────────────────────────────────────────────┘
┌─ Gemma (14:32) ────────────────────────────┐
│ firewalld is active. Default zone: public.  │
│ Default target: DROP. Rich rules: 3.        │
└──────────────────────────────────────────────┘
```

### 4.3 Config-Driven Feature Flags

Expand `gemma-ui.json`:

```json
{
  "version": "1.1.0",
  "default_mode": "general",
  "theme": "default",
  "features": {
    "voice": false,
    "dashboard": false,
    "auto_health_check": true
  },
  "ui": {
    "show_timestamps": true,
    "show_icons": true,
    "confirm_destructive": true,
    "panel_style": "rounded"
  }
}
```

### 4.4 Consistent Control Patterns

Every mode should support:
- `/quit` or `/back` → return to welcome
- `/help` → mode-specific help
- `/status` → show current state

### 4.5 Voice Mode (Future)

If we build `gemma-voice-chat`:
- Use local STT (e.g., `whisper.cpp` via Ollama or `faster-whisper`)
- Use local TTS (e.g., `piper` or Ollama voice output if available)
- The UI pattern from LiveKit: welcome → start listening → show transcript → stop
- Terminal equivalent: show "🎤 Listening..." with a spinner, print transcript, show "🔊 Speaking..." when Gemma responds

---

## 5. Future Web UI Possibility

If we ever want a web-based dashboard for Gemma (not terminal), the LiveKit starter provides a good **architecture blueprint**:

- **Next.js + React** for the framework
- **Config-driven** branding via a single config file
- **Component separation** (primitives vs app logic)
- **Theme switching** for accessibility
- **Session state management** for mode transitions

However, for our current Bazzite Local AI Ops Stack:
- **Terminal-first is correct** — no web server, no daemon, no port exposure
- **Web UI would be Phase 10+** — requires careful sandboxing, no network exposure, static-only or local-only
- **LiveKit patterns are inspirational only** — we would build a custom static HTML dashboard (like our existing `gemma-dashboard-build`) rather than a full Next.js app

---

## 6. License Note

**License:** MIT License (Copyright 2025 LiveKit, Inc.)

**Implications:**
- ✅ We can freely study, adapt concepts, and borrow architectural patterns
- ✅ We can reference their component designs and state management approaches
- ✅ No requirement to open-source our adaptations (MIT is permissive)
- ⚠️ If we ever copy substantial code blocks, we must include the MIT copyright notice
- **Current approach:** We are only reviewing concepts, not copying code, so attribution is recommended but not legally required for ideas

**Recommendation:** If we ever create a "Inspired by LiveKit Agents UI" note in our docs, it builds goodwill and documents our design lineage.

---

## 7. Summary & Recommendations

| LiveKit Feature | Our Equivalent | Priority |
|-----------------|---------------|----------|
| Config-driven UI (`app-config.ts`) | Expand `gemma-ui.json` | High |
| View state machine | Formalize welcome/session/results | Medium |
| Start/stop controls | Consistent `/quit`, `/back`, `/help` | High |
| Chat transcript | Rich panels with timestamps | Medium |
| Theme switching | Rich theme support | Low |
| Error boundaries | Consistent error panel style | Medium |
| Audio visualizers | Not applicable (terminal) | N/A |
| Video/screen share | Not applicable | N/A |
| LiveKit SDK | Avoid entirely | N/A |

**Bottom line:** Use this repo as **UI/voice inspiration first, not as a live dependency**. The architectural patterns (config-driven, state machine, component separation) are valuable. The implementation (Next.js, LiveKit, React) is not applicable to our terminal-first, local-only, zero-network-exposure design.

---

## 8. Safe Validation Commands

```bash
# Verify gemma-ui config exists
cat ~/.config/bazzite-security/gemma-ui.json

# Check no new dependencies installed
# (Should show no changes — we only reviewed, didn't install)

# Verify no network services created
sudo ss -tlnp | grep -E '3000|11434|8080' || echo "No unexpected listeners"

# Check no .env.local created
ls -la ~/.local/bin/.env.local 2>/dev/null || echo "No .env.local found — good"
```

---

**End of review.**

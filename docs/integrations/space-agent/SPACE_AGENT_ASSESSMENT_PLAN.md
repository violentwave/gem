# Space Agent Assessment Plan

## Overview

This document outlines the assessment plan for Space Agent integration into the Bazzite Local AI Operations Stack.

## Current Status

**Phase:** 5E (Assessment)
**Goal:** Research Space Agent and assess Linux/Bazzite compatibility
**Do Not:** Install Space Agent in this phase

## What is Space Agent?

Space Agent is a multi-workspace AI agent platform with:
- Browser automation
- Task management
- Workspace coordination
- Visual UI interactions
- Multi-agent support

## Assessment Goals

1. **Linux Compatibility:** Does it support Linux/Bazzite?
2. **Browser vs Desktop:** Browser extension or desktop app?
3. **Local Inference:** Can it use local models?
4. **A0 Integration:** Does it integrate with Agent Zero?

## Assessment Tasks (Phase 5E)

### 1. Research Official Source

**Find:**
- Official Space Agent website
- GitHub repository
- Documentation
- Installation instructions

**Look for:**
- Supported platforms
- System requirements
- Linux availability

### 2. Determine Linux Compatibility

**Check:**
- Official Linux support
- Community Linux builds
- Browser extension availability
- Desktop app availability

**Critical Question:**
Does Space Agent support Linux/Bazzite/Fedora Atomic?

### 3. Browser vs Desktop Availability

**Determine:**
- Is it a browser extension?
- Is it a desktop application?
- Is it a web service?
- Is it a containerized app?

**Implications:**
- Browser extension: Easier to install, sandboxed
- Desktop app: May have system dependencies
- Web service: Requires account, potentially cloud
- Container: Good for Bazzite Atomic

### 4. Local Inference Support

**Check:**
- Can it use local Ollama?
- Does it require cloud APIs?
- Is there an offline mode?
- Can it use local Gemma?

**Critical Question:**
Does Space Agent support local-only operation?

### 5. Agent Zero Integration

**Check:**
- Does Space Agent integrate with Agent Zero?
- Is there a connector?
- Can they coordinate?
- Shared memory/workspace?

**Implications:**
- Tight integration: Better coordination
- No integration: Separate systems
- Partial integration: Custom bridge needed

### 6. Installation Requirements

**Research:**
- Installation method (package, build from source, container)
- Dependencies
- Disk space requirements
- Network requirements

## Compatibility Matrix

| Feature | Required | Nice to Have |
|---------|----------|--------------|
| Linux support | ✅ Critical | - |
| Local inference | ✅ Critical | - |
| Browser-based | ✅ Preferred | - |
| A0 integration | ✅ Preferred | Custom bridge |
| Containerized | ✅ Preferred | Flatpak/Distrobox |
| Desktop app | ⚠️ Acceptable | Check dependencies |
| Cloud-only | ❌ Not acceptable | - |

## Blockers

**Hard Blockers (Integration not viable):**
- No Linux support
- Cloud-only operation
- Requires system changes not viable on Atomic

**Soft Blockers (Workaround possible):**
- No official Linux build (check community)
- No A0 integration (build bridge)
- Desktop app with dependencies (use Distrobox)

## Fallback Strategy

If Space Agent not viable:
1. Continue with OpenCode + Gemma wrappers
2. Use browser automation via Playwright MCP
3. Build simple workspace manager
4. Defer full workspace UI

## Next Steps

1. **Phase 5E:** Research Space Agent (read-only)
2. **Phase 6C:** If viable, sandbox test
3. **Phase 7C:** If tests pass, integrate

## Validation

```bash
# After Phase 5E research
cat ~/projects/gem/docs/integrations/space-agent/SPACE_AGENT_ASSESSMENT_PLAN.md

# Check assessment status
grep -r "Space Agent" ~/projects/gem/inventory/
```

## References

- Space Agent: Search for official website/repository
- Playwright MCP: Available in OpenCode MCP ecosystem
- Phase 5E Prompt: `prompts/opencode/phase5e-space-agent-assessment.prompt.txt`
- Roadmap: `docs/roadmap/ROADMAP.md`

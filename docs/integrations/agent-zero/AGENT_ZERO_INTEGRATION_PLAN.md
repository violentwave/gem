# Agent Zero Integration Plan

## Overview

This document outlines the integration approach for Agent Zero into the Bazzite Local AI Operations Stack.

## Current Status

**Phase:** 5C (Assessment)
**Goal:** Verify installation and assess integration options
**Do Not:** Install, start, or modify Agent Zero in this phase

## What is Agent Zero?

Agent Zero is a multi-agent orchestration platform that enables:
- Spawning and coordinating multiple AI agents
- Agent skill definitions
- Agent-to-agent communication
- Browser automation
- File system operations
- Memory and learning

## Integration Goals

1. **A0 CLI Connector:** Bridge between OpenCode and Agent Zero
2. **Agent Definitions:** Define agents for local AI operations
3. **Memory Integration:** Connect to RuVector for long-term memory
4. **Workspace Integration:** Coordinate with Space Agent for UI

## Assessment Tasks (Phase 5C)

### 1. Verify Installation

**Check if Agent Zero is installed:**
```bash
# Common install paths
which agent-zero
which a0
ls -la ~/AgentZero/ 2>/dev/null
ls -la ~/agent-zero/ 2>/dev/null
ls -la /opt/agent-zero/ 2>/dev/null
```

**Check for container:**
```bash
docker ps | grep -i agent
docker ps | grep -i a0
podman ps | grep -i agent
```

### 2. Identify Install Path

**If installed, find:**
- Binary location
- Config directory
- Data directory
- UI endpoint (if running)

### 3. Check UI Endpoint

**If running, identify:**
- Web UI URL
- Port (default often 5000 or 3000)
- Authentication state

### 4. Identify Version

```bash
agent-zero --version 2>/dev/null
a0 --version 2>/dev/null
```

### 5. Check A0 CLI Connector

**Look for:**
- `a0` CLI binary
- A0 CLI Python package
- API key or auth token (do not copy, just verify existence)

### 6. Identify Skills/Plugins Paths

```bash
# Common paths
ls -la ~/.agent-zero/skills/ 2>/dev/null
ls -la ~/AgentZero/skills/ 2>/dev/null
ls -la /opt/agent-zero/skills/ 2>/dev/null
```

### 7. Check Memory Integration

**Look for:**
- Memory database path
- Vector DB configuration
- Default vs pluggable memory

## Integration Options

### Option 1: A0 CLI Connector (Preferred)

**Approach:**
- Use A0 CLI to spawn agents from OpenCode
- Agents run in A0 environment
- OpenCode orchestrates via CLI

**Pros:**
- Clean separation
- Sandboxed execution
- Existing tooling

**Cons:**
- Requires A0 CLI installed
- May require API keys

### Option 2: Direct API Integration

**Approach:**
- OpenCode calls A0 HTTP API directly
- Bypass CLI wrapper

**Pros:**
- Direct control
- No CLI dependency

**Cons:**
- More complex
- API may change

### Option 3: Container Integration

**Approach:**
- Run A0 in container
- OpenCode communicates via container interface

**Pros:**
- Full isolation
- Easy to reset

**Cons:**
- Container overhead
- File system mapping complexity

## Security Considerations

1. **Sandboxing:** Agents must run sandboxed
2. **Authorization:** Each agent task requires explicit user approval
3. **Data Isolation:** Agent data isolated from system
4. **No Secrets:** API keys stay in canonical paths, not repo

## Fallback Strategy

If Agent Zero cannot be integrated:
1. Continue with OpenCode-only implementation (L3)
2. Use Gemma wrappers for advisory (L1-L2)
3. Defer multi-agent orchestration until viable alternative found

## Blockers

**Current Blockers:**
- Need to verify A0 installation state
- Need to assess A0 CLI connector availability

**Potential Blockers:**
- A0 may not be installed
- A0 CLI may not support Bazzite/Fedora Atomic
- A0 may require system-level changes

## Next Steps

1. **Phase 5C:** Run assessment (read-only)
2. **Phase 6A:** If viable, sandbox test
3. **Phase 7A:** If tests pass, integrate

## Validation

```bash
# After Phase 5C assessment
cat ~/projects/gem/inventory/live-paths/agent-zero-state.md

# Check if assessment complete
grep -r "Agent Zero" ~/projects/gem/inventory/
```

## References

- Agent Zero: https://github.com/frdel/agent-zero
- A0 CLI: Check if available in A0 repository
- Phase 5C Prompt: `prompts/opencode/phase5c-agent-zero-inventory.prompt.txt`

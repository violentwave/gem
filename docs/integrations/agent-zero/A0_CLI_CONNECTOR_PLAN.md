# A0 CLI Connector Plan

## Overview

This document outlines the A0 CLI connector integration plan for bridging OpenCode and Agent Zero.

## Purpose

The A0 CLI connector enables OpenCode to:
- Spawn Agent Zero agents programmatically
- Send tasks to agents
- Receive agent outputs
- Manage agent lifecycle

## Current Status

**Phase:** Assessment
**Goal:** Determine if A0 CLI connector exists and how to integrate it

## What is the A0 CLI Connector?

The A0 CLI connector is a command-line interface that allows external tools (like OpenCode) to interact with Agent Zero without using the web UI.

**Potential Components:**
1. `a0` binary - CLI tool
2. Python package - `agent-zero-cli`
3. API client - Direct HTTP client

## Assessment Tasks

### 1. Check for A0 CLI Binary

```bash
which a0
which agent-zero-cli
which agent-zero
ls -la ~/.local/bin/a0* 2>/dev/null
ls -la /usr/local/bin/a0* 2>/dev/null
```

### 2. Check for Python Package

```bash
pip list | grep -i agent
pip3 list | grep -i agent
npm list -g | grep -i agent
```

### 3. Check A0 Repository

**Look for:**
- CLI directory in A0 repo
- API client examples
- Connector documentation

### 4. Identify Connection Method

**Possible methods:**
1. Direct HTTP API calls to A0 server
2. CLI subprocess calls
3. Python library import
4. WebSocket connection

## Connector Design (If None Exists)

If no official A0 CLI connector exists, design a simple one:

### Option: HTTP API Client

```python
# Conceptual design
class A0Connector:
    def __init__(self, base_url, api_key=None):
        self.base_url = base_url
        self.api_key = api_key

    def spawn_agent(self, agent_type, task):
        # Spawn agent via A0 API
        pass

    def send_message(self, agent_id, message):
        # Send message to agent
        pass

    def get_response(self, agent_id):
        # Get agent response
        pass
```

### Option: CLI Wrapper

```python
# Conceptual design
class A0CLIWrapper:
    def __init__(self, a0_binary_path):
        self.binary = a0_binary_path

    def run_task(self, agent_type, task_description):
        # Call a0 CLI
        subprocess.run([self.binary, "run", agent_type, task_description])
```

## Integration Requirements

### Functional Requirements
1. Spawn agents from OpenCode
2. Send tasks to agents
3. Receive structured responses
4. Handle agent errors
5. Clean up agent instances

### Non-Functional Requirements
1. No sudo required
2. Sandboxed execution
3. Configurable timeout
4. Error handling
5. Logging

## Security Requirements

1. **API Keys:** Stored in canonical paths, not repo
2. **Sandboxing:** Agents run in isolated environment
3. **Authorization:** User approval for each agent spawn
4. **Audit:** Log all agent interactions

## Implementation Phases

### Phase 5C: Assessment
- Verify A0 CLI exists or design needed
- Document connector requirements

### Phase 6A: Prototype
- Build/test connector in sandbox
- Validate security model

### Phase 7A: Integration
- Integrate with OpenCode
- Test end-to-end

## Fallback Strategy

If A0 CLI connector not viable:
1. Use OpenCode MCPs directly
2. Build simple agent spawning via subprocess
3. Defer full A0 integration

## Validation

```bash
# Check if A0 CLI exists
which a0

# Check if connector documented
cat ~/projects/gem/docs/integrations/agent-zero/A0_CLI_CONNECTOR_PLAN.md

# Check assessment status
grep -r "A0 CLI" ~/projects/gem/inventory/
```

## References

- Agent Zero Repository: https://github.com/frdel/agent-zero
- A0 API Documentation: Check A0 repo for API docs
- Phase 5C Prompt: `prompts/opencode/phase5c-agent-zero-inventory.prompt.txt`

# Fallback Strategies

## Overview

This document defines fallback strategies for each integration point in the Bazzite Local AI Operations Stack. Each strategy defines the behavior when a component becomes unavailable or fails.

## Fallback Hierarchy

```
┌─────────────────────────────────────────────────────────────────────┐
│                     L7: Space Agent (Browser)                       │
│         Primary: Browser Agent    Fallback: CLI commands           │
├─────────────────────────────────────────────────────────────────────┤
│                     L6: RuVector (Memory)                           │
│         Primary: HNSW + Graph      Fallback: In-memory + disk       │
├─────────────────────────────────────────────────────────────────────┤
│                     L5: Agent Zero (Orchestration)                  │
│         Primary: Multi-agent       Fallback: OpenCode direct        │
├─────────────────────────────────────────────────────────────────────┤
│                     L4: Tool Orchestrator                           │
│         Primary: MCPs              Fallback: Direct CLI tools        │
├─────────────────────────────────────────────────────────────────────┤
│                     L0-L3: Core Stack                                │
│         Primary: Full capability   Fallback: Subset operations      │
└─────────────────────────────────────────────────────────────────────┘
```

## Component-Specific Fallbacks

### L5: Agent Zero Fallbacks

#### Scenario 1: A0 Connector Unavailable

**Detection:** CLI returns non-zero, connection refused

**Fallback Sequence:**
1. Log warning
2. Fall back to OpenCode direct execution
3. Notify user of degraded mode

**Example:**
```bash
# Original
a0 spawn --agent researcher --task "query"

# Fallback
opencode exec --task "research query" --model gpt-5.4
```

#### Scenario 2: Agent Timeout

**Detection:** Task exceeds timeout threshold

**Fallback Sequence:**
1. Retry once with exponential backoff
2. If still timeout, mark as failed
3. Return partial results if available
4. Log for debugging

#### Scenario 3: Resource Exhaustion

**Detection:** Max concurrent agents reached

**Fallback Sequence:**
1. Queue task
2. Notify user of wait time
3. Process when slot available

---

### L6: RuVector Fallbacks

#### Scenario 1: Service Unavailable

**Detection:** HTTP connection refused, socket error

**Fallback Sequence:**
1. Check in-memory cache
2. If cache miss, attempt disk fallback
3. Queue write operations for retry
4. Notify user of degraded mode

**Implementation:**
```python
def query_with_fallback(query, top_k):
    # Try primary
    try:
        return ruvector.query(query, top_k)
    except ServiceUnavailable:
        pass

    # Fallback 1: In-memory cache
    cached = memory_cache.get(query)
    if cached:
        return cached

    # Fallback 2: Disk storage
    return disk_storage.search(query, top_k)
```

#### Scenario 2: Index Corruption

**Detection:** Read errors, validation failure

**Fallback Sequence:**
1. Detect corruption
2. Switch to backup index
3. If no backup, rebuild from source
4. Alert user

**Recovery:**
```bash
# Check index integrity
ruvector validate

# Rebuild if corrupted
ruvector rebuild --source ~/.local/share/bazzite-security/

# Or restore from backup
ruvector restore --backup /path/to/backup
```

#### Scenario 3: Storage Full

**Detection:** Write fails with storage error

**Fallback Sequence:**
1. Alert user
2. Prevent new writes
3. Offer cleanup options:
   - Remove old sessions
   - Compress old memories
   - Export and clear
4. Require user action

#### Scenario 4: Learning System Failure

**Detection:** Feedback collection fails, consolidation error

**Fallback Sequence:**
1. Disable learning features
2. Preserve existing memories
3. Log error for debugging
4. Continue normal operation

---

### L7: Space Agent Fallbacks

#### Scenario 1: Browser Unavailable

**Detection:** CDP connection fails, browser not installed

**Fallback Sequence:**
1. Report error to user
2. Offer alternative: CLI-based web fetch
3. Skip browser-specific tasks

**Example:**
```python
# Original browser task
space_agent.navigate("https://example.com")

# Fallback
import requests
response = requests.get("https://example.com")
return response.text
```

#### Scenario 2: Workspace Corruption

**Detection:** State file invalid, config parse error

**Fallback Sequence:**
1. Backup current state
2. Reset to clean state
3. Preserve user config
4. Notify user of reset

#### Scenario 3: Task Queue Failure

**Detection:** Queue service unavailable

**Fallback Sequence:**
1. Fall back to in-memory queue
2. Persist to disk periodically
3. Recover on service restart

---

### L4: Tool Orchestrator Fallbacks

#### Scenario 1: MCP Server Unavailable

**Detection:** Connection refused, timeout

**Fallback Sequence:**
1. Retry with backoff
2. Fall back to direct CLI invocation
3. Notify user of missing capability

**Example:**
```bash
# Original MCP call
mcp-server-tavily search "query"

# Fallback
tavily-search "query"  # Direct CLI
```

#### Scenario 2: Skill Not Found

**Detection:** Skill lookup fails

**Fallback Sequence:**
1. Search alternative skills
2. Fall back to generic implementation
3. Notify user of limitation

---

## Cross-Component Fallbacks

### Full Stack Degradation

When multiple components fail, degrade gracefully:

| Level | Degraded Mode |
|-------|---------------|
| L7+L6 | OpenCode + Gemma only |
| L5+L6 | OpenCode + Gemma only |
| L6 only | In-memory fallback, notify |
| L5 only | OpenCode direct |
| L4 only | Direct CLI tools |

### Recovery Procedures

#### Step 1: Detect Failure
- Health checks on each component
- Timeout monitoring
- Error logging

#### Step 2: Execute Fallback
- Select appropriate fallback
- Log transition
- Notify user

#### Step 3: Restore
- Monitor for recovery
- Auto-retry primary
- Confirm with user

## Testing Fallbacks

```bash
# Test L6 fallback
# 1. Stop RuVector service
pkill ruvector

# 2. Run query
gemma-knowledge-rag "test query"

# 3. Verify fallback behavior

# Test L5 fallback
# 1. Break A0 connector
rm ~/.local/bin/a0

# 2. Attempt agent task
opencode exec --task "test"

# 3. Verify fallback to direct
```

## Monitoring Fallbacks

Track fallback events:
- Log each fallback trigger
- Count fallback occurrences
- Alert on excessive fallbacks

```bash
# View fallback events
grep -i fallback ~/.local/state/bazzite-security/logs/*.log

# Check fallback metrics
cat /tmp/fallback-stats.json
```

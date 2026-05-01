# RuVector Assessment Plan

## Overview

This document outlines the assessment plan for RuVector integration into the Bazzite Local AI Operations Stack.

## Current Status

**Phase:** 5D (Assessment)
**Goal:** Assess RuVector architecture and local-only feasibility
**Do Not:** Clone, install, or run RuVector in this phase

## What is RuVector?

RuVector is a vector database and memory system with:
- HNSW (Hierarchical Navigable Small World) indexing
- Semantic vector search
- Memory graphs
- Hybrid search (BM25 + vector)
- Optional self-learning capabilities

## Assessment Goals

1. **Architecture Review:** Understand RuVector components
2. **Local-Only Feasibility:** Can it run without external services?
3. **Self-Learning Scoping:** Can self-learning be disabled/scoped?
4. **Integration Options:** How would it integrate with Agent Zero/OpenCode?

## Assessment Tasks (Phase 5D)

### 1. Review Repository Structure

**Research:**
- RuVector GitHub repository
- Documentation
- Examples
- Architecture diagrams

**Look for:**
- Core Rust components
- NPM/Node.js bindings
- Docker deployment options
- Configuration options

### 2. Identify Dependencies

**Check for:**
- Rust toolchain requirements
- Node.js/npm requirements
- System dependencies
- Optional features

### 3. Assess Service Requirements

**Determine:**
- Does RuVector require a daemon/service?
- Can it run as library vs. service?
- Process vs. in-memory options

### 4. Identify Persistence Paths

**Look for:**
- Default data directories
- Configurable paths
- Database file formats
- Backup/restore options

### 5. Assess Self-Learning

**Critical Assessment:**
- What does self-learning mean in RuVector?
- Can it be disabled?
- Can it be scoped to specific data?
- Is there a manual learning mode?

**Safety Requirement:**
If self-learning cannot be scoped/disabled, RuVector may not be suitable for integration.

### 6. Define Local Data Paths

**Plan for:**
- Vector DB storage location
- Index file location
- Config file location
- Log location

**Canonical Path Options:**
- `~/.local/share/bazzite-security/ruvector/`
- `~/.cache/bazzite-security/ruvector/`

### 7. Review API Surface

**Look for:**
- Rust API
- JavaScript/TypeScript API
- HTTP API (if any)
- CLI commands

## Integration Options

### Option 1: Library Integration

**Approach:**
- Use RuVector as Rust library
- Link into Agent Zero
- Direct API calls

**Pros:**
- Tight integration
- No separate service
- Direct memory access

**Cons:**
- Rust dependency
- Compilation complexity
- Tight coupling

### Option 2: Service Integration

**Approach:**
- Run RuVector as local service
- HTTP or IPC communication
- Agent Zero calls service

**Pros:**
- Clean separation
- Language agnostic
- Easy to restart

**Cons:**
- Service overhead
- IPC complexity
- Potential latency

### Option 3: Container Integration

**Approach:**
- Run RuVector in container
- Volume mount for persistence
- Port mapping for API

**Pros:**
- Full isolation
- Easy reset
- Dependency bundling

**Cons:**
- Container overhead
- File system mapping
- Complexity

## Security Considerations

1. **Data Isolation:** Vector DB data isolated from system
2. **No Network:** Local-only, no external network
3. **User-Local:** Run as user, not system service
4. **Scoped Learning:** Only learn from authorized data

## Blockers

**Potential Blockers:**
- RuVector requires system-level dependencies
- Cannot disable self-learning
- Requires external services
- Not compatible with Bazzite/Fedora Atomic

## Fallback Strategy

If RuVector not viable:
1. Continue with Stage 3A deterministic retrieval
2. Explore simpler vector DB alternatives
3. Defer semantic search until viable option found

## Next Steps

1. **Phase 5D:** Research RuVector (read-only)
2. **Phase 6B:** If viable, sandbox test
3. **Phase 7B:** If tests pass, integrate

## Validation

```bash
# After Phase 5D assessment
cat ~/projects/gem/docs/integrations/ruvector/RUVECTOR_ASSESSMENT_PLAN.md

# Check assessment status
grep -r "RuVector" ~/projects/gem/inventory/
```

## References

- RuVector: Search for repository (likely GitHub)
- HNSW: https://github.com/nmslib/hnswlib
- Vector DB Comparison: Research alternatives
- Phase 5D Prompt: `prompts/opencode/phase5d-ruvector-assessment.prompt.txt`

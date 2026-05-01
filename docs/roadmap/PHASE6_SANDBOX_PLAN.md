# Phase 6 Sandbox Plan

## Overview

Phase 6 establishes isolated sandbox environments to test each component (Agent Zero, RuVector, Space Agent) before full integration. This phase validates feasibility, security boundaries, and fallback mechanisms without affecting the live system.

## Hard Boundaries (All Phases)

- No sudo
- No package installations to system
- No Agent Zero service start
- No RuVector clone or install
- No Space Agent run
- No Ollama service config changes
- No OpenCode permission changes
- No firewall, USBGuard, ClamAV, Lynis, rpm-ostree changes
- No secrets or private code in repo

---

## Phase 6A: Agent Zero Sandbox

### Goal
Test Agent Zero in isolated container environment.

### Tasks

1. **Inspect existing container**
   ```bash
   # Check container status (read-only)
   podman ps -a | grep agent-zero

   # Inspect container config
   podman inspect agent-zero | head -40
   ```

2. **Verify config paths**
   ```bash
   ls -la ~/.config/agent-zero/
   ls -la ~/.local/share/agent-zero/
   ```

3. **Check A0 CLI connector availability**
   ```bash
   which a0
   ls -la ~/.local/bin/a0 2>/dev/null || echo "Not found"
   ```

4. **Start container (if not running)**
   ```bash
   # Using existing helper
   ~/.local/bin/agent-zero-up

   # Verify endpoint
   curl -s http://127.0.0.1:5080 || echo "Not reachable"
   ```

5. **Verify sandbox isolation**
   ```bash
   # Check container network
   podman inspect agent-zero | grep -i network

   # Check mounts
   podman inspect agent-zero | grep -i mounts
   ```

6. **Test A0 CLI connector (if present)**
   ```bash
   a0 --version 2>/dev/null || echo "CLI not available"
   ```

7. **No broad host access** - Do not grant host filesystem access

8. **No system changes** - Do not modify any system files

### Validation Commands

```bash
# Container health
podman ps | grep agent-zero

# Endpoint availability
curl -s http://127.0.0.1:5080/health || echo "No health endpoint"

# Config integrity
ls -la ~/.config/agent-zero/
```

### Expected Output

- Container status report
- Config path verification
- Endpoint test results
- Isolation confirmation

### Blockers
- If container won't start → Document, do not force
- If no CLI → Note as gap for integration

### Hard Boundaries

- Do NOT modify container config
- Do NOT grant additional permissions
- Do NOT install packages in container
- Do NOT expose to network beyond localhost

---

## Phase 6B: RuVector Sandbox

### Goal
Test RuVector npm package in isolated user-space environment.

### Tasks

1. **Decide install method** (from assessment)
   ```bash
   # Option 1: npm in user space (preferred)
   cd ~/tmp/ruvector-test
   npm init -y
   npm install ruvector

   # Option 2: Not installing in this phase (assessment only)
   ```

2. **If installing, use temp directory**
   ```bash
   mkdir -p ~/tmp/ruvector-sandbox
   cd ~/tmp/ruvector-sandbox
   npm init -y
   npm install ruvector
   ```

3. **Test basic vector operations**
   ```bash
   # Test imports work
   node -e "const {VectorDB} = require('ruvector'); console.log('OK')"

   # Test basic create/insert/query (if install performed)
   ```

4. **Verify local-only operation**
   ```bash
   # Check for any network calls during init
   strace -e network node -e "require('ruvector')" 2>&1 | grep -i connect || echo "No network"
   ```

5. **Compare with Stage 3A**
   ```bash
   # Run a test query against both
   gemma-knowledge-rag "test query"

   # Compare retrieval methods conceptually
   echo "RuVector: Would use semantic search"
   echo "Stage 3A: Uses keyword matching"
   ```

6. **No daemon** - Do not create systemd service
7. **No system install** - Keep in user space only
8. **No external embeddings** - Use local ONNX only

### Validation Commands

```bash
# If installed
npm list ruvector

# Check user-space only
ls -la ~/tmp/ruvector-sandbox/

# Verify Stage 3A still works
gemma-evals-status
```

### Expected Output

- Installation method decision
- Package test results (if installed)
- Local-only confirmation
- Comparison with deterministic RAG

### Blockers
- If npm install fails → Document, do not proceed with install
- If network calls detected → Note as blocker

### Hard Boundaries

- Do NOT install to system npm
- Do NOT create service
- Do NOT download external models
- Do NOT expose to network

---

## Phase 6C: Space Agent Sandbox

### Goal
Test Space Agent Linux AppImage in user space.

### Tasks

1. **Download AppImage** (to temp location)
   ```bash
   mkdir -p ~/tmp/space-agent-test
   cd ~/tmp/space-agent-test

   # Download latest (check releases page)
   curl -L -o Space-Agent.AppImage \
     "https://github.com/agent0ai/space-agent/releases/download/v0.64/Space-Agent-0.64-linux-x64.AppImage"

   chmod +x Space-Agent.AppImage
   ```

2. **Identify config/state paths**
   ```bash
   # Run once to see where it writes
   ./Space-Agent.AppImage --help || true

   # Check created directories
   ls -la ~/.config/space-agent/ 2>/dev/null || echo "Not created yet"
   ls -la ~/.local/share/space-agent/ 2>/dev/null || echo "Not created yet"
   ```

3. **Test launch** (do not leave running)
   ```bash
   # Launch and immediately close
   timeout 5 ./Space-Agent.AppImage || echo "Exited"
   ```

4. **Verify local inference options**
   ```bash
   # Check docs for Ollama/local support
   # (Not actually configuring, just researching)
   grep -i "ollama\|local\|offline" ~/tmp/space-agent-test/* 2>/dev/null || echo "No local config found in download"
   ```

5. **No autostart** - Do not create systemd service
6. **No broad filesystem** - Do not grant extra permissions

### Validation Commands

```bash
# Check download
ls -la ~/tmp/space-agent-test/

# Check created dirs
ls -la ~/.config/space-agent/ 2>/dev/null
ls -la ~/.local/share/space-agent/ 2>/dev/null

# Clean up test directory
rm -rf ~/tmp/space-agent-test
```

### Expected Output

- AppImage download confirmation
- Config path identification
- Launch test results
- Local inference support status

### Blockers
- If download fails → Document, do not proceed
- If AppImage won't run → Note as gap

### Hard Boundaries

- Do NOT leave running
- Do NOT create autostart
- Do NOT install to system
- Do NOT grant broad filesystem access

---

## Phase 6D: Integration Smoke Test

### Goal
Verify Agent Zero, RuVector, and Space Agent can coexist without conflicts.

### Tasks

1. **Check component coexistence**
   ```bash
   # Document what is installed/available
   echo "=== Agent Zero ==="
   podman ps | grep agent-zero || echo "Not running"

   echo "=== RuVector ==="
   npm list -g ruvector 2>/dev/null || echo "Not installed globally"
   ls ~/tmp/ruvector-sandbox/node_modules/ruvector 2>/dev/null || echo "Not in sandbox"

   echo "=== Space Agent ==="
   ls ~/tmp/space-agent-test/Space-Agent.AppImage 2>/dev/null || echo "Not downloaded"
   ```

2. **Verify no port conflicts**
   ```bash
   # Check potential ports
   ss -tlnp | grep -E "5080|8080|3000" || echo "No conflicts"
   ```

3. **Verify no path conflicts**
   ```bash
   # Check data directories don't overlap
   echo "A0: ~/.local/share/agent-zero/"
   echo "RV: ~/.local/share/bazzite-security/ruvector/"
   echo "SA: ~/.local/share/space-agent/"
   ```

4. **Confirm fallback chain**
   ```bash
   # Stage 3A RAG still works
   gemma-evals-status

   # OpenCode still works
   which opencode
   ```

5. **No full operator mode** - Do not enable autonomous execution

### Validation Commands

```bash
# Check all fallbacks
gemma-bazzite "test"
gemma-evals-check
which opencode

# Document state
cat > ~/projects/gem/docs/integrations/INTEGRATION_SMOKE_REPORT.md << 'EOF'
# Integration Smoke Test Report

Date: [DATE]
Components tested: [LIST]

Findings:
- [component status]
- [no conflicts confirmed]
- [fallbacks operational]

Conclusion: [PROCEED / DO NOT PROCEED]
EOF
```

### Expected Output

- Coexistence verification
- No port/path conflicts
- Fallback chain confirmed
- Smoke test report

### Blockers
- If conflicts found → Document, resolve before Phase 7

---

## Phase 6 Deliverables

| Phase | Deliverable |
|-------|--------------|
| 6A | A0 sandbox test results |
| 6B | RuVector sandbox test results |
| 6C | Space Agent compatibility report |
| 6D | Integration smoke test report |

---

## Validation Summary

```bash
# Run before any Phase 6 work
gemma-evals-status
gemma-examples-check
cd ~/projects/gem && git status

# Run after each phase
[phase-specific commands above]

# Run after all phases
find ~/projects/gem/docs -name "*PHASE6*" -o -name "*SMOKE*" | head
```

---

## Next Steps After Phase 6

- Phase 7A: L5 Integration (Agent Zero)
- Phase 7B: L6 Integration (RuVector)
- Phase 7C: L7 Integration (Space Agent)

See `ROADMAP.md` for detailed timeline.

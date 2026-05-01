# OpenCode Role

## Overview

This document defines the role of OpenCode in the Bazzite Local AI Operations Stack.

## Current Role: Implementation Agent (L3)

OpenCode serves as the **implementation agent** for the stack, handling:
- File and configuration edits
- Repository operations
- Tool orchestration via MCPs
- Script execution (user-approved)

## What OpenCode Does

### Implementation Work
- Edit configuration files
- Create documentation
- Update repositories
- Run validation commands
- Coordinate tools via MCPs

### MCP Integration
OpenCode uses Model Context Protocol (MCP) servers:
- **Tavily:** Web search
- **Semgrep:** Security analysis
- **Context7:** Documentation lookup
- **Playwright:** Browser automation
- **GitHub:** Repository operations

### Skill System
OpenCode can load skills for:
- Domain-specific workflows
- Tool usage patterns
- Validation procedures

## What OpenCode Does NOT Do

### Not an Unattended System Operator
- Does not make system changes without explicit authorization
- Does not run sudo commands without user review
- Does not modify firewall, USBGuard, ClamAV, Lynis
- Does not change rpm-ostree state
- Does not modify systemd timers

### Not a Model Trainer
- Does not train models
- Does not modify Ollama model config
- Does not update Gemma profile

### Not a Replacement for Gemma
- Gemma: Advisory, RAG, bounded reporting
- OpenCode: Implementation, repo operations
- Different roles, complementary functions

## Operating Model

### User-Initiated Actions
Every OpenCode task is:
1. User-initiated
2. Explicitly requested
3. Reviewed before system changes
4. Validated after completion

### Authorization Levels

**L3 (Current): Repository Operations**
- Edit files in project repos
- Update configs in `~/.config/`
- Run safe validation commands
- No sudo required

**L4 (Future): Tool Orchestration**
- Coordinate MCPs
- Multi-tool workflows
- User-approved only

**L5+ (Future): Agent Coordination**
- Interface with Agent Zero
- Spawn and manage agents
- Explicit authorization per agent

## Security Boundaries

### No Unauthorized System Changes
OpenCode will not:
- Use sudo without explicit request
- Modify firewall rules
- Change USBGuard policies
- Update ClamAV/Lynis
- Layer packages with rpm-ostree
- Enable/disable systemd timers
- Modify Ollama service config

### Secrets Handling
OpenCode will not:
- Copy `.env` files into repo
- Store API keys in repo
- Log secrets in transcripts
- Expose tokens in outputs

## Prompt Storage

OpenCode prompts for future phases are stored in:
```
~/projects/gem/prompts/opencode/
├── phase5b-architecture-expansion.prompt.txt
├── phase5c-agent-zero-inventory.prompt.txt
├── phase5d-ruvector-assessment.prompt.txt
└── phase5e-space-agent-assessment.prompt.txt
```

These prompts are for future use, not immediate execution.

## Validation Commands

After OpenCode work, validate:
```bash
# If working on evals
gemma-examples-check
gemma-evals-check

# If working on config
ls -la ~/.config/bazzite-security/

# Check git status
git status --short
```

## Comparison with Gemma

| Aspect | Gemma | OpenCode |
|--------|-------|----------|
| **Role** | Advisory | Implementation |
| **Level** | L0-L2 | L3+ |
| **Actions** | Read-only analysis | File editing |
| **System Changes** | Never | User-approved only |
| **Model** | Local Gemma | GPT-5.4/Codex |
| **Speed** | Local, fast | Cloud, slower |
| **Cost** | Free (local) | API usage |
| **Security** | Sandboxed by wrappers | Sandboxed by permissions |

## Future Role Evolution

### Phase 5A-G: Coordination
- Create repo structure
- Write documentation
- No system changes

### Phase 6A-C: Sandbox Testing
- Test components in isolation
- Validate integration approaches
- No live system changes

### Phase 7A-C: Integration
- Implement integrations
- Configure components
- User-approved changes only

### Phase 8A-C: Workflows
- Define operational workflows
- Create templates
- Document best practices

### Phase 9A-B: Full Stack
- Operate full L0-L9 stack
- Supervised autonomy
- User override always available

## Emergency Stop

OpenCode will stop and ask for clarification if:
- A prompt asks for sudo without clear justification
- A prompt asks to modify system config without authorization
- A prompt asks to copy secrets into repo
- A prompt asks to start unvetted services

## References

- OpenCode: https://github.com/anthropics/opencode
- MCP: https://modelcontextprotocol.io/
- Capability Levels: `docs/architecture/CAPABILITY_LEVELS.md`
- AGENTS.md: `~/projects/gem/AGENTS.md`

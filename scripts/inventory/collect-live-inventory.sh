#!/usr/bin/env bash
#
# collect-live-inventory.sh - Collect sanitized inventory of live system
#
# This script reads live system state and writes sanitized summaries to the
# coordination repo. It does not copy secrets, raw logs, or sensitive data.
#
# Usage: bash scripts/inventory/collect-live-inventory.sh
#
# Requirements:
# - No sudo
# - Read-only
# - Safe for repo inclusion

set -euo pipefail

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INVENTORY_DIR="${REPO_ROOT}/inventory"
LIVE_PATHS_DIR="${INVENTORY_DIR}/live-paths"
HELPER_SCRIPTS_DIR="${INVENTORY_DIR}/helper-scripts"
CONFIG_DOCS_DIR="${INVENTORY_DIR}/config-docs"

# Live system paths
CONFIG_DIR="${HOME}/.config/bazzite-security"
LOCAL_BIN="${HOME}/.local/bin"
LOCAL_SHARE="${HOME}/.local/share/bazzite-security"
LOCAL_STATE="${HOME}/.local/state/bazzite-security/logs"
CACHE_DIR="${HOME}/.cache/bazzite-security"
REPORTS_DIR="${HOME}/offload/security-reports"

# Timestamp
TIMESTAMP=$(date -Iseconds)

echo "=== Live System Inventory Collection ==="
echo "Timestamp: ${TIMESTAMP}"
echo ""

# Create directories
mkdir -p "${LIVE_PATHS_DIR}"
mkdir -p "${HELPER_SCRIPTS_DIR}"
mkdir -p "${CONFIG_DOCS_DIR}"

# ============================================================================
# 1. Canonical Paths Inventory
# ============================================================================

echo "Collecting canonical paths..."

cat > "${LIVE_PATHS_DIR}/canonical-paths.md" << EOF
# Canonical Paths Inventory

**Generated:** ${TIMESTAMP}

## Config Directory: ~/.config/bazzite-security/

**Exists:** $([ -d "${CONFIG_DIR}" ] && echo "Yes" || echo "No")

**Contents:**
EOF

if [ -d "${CONFIG_DIR}" ]; then
    ls -la "${CONFIG_DIR}" >> "${LIVE_PATHS_DIR}/canonical-paths.md" 2>/dev/null || echo "  (Unable to list)" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
else
    echo "  Directory not found" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
fi

cat >> "${LIVE_PATHS_DIR}/canonical-paths.md" << EOF

## Scripts Directory: ~/.local/bin/

**Gemma Helper Scripts:**
EOF

if [ -d "${LOCAL_BIN}" ]; then
    ls -1 "${LOCAL_BIN}"/gemma-* 2>/dev/null | wc -l | xargs -I {} echo "  Count: {}" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
    echo "" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
    echo "**Script List:**" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
    ls -1 "${LOCAL_BIN}"/gemma-* 2>/dev/null | while read -r script; do
        echo "  - $(basename "${script}")" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
    done
else
    echo "  Directory not found" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
fi

cat >> "${LIVE_PATHS_DIR}/canonical-paths.md" << EOF

## Persistent State: ~/.local/share/bazzite-security/

**Exists:** $([ -d "${LOCAL_SHARE}" ] && echo "Yes" || echo "No")

**Subdirectories:**
EOF

if [ -d "${LOCAL_SHARE}" ]; then
    find "${LOCAL_SHARE}" -maxdepth 2 -type d 2>/dev/null | head -20 | sed 's/^/  - /' >> "${LIVE_PATHS_DIR}/canonical-paths.md"
else
    echo "  Directory not found" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
fi

cat >> "${LIVE_PATHS_DIR}/canonical-paths.md" << EOF

## Logs: ~/.local/state/bazzite-security/logs/

**Exists:** $([ -d "${LOCAL_STATE}" ] && echo "Yes" || echo "No")

**Recent Log Files:**
EOF

if [ -d "${LOCAL_STATE}" ]; then
    ls -1t "${LOCAL_STATE}" 2>/dev/null | head -10 | sed 's/^/  - /' >> "${LIVE_PATHS_DIR}/canonical-paths.md"
else
    echo "  Directory not found" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
fi

cat >> "${LIVE_PATHS_DIR}/canonical-paths.md" << EOF

## Cache: ~/.cache/bazzite-security/

**Exists:** $([ -d "${CACHE_DIR}" ] && echo "Yes" || echo "No")

## Reports: ~/offload/security-reports/

**Exists:** $([ -d "${REPORTS_DIR}" ] && echo "Yes" || echo "No")

**Subdirectories:**
EOF

if [ -d "${REPORTS_DIR}" ]; then
    find "${REPORTS_DIR}" -maxdepth 1 -type d 2>/dev/null | sed 's/^/  - /' >> "${LIVE_PATHS_DIR}/canonical-paths.md"
else
    echo "  Directory not found" >> "${LIVE_PATHS_DIR}/canonical-paths.md"
fi

echo "  Canonical paths inventory written"

# ============================================================================
# 2. Gemma Helper Scripts Inventory
# ============================================================================

echo "Collecting Gemma helper scripts inventory..."

cat > "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md" << EOF
# Gemma Helper Scripts Inventory

**Generated:** ${TIMESTAMP}

## Scripts Location: ~/.local/bin/

EOF

if [ -d "${LOCAL_BIN}" ]; then
    echo "**Script Count:** $(ls -1 "${LOCAL_BIN}"/gemma-* 2>/dev/null | wc -l)" >> "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"
    echo "" >> "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"
    echo "| Script | Purpose |" >> "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"
    echo "|--------|---------|" >> "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"

    for script in "${LOCAL_BIN}"/gemma-*; do
        if [ -f "${script}" ]; then
            name=$(basename "${script}")
            # Extract first line of description if available
            purpose=$(head -5 "${script}" 2>/dev/null | grep -E "^#.*Purpose|^#.*Usage" | head -1 | sed 's/^# */ /' || echo " Gemma helper")
            echo "| ${name} |${purpose} |" >> "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"
        fi
    done
else
    echo "Scripts directory not found" >> "${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"
fi

echo "  Gemma helper scripts inventory written"

# ============================================================================
# 3. Config Docs Inventory
# ============================================================================

echo "Collecting config docs inventory..."

cat > "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md" << EOF
# Bazzite Security Config Docs Inventory

**Generated:** ${TIMESTAMP}

## Location: ~/.config/bazzite-security/

EOF

if [ -d "${CONFIG_DIR}" ]; then
    echo "**Document Count:** $(ls -1 "${CONFIG_DIR}"/*.md 2>/dev/null | wc -l)" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
    echo "" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
    echo "| Document | Size | Modified |" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
    echo "|----------|------|----------|" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"

    for doc in "${CONFIG_DIR}"/*.md; do
        if [ -f "${doc}" ]; then
            name=$(basename "${doc}")
            size=$(stat -c%s "${doc}" 2>/dev/null || echo "0")
            modified=$(stat -c%y "${doc}" 2>/dev/null | cut -d' ' -f1 || echo "unknown")
            echo "| ${name} | ${size} bytes | ${modified} |" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
        fi
    done

    # Check for ollama subdirectory
    if [ -d "${CONFIG_DIR}/ollama" ]; then
        echo "" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
        echo "## Ollama Config" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
        echo "" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
        ls -1 "${CONFIG_DIR}/ollama/" 2>/dev/null | sed 's/^/  - /' >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
    fi
else
    echo "Config directory not found" >> "${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
fi

echo "  Config docs inventory written"

# ============================================================================
# 4. Tool Availability
# ============================================================================

echo "Collecting tool availability..."

cat > "${LIVE_PATHS_DIR}/tool-availability.md" << EOF
# Tool Availability Inventory

**Generated:** ${TIMESTAMP}

## Core Tools

| Tool | Path | Available | Version | Notes |
|------|------|-----------|---------|-------|
EOF

# Ollama
if command -v ollama &> /dev/null; then
    OLLAMA_PATH=$(which ollama)
    OLLAMA_VERSION=$(ollama --version 2>/dev/null | head -1 || echo "unknown")
    echo "| Ollama | ${OLLAMA_PATH} | Yes | ${OLLAMA_VERSION} | Local inference |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| Ollama | Not found | No | N/A | Install at /usr/local/bin |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

# OpenCode
if command -v opencode &> /dev/null; then
    OPCODE_PATH=$(which opencode)
    OPCODE_VERSION=$(opencode --version 2>/dev/null || echo "unknown")
    echo "| OpenCode | ${OPCODE_PATH} | Yes | ${OPCODE_VERSION} | Implementation agent |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| OpenCode | Not found | No | N/A | Check ~/.npm-global/bin |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

# Gemma validators
cat >> "${LIVE_PATHS_DIR}/tool-availability.md" << EOF

## Gemma Validators

| Validator | Available | Notes |
|-----------|-----------|-------|
EOF

for validator in gemma-examples-check gemma-evals-check gemma-evals-status gemma-examples-review-drafts; do
    if command -v ${validator} &> /dev/null; then
        echo "| ${validator} | Yes | Helper script |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
    else
        echo "| ${validator} | No | Not in PATH |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
    fi
done

# Agent Zero indicators
cat >> "${LIVE_PATHS_DIR}/tool-availability.md" << EOF

## Agent Zero Indicators

| Indicator | Status | Notes |
|-----------|--------|-------|
EOF

# Check for Agent Zero
if command -v agent-zero &> /dev/null || command -v a0 &> /dev/null || [ -d "${HOME}/AgentZero" ] || [ -d "${HOME}/agent-zero" ]; then
    echo "| Agent Zero binary | Found | May be installed |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| Agent Zero binary | Not found | Assessment needed |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

# Check for A0 CLI
if command -v a0 &> /dev/null; then
    echo "| A0 CLI | Found | Connector available |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| A0 CLI | Not found | Assessment needed |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

# Check for containers
if command -v docker &> /dev/null && docker ps &> /dev/null; then
    echo "| Docker | Running | Check for A0 containers |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
elif command -v podman &> /dev/null; then
    echo "| Podman | Available | Check for A0 containers |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| Container runtime | Not found | A0 may need Docker |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

# RuVector indicators
cat >> "${LIVE_PATHS_DIR}/tool-availability.md" << EOF

## RuVector Indicators

| Indicator | Status | Notes |
|-----------|--------|-------|
EOF

if command -v ruvector &> /dev/null; then
    echo "| RuVector binary | Found | May be installed |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| RuVector binary | Not found | Assessment needed |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

# Rust (for RuVector)
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version 2>/dev/null || echo "unknown")
    echo "| Rust | ${RUST_VERSION} | May need for RuVector build |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
else
    echo "| Rust | Not found | Needed for RuVector from source |" >> "${LIVE_PATHS_DIR}/tool-availability.md"
fi

echo "  Tool availability inventory written"

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "=== Inventory Collection Complete ==="
echo ""
echo "Output files:"
echo "  - ${LIVE_PATHS_DIR}/canonical-paths.md"
echo "  - ${LIVE_PATHS_DIR}/tool-availability.md"
echo "  - ${HELPER_SCRIPTS_DIR}/gemma-helper-inventory.md"
echo "  - ${CONFIG_DOCS_DIR}/bazzite-security-config-docs.md"
echo ""
echo "Timestamp: ${TIMESTAMP}"

#!/usr/bin/env bash
set -e

PLUGIN_NAME="ix-ideal"
INSTALL_DIR="${HOME}/.claude/plugins/${PLUGIN_NAME}"

echo "Installing ${PLUGIN_NAME} to ${INSTALL_DIR}..."

# 检测安装方式
if command -v git &> /dev/null && [ -d "$(dirname "$0")/../.git" ]; then
    # 从本地仓库安装
    REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    mkdir -p "${INSTALL_DIR}"
    cp -r "${REPO_DIR}/skills" "${INSTALL_DIR}/"
    cp "${REPO_DIR}/package.json" "${INSTALL_DIR}/"
    cp "${REPO_DIR}/CLAUDE.md" "${INSTALL_DIR}/" 2>/dev/null || true
    echo "Installed from local repo: ${REPO_DIR}"
else
    # 从 GitHub 安装（curl）
    echo "Downloading from GitHub..."
    TMP_DIR=$(mktemp -d)
    curl -fsSL "https://github.com/ienning/ix-ideal/archive/refs/heads/main.tar.gz" | tar -xz -C "${TMP_DIR}" --strip-components=1
    mkdir -p "${INSTALL_DIR}"
    cp -r "${TMP_DIR}/skills" "${INSTALL_DIR}/"
    cp "${TMP_DIR}/package.json" "${INSTALL_DIR}/"
    cp "${TMP_DIR}/CLAUDE.md" "${INSTALL_DIR}/" 2>/dev/null || true
    rm -rf "${TMP_DIR}"
    echo "Downloaded and installed from GitHub"
fi

echo ""
echo "✓ ${PLUGIN_NAME} installed successfully!"
echo ""
echo "Usage in Claude Code:"
echo "  /idea              - Start from scratch (AI guides you)"
echo "  /idea my-idea.md   - Analyze existing template"
echo ""
echo "To uninstall: rm -rf ${INSTALL_DIR}"

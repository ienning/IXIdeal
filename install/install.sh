#!/usr/bin/env bash
set -e

# Claude Code 只识别 ~/.claude/skills/<name>/SKILL.md 形式的用户级 skill
SKILL_NAME="idea"
INSTALL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"
LEGACY_DIR="${HOME}/.claude/plugins/ix-ideal"

echo "Installing skill '${SKILL_NAME}' to ${INSTALL_DIR}..."

# 检测安装方式
# 通过 curl | bash 执行时 BASH_SOURCE 为空（$0 是 "bash"），不能用它推导仓库目录，直接走 GitHub 下载
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
if [ -n "${SCRIPT_PATH}" ] && [ -f "${SCRIPT_PATH}" ] && [ -d "$(dirname "${SCRIPT_PATH}")/../.git" ]; then
    # 从本地仓库安装
    REPO_DIR="$(cd "$(dirname "${SCRIPT_PATH}")/.." && pwd)"
    mkdir -p "${INSTALL_DIR}"
    cp -r "${REPO_DIR}/skills/${SKILL_NAME}/." "${INSTALL_DIR}/"
    echo "Installed from local repo: ${REPO_DIR}"
else
    # 从 GitHub 安装（curl）
    echo "Downloading from GitHub..."
    TMP_DIR=$(mktemp -d)
    curl -fsSL "https://github.com/ienning/IXIdeal/archive/refs/heads/main.tar.gz" | tar -xz -C "${TMP_DIR}" --strip-components=1
    mkdir -p "${INSTALL_DIR}"
    cp -r "${TMP_DIR}/skills/${SKILL_NAME}/." "${INSTALL_DIR}/"
    rm -rf "${TMP_DIR}"
    echo "Downloaded and installed from GitHub"
fi

# 清理旧版脚本装到 plugins 目录下的残留（该位置不会被 Claude Code 加载）
if [ -d "${LEGACY_DIR}" ]; then
    rm -rf "${LEGACY_DIR}"
    echo "Removed legacy install: ${LEGACY_DIR}"
fi

echo ""
echo "✓ skill '${SKILL_NAME}' installed successfully!"
echo ""
echo "Usage in Claude Code (restart Claude Code first):"
echo "  /idea              - Start from scratch (AI guides you)"
echo "  /idea my-idea.md   - Analyze existing template"
echo ""
echo "To uninstall: rm -rf ${INSTALL_DIR}"

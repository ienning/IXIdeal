# IXIdeal — 想法落地引导工具

> 从一个模糊的想法出发，通过 AI 对话引导和深度分析，输出完整的项目启动包。

---

## 这是什么？

很多人有好想法，但不知道从哪里开始。IXIdeal 提供一个结构化工具，帮你：

- 用 8 个维度梳理清楚你的想法
- AI 评估技术、市场、资源三个维度的可行性
- 自动搜索 GitHub 开源项目和市场竞品
- 生成完整的项目启动包（技术方案 + 任务清单 + 资源推荐）

**适用人群**：开发者、产品经理、创业者——不论技术背景。

---

## 快速开始

### 方式一：Claude Code（推荐）

**1. 安装插件**

**Unix/macOS：**
```bash
# 从 GitHub 一键安装
curl -fsSL https://raw.githubusercontent.com/ienning/IXIdeal/main/install/install.sh | bash

# 或克隆后本地安装
git clone https://github.com/ienning/IXIdeal.git
cd IXIdeal && bash install/install.sh
```

**Windows（PowerShell）：**
```powershell
# 从 GitHub 一键安装
irm https://raw.githubusercontent.com/ienning/IXIdeal/main/install/install.ps1 | iex

# 或克隆后本地安装
git clone https://github.com/ienning/IXIdeal.git
cd IXIdeal; .\install\install.ps1
```

**2. 使用**

安装完成后，在 Claude Code 中：

```
# 从零开始（AI 引导你填写）
/idea

# 已有想法文档，直接分析
/idea my-idea.md
```

---

### 方式二：任意 AI 工具（ChatGPT / Gemini / Claude Web 等）

1. 下载或复制 [`idea-template.md`](./idea-template.md)，填写你的想法
2. 打开 [`idea-prompt-guide.md`](./idea-prompt-guide.md)，复制其中的系统提示词
3. 将系统提示词粘贴到 AI 工具，然后发送填好的模板内容
4. AI 会追问空字段，然后生成完整分析

---

### 方式三：Codex CLI

**1. 启用多代理支持**

在 `~/.codex/config.toml` 中添加：
```toml
[features]
multi_agent = true
```

**2. 安装 Skill**

```bash
# Codex 从 ~/.agents/skills/<名称>/SKILL.md 加载用户级 Skill
mkdir -p ~/.agents/skills/idea-codex
cp skills/idea-codex/SKILL.md ~/.agents/skills/idea-codex/
```

**3. 使用**

```
$idea-codex
$idea-codex my-idea.md
```

---

## 输出示例

分析完成后，`idea-template.md` 的末尾会自动写入：

```markdown
## 分析结果

### 可行性评估
| 维度 | 评级 | 说明 |
|------|------|------|
| 技术可行性 | 🟢 | Python 生态完善，相关库成熟 |
| 市场可行性 | 🟡 | 竞品较多，需差异化定位 |
| 资源可行性 | 🟢 | 个人项目 MVP 可在 4 周内完成 |

### 技术方案
...

### 开源项目参考
...

### MVP 任务拆解
- [ ] 搭建基础 CLI 框架（2h）
- [ ] 实现自动项目识别（4h）
...
```

---

## 仓库结构

```
IXIdeal/
  README.md                    # 本文档
  idea-template.md             # 独立模板（任意 AI 可用）
  idea-prompt-guide.md         # 通用 AI 使用指南（含系统提示词）
  package.json                 # 插件清单
  CLAUDE.md                    # Claude Code 说明
  skills/
    idea/
      SKILL.md                 # Claude Code Skill（/idea 命令，安装到 ~/.claude/skills/idea/）
    idea-codex/
      SKILL.md                 # Codex CLI 适配版（安装到 ~/.agents/skills/idea-codex/）
  install/
    install.sh                 # Unix/macOS 一键安装
    install.ps1                # Windows 一键安装
```

---

## 卸载

**Unix/macOS：**
```bash
rm -rf ~/.claude/skills/idea
```

**Windows：**
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\skills\idea"
```

---

## License

MIT © Ienning

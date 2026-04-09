# skill-flow

[English](README.md)

一个用于分析 Agent Skill 文件执行流程、工具交互与质量评分的 Agent Skill —— 并生成可视化 HTML 报告。

## 特性

- 🔍 **深度分析** —— 解析 YAML Frontmatter、正文指令、工具调用、Shell 命令及外部系统引用
- 📊 **质量评分** —— 5 个维度共 100 分：安全性、清晰度、工具设计、文档完整性、可维护性
- 🗺️ **交互流程图** —— 生成基于 Mermaid 的交互流程图，展示真实执行逻辑
- 📋 **HTML 报告** —— 单文件深色主题仪表盘，包含评分详情、工具矩阵和改进建议
- 🌐 **多平台支持** —— 开箱即用支持 6 个平台：

| 平台 | 标识 | Skill 目录 |
|------|------|-----------|
| Claude Code | 🟣 | `.claude/skills/` |
| GitHub Copilot | 🟢 | `.github/skills/` |
| OpenAI Codex | 🟠 | `.codex/skills/` |
| Gemini CLI | 🔵 | `.gemini/skills/` |
| OpenCode | 🔶 | `.opencode/skills/` |
| agentskills.io | 🌐 | `.agents/skills/` |

## 安装

### 通过安装脚本（推荐）

**macOS / Linux：**

```bash
./install-skill-flow.sh
```

**Windows（PowerShell）：**

```powershell
.\install-skill-flow.ps1
```

安装脚本会提示你选择目标平台和作用范围（用户级或项目级）。

### 手动安装

将 `skills/skill-flow/SKILL.md` 复制到你的 Agent Skill 目录。例如：

```bash
# Claude Code
cp skills/skill-flow/SKILL.md ~/.claude/skills/skill-flow/SKILL.md

# GitHub Copilot
cp skills/skill-flow/SKILL.md ~/.copilot/skills/skill-flow/SKILL.md

# OpenAI Codex
cp skills/skill-flow/SKILL.md ~/.codex/skills/skill-flow/SKILL.md

# Gemini CLI
cp skills/skill-flow/SKILL.md ~/.gemini/skills/skill-flow/SKILL.md

# OpenCode
cp skills/skill-flow/SKILL.md ~/.config/opencode/skills/skill-flow/SKILL.md

# agentskills.io（通用）
cp skills/skill-flow/SKILL.md ~/.agents/skills/skill-flow/SKILL.md
```

安装后请重启你的 Agent。

## 使用方式

通过名称调用该 Skill，或让 Agent 自动检测。示例：

```
分析 ./my-project/.claude/skills/deploy/SKILL.md 这个 Skill
```

```
审查这个 Skill：https://github.com/user/repo/blob/main/skills/my-skill/SKILL.md
```

```
分析当前项目中的所有 Skill
```

该 Skill 会：

1. 获取并验证 SKILL.md 文件
2. 自动检测目标平台（Claude Code / Copilot / Codex / Gemini / OpenCode）
3. 深度解析 Frontmatter 和正文内容
4. 构建包含参与者映射的交互模型
5. 按 5 个维度进行质量评分（满分 100）
6. 在终端输出摘要 + 在浏览器中打开完整 HTML 报告

## 评分维度

| 维度 | 满分 | 评估内容 |
|------|------|----------|
| 🔒 安全性 | 25 | 外部调用、敏感路径、破坏性命令、沙箱配置 |
| 📝 清晰度 | 25 | 步骤结构、逻辑衔接、指令明确性、角色定义 |
| 🔧 工具设计 | 20 | 权限声明、工具使用模式、平台最佳实践 |
| 📖 文档完整性 | 15 | Frontmatter 字段、描述信息、输出格式说明 |
| 🔄 可维护性 | 15 | 文件大小、硬编码值、错误处理、渐进式披露 |

### 等级划分

| 等级 | 分数 | 含义 |
|------|------|------|
| ⭐ 优秀 | 90–100 | 设计精良，安全可靠 |
| ✅ 良好 | 70–89 | 基本达标，有小幅改进空间 |
| ⚠️ 一般 | 50–69 | 存在明显不足 |
| ❌ 需改进 | 0–49 | 存在较多问题 |

## HTML 报告内容

生成的报告包含：

- **顶部标题栏** —— Skill 名称、平台徽章、总分、等级徽章、agentskills.io 合规状态
- **交互流程图** —— Mermaid 图表展示实际执行流程，按类型着色的节点
- **工具交互矩阵** —— 每个工具的调用方式、用途、权限状态和风险等级
- **外部系统清单** —— 所有外部调用的数据方向和风险标签
- **评分详情** —— 各维度卡片，含进度条和逐项扣分明细
- **agentskills.io 合规性** —— 标准检查与跨平台兼容性评估
- **改进建议** —— 按优先级排序的可操作建议

## 项目结构

```
hugewave-skill/
├── skills/
│   └── skill-flow/
│       └── SKILL.md           # Skill 本体
├── install-skill-flow.sh      # macOS / Linux 安装脚本
├── install-skill-flow.ps1     # Windows 安装脚本
├── README.md                  # English
├── README.zh.md               # 中文
└── LICENSE
```

## 前提条件

- 任何支持 [agentskills.io](https://agentskills.io) 标准或平台原生 Skill 的 AI 编程 Agent（Claude Code、GitHub Copilot、OpenAI Codex、Gemini CLI、OpenCode）
- 现代浏览器（用于查看 HTML 报告）

## 许可证

MIT

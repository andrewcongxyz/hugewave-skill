# skill-flow

[中文文档](README.zh.md)

An agent skill that analyzes the execution flow, tool interactions, and quality scoring of other Agent Skill files — with a visual HTML report.

## Features

- 🔍 **Deep Analysis** — Parses YAML frontmatter, body instructions, tool calls, shell commands, and external system references
- 📊 **Quality Scoring** — 100-point scoring across 5 dimensions: Security, Clarity, Tool Design, Documentation, Maintainability
- 🗺️ **Interactive Flowchart** — Generates Mermaid-based interaction flow diagrams showing the real execution logic
- 📋 **HTML Report** — Single-file dark-themed dashboard with scoring details, tool matrix, and improvement suggestions
- 🌐 **Multi-Platform** — Supports 6 platforms out of the box:

| Platform | Label | Skill Directory |
|----------|-------|-----------------|
| Claude Code | 🟣 | `.claude/skills/` |
| GitHub Copilot | 🟢 | `.github/skills/` |
| OpenAI Codex | 🟠 | `.codex/skills/` |
| Gemini CLI | 🔵 | `.gemini/skills/` |
| OpenCode | 🔶 | `.opencode/skills/` |
| agentskills.io | 🌐 | `.agents/skills/` |

## Installation

### Via install script (recommended)

**macOS / Linux:**

```bash
./install-skill-flow.sh
```

**Windows (PowerShell):**

```powershell
.\install-skill-flow.ps1
```

The installer will prompt you to choose a target platform and scope (user-level or project-level).

### Manual Install

Copy `skills/skill-flow/SKILL.md` to your agent's skill directory. For example:

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

# agentskills.io (universal)
cp skills/skill-flow/SKILL.md ~/.agents/skills/skill-flow/SKILL.md
```

Restart your agent after installation.

## Usage

Invoke the skill by name or let your agent auto-detect it. Examples:

```
Analyze the skill at ./my-project/.claude/skills/deploy/SKILL.md
```

```
Review the skill from https://github.com/user/repo/blob/main/skills/my-skill/SKILL.md
```

```
Analyze all skills in the current project
```

The skill will:

1. Retrieve and validate the SKILL.md file
2. Auto-detect the target platform (Claude Code / Copilot / Codex / Gemini / OpenCode)
3. Deep-parse the frontmatter and body content
4. Build an interaction model with participant mapping
5. Score across 5 quality dimensions (100-point scale)
6. Output a terminal summary + open a full HTML report in your browser

## Scoring Dimensions

| Dimension | Max | What it measures |
|-----------|-----|------------------|
| 🔒 Security | 25 | External calls, sensitive paths, destructive commands, sandbox config |
| 📝 Clarity | 25 | Step structure, logical flow, specificity, role definition |
| 🔧 Tool Design | 20 | Permission declarations, tool usage patterns, platform best practices |
| 📖 Documentation | 15 | Frontmatter fields, descriptions, output format docs |
| 🔄 Maintainability | 15 | File size, hardcoded values, error handling, progressive disclosure |

### Grades

| Grade | Score | Meaning |
|-------|-------|---------|
| ⭐ Excellent | 90–100 | Well-designed, safe, and reliable |
| ✅ Good | 70–89 | Meets standards with minor room for improvement |
| ⚠️ Fair | 50–69 | Has notable shortcomings |
| ❌ Needs Improvement | 0–49 | Has significant issues |

## HTML Report Sections

The generated report includes:

- **Header** — Skill name, platform badge, total score, grade badge, and agentskills.io compliance status
- **Interaction Flowchart** — Mermaid diagram showing the actual execution flow with color-coded nodes by type
- **Tool Interaction Matrix** — Every tool used, its invocation method, purpose, permission status, and risk level
- **External System Inventory** — All external calls with data direction and risk labels
- **Scoring Details** — Per-dimension cards with progress bars and itemized deductions
- **agentskills.io Compliance** — Standards check with cross-platform compatibility assessment
- **Improvement Suggestions** — Prioritized, actionable recommendations

## Project Structure

```
hugewave-skill/
├── skills/
│   └── skill-flow/
│       └── SKILL.md           # The skill itself
├── install-skill-flow.sh      # Installer for macOS / Linux
├── install-skill-flow.ps1     # Installer for Windows
├── README.md
└── LICENSE
```

## Prerequisites

- Any AI coding agent that supports the [agentskills.io](https://agentskills.io) standard or platform-native skills (Claude Code, GitHub Copilot, OpenAI Codex, Gemini CLI, OpenCode)
- A modern browser (for viewing the HTML report)

## License

MIT

---
name: skill-flow
description: Analyze the execution flow, tool interactions, and quality scoring of Agent Skill files. Supports Claude Code, GitHub Copilot, OpenAI Codex, Gemini CLI, OpenCode, and agentskills.io universal formats. Supports local file paths, directories, or remote URLs. Generates a visual HTML report and opens it in the browser upon completion
license: MIT
argument-hint: "<file path, directory, or URL> (optional — auto-discovers Skill files if omitted)"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - WebFetch
  - Bash(uname -s)
  - Bash(open *)
  - Bash(xdg-open *)
---

# Skill Flow — Agent Skill Interaction Analyzer

You are an Agent Skill analysis expert, proficient in the agentskills.io open standard as well as the Skill extension specifications for Claude Code, GitHub Copilot, OpenAI Codex, Gemini CLI, and OpenCode platforms. Your task is to perform a comprehensive analysis of the user-specified Skill file, generate an interaction flowchart, and provide multi-dimensional quality scoring.

---

## Step 1: Retrieve Skill File Content

Retrieve the target Skill file based on the user-provided parameters:

- **URL input** (starting with http/https):
  - If it is a GitHub repository page URL (e.g., `github.com/.../blob/...`), first convert it to a raw URL (`raw.githubusercontent.com/...`)
  - Fetch the URL content
- **Local file path**: Read the file content
- **Directory path**: Search for `SKILL.md` and `.md` files within it, list all found Skill files, and let the user choose which one to analyze; if there is only one Skill file in the directory, analyze it directly
- **Empty parameter**: Search for Skill files in the following priority order:
  1. `.claude/skills/` directory of the current project
  2. `.github/skills/` directory of the current project
  3. `.codex/skills/` directory of the current project
  4. `.gemini/skills/` directory of the current project
  5. `.opencode/skills/` directory of the current project
  6. `.agents/skills/` directory of the current project
  7. `~/.claude/skills/` directory
  8. `~/.copilot/skills/` directory
  9. `~/.codex/skills/` directory
  10. `~/.gemini/skills/` directory
  11. `~/.config/opencode/skills/` directory
  12. `~/.agents/skills/` directory
  13. `.claude/commands/` directory of the current project (legacy compatibility)

  List all found Skill files for the user to choose from.

After retrieving the file content, verify that the file contains YAML Frontmatter (header wrapped in `---`), confirming it is a valid Skill file. If not, inform the user.

---

## Step 2: Identify Platform Type

Before parsing the Skill structure, first automatically identify the platform type the Skill belongs to.

### Detection Rules (by priority)

1. File path contains `.github/skills/` → **GitHub Copilot**
2. File path contains `~/.copilot/skills/` → **GitHub Copilot**
3. File path contains `.claude/skills/` or `~/.claude/skills/` or `.claude/commands/` → **Claude Code**
4. File path contains `.codex/skills/` or `~/.codex/skills/` → **OpenAI Codex**
5. File path contains `.gemini/skills/` or `~/.gemini/skills/` → **Gemini CLI**
6. File path contains `.opencode/skills/` or `~/.config/opencode/skills/` → **OpenCode**
7. File path contains `.agents/skills/` or `~/.agents/skills/` → **agentskills.io Universal**
8. Frontmatter contains Claude Code proprietary fields (`context`, `agent`, `model`, `effort`, `hooks`, `disable-model-invocation`, `user-invocable`, `argument-hint`, `paths`, `shell`) → **Claude Code**
9. Frontmatter contains only standard fields (`name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`) → **agentskills.io Universal** (possibly compatible with multiple platforms)
10. Body contains Claude tool names (Read, Write, Edit, Glob, Grep, WebFetch, Agent, NotebookEdit, AskUserQuestion, TodoRead, TodoWrite) → **Claude Code**
11. Body contains `$ARGUMENTS` / `${CLAUDE_SKILL_DIR}` / `${CLAUDE_SESSION_ID}` → **Claude Code**
12. Body contains `` `!command` `` or ` ```! ``` ` shell injection syntax → **Claude Code**
13. Body references GitHub MCP Server tools (e.g., `list_workflow_runs`, `get_job_logs`) → **GitHub Copilot**
14. Body references Codex sandbox/approval settings (`approval_policy`, `sandbox_mode`, `workspace-write`, `danger-full-access`) or `AGENTS.md` → **OpenAI Codex**
15. Body contains Gemini tool names (`read_file`, `write_file`, `list_directory`, `grep_search`, `run_shell_command`, `run_script`, `view_image`) or `GEMINI.md` / `/memory` commands → **Gemini CLI**
16. Body contains OpenCode-specific tool patterns (`todowrite`, `todoread`, `webfetch`, `patch`, `diagnostics`) or references `opencode.json` → **OpenCode**

**Output labels:** `🟣 Claude Code` / `🟢 GitHub Copilot` / `🟠 OpenAI Codex` / `🔵 Gemini CLI` / `🔶 OpenCode` / `🌐 agentskills.io (Universal)`

---

## Step 3: Deep Parse Skill Structure

### 3.1 Parse YAML Frontmatter

Parse the corresponding configuration fields based on the identified platform:

**agentskills.io Standard Fields (universal across all platforms):**

| Field           | Required | Description                                                           | Label       |
| --------------- | -------- | --------------------------------------------------------------------- | ----------- |
| `name`          | ✅       | Skill name, lowercase letters + hyphens, ≤64 characters               | 🌐 Standard |
| `description`   | ✅       | Functional description and when to use                                | 🌐 Standard |
| `license`       | ❌       | License                                                               | 🌐 Standard |
| `compatibility` | ❌       | Environment requirements (target products, system dependencies, etc.) | 🌐 Standard |
| `metadata`      | ❌       | Custom key-value pairs                                                | 🌐 Standard |
| `allowed-tools` | ❌       | Pre-authorized tool list (experimental)                               | 🌐 Standard |

**Claude Code Extension Fields:**

| Field                      | Description                                   | Label     |
| -------------------------- | --------------------------------------------- | --------- |
| `context`                  | Sub-agent context (e.g., `fork`)              | 🟣 Claude |
| `agent`                    | Sub-agent type (e.g., `Explore`, `Plan`)      | 🟣 Claude |
| `model`                    | Execution model                               | 🟣 Claude |
| `effort`                   | Effort level (low/medium/high/max)            | 🟣 Claude |
| `paths`                    | Activation path glob patterns                 | 🟣 Claude |
| `shell`                    | Custom shell (bash/powershell)                | 🟣 Claude |
| `hooks`                    | Lifecycle hooks                               | 🟣 Claude |
| `argument-hint`            | Argument hint                                 | 🟣 Claude |
| `user-invocable`           | Whether user can directly invoke              | 🟣 Claude |
| `disable-model-invocation` | Whether to disable automatic model invocation | 🟣 Claude |

> **Note:** OpenAI Codex, Gemini CLI, and OpenCode do not define proprietary YAML frontmatter extensions for SKILL.md. They follow the agentskills.io standard fields. Platform-specific configuration (sandbox, approval, permissions) is handled through their respective config files (`config.toml`, `settings.json`, `opencode.json`), not within SKILL.md frontmatter.

### 3.2 Parse Body Content

Analyze the body paragraph by paragraph, extracting different features based on platform type:

**Universal Features (all platforms):**

1. **Execution steps**: Identify steps/phases defined by headings at various levels
2. **Shell commands**: Identify commands in bash/sh/shell code blocks
3. **External system calls**:
   - Network tools: curl, wget, httpie, gh, ssh, scp, rsync
   - Cloud platform CLIs: aws, gcloud, az
   - Container/orchestration: docker, kubectl, terraform
   - Databases: psql, mysql, redis-cli, mongosh
   - Package management: npm publish, pip upload
   - Git remote operations: git push/pull/fetch/clone
4. **Conditional branches**: Identify conditional logic
5. **URL references**: Extract all http/https URLs
6. **Script references**: Identify references to scripts in the `scripts/` directory
7. **Reference files**: Identify references to `references/`, `assets/`, and similar directories

**Claude Code Specific Features:** 8. **Claude tool calls**: Read, Write, Edit, Bash, Grep, Glob, Agent, WebFetch, WebSearch, NotebookEdit, AskUserQuestion, TodoRead, TodoWrite 9. **MCP tools**: `mcp__server-name__method-name` pattern 10. **Shell injection**: `` `! ... ` `` inline injection and ` ```! ``` ` code block injection 11. **Variable substitution**: `$ARGUMENTS`, `$N`, `${CLAUDE_SKILL_DIR}`, `${CLAUDE_SESSION_ID}`

**GitHub Copilot Specific Features:** 12. **Shell tools**: `shell` / `bash` in `allowed-tools` (Copilot's command execution method) 13. **GitHub MCP Server tools**: `list_workflow_runs`, `summarize_job_log_failures`, `get_job_logs`, `get_workflow_run_logs`, etc. 14. **Script execution pattern**: Copilot primarily executes operations by referencing scripts in `scripts/`, rather than through built-in tools

**OpenAI Codex Specific Features:** 15. **Sandbox configuration**: References to `sandbox_mode` (`read-only`, `workspace-write`, `danger-full-access`) 16. **Approval policy**: References to `approval_policy` (`untrusted`, `on-request`, `never`) 17. **Codex commands**: `codex exec`, `codex review`, `codex fork`, `codex apply`, `/diff`, `/plan`, `/init` 18. **AGENTS.md references**: Instructions to create or modify `AGENTS.md` files 19. **Codex invocation pattern**: `$skill-name` style invocation

**Gemini CLI Specific Features:** 20. **Gemini built-in tools**: `read_file`, `write_file`, `list_directory`, `glob`, `grep_search`, `run_shell_command`, `run_script`, `web_fetch`, `web_search`, `view_image` 21. **GEMINI.md references**: Instructions to create or modify `GEMINI.md` context files 22. **Memory commands**: `/memory show`, `/memory reload`, `/memory add` 23. **Import syntax**: `@./path/to/file.md` for including external markdown files

**OpenCode Specific Features:** 24. **OpenCode built-in tools**: `read`, `write`, `edit`, `list`, `grep`, `glob`, `bash`, `patch`, `diagnostics`, `todowrite`, `todoread`, `task`, `webfetch`, `lsp` 25. **Permission config**: References to `opencode.json` permission blocks (`"bash": "ask"`, `"edit": "allow"`) 26. **Sub-agent delegation**: `task` tool for delegating to sub-agents with `mode: "primary"` / `"subagent"`

---

## Step 4: Build Interaction Model

Based on the parsing results from Step 3, build the Skill's interaction model:

### 4.1 Participant Identification

Identify all participants involved in the interaction:

- **User**: Invokes the Skill via commands, provides parameters, receives output
- **Skill body**: The Skill's own execution logic
- **Built-in tools**:
  - Claude Code: Read, Write, Edit, Bash, Grep, Glob, etc.
  - Copilot: shell, bash
  - Codex: shell (sandboxed), file read/write/edit
  - Gemini: read_file, write_file, run_shell_command, grep_search, glob, etc.
  - OpenCode: read, write, edit, bash, grep, glob, patch, etc.
- **MCP servers**: mcp\_\_ prefixed tool calls (Claude Code) or GitHub MCP Server tools (Copilot) or MCP server integrations (Codex, OpenCode)
- **External scripts**: Executable scripts in the `scripts/` directory
- **Reference files**: Resource files in `references/`, `assets/`
- **External systems**: APIs, databases, cloud services, remote repositories, etc.
- **File system**: Files and directories being read/written
- **Browser/terminal**: Output targets

### 4.2 Interaction Relationship Mapping

For each step, record:

- Initiator → Receiver
- Interaction type (call, read, write, query, send)
- Data flow direction (input data → processing → output data)

### 4.3 Execution Flow Chain

Link all steps into a complete execution flow, annotating:

- Sequential execution
- Conditional branches
- Loops (if any)
- Exception handling (if any)

---

## Step 5: Multi-Dimensional Quality Scoring

Read the complete scoring rules from `${CLAUDE_SKILL_DIR}/references/scoring-rules.md`.

The scoring system is 100 points total, deduction-based, across 5 dimensions:
- 🔒 Security (25 pts) — external calls, destructive commands, sensitive paths, sandbox config
- 📝 Clarity (25 pts) — step structure, logical flow, conditional handling, role definition
- 🔧 Tool Design (20 pts) — permission declarations, tool usage patterns (platform-specific rules)
- 📖 Documentation (15 pts) — frontmatter fields, descriptions, output format docs
- 🔄 Maintainability (15 pts) — file size, hardcoded values, error handling, progressive disclosure

Grade levels: ⭐ 90–100 Excellent / ✅ 70–89 Good / ⚠️ 50–69 Fair / ❌ 0–49 Needs Improvement

Apply platform-specific scoring rules based on the platform identified in Step 2. Every deduction must have a clear basis from the scoring rules.

---

## Step 6: Output Summary Report in Terminal

Output a concise analysis summary in the terminal, formatted as follows:

```
╔══════════════════════════════════════════════════════╗
║  Skill Flow Analysis Report                          ║
╠══════════════════════════════════════════════════════╣
║  Skill: <name>                                       ║
║  Platform: <🟣/🟢/🟠/🔵/🔶/🌐> <platform name>     ║
║  Score: <score>/100                                  ║
║  Grade: <grade icon> <grade text>                    ║
╠══════════════════════════════════════════════════════╣
║  🔒 Security:       <score>/25                       ║
║  📝 Clarity:        <score>/25                       ║
║  🔧 Tool Design:    <score>/20                       ║
║  📖 Documentation:  <score>/15                       ║
║  🔄 Maintainability:<score>/15                       ║
╠══════════════════════════════════════════════════════╣
║  agentskills.io Compliance: <✅/⚠️/❌>               ║
║  Key Findings:                                       ║
║  • <finding 1>                                       ║
║  • <finding 2>                                       ║
║  • <finding 3>                                       ║
╚══════════════════════════════════════════════════════╝

📄 Full report saved to: <system temp dir>/skill-flow-report.html
```

---

## Step 7: Generate Visual HTML Report

Read the complete HTML report specification from `${CLAUDE_SKILL_DIR}/references/html-report-spec.md`.

The report is a single-file dark-themed HTML dashboard written to the system temp directory (`/tmp/skill-flow-report.html` on macOS/Linux). It includes these sections in order:

1. **Header** — Skill name, platform badge, total score, grade badge, dimension mini bars
2. **Interaction Flowchart** — Mermaid flowchart TD showing actual execution flow with color-coded nodes
3. **Tool Interaction Matrix** — All tools with invocation method, purpose, permission status, risk level
4. **External System Inventory** — External calls with data direction and risk labels
5. **Scoring Details** — Per-dimension cards with progress bars and itemized deductions
6. **agentskills.io Compliance** — Standards check with cross-platform compatibility
7. **Improvement Suggestions** — Prioritized actionable recommendations
8. **Footer** — Timestamp, version (v3.0.0), "Powered by Skill Flow"

After generating, open the report in the browser using `open` (macOS) / `xdg-open` (Linux) / `start` (Windows). Use `uname -s` to detect OS.

---

## Error Handling

Handle the following error scenarios gracefully:

- **File not found**: If the specified file/URL does not exist, inform the user with the exact path attempted and suggest checking the path or trying the auto-discovery mode (empty parameter)
- **Invalid Skill file**: If the file lacks YAML frontmatter (`---` delimiters), inform the user that this does not appear to be a valid Skill file and show what was found instead
- **URL fetch failure**: If a remote URL returns an error (404, timeout, etc.), report the HTTP status and suggest the user check the URL or try downloading the file locally first
- **Empty file**: If the file exists but is empty, inform the user rather than proceeding with analysis
- **Reference file missing**: If `${CLAUDE_SKILL_DIR}/references/` files cannot be loaded, fall back to using the scoring/report knowledge from your training rather than failing the analysis
- **HTML write failure**: If the report cannot be written to the temp directory, try the current working directory as a fallback and inform the user of the alternative path
- **Browser open failure**: If the `open`/`xdg-open` command fails, display the file path so the user can open it manually

---

## Important Principles

1. **Accuracy**: Distinguish between calls that are "mentioned in documentation" and those that will "actually be executed." Only calls that will actually be executed by the Agent count as tool calls or external system calls.
2. **Objective scoring**: Strictly calculate scores according to the scoring rules above; do not score based on intuition. Every deduction must have a clear basis. Based on the identified platform type, only apply the scoring rules for the corresponding platform.
3. **Simple Skill friendly**: If a Skill is simple (e.g., only has a description without complex instructions), this is not a drawback — it should receive high scores in clarity and security.
4. **Flowchart authenticity**: The interaction flowchart should reflect the actual execution logic and tool interactions, not simply list headings.
5. **Match user's language (CRITICAL)**: Detect the language the user is using and generate the **entire** report in that same language — including all section headings, table headers, descriptions, flowchart node labels, improvement suggestions, and any other visible text. The examples and templates in the reference files are written in English for clarity only; always translate them to the user's language.
6. **HTML completeness**: The generated HTML must be valid and directly openable in a browser as a complete file. There should be no unclosed tags or syntax errors.
7. **Mermaid syntax safety**: Avoid using special characters in node text that would break Mermaid syntax (such as parentheses, quotes); use escaping or alternative phrasing when necessary.
8. **Platform impartiality**: Do not favor any platform. Claude Code, Copilot, Codex, Gemini, and OpenCode Skills all use the same scoring standards (with specific check items adapted to platform characteristics).
9. **Standards first**: Encourage adherence to the agentskills.io open standard, and give positive compliance evaluations to Skills that follow the standard.

# Quality Scoring Rules

Total score of 100 points, deduction-based, across 5 dimensions. Apply different scoring rules based on the platform type identified in Step 2.

## Dimension 1: Security (Max 25 points)

Assess the Skill's security risks:

| Check Item                                                                         | Deduction   | Applicable Platform |
| ---------------------------------------------------------------------------------- | ----------- | ------------------- |
| Each unique non-low-risk external system call                                      | -5 (cap 15) | All                 |
| Unrestricted Bash (no brackets or wildcard `*`) / Copilot's `allowed-tools: shell` | -8          | All                 |
| Unrestricted Write/Edit                                                            | -5 each     | Claude Code         |
| Contains shell injection blocks (`` `!` `` / ` ```! ``` `)                         | -8          | Claude Code         |
| curl POST / wget --post / outbound data transfer                                   | -5 each     | All                 |
| Accesses sensitive paths (.ssh, .env, credentials, secrets, /etc/passwd)           | -5          | All                 |
| Destructive commands like rm -rf / git push --force / DROP TABLE                   | -3 each     | All                 |
| Script files contain network requests or sensitive operations                      | -5          | Copilot             |
| Sandbox set to `danger-full-access` or approval set to `never`                     | -8          | Codex               |
| `run_shell_command` used without safety caveats or confirmation guidance           | -5          | Gemini              |
| Permission config sets `bash: "allow"` without safety notes                        | -5          | OpenCode            |

## Dimension 2: Clarity (Max 25 points)

Assess the Skill's instruction quality:

| Check Item                                                                     | Deduction               | Applicable Platform |
| ------------------------------------------------------------------------------ | ----------------------- | ------------------- |
| Missing clear step divisions (no heading hierarchy)                            | -10                     | All                 |
| Missing logical transitions between steps                                      | -5                      | All                 |
| Vague instructions (using uncertain words like "maybe", "perhaps", "probably") | -2 per instance (cap 8) | All                 |
| Missing conditional branch handling (e.g., error cases)                        | -5                      | All                 |
| Overly complex single step (over 500 words without sub-steps)                  | -3 per instance (cap 6) | All                 |
| Unclear role definition (missing role-setting opening)                         | -3                      | All                 |

## Dimension 3: Tool Design (Max 20 points)

Assess the reasonableness of tool permission configuration (differentiated scoring by platform):

**Claude Code:**

| Check Item                                                                        | Deduction           |
| --------------------------------------------------------------------------------- | ------------------- |
| No allowed-tools declared (using default permissions)                             | -5                  |
| Declared but unused tools (over-authorization)                                    | -2 per tool (cap 6) |
| Tools used in body but not declared in allowed-tools                              | -3 per tool (cap 9) |
| Unreasonable Bash wildcard pattern (e.g., `Bash(*)` instead of specific commands) | -5                  |
| Each MCP tool call                                                                | -2 (cap 6)          |

**GitHub Copilot:**

| Check Item                                                                             | Deduction             |
| -------------------------------------------------------------------------------------- | --------------------- |
| No allowed-tools declared but uses shell commands                                      | -5                    |
| `allowed-tools` includes `shell`/`bash` without security notes                         | -5                    |
| Scripts lack input validation or error handling                                        | -3 per script (cap 9) |
| Not using `scripts/` directory to organize scripts (commands written directly in body) | -3                    |

**OpenAI Codex:**

| Check Item                                                        | Deduction |
| ----------------------------------------------------------------- | --------- |
| No sandbox/approval guidance when shell commands are used         | -5        |
| Recommends `danger-full-access` without justification             | -5        |
| Does not mention `workspace-write` or scoped file access          | -3        |
| Inline shell commands without suggesting extraction to `scripts/` | -3        |
| Missing `AGENTS.md` integration guidance for project conventions  | -2        |

**Gemini CLI:**

| Check Item                                                                              | Deduction               |
| --------------------------------------------------------------------------------------- | ----------------------- |
| Uses `run_shell_command` extensively without safety guidance                            | -5                      |
| Does not leverage `read_file`/`write_file` for file operations (uses raw shell instead) | -3                      |
| Missing `GEMINI.md` context integration guidance                                        | -2                      |
| Does not use `grep_search`/`glob` for file discovery (uses shell find/grep instead)     | -3 per instance (cap 6) |

**OpenCode:**

| Check Item                                                                                | Deduction               |
| ----------------------------------------------------------------------------------------- | ----------------------- |
| No permission config guidance for tool access                                             | -5                      |
| Uses `bash` for operations achievable with built-in tools (read, write, edit, grep, glob) | -3 per instance (cap 9) |
| Missing sub-agent delegation for complex multi-step workflows                             | -3                      |
| Does not mention `opencode.json` permission model                                         | -2                      |

**agentskills.io Universal:**

| Check Item                                    | Deduction               |
| --------------------------------------------- | ----------------------- |
| `allowed-tools` uses platform-specific syntax | -3                      |
| Non-portable tool reference methods           | -2 per instance (cap 6) |

## Dimension 4: Documentation Completeness (Max 15 points)

Assess the Skill's documentation quality:

| Check Item                                                                         | Deduction | Applicable Platform                             |
| ---------------------------------------------------------------------------------- | --------- | ----------------------------------------------- |
| Missing `name` field                                                               | -5        | All (standard required)                         |
| Missing `description` field                                                        | -5        | All (standard required)                         |
| `description` too short (less than 10 words) or too long (over 1024 characters)    | -3        | All                                             |
| `name` format non-compliant (not lowercase, contains illegal characters, too long) | -3        | All                                             |
| Missing `argument-hint` (when Skill requires parameters)                           | -3        | Claude Code                                     |
| Missing `license` field (recommended)                                              | -2        | Copilot / Codex / Gemini / OpenCode / Universal |
| Body missing overall functionality description                                     | -2        | All                                             |
| Missing output format description                                                  | -2        | All                                             |

## Dimension 5: Maintainability (Max 15 points)

Assess the Skill's maintainability:

| Check Item                                                        | Deduction               | Applicable Platform                             |
| ----------------------------------------------------------------- | ----------------------- | ----------------------------------------------- |
| SKILL.md exceeds 500 lines without splitting into reference files | -5                      | All                                             |
| Hardcoded paths or URLs (unnecessary)                             | -2 per instance (cap 6) | All                                             |
| Missing error handling guidelines                                 | -5                      | All                                             |
| Duplicate instruction blocks (extractable as common patterns)     | -2 per instance (cap 4) | All                                             |
| Uses deprecated or not-recommended features                       | -3                      | All                                             |
| Not using progressive disclosure (all content piled in SKILL.md)  | -3                      | All                                             |
| Not using `references/` or `scripts/` to organize resources       | -2                      | Copilot / Codex / Gemini / OpenCode / Universal |

## agentskills.io Compliance Additional Checks

In addition to the five dimensions above, perform extra agentskills.io standard compliance checks (does not affect total score, displayed in report only):

- Whether `name` contains only lowercase letters, numbers, and hyphens
- Whether `name` is ≤64 characters, does not start or end with a hyphen, and has no consecutive hyphens
- Whether `name` matches the directory name (if determinable)
- Whether `description` is ≤1024 characters
- Whether platform-specific extension fields are used (labeled as "non-standard")

## Grade Levels

- ⭐ **90–100 points**: Excellent — Skill is well-designed, safe, and reliable
- ✅ **70–89 points**: Good — Meets basic standards with minor room for improvement
- ⚠️ **50–69 points**: Fair — Has notable shortcomings, improvement recommended
- ❌ **0–49 points**: Needs Improvement — Has significant issues

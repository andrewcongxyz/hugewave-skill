# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

hugewave-skill is a distribution repository for **skill-flow**, an AI agent skill that analyzes other Agent Skill files (SKILL.md). It parses execution flow, tool interactions, and provides quality scoring with a visual HTML report. The skill itself is a single large Markdown file — there is no build system, no tests, and no compiled code.

## Repository Structure

- `skills/skill-flow/SKILL.md` — The skill definition (the core deliverable). This is a ~540-line Markdown file with YAML frontmatter that instructs AI agents how to analyze other skills.
- `install-skill-flow.sh` / `install-skill-flow.ps1` — Interactive installers that copy SKILL.md to the user's chosen agent platform directory (Claude Code, GitHub Copilot, OpenAI Codex, Gemini CLI, OpenCode, or agentskills.io).

## Supported Platforms

The skill targets 6 AI coding agent platforms. Each has its own skill directory convention:

| Platform | Project-level | User-level |
|----------|--------------|------------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| GitHub Copilot | `.github/skills/` | `~/.copilot/skills/` |
| OpenAI Codex | `.codex/skills/` | `~/.codex/skills/` |
| Gemini CLI | `.gemini/skills/` | `~/.gemini/skills/` |
| OpenCode | `.opencode/skills/` | `~/.config/opencode/skills/` |
| agentskills.io | `.agents/skills/` | `~/.agents/skills/` |

## Key Design Decisions

- SKILL.md follows the [agentskills.io](https://agentskills.io) open standard with YAML frontmatter (`name`, `description`, `license`).
- The skill uses a 100-point deduction-based scoring system across 5 dimensions (Security 25, Clarity 25, Tool Design 20, Documentation 15, Maintainability 15), with platform-specific scoring rules.
- HTML reports are single-file, dark-themed, use Mermaid JS from CDN for flowcharts, and are written to the system temp directory.
- The skill must remain platform-impartial — it supports all 6 platforms equally and applies the same scoring standards adapted to each platform's characteristics.

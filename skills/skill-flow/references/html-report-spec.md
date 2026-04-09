# HTML Report Specification

Write the complete analysis results to `skill-flow-report.html` in the system temporary directory.

**Cross-platform temp directory detection:**

- macOS / Linux: `/tmp/skill-flow-report.html`
- Windows (PowerShell / CMD): `$env:TEMP\skill-flow-report.html` or `%TEMP%\skill-flow-report.html`
- Universal method: First run `python3 -c "import tempfile; print(tempfile.gettempdir())"` to get the temp directory path

## Basic Specifications

- Single file, no external CSS dependencies (all styles inline)
- Load Mermaid JS from CDN: `https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js`
- Dark theme, modern dashboard style
- HTML must be valid and directly openable in a browser as a complete file
- Match user's language: report in the same language the user uses. All descriptions and report content should match the user's language.

## Page Structure (top to bottom)

### 1. Top Header Bar

- Left side: Skill name + source path (URL or file path)
- Right side: Total score in large font + grade badge
- Colors change with grade: Excellent green, Good blue, Fair orange, Needs Improvement red
- Bottom left: **Platform badge** (🟣 Claude Code / 🟢 GitHub Copilot / 🟠 OpenAI Codex / 🔵 Gemini CLI / 🔶 OpenCode / 🌐 agentskills.io) + agentskills.io compliance label (✅ Compliant / ⚠️ Partially Compliant / ❌ Non-Compliant)
- Bottom right: Mini score bars for 5 dimensions
- If the Skill uses platform-specific extensions, display a cross-platform compatibility note (e.g., "⚠️ This Skill uses Claude Code proprietary fields and cannot be directly used in Copilot/Codex/Gemini/OpenCode")

### 2. Interaction Flowchart (Core Section)

Generate an interaction flowchart in **Mermaid flowchart TD** format.

**Node design:**

- All node labels use **English**
- Node IDs use short English identifiers (n0, n1, n2...)
- No more than 25 nodes

**Node shapes and colors (adapted by platform):**
| Type | Shape | Color | Mermaid Syntax Example | Applicable Platform |
|------|-------|-------|------------------------|---------------------|
| Entry (user invocation) | Rounded rectangle | Indigo `fill:#6366f1,color:#fff` | `n0["User Invokes Skill"]` | All |
| Regular step | Rectangle | Blue `fill:#3b82f6,color:#fff` | `n1["Parse Arguments"]` | All |
| Conditional | Diamond | Amber `fill:#f59e0b,color:#fff` | `n2{"URL or Local Path?"}` | All |
| Claude tool call | Rounded rectangle | Cyan `fill:#06b6d4,color:#fff` | `n3("Call Read to Read File")` | Claude Code |
| Codex sandboxed op | Rounded rectangle | Orange-red `fill:#ea580c,color:#fff` | `n3("Sandboxed File Edit")` | OpenAI Codex |
| Gemini tool call | Rounded rectangle | Sky blue `fill:#0ea5e9,color:#fff` | `n3("Call read_file")` | Gemini CLI |
| OpenCode tool call | Rounded rectangle | Amber `fill:#d97706,color:#fff` | `n3("Call edit Tool")` | OpenCode |
| Shell/script execution | Parallelogram | Orange `fill:#f97316,color:#fff` | `n4[/"Execute Shell Command"/]` | All |
| External system | Hexagon | Red `fill:#ef4444,color:#fff` | `n5{{"Access GitHub API"}}` | All |
| File I/O | Cylinder | Emerald `fill:#10b981,color:#fff` | `n6[("Write Report File")]` | All |
| Reference file loading | Trapezoid | Purple `fill:#8b5cf6,color:#fff` | `n7[/"Load references/API.md"/\]` | Copilot / Codex / Gemini / OpenCode / Universal |
| Output/End | Stadium | Green `fill:#22c55e,color:#fff` | `n8(["Output Analysis Results"])` | All |

**Edge design:**

- Sequential execution: Solid arrow `-->`
- Conditional branch: Labeled arrow `-->|Yes|` / `-->|No|`
- Data passing: Dashed arrow `-.->|data|`

**Flowchart requirements:**

- Flowchart title must include the platform label (e.g., "🟣 Claude Code Skill Interaction Flow", "🟢 GitHub Copilot Skill Interaction Flow", "🟠 OpenAI Codex Skill Interaction Flow", "🔵 Gemini CLI Skill Interaction Flow", or "🔶 OpenCode Skill Interaction Flow")
- Reflect the Skill's **actual execution logic**, not just a simple listing of steps
- Show the complete interaction chain: User → Skill → Tools → External Systems → Output
- Conditional branches must fully display all branch paths
- Annotate key data flows (e.g., "file content", "analysis results")
- For Copilot Skills, show script referencing and progressive loading flows
- For Codex Skills, show sandbox boundaries and approval checkpoints
- For Gemini Skills, show GEMINI.md context loading and tool invocation patterns
- For OpenCode Skills, show permission checks and sub-agent delegation

**Placement:**

- Place inside `<pre class="mermaid">` tags
- Initialize Mermaid with dark theme

### 3. Tool Interaction Matrix

Table displaying all tools used by the Skill:

| Column                 | Description                                                                             |
| ---------------------- | --------------------------------------------------------------------------------------- |
| Tool Name              | e.g., Read, Bash, WebFetch, read_file, run_shell_command                                |
| Invocation Method      | Direct call / Shell injection / Code block reference / Config-based                     |
| Purpose                | What this tool is used for in the Skill                                                 |
| Permission Declaration | ✅ Declared in allowed-tools / ❌ Not declared / ⚠️ Over-authorized / 🔧 Config-managed |
| Risk Level             | 🟢 Low / 🟡 Medium / 🔴 High                                                            |

### 4. External System Call Inventory

If the Skill involves external system calls, list them:

| Column         | Description                                  |
| -------------- | -------------------------------------------- |
| System/Service | e.g., GitHub API, AWS S3                     |
| Call Method    | curl / gh / aws cli / MCP / Codex exec, etc. |
| Data Direction | ⬇️ Read / ⬆️ Send / ↕️ Bidirectional         |
| Purpose        | Why access is needed                         |
| Risk Label     | `High` red / `Medium` orange / `Low` green   |

If there are no external system calls, display a green "✅ This Skill does not involve external system calls" notice.

### 5. Scoring Details

Scoring details for 5 dimensions:

- One card per dimension
- Each card contains:
  - Dimension name + icon
  - Score / Max score (large font)
  - CSS bar progress indicator (color changes with score ratio: ≥80% green, ≥60% blue, ≥40% orange, <40% red)
  - Deduction details list (each deduction item shows how many points were deducted and why)
  - If full score, display "🎉 Perfect score for this dimension!"

### 6. agentskills.io Compliance (Dedicated Section)

Standalone card showing agentskills.io standard compliance check results:

- Compliance status overview (✅ Compliant / ⚠️ Partially Compliant / ❌ Non-Compliant)
- Item-by-item check results:
  - `name` format compliance
  - `description` format compliance
  - Whether non-standard extension fields are used (list specific fields and their platform)
- Cross-platform compatibility assessment: Which platforms this Skill can be directly used on (Claude Code, Copilot, Codex, Gemini, OpenCode)

### 7. Improvement Suggestions

Based on the analysis results, provide specific, actionable improvement suggestions:

- Sorted by priority (high → low)
- Each suggestion includes: Problem description + specific improvement method + expected outcome
- Use icons to differentiate priority: 🔴 High priority / 🟡 Medium priority / 🟢 Low priority

### 8. Footer

- Display analysis timestamp
- Display Skill Flow version number (v3.0.0)
- "Powered by Skill Flow"

## CSS Style Specifications

```
Background:       #0f172a (dark blue-black)
Card background:  #1e293b
Card hover:       #253349
Border color:     #334155
Primary text:     #f1f5f9
Secondary text:   #94a3b8
Muted text:       #64748b
Accent (indigo):  #6366f1
Success (green):  #22c55e
Warning (orange): #f97316
Danger (red):     #ef4444
Info (cyan):      #06b6d4
Font:             system-ui, -apple-system, 'Segoe UI', sans-serif
Code font:        'SF Mono', Menlo, Monaco, Consolas, monospace
Card radius:      12px
Card padding:     24px
Card gap:         20px
Max width:        1000px centered
Transition:       transition: all 0.2s ease
```

## Opening the Report

After generating the HTML, use the appropriate command to open the report in the browser based on the operating system:

- **macOS**: `open <report path>`
- **Linux**: `xdg-open <report path>`
- **Windows**: `start <report path>`

Use `uname -s` to determine the current system (Darwin = macOS, Linux = Linux). If the command does not exist in a Windows environment, default to using `start`.

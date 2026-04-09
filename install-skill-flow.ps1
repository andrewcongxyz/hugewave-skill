# install-skill-flow.ps1 — Install skill-flow to your preferred AI coding agent
# Supports: Windows (PowerShell 5.1+)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillSource = Join-Path $ScriptDir "skills\skill-flow\SKILL.md"
$RefsSource = Join-Path $ScriptDir "skills\skill-flow\references"

function Print-Banner {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       Skill Flow — Installer             ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# Check source files exist
if (-not (Test-Path $SkillSource)) {
    Write-Host "Error: SKILL.md not found at $SkillSource" -ForegroundColor Red
    Write-Host "Please run this script from the hugewave-skill root directory."
    exit 1
}

if (-not (Test-Path $RefsSource)) {
    Write-Host "Error: references/ directory not found at $RefsSource" -ForegroundColor Red
    Write-Host "Please run this script from the hugewave-skill root directory."
    exit 1
}

Print-Banner
Write-Host "Detected: Windows" -ForegroundColor DarkGray
Write-Host ""

$Home_ = $env:USERPROFILE

# Define installation targets
$Targets = @(
    @{ Label = "[Purple] Claude Code (user)";       Path = "$Home_\.claude\skills\skill-flow" }
    @{ Label = "[Purple] Claude Code (project)";    Path = ".claude\skills\skill-flow" }
    @{ Label = "[Green] GitHub Copilot (user)";     Path = "$Home_\.copilot\skills\skill-flow" }
    @{ Label = "[Green] GitHub Copilot (project)";  Path = ".github\skills\skill-flow" }
    @{ Label = "[Orange] OpenAI Codex (user)";      Path = "$Home_\.codex\skills\skill-flow" }
    @{ Label = "[Orange] OpenAI Codex (project)";   Path = ".codex\skills\skill-flow" }
    @{ Label = "[Blue] Gemini CLI (user)";          Path = "$Home_\.gemini\skills\skill-flow" }
    @{ Label = "[Blue] Gemini CLI (project)";       Path = ".gemini\skills\skill-flow" }
    @{ Label = "[Gold] OpenCode (user)";            Path = "$Home_\.config\opencode\skills\skill-flow" }
    @{ Label = "[Gold] OpenCode (project)";         Path = ".opencode\skills\skill-flow" }
    @{ Label = "[Globe] agentskills.io (user)";     Path = "$Home_\.agents\skills\skill-flow" }
    @{ Label = "[Globe] agentskills.io (project)";  Path = ".agents\skills\skill-flow" }
)

# Platform colors
$Colors = @(
    "Magenta", "Magenta",
    "Green", "Green",
    "DarkYellow", "DarkYellow",
    "Blue", "Blue",
    "Yellow", "Yellow",
    "Cyan", "Cyan"
)

# Platform emoji/icons for display
$Icons = @(
    [char]0x25CF, [char]0x25CF,   # Purple circles for Claude
    [char]0x25CF, [char]0x25CF,   # Green circles for Copilot
    [char]0x25CF, [char]0x25CF,   # Orange circles for Codex
    [char]0x25CF, [char]0x25CF,   # Blue circles for Gemini
    [char]0x25CF, [char]0x25CF,   # Gold circles for OpenCode
    [char]0x25CF, [char]0x25CF    # Cyan circles for agentskills.io
)

# Pretty labels
$PrettyLabels = @(
    "Claude Code (user)",       "Claude Code (project)",
    "GitHub Copilot (user)",    "GitHub Copilot (project)",
    "OpenAI Codex (user)",      "OpenAI Codex (project)",
    "Gemini CLI (user)",        "Gemini CLI (project)",
    "OpenCode (user)",          "OpenCode (project)",
    "agentskills.io (user)",    "agentskills.io (project)"
)

Write-Host "Select installation target:" -NoNewline
Write-Host ""
Write-Host ""

for ($i = 0; $i -lt $Targets.Count; $i++) {
    $num = "{0,4}" -f "$($i + 1))"
    $displayPath = $Targets[$i].Path -replace [regex]::Escape($Home_), "~"
    
    Write-Host $num -NoNewline -ForegroundColor White
    Write-Host "  " -NoNewline
    Write-Host "$($Icons[$i]) " -NoNewline -ForegroundColor $Colors[$i]
    $paddedLabel = $PrettyLabels[$i].PadRight(32)
    Write-Host $paddedLabel -NoNewline -ForegroundColor $Colors[$i]
    Write-Host " $displayPath\" -ForegroundColor DarkGray
}

$customNum = $Targets.Count + 1
$num = "{0,4}" -f "$customNum)"
Write-Host ""
Write-Host "$num  Custom path" -ForegroundColor White
Write-Host ""

# Read selection
do {
    $choice = Read-Host "Enter choice [1-$customNum]"
} while (-not ($choice -match '^\d+$') -or [int]$choice -lt 1 -or [int]$choice -gt $customNum)

$choice = [int]$choice

# Determine target path
if ($choice -eq $customNum) {
    $TargetDir = Read-Host "Enter custom path"
    $TargetDir = $TargetDir -replace "^~", $Home_
} else {
    $TargetDir = $Targets[$choice - 1].Path
}

# Confirm
$displayTarget = $TargetDir -replace [regex]::Escape($Home_), "~"
Write-Host ""
Write-Host "Will install to: " -NoNewline -ForegroundColor Yellow
Write-Host "$displayTarget\SKILL.md" -ForegroundColor Yellow
$confirm = Read-Host "Proceed? [Y/n]"
if ([string]::IsNullOrWhiteSpace($confirm)) { $confirm = "Y" }

if ($confirm -notmatch '^[Yy]$') {
    Write-Host "Installation cancelled." -ForegroundColor DarkGray
    exit 0
}

# Install
$RefsTargetDir = Join-Path $TargetDir "references"
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
if (-not (Test-Path $RefsTargetDir)) {
    New-Item -ItemType Directory -Path $RefsTargetDir -Force | Out-Null
}
Copy-Item -Path $SkillSource -Destination (Join-Path $TargetDir "SKILL.md") -Force
Copy-Item -Path (Join-Path $RefsSource "*.md") -Destination $RefsTargetDir -Force

$refsCount = (Get-ChildItem -Path $RefsSource -Filter "*.md").Count
Write-Host ""
Write-Host "  skill-flow installed successfully!" -ForegroundColor Green
Write-Host "  $displayTarget\SKILL.md" -ForegroundColor DarkGray
Write-Host "  $displayTarget\references\ ($refsCount files)" -ForegroundColor DarkGray
Write-Host ""

#!/usr/bin/env bash
# install-skill-flow.sh — Install skill-flow to your preferred AI coding agent
# Supports: macOS, Linux

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_SOURCE="$SCRIPT_DIR/skills/skill-flow/SKILL.md"
REFS_SOURCE="$SCRIPT_DIR/skills/skill-flow/references"

# Colors
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
BLUE='\033[34m'
RESET='\033[0m'

print_banner() {
  echo ""
  echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}${BOLD}║       Skill Flow — Installer             ║${RESET}"
  echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════╝${RESET}"
  echo ""
}

# Check source files exist
if [ ! -f "$SKILL_SOURCE" ]; then
  echo -e "${RED}Error: SKILL.md not found at $SKILL_SOURCE${RESET}"
  echo "Please run this script from the hugewave-skill root directory."
  exit 1
fi

if [ ! -d "$REFS_SOURCE" ]; then
  echo -e "${RED}Error: references/ directory not found at $REFS_SOURCE${RESET}"
  echo "Please run this script from the hugewave-skill root directory."
  exit 1
fi

print_banner

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Darwin) OS_NAME="macOS" ;;
  Linux)  OS_NAME="Linux" ;;
  *)      echo -e "${RED}Unsupported OS: $OS. Use install-skill-flow.ps1 for Windows.${RESET}"; exit 1 ;;
esac
echo -e "${DIM}Detected: ${OS_NAME}${RESET}"
echo ""

# Define installation targets: label | path
TARGETS=(
  "🟣 Claude Code (user)|$HOME/.claude/skills/skill-flow"
  "🟣 Claude Code (project)|.claude/skills/skill-flow"
  "🟢 GitHub Copilot (user)|$HOME/.copilot/skills/skill-flow"
  "🟢 GitHub Copilot (project)|.github/skills/skill-flow"
  "🟠 OpenAI Codex (user)|$HOME/.codex/skills/skill-flow"
  "🟠 OpenAI Codex (project)|.codex/skills/skill-flow"
  "🔵 Gemini CLI (user)|$HOME/.gemini/skills/skill-flow"
  "🔵 Gemini CLI (project)|.gemini/skills/skill-flow"
  "🔶 OpenCode (user)|$HOME/.config/opencode/skills/skill-flow"
  "🔶 OpenCode (project)|.opencode/skills/skill-flow"
  "🌐 agentskills.io (user)|$HOME/.agents/skills/skill-flow"
  "🌐 agentskills.io (project)|.agents/skills/skill-flow"
)

echo -e "${BOLD}Select installation target:${RESET}"
echo ""

for i in "${!TARGETS[@]}"; do
  IFS='|' read -r label path <<< "${TARGETS[$i]}"
  # Shorten $HOME display
  display_path="${path/#$HOME/~}"
  printf "  ${BOLD}%2d)${RESET}  %-36s ${DIM}%s${RESET}\n" "$((i+1))" "$label" "$display_path/"
done

echo ""
printf "  ${BOLD}%2d)${RESET}  Custom path\n" "$((${#TARGETS[@]}+1))"
echo ""

# Read selection
while true; do
  read -rp "$(echo -e "${CYAN}Enter choice [1-$((${#TARGETS[@]}+1))]: ${RESET}")" choice

  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$((${#TARGETS[@]}+1))" ]; then
    break
  fi
  echo -e "${RED}Invalid choice. Please try again.${RESET}"
done

# Determine target path
if [ "$choice" -eq "$((${#TARGETS[@]}+1))" ]; then
  read -rp "$(echo -e "${CYAN}Enter custom path: ${RESET}")" custom_path
  # Expand ~ manually
  TARGET_DIR="${custom_path/#\~/$HOME}"
else
  IFS='|' read -r _ TARGET_DIR <<< "${TARGETS[$((choice-1))]}"
fi

# Confirm
display_target="${TARGET_DIR/#$HOME/~}"
echo ""
echo -e "${YELLOW}Will install to: ${BOLD}${display_target}/SKILL.md${RESET}"
read -rp "$(echo -e "${CYAN}Proceed? [Y/n]: ${RESET}")" confirm
confirm="${confirm:-Y}"

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "${DIM}Installation cancelled.${RESET}"
  exit 0
fi

# Install
mkdir -p "$TARGET_DIR/references"
cp "$SKILL_SOURCE" "$TARGET_DIR/SKILL.md"
cp "$REFS_SOURCE"/*.md "$TARGET_DIR/references/"

echo ""
echo -e "${GREEN}${BOLD}✅ skill-flow installed successfully!${RESET}"
echo -e "${DIM}   ${display_target}/SKILL.md${RESET}"
echo -e "${DIM}   ${display_target}/references/ ($(ls "$REFS_SOURCE"/*.md | wc -l | tr -d ' ') files)${RESET}"
echo ""

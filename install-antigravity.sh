#!/bin/bash
# Install MonScanner sales agents into Antigravity (Gemini skills)
# Usage: ./install-antigravity.sh

SKILLS_DIR="$HOME/.gemini/antigravity/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/antigravity"

echo "Installing MonScanner sales agents to $SKILLS_DIR..."

agents=(
  monscanner-outbound-strategist
  monscanner-discovery-coach
  monscanner-deal-strategist
  monscanner-sales-engineer
  monscanner-proposal-strategist
  monscanner-pipeline-analyst
  monscanner-account-strategist
  monscanner-sales-coach
)

installed=0
for agent in "${agents[@]}"; do
  src="$SOURCE_DIR/$agent/SKILL.md"
  dest="$SKILLS_DIR/$agent"
  if [ -f "$src" ]; then
    mkdir -p "$dest"
    cp "$src" "$dest/SKILL.md"
    echo "  ✓ $agent"
    ((installed++))
  else
    echo "  ✗ $agent (source not found)"
  fi
done

echo ""
echo "Done! $installed/8 agents installed to $SKILLS_DIR"
echo "Restart Gemini to pick up the new skills."

#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$HOME/.gemini/antigravity/skills"
TODAY="$(date +%Y-%m-%d)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COUNT=0

get_field() {
  local field="$1" file="$2"
  awk -v f="$field" '
    /^---$/ { fm++; next }
    fm == 1 && $0 ~ "^" f ": " { sub("^" f ": ", ""); print; exit }
  ' "$file"
}

get_body() {
  awk 'BEGIN{fm=0} /^---$/{fm++; next} fm>=2{print}' "$1"
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//'
}

mkdir -p "$SKILLS_DIR"

for f in "$SCRIPT_DIR"/monscanner-*.md; do
  [ -f "$f" ] || continue

  name="$(get_field "name" "$f")"
  description="$(get_field "description" "$f")"
  slug="monscanner-$(slugify "$name")"
  body="$(get_body "$f")"

  outdir="$SKILLS_DIR/$slug"
  mkdir -p "$outdir"

  printf '%s\n' "---" "name: ${slug}" "description: ${description}" "risk: low" "source: community" "date_added: '${TODAY}'" "---" "" > "$outdir/SKILL.md"
  printf '%s\n' "$body" >> "$outdir/SKILL.md"

  echo "[OK] Installed: $slug"
  (( COUNT++ )) || true
done

echo ""
echo "Done. Installed $COUNT MonScanner skills to $SKILLS_DIR"

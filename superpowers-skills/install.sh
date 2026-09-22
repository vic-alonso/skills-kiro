#!/usr/bin/env bash
# Install Superpowers skills + bootstrap into a Kiro workspace.
#
# Usage:
#   bash superpowers-skills/install.sh [TARGET_WORKSPACE]
#
# TARGET_WORKSPACE defaults to the current directory. Pass "~" (or "$HOME") to
# install globally for every workspace.
#
# Copies:
#   superpowers-skills/skills/   -> <target>/.kiro/skills/
#   superpowers-skills/steering/ -> <target>/.kiro/steering/
#
# Re-run to update. Existing files with the same name are overwritten; unrelated
# files in the target .kiro/ directories are left untouched.

set -euo pipefail

# Directory this script lives in (the superpowers-skills package root).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET="${1:-$PWD}"
# Expand a bare ~ if the shell didn't.
TARGET="${TARGET/#\~/$HOME}"

if [ ! -d "$TARGET" ]; then
  echo "error: target workspace does not exist: $TARGET" >&2
  exit 1
fi

SRC_SKILLS="$SCRIPT_DIR/skills"
SRC_STEERING="$SCRIPT_DIR/steering"

if [ ! -d "$SRC_SKILLS" ] || [ ! -d "$SRC_STEERING" ]; then
  echo "error: cannot find skills/ or steering/ next to install.sh ($SCRIPT_DIR)" >&2
  exit 1
fi

DEST_SKILLS="$TARGET/.kiro/skills"
DEST_STEERING="$TARGET/.kiro/steering"

mkdir -p "$DEST_SKILLS" "$DEST_STEERING"

# The trailing /. copies directory *contents* (merges into existing .kiro dirs).
cp -R "$SRC_SKILLS/." "$DEST_SKILLS/"
cp -R "$SRC_STEERING/." "$DEST_STEERING/"

skill_count=$(find "$DEST_SKILLS" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')

echo "Superpowers installed into $TARGET/.kiro"
echo "  skills   -> $DEST_SKILLS  ($skill_count skills)"
echo "  steering -> $DEST_STEERING/superpowers-bootstrap.md"
echo
echo "Start a fresh Kiro session and send: \"Let's make a react todo list\""
echo "A working install auto-triggers the brainstorming skill before any code."

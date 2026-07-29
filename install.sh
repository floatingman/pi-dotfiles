#!/usr/bin/env bash
# install.sh — wire pi-agent config + skills into place from this dotfiles repo.
#
# Run after cloning on a new machine:
#   git clone <remote> ~/dotfiles && cd ~/dotfiles && ./install.sh
#
# Creates symlinks:
#   ~/.agents/skills             -> ~/dotfiles/agents/skills
#   ~/.pi/agent/settings.json    -> ~/dotfiles/pi/settings.json
#   ~/.pi/agent/mcp.json         -> ~/dotfiles/pi/mcp.json
#
# Existing real files are backed up to <path>.bak; existing correct symlinks are skipped.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local target="$1"          # absolute path inside the repo
  local linkname="$2"        # standard-location path to create
  local parent
  parent="$(dirname "$linkname")"
  mkdir -p "$parent"

  # Already correctly linked?
  if [ -L "$linkname" ] && [ "$(readlink -f "$linkname")" = "$(readlink -f "$target")" ]; then
    echo "  ✓ $linkname already linked"
    return 0
  fi

  # Back up an existing real file/dir (not a symlink we just checked).
  if [ -e "$linkname" ] || [ -L "$linkname" ]; then
    echo "  • backing up existing $linkname -> ${linkname}.bak"
    rm -rf "${linkname}.bak"
    mv "$linkname" "${linkname}.bak"
  fi

  ln -s "$target" "$linkname"
  echo "  ✓ $linkname -> $target"
}

echo "Linking pi-agent config from $REPO"
link "$REPO/agents/skills"          "$HOME/.agents/skills"
link "$REPO/pi/settings.json"       "$HOME/.pi/agent/settings.json"
link "$REPO/pi/mcp.json"            "$HOME/.pi/agent/mcp.json"

echo ""
echo "Done. Notes:"
echo "  - Skills are read automatically by pi from ~/.agents/skills (no settings entry needed)."
echo "  - settings.json references the local package '../../git/pi-reviewer' (relative to ~/.pi/agent)."
echo "    Clone pi-reviewer to ~/git/pi-reviewer for that package to resolve."
echo "  - If a backup (*.bak) was created, review it and delete it once you've confirmed everything works."

#!/usr/bin/env bash
set -euo pipefail

AUTOSTART_FILE="$HOME/.config/autostart/rpg15-autostart.desktop"
LAUNCHER_FILE="$HOME/.local/bin/rpg15-autostart.sh"

if [[ -f "$AUTOSTART_FILE" ]]; then
  rm -f "$AUTOSTART_FILE"
  echo "Removed: $AUTOSTART_FILE"
else
  echo "Not found: $AUTOSTART_FILE"
fi

if [[ -f "$LAUNCHER_FILE" ]]; then
  rm -f "$LAUNCHER_FILE"
  echo "Removed: $LAUNCHER_FILE"
else
  echo "Not found: $LAUNCHER_FILE"
fi

echo "RPG15 Linux autostart removed."

#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[RPG15] %s\n' "$1"
}

fail() {
  printf '[RPG15][ERROR] %s\n' "$1" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_SCRIPT="$SCRIPT_DIR/start-rpg15-silent.sh"
AUTOSTART_DIR="$HOME/.config/autostart"
LOCAL_BIN_DIR="$HOME/.local/bin"
LAUNCHER="$LOCAL_BIN_DIR/rpg15-autostart.sh"
DESKTOP_FILE="$AUTOSTART_DIR/rpg15-autostart.desktop"

if [[ ! -f "$PROJECT_SCRIPT" ]]; then
  fail "Missing script: $PROJECT_SCRIPT"
fi

log "Preparing autostart directories"
mkdir -p "$AUTOSTART_DIR" "$LOCAL_BIN_DIR"
chmod +x "$PROJECT_SCRIPT"

log "Creating launcher: $LAUNCHER"
cat >"$LAUNCHER" <<EOF
#!/usr/bin/env bash
"$PROJECT_SCRIPT"
EOF
chmod +x "$LAUNCHER"

log "Creating desktop entry: $DESKTOP_FILE"
cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=RPG15 Auto Start
Comment=Start RPG15 local server and open dashboard
Exec=$LAUNCHER
X-GNOME-Autostart-enabled=true
Terminal=false
Hidden=false
EOF

[[ -f "$DESKTOP_FILE" ]] || fail "Desktop file was not created"
[[ -f "$LAUNCHER" ]] || fail "Launcher was not created"

log "Installed Linux autostart: $DESKTOP_FILE"
log "Launcher: $LAUNCHER"
log "Done"
# cd ~/Thitipong/RPG15-School/RPG15 chmod +x install-startup-rpg15-linux.sh start-rpg15-silent.sh ./install-startup-rpg15-linux.sh
# cat ~/.config/autostart/rpg15-autostart.desktop
# cat ~/.local/bin/rpg15-autostart.sh
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_SCRIPT="$SCRIPT_DIR/start-rpg15-silent.sh"
AUTOSTART_DIR="$HOME/.config/autostart"
LOCAL_BIN_DIR="$HOME/.local/bin"
LAUNCHER="$LOCAL_BIN_DIR/rpg15-autostart.sh"
DESKTOP_FILE="$AUTOSTART_DIR/rpg15-autostart.desktop"

if [[ ! -f "$PROJECT_SCRIPT" ]]; then
  echo "[ERROR] Missing script: $PROJECT_SCRIPT"
  exit 1
fi

mkdir -p "$AUTOSTART_DIR" "$LOCAL_BIN_DIR"
chmod +x "$PROJECT_SCRIPT"

cat >"$LAUNCHER" <<EOF
#!/usr/bin/env bash
"$PROJECT_SCRIPT"
EOF
chmod +x "$LAUNCHER"

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=RPG15 Auto Start
Comment=Start RPG15 local server and open dashboard
Exec=$LAUNCHER
X-GNOME-Autostart-enabled=true
Terminal=false
EOF

echo "Installed Linux autostart: $DESKTOP_FILE"
echo "Launcher: $LAUNCHER"
# cd ~/Thitipong/RPG15-School/RPG15 chmod +x install-startup-rpg15-linux.sh start-rpg15-silent.sh ./install-startup-rpg15-linux.sh
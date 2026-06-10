#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
URL="http://localhost:8080/?sn=202604150001"

if [[ ! -f "$PROJECT_DIR/index.html" ]]; then
  exit 1
fi

if ! command -v http-server >/dev/null 2>&1; then
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "RPG15 Startup" "http-server not found. Run: npm install -g http-server"
  fi
  exit 1
fi

# Start server only if port 8080 is not already in use.
if ! command -v lsof >/dev/null 2>&1 || ! lsof -iTCP:8080 -sTCP:LISTEN >/dev/null 2>&1; then
  nohup http-server "$PROJECT_DIR" --proxy http://localhost -p 8080 \
    >"${TMPDIR:-/tmp}/rpg15-http-server.log" 2>&1 &
fi

sleep 5

fullscreen_with_f11() {
  if ! command -v xdotool >/dev/null 2>&1; then
    return
  fi

  (
    sleep 2
    for cls in google-chrome Google-chrome chromium Chromium chromium-browser; do
      wid="$(xdotool search --onlyvisible --class "$cls" 2>/dev/null | tail -n 1 || true)"
      if [[ -n "$wid" ]]; then
        xdotool windowactivate "$wid" key F11 >/dev/null 2>&1 || true
        break
      fi
    done
  ) >/dev/null 2>&1 &
}

if command -v google-chrome >/dev/null 2>&1; then
  nohup google-chrome --new-window --start-fullscreen "$URL" >/dev/null 2>&1 &
  fullscreen_with_f11
elif command -v google-chrome-stable >/dev/null 2>&1; then
  nohup google-chrome-stable --new-window --start-fullscreen "$URL" >/dev/null 2>&1 &
  fullscreen_with_f11
elif command -v chromium-browser >/dev/null 2>&1; then
  nohup chromium-browser --new-window --start-fullscreen "$URL" >/dev/null 2>&1 &
  fullscreen_with_f11
elif command -v chromium >/dev/null 2>&1; then
  nohup chromium --new-window --start-fullscreen "$URL" >/dev/null 2>&1 &
  fullscreen_with_f11
elif command -v firefox >/dev/null 2>&1; then
  # Firefox has no reliable start-fullscreen flag like Chromium; open normally.
  nohup firefox --new-window "$URL" >/dev/null 2>&1 &
else
  xdg-open "$URL" >/dev/null 2>&1 || true
fi

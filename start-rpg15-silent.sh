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
xdg-open "$URL" >/dev/null 2>&1 || true

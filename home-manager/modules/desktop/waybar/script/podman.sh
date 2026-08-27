#!/usr/bin/env bash
# Waybar custom module: running podman container count

if ! command -v podman &>/dev/null; then
  echo '{"text": " N/A", "tooltip": "podman not found", "class": "podman-error"}'
  exit 0
fi

if ! docker info &>/dev/null; then
  echo '{"text": " !", "tooltip": "podman daemon not running", "class": "podman-error"}'
  exit 0
fi

COUNT=$(podman ps -q 2>/dev/null | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  echo '{"text": " 0", "tooltip": "No running containers", "class": "podman-none"}'
else
  NAMES=$(podman ps --format '{{.Names}} ({{.Image}})' 2>/dev/null)
  NAMES="${NAMES//$'\n'/\\n}"
  echo "{\"text\": \"  ${COUNT}\", \"tooltip\": \"${NAMES}\", \"class\": \"podman\"}"
fi

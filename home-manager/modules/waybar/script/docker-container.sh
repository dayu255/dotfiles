#!/usr/bin/env bash
# Waybar custom module: running Docker container count

COUNT=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')

if ! command -v docker &>/dev/null; then
  echo '{"text": " N/A", "tooltip": "docker not found", "class": "docker-error"}'
  exit 0
fi

if ! docker info &>/dev/null 2>&1; then
  echo '{"text": " !", "tooltip": "Docker daemon not running", "class": "docker-error"}'
  exit 0
fi

if [ "$COUNT" -eq 0 ]; then
  echo '{"text": " 0", "tooltip": "No running containers", "class": "docker-none"}'
else
  NAMES=$(docker ps --format '{{.Names}} ({{.Image}})' 2>/dev/null | paste -sd '\n' -)
  echo "{\"text\": \"  ${COUNT}\", \"tooltip\": \"${NAMES}\", \"class\": \"docker\"}"
fi

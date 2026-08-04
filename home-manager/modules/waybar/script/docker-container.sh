#!/usr/bin/env bash
# Waybar custom module: running Docker container count

# 先にDockerコマンドとデーモンの状態をチェックする
if ! command -v docker &>/dev/null; then
  echo '{"text": " N/A", "tooltip": "docker not found", "class": "docker-error"}'
  exit 0
fi

if ! docker info &>/dev/null; then
  echo '{"text": " !", "tooltip": "Docker daemon not running", "class": "docker-error"}'
  exit 0
fi

COUNT=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  echo '{"text": " 0", "tooltip": "No running containers", "class": "docker-none"}'
else
  # コンテナ一覧を取得 (paste は使わない)
  NAMES=$(docker ps --format '{{.Names}} ({{.Image}})' 2>/dev/null)
  
  # 生の改行を文字列としての "\n" に置換する
  NAMES="${NAMES//$'\n'/\\n}"
  
  echo "{\"text\": \"  ${COUNT}\", \"tooltip\": \"${NAMES}\", \"class\": \"docker\"}"
fi

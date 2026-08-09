#!/usr/bin/env bash

# 標準エラー出力をすべて破棄（Warning等の混入防止）
exec 2>/dev/null

TAILSCALE_BIN="tailscale"

# コマンド未存在またはデーモン未起動の場合
if ! command -v "$TAILSCALE_BIN" &>/dev/null || ! command -v jq &>/dev/null; then
  echo '{"text": "󰲛 Disconnected", "tooltip": "Tailscale CLI or jq not found", "class": "disconnected"}'
  exit 0
fi

# ステータスを取得
status_json=$("$TAILSCALE_BIN" status --json 2>/dev/null)
backend_state=$(echo "$status_json" | jq -r '.BackendState // "NoState"' 2>/dev/null)

if [ "$backend_state" = "Running" ]; then
  my_ip=$(echo "$status_json" | jq -r '.TailscaleIPs[0] // "No IP"' 2>/dev/null)

  tooltip_content=$(printf "Tailscale: Connected\nIP: %s" "$my_ip")

  jq -c -n \
    --arg text "󰒄  connected" \
    --arg tooltip "$tooltip_content" \
    --arg class "connected" \
    '{text: $text, tooltip: $tooltip, class: $class}'
else
  jq -c -n \
    --arg text "󰲛  stopped" \
    --arg tooltip "Tailscale: Disconnected ($backend_state)" \
    --arg class "disconnected" \
    '{text: $text, tooltip: $tooltip, class: $class}'
fi

#!/bin/bash

# パブリックIPv4の取得 (外部APIを利用、タイムアウト2秒)
PUBLIC_IPV4=$(curl -s4 --max-time 2 https://checkip.amazonaws.com)

# プライベートIPv4の取得 (デフォルトルートから自動判定)
PRIVATE_IPV4=$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')

# グローバルIPv6の取得
IPV6=$(ip -6 addr show scope global 2>/dev/null | grep inet6 | awk '{print $2}' | cut -d/ -f1 | head -n1)

# 値が空だった場合のフォールバック
PUBLIC_IPV4=${PUBLIC_IPV4:-"Offline"}
PRIVATE_IPV4=${PRIVATE_IPV4:-"Offline"}
IPV6=${IPV6:-"None"}

# Waybar用のJSONフォーマットで出力
if [ "$PUBLIC_IPV4" = "$PRIVATE_IPV4" ] && [ "$PRIVATE_IPV4" != "Offline" ]; then
  # PUBLICとPRIVATEが同一、かつOfflineではない場合
  cat <<EOF
{"text": "v4: ${PUBLIC_IPV4}     v6: ${IPV6}", "tooltip": "Public IPv4: ${PUBLIC_IPV4}\nPrivate IPv4: ${PRIVATE_IPV4}\nIPv6: ${IPV6}"}
EOF
else
  # それ以外（NAT配下、もしくはオフライン）の場合
  cat <<EOF
{"text": "v4: ${PRIVATE_IPV4}   ${PUBLIC_IPV4}     v6: ${IPV6}", "tooltip": "Public IPv4: ${PUBLIC_IPV4}\nPrivate IPv4: ${PRIVATE_IPV4}\nIPv6: ${IPV6}"}
EOF
fi

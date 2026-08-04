#!/bin/bash

NO_IPV4="None"
NO_IPV6="None"

# パブリックIPv4の取得 (外部APIを利用、タイムアウト2秒)
PUBLIC_IPV4=$(curl -s4 --max-time 2 https://checkip.amazonaws.com | tr -d '\r\n')

# プライベートIPv4の取得 (デフォルトルートから自動判定)
PRIVATE_IPV4=$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')

# グローバルIPv6の取得
IPV6=$(ip -6 addr show scope global 2>/dev/null | grep inet6 | awk '{print $2}' | cut -d/ -f1 | head -n1)

# 値が空だった場合のフォールバック
PUBLIC_IPV4=${PUBLIC_IPV4:-"$NO_IPV4"}
PRIVATE_IPV4=${PRIVATE_IPV4:-"$NO_IPV4"}
IPV6=${IPV6:-$NO_IPV6}

# Waybar用のJSONフォーマットで出力
if [[ "$PUBLIC_IPV4" == "$PRIVATE_IPV4" && ("$PUBLIC_IPV4" != "$NO_IPV4" || "$PRIVATE_IPV4" != "$NO_IPV4") ]]; then
  # PUBLICとPRIVATEが同一、かつ少なくとも一方がOfflineではない場合
  cat <<EOF
{"text": "v4: ${PUBLIC_IPV4}     v6: ${IPV6}", "tooltip": "Public IPv4: ${PUBLIC_IPV4}\nPrivate IPv4: ${PRIVATE_IPV4}\nIPv6: ${IPV6}"}
EOF
elif [[ "$PUBLIC_IPV4" == "$NO_IPV4" && "$PRIVATE_IPV4" == "$NO_IPV4" ]]; then
  # IPv4が完全にオフラインの場合
  cat <<EOF
{"text": "v4: ${NO_IPV4}     v6: ${IPV6}", "tooltip": "Public IPv4: ${NO_IPV4}\nPrivate IPv4: ${NO_IPV4}\nIPv6: ${IPV6}"}
EOF
else
  # それ以外（NAT配下かつ両方がオフラインでない場合）
  cat <<EOF
{"text": "v4: ${PRIVATE_IPV4}   ${PUBLIC_IPV4}     v6: ${IPV6}", "tooltip": "Public IPv4: ${PUBLIC_IPV4}\nPrivate IPv4: ${PRIVATE_IPV4}\nIPv6: ${IPV6}"}
EOF
fi

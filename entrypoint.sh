#!/bin/sh
set -e
# UUID must come from Railway variables — never baked into the repo.
if [ -z "$UUID" ]; then
  echo "ERROR: UUID is not set. Set the UUID variable in Railway." >&2
  exit 1
fi
WS_PATH=${WS_PATH:-/vless}
PORT=${PORT:-3000}
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}", "flow": ""}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"},
        "security": "none"
      }
    }
  ],
  "outbounds": [
    {"protocol": "freedom", "settings": {}},
    {"protocol": "blackhole", "settings": {}, "tag": "blocked"}
  ]
}
EOF
echo "xray listening on port ${PORT}, ws path ${WS_PATH}"
exec /usr/local/bin/xray run -c /etc/xray/config.json

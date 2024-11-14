#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ! -f /var/lib/op-node/ee-secret/jwtsecret ]]; then
  echo "Generating JWT secret"
  __secret1=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  __secret2=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  echo -n "${__secret1}""${__secret2}" > /var/lib/op-node/ee-secret/jwtsecret
fi

if [[ -O "/var/lib/op-node/ee-secret/jwtsecret" ]]; then
  chmod 666 /var/lib/op-node/ee-secret/jwtsecret
fi

__public_ip="--p2p.advertise.ip $(wget -qO- https://ifconfig.me/ip)"

wget $ROLLUP_FILE_URL -O /var/lib/op-node/rollup.json
export OP_NODE_ROLLUP_CONFIG="/var/lib/op-node/rollup.json"

# Word splitting is desired for the command line parameters
# shellcheck disable=SC2086
exec "$@" ${__public_ip} ${OPNODE_EXTRAS}

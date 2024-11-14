#!/usr/bin/env bash
set -euo pipefail

# Set verbosity
shopt -s nocasematch
case ${LOG_LEVEL} in
  error)
    __verbosity="--verbosity 1"
    ;;
  warn)
    __verbosity="--verbosity 2"
    ;;
  info)
    __verbosity="--verbosity 3"
    ;;
  debug)
    __verbosity="--verbosity 4"
    ;;
  trace)
    __verbosity="--verbosity 5"
    ;;
  *)
    echo "LOG_LEVEL ${LOG_LEVEL} not recognized"
    __verbosity=""
    ;;
esac

if [[ ! -f /var/lib/op-geth/ee-secret/jwtsecret ]]; then
  echo "Generating JWT secret"
  __secret1=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  __secret2=$(head -c 8 /dev/urandom | od -A n -t u8 | tr -d '[:space:]' | sha256sum | head -c 32)
  echo -n "${__secret1}""${__secret2}" > /var/lib/op-geth/ee-secret/jwtsecret
fi

if [[ -O "/var/lib/op-geth/ee-secret/jwtsecret" ]]; then
  chmod 666 /var/lib/op-geth/ee-secret/jwtsecret
fi

if [ ! -d "/var/lib/op-geth/geth/" ]; then
    echo "Initializing geth datadir"
    wget $GENESIS_FILE_URL -O genesis.json
    geth init --datadir=/var/lib/op-geth genesis.json
else
    echo "geth datadir already initialized, skipping..."
fi

# Word splitting is desired for the command line parameters
# shellcheck disable=SC2086
exec "$@" ${__verbosity} ${OPGETH_EXTRAS}

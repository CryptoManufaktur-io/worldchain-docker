# Worldchain Docker

Docker compose for Worldchain

Meant to be used with central-proxy-docker for traefik and Prometheus remote write; use :ext-network.yml in COMPOSE_FILE inside .env in that case.

Please note this is a (hopefully) temporary workaround for worldchain-mainnet not being recognized by op-node.
worldchain is in the super chain registry; eventually we should be able to sunset this repo and use Optimism Docker

## Version

Worldchain Docker uses a "semver" scheme.

This is Worldchain Docker v0.1.1

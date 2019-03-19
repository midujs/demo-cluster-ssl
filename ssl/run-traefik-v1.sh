# !/bin/bash

### Clean up
docker-machine ssh manager "docker service rm traefik &> /dev/null || true"

### Create mount config on MANAGER node
docker-machine ssh manager "sh -c '
  mkdir -p /etc/traefik
  touch /etc/traefik/acme.json
  touch /etc/traefik/traefik.toml
'"

### Copy traefik config to MANAGER node
docker-machine scp ./ssl/traefik.toml manager:/etc/traefik/traefik.toml

### Create network
docker-machine ssh manager "docker network create --driver=overlay traefik-net &> /dev/null || true"

### Create traefik service
docker-machine ssh manager "docker service create \
    --name traefik \
    --constraint=node.role==manager \
    --publish 80:80 \
    --publish 443:443 \
    --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --mount type=bind,source=/etc/traefik/acme.json,target=/etc/traefik/acme.json \
    --mount type=bind,source=/etc/traefik/traefik.toml,target=/etc/traefik/traefik.toml \
    --network traefik-net \
    traefik \
    --api \
    --docker \
    --docker.watch \
    --docker.swarmMode"

### Log info
docker-machine ssh manager "docker service ps traefik"

echo ""
echo "To demo SSL, please map DOMAIN -> manager IP"
echo "  - manager IP:\x1b[1m\x1b[32m $(docker-machine ip manager) \x1b[0m"
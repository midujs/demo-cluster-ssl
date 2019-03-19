docker-machine ssh manager "docker service create \
    --name whoami0 \
    --label traefik.port=80 \
    --network traefik-net \
    containous/whoami"
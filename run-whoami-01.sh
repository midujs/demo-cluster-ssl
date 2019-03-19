docker-machine ssh manager "docker service create \
    --name whoami1 \
    --label traefik.port=80 \
    --network traefik-net \
    --label traefik.backend.loadbalancer.sticky=true \
    containous/whoami"
# !/bin/bash
APP_NAME=todo-app
DOMAIN_NAME=todo-app.traefik.tinypos.org

### Clean up
docker-machine ssh manager "docker service rm ${APP_NAME} &> /dev/null || true"

### Create todo-app service
docker-machine ssh manager "docker service create \
    --name ${APP_NAME} \
    --label traefik.enable=true \
    --label traefik.frontend.rule=Host:${DOMAIN_NAME} \
    --label traefik.port=80 \
    --label traefik.protocol=http \
    --network traefik-net \
  hoanganh25991/todo-app:v0.1"

### Log info
docker-machine ssh manager "docker service ps ${APP_NAME}"
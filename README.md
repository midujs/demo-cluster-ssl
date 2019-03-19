# Traefik

Swarm Mode Cluster

User guide

- Traefik: https://docs.traefik.io/user-guide/swarm-mode/
- Docker machine: https://docs.docker.com/machine/drivers/digital-ocean/

## Test on docker

Run traefik

```sh
# Consume port 80
# Listen to container on /var/run/docker.sock
docker-compose --file docker-compose.yml up --detach
```

Run whoami

```sh
# Run & scale without publish port
# Traefik self discovery to rout `whoami`
docker-compose --file docker-compose.whoami.yml up --scale whoami=2 --detach
```

## Test on docker-swarm

Create droplet

```sh
# base=https://github.com/docker/machine/releases/download/v0.16.0 &&
# curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/usr/local/bin/docker-machine &&
# chmod +x /usr/local/bin/docker-machine
DO_ACCESS_TOKEN=[YOUR TOKEN HERE]
docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    master

docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    worker-01

docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    worker-02
```

```sh
# Playground with docker-machine
docker-machine create -d virtualbox manager
docker-machine create -d virtualbox worker1
docker-machine create -d virtualbox worker2

# Enable swarm
sh enable-swarm.sh

# Review node in cluster
docker-machine ssh manager docker node ls

# Review manager IP
docker-machine ip manager
```

Create network overlay

```sh
docker-machine ssh manager "docker network create --driver=overlay traefik-net"
```

Start traefik

```sh
# Same as docker stack deploy with constraint node===manager
sh run-traefik.sh
```

Run app

```sh
sh run-whoami.sh
sh run-whoami-01.sh
```

See how `routing` by traefik works

```sh
curl -H Host:whoami0.traefik http://$(docker-machine ip manager)
curl -H Host:whoami1.traefik http://$(docker-machine ip manager)
```

Scale & see how `load-balancer` works

```sh
docker-machine ssh manager "docker service scale whoami0=5"
docker-machine ssh manager "docker service scale whoami1=5"
```

```sh
# Review service
docker-machine ssh manager "docker service ls"
```

See how traefik handle cookies

```sh
# Save IP of which container running into cookies.txt
curl -c cookies.txt -H Host:whoami1.traefik http://$(docker-machine ip manager)

# Load cookies.txt to expect SAME routing second call
curl -b cookies.txt -H Host:whoami1.traefik http://$(docker-machine ip manager)
```

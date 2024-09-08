#!/bin/bash

# Define the number of Redis nodes
NODES=3
START_PORT=7100  # Change starting port to 7100

# Pull the latest Redis image
docker pull redis:latest

# Start Redis instances
for i in $(seq 1 $NODES); do
    port=$((START_PORT + i - 1))
    docker run -d --name redis_$i -p $port:$port redis:latest redis-server --port $port --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 5000 --appendonly yes
done

# Get the IP addresses of the Redis containers
IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis_1)

# Forming the cluster
echo yes | docker exec -i  $NODES $START_PORT redis_1 redis-cli --cluster create $(for i in $(seq 1 $NODES); do echo -n "redis_$i:$((START_PORT + i - 1)) "; done) --cluster-replicas 0

echo "Redis cluster setup complete."


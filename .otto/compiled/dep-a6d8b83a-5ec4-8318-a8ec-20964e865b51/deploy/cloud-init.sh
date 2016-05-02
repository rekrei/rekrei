#!/bin/bash
set -e

# Install cURL if we have to
apt-get update -y
apt-get install -y curl

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Create the container
docker create -p 6379:6379 --name="redis" redis:3

# Write the service
cat >/etc/init/redis.conf <<EOF
description "Docker container: redis"

start on filesystem and started docker
stop on runlevel [!2345]

respawn

post-stop exec sleep 5

script
  /usr/bin/docker start redis
end script
EOF

# Start the service
start redis

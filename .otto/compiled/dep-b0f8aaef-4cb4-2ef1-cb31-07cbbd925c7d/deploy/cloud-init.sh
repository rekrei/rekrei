#!/bin/bash
set -e

# Install cURL if we have to
apt-get update -y
apt-get install -y curl

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Create the container
docker create -p 5432:5432 --name="postgresql" postgres:9.5

# Write the service
cat >/etc/init/postgresql.conf <<EOF
description "Docker container: postgresql"

start on filesystem and started docker
stop on runlevel [!2345]

respawn

post-stop exec sleep 5

script
  /usr/bin/docker start postgresql
end script
EOF

# Start the service
start postgresql

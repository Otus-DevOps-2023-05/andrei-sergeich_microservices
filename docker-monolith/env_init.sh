#!/bin/bash

# --generic-ip-address= ПОДСТАВИТЬ IP СОЗДАННОЙ VM
docker-machine create \
    --driver generic \
    --generic-ip-address=158.160.106.174 \
    --generic-ssh-user yc-user \
    --generic-ssh-key ~/.ssh/id_ed25519 \
    docker-host

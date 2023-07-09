#!/bin/bash

VM_NAME=docker-host
VM_SSH_USER=yc-user
VM_IP_ADDRESS=$(yc compute instance show --name $VM_NAME | grep -E ' +address' | tail -n 1 | awk '{print $2}')
SSH_KEY_PATH=~/.ssh/id_ed25519

docker-machine create \
    --driver generic \
    --generic-ip-address=$VM_IP_ADDRESS \
    --generic-ssh-user $VM_SSH_USER \
    --generic-ssh-key $SSH_KEY_PATH \
    $VM_NAME

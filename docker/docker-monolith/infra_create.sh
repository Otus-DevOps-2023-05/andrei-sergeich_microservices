#!/bin/bash

VM_NAME=docker-host
SSH_KEY_PATH=~/.ssh/id_ed25519.pub

yc compute instance create \
    --name $VM_NAME \
    --zone ru-central1-a \
    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
    --ssh-key $SSH_KEY_PATH

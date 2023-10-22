#!/usr/bin/bash
# print command before executing, and exit when any command fails
# set -xe

# Update the system clock
timedatectl set-ntp true

read -r -p "Have you already partitioned your disk, built filesystem, and mounted to /mnt correctly? [y/N]" confirm
if [[ ! "$confirm" =~ ^(y|Y) ]]; then
  ls
fi

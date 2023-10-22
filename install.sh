#!/usr/bin/bash
# print command before executing, and exit when any command fails
# set -xe


# Set timezone
timedatectl set-timezone Asia/Seoul
timedatectl set-ntp true
timedatectl

# Update mirrorlist
update_mirrorlist(){
  curl -s "https://archlinux.org/mirrorlist/?country=KR&protocol=https&ip_version=4" -o /etc/pacman.d/mirrorlist
}

while true; do
  update_mirrorlist
  cat /etc/pacman.d/mirrorlist
  read -r -p "Do you want update mirrorlist? [Y/n]" confirm
  if [[ ! "$confirm" =~ ^(n|N) ]]; then
    break
  fi
done

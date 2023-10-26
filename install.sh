#!/usr/bin/bash
# print command before executing, and exit when any command fails
set -e

# Set timezone
clear
echo '# Set timezone'
timedatectl set-timezone Asia/Seoul
timedatectl set-ntp true
timedatectl

# Update mirrorlist
echo '# Update mirrorlist'

update_mirrorlist(){
  curl -sSL "https://archlinux.org/mirrorlist/?country=KR&protocol=https&ip_version=4" -o /etc/pacman.d/mirrorlist
  sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
}


read -r -p "Do you want update mirrorlist? [Y/n]" confirm
if [[ ! "$confirm" =~ ^(n|N) ]]; then
  update_mirrorlist
  cat /etc/pacman.d/mirrorlist
else
  break
fi


# Set env var
#clear
echo '# Set env var'

read -r -p "What's your ssd name? (ex: sda or nvme0n1) : " ssd_name

case $ssd_name in
  sd* | nvme*)
    ;;
  *)
    clear
    echo 'invalid ssd_name.'
    exit 
esac


# Exec fdisk
echo 'Enter the Fdisk...'
sudo fdisk /dev/$ssd_name


# Set Btrfs & Mount
echo '# Set Btrfs & Mount'

read -r -p "What's your root partition Number or Name? : " r_pt_name
read -r -p "What's your boot partition Number or Name? : " b_pt_name

if findmnt /dev/$ssd_name$r_pt_name >/dev/null 2>&1 ; then
  echo "already mount /dev/$ssd_name$r_pt_name"
  exit 1
else 
  echo 'Set btrfs filesystem...'
  echo 'Mounting root & boot & home...'

  mkfs.btrfs /dev/$ssd_name$r_pt_name
  mount /dev/$ssd_name$r_pt_name /mnt
  cd /mnt

  btrfs su cr @
  btrfs su cr @home
  cd ..

  umount /mnt
  mount -o rw,ssd,noatime,discard=async,compress=zstd,space_cache=v2,subvol=@ /dev/$ssd_name$r_pt_name /mnt

  mkdir /mnt/home /mnt/boot

  mount -o rw,ssd,noatime,discard=async,compress=zstd,space_cache=v2,subvol=@home /dev/$ssd_name$r_pt_name /mnt/home
  mount /dev/$ssd_name$b_pt_name /mnt/boot

  if [[ "$?" == "0" ]]; then
    echo 'Mount OK' 
  fi

# Install Base Package
  read -r -p "Install base Package? [Y/n]" confirm
  if [[ ! "$confirm" =~ ^(n|N) ]]; then
    pacstrap -K /mnt base base-devel linux linux-firmware sudo nano networkmanager
  fi

fi

# genfstab
if [[ "$?" == "0" ]]; then
  genfstab -U /mnt >> /mnt/etc/fstab
  nano /mnt/etc/fstab 
fi
  
# arch-chroot
if [[ "$?" == "0" ]]; then
  mkdir /mnt/arch
  cp -r ~/arch/* /mnt/arch
  chmod -x /mnt/arch/*
  arch-chroot /mnt sh /arch/setup.sh 
fi

if [[ "$?" == "0" ]]; then
  echo "Finished successfully."
  read -r -p "Reboot now? [Y/n]" confirm
  if [[ ! "$confirm" =~ ^(n|N) ]]; then
    reboot
  fi
fi

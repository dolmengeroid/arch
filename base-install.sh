#!/bin/bash
# set env var
ssd_name="sda"
root_partition_num="7"
boot_partition_num="1"

# set timezone
timedatectl set-timezone Asia/Seoul
timedatectl set-ntp true
timedatectl

# mount
fdisk /dev/${ssd_name}
mkfs.btrfs /dev/${ssd_name}${root_partition_num}


mount /dev/${ssd_name}${root_partition_num} /mnt
cd /mnt

btrfs su cr @
btrfs su cr @home
cd ..

umount /mnt
mount -o rw,ssd,noatime,discard=async,compress=zstd,space_cache=v2,subvol=@ /dev/${ssd_name}${root_partition_num} /mnt

mkdir /mnt/home
mkdir /mnt/boot

mount -o rw,ssd,noatime,discard=async,compress=zstd,space_cache=v2,subvol=@home /dev/${ssd_name}${root_partition_num} /mnt/home

mount /dev/${ssd_name}${boot_partition_num} /mnt/boot

pacstrap -K /mnt base linux linux-firmware sudo nano networkmanager

genfstab -U /mnt >> /mnt/etc/fstab
nano /mnt/etc/fstab

mkdir /mnt/arch
echo "Type 'cp arch/* /mnt/arch'"
echo "Then type 'arch-chroot /mnt'"

#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc

nano /etc/locale.gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf

echo archlinux >> /etc/hostname

nano /etc/hosts

passwd
useradd -m -G wheel dalt
passwd dalt
EDITOR=nano visudo

systemctl enable NetworkManager.service

pacman -S intel-ucode os-prober grub efibootmgr pulseaudio sof-firmware

nano /usr/bin/grub-mkconfig
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=archlinux

grub-mkconfig -o /boot/grub/grub.cfg




echo "Now, type 'exit'"
echo "Then 'unoumt -R /mnt'"
echo "Then 'reboot'"
echo "And type next, when after reboot."
echo "#LC_ALL=C grub-mkconfig -o /boot/grub/grub.cfg"

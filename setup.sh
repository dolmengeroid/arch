#!/usr/bin/bash
# print command before executing, and exit when any command fails
set -e

# Set timezone
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc

# Set Locale
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sed -i 's/^#ko_KR.UTF-8/ko_KR.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set Hostname
echo archlinux >> /etc/hostname

# Set Hosts
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarchlinux" >> /etc/hosts

# Set root password
echo '# Set root password'
passwd

# Add User account
echo '# Add User account'
useradd -m -G wheel -s /bin/bash dalt
passwd dalt

# Config sudo
# allow users of group wheel to use sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Install Added Package
pacman -S intel-ucode os-prober grub efibootmgr pulseaudio sof-firmware 

# Boot 
sed -i 's/^GRUB_DISABLE_OS_PROBER="true"/GRUB_DISABLE_OS_PROBER=false/' /usr/bin/grub-mkconfig
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=archlinux

grub-mkconfig -o /boot/grub/grub.cfg


# graphics driver
read -r -p "Install VGA Driver? [Y/n]" confirm
if [[ ! "$confirm" =~ ^(n|N) ]]; then

  nvidia=$(lspci | grep -e VGA -e 3D | grep 'NVIDIA' 2> /dev/null || echo '')
  amd=$(lspci | grep -e VGA -e 3D | grep 'AMD' 2> /dev/null || echo '')
  intel=$(lspci | grep -e VGA -e 3D | grep 'Intel' 2> /dev/null || echo '')
  if [[ -n "$nvidia" ]]; then
    pacman -S --noconfirm nvidia
  fi

  if [[ -n "$amd" ]]; then
    pacman -S --noconfirm xf86-video-amdgpu
  fi

  if [[ -n "$intel" ]]; then
    pacman -S --noconfirm xf86-video-intel
  fi

  if [[ -n "$nvidia" && -n "$intel" ]]; then
    pacman -S --noconfirm bumblebee
    gpasswd -a $username bumblebee
    systemctl enable bumblebeed
  fi
fi

# gnome
read -r -p "Install GNOME? [Y/n]" confirm
if [[ ! "$confirm" =~ ^(n|N) ]]; then
  pacman -S --noconfirm gdm gnome-shell gnome-shell-extensions gnome-keyring seahorse gnome-backgrounds \
  gnome-control-center gnome-font-viewer xdg-user-dirs-gtk \
  gnome-power-manager gnome-system-monitor gnome-terminal nautilus gvfs-mtp eog evince \
  file-roller gnome-tweaks

# start gnome by default
  systemctl enable gdm
fi

# KDE
read -r -p "Install KDE Plasma? [Y/n]" confirm
if [[ ! "$confirm" =~ ^(n|N) ]]; then
  pacman -S --noconfirm --needed plasma dolphin konsole ark

# start kde by default
  systemctl enable sddm
fi

# install common package
  pacman -S --noconfirm --needed firefox timeshift btrfs-progs bluez ibus-hangul

# start ibus daemon
echo -e "\n# ibus daemon\nexport GTK_IM_MODULE=ibus\nexport XMODIFIERS=@im=ibus\nexport QT_IM_MODULE=ibus\n\nibus-daemon -drx" >> ~/.bashrc


# default service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service


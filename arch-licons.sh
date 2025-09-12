#!/bin/bash
set -e

echo "==> Thiết lập timezone"
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
timedatectl set-timezone Asia/Ho_Chi_Minh
timedatectl set-ntp true

echo "==> Cấu hình locale"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "==> Hostname"
echo "seiza" > /etc/hostname
if ! grep -q "127.0.0.1 seiza.localdomain seiza" /etc/hosts; then
    echo "127.0.0.1 seiza.localdomain seiza" >> /etc/hosts
fi

echo "==> Đặt mật khẩu root"
passwd

useradd -mG wheel licons
echo "==> Đặt mật khẩu cho user: licons"
passwd licons

echo "==> Mở file sudoers để bỏ comment các dòng liên quan đến wheel"
EDITOR=nano visudo

echo "==> Mở /etc/pacman.conf để bỏ comment [multilib] và Include"
nano /etc/pacman.conf

# Update pacman
pacman -Syu --noconfirm pacman

echo "==> Mở /etc/mkinitcpio.d/linux.preset"
echo "===> Chỉnh PRESETS=('default')"
echo "===> #fallback"
nano /etc/mkinitcpio.d/linux.preset
rm -f /boot/initramfs-linux-fallback.img
mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# Cài theme cho grub
cd /tmp
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -t tela
cd /

# Cấu hình grub
echo "==> Mở /etc/default/grub và chỉnh lại:"
echo "GRUB_DEFAULT=saved"
echo "GRUB_TIMEOUT=2"
echo "GRUB_DISABLE_OS_PROBER=false"
echo "GRUB_DISABLE_SUBMENU=y"
echo "GRUB_DISABLE_RECOVERY=true"
nano /etc/default/grub

chmod -x /etc/grub.d/30_uefi-firmware
grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Hoàn tất cấu hình cơ bản!"


echo "==> Cài driver NVIDIA"
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf
echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf

### ==== Cinnamon ====
echo "==> Cài Cinnamon và các apps"
pacman -S --noconfirm \
    cinnamon \
    nemo-fileroller nemo-terminal \
    gnome-terminal \
    gnome-screenshot \
    gnome-system-monitor \
    gnome-calculator \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-slick-greeter \
    bluez bluez-utils blueberry \
    pipewire pipewire-pulse pipewire-alsa \
    wireplumber \
    powerdevil \
    power-profiles-daemon \
    ufw gufw \
    kate konsole gwenview \
    fastfetch fish \
    fcitx5-im fcitx5-configtool fcitx5-unikey \
    ttf-roboto ttf-dejavu \
    ttf-liberation ttf-jetbrains-mono \
    noto-fonts \
    docker docker-compose

systemctl enable NetworkManager
systemctl enable lightdm
systemctl enable bluetooth
systemctl enable ufw
systemctl enable systemd-timesyncd
systemctl enable docker

echo "==> Hoàn tất cài đặt!"

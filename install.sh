#!/bin/bash

set -e

# Cập nhật hệ thống
yay -Syu --noconfirm

# Cài các phần mềm khác
yay -S --noconfirm \
  lightdm-settings \
  tela-circle-icon-theme \
  zen-browser-bin \
  nodejs npm jdk-openjdk \
  onedrive onedrivegui \
  vlc \
  libreoffice-fresh \
  teams-for-linux \
  rider \
  dbeaver \
  postman-bin \
  appimagelauncher

echo "==> Cấu hình fcitx5 trong ~/.xprofile"

if ! grep -q "GTK_IM_MODULE=fcitx" ~/.xprofile 2>/dev/null; then
cat << 'EOF' >> ~/.xprofile

# Fcitx5 input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export INPUT_METHOD=fcitx
EOF
fi

echo "Hoàn tất cài đặt!"

#!/bin/bash

set -ouex pipefail

### Install packages
# this activate some repo, first the free and non-free rpmfusion, 
# RPM FUSION
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# this installs a package from fedora repos
LACT=$(curl -s https://api.github.com/repos/ilya-zlobintsev/LACT/releases/latest | grep -oP 'https://github\.com/ilya-zlobintsev/LACT/releases/download/[^"]*lact-headless[^"]*fedora-43\.rpm' | head -n 1)

PACKAGES=(
  mpv
  git
  zsh
  nemo
  btop
  gvfs
  unrar
  unzip
  kitty
  steam
  lutris
  discord
  wlogout
  udisks2
  nwg-look
  gvfs-mtp
  gvfs-smb
  fastfetch
  distrobox
  cabextract
  file-roller
  glib2-devel
  vulkan-tools
  nemo-preview
  smartmontools
  systemd-devel
  nemo-fileroller
  fira-code-fonts
  pocillo-gtk-theme
  libappindicator-gtk3
  cascadia-code-nf-fonts
  google-noto-sans-fonts
  SwayNotificationCenter
  google-noto-serif-fonts
  google-noto-emoji-fonts
  impallari-raleway-fonts
  zsh-syntax-highlighting
  folder-color-switcher-nemo
  SwayNotificationCenter-zsh-completion
)
BUILD_PACKAGES=(
  zig
  #pkgconf
  meson
  ninja
  gcc
  make
)
RM_PACKAGES=(
  foot
  bluez
  cups
  ModemManager
  tuned
  xarchiver
)
CODECS=(
  gstreamer1-plugins-base
  gstreamer1-plugins-good
  gstreamer1-plugins-bad-free
  gstreamer1-plugins-bad-freeworld
  gstreamer1-plugins-ugly
  gstreamer1-libav
  mozilla-openh264
  libavcodec-freeworld
  lame
)
dnf5 remove -y "${RM_PACKAGES[@]}"
dnf5 install --setopt=install_weak_deps=False --skip-unavailable -y \
  "${PACKAGES[@]}" \
  "${CODECS[@]}" \
  "$LACT"
dnf5 install --setopt=install_weak_deps=False --setopt=tsflags=nodocs -y "${BUILD_PACKAGES[@]}"
# build Falcond
git clone https://git.pika-os.com/general-packages/falcond.git /tmp/
cd /tmp/falcond
install -d -m 765 /opt/falcond/conf.d && install -d -m 765 /run/falcond
install -d -m 765 /tmp/zig-cache
export ZIG_CACHE_DIR=/tmp/zig-cache
zig build -Doptimize=ReleaseFast \
          -Dconfig-path=/opt/falcond/config.conf \
          -Dstatus-file=/run/falcond/status \
          -Duser-profiles-dir=/opt/falcond/conf.d

install -m 755 ./zig-out/bin/falcond /usr/bin/falcond
#install -d -m 765 /usr/local/bin
#cp ./zig-out/bin/falcond /usr/local/bin/falcond
cd /
rm -rf /tmp/falcond

# for a lightweight image
dnf5 remove -y "${BUILD_PACKAGES[@]}"

# FLATHUB
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak -y install flathub md.obsidian.Obsidian com.ranfdev.DistroShelf io.github.kolunmi.Bazaar
# Use a COPR Example:
#dnf5 copr enable scottames/vicinae
#dnf5 install --skip-unavailable vicinae
# Disable COPRs so they don't end up enabled on the final image:
#dnf5 -y copr disable scottames/vicinae

### ICON THEME ARASHI + FONTS
git clone --depth=1 https://github.com/0hStormy/Arashi /tmp/Arashi
mkdir -p /usr/share/icons
cp -r /tmp/Arashi /usr/share/icons/Arashi && rm -rf /tmp/Arashi

# Clean dnf
dnf5 clean all
dnf5 autoremove -y

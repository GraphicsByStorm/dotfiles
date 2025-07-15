#!/bin/bash

echo "[START]: general-packages installation..."

# Check if Aura is installed
if ! command -v aura &> /dev/null; then
  echo "[INFO]: Aura not found. Installing aura-bin from AUR..."
  mkdir -p "$HOME/Downloads/git-downloads"
  git clone https://aur.archlinux.org/aura-bin.git "$HOME/Downloads/git-downloads/aura-bin"
  cd "$HOME/Downloads/git-downloads/aura-bin" || exit 1
  makepkg -si --noconfirm || {
    echo "[ERROR]: Failed to install aura-bin"
    exit 1
  }
  cd - || exit 1
fi

# Update system
sudo aura -Syu

# Define safe, current package list
PKGS=(
  base bash binutils bison coreutils diffutils file findutils gawk gcc
  gettext grep gzip inetutils less licenses make pacman patch sed sudo
  systemd tar texinfo util-linux which

  cmake git ninja meson pkgconf gdb clang rustup go valgrind

  ffmpeg imagemagick inkscape gimp vlc

  openssh wget curl networkmanager iproute2 net-tools nfs-utils smbclient

  xorg-server xorg-xinit xorg-xrandr xterm xorg-xsetroot xorg-xprop xorg-xrdb
  xf86-input-libinput mesa qt5-base gtk3 gtk4 gnome-keyring gnome-disk-utility
  gnome-font-viewer gvfs gvfs-afc gvfs-mtp gvfs-smb gparted
  gsettings-desktop-schemas

  alacritty kitty zsh zsh-autosuggestions

  htop neovim unzip p7zip lsof tree man-db man-pages tldr smartmontools
  parted gnome-system-monitor gnome-control-center polkit

  pipewire pipewire-pulse pulseaudio pavucontrol

  ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji cantarell-fonts
  hicolor-icon-theme adwaita-icon-theme gnome-themes-extra

  lxappearance nitrogen dmenu rofi feh screenfetch scrot
)

# Install packages using aura
aura -S --needed --noconfirm "${PKGS[@]}" || {
  echo "[ERROR]: Failed installing pacman packages."
  exit 1
}

# ranger icons:
devicons_dir=$HOME/.config/ranger/plugins/ranger_devicons
[ -d $devicons_dir ] && rm -rf $devicons_dir
git clone https://github.com/alexanderjeurissen/ranger_devicons $devicons_dir

echo "[FINISHED]: general-packages installation"

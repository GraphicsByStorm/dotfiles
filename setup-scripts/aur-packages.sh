#!/bin/bash

echo "[START]: AUR/external packages installation..."

# Import keys
./.scripts/addkey.sh $(grep -v '#' ./setup-scripts/resources/keys)

# Output packages directory creation
mkdir -p "$HOME/Downloads/git-downloads"

# Check if Aura is installed
if ! command -v aura &> /dev/null; then
  echo "[INFO]: Aura not found. Installing aura-bin from AUR..."
  git clone https://aur.archlinux.org/aura-bin.git "$HOME/Downloads/git-downloads/aura-bin"
  cd "$HOME/Downloads/git-downloads/aura-bin" || exit 1
  makepkg -si --noconfirm || {
    echo "[ERROR]: Failed to install aura-bin"
    exit 1
  }
  cd - || exit 1
fi

# Update AUR package database
sudo aura -Sy

# Safe, validated AUR packages
AUR_PKGS=(
  arc-icon-theme celt electron13 libsidplay libvisual metis neofetch nomacs
  python-progress udevil vbam-wx wxgtk2 wxgtk3 wxgtk-common
  zsh-theme-powerlevel10k
)

# Install AUR packages
aura -A --needed --noconfirm "${AUR_PKGS[@]}" || {
  echo "[ERROR]: Failed installing AUR packages."
  exit 1
}

# Extra AUR packages not in list
aura -A --needed --noconfirm wmutils-git ueberzug

# Python requirement
pip install --break-system-packages dbus-python

# Spotify fix (if using Spicetify)
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

echo "[FINISHED]: AUR/external packages installation"

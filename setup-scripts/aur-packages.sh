#!/bin/bash

echo "[START]: AUR/external packages installation..."

# Import keys
./.scripts/addkey.sh $(grep -v '#' ./setup-scripts/resources/keys)

# Ensure base-devel and git are present (required for AUR building)
sudo pacman -S --needed base-devel git --noconfirm

# Install aura-bin manually if aura is not installed
if ! command -v aura &> /dev/null; then
  echo "[INFO]: Aura not found. Bootstrapping aura-bin from AUR..."
  git clone https://aur.archlinux.org/aura-bin.git /tmp/aura-bin
  cd /tmp/aura-bin
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/aura-bin
fi

# Create output packages directory
mkdir -p "$HOME/Downloads/git-downloads"

# Sync packages
sudo aura -Sy

# Install AUR packages from list
aura -A --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/aur-packages) || {
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

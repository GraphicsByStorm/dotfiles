#!/bin/bash

echo "[START]: combined packages installation..."

# Import keys (if any)
[ -f ./setup-scripts/resources/keys ] && ./setup-scripts/addkey.sh $(grep -v '#' ./setup-scripts/resources/keys)

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

# Update system
sudo aura -Syu

# Install pacman packages
if [ -f ./setup-scripts/resources/pacman-packages ]; then
  echo "[INFO]: Installing pacman packages..."
  aura -S --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/pacman-packages) || {
    echo "[ERROR]: Failed installing pacman packages."
    exit 1
  }
fi

# Install AUR packages
if [ -f ./setup-scripts/resources/aur-packages ]; then
  echo "[INFO]: Installing AUR packages..."
  aura -A --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/aur-packages) || {
    echo "[ERROR]: Failed installing AUR packages."
    exit 1
  }
fi

# Extra AUR packages (if not listed)
aura -A --needed --noconfirm wmutils-git ueberzug

# Python requirement
pip install --break-system-packages dbus-python

# Spotify fix (if using Spicetify)
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

echo "[FINISHED]: combined packages installation"

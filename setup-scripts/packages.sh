#!/bin/bash

echo "[START]: combined packages installation..."

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

# Update system
sudo aura -Sy

# Install packages from packages.txt
aura -A --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/packages.txt) || {
  echo "[ERROR]: Failed installing packages from packages.txt."
  exit 1
}

# Python requirement
pip install --break-system-packages dbus-python

# Spotify fix (if using Spicetify)
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

echo "[FINISHED]: combined packages installation"

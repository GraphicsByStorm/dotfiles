#!/bin/bash

echo "[START]: AUR/external packages installation..."

# Import keys
./.scripts/addkey.sh $(grep -v '#' ./setup-scripts/resources/keys)

# Output packages directory creation
mkdir -p "$HOME/Downloads/git-downloads"

# Update system
sudo aura -Sy

# Install AUR packages
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
#!/bin/bash

echo "[START]: Combined packages installation..."

# Import keys
./.scripts/addkey.sh $(grep -v '#' ./setup-scripts/resources/keys)

# Output packages directory creation
mkdir -p "$HOME/Downloads/git-downloads"

# Update
sudo aura -Syu --noconfirm

# Manual split between official and AUR required here (not ideal)
# This assumes you fixed packages.txt to contain only AUR-compatible items
aura -A --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/packages.txt)

# Python requirement
pip install --break-system-packages dbus-python

# Spotify fix
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

echo "[FINISHED]: Combined packages installation"

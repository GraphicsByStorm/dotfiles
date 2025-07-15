#!/bin/bash

echo "[START]: General packages installation..."

# Full system upgrade
sudo aura -Syu --noconfirm

# Install official repo packages
sudo aura -S --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/pacman-packages) || {
  echo "[ERROR]: Failed installing pacman packages."
  exit 1
}

# Ranger icons plugin
devicons_dir="$HOME/.config/ranger/plugins/ranger_devicons"
rm -rf "$devicons_dir"
git clone https://github.com/alexanderjeurissen/ranger_devicons "$devicons_dir"

echo "[FINISHED]: General packages installation"

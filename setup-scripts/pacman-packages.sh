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

# Install pacman packages
aura -S --needed --noconfirm $(grep -v '#' ./setup-scripts/resources/pacman-packages) || {
  echo "[ERROR]: Failed installing pacman packages."
  exit 1
}

# ranger icons:
devicons_dir=$HOME/.config/ranger/plugins/ranger_devicons
[ -d $devicons_dir ] && rm -rf $devicons_dir
git clone https://github.com/alexanderjeurissen/ranger_devicons $devicons_dir

echo "[FINISHED]: general-packages installation"

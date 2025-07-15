#!/bin/bash

echo "[START]: Display Manager (TTY1 Autologin) installation..."

# Set target path
override_dir="/etc/systemd/system/getty@tty1.service.d"
override_file="override.conf"

# Create directory if not present
sudo mkdir -p "$override_dir"

# Copy override file
if sudo cp "./getty-dm/$override_file" "$override_dir/$override_file"; then
    echo "[INFO]: override.conf copied successfully."
else
    echo "[ERROR]: Failed to copy override.conf"
    exit 1
fi

# Replace 'zodd' with current username
sudo sed -i "s/zodd/$(whoami)/g" "$override_dir/$override_file"

echo "[FINISHED]: Display Manager installation"

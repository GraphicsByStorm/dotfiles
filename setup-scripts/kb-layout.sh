#!/bin/bash

echo -n "Select your keyboard layout (e.g. us): "
read -r layout

if [ -z "$layout" ]; then
  echo "[ERROR]: No input provided. Exiting."
  exit 1
fi

if ! setxkbmap "$layout"; then
  echo "[ERROR]: Invalid keyboard layout '$layout'."
  exit 1
fi

echo "[INFO]: Selected keyboard layout: $layout"

# Copy and update .xinitrc
cp ./shared-config/.xinitrc "$HOME/.xinitrc"
sed -i "s/setxkbmap es/setxkbmap $layout/g" "$HOME/.xinitrc"

#!/bin/bash

replace_user="zodd"

echo "[INFO]: Copying themes, icons, fonts, and scripts..."
notify-send -i ./setup-scripts/resources/white-brush.png "[INFO]: Copying themes, icons, fonts, and scripts..." &

# Append to /etc/environment only if values aren't already present
if ! grep -qF "$(cat ./environment)" /etc/environment 2>/dev/null; then
  echo "[INFO]: Updating /etc/environment..."
  sudo tee -a /etc/environment < ./environment >/dev/null
fi

# Create screenshots directory if missing
mkdir -p "$HOME/Pictures/Screenshots"

echo "[INFO]: Copying wallpapers..."
cp -r ./.wallpapers "$HOME"

echo "[INFO]: Copying scripts..."
cp -r ./.scripts "$HOME"

echo "[INFO]: Copying fonts..."
cp -r ./.fonts "$HOME"

echo "[INFO]: Copying themes..."
cp -r ./.themes "$HOME"

echo "[INFO]: Copying icons..."
cp -r ./.icons "$HOME"

echo "[INFO]: Copying shared configuration files..."
cp -rv ./shared-config/. "$HOME"

# Install plugins for Neovim
echo "[INFO]: Installing Neovim plugins..."
nvim -E -s -u "$HOME/.config/nvim/init.vim" +PlugInstall +qall

# Install coc.nvim dependencies if available
if [ -d "$HOME/.config/nvim/plugged/coc.nvim" ]; then
  echo "[INFO]: Installing coc.nvim..."
  cd "$HOME/.config/nvim/plugged/coc.nvim" && npm i && cd -
fi

# Ranger devicons plugin
echo "[INFO]: Installing Ranger devicons..."
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons 2>/dev/null

# Replace placeholder user with current user
sed -i "s/$replace_user/$USER/g" "$HOME/.zshrc" "$HOME/.config/sxhkd/sxhkdrc"*

# Ensure custom autostart exists
autostart_script="$HOME/.scripts/custom-autostart"
if [ ! -f "$autostart_script" ]; then
  echo '#!/bin/bash' > "$autostart_script"
  chmod +x "$autostart_script"
fi

# Set default sxhkd config
cp "$HOME/.config/sxhkd/sxhkdrc.bspwm" "$HOME/.config/sxhkd/sxhkdrc"

# Set ZSH as default shell if not already
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "[INFO]: Changing default shell to Zsh..."
  chsh -s /usr/bin/zsh
fi

# Ask user to set keyboard layout
./setup-scripts/kb-layout.sh

echo "[FINISHED]: Theme, fonts, icons, and script configuration complete."

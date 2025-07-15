#!/bin/bash

SETUP_ROOT="$(dirname "$(readlink -f "$0")")/.."
beautifuldiscord_theme="custom-discord-theme.css"
theme_css_path="$HOME/.config/discord/rices/$beautifuldiscord_theme"

echo
echo "[INFO]: Applying BeautifulDiscord theme..."
notify-send -i "$SETUP_ROOT/setup-scripts/resources/white-brush.png" \
  "[INFO]: Applying BeautifulDiscord theme..."

# Start Discord if not running
if ! pgrep -x discord > /dev/null; then
    discord &>/dev/null &
    sleep 5
fi

# Apply BeautifulDiscord theme
if command -v python &>/dev/null; then
    python -m beautifuldiscord --revert
    sleep 3

    if [ -f "$theme_css_path" ]; then
        python -m beautifuldiscord --css "$theme_css_path"
        sleep 3
    else
        echo "[ERROR]: Theme file not found at $theme_css_path"
        notify-send -i "$SETUP_ROOT/setup-scripts/resources/white-brush.png" \
          "[ERROR]: Theme file not found: $beautifuldiscord_theme"
        exit 1
    fi

    killall discord
else
    echo "[ERROR]: Python is not installed or not in PATH."
    exit 1
fi

# Optional: Switch back to first bspwm desktop
if command -v bspc &>/dev/null; then
    bspc desktop -f '^1' --follow
fi

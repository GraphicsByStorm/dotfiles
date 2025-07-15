#!/bin/bash

SETUP_ROOT="$(dirname "$(readlink -f "$0")")/.."

function set_theme {
    local spicetify_theme="$1"

    echo "[INFO]: Applying \"$spicetify_theme\" Spicetify theme..."
    notify-send -i "$SETUP_ROOT/setup-scripts/resources/white-brush.png" \
      "[INFO]: Applying \"$spicetify_theme\" Spicetify theme..."

    if command -v spicetify &>/dev/null; then
        spicetify config current_theme "$spicetify_theme"
        spicetify apply
    elif [ -x "$HOME/spicetify-cli/spicetify" ]; then
        "$HOME/spicetify-cli/spicetify" config current_theme "$spicetify_theme"
        "$HOME/spicetify-cli/spicetify" apply
    else
        echo "[ERROR]: Spicetify is not installed or not in the expected location."
        exit 1
    fi
}

# Argument-based override
if [ -n "$1" ]; then
    set_theme "$1"
    exit 0
fi

# Fallback to config-based detection
if [ ! -f "$HOME/.config/current_theme" ]; then
    echo "[ERROR]: Theme config not found: ~/.config/current_theme"
    exit 1
fi

current_theme="$(<"$HOME/.config/current_theme")"

shopt -s nocasematch
case "$current_theme" in
    "gruvbox" )         set_theme "Gruvbox-Gold" ;;
    "solarized-dark" )  set_theme "SolarizedDark" ;;
    "pink-nord" )       set_theme "Nord" ;;
    # "nord" )          set_theme "Nord" ;;
    * )
        echo "[ERROR]: No Spicetify theme mapping for \"$current_theme\""
        notify-send -i "$SETUP_ROOT/setup-scripts/resources/white-brush.png" \
          "[ERROR]: No Spicetify theme mapping for \"$current_theme\""
        exit 1
    ;;
esac

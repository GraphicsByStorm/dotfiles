#!/bin/bash

# Set working root
DOTFILES="${DOTFILES:-$HOME/dotfiles}"

function update() {
    local pacman_arg=$1
    local output_file=$2
    local output_path="$DOTFILES/setup-scripts/resources/$output_file"

    local EXCLUDE='(systemd|^themix|nativefier|^resvg|discord|spotify|skype|virtualbox|dropbox|etcher-bin|chromium|libsoup3|telegram|code)'

    echo "[INFO]: Updating package list -> $output_file"
    sudo pacman -"$pacman_arg" | grep -Ev "$EXCLUDE" | awk '{print $1}' > "$output_path"

    if [ $? -eq 0 ]; then
        echo "[SUCCESS]: Wrote to $output_path"
    else
        echo "[ERROR]: Failed writing to $output_path"
    fi
}

arg="$1"

case "$arg" in
    aur)
        update 'Qm' 'aur-packages'
        ;;
    pacman)
        update 'Qn' 'pacman-packages'
        ;;
    all)
        update 'Qm' 'aur-packages'
        update 'Qn' 'pacman-packages'
        ;;
    *)
        echo "[ERROR]: Invalid option \"$arg\""
        echo "Usage: $0 [aur|pacman|all]"
        exit 1
        ;;
esac

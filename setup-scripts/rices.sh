#!/bin/bash

echo "[START]: theme installation..."

SETUP_ROOT="$(dirname "$PWD")"
arg=$1
copy_icons_and_themes=$2
echo "SETUP_ROOT: $SETUP_ROOT"

function setup_config {
    replace_user="zodd"
    config_name=$1

    # Download rice if the config directory is empty
    if [ -z "$(ls -A "./rices/$config_name" 2>/dev/null | grep -v -w '^\.')" ]; then
        ./setup-scripts/download-rice.sh "$config_name"
    fi

    # Backup of existing shell config files
    [ -f "$HOME/.xinitrc" ] && cp "$HOME/.xinitrc" "$HOME/.xinitrc-backup"
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc-backup"
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc-backup"

    nohup notify-send -i "$SETUP_ROOT/dotfiles/setup-scripts/resources/white-brush.png" \
        "[INFO]: copying \"$config_name\" config files..." &

    echo
    echo "[INFO]: applying \"$config_name\" theme..."

    # Neofetch config
    cp ./shared-config/.config/neofetch/config.conf "$HOME/.config/neofetch" 2>/dev/null

    # Clean additional zsh plugins if exists
    rm -rf "$HOME/.oh-my-zsh/additional/"* 2>/dev/null

    # Gedit config
    if [ -f "$HOME/.config/gedit-dump.dconf" ]; then
        dconf load /org/gnome/gedit/ < "$HOME/.config/gedit-dump.dconf"
    fi

    # Remove old Firefox userChrome.css if present
    firefox_profile=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default-release*" | head -n 1)
    if [ -f "$firefox_profile/chrome/userChrome.css" ]; then
        rm "$firefox_profile/chrome/userChrome.css"
    fi

    # Sync polybar scripts
    rsync -ravu ./shared-config/.config/polybar/scripts/rofi-poweroff.sh \
                ./shared-config/.config/polybar/scripts/theme-swap.sh \
                "$HOME/.config/polybar/scripts" 2>/dev/null

    # Sync dotfiles (excluding icons/themes/wallpapers)
    rsync -rav --exclude "*git*" --exclude ".icons" --exclude ".themes" --exclude ".wallpapers" \
        "$SETUP_ROOT/dotfiles/rices/$config_name/." "$HOME"

    # Copy optional resources
    for dir in ".icons" ".themes" ".wallpapers"; do
        [ -d "./rices/$config_name/$dir" ] && rsync -ravu "./rices/$config_name/$dir" "$HOME"
    done

    # Update Nitrogen config user path
    nitrogen_cfg="$HOME/.config/nitrogen/bg-saved.cfg"
    [ -f "$nitrogen_cfg" ] && sed -i "s/$replace_user/$USER/g" "$nitrogen_cfg"

    # Install NVIM plugins
    if command -v nvim &>/dev/null && [ -f "$HOME/.config/nvim/init.vim" ]; then
        nvim -E -s -u "$HOME/.config/nvim/init.vim" +PlugInstall +qall
    fi

    # Cleanup README if copied
    [ -f "$HOME/README.md" ] && rm "$HOME/README.md"

    echo "[FINISHED]: theme installation"
    exit 0
}

shopt -s nocasematch
case "$arg" in 
    "gruvbox" ) setup_config "Gruvbox" ;; 
    "gruvbox-material" ) setup_config "GruvboxMaterial" ;; 
    "solarized-dark" ) setup_config "SolarizedDark" ;; 
    "pink-nord-alternative" ) setup_config "PinkNordAlternative" ;; 
    "pink-nord" ) setup_config "PinkNord" ;; 
    "horizon" ) setup_config "Horizon" ;; 
    "bw" ) setup_config "BW" ;; 
    "ayu" ) setup_config "Ayu" ;; 
    "nord" ) setup_config "Nord" ;; 
    "doombox" ) setup_config "Doombox" ;; 
    "forest" ) setup_config "Forest" ;; 
    "dracula" ) setup_config "Dracula" ;; 
    * ) 
        echo "[ERROR]: no config with name \"$arg\" found"
        notify-send -i "$SETUP_ROOT/dotfiles/setup-scripts/resources/white-brush.png" "[ERROR]: Selected theme does not exist" &
        ;;
esac

exit 1

#!/bin/bash

set -e  # Exit on error

option=$1
theme=$2

shopt -s nocasematch
case "$option" in
    "all" )
        ./setup-scripts/pacman-packages.sh
        ./setup-scripts/aur-packages.sh
        ./setup-scripts/themes.sh
        ./setup-scripts/rices.sh "$theme"
        ;;
    "packages" )
        ./setup-scripts/pacman-packages.sh
        ./setup-scripts/aur-packages.sh
        ;;
    "themes" )
        ./setup-scripts/themes.sh
        ;;
    "rice" )
        ./setup-scripts/rices.sh "$theme"
        ;;
    *)
        echo "[ERROR]: No install flag with name \"$option\" found"
        exit 1
        ;;
esac

#!/usr/bin/env bash
# ============================================================
#  Theme Downloader & Updater
#  Run this script to download or update the GRUB theme repos.
# ============================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"

mkdir -p "$THEMES_DIR"

declare -A REPOS=(
    ["darkmatter"]="https://github.com/VandalByte/darkmatter-grub2-theme.git"
    ["elegant"]="https://github.com/vinceliuice/Elegant-grub2-themes.git"
    ["sleek"]="https://github.com/sandesh236/sleek--themes.git"
    ["grub2-themes"]="https://github.com/vinceliuice/grub2-themes.git"
    ["catppuccin"]="https://github.com/catppuccin/grub.git"
    ["Gorgeous-GRUB-reference"]="https://github.com/Jacksaur/Gorgeous-GRUB.git"
)

echo "Checking and updating theme repositories in $THEMES_DIR..."

for folder in "${!REPOS[@]}"; do
    url="${REPOS[$folder]}"
    dest="$THEMES_DIR/$folder"
    
    if [[ -d "$dest/.git" ]]; then
        echo "Updating $folder..."
        git -C "$dest" pull --quiet
    else
        echo "Downloading $folder..."
        git clone --depth=1 "$url" "$dest"
    fi
done

echo ""
echo "All repositories are up to date!"
echo "Check the README.md for instructions on how to use each theme's installer."

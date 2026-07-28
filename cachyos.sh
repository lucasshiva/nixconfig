#!/usr/bin/env bash
set -euo pipefail

# Packages required for a functional system.
packages=(
    "visual-studio-code-bin" # Text editor
    "zed" # Super fast text editor
    "jetbrains-toolbox" # JetBrains IDEs
    "nautilus" # For GNOME portals, file choosers, etc.
    "niri" # Window manager
    "noctalia" # Shell for Wayland window managers
    "neovim" # Terminal text editor
    "micro" # Terminal text editor with mouse support.
    "keepassxc" # Password manager
    "obsidian" # Note app
    "firefox" # Browser for personal stuff
    "firefox-developer-edition" # Browser for work/dev stuff
    "fooyin" # Music player
)

# Ensure yay is installed
sudo pacman -S --needed --noconfirm yay

# Expand the array to install everything in a single command.
yay -S --needed --noconfirm "${packages[@]}"

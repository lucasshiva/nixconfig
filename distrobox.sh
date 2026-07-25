#!/usr/bin/env bash
set -euo pipefail

install_vscode() {
    yay -S --noconfirm --needed visual-studio-code-bin
    distrobox-export --bin $(which code)
    distrobox-export --app code
}

install_jetbrains_toolbox() {
    yay -S --noconfirm --needed jetbrains-toolbox
}

install_vscode
install_jetbrains_toolbox

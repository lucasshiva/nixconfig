#!/usr/bin/env bash
set -euo pipefail

# --- Defaults for my setup, can be overriden from the command line ---
FORCE=false
KP_DATABASE_FILE="/mnt/data/Apps/KeePass/Passwords.kdbx"
KP_KEY_FILE="/mnt/data/Documents/keepass/kp-keyfile.keyx"
KP_ENTRY="id_ed25519"
KP_ENTRY_ATTRIBUTE="PRIVATE_KEY"
TARGET_USER="${USER}"
TARGET_HOST="${HOSTNAME:-$(hostname)}"

readonly SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"
readonly SSH_PUB_KEY_PATH="${SSH_KEY_PATH}.pub"

readonly AGE_KEY_DIR="${HOME}/.config/sops/age"
readonly AGE_KEY_PATH="${AGE_KEY_DIR}/keys.txt"

# --- Colors ---
readonly C_RESET='\033[0m'
readonly C_GREEN='\033[0;32m'
readonly C_YELLOW='\033[0;33m'
readonly C_RED='\033[0;31m'
readonly C_BLUE='\033[0;34m'

readonly SCRIPT_NAME="$(basename "$0")"

info()  { echo -e "${C_BLUE}[INFO]${C_RESET} $*"; }
ok()    { echo -e "${C_GREEN}[ OK ]${C_RESET} $*"; }
warn()  { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
err()   { echo -e "${C_RED}[FAIL]${C_RESET} $*" >&2; }

print_help() {
    cat <<EOF
${SCRIPT_NAME} - Bootstrap Nix and Secrets on Arch or NixOS.

USAGE:
    ${SCRIPT_NAME} [OPTIONS]


OPTIONS:
    -f, --force                     Replace existing files (SSH key, age key) if present
    -d, --db_file PATH              Path to the KeePass database file (default: ${KP_DATABASE_FILE})
    -k, --key_file [PATH|None]      Path to the KeePass keyfile, if used (default: none)
    -e, --entry NAME                Name of the KeePass entry holding the SSH key (default: ${KP_ENTRY})
    -a, --attribute NAME            Name of the attribute holding the private key (default: ${KP_ENTRY_ATTRIBUTE})
        --user NAME                 Target username for home-manager (default: ${TARGET_USER})
        --host NAME                 Target hostname for home-manager (default: ${TARGET_HOST})
    -h, --help                      Show this help message and exit

EOF
}

configure_nix_conf() {
    local conf="/etc/nix/nix.conf"
    local required_lines=(
        "trusted-users = root @wheel"
        "experimental-features = nix-command flakes"
        "max-jobs = auto"
    )

    sudo touch "$conf"

    local line
    for line in "${required_lines[@]}"; do
        if grep -qxF "$line" "$conf"; then
            ok "Already set: ${line}"
        else
            info "Adding: ${line}"
            echo "$line" | sudo tee -a "$conf" >/dev/null
        fi
    done
}

setup_nix() {
    if command -v nix >/dev/null 2>&1; then
        ok "Nix already installed, skipping."
        return 0
    fi

    info "Installing Nix via pacman..."
    sudo pacman -Syu --needed --noconfirm nix

    info "Enabling nix-daemon.service..."
    sudo systemctl enable --now nix-daemon.service

    configure_nix_conf

    ok "Nix setup complete."
}

fetch_ssh_key() {
    if [[ -f "$SSH_KEY_PATH" && "$FORCE" == false ]]; then
        ok "SSH key already exists at ${SSH_KEY_PATH}, skipping (use -f to overwrite)."
        return 0
    fi

    if [[ ! -f "$KP_DATABASE_FILE" ]]; then
        err "Database file not found: ${KP_DATABASE_FILE}"
        exit 1
    fi

    if [[ -n "$KP_KEY_FILE" && ! -f "$KP_KEY_FILE" ]]; then
        err "Key file not found: ${KP_KEY_FILE}"
        exit 1
    fi

    info "Fetching SSH private key from keepass entry '${KP_ENTRY}'..."

    local kp_cli_args=()
    [[ -n "$KP_KEY_FILE" ]] && kp_cli_args+=(--key-file "$KP_KEY_FILE")

    mkdir -p "$(dirname "$SSH_KEY_PATH")"
    chmod 700 "$(dirname "$SSH_KEY_PATH")"

    local fetch_ok=true
    if command -v keepassxc-cli >/dev/null 2>&1; then
        keepassxc-cli show "$KP_DATABASE_FILE" "$KP_ENTRY" "${kp_cli_args[@]}" -a "$KP_ENTRY_ATTRIBUTE" \
            > "$SSH_KEY_PATH" || fetch_ok=false
    else
        info "keepassxc-cli not found on PATH, using nix-shell..."
        nix-shell -p keepassxc --run \
            "keepassxc-cli show '${KP_DATABASE_FILE}' '${KP_ENTRY}' ${kp_cli_args[*]} -a '${KP_ENTRY_ATTRIBUTE}'" \
            > "$SSH_KEY_PATH" || fetch_ok=false
    fi

    if [[ "$fetch_ok" == false ]]; then
        rm -f "$SSH_KEY_PATH"
        err "Failed to fetch SSH key from keepass entry '${ENTRY}', attribute '${ATTRIBUTE}'."
        exit 1
    fi

    chmod 600 "$SSH_KEY_PATH"

    if [[ ! -s "$SSH_KEY_PATH" ]]; then
        rm -f "$SSH_KEY_PATH"
        err "Fetched empty value from keepass. Check --entry/--attribute."
        exit 1
    fi

    ok "SSH private key written to ${SSH_KEY_PATH}."

    info "Generating public key..."
    ssh-keygen -y -f "$SSH_KEY_PATH" > "$SSH_PUB_KEY_PATH"
    chmod 644 "$SSH_PUB_KEY_PATH"
    ok "Public key written to ${SSH_PUB_KEY_PATH}."
}

generate_age_key() {
    if [[ -f "$AGE_KEY_PATH" && "$FORCE" == false ]]; then
        ok "Age key already exists at ${AGE_KEY_PATH}, skipping (use -f to overwrite)."
        return 0
    fi

    if [[ ! -f "$SSH_KEY_PATH" ]]; then
        err "SSH private key not found at ${SSH_KEY_PATH}. Run fetch_ssh_key first."
        exit 1
    fi

    info "Generating age key from SSH key for sops-nix..."

    mkdir -p "$AGE_KEY_DIR"
    chmod 700 "$AGE_KEY_DIR"

    local gen_ok=true
    if command -v ssh-to-age >/dev/null 2>&1; then
        ssh-to-age -private-key -i "$SSH_KEY_PATH" > "$AGE_KEY_PATH" || gen_ok=false
    else
        info "ssh-to-age not found on PATH, using nix-shell..."
        nix-shell -p ssh-to-age --run \
            "ssh-to-age -private-key -i '${SSH_KEY_PATH}'" \
            > "$AGE_KEY_PATH" || gen_ok=false
    fi

    if [[ "$gen_ok" == false ]]; then
        rm -f "$AGE_KEY_PATH"
        err "Failed to generate age key from ${SSH_KEY_PATH}."
        exit 1
    fi
    chmod 600 "$AGE_KEY_PATH"

    if [[ ! -s "$AGE_KEY_PATH" ]]; then
        rm -f "$AGE_KEY_PATH"
        err "Generated age key is empty. Check that ${SSH_KEY_PATH} is a valid ed25519 key."
        exit 1
    fi

    ok "Age key written to ${AGE_KEY_PATH}."
}

is_nixos() {
    [[ -f /etc/NIXOS ]]
}

rebuild_system() {
    if is_nixos; then
        info "NixOS detected. Running nixos-rebuild switch..."
        sudo nixos-rebuild switch --flake .
        ok "System rebuilt via nixos-rebuild."
        return 0
    fi

    info "Non-NixOS system detected."

    if command -v home-manager >/dev/null 2>&1; then
        info "home-manager found on PATH. Running home-manager switch..."
        home-manager switch --flake . -b backup
    else
        info "home-manager not found. Bootstrapping via nix run..."
        nix run github:nix-community/home-manager -- switch \
            --flake ".#${TARGET_USER}@${TARGET_HOST}" -b backup
    fi

    ok "home-manager configuration applied."
    warn "For KDE/GNOME to find apps, you need to re-login."
}

main() {
    setup_nix
    fetch_ssh_key
    generate_age_key
    rebuild_system
}

# --- Arg parsing ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            print_help
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -d|--db_file)
            KP_DATABASE_FILE="$2"
            shift 2
            ;;
        -k|--key_file)
            KP_KEY_FILE="$2"
            shift 2
            ;;
        -e|--entry)
            KP_ENTRY="$2"
            shift 2
            ;;
        -a|--attribute)
            KP_ENTRY_ATTRIBUTE="$2"
            shift 2
            ;;
        --user)
            TARGET_USER="$2"
            shift 2
            ;;
        --host)
            TARGET_HOST="$2"
            shift 2
            ;;
        *)
            err "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

main "$@"

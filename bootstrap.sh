#!/usr/bin/env bash
set -eu

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# OS Detection
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    elif [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
        echo "wsl"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
log_info "Detected OS: $OS"

# ====================
# 1) Install prerequisites
# ====================
install_prerequisites() {
    log_info "Installing prerequisites..."

    if [[ "$OS" == "darwin" ]]; then
        # Install Xcode Command Line Tools
        if ! xcode-select -p &>/dev/null; then
            log_info "Installing Xcode Command Line Tools..."
            xcode-select --install
            # Wait for installation
            until xcode-select -p &>/dev/null; do
                sleep 5
            done
        fi

        # Install Homebrew
        if ! command -v brew &>/dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    elif [[ "$OS" == "wsl" ]] || [[ "$OS" == "linux" ]]; then
        # Install dependencies via apt
        if command -v apt-get &>/dev/null; then
            log_info "Installing dependencies via apt..."
            sudo apt-get update
            sudo apt-get install -y git curl zsh keychain
        fi
    fi

    log_success "Prerequisites installed"
}

# ====================
# 2) Install chezmoi
# ====================
install_chezmoi() {
    if command -v chezmoi &>/dev/null; then
        log_info "chezmoi is already installed"
        return
    fi

    log_info "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
    log_success "chezmoi installed"
}

# ====================
# 3) Initialize chezmoi
# ====================
init_chezmoi() {
    log_info "Initializing chezmoi..."

    if [[ -d "$HOME/.local/share/chezmoi" ]]; then
        log_info "chezmoi source directory exists, applying..."
        chezmoi apply
    else
        log_info "Initializing from GitHub..."
        chezmoi init --apply shibachan1015/dotfiles
    fi

    log_success "chezmoi initialized"
}

# ====================
# 4) Install Nix
# ====================
install_nix() {
    if command -v nix &>/dev/null; then
        log_info "Nix is already installed"
        return
    fi

    log_info "Installing Nix (multi-user)..."
    sh <(curl -L https://nixos.org/nix/install) --daemon

    # Source nix
    if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi

    log_success "Nix installed"
}

# ====================
# 5) Setup Home Manager
# ====================
setup_home_manager() {
    log_info "Setting up Home Manager..."

    # Enable flakes
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

    local username=$(whoami)
    local flake_path="$HOME/dotfiles/nix"

    if [[ "$OS" == "darwin" ]]; then
        log_info "Setting up nix-darwin..."
        nix run nix-darwin -- switch --flake "$flake_path#MacBook-Pro"
    else
        log_info "Applying Home Manager configuration for $username..."
        nix run home-manager/master -- switch --flake "$flake_path#$username"
    fi

    log_success "Home Manager configured"
}

# ====================
# 6) Setup zsh as default shell
# ====================
setup_zsh() {
    if [[ "$SHELL" == *"zsh"* ]]; then
        log_info "zsh is already the default shell"
        return
    fi

    log_info "Setting zsh as default shell..."

    # Add zsh to /etc/shells if not present
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi

    chsh -s "$(which zsh)"
    log_success "zsh set as default shell"
}

# ====================
# Main
# ====================
main() {
    log_info "Starting dotfiles bootstrap..."
    log_info "=========================================="

    install_prerequisites
    install_chezmoi
    init_chezmoi
    install_nix
    setup_home_manager
    setup_zsh

    log_info "=========================================="
    log_success "Bootstrap complete!"
    log_info "Please restart your terminal or run: exec zsh"
}

main "$@"

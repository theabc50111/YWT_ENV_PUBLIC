#!/bin/bash

set -euo pipefail

# --- Helper Functions ---

# Function to run a command, using sudo if not root.
# This avoids repeating the root check.
run_as_root() {
    if [ "$(whoami)" != "root" ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# --- Task-specific Functions ---

# Consolidates all package installations.
install_packages() {
    echo "INFO: Updating package lists..."
    run_as_root apt-get update

    echo "INFO: Installing required packages..."
    local packages="git curl wget zsh tmux sed tree less jq bat"
    if [ "$gnome_enabled" = "true" ]; then
        packages="$packages bc dconf-cli"
    fi
    run_as_root apt-get install -y $packages
    echo "SUCCESS: All packages installed."
}

# Sets up Zsh, Oh My Zsh, and plugins.
setup_zsh() {
    echo "INFO: Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"

    echo "INFO: Installing Oh-My-Zsh..."
    if [ -d ~/.oh-my-zsh ]; then
        rm -rf ~/.oh-my-zsh
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo "INFO: Installing Zsh plugins..."
    local custom_plugins_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    git clone https://github.com/zsh-users/zsh-completions "${custom_plugins_dir}/zsh-completions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${custom_plugins_dir}/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${custom_plugins_dir}/zsh-syntax-highlighting"

    echo "INFO: Installing Dracula theme for zsh-syntax-highlighting..."
    local dracula_clone_dir="zsh-syntax-highlighting-dracula"
    git clone https://github.com/dracula/zsh-syntax-highlighting.git "$dracula_clone_dir"
    # Safely add theme to .zshrc if not already present
    if ! grep -q 'Dracula Theme (for zsh-syntax-highlighting)' ./.zshrc; then
        sed -i '61 r ./'"$dracula_clone_dir"'/zsh-syntax-highlighting.sh' ./.zshrc
    fi
    rm -rf "$dracula_clone_dir"
    echo "SUCCESS: Zsh setup is complete."
}

# Handles all GNOME-related setup.
setup_gnome() {
    echo "INFO: Starting GNOME Terminal setup..."
    # Check GNOME version before proceeding
    local gnome_ver
    gnome_ver=$(gnome-terminal --version | grep -Eo '[0-9]*\.[0-9]*' | head -1)
    local terminal_profile_list
    terminal_profile_list=($(gsettings get org.gnome.Terminal.ProfilesList list))
    
    if (( $(echo "$gnome_ver > 3.8" | bc -l) )) && [ ${#terminal_profile_list[@]} -le 1 ]; then
        echo "WARNING: Your GNOME version is > 3.8, but you have no extra profiles."
        echo "Please create at least one new terminal profile manually for the script to continue."
        exit 1
    fi

    local profile_name="YWT_Dracula"
    echo "INFO: Creating GNOME Terminal profile: $profile_name..."
    # shellcheck source=./create_gnome_terminal_profile.sh
    source "$PWD/create_gnome_terminal_profile.sh" "$profile_name"

    echo "INFO: Installing Dracula theme for GNOME Terminal..."
    git clone https://github.com/dracula/gnome-terminal
    ./gnome-terminal/install.sh --scheme Dracula --profile "$profile_name" --install-dircolors
    
    # Clean up
    rm -rf gnome-terminal dircolors ~/.dir_colors/dircolors.old
    echo "SUCCESS: GNOME Terminal setup is complete."
}

# Copies configuration files to home directory.
deploy_dotfiles() {
    echo "INFO: Deploying dotfiles (.zshrc, .bashrc, .tmux.conf)..."
    cp -rf "$PWD/.zshrc" "$PWD/.bashrc" "$PWD/.profile" "$PWD/.tmux.conf" ~/
    echo "SUCCESS: Dotfiles have been deployed."
}

# Sets up Tmux and its plugin manager.
setup_tmux() {
    echo "INFO: Installing Tmux Plugin Manager (TPM)..."
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    
    echo "INFO: Installing Tmux plugins..."
    ~/.tmux/plugins/tpm/bin/install_plugins

    echo "INFO: Copying Tmux scripts..."
    mkdir -p ~/.tmux/scripts
    cp -f "$PWD/tmux_scripts/"* ~/.tmux/scripts/
    echo "SUCCESS: Tmux setup is complete."
}

# Updates the /etc/hosts file.
update_hosts_file() {
    echo "INFO: Updating /etc/hosts to map localhost to hostname..."
    local temp_hosts
    temp_hosts=$(mktemp)
    
    # Create a new hosts file in a temporary location
    cp /etc/hosts "$temp_hosts"
    sed -i "s/#127.0.1.1 # revise to  your loscalhost hostname/127.0.0.1 $HOSTNAME/" "$temp_hosts"

    # Overwrite the original /etc/hosts file
    run_as_root cp "$temp_hosts" /etc/hosts
    rm -f "$temp_hosts"
    echo "SUCCESS: /etc/hosts file updated."
}


# --- Main Execution Logic ---

main() {
    local gnome_enabled="false"
    
    # Argument parsing
    if [ $# -eq 0 ]; then
        echo "ERROR: Missing required argument. Use --gnome 'true' or 'false'." >&2
        exit 1
    fi
    
    # Simple argument parsing for --gnome
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --gnome)
                gnome_enabled="$2"
                shift 2
                ;;
            -h|--help)
                echo "This script sets up a development environment with configurations for tmux, zsh, bash, and optionally GNOME Terminal."
                echo "Usage: $0 --gnome 'true'|'false'"
                exit 0
                ;;
            *)
                echo "ERROR: Unrecognized option: $1" >&2
                exit 1
                ;;
        esac
    done

    # --- Execute Setup Tasks ---
    install_packages
    if [ "$gnome_enabled" = "true" ]; then
        setup_gnome
    else
        echo "INFO: Skipping GNOME Terminal setup."
    fi
    setup_zsh
    setup_tmux
    deploy_dotfiles
    update_hosts_file

    echo "----------------------------------------------------"
    echo "SUCCESS: System setup and configuration is complete!"
    echo "Please restart your terminal to apply all changes."
    echo "----------------------------------------------------"
}

# Pass all script arguments to the main function
main "$@"
git reset --hard

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

# Clones a repo or moves a local folder.
# Arguments:
#   $1: can_git_clone_enabled (string: "true" or "false")
#   $2: repo_url (used for cloning)
#   $3: local_source_path (Full path to the local source directory or file to move)
#   $4: destination_path
resource_get() {
    local can_git_clone_enabled="$1"
    local repo_url="$2"
    local local_source_path="$3" # Full path to the local source directory or file
    local destination_path="$4"  # Full path to the desired destination directory or file

    if [ "$can_git_clone_enabled" = "true" ]; then
        echo "INFO: Cloning '$repo_url'..."
        git clone --depth 1 "$repo_url" "$destination_path"
    else
        if [ -d "$local_source_path" ]; then
            echo "INFO: Moving local directory '$local_source_path' to '$destination_path'..."
            
            # Ensure parent directory exists for the destination
            mkdir -p "$(dirname "$destination_path")"

            # Remove existing destination if it's a directory (to avoid 'mv' moving source INSIDE dest)
            if [ -d "$destination_path" ]; then
                rm -rf "$destination_path"
            fi
            
            mv "$local_source_path" "$destination_path" # Move the entire directory
            
        elif [ -f "$local_source_path" ]; then
            echo "INFO: Moving local file '$local_source_path' to '$destination_path'..."
            mkdir -p "$(dirname "$destination_path")"
            mv "$local_source_path" "$destination_path"
        else
            echo "WARNING: Local resource '$local_source_path' not found. Skipping." >&2
        fi
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
    local can_git_clone_enabled="$1"
    echo "INFO: Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"

    echo "INFO: Installing Oh-My-Zsh..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh"
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo "INFO: Getting Zsh plugins..."
    local custom_plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    resource_get "$can_git_clone_enabled" "https://github.com/zsh-users/zsh-completions.git" "./pkgs/zsh-completions" "${custom_plugins_dir}/zsh-completions"
    resource_get "$can_git_clone_enabled" "https://github.com/zsh-users/zsh-autosuggestions.git" "./pkgs/zsh-autosuggestions" "${custom_plugins_dir}/zsh-autosuggestions"
    resource_get "$can_git_clone_enabled" "https://github.com/zsh-users/zsh-syntax-highlighting.git" "./pkgs/zsh-syntax-highlighting" "${custom_plugins_dir}/zsh-syntax-highlighting"

    echo "INFO: Getting Dracula theme for zsh-syntax-highlighting..."
    local dracula_clone_dir="zsh-syntax-highlighting-dracula"
    resource_get "$can_git_clone_enabled" "https://github.com/dracula/zsh-syntax-highlighting.git" "./pkgs/zsh-syntax-highlighting-dracula" "$dracula_clone_dir"

    if [ -f "./$dracula_clone_dir/zsh-syntax-highlighting.sh" ]; then
        # Safely add theme to the local .zshrc if not already present
        if ! grep -q 'zsh-syntax-highlighting.sh' ./.zshrc; then
            sed -i '61 r ./'"$dracula_clone_dir"'/zsh-syntax-highlighting.sh' ./.zshrc
        fi
        rm -rf "$dracula_clone_dir"
    fi
    echo "SUCCESS: Zsh setup is complete."
}

# Handles all GNOME-related setup.
setup_gnome() {
    local can_git_clone_enabled="$1"
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

    echo "INFO: Getting Dracula theme for GNOME Terminal..."
    resource_get "$can_git_clone_enabled" "https://github.com/dracula/gnome-terminal.git" "./pkgs/gnome-terminal" "gnome-terminal"

    if [ -d "./gnome-terminal" ]; then
        ./gnome-terminal/install.sh --scheme Dracula --profile "$profile_name" --install-dircolors
        # Clean up
        rm -rf gnome-terminal dircolors "$HOME/.dir_colors/dircolors.old"
    fi
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
    local can_git_clone_enabled="$1"
    echo "INFO: Getting Tmux Plugin Manager (TPM)..."
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        resource_get "$can_git_clone_enabled" "https://github.com/tmux-plugins/tpm.git" "./pkgs/tpm" "$HOME/.tmux/plugins/tpm"
    fi
    
    # Conditionally install plugins
    if [ "$can_git_clone_enabled" = "true" ]; then
        if [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
            echo "INFO: Installing Tmux plugins..."
            "$HOME/.tmux/plugins/tpm/bin/install_plugins"
        fi
    else
        echo "INFO: Skipping automatic Tmux plugin installation (can_git_clone_enabled is false)."
        echo "INFO: Please ensure required Tmux plugins are manually placed in '$HOME/.tmux/plugins/'"
    fi

    echo "INFO: Copying Tmux scripts..."
    mkdir -p "$HOME/.tmux/scripts"
    cp -f "$PWD/tmux_scripts/"* "$HOME/.tmux/scripts/"
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
    local gnome_enabled="" # Required, so no default value
    local can_git_clone_enabled="" # Required, so no default value

    # Simple argument parsing
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --gnome)
                gnome_enabled="$2"
                shift 2
                ;;
            --can-git-clone)
                can_git_clone_enabled="$2"
                shift 2 # Argument takes a value, so shift 2
                ;;
            -h|--help)
                echo "This script sets up a development environment with configurations for tmux, zsh, bash, and optionally GNOME Terminal."
                echo "Usage: $0 --gnome <true|false> --can-git-clone <true|false>"
                exit 0
                ;;
            *)
                echo "ERROR: Unrecognized option: $1" >&2
                exit 1
                ;;
        esac
    done

    # Verify that the required argument was provided
    if [ -z "$can_git_clone_enabled" ]; then
        echo "ERROR: --can-git-clone is a required argument." >&2
        echo "Usage: $0 --can-git-clone <true|false>"
        exit 1
    fi
    if [ -z "$gnome_enabled" ]; then
        echo "ERROR: --gnome is a required arguments." >&2
        echo "Usage: $0 --gnome <true|false>"
        exit 1
    fi

    # --- Execute Setup Tasks ---
    install_packages
    if [ "$gnome_enabled" = "true" ]; then
        setup_gnome "$can_git_clone_enabled"
    else
        echo "INFO: Skipping GNOME Terminal setup."
    fi
    setup_zsh "$can_git_clone_enabled"
    deploy_dotfiles
    setup_tmux "$can_git_clone_enabled"
    update_hosts_file

    echo "----------------------------------------------------"
    echo "SUCCESS: System setup and configuration is complete!"
    echo "Please restart your terminal to apply all changes."
    echo "----------------------------------------------------"
}

# Pass all script arguments to the main function
main "$@"
git reset --hard

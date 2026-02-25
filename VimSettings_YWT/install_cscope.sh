#!/bin/bash

set -u # make sure all varaible is set
operator=$(whoami)

# --- Default values ---
can_git_clone=""
install_dir=""

# --- Argument Parsing ---
LONG_ARGUMENT_LIST=(
    "help"
    "can-git-clone:"
    "install-dir:"
)

ARGUMENT_LIST=(
    "h"
)

opts=$(getopt \
  --longoptions "$(printf "%s," "${LONG_ARGUMENT_LIST[@]}")" \
  --options "$(printf "%s," "${ARGUMENT_LIST[@]}")" \
  --name "$(basename "$0")" \
  -- "$@"
)

if [ $? -ne 0 ]; then
  echo "Invalid option provided"
  exit 1
fi

eval set -- "$opts"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --can-git-clone)
      can_git_clone="$2"
      shift 2
      ;;
    --install-dir)
      install_dir="$2"
      shift 2
      ;;
    -h|--help)
        cat <<-EOF
        Installs cscope either from apt repository or by compiling from a local source.

        Usage:
          $(basename "$0") --can-git-clone <true|false> [--install-dir /path/to/install]

        Options:
          --can-git-clone <true|false>   (Required) Specify the installation method.
                                         - "true": Use 'apt install' (requires network).
                                         - "false": Compile from local source (offline).

          --install-dir <path>           (Only for local source) Set the installation prefix.
                                         Defaults to /usr/local.

          -h, --help                     Display this help message and exit.
EOF
        exit 0
        ;;
    --)
      shift
      break
      ;;
    *)
      echo "================ Error:Unrecognized option: $1 provided ================"
      exit 1
      ;;
  esac
done

# --- Validate arguments ---
if [ -z "$can_git_clone" ]; then
  echo "Error: --can-git-clone <true|false> is a required option."
  echo "Run with --help for more information."
  exit 1
fi

# --- Main Logic ---
if [ "$can_git_clone" = "true" ]; then
    echo "Installing cscope using apt..."
    if [ "$operator" != "root" ]; then
        sudo apt install -y cscope
    else
        apt install -y cscope
    fi
    echo "cscope installation complete."
else
    echo "Installing cscope from local source..."
    cscope_dir="./pkgs/cscope"

    # Set default install directory if not provided
    if [ -z "$install_dir" ]; then
        install_dir="/usr/local"
        echo "No --install-dir provided, defaulting to $install_dir"
    fi

    # Check 1: Source directory exists
    if [ ! -d "$cscope_dir" ]; then
        echo "Error: $cscope_dir not found."
        echo "Please download the cscope source from https://cscope.sourceforge.net/, unzip it, rename the folder to 'cscope', and place it in the './pkgs' directory."
        exit 1
    fi
    echo "Found source directory at $cscope_dir"

    # Check 2: Install directory doesn't contain /bin
    if [[ "$install_dir" == *"/bin"* ]]; then
        echo "Error: --install-dir should not contain '/bin'. 'make install' will handle that."
        exit 1
    fi

    cd "$cscope_dir"

    # Check 3: Automake version
    if [ "$(automake --version | grep -oE '[0-9]+\.[0-9]+')" != "1.15" ]; then
        echo "Automake version is not 1.15. Running 'autoreconf'..."
        autoreconf --install
    else
        echo "Automake version is 1.15. Skipping autoreconf."
    fi

    # Install cscope from source
    echo "Configuring with install prefix: $install_dir"
    ./configure --prefix="$install_dir"
    
    echo "Running make..."
    make

    echo "Running make install..."
    if [ "$operator" != "root" ]; then
        sudo make install
    else
        make install
    fi

    cd ../../
    echo "cscope installation from source complete."
fi

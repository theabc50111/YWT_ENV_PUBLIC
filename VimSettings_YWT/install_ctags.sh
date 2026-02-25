#! /bin/bash

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
        Installs Universal Ctags either by cloning and building from git, or by compiling from a local source.

        Usage:
          $(basename "$0") --can-git-clone <true|false> [--install-dir /path/to/install]

        Options:
          --can-git-clone <true|false>   (Required) Specify the installation method.
                                         - "true": Clones source from GitHub and installs build dependencies via apt.
                                         - "false": Compiles from local source (offline). Assumes source is in './pkgs/ctags' and build dependencies are pre-installed.

          --install-dir <path>           (Optional) Set the installation prefix. Defaults to /usr/local.

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
    echo "Installing Universal Ctags from git..."

    # Install build dependencies
    echo "Installing build dependencies via apt..."
    if [ "$operator" != "root" ]; then
        sudo apt install -y gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
    else
        apt install -y gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
    fi

    # Clone source and build
    echo "Cloning Universal Ctags repository..."
    git clone https://github.com/universal-ctags/ctags.git
    
    cd ctags
    echo "Running autogen.sh..."
    ./autogen.sh
    echo "Configuring..."
    # Use provided install_dir or default to /usr/local
    ./configure --prefix="${install_dir:-/usr/local}"
    echo "Running make..."
    make
    echo "Running make install..."
    if [ "$operator" != "root" ]; then
        sudo make install
    else
        make install
    fi
    cd ..
    echo "Cleaning up cloned repository..."
    rm -rf ctags
    echo "Universal Ctags installation from git complete."

else # --can-git-clone false
    echo "Installing Universal Ctags from local source..."
    ctags_dir="./pkgs/ctags"

    # Set default install directory if not provided
    if [ -z "$install_dir" ]; then
        install_dir="/usr/local"
        echo "No --install-dir provided, defaulting to $install_dir"
    fi

    # Check 1: Source directory exists
    if [ ! -d "$ctags_dir" ]; then
        echo "Error: $ctags_dir not found."
        echo "Please clone ctags from https://github.com/universal-ctags/ctags.git, rename the folder to 'ctags', and place it in the './pkgs' directory."
        exit 1
    fi
    echo "Found source directory at $ctags_dir"

    # Check 2: Install directory doesn't contain /bin
    if [[ "$install_dir" == *"/bin"* ]]; then
        echo "Error: --install-dir should not contain '/bin'. 'make install' will handle that."
        exit 1
    fi

    cd "$ctags_dir"

    # Install ctags from source
    echo "Running autogen.sh..."
    ./autogen.sh
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
    echo "Universal Ctags installation from source complete."
fi

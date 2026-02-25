#! /bin/bash

set -u # make sure all varaible is set
operator=$(whoami)

can_git_clone=""


LONG_ARGUMENT_LIST=(
    "help"
    "can-git-clone:"
)

ARGUMENT_LIST=(
    "h"
)

# read arguments
opts=$(getopt \
  --longoptions "$(printf "%s," "${LONG_ARGUMENT_LIST[@]}")" \
  --options "$(printf "%s," "${ARGUMENT_LIST[@]}")" \
  --name "$(basename "$0")" \
  -- "$@"
)

# if sending invalid option, stop script
if [ $? -ne 0 ]; then
  echo "Invalid option provided"
  exit 1
fi

eval set -- "$opts"
# The eval in eval set --$opts is required as arguments returned by getopt are quoted.

while [[ $# -gt 0 ]]; do
  case "$1" in

    --can-git-clone)
      can_git_clone="$2"
      shift 2
      ;;

    -h|--help)
        cat <<-EOF
        Builds and installs the latest stable version of Vim from source.

        Usage:
          $(basename "$0") --can-git-clone <true|false>

        This script requires specifying whether to clone the Vim source code from GitHub
        or use a local copy.

        Options:
          --can-git-clone <true|false>   (Required) Specify whether to clone the vim repository.
                                         - If "true", clones from https://github.com/vim/vim.git.
                                         - If "false", uses a local copy expected at ./pkgs/vim.
          -h, --help                     Display this help message and exit.
EOF
        exit 0
        ;;

    --)
      # if getopt reached the end of options, exit loop
      shift
      break
      ;;

    *)
      # if sending invalid option, stop script
      echo "================ Error:Unrecognized option: $1 provided ================"
      exit 1
      ;;

  esac
done

if [ -z "$can_git_clone" ]; then
  echo "Error: --can-git-clone option is required."
  echo "Usage: $0 --can-git-clone <true|false>"
  exit 1
fi



# install prerequisite of vim with apt
if [ "$operator" != "root" ]; then
    sudo apt install -y build-essential make clang libtool-bin libxt-dev libgtk-3-dev libpython3-dev libncurses-dev python3-dev
else
    apt install -y build-essential make clang libtool-bin libxt-dev libgtk-3-dev libpython3-dev libncurses-dev python3-dev
fi

if [ "$can_git_clone" = "true" ]; then
    git clone https://github.com/vim/vim.git
else
    # Check if pkgs/vim exists before moving
    if [ -d "./pkgs/vim" ]; then
        cp -r ./pkgs/vim ./vim
    else
        echo "Error: ./pkgs/vim does not exist. Cannot install Vim without git clone or local source."
        exit 1
    fi
fi

cd vim/src
./configure --with-features=huge --enable-python3interp --enable-gui=gtk3 --enable-cscope
if [ "$operator" != "root" ]; then
    sudo make -j$(nproc)
    sudo make install
else
    make -j$(nproc)
    make install
fi
cd ../../
rm -rf vim

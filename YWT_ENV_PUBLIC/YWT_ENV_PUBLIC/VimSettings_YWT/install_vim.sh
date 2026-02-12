#! /bin/bash

set -u # make sure all varaible is set
operator=$(whoami)


LONG_ARGUMENT_LIST=(
    "help"
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

    -h|--help)
        echo "This script build vim from git, to make sure install newest stable vim"
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



# install prerequisite of vim with apt
if [ "$operator" != "root" ]; then
    # ref: https://github.com/vim/vim/blob/master/src/INSTALL ; https://github.com/vim/vim
    sudo apt install -y build-essential make clang libtool-bin libxt-dev libgtk-3-dev libpython3-dev libncurses-dev python3-dev
    git clone https://github.com/vim/vim.git
    cd vim/src
    ./configure --with-features=huge --enable-python3interp --enable-gui=gtk3 --enable-cscope
    sudo make -j$(nproc)
    sudo make install
    cd ../../
    sudo rm -rf vim
else
    apt install -y build-essential make clang libtool-bin libxt-dev libgtk-3-dev libpython3-dev libncurses-dev python3-dev
    git clone https://github.com/vim/vim.git
    cd vim/src
    ./configure --with-features=huge --enable-python3interp --enable-gui=gtk3 --enable-cscope
    make -j$(nproc)
    make install
    cd ../../
    rm -rf vim
fi

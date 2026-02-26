#!/bin/bash

set -u # check if all variables have been set

install_cscope="false"
install_ctags="false"
install_offline="" # Initialize to empty string
install_nodejs=""  # Initialize to empty string
install_ctag_cscope_dir=""

LONG_ARGUMENT_LIST=(
  "install-cscope:"
  "install-ctags:"
  "install-nodejs:"
  "offline:"
  "install-ctag-cscope-dir:"
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
  -- "$@")

# if sending invalid option, stop script
if [ $? -ne 0 ]; then
  echo  "================== Error:Invalid option provided =================="
  exit 1
fi

# The eval in eval set --$opts is required as arguments returned by getopt are quoted.
eval set --$opts


while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-cscope)
      install_cscope="$2" # Note: In order to handle the argument containing space, the quotes around '$2': they are essential!
      shift 2 # The 'shift' eats a commandline argument, i.e. converts $1=a, $2=b, $3=c, $4=d into $1=b, $2=c, $3=d. shift 2 moves it all the way to $1=c, $2=d. It's done since that particular branch uses an argument, so it has to remove two things from the list (the -r and the argument following it) not just one.
      ;;

    --install-ctags)
      install_ctags="$2"
      shift 2
      ;;

    --install-nodejs)
      install_nodejs="$2"
      shift 2
      ;;

    --offline)
      install_offline="$2"
      shift 2
      ;;

    --install-ctag-cscope-dir)
      install_ctag_cscope_dir="$2"
      shift 2
      ;;

    -h|--help)
        echo "This script setting for vim"
        echo "--install-cscope takes 'true' or 'false'"
        echo "--install-ctags takes 'true' or 'false'"
        echo "--install-nodejs takes 'true' or 'false'"
        echo "--offline takes 'true' or 'false' to install from local pkgs"
        echo "--install-ctag-cscope-dir takes path (mandatory for --offline, --install-ctags/--install-cscope is true)"
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

# Mandatory checks
if [ -z "$install_offline" ]; then
    echo "Error: --offline must be provided."
    exit 1
fi

if [ -z "$install_nodejs" ]; then
    echo "Error: --install-nodejs must be provided."
    exit 1
fi

if [ "$install_offline" = "true" ] && { [ "$install_ctags" = "true" ] || [ "$install_cscope" = "true" ]; } && [ -z "$install_ctag_cscope_dir" ]; then
    echo "Error: --install-ctag-cscope-dir is mandatory when --offline is true and --install-ctags or --install-cscope is set."
    exit 1
fi


if [ $install_cscope = "true" ]; then
    if [ "$install_offline" = "true" ]; then
        ./install_cscope.sh --can-git-clone false --install-dir $install_ctag_cscope_dir
    else
        ./install_cscope.sh
    fi
    echo "--- Cscope installation completed successfully."
fi

if [ $install_ctags = "true" ]; then
    if [ "$install_offline" = "true" ]; then
        ./install_ctags.sh --can-git-clone false --install-dir $install_ctag_cscope_dir
    else
        ./install_ctags.sh
    fi
    echo "--- Ctags installation completed successfully."
fi

if [ "$install_nodejs" = "true" ]; then
    ./install_nodejs.sh
    echo "--- Node.js installation completed successfully."
fi

mkdir -p ~/.config
echo "--- Directory ~/.config created."

if [ "$install_offline" = "true" ]; then
    cp -rf $PWD/.vimrc_no_net ~/.vimrc
    mkdir -p ~/.vim/autoload
    mkdir -p ~/.vim/plugged
    cp -rf $PWD/pkgs/plug.vim ~/.vim/autoload
    cp -rf $PWD/pkgs/dracula ~/.vim/plugged
    cp -rf $PWD/pkgs/ale ~/.vim/plugged
    cp -rf $PWD/pkgs/vim-lsp ~/.vim/plugged
    cp -rf $PWD/pkgs/vista.vim ~/.vim/plugged
    cp -rf $PWD/pkgs/vim-lsp-ale ~/.vim/plugged
    cp -rf $PWD/pkgs/vim-airline ~/.vim/plugged
    cp -rf $PWD/pkgs/vim-airline-themes ~/.vim/plugged
    cp -rf $PWD/pkgs/vim-hocon ~/.vim/plugged
    cp -rf $PWD/pkgs/vim-jsonpath ~/.vim/plugged
    cp -rf $PWD/pkgs/snake ~/.vim/plugged
    echo "export PATH=$PATH:$install_ctag_cscope_dir/bin/" >> ~/.bashrc
    echo "export PATH=$PATH:$install_ctag_cscope_dir/bin/" >> ~/.zshrc
    source ~/.bashrc
    echo "--- Vim configuration and plugins (offline) deployed successfully."
else
    cp -rf $PWD/.vimrc ~
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "--- Vim configuration and vim-plug (online) deployed successfully."
fi
cp -rf $PWD/lint_config ~/.config
echo "--- Lint configuration deployed successfully."

echo "Finish!!!!!!!!!!!!!!!!"

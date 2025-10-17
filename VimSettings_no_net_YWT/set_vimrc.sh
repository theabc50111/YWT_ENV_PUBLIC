#!/bin/bash

set -u # check if all variables have been set

LONG_ARGUMENT_LIST=(
  "install_cscope:"  # `:` means require arguments
  "install_ctags:"
  "install_dir:"
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

install_dir=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install_cscope)
      install_cscope="$2" # Note: In order to handle the argument containing space, the quotes around '$2': they are essential!
      shift 2 # The 'shift' eats a commandline argument, i.e. converts $1=a, $2=b, $3=c, $4=d into $1=b, $2=c, $3=d. shift 2 moves it all the way to $1=c, $2=d. It's done since that particular branch uses an argument, so it has to remove two things from the list (the -r and the argument following it) not just one.
      ;;

    --install_ctags)
      install_ctags="$2"
      shift 2
      ;;

    --install_dir)
      install_dir="$2"
      shift 2
      ;;

    -h|--help)
        echo "This script setting for vim"
        echo "--install_cscope takes 'true' or 'false'"
        echo "--install_ctags takes 'true' or 'false'"
        echo "--install_dir takes path"
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

# Check for mandatory options
if [ -z "$install_dir" ]; then
    echo "Error: Options --install_dir is mandatory."
    exit 1
fi

if [ $install_cscope = "true" ]; then
    ./install_cscope_no_net.sh $install_dir
fi

if [ $install_ctags = "true" ]; then
    ./install_ctags_no_net.sh $install_dir
fi

# Append the line to .bashrc
echo "export PATH=$PATH:$install_dir/bin/" >> ~/.bashrc
# Reload .bashrc to apply changes in the current session
source ~/.bashrc

mkdir ~/.config
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/plugged
[[ -f "$PWD/pkgs/plug.vim" ]] && echo "./pkgs/plug.vim exists." || echo "./pkgs/plug.vim does not exist. "Download plug.vim from https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp -rf $PWD/.vimrc ~
cp -rf $PWD/lint_config ~/.config
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
echo "Finish!!!!!!!!!!!!!!!!"

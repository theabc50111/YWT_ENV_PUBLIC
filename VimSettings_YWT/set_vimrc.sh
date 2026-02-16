#!/bin/bash

set -u # check if all variables have been set

LONG_ARGUMENT_LIST=(
  "install-cscope:"  # `:` means require arguments
  "install-ctags:"
  "install-nodejs:"
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

    -h|--help)
        echo "This script setting for vim"
        echo "--install-cscope takes 'true' or 'false'"
        echo "--install-ctags takes 'true' or 'false'"
        echo "--install-nodejs takes 'true' or 'false'"
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

if [ $install_cscope = "true" ]; then
    ./install_cscope.sh
fi

if [ $install_ctags = "true" ]; then
    ./install_ctags.sh
fi

if [ $install_nodejs = "true" ]; then
    ./install_nodejs.sh
fi

mkdir ~/.config

cp -rf $PWD/.vimrc ~
#cp -rf $PWD/.vim/ ~
cp -rf $PWD/lint_config ~/.config

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Finish!!!!!!!!!!!!!!!!"

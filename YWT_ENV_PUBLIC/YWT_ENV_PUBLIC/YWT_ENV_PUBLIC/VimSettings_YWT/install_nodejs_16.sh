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
        echo "This script install nodejs 16.x from apt, because nodejs is prerequisite of copilot.vim"
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
    # ref: https://github.com/nodesource/distributions#debinstall ; https://nodejs.org/en/download/package-manager#debian-and-ubuntu-based-linux-distributions
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&\
        sudo apt-get install -y nodejs
else
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
        apt-get install -y nodejs
fi

#! /bin/bash


set -u # check if all variables have been set
ctags_dir="./pkgs/ctags"
install_dir="$1"  # First positional arg should be the preferred install directory of ctags

if [ -d $ctags_dir ]; then
    echo "$ctags_dir exists, continue"
else 
    echo "$ctags_dir not exists, you can clone ctags from https://github.com/universal-ctags/ctags.git, and move ctags to ./pkgs"
    exit 1
fi

if [[ $install_dir == *"/bin"* ]]; then
    echo "'make' will automatically install ctags to **/bin so prefered install directory should not contains /bin"
    exit 1
fi

# install dependencies of universal ctags, ref: https://docs.ctags.io/en/latest/autotools.html#gnu-linux-distributions
# install universal ctags, ref: https://docs.ctags.io/en/latest/autotools.html#building-with-configure-nix-including-gnu-linux
cd $ctags_dir
./autogen.sh
./configure --prefix="$install_dir" # defaults to /usr/local
make
make install # may require extra privileges depending on where to install

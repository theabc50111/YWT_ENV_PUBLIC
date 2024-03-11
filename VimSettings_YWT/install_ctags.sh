#! /bin/bash


set -u # check if all variables have been set
operator=$(whoami)

if [ "$operator" != "root" ]; then
    # install  dependencies of universal ctags, ref: https://docs.ctags.io/en/latest/autotools.html#gnu-linux-distributions
    sudo apt install -y gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
    # install universal ctags, ref: https://docs.ctags.io/en/latest/autotools.html#building-with-configure-nix-including-gnu-linux
    git clone https://github.com/universal-ctags/ctags.git
    cd ctags
    sudo ./autogen.sh
    #./configure --prefix=/where/you/want # defaults to /usr/local
    sudo ./configure  # defaults to /usr/local
    sudo make
    sudo make install # may require extra privileges depending on where to install
else 
    apt install -y gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev 
    # install universal ctags, ref: https://docs.ctags.io/en/latest/autotools.html#building-with-configure-nix-including-gnu-linux
    git clone https://github.com/universal-ctags/ctags.git
    cd ctags
    ./autogen.sh
    #./configure --prefix=/where/you/want # defaults to /usr/local
    ./configure  # defaults to /usr/local
    make
    make install # may require extra privileges depending on where to install
fi


cd ..
rm -rf ctags

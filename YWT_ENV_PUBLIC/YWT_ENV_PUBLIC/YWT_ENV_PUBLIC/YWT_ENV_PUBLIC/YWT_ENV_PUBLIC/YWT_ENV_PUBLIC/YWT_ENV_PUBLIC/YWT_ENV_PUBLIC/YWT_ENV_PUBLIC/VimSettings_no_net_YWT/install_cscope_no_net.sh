#!/bin/bash

set -u # check if all variables have been set
cscope_dir="./pkgs/cscope"
install_dir="$1"  # First positional arg should be the preferred install directory of cscope

if [ -d $cscope_dir ]; then
    echo "$cscope_dir exists, continue"
else 
    # You can find the download page in cscope official page : https://cscope.sourceforge.net/
    echo "$cscope_dir not exists, you can download cscope from ,https://sourceforge.net/projects/cscope/files/ and unzzip the cscope-x.x.tar.gz and rename cscope-x.x to cscope and move cscope to ./pkgs"
    exit 1
fi

if [[ $install_dir == *"/bin"* ]]; then
    echo "'make' will automatically install cscope to **/bin so prefered install directory should not contains /bin"
    exit 1
fi

cd $cscope_dir

# Check if automake version is 1.15
if [ "$(automake --version | grep -oE '[0-9]+\.[0-9]+')" != "1.15" ]; then
    echo "Automake version is not 1.15. Running autoreconf in $cscope_dir"
    autoreconf
else
    echo "Automake version is 1.15. No action needed."
fi

# Install cscope
./configure --prefix="$install_dir" # defaults to /usr/local
make
make install # may require extra privileges depending on where to install

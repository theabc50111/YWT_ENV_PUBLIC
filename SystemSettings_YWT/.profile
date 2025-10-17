# ~/.profile: executed by the command interpreter for login shells.                                                               
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# ywt setting aliases
alias saturn='ssh ywt01_dmlab@140.119.164.201 -p 10000'
alias mercury='ssh ywt01_dmlab@140.119.164.193 -p 10000'
alias mars='ssh ywt01_dmlab@140.119.164.201 -p 15000'
alias uranus='ssh ywt01_dmlab@140.119.164.193 -p 15000'

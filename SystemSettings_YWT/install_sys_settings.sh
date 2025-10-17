#! /bin/bash

set -u # make sure all varaible is set
operator=$(whoami)

if [ $# -eq 0 ]
then
    echo "Need at least one argument"
    echo "Required argument : --gnome"
    exit 0
fi


LONG_ARGUMENT_LIST=(
    "gnome:"  # `:` means require arguments
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
    --gnome)
      gnome="$2" # Note: In order to handle the argument containing space, the quotes around '$2': they are essential!
      shift 2 # The 'shift' eats a commandline argument, i.e. converts $1=a, $2=b, $3=c, $4=d into $1=b, $2=c, $3=d. shift 2 moves it all the way to $1=c, $2=d. It's done since that particular branch uses an argument, so it has to remove two things from the list (the -r and the argument following it) not just one.
      ;;

    -h|--help)
        echo "This script setting for tmux, zsh, bash, gnome"
        echo "--gnome takes 'true' or 'false'"
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


# check if gnome terminal profile settings is right
if [ "$gnome" = "true" ]; then
    if [ "$operator" != "root" ]; then
        sudo apt install -y bc
    else 
        apt install -y bc
    fi

    terminal_profile_list=($(gsettings get org.gnome.Terminal.ProfilesList list))
    terminal_profile_len=${#terminal_profile_list[@]}
    gnome_ver=$(gnome-terminal --version|grep  -Eo '[0-9]*\.[0-9]*'|head -1)

    if (( $(echo "$gnome_ver > 3.8" |bc -l) )) && [ $terminal_profile_len -le 1 ]; then
        echo "Because gnome version<3.8, so can't create gnome terminal profile by script, so please CREATE ONE gnome profile MANUALLY by GUI"
        exit 0
    fi
fi


# install packages with apt 
if [ "$operator" != "root" ]; then
    sudo apt-get update
    sudo apt install -y git curl wget zsh tmux sed
else
    apt-get update
    apt install -y git curl wget zsh tmux sed
fi

# make it yout default shell
chsh -s $(which zsh)

# install Oh-my-zsh
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# install zsh plugin
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


# install dracula scheme for zsh-highlighting
git clone https://github.com/dracula/zsh-syntax-highlighting.git
sed -i '61 r ./zsh-syntax-highlighting/zsh-syntax-highlighting.sh' .zshrc 
rm -rf zsh-syntax-highlighting

if [ "$gnome" = "true" ]; then
    # create gnome terminal profile
    gnome_terminal_profile_name="YWT_Dracula"
    source $PWD/create_gnome_terminal_profile.sh $gnome_terminal_profile_name

    # install dracula scheme for gnome terminal
    if [ "$operator" != "root" ];then
        sudo apt-get install -y dconf-cli
    else
        apt-get install -y dconf-cli
    fi

    git clone https://github.com/dracula/gnome-terminal
    ./gnome-terminal/install.sh --scheme Dracula --profile $gnome_terminal_profile_name --install-dircolors
	eval `dircolors /path/to/dircolorsdb`
    rm -rf gnome-terminal
    rm -rf dircolors
    rm -rf ~/.dir_colors/dircolors.old
else 
    echo "not setting gnome terminal !!!!!!!!!!!!!!"
fi;


cp -rf $PWD/.zshrc ~/
cp -rf $PWD/.bashrc ~/
cp -rf $PWD/.profile ~/
cp -rf $PWD/.tmux.conf ~/

# install TPM〔Tmux Plugin Manager〕
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
mkdir -p ~/.tmux/scripts
cp $PWD/tmux_scripts/* ~/.tmux/scripts/

git reset --hard

if [ "$operator" != "root" ]; then
    sudo cp $PWD/hosts $PWD/hosts.new
    sudo sed -i "s/#127.0.1.1 # revise to  your loscalhost hostname/127.0.0.1 $HOSTNAME/" $PWD/hosts.new
    sudo cp -rf $PWD/hosts.new /etc/hosts
    sudo rm -rf $PWD/hosts.new
else
    cp $PWD/hosts $PWD/hosts.new
    sed -i "s/#127.0.1.1 # revise to  your loscalhost hostname/127.0.0.1 $HOSTNAME/" $PWD/hosts.new
    cp -rf $PWD/hosts.new /etc/hosts
    rm -rf $PWD/hosts.new
fi

echo "Finish!!!!!!!!!!!!!!!!!!!!"

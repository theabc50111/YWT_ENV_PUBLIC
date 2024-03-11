# System settings


<details markdown="1">
  <summary  style="font-size:22px" >start script:</summary>

  - #### script name: ```install_sys_settings.sh```
  - e.g. : ```./install_sys_settings.sh```

</details>

<details markdown="1">
<summary  style="font-size:22px;" >file description:</summary>

- **```.hosts```** : used for IP DNS
  - store in ```/etc/hosts```
  - revise the loclahost name (first line of ```hosts```)
- **```.profile```** : YWT settings
  - including:
    - alias commands
    - PATH setting 
  - sotre in ```~/.profile``` 
- **```.bashrc```** : YWT non-logging bash settings
  - this script will automatically start ```~/.profile```
  - sotre in ```~/.bashrc``` 
- **```.zshrc```** : YWT non-logging zsh settings
  - this script will automatically start ```~/.profile```
  - sotre in ```~/.zshrc``` 
- **```.tmux.conf```** : YWT tmux setting
  - sotre in ```~/.tmux.conf``` 
  - [tmux shortcuts & cheatsheet](https://gist.github.com/MohamedAlaa/2961058)
- **```create_gnome_terminal_profile.sh```** : YWT create a gnome_terminal_profile
  - this script will be execuated in `install_sys_settings.sh` , and create a gnome_terminal_profile called *YWT_Dracula*
  

</details>

<hr>


# Vim settings
<details markdown="1">
  <summary  style="font-size:22px" >start script:</summary>

  - #### script name: ```install_vim.sh```
  - e.g. : ```./install_vimrc.sh```
  - #### script name: ```set_vimrc.sh```
  - e.g. : ```./set_vimrc.sh```

</details>

<details markdown="1">
<summary  style="font-size:22px" >file descirption:</summary>
    
- ```install_cscope.sh``` : install cscope
  - this script will be execuated in `install_vimrc.sh`
- ```install_ctags.sh``` : install universal ctags
  - this script will be execuated in `install_vimrc.sh`
- ```install_nodejs.sh``` : install nodejs for copilot.vim
  - this script will be execuated in `install_vimrc.sh`
- ```.vimrc``` : vim setting file
  - store in ```~/.vimrc```
- ```.vim/``` : folder consist of vim colorscheme file
  - sotre in ```~/.vim```
- ```lint_confg/.flake8``` : lint file of python
  - sotre in ```~/.config/lint_config/.flake8```
- ```lint_config/.pytlintrc``` : lint file of python
  - sotre in ```~/.config/lint_config/.pytlintrc```
</details>

<details markdown="1">
<summary  style="font-size:22px" >after install operation:</summary>
    
- ```:PlugInstall``` : install all pulg by [vim-plug](https://github.com/junegunn/vim-plug)

</details>

<hr>

# BackupScripts:

<details markdown="1">
<summary  style="font-size:22px" >file descirption:</summary>
    
- `rclone_check.sh` : used for check difference between sorce and destination
  - store in `~/.local/bin/rclone_check.sh`
- `rclone_remote_sync.sh` : used to sync local data to specific remote drive
  - sotre in `~/.local/bin/rclone_remote_sync.sh`
</details>
<hr>

# This repository include four dockerfiles:
## tensorflow:latest-gpu-jupyterlab
- _Dockerfile & start scrip & setting files:_ https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/tensorflow:latest-gpu-jupyterlab
- _docker hub:_ https://hub.docker.com/repository/docker/abc50111/tensorflow

## OpenCV:4.2.0
- _Dockerfile & start scrip & setting files:_ https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/opencv:4.2.0
- _docker hub:_ https://hub.docker.com/repository/docker/abc50111/opencv

## OpenCV:4.2.0-dlib-face_rec-cuda
- _Dockerfile & start scrip & setting files:_ https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/opencv:4.2.0-dlib-face_rec-cuda
- _docker hub:_ https://hub.docker.com/repository/docker/abc50111/opencv


## flask_YWT:dev-server
- _Dockerfile & start scrip & setting files:_ https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/flask_YWT:dev-server
- _docker hub:_ https://hub.docker.com/repository/docker/abc50111/flask-ywt

<hr>

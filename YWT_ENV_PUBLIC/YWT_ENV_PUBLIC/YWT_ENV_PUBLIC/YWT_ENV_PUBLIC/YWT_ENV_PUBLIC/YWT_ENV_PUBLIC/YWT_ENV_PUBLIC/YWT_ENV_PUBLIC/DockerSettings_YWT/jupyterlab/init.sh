#!/bin/bash
echo "start to initualization!!!!!!!"

# install common python pacakge
pip install -r /root/requirements.txt

# setting ip, password, allow-root of jupyter lab
mkdir -p ~/.jupyter
cp /root/jupyter_lab_config.py ~/.jupyter/ 

# setting autoload, autotime to ipython
ipython profile create
cp /root/ipython_kernel_config.py ~/.ipython/profile_default/


# Adjusted font-size & theme-color
mkdir -p ~/.jupyter/lab/user-settings/\@jupyterlab/apputils-extension
mv /root/themes.jupyterlab-settings ~/.jupyter/lab/user-settings/\@jupyterlab/apputils-extension/
 
# Adjusted codeCellconfig, e.g. lineNumber, LineWrapper
mkdir -p ~/.jupyter/lab/user-settings/\@jupyterlab/notebook-extension/
mv /root/tracker.jupyterlab-settings ~/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

# Before install following labextension, need to install npm & node.js
#jupyter labextension install @jupyterlab/toc
#jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-matplotlib
#jupyter labextension install @krassowski/jupyterlab_go_to_definition  

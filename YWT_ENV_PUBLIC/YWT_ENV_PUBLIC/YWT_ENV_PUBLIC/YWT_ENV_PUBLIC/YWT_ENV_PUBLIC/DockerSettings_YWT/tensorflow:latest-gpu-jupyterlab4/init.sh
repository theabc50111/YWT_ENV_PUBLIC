#!/bin/bash

pip install -r /root/requirements.txt

# setting ip, password, allow-root of jupyter lab
mkdir -p ~/.jupyter
cp /root/jupyter_lab_config.py ~/.jupyter/ 

# setting autoload, autotime to ipython
ipython profile create
cp /root/ipython_kernel_config.py ~/.ipython/profile_default/

# setting config of jupyterlab 4.0.2
mkdir -p ~/.jupyter/lab/
mv /root/user-settings ~/.jupyter/lab

# remove default tensorflow-tutorials
rm -rf /tf/tensorflow-tutorials;


# Before install following labextension, need to install npm & node.js
#jupyter labextension install @jupyterlab/toc
#jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-matplotlib
#jupyter labextension install @krassowski/jupyterlab_go_to_definition  

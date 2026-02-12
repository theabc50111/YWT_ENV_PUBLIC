From tensorflow/tensorflow:latest-gpu
LABEL maintainer="theabc50111@gmail.com"

COPY ["init.sh", "requirements.txt", "tracker.jupyterlab-settings", "ipython_kernel_config.py", "jupyter_lab_config.py", "themes.jupyterlab-settings", "/root/"]
RUN source /root/init.sh
WORKDIR /tf

CMD jupyter lab

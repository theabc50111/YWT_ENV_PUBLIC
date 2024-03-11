# YWT-customized Dockerfiles:

## tensorflow:latest-gpu-jupyterlab

<details markdown="1">
<summary style="font-size:20px; font-weight: bold;">start script:</summary>

#### script name: ```docker_jupyter```
#### script options:
```
-f) folder_path
-p) port
-n) container_name
-d) deamon
```
- e.g. : ```docker_jupyter -f ~/Documents/codes/ -p 16000 -n ywt-tf -d true```
</details>

<details markdown="1">
<summary style="font-size:20px; font-weight: bold;">include packages and customized settins:</summary>

- jupyter notebook with customized settings
- pandas
- scikit-learn
</details>

- ***Dockerfile & start scrip & settingfiles: https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/tensorflow:latest-gpu-jupyterlab***
- ***docker hub: https://hub.docker.com/repository/docker/abc50111/tensorflow*** 

<hr>

## flask_YWT:dev-server

<details style="font-size:20px; font-weight: bold;" markdown="1">
<summary>start script:</summary>

#### script name: ```docker_flask```
#### script options:
```
-f) folder_path
-p) port
```
- e.g. : ```docker_flask -f ~/Documents/codes/ -p 16000 ```
</details>

<details style="font-size:20px; font-weight: bold;" markdown="1">
<summary style="font-size:20px; font-weight: bold;">include packages and customized settins:</summary>

- vim
</details>

- ***Dockerfile & start scrip & setting files:_ https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/flask_YWT:dev-server***
- ***docker hub: https://hub.docker.com/repository/docker/abc50111/flask-ywt***

<hr>

## OpenCV:4.2.0

<details>
<summary style="font-size:20px; font-weight: bold;">start script</summary> 

#### script name: ```4.2.0_docker_run-set_env```
  - it’s an exectable file, execute it will automatically create container
  - remember to replace option of ```-v``` to change mounted dir 
  - https://github.com/theabc50111/YWT_ENV/blob/master/YWT_DockerSettings/opencv:4.2.0/4.2.0_docker_run-set_env
    
</details>

<details>
  <summary style="font-size:20px; font-weight: bold;">include packages and customized settins:</summary>

  - include OpenCV4.2.0 with customized settings by compiled by my self
</details>

- ***Dockerfile & start scrip & setting files: https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/opencv:4.2.0***
- ***docker hub: https://hub.docker.com/repository/docker/abc50111/opencv***

## OpenCV:4.2.0-dlib-face_rec-cuda

<details>
<summary style="font-size:20px; font-weight: bold;">start script</summary> 

#### script name: ```4.2.0-dlib-face_rec-cuda_docker_run-set_env```
  - it’s an exectable file, execute it will automatically create container
  - remember to replace option of ```-v``` to change mounted dir 
  - https://github.com/theabc50111/YWT_ENV/blob/master/YWT_DockerSettings/opencv:4.2.0-dlib-face_rec-cuda/4.2.0-dlib-face_rec-cuda_docker_run-set_env
    
</details>

<details>
<summary style="font-size:20px; font-weight: bold;">include packages and customized settins:</summary>

- include OpenCV4.2.0 with customized settings by compiled by my self
- include objective dlib
- include face-recognition(***python package***) which can be execuated by CUDA
</details>

<details>
<summary style="font-size:14px; font-weight: bold;"><i>note of using OpenCV:4.2.0-dlib-face_rec-cuda</i></summary>

- ### *before using OpenCV:4.2.0-dlib-face_rec-cuda,*
  - ***install nvidia-container-runtime(https://github.com/NVIDIA/nvidia-container-runtime)***<br>
  - ***remember to add --gpus all in docker run command***
- ### *set enviroment example :　(it's an exectable file, execute it will automatically create container)*
</details>

- ***Dockerfile & start scrip & setting files:
https://github.com/theabc50111/YWT_ENV/tree/master/YWT_DockerSettings/opencv:4.2.0-dlib-face_rec-cuda***
- ***docker hub: https://hub.docker.com/repository/docker/abc50111/opencv***
## Note

<details>
    <summary style="font-size:20px; font-weight: bold;">There are two ways to set enviroment to make container can show image</summary>

## 1. input the following code in terminal
```
$ xhost +local:docker
$ XSOCK=/tmp/.X11-unix
$ XAUTH=/tmp/.docker.xauth
$ xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
$ sudo docker run -it --device=/dev/video0　-e DISPLAY=$DISPLAY --env QT_X11_NO_MITSHM=1 \
-v $XSOCK:$XSOCK -v $XAUTH:$XAUTH \
-e XAUTHORITY=$XAUTH abc50111/opencv:tag command #(choose the image tag and command you need)
$ xhost -local:docker #Revoke Authority
```
## 2. input the following code in terminal
``` 
xhost +local:root 
docker run -it --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" abc50111/opencv:tag command #(choose the image tag and command you need)
```
##### Using the second way , you can't assaign a ip to your container, because it share the same ip with host 
</details>

<hr>

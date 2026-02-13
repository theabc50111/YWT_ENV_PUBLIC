FROM ubuntu:18.04
MAINTAINER YWT

ARG DEBIAN_FRONTEND=noninteractive

# update mirrors website
RUN sed -i "s|http://archive.ubuntu.com/ubuntu/|http://free.nchc.org.tw/ubuntu/ |g" /etc/apt/sources.list


# Essentials: developer tools, build tools, OpenBLAS
RUN apt-get update && apt-get upgrade -y --no-install-recommends && apt-get install --yes --no-install-recommends\
    apt-utils curl vim openssh-client openssh-server nano wget lsof \
    x11-apps ffmpeg eog \
    build-essential pkg-config git cmake unzip checkinstall \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libavresample-dev libgstreamer-plugins-bad1.0-dev \
    libxvidcore-dev libx264-dev \
    liblapacke-dev libopenblas-dev libeigen3-dev libatlas-base-dev gfortran \
    libhdf5-dev \
    libgtk-3-dev \
    libtbb-dev \
    libdc1394-22-dev \
    libcanberra-gtk-module libcanberra-gtk3-module gnupg

# install jpeg2000
RUN echo "deb http://ftp.fau.de/trinity/trinity-builddeps-r14.0.0/ubuntu/ bionic main" >> /etc/apt/sources.list.d/jasper.list
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN apt-key adv --keyserver keyserver.quickbuild.io --recv-keys F5CFC95C
RUN wget -q -P /home --no-check-certificate http://mirror.ppa.trinitydesktop.org/trinity/deb/trinity-keyring.deb
RUN dpkg -i /home/trinity-keyring.deb \
 && rm -f trinity-keyring.deb
RUN apt-get update && apt-get install --yes --no-install-recommends libjasper-dev

# python3.6
RUN apt-get install --yes --no-install-recommends  python3-dev
RUN wget -q -P /home --no-check-certificate  http://bootstrap.pypa.io/get-pip.py
RUN python3 /home/get-pip.py
RUN pip --no-cache-dir install testresources launchpadlib 
RUN apt-get install --yes --no-install-recommends  zlib1g-dev
RUN pip --no-cache-dir install Pillow
RUN pip --no-cache-dir install numpy scipy sklearn scikit-image pandas matplotlib imutils requests

# OpenCV 4.2.0
RUN cd /home \
 && mkdir OPENCV
RUN wget -q -P /home/OPENCV --no-check-certificate https://github.com/opencv/opencv/archive/4.2.0.tar.gz
RUN cd /home/OPENCV \
 && tar -xvf 4.2.0.tar.gz \
 && mv opencv-4.2.0 opencv \
 && rm -rf 4.2.0.tar.gz 
RUN wget -q -P /home/OPENCV --no-check-certificate https://github.com/opencv/opencv_contrib/archive/4.2.0.tar.gz
RUN cd /home/OPENCV \
 && tar -xvf 4.2.0.tar.gz \
 && mv opencv_contrib-4.2.0 opencv_contrib \
 && rm -rf 4.2.0.tar.gz
RUN cd /home/OPENCV/opencv \
 && mkdir build \ 
 && cd /home/OPENCV/opencv/build
RUN cd /home/OPENCV/opencv/build \
 && cmake -D CMAKE_BUILD_TYPE=RELEASE \
                  -D CMAKE_INSTALL_PREFIX=/usr/local \
                  -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
                  -D WITH_TBB=ON \
                  -D BUILD_TESTS=OFF \
                  -D OPENCV_ENABLE_NONFREE=ON \
                  -D INSTALL_PYTHON_EXAMPLES=ON \
                  -D BUILD_EXAMPLES=ON \
                  -D BUILD_JASPER=ON \
                  -D WITH_JASPER=ON \
                  -D OPENCV_IO_ENABLE_JASPER=1 ..|tee /home/cmake.txt
RUN cd /home/OPENCV/opencv/build \
 && make -j4 \
 && make install

# set environment variable(for JPEG-2000)
ENV OPENCV_IO_ENABLE_JASPER=1

###################################################################################################
# Python 3.5
#
## For convenience, alias (but don't sym-link) python & pip to python3 & pip3 as recommended in:
## http://askubuntu.com/questions/351318/changing-symlink-python-to-python3-causes-problems
#RUN apt-get install -y --no-install-recommends python3.5 python3.5-dev python3-pip python3-tk && \
#    pip3 install --no-cache-dir --upgrade pip setuptools && \
#    echo "alias python='python3'" >> /root/.bash_aliases && \
#    echo "alias pip='pip3'" >> /root/.bash_aliases
## Pillow and it's dependencies
#RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && \
#    pip3 --no-cache-dir install Pillow
## Science libraries and other common packages
#RUN pip3 --no-cache-dir install \
#    numpy scipy sklearn scikit-image pandas matplotlib imutils requests
####################################################################################################

#########################################################################################################
## Tensorflow - CPU
#
#RUN pip3 install --no-cache-dir --upgrade tensorflow 

## Expose port for TensorBoard
#EXPOSE 6006
##########################################################################################################

##########################################################################################################
## OpenCV 3.4.1
##S
#RUN wget -q -P /usr/local/src/ --no-check-certificate https://github.com/opencv/opencv/archive/3.4.1.zip
#RUN cd /usr/local/src/ \
# && unzip 3.4.1.zip \
# && rm 3.4.1.zip \
# && cd /usr/local/src/opencv-3.4.1/ \
# && mkdir build \
# && cd /usr/local/src/opencv-3.4.1/build \ 
# && cmake -D CMAKE_INSTALL_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local/ .. \
# && make -j4 \
# && make install \
#&& rm -rf /usr/local/src/opencv-3.4.1
##########################################################################################################

##########################################################################################################
## Keras
#
#RUN git clone --depth 1 https://github.com/fchollet/keras.git /usr/src/keras && \
#    pip install keras
##########################################################################################################


##########################################################################################################
## PyTorch 0.3.1
#
#RUN pip3 install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp35-cp35m-linux_x86_64.whl && \
#pip3 install torchvision
##########################################################################################################

##########################################################################################################
## Setting up working directory 
#RUN mkdir /js
#WORKDIR /js
##########################################################################################################

# Minimize image size 
RUN (apt-get autoremove --yes; \
apt-get autoclean --yes)

CMD ["/bin/bash"]

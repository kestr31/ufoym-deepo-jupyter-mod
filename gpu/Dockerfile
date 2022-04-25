FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04

COPY /scripts/docker-clean /etc/apt/apt.conf.d/docker-clean
COPY /scripts/sources.list /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# For nVidia GPU
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

ARG MATLAB_RELEASE=r2022a

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# --------------- DEEPO ---------------
# Install Dependencies
RUN apt-get update && apt-get -y --quiet install \
		build-essential \
		apt-utils \
		ca-certificates \
		wget \
		git \
		vim \
		libssl-dev \
		curl \
		unzip \
		unrar \
		cmake \
        && apt-get -y autoremove \
        && apt-get clean autoclean \
        && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Darknet
RUN git clone --depth 10 https://github.com/AlexeyAB/darknet ~/darknet \
	&& cd ~/darknet \
	&& sed -i 's/GPU=0/GPU=1/g' ~/darknet/Makefile \
	&& sed -i 's/CUDNN=0/CUDNN=1/g' ~/darknet/Makefile \
	&& make -j"$(nproc)" \
	&& cp ~/darknet/include/* /usr/local/include \
	&& cp ~/darknet/darknet /usr/local/bin

# Python, Chainer, Jupyter
RUN apt-get update && apt-get -y --quiet install \
		python3.8 \
		python3.8-dev \
		python3.8-distutils \
	&& wget -O ~/get-pip.py https://bootstrap.pypa.io/get-pip.py \
	&& python3.8 ~/get-pip.py \
	&& ln -s /usr/bin/python3.8 /usr/local/bin/python \
	&& python -m pip --no-cache-dir install --upgrade \
		numpy \
		scipy \
		pandas \
		scikit-image \
		scikit-learn \
		matplotlib \
		Cython \
		tqdm \
		cupy \
		chainer \
		jupyter \
		jupyterlab \
        && apt-get -y autoremove \
        && apt-get clean autoclean \
        && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Mxnet, ONNX, Paddle
RUN apt-get update && apt-get -y --quiet install \
		libatlas-base-dev \
		graphviz \
		protobuf-compiler \
		libprotoc-dev \
	&& python -m pip --no-cache-dir install --upgrade \
		mxnet-cu112 \
		graphviz \
		protobuf \
		onnx \
		onnxruntime-gpu \
		paddlepaddle-gpu \
        && apt-get -y autoremove \
        && apt-get clean autoclean \
        && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Pytorch
RUN python -m pip --no-cache-dir install --upgrade \
		future \
		enum34 \
		pyyaml \
		typing \
	&& python -m pip --no-cache-dir install --upgrade \
		--pre torch torchvision torchaudio -f \
		https://download.pytorch.org/whl/nightly/cu113/torch_nightly.html

# Tensorflow
RUN python -m pip --no-cache-dir install --upgrade \
		tensorflow-gpu

# --------------- Jupyterlab ---------------
# Install dependencies for Jupyterlab extensions
RUN apt-get update && apt-get -y --quiet install \
		npm \
	&& npm cache clean -f \
	&& npm install -g n \
	&& n lts \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Install Jupyterlab extensions
RUN mkdir -p ~/.jupyter/lab/workspaces \
	&& pip3 install ipympl \
	&& pip3 install ipywidgets \
	&& pip3 install aquirdturtle_collapsible_headings \
	&& pip3 install jupyterlab-drawio \
	&& pip3 install --upgrade jupyterlab-git \
	&& pip3 install jupyterlab_latex \
	&& pip3 install jupyterlab-lsp \
	&& pip3 install jupyterlab-system-monitor \
	&& pip3 install lckr-jupyterlab-variableinspector \
	&& pip3 install jupyterlab_latex \
	&& jupyter labextension install jupyterlab-spreadsheet \
	&& jupyter labextension install @krassowski/jupyterlab_go_to_definition

COPY /config/jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py

WORKDIR /root/.jupyter/lab/workspaces

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 8888 6006

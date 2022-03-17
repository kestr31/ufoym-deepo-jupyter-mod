FROM ufoym/deepo:all-jupyter-cu113

COPY /scripts/docker-clean /etc/apt/apt.conf.d/docker-clean
COPY /scripts/sources.list /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# For nVidia GPU
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["jupyter", "lab", "--config=/root/.jupyter/jupyter_lab_config.py"]

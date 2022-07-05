#!/bin/bash

# Change Directory
cd /root/.jupyter

# Generate OpenSSL Certificate Valid for 730 Days
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
-subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
-keyout jupyter.key -out jupyter.cert 

# RUN  SSH
service ssh restart

# Run Jupyter Lab
jupyter lab --config=/root/.jupyter/jupyter_lab_config.py

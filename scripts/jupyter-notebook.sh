#!/bin/bash
#

# Jupyter Docker in Docker Umgebung - obsolet
microk8s kubectl delete -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base-microk8s.yaml 
microk8s kubectl delete -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml
#microk8s kubectl apply  -f https://raw.githubusercontent.com/mc-b/duk/v2.1/addons/deny-port.yaml

# HACK: switch Branch 2.1
cd ~/duk
git switch v2.1
cp -rpv data/* /data/
cd -

# neue Jupyter Umgebung, Docker ist lokal auf VM

sudo apt-get install -y jupyter-notebook

ln -s /data/jupyter work

cat <<%EOF% | sudo tee /etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/usr/bin/jupyter notebook --ip=0.0.0.0 --port=32188 --no-browser --NotebookApp.token='' --NotebookApp.password=''
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
%EOF%

sudo systemctl daemon-reload
sudo systemctl enable jupyter.service
sudo systemctl restart jupyter.service

# lernkube Public Key
curl https://raw.githubusercontent.com/mc-b/lerncloud/main/ssh/lerncloud >~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
 
       
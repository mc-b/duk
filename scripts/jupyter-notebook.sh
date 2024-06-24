#!/bin/bash
#

# Jupyter Docker in Docker Umgebung - obsolet
microk8s kubectl delete -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base-microk8s.yaml 
microk8s kubectl delete -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml
microk8s kubectl apply  -f https://raw.githubusercontent.com/mc-b/duk/v2.1/addons/deny-port.yaml

# neue Jupyter Umgebung, Docker ist lokal auf VM

sudo apt install -y python3-pip
pip install jupyter
ln -s /data/jupyter work

cat <<%EOF% | sudo tee /etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/home/ubuntu/.local/bin/jupyter notebook --ip=0.0.0.0 --port=32188 --no-browser --NotebookApp.token='' --NotebookApp.password=''
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/work
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
%EOF%

sudo systemctl daemon-reload
sudo systemctl enable jupyter.service
sudo systemctl restart jupyter.service

cd /tmp && wget -q https://github.com/itaysk/kubectl-neat/releases/download/v2.0.2/kubectl-neat_linux.tar.gz && \
    tar xzf kubectl-neat_linux.tar.gz && \
    sudo mv kubectl-neat /usr/local/bin && \
    rm kubectl-neat_linux.tar.gz

cd /tmp && wget -q https://github.com/tohjustin/kube-lineage/releases/download/v0.5.0/kube-lineage_linux_amd64.tar.gz && \
    tar xzf kube-lineage_linux_amd64.tar.gz && \
    sudo mv kube-lineage /usr/local/bin/ && \
    rm kube-lineage_linux_amd64.tar.gz 
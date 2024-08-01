#!/bin/bash
#

# neue Jupyter Umgebung, Docker ist lokal auf VM
sudo apt-get install -y  --no-install-recommends jupyter-notebook python3-venv uuid

# Python3 Libraries
sudo apt-get install -y python3-flask python3-setproctitle python3-requests python3-paho-mqtt \
                        python3-matplotlib python3-numpy python3-sklearn python3-pandas python3-seaborn 

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

# SSH keine Verwendung von .ssh/known_hosts
cat <<EOF >~/.ssh/config
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
LogLevel error
EOF

# Eindeutige UUID pro Installation fuer IoT
echo "UUID=\"$(uuid)\"" >~/work/uuid.py

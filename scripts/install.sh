#!/bin/bash
#
#	Installationsscript duk

# Jupyter Docker in Docker Umgebung
microk8s kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base-microk8s.yaml 
microk8s kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml

# Jupyter Scripte etc. Allgemein verfuegbar machen
cp -rpv data/* /data/

# IP fuer Notebooks
export ADDR=$(ip -f inet addr show wg0 | grep -Po 'inet \K[\d.]+')

if [ "${ADDR}" != "" ]
then
    echo ${ADDR} >/data/jupyter/server-ip
else
    echo $(hostname -I | cut -d ' ' -f 1) >/data/jupyter/server-ip
fi 
chown ubuntu:ubuntu /data/jupyter/server-ip

# bei Reboot VM wieder richtig setzen
cat <<%EOF% >>/home/ubuntu/.bashrc
export ADDR=$(ip -f inet addr show wg0 | grep -Po 'inet \K[\d.]+')

if [ "\${ADDR}" != "" ]
then
    echo \${ADDR} >/data/jupyter/server-ip
else
    echo \$(hostname -I | cut -d ' ' -f 1) >/data/jupyter/server-ip
fi 

microk8s config >~/.kube/config
%EOF%





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

# AWS Public Hostname
export ADDR=$(curl -s --max-time 2 http://169.254.169.254/latest/meta-data/public-hostname)
[ "${ADDR}" != "" ] && {  echo ${ADDR} >/data/jupyter/server-ip; }

chown ubuntu:ubuntu /data/jupyter/server-ip

# bei Reboot VM wieder richtig setzen
cat <<%EOF% >>/home/ubuntu/.bashrc
export ADDR=\$(ip -f inet addr show wg0 | grep -Po 'inet \K[\d.]+')

if [ "\${ADDR}" != "" ]
then
    echo \${ADDR} >/data/jupyter/server-ip
else
    echo \$(hostname -I | cut -d ' ' -f 1) >/data/jupyter/server-ip
fi 

# AWS Public Hostname
export ADDR=\$(curl -s --max-time 1 http://169.254.169.254/latest/meta-data/public-hostname)
[ "\${ADDR}" != "" ] && {  echo \${ADDR} >/data/jupyter/server-ip; }  

microk8s config >~/.kube/config
%EOF%

# unshare, nsenter in History
cat <<%EOF% >>/home/ubuntu/.bash_history
lsns
pstree -n -p -T -A
sudo unshare -n -p --fork --mount-proc sh
kubectl run birdpedia --restart=Never --image=registry.gitlab.com/mc-b/birdpedia/birdpedia:1.0-alpine
%EOF%




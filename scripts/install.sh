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

# Azure Cloud Public Hostname
RC=$(curl -w "%{http_code}" -o /dev/null -s --max-time 3 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network/interface?api-version=2021-02-01')
if [ "$RC" == "200" ]
then
    curl -s --max-time 2 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network?api-version=2021-02-01' | jq '.interface[0].ipv4.ipAddress[0].publicIpAddress' | tr -d '"' >/data/jupyter/server-ip 
fi

# AWS Cloud Public Hostname
RC=$(curl -w "%{http_code}" -o /dev/null -s --max-time 3 http://169.254.169.254/latest/meta-data/public-hostname)
if [ "$RC" == "200" ]
then
    curl -s --max-time 2 http://169.254.169.254/latest/meta-data/public-hostname >/data/jupyter/server-ip
fi

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

# Azure Cloud Public Hostname
RC=\$(curl -w "%{http_code}" -o /dev/null -s --max-time 1 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network/interface?api-version=2021-02-01')
if [ "\$RC" == "200" ]
then
    curl -s --max-time 1 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network?api-version=2021-02-01' | jq '.interface[0].ipv4.ipAddress[0].publicIpAddress' | tr -d '"' >/data/jupyter/server-ip 
fi

# AWS Cloud Public Hostname
RC=\$(curl -w "%{http_code}" -o /dev/null -s --max-time 1 http://169.254.169.254/latest/meta-data/public-hostname)
if [ "\$RC" == "200" ]
then
    curl -s --max-time 1 http://169.254.169.254/latest/meta-data/public-hostname >/data/jupyter/server-ip
fi

microk8s config >~/.kube/config
%EOF%

# unshare, nsenter in History
cat <<%EOF% >>/home/ubuntu/.bash_history
sudo cloud-init status
sudo less /var/log/cloud-init-output.log
microk8s add-node --token-ttl 3600
echo 'Auf den Worker(n): sudo mount -t nfs dukmaster-10-default:/data /data'
kubectl run birdpedia --restart=Never --image=registry.gitlab.com/mc-b/birdpedia/birdpedia:1.0-alpine
sudo unshare -n -p --fork --mount-proc sh
pstree -n -p -T -A
lsns
%EOF%

# Load Balancer enablen
ping -c 1 dukmaster-10-default.mshome.net >/dev/null
if [ $? -eq 0 ]
then
    # Abfangen, dass microk8s noch nicht bereit ist
    microk8s status --wait-ready
    microk8s kubectl wait --for=condition=Ready pod -l app=jupyter-base
    $(hostname -I | awk -F. '{ printf("microk8s enable metallb:%d.%d.%d.1/20\n", $1, $2, $3 ) }')
fi   





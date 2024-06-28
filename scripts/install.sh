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
# Enable LoadBalancer
\$(hostname -I | awk -F. '{ printf("microk8s enable metallb:%d.%d.%d.1/20\n", \$1, \$2, \$3 ) }')
# Helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-wp bitnami/wordpress
# Operator Pattern
git clone https://gitlab.com/ch-tbz-hf/Stud/v-cnt.git 
cd v-cnt/2_Unterrichtsressourcen/I/custom/
kubectl apply -f resourcedefinition.yaml -f myservice-operator-rbac.yaml -f myservice-operator.yaml
# Cloud-init
sudo cloud-init status
sudo less /var/log/cloud-init-output.log
# Join Cluster
microk8s add-node --token-ttl 3600; echo ""; echo "Auf den Worker(n) ausfuehren: sudo mount -t nfs dukmaster-10-default:/data /data"
# Linux Namespaces
kubectl run birdpedia --restart=Never --image=registry.gitlab.com/mc-b/birdpedia/birdpedia:1.0-alpine
sudo unshare -n -p --fork --mount-proc sh
pstree -n -p -T -A
lsns
%EOF%

# Docker fuer Security Uebungen
sudo apt-get install -y docker.io
sudo usermod -aG docker ubuntu 

# Containers Tools fuer Uebungen (ab Ubuntu 22.x)
sudo apt-get install -y podman podman-compose buildah skopeo 

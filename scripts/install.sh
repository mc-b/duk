#!/bin/bash
#
#	Installationsscript duk

# Jupyter Docker in Docker Umgebung - ab Version v2.1 obsolet
# microk8s kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base-microk8s.yaml  
# microk8s kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml

# Jupyter Scripte etc. Allgemein verfuegbar machen
cp -rpv data/* /data/

# Abfrage des Cloud-Namens mit cloud-init
CLOUD_NAME=$(sudo cloud-init query v1.cloud_name)

# Setzen der Variable HOST basierend auf CLOUD_NAME
case $CLOUD_NAME in
  "aws" | "gcloud")
    ADDR=$(sudo cloud-init query ds.meta_data.public_hostname)
    ;;
  "azure")
    ADDR=$(jq -r '.ds.meta_data.imds.network.interface[0].ipv4.ipAddress[0].publicIpAddress' /run/cloud-init/instance-data.json 2>/dev/null)
    ;;    
  "maas")
    ADDR=$(hostname -I | cut -d ' ' -f 1)
    ;;
  "multipass")
    ADDR=$(hostname)".mshome.net"
    ;;
  *)
    ADDR=$(hostname -I | cut -d ' ' -f 1)
    ;;
esac
echo ${ADDR} >/data/jupyter/server-ip

# Wireguard IP hat Vorrang vor allen anderen
ADDR=$(ip -f inet addr show wg0 2>/dev/null | grep -Po 'inet \K[\d.]+') 
[ "${ADDR}" != "" ] && { echo ${ADDR} >/data/jupyter/server-ip; }

chown ubuntu:ubuntu /data/jupyter/server-ip

# bei Reboot VM wieder richtig setzen
cat <<%EOF% >>/home/ubuntu/.bashrc
CLOUD_NAME=\$(sudo cloud-init query v1.cloud_name)
case \$CLOUD_NAME in
  "aws" | "azure" | "gcloud")
    ADDR=\$(sudo cloud-init query ds.meta_data.public_hostname)
    ;;
  *)
    ADDR=\$(hostname -I | cut -d ' ' -f 1)
    ;;
esac
echo \${ADDR} >/data/jupyter/server-ip
ADDR=\$(ip -f inet addr show wg0 2>/dev/null | grep -Po 'inet \K[\d.]+') 
[ "\${ADDR}" != "" ] && { echo \${ADDR} >/data/jupyter/server-ip; }

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

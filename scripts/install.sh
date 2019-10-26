#!/bin/bash
#
#	Installationsscript dok

# Jupyter Docker in Docker Umgebung
docker pull jupyter/base-notebook
kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base.yaml 
kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml

# Jupyter Scripte etc. Allgemein verfuegbar machen
cp -rpv data/* /data/

# User snoopy anlegen
# User snoopy anlegen

openssl genrsa -out snoopy.pem 2048
openssl req -new -key snoopy.pem -out snoopy.csr -subj "/CN=snoopy"

cat <<%EOF% | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: user-request-snoopy
spec:
  groups:
  - system:authenticated
  request: $(cat snoopy.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - client auth
%EOF%

kubectl certificate approve user-request-snoopy
kubectl get csr user-request-snoopy -o jsonpath='{.status.certificate}' | base64 -d > snoopy.crt

mkdir .kube
kubectl --kubeconfig .kube/config-snoopy config set-cluster kubernetes --insecure-skip-tls-verify=true --server=https://$(hostname -I | cut -d ' ' -f 2):6443
kubectl --kubeconfig .kube/config-snoopy config set-credentials snoopy --client-certificate=snoopy.crt --client-key=snoopy.pem --embed-certs=true

kubectl --kubeconfig .kube/config-snoopy config set-context snoopy --cluster=kubernetes --user=snoopy 
kubectl --kubeconfig .kube/config-snoopy config use-context snoopy

kubectl apply -f rbac/

kubectl describe secret $(kubectl get secret | grep snoopy | awk '{print $1}') >dashboard-snoopy.txt
#!/bin/bash
#
#	Installationsscript dok

# Jupyter Docker in Docker Umgebung
kubectl create namespace jupyter
kubectl create -f https://raw.githubusercontent.com/mc-b/devops/master/kubernetes/jupyter/jupyter-base.yaml -n jupyter
kubectl create -f https://raw.githubusercontent.com/mc-b/devops/master/kubernetes/jupyter/dind.yaml -n jupyter

# Jupyter Scripte etc. Allgemein verfuegbar machen
cp -rpv data/* /data/
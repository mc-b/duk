#!/bin/bash
#
#	Installationsscript dok

# Jupyter Docker in Docker Umgebung
docker pull misegr/base-notebook
kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/jupyter-base.yaml 
kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/jupyter/dind.yaml

# Jupyter Scripte etc. Allgemein verfuegbar machen
cp -rpv data/* /data/

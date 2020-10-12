# Copyright (c) Marcel Bernet, mc-b.ch
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="mc-b <marcel.bernet@mc-b.ch>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    curl \
    wget \
    vim \
    netcat \
    unzip \
    nano \
    mosquitto-clients \
    tar \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && wget -q https://github.com/itaysk/kubectl-neat/releases/download/v2.0.1/kubectl-neat_linux.tar.gz && \
    tar xzf kubectl-neat_linux.tar.gz && \
    mv kubectl-neat /usr/local/bin && \
    rm kubectl-neat_linux.tar.gz

RUN cd /tmp && wget -q https://download.docker.com/linux/static/stable/x86_64/docker-18.09.8.tgz && \
    tar xzf docker-18.09.8.tgz && \
    mv docker/docker /usr/local/bin && \
    rm docker-18.09.8.tgz

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

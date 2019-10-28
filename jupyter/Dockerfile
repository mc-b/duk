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
    bsdtar \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
FROM ubuntu:17.10

# C++ Compiler
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  gcc-arm-none-eabi \
  git \
  mercurial \
  python \
  python-pip \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*
  
# mbed-cli
RUN pip install mbed-cli PrettyTable

# Toolchain and K64F Board 
RUN	mbed toolchain -G GCC_ARM && mbed config --global TARGET K64F && mbed config --global TOOLCHAIN GCC_ARM && mbed config --list

# build mbed static library
RUN mkdir -p /opt/mbed
WORKDIR /opt/mbed
RUN mbed new . && mbed compile --library --no-archive --source=mbed-os --build=../mbed-os
COPY compile /usr/local/bin
RUN chmod 755 /usr/local/bin/compile

RUN mkdir /src
WORKDIR /src  
  
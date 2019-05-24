FROM ubuntu:18.10

# C++ Compiler
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  git \
  mercurial \
  python2.7 \
  python-pip \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*
  
# GCC_ARM
WORKDIR /opt
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 -O gcc-arm.tar.bz2 && \
    tar xvjf gcc-arm.tar.bz2 && \
    rm gcc-arm.tar.bz2
    ln ln -s gcc-arm-none-eabi-6-2017-q2-update/ gcc-arm 
  
# mbed-cli
RUN pip install mbed-cli PrettyTable

# Toolchain and K64F Board 
RUN	mbed toolchain -G GCC_ARM && \
    mbed config --global TOOLCHAIN GCC_ARM && \
    mbed config --global TOOLCHAIN GCC_ARM && \
    mbed config --global GCC_ARM_PATH /opt/gcc-arm/bin
    mbed config --list

# build mbed static library
RUN mbed import http://os.mbed.com/teams/IoTKitV3/code/template/
WORKDIR /opt/template

# K64F Board - Libraries 
RUN mbed compile -m k64f

# NUCLEO_F303RE Board - Libraries
RUN mbed compile -m nucleo_f303re

# NUCLEO_F411RE Board - Libraries
RUN mbed compile -m nucleo_f411re

# DISCO_L475VG_IOT01A Board - Libraries 
RUN mbed compile -m DISCO_L475VG_IOT01A

# helper script compile
COPY compile /usr/local/bin
RUN chmod 755 /usr/local/bin/compile

RUN mkdir /src
WORKDIR /src

ENTRYPOINT ["/usr/local/bin/mbed"]
  
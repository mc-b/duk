FROM ubuntu:17.10

# C++ Compiler
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  git \
  mercurial \
  python2.7 \
  python-pip \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*
  
RUN add-apt-repository ppa:team-gcc-arm-embedded/ppa
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gcc-arm-none-eabi  
  
# mbed-cli
RUN pip install mbed-cli PrettyTable

# Toolchain and K64F Board 
RUN	mbed toolchain -G GCC_ARM && mbed config --global TOOLCHAIN GCC_ARM && mbed config --list

# build mbed static library
RUN mkdir -p /opt/mbed
WORKDIR /opt/mbed

# init mbed project with mbed OS latest

RUN mbed import http://os.mbed.com/teams/IoTKitV3/code/template/
WORKDIR /opt/mbed/template

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
  
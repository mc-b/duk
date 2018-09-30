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
RUN	mbed toolchain -G GCC_ARM && mbed config --global TARGET K64F && mbed config --global TOOLCHAIN GCC_ARM && mbed config --list

# build mbed static library
RUN mkdir -p /opt/mbed
WORKDIR /opt/mbed
# init mbed project with mbed OS latest
RUN mbed new . 
# add libraries
RUN mbed add http://developer.mbed.org/users/AtomX/code/MFRC522/ 
RUN mbed add http://developer.mbed.org/teams/smdiotkitch/code/OLEDDisplay/
RUN mbed add https://mbed.org/teams/mqtt/code/MQTT/
RUN mbed add https://os.mbed.com/teams/IoTKitV3/code/HTS221lib/
RUN mbed add https://os.mbed.com/teams/IoTKitV3/code/QEI/
RUN mbed add https://developer.mbed.org/teams/Bluetooth-Low-Energy/code/BLE_API/
RUN mbed add https://mbed.org/teams/Nordic-Semiconductor/code/nRF51822/
RUN mbed add http://developer.mbed.org/users/highroads/code/VL6180x/
RUN cd mbed-os; git checkout refs/tags/mbed-os-5.9.7
RUN mbed add https://github.com/ARMmbed/esp8266-driver.git
# RUN sed -i -e"s/ESP8266_VERSION 2/ESP8266_VERSION 1/" esp8266-driver/ESP8266Interface.cpp
RUN sed -i -e"s/ESP8266_SDK_VERSION 2000000/ESP8266_SDK_VERSION 1000000/" esp8266-driver/ESP8266/ESP8266.h
# compile all
RUN mbed compile --library --no-archive --source=mbed-os --source MFRC522 --source esp8266-driver --source OLEDDisplay --source MQTT --source HTS221lib \
	             --source QEI --source BLE_API --source nRF51822 --source VL6180x --build=../mbed-os
COPY compile /usr/local/bin
RUN chmod 755 /usr/local/bin/compile

RUN mkdir /src
WORKDIR /src

ENTRYPOINT ["/usr/local/bin/mbed"]
  
#!/bin/bash

if [ -z $SUDO_USER ]; # if SUDO_USER is empty, user is root
then
    USER_HOME=$HOME # USER_HOME="/root"
else
    USER_HOME=$(eval echo ~${SUDO_USER}) # USER_HOME="/home/username"
fi

if [ ! -d "/usr/share/nmap/scripts/nmap-vulners" ]; # if NOT exists
then
    sudo git clone https://github.com/vulnersCom/nmap-vulners.git /usr/share/nmap/scripts/nmap-vulners
    sudo ln -s /usr/share/nmap/scripts/nmap-vulners/vulners.nse /usr/share/nmap/scripts/vulners.nse
else
    cd /usr/share/nmap/scripts/nmap-vulners
    git pull
fi

if [ ! -d "/usr/share/nmap/scripts/vulscan" ]; # if NOT exists
then
    sudo git clone https://github.com/scipag/vulscan.git /usr/share/nmap/scripts/vulscan
    sudo ln -s /usr/share/nmap/scripts/vulscan/vulscan.nse /usr/share/nmap/scripts/vulscan.nse
else
    cd /usr/share/nmap/scripts/vulscan
    sudo git pull
fi

sudo nmap --script-updatedb
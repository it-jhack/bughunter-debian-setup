#!/bin/bash -i
# -i = to make 'source' command work within the script

####################################################

if [ -z $SUDO_USER ]; # if SUDO_USER is empty, user is root
then
    USER_HOME=$HOME # USER_HOME="/root"
else
    USER_HOME=$(eval echo ~${SUDO_USER}) # USER_HOME="/home/username"
fi

####################################################
# Script to install GUI programs

# Adding qBitTorrent package (no updates on this method)
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y

# apt && apt-get update/upgrade
sudo apt update && apt upgrade -y
sudo apt-get update && apt-get upgrade -y

# install qBitTorrent
sudo apt-get install qbittorrent -y
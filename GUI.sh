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

# Adding packages
## qBitTorrent
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
## Atom Editor
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
## Sublime Merge
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# apt && apt-get update/upgrade
sudo apt update && apt upgrade -y
sudo apt-get update && apt-get upgrade -y

# apt-get installations
sudo apt-get install qbittorrent -y
sudo apt-get install wireshark -y
sudo apt-get install kolourpaint -y
sudo apt-get install sublime-merge -y

# apt installations
sudo apt install atom -y

# Other Package Managers
sudo snap install discord
sudo snap install colorpicker-app

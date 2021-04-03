#!/bin/bash -i
# -i = to make 'source' command work within the script

if [ -z $SUDO_USER ]; # if SUDO_USER is empty, user is root
then
    USER_HOME=$HOME # USER_HOME="/root"
else
    USER_HOME=$(eval echo ~${SUDO_USER}) # USER_HOME="/home/username"
fi

# Doing Config Files Backup
cd $USER_HOME
timestamp=$(date +"%y%m%d-%H%M%S")
mkdir $timestamp-backup-config
cp .bashrc $timestamp-backup-config
cp .profile $timestamp-backup-config
cp -r .config $timestamp-backup-config

# Download Links
# url example = https://golang.org/dl/go1.16.2.linux-amd64.tar.gz

# Golang Download/Installation/Path settings
echo "GOLANG INSTALLATION:"
echo -n "Install Golang (y/n)? "
read install_go
if [ $install_go == "y" ];
then
    echo -n "Enter Golang (for Debian/Linux) download URL (example: https://golang.org/dl/go1.16.2.linux-amd64.tar.gz): "
    read go_url
    go_filename=${go_url##*/} # strip last part of $go_url

    cd $USER_HOME/Downloads

    # Downloading Golang
    wget $go_url

    # Extract/Install Golang
    rm -rf /usr/local/go && tar -C /usr/local -xzf $go_filename

    # Setting user go workspace
    if [ ! -d "$USER_HOME/go" ]; # if NOT exists
    then
        mkdir $USER_HOME/go
        cd $USER_HOME/go
        mkdir src pkg bin
    else # if exists
        cd $USER_HOME/go
        if [ ! -d "$USER_HOME/go/src" ]; then mkdir $USER_HOME/go/src; fi
        if [ ! -d "$USER_HOME/go/pkg" ]; then mkdir $USER_HOME/go/pkg; fi
        if [ ! -d "$USER_HOME/go/bin" ]; then mkdir $USER_HOME/go/bin; fi
    fi
    
    # Exporting Golang path on ~/.bashrc
    echo "" >> $USER_HOME/.bashrc
    echo "export GOPATH=$USER_HOME/go" >> $USER_HOME/.bashrc
    echo "export PATH=\$PATH:/usr/local/go/bin" >> $USER_HOME/.bashrc
    source $USER_HOME/.bashrc # load changes

    # Adding go to root's bin, so you can exec go as sudo
    if [ $USER_HOME != "/root" ];
    then
        cd /usr/local/go/bin
        sudo cp go /bin
        sudo cp gofmt /bin
    fi

    echo "User Go version:"
    go version
    echo "root Go version:"
    sudo go version
fi

echo ""
echo "######################################################"
echo " Some API keys are required to run programs smoothly."
echo " API keys will be appended to: $USER_HOME/.profile"
echo ""
echo " Required APIs (free):"
echo "     - None (yet)"
echo ""
echo " Optional:"
echo "     - spyse.com"
echo ""
echo " WARNING:"
echo " API keys are sensitive information and should be"
echo " treated as passwords. Check this script code on an"
echo " editor if you don't trust its source."
echo "######################################################"
echo ""

# SPYSE API key [Optional]
echo -n "[Optional] Enter your spyse.com API key (used on 'assetfinder') or just press Enter: "
read spyse_api

####################################################
#PACKAGE MANAGERS

# apt && apt-get update/upgrade
sudo apt update && apt upgrade -y
sudo apt-get update && apt-get upgrade -y

# install snap
sudo apt install snapd -y

# apt packages
sudo apt install git -y
sudo apt install python3-pip -y
sudo apt install mlocate -y
sudo updatedb #necessary for 'locate' (mlocate) to work

# apt-get packages
sudo apt-get install jq -y
sudo apt-get install tree -y

# Golang packages
sudo snap install amass # -y flag not needed

# Nuclei by ProjectDiscovery
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
nuclei -version
nuclei -update-templates

# hakrawler by hakluke
go get github.com/hakluke/hakrawler

# assetfinder by tomnomnom
go get -u github.com/tomnomnom/assetfinder

# httprobe by tomnomnom
go get -u github.com/tomnomnom/httprobe

# subfinder by projectdiscovery
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder


####################################################
# Python

# pip3 packages
pip3 install requests

# EyeWitness
if [ ! -d "$USER_HOME/bugbounty" ]; then mkdir $USER_HOME/bugbounty; fi
if [ ! -d "$USER_HOME/bugbounty/+tools" ]; then mkdir $USER_HOME/bugbounty/+tools; fi
cd $USER_HOME/bugbounty/+tools
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd EyeWitness/Python/setup
sudo ./setup.sh
echo "" >> $USER_HOME/.bashrc
echo "alias eyewitness=\"\$HOME/bugbounty/+tools/EyeWitness/Python/EyeWitness.py\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

### Other Programming Languages
cd $USER_HOME/bugbounty/+tools
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
echo "" >> $USER_HOME/.bashrc
echo "alias massdns=\"\$HOME/bugbounty/+tools/massdns/bin/massdns\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc


### WRITING APIs
echo "" >> $USER_HOME/.profile #append blank line

#assetfinder
if [ -z "$spyse_api" ] # if spyse_api is empty
then
    echo "User opted not to provide spyse.com API key"
else
    echo "" >> $USER_HOME/.profile
    echo "#assetfinder" >> $USER_HOME/.profile
    echo "export SPYSE_API_TOKEN=\"$spyse_api\"" >> $USER_HOME/.profile
fi

# Update ~/.profile
source $USER_HOME/.profile
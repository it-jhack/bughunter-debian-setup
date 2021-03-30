#!/bin/bash

if [ -z $SUDO_USER ]; # if SUDO_USER is empty, user is root
then
    USER_HOME=$HOME # USER_HOME="/root"
else
    USER_HOME=$(eval echo ~${SUDO_USER}) # USER_HOME="/home/username"
fi

# Download Links
# url example = https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz

# Golang download
echo -n "Enter Golang (for Debian/Linux) download URL (example: https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz): "
read go_url
go_filename=${go_url##*/} # strip last part of $go_url

# Shodan.io API to create environment var
echo -n "Enter your shodan.io API key (free registration): "
read shodan_api

# VirusTotal API key
echo -n "Enter your virustotal.com API key (free registration): "
read virustotal_api

# SPYSE API key [Optional]
echo -n "[Optional] Enter your spyse.com API key (used on 'assetfinder'): "
read spyse_api

####################################################
#PACKAGE MANAGERS

# apt && apt-get update/upgrade
apt update && apt upgrade -y
apt-get update && apt-get upgrade -y

# install snap
apt install snapd -y

# apt packages
apt install git -y
apt install python3-pip -y
apt install mlocate -y
updatedb #necessary for 'locate' (mlocate) to work

# apt-get packages
apt-get install jq -y
apt-get install tree -y

####################################################
#GOLANG

# Creating script_download folder
cd $USER_HOME
mkdir script_downloads
cd script_downloads

# Downloading Golang
curl $go_url

# Extracting Golang
rm -rf /usr/local/go && tar -C /usr/local -xzf $go_filename

# Creating Golang path on ~/.bashrc
echo "" >> $USER_HOME/.bashrc
echo "export GOPATH='$USER_HOME/go'"
echo "export PATH=\$PATH:$GOPATH/bin" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc # load changes

# Golang packages
snap install amass # -y flag not needed

# Nuclei
cd $USER_HOME/go/pkg/mod/github.com/
mkdir projectdiscovery
cd projectdiscovery
git clone https://github.com/projectdiscovery/nuclei.git
cd nuclei/v2/cmd/nuclei
go build
mv nuclei /usr/local/bin/
nuclei -version
nuclei -update-templates

# shosubgo (shodan subdomain enumerator)
cd $USER_HOME/go/pkg/mod/github.com/
mkdir shosubgo
cd shosubgo
curl -LJO https://github.com/pownx/shosubgo/releases/download/1.1/shosubgo_linux_1_1
chmod +x shosubgo_linux_1_1
echo "" >> $USER_HOME/.profile
echo "export SHODAN_API=$shodan_api" >> $USER_HOME/.profile
source $USER_HOME/.profile
echo "" >> $USER_HOME/.bashrc
echo "alias shosubgo='\$HOME/go/pkg/mod/github.com/shosubgo/shosubgo_linux_1_1'" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

# hakrawler by hakluke
go get github.com/hakluke/hakrawler
echo "" >> $USER_HOME/.bashrc
echo "alias hakrawler='\$HOME/go/bin/hakrawler'" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

# assetfinder by tomnomnom
go get -u github.com/tomnomnom/assetfinder
echo "" >> $USER_HOME/.profile
echo "export VT_API_KEY=\"$virustotal_api\"" >> $USER_HOME/.profile
if [ -z "$spyse_api" ] # if spyse_api is empty
then
      echo "User opted not to provide spyse.com API key"
else
      echo "export SPYSE_API_TOKEN=\"$spyse_api\"" >> $USER_HOME/.profile
fi
source $USER_HOME/.profile
echo "" >> $USER_HOME/.bashrc
echo "alias assetfinder=\"\$HOME/go/bin/assetfinder\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

# httprobe by tomnomnom
go get -u github.com/tomnomnom/httprobe
echo "" >> $USER_HOME/.bashrc
echo "alias httprobe=\"\$HOME/go/bin/httprobe\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

# subdomainizer by nsonaniya2010
mkdir $USER_HOME/bugbounty
mkdir $USER_HOME/bugbounty/_tools
cd $USER_HOME/bugbounty/_tools
git clone https://github.com/nsonaniya2010/SubDomainizer.git
cd SubDomainizer
pip3 install -r requirements.txt
pip3 install colorama
echo "" >> $USER_HOME/.bashrc
echo "alias subdomainizer=\"python3 \$HOME/bugbounty/_tools/SubDomainizer/SubDomainizer.py\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

# subfinder by projectdiscovery
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
echo "" >> $USER_HOME/.bashrc
echo "alias subfinder=\"\$HOME/go/bin/httprobe\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

####################################################
# Python

# pip3 packages
pip3 install requests

# EyeWitness
cd $USER_HOME/bugbounty/_tools
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd Python/setup
./setup.sh
echo "" >> $USER_HOME/.bashrc
echo "alias eyewitness=\"\$HOME/bugbounty/_tools/EyeWitness/Python/EyeWitness.py\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

####################################################
# Other Programming Languages
cd $USER_HOME/bugbounty/_tools
git clone https://github.com/blechschmidt/massdns.git
cd massdns/bin
make
echo "" >> $USER_HOME/.bashrc
echo "alias massdns=\"\$HOME/bugbounty/_tools/massdns/bin/massdns\"" >> $USER_HOME/.bashrc
source $USER_HOME/.bashrc

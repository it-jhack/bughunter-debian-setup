#!/bin/bash

# Download Links/vars
# url example = https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz

# Golang download
echo -n "Enter Golang (for Debian/Linux) download URL: "
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

# apt-get packages
apt-get install jq -y
apt-get install tree -y

####################################################
#GOLANG

# Creating script_download folder
cd ~
mkdir script_downloads
cd script_downloads

# Downloading Golang
curl $go_url

# Extracting Golang
rm -rf /usr/local/go && tar -C /usr/local -xzf $go_filename

# Creating Golang path on ~/.bashrc
echo "" >> ~/.bashrc
echo "export GOPATH='/usr/local/go'"
echo "export PATH=\$PATH:$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc # load changes

# Golang packages
snap install amass # -y flag not needed

# Nuclei
cd ~/go/pkg/mod/github.com/
mkdir projectdiscovery
cd projectdiscovery
git clone https://github.com/projectdiscovery/nuclei.git
cd nuclei/v2/cmd/nuclei
go build
mv nuclei /usr/local/bin/
nuclei -version
nuclei -update-templates

# shosubgo (shodan subdomain enumerator)
cd ~/go/pkg/mod/github.com/
mkdir shosubgo
cd shosubgo
curl -LJO https://github.com/pownx/shosubgo/releases/download/1.1/shosubgo_linux_1_1
chmod +x shosubgo_linux_1_1
echo "" >> ~/.profile
echo "export SHODAN_API=$shodan_api" >> ~/.profile
source ~/.profile
echo "" >> ~/.bashrc
echo "alias shosubgo='\$HOME/go/pkg/mod/github.com/shosubgo/shosubgo_linux_1_1'" >> ~/.bashrc
source ~/.bashrc

# hakrawler by hakluke
go get github.com/hakluke/hakrawler
echo "" >> ~/.bashrc
echo "alias hakrawler='\$HOME/go/bin/hakrawler'" >> ~/.bashrc
source ~/.bashrc

# assetfinder by tomnomnom
go get -u github.com/tomnomnom/assetfinder
echo "" >> ~/.profile
echo "export VT_API_KEY=\"$virustotal_api\"" >> ~/.profile
if [ -z "$spyse_api" ] # if spyse_api is empty
then
      echo "User opted not to provide spyse.com API key"
else
      echo "export SPYSE_API_TOKEN=\"$spyse_api\"" >> ~/.profile
fi
source ~/.profile
echo "" >> ~/.bashrc
echo "alias assetfinder=\"\$HOME/go/bin/assetfinder\"" >> ~/.bashrc
source ~/.bashrc

# httprobe by tomnomnom
go get -u github.com/tomnomnom/httprobe
echo "" >> ~/.bashrc
echo "alias httprobe=\"\$HOME/go/bin/httprobe\"" >> ~/.bashrc
source ~/.bashrc

# subdomainizer by nsonaniya2010
mkdir ~/bugbounty
mkdir ~/bugbounty/_tools
cd ~/bugbounty/_tools
git clone https://github.com/nsonaniya2010/SubDomainizer.git
cd SubDomainizer
pip3 install -r requirements.txt
pip3 install colorama
echo "" >> ~/.bashrc
echo "alias subdomainizer=\"python3 \$HOME/bugbounty/_tools/SubDomainizer/SubDomainizer.py\"" >> ~/.bashrc
source ~/.bashrc

####################################################
# Python

# pip3 packages
pip3 install requests

# EyeWitness
cd ~/bugbounty/_tools
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd Python/setup
./setup.sh
echo "" >> ~/.bashrc
echo "alias eyewitness=\"\$HOME/bugbounty/_tools/EyeWitness/Python/EyeWitness.py\"" >> ~/.bashrc
source ~/.bashrc

####################################################
# Other Programming Languages
cd ~/bugbounty/_tools
git clone https://github.com/blechschmidt/massdns.git
cd massdns/bin
make
echo "" >> ~/.bashrc
echo "alias massdns=\"\$HOME/bugbounty/_tools/massdns/bin/massdns\"" >> ~/.bashrc
source ~/.bashrc

#!/bin/bash

# Download Links/vars
# url example = https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz
echo -n "Enter Golang (for Debian/Linux) download URL: "
read go_url
go_filename=${go_url##*/} # strip last part of $go_url

####################################################
#PACKAGE MANAGERS

# apt && apt-get update/upgrade
apt update && apt upgrade
apt-get update && apt-get upgrade

# install snap
apt install snapd -y

# apt packages
apt install git -y

# apt-get packages
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
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
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

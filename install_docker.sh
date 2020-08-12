#!/bin/sh
set -e

case "$1" in
 "centos" )
  echo "Install Docker for CentOS"
  echo "Remove old docker packages..."
  yum remove docker \
                    docker-client \
                    docker-client-latest \
                    docker-common \
                    docker-latest-logrotate \
                    docker-logrotate \
                    docker-engine| true
  echo "Install dependencies..."
  yum install -y yum-utils
  echo "Set up the repository..."
  yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
  echo "Install Docker."
  yum install docker-ce docker-ce-cli containerd.io docker-compose python3-docker
  echo "Done."
 ;;

 "debian" )
  echo "Install Docker for Debian"
  echo "Remove old docker packages..."
  apt-get -y remove docker docker-engine docker.io containerd runc| true
  echo "Install dependencies..."
  apt-get update
  apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common --no-install-recommends
  echo "Set up the repository..."
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
  echo "Install Docker."
  apt-get update
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose python3-docker gnupg2 pass --no-install-recommends
  echo "Done."
 ;;
 
 "ubuntu" )
  echo "Install Docker for Ubuntu"
  echo "Remove old docker packages..."
  apt-get remove docker docker-engine docker.io containerd runc| true
  echo "Install dependencies..."
  apt-get update
  apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common --no-install-recommends
  echo "Set up the repository..."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
  echo "Install Docker."
  apt-get update
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose python3-docker gnupg2 pass --no-install-recommends
  echo "Done."
 ;;
 
 * )
  echo "Example: ./install_docker.sh ubuntu|debian|centos"
 ;;
 
esac

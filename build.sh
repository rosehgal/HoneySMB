#!/bin/bash
ls smbDockerKeys
if [ $? -eq 0 ]
then
  rm smbDockerKeys*
fi
ssh-keygen -t rsa -f smbDockerKeys
cat smbDockerKeys.pub >> ~/.ssh/authorized_keys
id smbuser

if [ $? -ne 0 ]
then
  echo "[*] Adding smb user"
  sudo useradd smbuser
fi

docker -v
if [ $? -ne 0 ]
then
  sudo aptitude install docker.io -y
else
  echo "[*] Docker Already Installed"
fi

sudo docker build -t smbserver .

if [ $? -ne 0 ]
then
  echo "[*] unbale to build docker"
  exit
fi

sudo docker run --name SMB -d -p 445:445 -p 139:139 -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  sudo docker rm -f SMB
sudo docker run --name SMB -d -p 445:445 -p 139:139 -i smbserver
fi


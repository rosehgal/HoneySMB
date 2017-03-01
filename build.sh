#!/bin/bash
if [ "$EUID" -ne 0 ]
then
  echo "[*] Please run as root"
  exit
fi

docker -v
if [ $? -ne 0 ]
then
  aptitude install docker.io -y
else
  echo "[*] Docker Already Installed"
fi

docker build -t smbserver .

if [ $? -ne 0 ]
then
  echo "[*] unbale to build docker"
  exit
fi

mkdir logs
mkdir smbDrive
docker run --name SMB -d -p 445:445 -p 139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --name SMB -d -p 445:445 -p 139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver
fi

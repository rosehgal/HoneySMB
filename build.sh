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

echo "[*]Enter the IP to bind the server to[0.0.0.0.]";read server_ip;
if [[ -z "${server_ip// }" ]];then server_ip="0.0.0.0" ;fi
docker run --name SMB -d -p $server_ip:445:445 -p $server_ip:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --name SMB -d -p $server_ip:445:445 -p $server_ip:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver
fi

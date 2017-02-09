#!/bin/bash
if [ "$EUID" -ne 0 ]
then
  echo "[*] Please run as root"
  exit
fi

ls smbDockerKeys
if [ $? -eq 0 ]
then
  rm smbDockerKeys*
fi

ssh-keygen -t rsa -f smbDockerKeys
#cat smbDockerKeys.pub >> /home/smbuser/.ssh/authorized_keys
id smbuser

if [ $? -ne 0 ]
then
  echo "[*] Adding smb user"
  useradd -m smbuser
fi

chmod +r ./smbDockerKeys ./smbDockerKeys.pub
#chown -R :smbuser /home/smbuser
#chmod 777 -R /home/smbuser
#touch /home/smbuser/.ssh/authorized_keys
#cat smbDockerKeys.pub >> ~/.ssh/authorized_keys

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

docker run --name SMB -d -p 445:445 -p 139:139 -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --name SMB -d -p 445:445 -p 139:139 -i smbserver
fi

ls /home/smbuser/.ssh
if [ $? -eq 0 ]
then rm -rf /home/smbuser/.ssh
fi
sudo -H -u smbuser bash -c "mkdir ~/.ssh ; cat smbDockerKeys.pub >> ~/.ssh/authorized_keys"
#docker exec SMB tcpdump -p -f "port 445 or port 139" -w /dev/stdout | ssh -i /home/smb/smbDockerKeys -o StrictHostKeyChecking=no smbuser@`/sbin/ip route|awk '/default/ { print $3 }'` "cat - > /home/smbuser/smbDocker_`date +%Y-%m-%d`.pcap"

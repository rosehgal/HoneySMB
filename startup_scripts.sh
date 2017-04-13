#!/bin/bash
python /home/smb/smbserver.py &  
<<<<<<< HEAD
tcpdump -p -f "port 445 or port 139" -w /home/smb/logs/smblog.pcap
=======
tcpdump -p -f "port 445 or port 139" -w /home/smb/logs/"smblog.pcap"
>>>>>>> HoneySMB/master

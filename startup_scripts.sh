#!/bin/bash
python /home/smb/smbserver.py &  
tcpdump -p -f "port 445 or port 139" -G 3600 -w /home/smb/logs/"log_+%Y-%m-%d.pcap"

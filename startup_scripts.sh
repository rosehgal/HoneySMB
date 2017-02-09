 #!/bin/bash
tcpdump -p -f "port 445 or port 139" -w /dev/stdout | ssh -i /home/smb/smbDockerKeys -o StrictHostKeyChecking=no smbuser@`/sbin/ip route|awk '/default/ { print $3 }'` "cat - > /home/smbuser/smbDocker_`date +%Y-%m-%d`.pcap" &
python /home/smb/smbserver.py &

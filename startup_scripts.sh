 #!/bin/bash
tcpdump -p -f "port 445 or port 139" | ssh -i /home/smbDockerKeys smbuser@`/sbin/ip route|awk '/default/ { print $3 }'` "cat - > /tmp/smbDocker_`date +%Y-%m-%d`.pcap"
python /home/smbserver.py &

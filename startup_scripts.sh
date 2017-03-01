 #!/bin/bash
tcpdump -p -f "port 445 or port 139" -w /dev/stdout | cat - > /home/smb/logs/log_`date +%Y-%m-%d`.pcap

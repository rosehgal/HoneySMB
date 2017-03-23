sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev python -y
wget https://www.bro.org/downloads/bro-2.5.tar.gz
tar -xvzf bro-2.5.tar.gz
cd bro-2.5 && ./configure
make -j4
sudo make install

rm -rf bro-2.5.tar.gz bro-2.5/ 

sudo /usr/local/bro/bin/broctl deploy

sudo sh -c "sed -i 's+# @load policy/protocols/smb+@load policy/protocols/smb+g' /usr/local/bro/share/bro/site/local.bro"
sudo sh -c "sed -i 's+# @load policy/protocols/smb+@load policy/protocols/smb+g' /usr/local/bro/spool/installed-scripts-do-not-touch/site/local.bro"

# command to create all lgo file

# /usr/local/bro/bin/bro -Cr <name of pcap file> local

# /usr/local/bro/bin/bro-cut -d ts id.orig_h id.orig_p id.resp_h id.resp_p < conn.log

# /usr/local/bro/bin/bro-cut -d ts id.orig_h id.resp_h id.resp_p action path name < smb_files.log

#/usr/local/bro/bin/bro-cut -d ts id.orig_h id.resp_h id.resp_p path service native_file_system share_type < smb_mapping.log

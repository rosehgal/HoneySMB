FROM ubuntu
MAINTAINER Rohit Sehgal (rsehgal@iitk.ac.in)

RUN apt-get update -y && apt-get install python2.7 -y
RUN apt-get update
RUN apt-get install openssh-client python tcpdump python-pip -y
RUN apt-get install iproute -y
RUN apt-get install aptitude -y
RUn aptitude install supervisor -y

RUN mkdir -p /home/smb

COPY libs /home/smb/libs
COPY credentials_file /home/smb/credentials_file
COPY __init__.py /home/smb/__init__.py
COPY shares.conf /home/smb/shares.conf
COPY smbserver.py /home/smb/smbserver.py
COPY smb.conf /home/smb/smb.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY startup_scripts.sh /home/smb/startup_scripts.sh
RUN chmod 754 /home/smb/startup_scripts.sh

COPY smbDockerKeys /home/smb/smbDockerKeys
RUN chmod 400 /home/smb/smbDockerKeys

COPY requirements.txt /home/smb/requirements.txt
RUN pip install -r /home/smb/requirements.txt

COPY smbDrive /home/smb/smbDrive

EXPOSE 445 139

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-n"]

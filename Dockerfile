FROM ubuntu
MAINTAINER Rohit Sehgal (rsehgal@iitk.ac.in)

RUN apt-get update -y && apt-get install python2.7 -y
RUN apt-get update
RUN apt-get install openssh-client python tcpdump python-pip -y
RUN apt-get install iproute -y

RUN mkdir -p /home/smb
RUN chmod 770 /home/smb

RUN useradd smb

RUN chown :smb /home/smb

COPY libs /home/smb/libs
COPY credentials_file /home/smb/credentials_file
COPY __init__.py /home/smb/__init__.py
#COPY requirements.txt /home/smb/requirements.txt
COPY shares.conf /home/smb/shares.conf
COPY smbserver.py /home/smb/smbserver.py

COPY startup_scripts.sh /home/smb/startup_scripts.sh

RUN chmod 754 /home/smb/startup_scripts.sh

COPY smbDockerKeys /home/smb/smbDockerKeys
RUN chmod 400 /home/smb/smbDockerKeys

#COPY requirements.txt /home/smb/requirements.txt
#RUN pip install -r /home/smb/requirements.txt
RUN pip install pycrypto

COPY smbDrive /home/smb/smbDrive
RUN chown :smb /home/smb/smbDrive

EXPOSE 445 139

#ENTRYPOINT ["/bin/bash"]
#CMD ["/home/smb/startup_scripts.sh"]

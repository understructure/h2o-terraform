#!/bin/bash

# install rpm
# apt-get update
# apt install -y rpm

# install Java
cd /opt && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.rpm && \
    rpm -ivh jdk-8u191-linux-x64.rpm 


# install java - Ubuntu - not quite right 2018-12-03
# apt install -y software-properties-common
# apt-add-repository -y ppa:webupd8team/java
# apt update
# echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# apt install -y oracle-java8-installer

# install python3 and relevant libraries
# only for AWS Linux
amazon-linux-extras install -y python3

# only for Ubuntu
# apt install -y python3-pip

pip3 install requests
pip3 install six
pip3 install tabulate
pip3 install "colorama>=0.3.8"
pip3 install future

# install h2o
pip3 uninstall h2o
pip3 install -f http://h2o-release.s3.amazonaws.com/h2o/latest_stable_Py.html h2o

# get and copy service file to /etc/systemd/system
wget https://gist.githubusercontent.com/understructure/9d0af085e4053a3c12de900e5ee0ae0d/raw/30f6f5e50582df215f146c1e254c84bf8f64b316/h2o.service && cp h2o.service /etc/systemd/system/h2o.service

# get and copy service shell script to /usr/local/bin
# wget https://gist.github.com/understructure/9d0af085e4053a3c12de900e5ee0ae0d/raw/30f6f5e50582df215f146c1e254c84bf8f64b316/h2oService.sh && cp h2oService.sh /usr/local/bin/h2oService.sh && chmod +x /usr/local/bin/h2oService.sh

wget https://gist.githubusercontent.com/understructure/9d0af085e4053a3c12de900e5ee0ae0d/raw/68908ab4ff7e9f9423d1ccf29bb1b95478a753b1/h2oService.sh && cp h2oService.sh /usr/local/bin/h2oService.sh && chmod +x /usr/local/bin/h2oService.sh

systemctl start h2o.service


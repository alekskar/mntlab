#!/bin/bash
cd /home/vagrant/sources
yum install -y java-1.8.0-openjdk.x86_64
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.3/bin/apache-tomcat-8.5.3.tar.gz
tar xvfz apache-tomcat-8.5.3.tar.gz
cd  ./apache-tomcat-8.5.3/bin
chmod a+x *.sh
bash startup.sh

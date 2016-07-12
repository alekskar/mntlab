#!/bin/bash
yum install -y httpd
cd /home/vagrant/sources
cp ./mod_jk.so /etc/httpd/modules/
cp ./httpd-vhosts.conf /etc/httpd/conf.d/
cp ./workers.properties /etc/httpd/conf/
rm -f /etc/httpd/conf/httpd.conf
cp ./httpd.conf /etc/httpd/conf/httpd.conf
chkconfig httpd on
service httpd start

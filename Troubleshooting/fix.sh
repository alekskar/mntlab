#!/bin/bash
# This script repair issues in mntlab server
# fix issue 1
sed -i -e '/^<VirtualHost/,+6 s/^/#/' /etc/httpd/conf/httpd.conf
sed -i -e '/<VirtualHost/s/mntlab/*/' /etc/httpd/conf.d/vhost.conf
#fix issue 2
sed -i -e '/> \/dev\/null/s/>/#>/' /etc/init.d/tomcat
sed -i -e '/^export [JC]A/d' /home/tomcat/.bashrc
chown -R tomcat:tomcat /opt/apache/tomcat/7.0.62/logs/
#fix issue 3
alternatives --config java <<< '1'
#fix issue 4
sed -i -e 's/worker-jk@ppname/tomcat.worker/g' /etc/httpd/conf.d/workers.properties
sed -i -e 's/192.168.56.100/127.0.0.1/' /etc/httpd/conf.d/workers.properties
sed -i -e 's/192.168.56.10/127.0.0.1/g'  /opt/apache/tomcat/7.0.62/conf/server.xml
# add tomcat to autostart with reboot
chkconfig tomcat on
#restarting services to apply changes
service httpd restart
service tomcat start
#change immutable attribute to fix iptables
chattr -i /etc/sysconfig/iptables
#load tested iptables config records
cat > /etc/sysconfig/iptables <<EOF
# Generated by iptables-save v1.4.7
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [71:8305]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
#return immutable attrubute
chattr -i /etc/sysconfig/iptables
service iptables restart





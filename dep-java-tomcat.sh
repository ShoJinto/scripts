#!/bin/bash
#
#this is a install apache-tomcat script
#
# edit by jtxiao 2016-7-4

#INSTALL JAVA ENV

curl -O http://ddns.defshare.cn:18080/softs/jdk-8u65-linux-x64.gz
mkdir -p /usr/lib/jvm
tar xf jdk-8u65-linux-x64.gz -C /usr/lib/jvm

ln -s /usr/lib/jvm/jdk1.8.0_65/bin/* /usr/sbin/

#INSTALL TOMCAT 
curl -O http://ddns.defshare.cn:18080/softs/apache-tomcat-jsvc-8.0.32.tar.gz

tar xf apache-tomcat-jsvc-8.0.32.tar.gz -C /usr/local

ln -s /usr/local/apache-tomcat-8.0.32/bin/daemon.sh /etc/init.d/tomcatd

chkconfig /etc/init.d/tomcatd on


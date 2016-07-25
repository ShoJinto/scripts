#!/bin/bash
#
#this is a install apache-tomcat script
#
#Only adapted version before centos7
#
# edit by jtxiao 2016-7-4
#

#INSTALL JAVA ENV

curl -O http://ddns.defshare.cn:18080/softs/jdk-8u65-linux-x64.gz
mkdir -p /usr/lib/jvm
tar xf jdk-8u65-linux-x64.gz -C /usr/lib/jvm

ln -s /usr/lib/jvm/jdk1.8.0_65/bin/* /usr/sbin/

cat > /etc/profile.d/java.sh << EOF
export  JAVA_HOME=/usr/lib/jvm/jdk1.8.0_65
export  JRE_HOME=\${JAVA_HOME}/jre
export  CLASSPATH=.:\${JAVA_HOME}/lib/:\${JRE_HOME}/lib
export  PATH=\${JAVA_HOME}/bin:\${PATH}
EOF
source /etc/profile

#INSTALL TOMCAT 

curl -O ddns.defshare.cn:18080/softs/apache-tomcat-8.0.32.tar.gz

tar xf apache-tomcat-8.0.32.tar.gz -C /usr/local

rm -rf /usr/local/apache-tomcat-8.0.32/webapps/*

cd /usr/local/apache-tomcat-8.0.32/bin
tar	xf commons-daemon-native.tar.gz
cd commons-daemon-1.0.15-native-src/unix
./configure
if [ $? -ne 0 ];then
	yum install -y gcc-c++ gcc
fi
make
cp jsvc ../../

useradd -r -s /sbin/nologin tomcat

ln -sf /usr/local/apache-tomcat-8.0.32/bin/daemon.sh /etc/init.d/tomcatd

sed -i '2i\\# chkconfig: 2345 88 92' /usr/local/apache-tomcat-8.0.32/bin/daemon.sh

chkconfig tomcatd on

/etc/init.d/tomcatd start


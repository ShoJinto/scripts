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

#DOWNLOAD jenkins.war

curl -o /usr/local/apache-tomcat-8.0.32/webapps/ROOT.war http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable/1.651.3/jenkins.war
sed -i '24i\\ \ \ \ <Environment name="JENKINS_HOME" value="${catalina.base}/webapps/jenkins" type="java.lang.String" />' \
/usr/local/apache-tomcat-8.0.32/conf/context.xml

adduser -r -s /sbin/nologin tomcat
chown tomcat.tomcat -R /usr/local/apache-tomcat-8.0.32

#INSTALL SUPERVISOR

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install python-pip
pip install supervisor
cat >> /etc/supervisord.conf <<EOF
[unix_http_server]
file=/tmp/supervisor.sock   ; (the path to the socket file)
[supervisord]
logfile=/tmp/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10           ; (num of main logfile rotation backups;default 10)
loglevel=info                ; (log level;default info; others: debug,warn,trace)
pidfile=/tmp/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false               ; (start in foreground if true;default false)
minfds=1024                  ; (min. avail startup file descriptors;default 1024)
minprocs=200                 ; (min. avail process descriptors;default 200)
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket
[program:tomcat_monitor]
command=/usr/local/apache-tomcat-8.0.32/bin/catalina.sh  run             ; the program (relative uses PATH, can take args)
directory=/usr/local/apache-tomcat-8.0.32/webapps                ; directory to cwd to before exec (def no cwd)
user=tomcat                  ; setuid to this UNIX account to run the program
redirect_stderr=true          ; redirect proc stderr to stdout (default false)
stdout_logfile=/usr/local/apache-tomcat-8.0.18/logs/catalina.out
EOF
echo 'supervisord -c /etc/supervisord.conf' >> /etc/rc.local

supervisord -c /etc/supervisord.conf
supervisorctl status tomcat_monitor




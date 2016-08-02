#!/bin/bash
#
#this is a install apache-tomcat script
#
#Only adapted version before centos7
#
# edit by jtxiao 2016-8-1
#

#INASALL MYSQL

echo -e "======mysql database deploying....\n
		using source code install mysql database please wait a few minutes."

echo 'download mysql source code from mysql.com,please wait.'
curl -O http://cdn.mysql.com/archives/mysql-5.5/mysql-5.5.46.tar.gz
tar xf mysql-5.5.46.tar.gz
cd mysql-5.5.46/
yum  install cmake  gcc gcc_c++
yum  install ncurses-devel
cmake .
make && make install
useradd -r -s /sbin/nologin mysql
cd /usr/local/mysql
chown mysql.mysql -R .
cp support-files/my-default.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysqld
mysql -H scripts/mysql_install_db --user=mysql
ln -s `pwd`/bin/* /usr/sbin/
mysql -H mysqld_safe --user=mysql &
mysql_secure_installation
ps -ef |grep mysql |awk '{print $2}' |xargs sudo kill -9
chkconfig mysqld on
service mysqld start


#INSTALL JAVA ENV

echo ======java env deploying....

echo 'download java from oracle,plases wait.'
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

echo =======tomcat deploying....

echo 'download tomcat from apache,please wait.'
curl -O ddns.defshare.cn:18080/softs/apache-tomcat-8.0.32.tar.gz

tar xf apache-tomcat-8.0.32.tar.gz -C /usr/local

rm -rf /usr/local/apache-tomcat-8.0.32/webapps/*

adduser -r -s /sbin/nologin tomcat
chown tomcat.tomcat -R /usr/local/apache-tomcat-8.0.32

#INSTALL SUPERVISOR

echo =======supervisor deploying....

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

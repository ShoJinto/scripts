#!/bin/bash
#
# edit by jtxiao 2016-04-26

PRJ_HOME=/usr/local/apache-tomcat-8.0.32
LOG_DIR=/data/guess_upload/static/logs

#cut logs
cat ${PRJ_HOME}/logs/catalina.out >> ${PRJ_HOME}/logs/catalina.`date +%F`.out && > ${PRJ_HOME}/logs/catalina.out

#archive logs
#projectlogdir=/data/guess_upload/static/logs
#logfilename=`date -d 'yesterday' +%Y_%m_%d`.stderrout.log
#tmp=`date -d 'yesterday' +%Y_%m_%d`.stderrout.log.*

#cd ${LOG_DIR}
#tar czf ${LOG_DIR}/archive-logs/catalina.`date -d '2 days ago' +%F`.out.tgz ${PRJ_HOME}/logs/catalina.`date -d '2 days ago' +%F`.out --remove-files
tar czf ${LOG_DIR}/archive-logs/catalina.`date  +%F`.out.tgz ${PRJ_HOME}/logs/catalina.`date  +%F`.out --remove-files

#logfilename1=`ls ${tmp}`
#[ -n ${logfilename1} ] && tar czf archive-logs/${logfilename1}.tgz ${logfilename1}  --remove-files

mv ${PRJ_HOME}/logs/66cf.`date -d  +%F`.log.zip ${LOG_DIR}/archive-logs/


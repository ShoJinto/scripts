#!/bin/bash 
#
#name:backup.sh
#description:full  incremental and differential  backup script
#	edit by :jtxiao

#以下变量再实际应用中需要根据具体情况进行修改

SRV_NAME=`hostname`							# 设置服务器名字，如果有多台服务器，那么就很好区分
DIRECTORIES="/data"							# 设置要备份的目录
BACKUPDIR="/backups"						# 设置备份文件存放位置
TIMEDIR=$BACKUPDIR/last-full				# 定义上次完整备份时间的存放目录
LOG=$BACKUPDIR/log/backup-`date +%F`.log	# 设置log存放目录
DIFF_BAK_LIST=$BACKUPDIR/differential/files	# 设置差异备份文件集
TAR=/bin/tar

#兼容性设置
LANG=C								# 设置语言兼容，避免出现中文日期
#PATH=/usr/local/bin:/usr/bin:/bin
DOW=`date +%a`						# 周几 例如：Fri
DOM=`date +%d`						# 几号 例如：09
DATE=`date +%F`						# 几月几号 例如：2016-09-09

# 备份策略：
# 1.每月1号进行完整备份
# 2.每周日进行完整备份，并覆盖上周日生成的完整备份
# 3.周3进行差异备份
# 4.其他日期进行增量备份，每个增量备份都覆盖上周生成的增量备份

# 如果 NEWER = “”，即进行完整备份，否则备份NEWER 时间新的文件，NEWER 每周日生成并存放于 TIMEDIR/SRV_NAME-full-date 文件中


# 若不是在一个月的 1 日或非周日开始运行此脚本，可以依照脚本中的文件名约定手工创建一个完全备 份文件，并用如下的命令
# 将完全备份的日期写入 /backups/last-full 目录下的文件 $SRV_NAME-full-date 中，此脚本默认的文件名是 $SRV_NAME-full-date
# 赋予此文件可执行权限，然后将文件cp到/etc/cron.daily 即可
# prepare environment
[ ! -e $BACKUPDIR/last-full ] && mkdir -p $BACKUPDIR/last-full
[ ! -e $BACKUPDIR/log ] && mkdir -p $BACKUPDIR/log
[ ! -e $BACKUPDIR/differential ] && mkdir -p $BACKUPDIR/differential

# every mouth full backup
if [ $DOM == "01" ]; then
	NEWER=""
	$TAR $NEWER -czvpf $BACKUPDIR/$SRV_NAME-mouth-full-$DATE.tgz $DIRECTORIES
fi

# every week full backup
if [ $DOW == "Sun" ]; then
	NEWER=""
	# update full backup date
	echo `date +%F` > $TIMEDIR/$SRV_NAME-full-date
	$TAR $NEWER -czvpf $BACKUPDIR/$SRV_NAME-sun-full-$DATE.tgz $DIRECTORIES >>$LOG 2>&1
# differential backup
elif [ $DOW == "Wed" ]; then
	find $DIRECTORIES -mtime -1 -print >> $DIFF_BAK_LIST 	
	$TAR -T $DIFF_BAK_LIST -czvpf $BACKUPDIR/$SRV_NAME-differential-$DATE.tgz $DIRECTORIES >>$LOG 2>&1
# incremental backup
else
	# get last full backup date
	NEWER="--newer `cat $TIMEDIR/$SRV_NAME-full-date`"
	$TAR $NEWER -cavpf $BACKUPDIR/$SRV_NAME-incremental-$DATE.tgz $DIRECTORIES >>$LOG 2>&1
fi


BACKUPKEEPDAYS=60
# clean backkup files
#find $BACKUPDIR -mtime +$BACKUPKEEPDAYS -exec rm -rf { } \;

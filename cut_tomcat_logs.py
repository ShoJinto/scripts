#!/usr/bin/env python
#

import os
import time

source_dir = '/usr/local/apache-tomcat-8.0.32/logs/'
source_log = source_dir + 'catalina.out'
target_log = source_log[:-4] + '.' + time.strftime('%Y-%m-%d') + '.out'

move_log_command = 'cat '+ source_log +' > '+ target_log
flush_log_command = '> '+ source_log

target_dir='/data/guess_upload/static/logs/archive-logs/'
target_bak=target_dir + target_log.split('/',5)[5] + '.tgz'
tar_command = "tar czf %s %s --remove-files" % (target_bak,''.join(source_log))


if os.system(tar_command) == 0:
    print 'Successful backup to',target_bak
else:
    print 'Backup FAILED'

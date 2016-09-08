#!/usr/bin/env python
#

import os

make_jumper_cmd = 'useradd -d /home/jumper -s /bin/bash -m jumper'

setup_cmd = 'echo "jumper.py" >> /home/jumper/.profile && echo "logout" >> /home/jumper/.profile'


os.system(make_jumper_cmd)
os.system(setup_cmd)

#!/usr/bin/evn python
#

import pickle
import os

ip_dict = {}
num = 1
default_ip = 'localhost'
default_user = os.environ['USER']
default_port = 22
default_auth = 'password'

print '\t\t\033[33;2mWelcome to jumpserver managent\n\033[0m'
while True:
    ip = raw_input('Remote Server IP [%s]:' % default_ip)
    if len(ip) == 0: ip = default_ip
    login_user = raw_input('Remote Server Login user [%s]:' % default_user)
    if len(login_user) == 0: login_user = default_user
    port = raw_input('Remote Server SSH port [%s]:' % default_port)
    if len(port) == 0: port = default_port
    auth_method = raw_input('Remote Server Authorized Method [%s] or [ssh-key]:' % default_auth)
    if len(auth_method) == 0: auth_method = default_auth
    
    ip_dict[str(num)] = [ip, login_user, port, auth_method]
    num += 1


    iscontinue = raw_input('Do you want to add go on? [Y]yse or [N]no:')
    if iscontinue in ["Y","y","Yes","yes"]:
	continue
    else:
	break

try:
    with open('ips.pkl','ab') as ips:
	pickle.dump(ip_dict,ips)		
except IOError as e:
    print "File missing! %s" % e

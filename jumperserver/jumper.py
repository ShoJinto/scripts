#!/usr/bin/env python
#

import os
import sys
import time
import socket
import getpass
import traceback
from paramiko.py3compat import input,u

import pickle

import paramiko


UseGSSAPI = True 
DoGSSAPIKeyExchange = True


def run_jump():
    #ips = []
    #ip_dict = {}
    with open('ips.pkl') as ip_list:
        #while True:
        #	i = ip_list.readline()
        #	if len(i) == 0: break
    	#	ips.append(i)
	srv_info=pickle.load(ip_list)


    print "\033[33;2\t\tmWelcome to login jumpserver\033[0m"
    print "\t\tchooise you want to connect:"
    #while True:
    #    num = 1
    #    for ip in ips:
    #        print "\033[32;1m%d. %s\033[0m" % (num,ip.strip('\n'))
    #        ip_dict[str(num)] = ip.strip('\n')	
    #        num += 1
    #
    #    option = raw_input('Please input your chooise number:')
    #    if option in ip_dict.keys():
    #        ssh('root',ip_dict[option])
    for n,info in srv_info.items():
	print '\033[32;1m%s. %s\033[0m' % (n,info[0])

    option = raw_input('Please input your chooise number:')
    if option in srv_info.keys():
        #ssh(srv_info.keys()[option][2])
	hostname = srv_info.values()[int(option) - 1][0]
	username = srv_info.values()[int(option) - 1][1]
	port = srv_info.values()[int(option) - 1][2]
	auth_method = srv_info.values()[int(option) - 1][3]
        #print hostname,username,port,auth_method
	ssh(username,hostname,port,auth_method)
    
def ssh(username,hostname,port,auth_method):
    '''
    this functon is ssh to target server use shell
    ''' 
    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    #client.set_missing_host_key_policy(paramiko.WarningPolicy())
    print('*** Connecting...')
    if not UseGSSAPI or (not UseGSSAPI and not DoGSSAPIKeyExchange):
        client.connect(hostname, port, username, password)
    else:
        # SSPI works only with the FQDN of the target host
        hostname = socket.getfqdn(hostname)
        try:
            client.connect(hostname, port, username, gss_auth=UseGSSAPI,
                           gss_kex=DoGSSAPIKeyExchange)
        except Exception:
            password = getpass.getpass('Password for %s@%s: ' % (username, hostname))
            client.connect(hostname, port, username, password)

    chan = client.invoke_shell()
    #print(repr(client.get_transport()))
    print('*** Here we go!\n')
    shell(chan,username,hostname)
    chan.close()
    client.close()

def shell(chan,username,hostname):
    '''
    this function is create a shell
    '''
    timestemp = time.strftime('%Y-%m-%d')
    history_list = []
    
    import select,termios,tty

    oldtty = termios.tcgetattr(sys.stdin)
    try:
	tty.setraw(sys.stdin.fileno())
	tty.setcbreak(sys.stdin.fileno())
	chan.settimeout(0.0)
	
	while True:
	    r, w, e = select.select([chan, sys.stdin], [], [])
	    if chan in r:
		try:
		    x = u(chan.recv(1024))
		    if len(x) == 0:
			sys.stdout.write('\r\n*** EOF\r\n')
			break
		    sys.stdout.write(x)
		    sys.stdout.flush()
		except socket.timeout:
		    pass
	    if sys.stdin in r:
		x = sys.stdin.read(1)
		if len(x) == 0:
		    break
		chan.send(x)
		history_list.append(x)
	    if x == '\r':
		command = ''.join(history_list).split('\r')[-2]
		record = "%s |%s |%s |%s \n" % (username, hostname, time.strftime('%Y-%m-%d %Y:%M:%S'), command)
		with open('/tmp/audit_%s_%s.log' % (username,timestemp), 'a+') as log:
		    log.write(record)
		    log.flush()
    finally:
	termios.tcsetattr(sys.stdin, termios.TCSADRAIN, oldtty)


if __name__ == "__main__":
    run_jump()

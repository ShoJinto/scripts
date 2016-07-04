#!/usr/bin/env python
#
# edit by jtxiao 2016-05-03

import cPickle
import os


class notes:
    #def __init__(self,name,phone,email,address):
    #    self.name=name
    #    self.phone=phone
    #    self.email=email
    #    self.address=address
    
    def input_info(self,name,phone,email,address):
	info={'Name':name,'Phone':phone,'Emaile':email,'Address':address}        
 
	f=file('notes.db','a')
	cPickle.dump(info,f)
	f.close()
	
	del info

    def print_info(self):
	f=file('notes.db')
	stored_info=cPickle.load(f)
	print stored_info

def main():
    Note=notes()
    if os.path.isfile('notes.db'):
	choose=raw_input('''\
	Press V or v to view notepad book,
	Press E or e to edit the record of notepad book,
	Press D or d to delete the record of notepad book.''',)
    	Note.print_info()
    else:
        name=raw_input('Plases input your firend name:')        
        phone=raw_input('Plases input your firend phone:')        
        email=raw_input('Plases input your firend email:')        
        address=raw_input('Plases input your firend address:')
    	Note.input_info(name,phone,email,address)
    	Note.print_info()

if __name__ == '__main__':
    main()

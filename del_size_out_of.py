#!/usr/bin/env python
# coding: utf-8
#
# Created by jtxiao on 16-9-1.
#

import os
import sys

file_and_size = {}


def usage():
    print(
        '''
        Welcome to use the script,it can delete file that size out of specify.

        ===================

        Usage:%s <yourpath> <szie>      default szie is (.MB)

        For example: %s /path/to/you 50
        ''' % (sys.argv[0], sys.argv[0])
    )


def countSize(file_dir, file_list):
    '''
    Return a dictionry it inculude filepath and filesize.
    '''
    for files in file_list:
        # print os.path.join(pth,i), getSizeInNiceString(os.path.getsize(os.path.join(pth,i)))
        # pass
        try:
            file_path = os.path.join(file_dir, files)
            file_size_of_bytes = os.path.getsize(file_path)
            file_and_size[str(file_path)] = file_size_of_bytes
        except OSError:
            pass
    return file_and_size


def delete(specify_dir, specify_size):
    for file_list in os.walk(specify_dir):
        # print file_list[0],file_list[2]
        for del_file, size in countSize(file_list[0], file_list[2]).items():
            print del_file, size
            try:
                if size >= int(specify_size) * 1024 * 1024:
                    os.remove(del_file)
                    print('\033[31;1m%s was deleted!\033[0m' % del_file)
            except OSError:
                continue


if __name__ == "__main__":
    try:
        workdir = os.path.join(os.path.dirname(sys.argv[1]), os.path.basename(sys.argv[1]))
        delete(workdir, sys.argv[2])
    except IndexError:
        usage()

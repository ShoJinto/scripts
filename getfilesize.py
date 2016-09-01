# --*-- coding:utf8 --*--
# !/usr/bin/env python
#

import os
import multiprocessing
from sys import argv



def usage():
    print(
        '''
        Welcome to use the script,it can find size out of you specify size.

        ===================

        Usage:%s <yourpath> [your specify size]         the sepecify size default 200MB

        For example: %s /path/to/you 50
        ''' % (argv[0], argv[0])
    )


def getSizeInNiceString(sizeInBytes):
    """
    Convert the given byteCount into a string like: 9.9bytes/KB/MB/GB
    """
    for (cutoff, label) in [(1024 * 1024 * 1024, "GB"),
                            (1024 * 1024, "MB"),
                            (1024, "KB")
                            ]:
        if sizeInBytes >= cutoff:
            return "%.1f %s" % (sizeInBytes * 1.0 / cutoff, label)
    if sizeInBytes == 1:
        return "1 byte"
    else:
        bytes = "%.1f" % (sizeInBytes or 0,)
        return (bytes[:-2] if bytes.endswith('.0') else bytes) + ' bytes'


def countSize(file_dir, file_list, specify_size):
    '''
    Return size of files in the path
    '''
    for files in file_list:
        # print os.path.join(pth,i), getSizeInNiceString(os.path.getsize(os.path.join(pth,i)))
        # pass
        try:
            file_path = os.path.join(file_dir, files)
            file_size = getSizeInNiceString(os.path.getsize(file_path))
            file_size_of_bytes = os.path.getsize(file_path)
            if file_size_of_bytes > specify_size * 1024 * 1024:
                print file_path, file_size
        except OSError:
            pass


def getfile_size(specify_dir, specify_size):
    """

    :rtype : object
    """
    for file_items in os.walk(specify_dir):
        countSize(file_items[0], file_items[2], specify_size)


if __name__ == "__main__":
    try:
        workdir = os.path.dirname(argv[1])
        if len(argv) == 2:
            getfile_size(workdir, 200)
        elif len(argv) == 3:
            getfile_size(workdir, int(argv[2]))
        else:
            usage()

    except IndexError:
        usage()

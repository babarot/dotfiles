#!/usr/bin/env python

import os
import sys
import glob

def main():
    """Script Main"""
    search_cmd = sys.argv[1:]
    search_path = os.environ['PATH'].split(':')
    for cmd in search_cmd:                     
        found_cmd = search_file(cmd, search_path)
        if found_cmd:
            print found_cmd
        else:
            print 'cannot find "%s" command' %(cmd)

def search_file(file, search_path):
    for path in search_path:
        for match in glob.glob(os.path.join(path, file)):
            if os.access(match, os.X_OK):
                return match

if __name__ == '__main__':
    main()

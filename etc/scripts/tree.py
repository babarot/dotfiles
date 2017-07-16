#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys
import os

INDENT_WIDTH = 4
EXCULUDE_LIST = ['.git']

def main(args):
    path_list = []
        if len(args) == 0:
            path_list.append('.')
        else:
            for path in args:
                path = os.path.expanduser(path)
                if not os.path.isdir(path):
                    print('Error: invalid path', path, file=sys.stderr)
                        return 1
                path_list.append(path)

        tree(path_list)

def tree(path_list, indent=0):
    for path in path_list:
        basename = os.path.basename(path)
                if basename in EXCULUDE_LIST:
                    continue

                if os.path.islink(path):
                    print(' ' * INDENT_WIDTH * indent + basename + '@')
                elif os.path.isdir(path):
                    print(' ' * INDENT_WIDTH * indent + basename + '/')
                        children = os.listdir(path)
                        children = [os.path.join(path, x) for x in children]
                        tree(children, indent + 1)
                else:
                    print(' ' * INDENT_WIDTH * indent + basename)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

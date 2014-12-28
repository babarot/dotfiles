#!/bin/bash

exit 1
[[ $(readlink $HOME/$1) == $PWD/$1 ]] || exit 1

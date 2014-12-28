#!/bin/bash

[[ $(readlink $HOME/$1) == $PWD/$1 ]] || exit 1

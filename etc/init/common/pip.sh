#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

has "easy_install" || sudo yum install -y python-setuptools
has "pip" || sudo yum install -y pip

has "diff-highlight" || sudo pip install diff-highlight
has "pygmentize" || sudo pip install Pygments

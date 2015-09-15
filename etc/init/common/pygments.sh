#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

#   # The script is dependent on python
#   if ! has "python"; then
#       log_fail "error: require: python"
#       exit 1
#   fi
#   
#   if has "pygmentize"; then
#       log_pass "pygmentize: already installed"
#       exit
#   fi
#   
#       sudo easy_install pip
#       pip install Pygments
#       pip install pygments-style-solarized
#   
#       cd "$DOTPATH"/etc/init/assets/pygments
#       if [ -d solarized-pygment ]; then
#           cd solarized-pygment
#           git submodule update
#           sudo ./setup.py install
#       else
#           log_fail "something is wrong"
#           exit 1
#       fi
#   else
#       log_fail "install python before Pygments"
#       exit 1
#   fi
#   
#   log_pass "ok: installing pygmentize"

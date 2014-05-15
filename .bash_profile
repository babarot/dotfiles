#=============================================================
#    _               _                           __ _ _      
#   | |__   __ _ ___| |__       _ __  _ __ ___  / _(_) | ___ 
#   | '_ \ / _` / __| '_ \     | '_ \| '__/ _ \| |_| | |/ _ \
#  _| |_) | (_| \__ \ | | |    | |_) | | | (_) |  _| | |  __/
# (_)_.__/ \__,_|___/_| |_|____| .__/|_|  \___/|_| |_|_|\___|
#                        |_____|_|                           
# 
#=============================================================

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

##
# Your previous /Users/fu7ur3/.bash_profile file was backed up as /Users/fu7ur3/.bash_profile.macports-saved_2013-08-10_at_15:22:25
##

# MacPorts Installer addition on 2013-08-10_at_15:22:25: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# MySQL Path Setting
export PATH=$PATH:/usr/local/mysql/bin

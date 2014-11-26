#!/bin/bash

#cal | awk '{ getline; print " Mo Tu We Th Fr Sa Su"; getline; if (substr($0,1,2) == " 1")  print "                    1 "; do { prevline=$0; if (getline == 0) exit; print " " substr(prevline,4,17) " " substr($0,1,2) " "; } while (1) }' | sed -E '1,$'"s/ ($(date +%e))( |$)/ $(echo '\033[1;47m')\1$(echo  '\033[0m')\2/"

date +"    [ %Y/%m/%d ]"
cal |
awk '{ getline; print " Mo Tu We Th Fr Sa Su"; getline; \
if (substr($0,1,2) == " 1")  print "                    1 "; \
do { prevline=$0; if (getline == 0) exit; print " "\
substr(prevline,4,17) " " substr($0,1,2) " "; } while (1) }' | 
sed -E '1,$'"s/ ($(date +%e))( |$)/ $(echo -e '\033[1;47m')\1$(echo -e '\033[0m')\2/"

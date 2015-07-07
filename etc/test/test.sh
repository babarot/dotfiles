#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

for i in $DOTPATH/etc/test/*_test.sh
do
    bash "$i" || err=1
done

for i in $DOTPATH/etc/test/$(get_os)/*_test.sh
do
    [ -f "$i" ] || continue
    bash "$i" || err=1
done

n_unit=$(find $DOTPATH/etc/test -name "*_test.sh" | xargs grep "^unit[0-9]$" | wc -l | sed "s/ //g")
n_file=$(find $DOTPATH/etc/test -name "*_test.sh" | wc -l | sed "s/ //g")

echo "Files=$n_file, Tests=$n_unit"
[ "$err" = 1 ] && exit 1 || exit 0

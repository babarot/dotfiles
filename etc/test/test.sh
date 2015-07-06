#!/bin/bash

. $DOTPATH/etc/lib/vital.sh

for i in $DOTPATH/etc/test/*_test.sh
do
    bash "$i"
done

n_unit=$(find $DOTPATH/etc/test -name "*_test.sh" | xargs grep "^unit[0-9]$" | wc -l | sed "s/ //g")
n_file=$(find $DOTPATH/etc/test -name "*_test.sh" | wc -l | sed "s/ //g")

echo "Files=$n_file, Tests=$n_unit"

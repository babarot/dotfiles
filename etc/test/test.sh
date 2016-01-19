#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

for i in "$DOTPATH"/etc/test/*_test.sh
do
    bash "$i" || ERR=1
done

if [ -n "$(get_os)" ]; then
    for i in "$DOTPATH"/etc/test/"$(get_os)"/*_test.sh
    do
        [ -f "$i" ] || continue
        bash "$i" || ERR=1
    done
fi

n_unit=$(find "$DOTPATH"/etc/test -name "*_test.sh" | xargs grep "^unit[0-9]$" | wc -l | sed "s/ //g")
n_file=$(find "$DOTPATH"/etc/test -name "*_test.sh" | wc -l | sed "s/ //g")

echo "Files=$n_file, Tests=$n_unit"
[ "$ERR" = 1 ] && exit 1 || exit 0

#!/usr/bin/env awk -f
#
# @(#) tac ver.0.1 2014.10.2
#
# Usage:
#   tac.awk file...
#
# Description:
#   tac.awk - tac written in AWK
#   Same as 'tail -r' and 'tac'.
#
######################################################################
# Oneliner: awk '{a[NR]=$0}END{for(i=NR;i>0;i--)print a[i]}'

BEGIN {
    # In order to avoid conflicts,
    # use '\034' as the delimiter
    sort_exe = "sort -t \"\034\" -nr"
}

{
    # Passed to the child process
    printf("%d\034%s\n", NR, $0) |& sort_exe;
}

END {
    # Close the input pipe
    close(sort_exe, "to");

    # Reads the output of the child process
    while ((sort_exe |& getline var) > 0) {
        split(var, arr, /\034/);

        print arr[2];
    }
    close(sort_exe);
}

#!/usr/bin/env gawk -f

@include "./string/prefix.awk"
@include "./path/filepath.awk"

BEGIN {
    if (isabs("/path/to/dir")) {
        print basename("/path/to/dir")
    }
}

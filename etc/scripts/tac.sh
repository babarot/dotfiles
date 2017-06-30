#!/bin/bash

ex -s "$1" <<EOF
g/^/mo0
%p
EOF
